//
//  ZHLocalAuthManager.h
//  
//
//  Created by 李志华 on 2017/8/28.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AuthenticationServices/AuthenticationServices.h>

typedef NS_ENUM(NSUInteger, ZHAuthType) {
    ZHAuthTypeNone = 0,
    ZHAuthTypeTouchID,
    ZHAuthTypeFaceID,
};

@interface ZHLocalAuthManager : NSObject

+ (instancetype)authManager;

/**
 判断Touch ID or Face ID是否可用
 */
+ (ZHAuthType)isAvailableForLocalAuth;

/**
 Touch ID or Face ID
 */
+ (void)authenticateWithReason:(NSString *)reason completion:(void(^)(BOOL success, NSError *error))completion;

/**
 Touch ID or Face ID，自定义取消文案 （iOS 10 以上）
 */
+ (void)authenticateWithReason:(NSString *)reason cancelTitle:(NSString *)cancelTitle completion:(void(^)(BOOL success, NSError *error))completion;

/// Sign In with Apple
/// @param presentationAnchor UI所在窗口
/// @param authorization 识别结果
- (void)performAppleIDLoginRequestsInPresentationAnchor:(ASPresentationAnchor)presentationAnchor authorizationCompleteHandler:(void(^)( ASAuthorizationAppleIDCredential *appleIDCredential, ASPasswordCredential *passwordCredential))authorization API_AVAILABLE(ios(13.0));

/// 保存Apple登录返回的userID到钥匙串
+ (void)saveAppleUserID:(NSString *)userId;

/// 获取Apple登录返回的userID
+ (NSString *)getAppleUserID;
@end
