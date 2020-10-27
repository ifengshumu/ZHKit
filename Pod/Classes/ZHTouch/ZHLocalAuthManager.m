//
//  ZHLocalAuthManager.m
//  
//
//  Created by 李志华 on 2017/8/28.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "ZHLocalAuthManager.h"
#import <SAMKeychain/SAMKeychain.h>
#import <LocalAuthentication/LocalAuthentication.h>

@interface ZHLocalAuthManager ()<ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>
@property (nonatomic, strong) ASPresentationAnchor presentationAnchor;
@property (nonatomic, copy) void(^authorizationCompleteHandler)(ASAuthorizationAppleIDCredential *appleIDCredential, ASPasswordCredential *passwordCredential) API_AVAILABLE(ios(13.0));
@end


static NSString *const AppleIDSignService = @"sign.In.with.Apple";
static NSString *const AppleIDSignAccount = @"apple.userId.chery.new.retail";

static ZHLocalAuthManager *manager = nil;
@implementation ZHLocalAuthManager

+ (instancetype)authManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

+ (ZHAuthType)isAvailableForLocalAuth {
    BOOL version = (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_8_0);
    LAContext *context = [[LAContext alloc] init];
    BOOL evaluate = NO;
    if (@available(iOS 9.0, *)) {
        evaluate = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:nil];
    } else {
        evaluate = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
    }
    if (version && evaluate) {
        if (@available(iOS 11.0, *)) {
            return (ZHAuthType)context.biometryType;
        } else {
            return ZHAuthTypeTouchID;
        }
    }
    return ZHAuthTypeNone;
}

+ (void)authenticateWithReason:(NSString *)reason completion:(void (^)(BOOL, NSError *))completion {
    return [self authenticateWithReason:reason cancelTitle:nil completion:completion];
}

+ (void)authenticateWithReason:(NSString *)reason cancelTitle:(NSString *)cancelTitle completion:(void (^)(BOOL, NSError *))completion {
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0) {
        if (@available(iOS 11.0, *)) {
            NSError *error = [NSError errorWithDomain:@"系统低于iOS 8.0无法使用" code:LAErrorBiometryNotAvailable userInfo:nil];
            completion(NO, error);
        } else {
            NSError *error = [NSError errorWithDomain:@"系统低于iOS 8.0无法使用" code:LAErrorTouchIDNotAvailable userInfo:nil];
            completion(NO, error);
        }
        return;
    }
    
    LAContext *context = [[LAContext alloc] init];
    if (@available(iOS 10.0, *)) {
        context.localizedCancelTitle = cancelTitle;
    } else {
        // Fallback on earlier versions
    }
    NSError *error = nil;
    LAPolicy policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    if (@available(iOS 9.0, *)) {
        policy = LAPolicyDeviceOwnerAuthentication;
    }
    if ([context canEvaluatePolicy:policy error:&error]) {
        [context evaluatePolicy:policy localizedReason:reason reply:^(BOOL success, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    completion(YES, nil);
                } else {
                    //LAError = error.code
                    completion(NO, error);
                }
            });
        }];
    } else {
        completion(NO, error);
    }
}

- (void)performAppleIDLoginRequestsInPresentationAnchor:(ASPresentationAnchor)presentationAnchor
                           authorizationCompleteHandler:(void (^)(ASAuthorizationAppleIDCredential *, ASPasswordCredential *))authorization API_AVAILABLE(ios(13.0)){
    self.presentationAnchor = presentationAnchor;
    self.authorizationCompleteHandler = authorization;
    NSMutableArray *requests = [NSMutableArray arrayWithCapacity:0];
    ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc] init];
    ASAuthorizationAppleIDRequest *appleIDRequest = [provider createRequest];
    appleIDRequest.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
    [requests addObject:appleIDRequest];
    //必须判断钥匙串是否保存了密码凭证，否则无法调起
    NSString *password = [SAMKeychain passwordForService:AppleIDSignService account:AppleIDSignAccount];
    if (password) {
        ASAuthorizationPasswordRequest *passwordRequest = [[[ASAuthorizationPasswordProvider alloc] init] createRequest];
        [requests addObject:passwordRequest];
    }
    ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:requests.copy];
    controller.delegate = self;
    controller.presentationContextProvider = self;
    [controller performRequests];
    [self addObserverForAppleID];
}

- (void)addObserverForAppleID API_AVAILABLE(ios(13.0)){
    [[NSNotificationCenter defaultCenter] addObserverForName:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [SAMKeychain deletePasswordForService:AppleIDSignService account:AppleIDSignAccount];
    }];
}

+ (void)saveAppleUserID:(NSString *)userId {
    [SAMKeychain setPassword:userId forService:AppleIDSignService account:AppleIDSignAccount];
}

+ (NSString *)getAppleUserID {
    NSString *userId = [SAMKeychain passwordForService:AppleIDSignService account:AppleIDSignAccount];
    return userId;
}

#pragma mark - ASAuthorizationControllerDelegate
//授权成功地回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization  API_AVAILABLE(ios(13.0)){
    ASAuthorizationAppleIDCredential *appleIDCredential = nil;
    ASPasswordCredential *passwordCredential = nil;
    if ([authorization.credential isKindOfClass:ASAuthorizationAppleIDCredential.class]) {
        //第一次或重新认证
        appleIDCredential = authorization.credential;
    } else if ([authorization.credential isKindOfClass:ASPasswordCredential.class]) {
        //使用现有的密码凭证
        passwordCredential = authorization.credential;
    } else {
        
    }
    if (self.authorizationCompleteHandler) {
        self.authorizationCompleteHandler(appleIDCredential, passwordCredential);
    }
    
}
//授权失败的回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error  API_AVAILABLE(ios(13.0)){
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
    }
    NSLog(@"Sign in Apple授权失败:%@", errorMsg);
}

#pragma mark - ASAuthorizationControllerPresentationContextProviding
//告诉代理应该在哪个window 展示内容给用户
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller  API_AVAILABLE(ios(13.0)){
    return self.presentationAnchor;
}


@end
