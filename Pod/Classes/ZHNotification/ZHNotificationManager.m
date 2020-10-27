//
//  ZHNotificationManager.m
//
//  Created by 李志华 on 17/3/17.
//

#import "ZHNotificationManager.h"
#import <JPush/JPUSHService.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

#ifdef DEBUG
static BOOL isProduction = NO;
#else
static BOOL isProduction = YES;
#endif

static NSString *appKey = @"7175ab84fa8cfb4e1a2647ba";
static NSString *channel = @"App Store";

@interface ZHNotificationManager()<JPUSHRegisterDelegate>
@property (nonatomic, copy) NSDictionary *launchNotificationUserInfo;
@property (nonatomic, copy) NSDictionary *remoteNotificationUserInfo;
@property (nonatomic, copy) NSDictionary *JPushMessageUserInfo;
@end

@implementation ZHNotificationManager

static ZHNotificationManager *manager = nil;
+ (instancetype)sharedManager {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //注册APNs
        JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = JPAuthorizationOptionAlert | JPAuthorizationOptionBadge | JPAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
        //添加通知
        [self addApplicationObserver];
    }
    return self;
}

- (void)addApplicationObserver {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        //处理APP被远程推送唤醒的消息
        if (self.remoteNotificationUserInfo) {
            [self handleNotificationUserinfo:self.remoteNotificationUserInfo isForegroundMode:NO];
        } else {
            //处理启动时带有的推送
            [self handleNotificationUserinfo:self.launchNotificationUserInfo isForegroundMode:YES];
        }
        //处理极光极光自定义消息
        if (self.JPushMessageUserInfo) {
            [self handleJPushMessage:self.JPushMessageUserInfo isForegroundMode:UIApplication.sharedApplication.applicationState == UIApplicationStateActive];
        }
    }];
    [notificationCenter addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSDictionary *launchOptions = note.userInfo;
        NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo) {
            self.launchNotificationUserInfo = userInfo;
        }
    }];
    
    //个人资料获取成功通知
    [notificationCenter addObserverForName:PPLoginSuccessNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSString *userid = [AppService uid];
        NSString *alias = [NSString stringWithFormat:@"%@%@", @"env", userid];
        [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            if (iResCode == 0) {
                NSLog(@"极光推送设置别名成功：%@", iAlias);
            } else {
                NSLog(@"极光推送设置别名失败：%ld", (long)iResCode);
            }
        } seq:1];
    }];
    //登出通知
    [notificationCenter addObserverForName:PPLogoutSuccessNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            if (iResCode == 0) {
                NSLog(@"极光推送删除别名成功：%@", iAlias);
            } else {
                NSLog(@"极光推送删除别名失败：%ld", (long)iResCode);
            }
        } seq:1];
    }];
    //获取极光registrationID
    [notificationCenter addObserverForName:kJPFNetworkDidLoginNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSString *registrationID = [JPUSHService registrationID];
        [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"JPUSH_RegistrationID"];
    }];
    //极光自定义消息，在前台显示
    [notificationCenter addObserverForName:kJPFNetworkDidReceiveMessageNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSDictionary *userInfo = note.userInfo;
        [self handleJPushMessage:userInfo isForegroundMode:UIApplication.sharedApplication.applicationState == UIApplicationStateActive];
    }];
}

- (void)startPushSDKWithOptions:(NSDictionary *)options {
    [JPUSHService setupWithOption:options appKey:appKey channel:channel apsForProduction:isProduction];
}

- (void)registerDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)registrationIDCompletionHandler:(void (^)(int, NSString *))completionHandler {
    [JPUSHService registrationIDCompletionHandler:completionHandler];
}

//处理静默推送
- (void)handleSlientRemoteNotification:(NSDictionary *)userInfo {
    
}
//处理极光自定义消息
- (void)handleJPushMessage:(NSDictionary *)userInfo isForegroundMode:(BOOL)isForeground {
    NSDictionary *extras = userInfo[@"extras"];
    NSString *title = userInfo[@"title"]; //标题
    NSString *message = userInfo[@"content"]; //消息
    if (isForeground) {
        [ZHAlertView showAlertWithTitle:title message:message confirmTitle:@"确定" cancelTitle:@"取消" confirmHandler:^{
            //TODO:跳转
            [AppService handleOpenPage:@"" params:@{}];
        } cancelHandler:nil];
    } else {
        JPushNotificationContent *content = [[JPushNotificationContent alloc] init];
        content.title = title;
        content.body = message;
        content.badge = @(-1);
        content.userInfo = userInfo;
        JPushNotificationTrigger *trigger = [[JPushNotificationTrigger alloc] init];
        if (@available(iOS 10.0, *)) {
            trigger.timeInterval = 2;
        } else {
            trigger.fireDate = [NSDate dateWithTimeIntervalSinceNow:2];
        }
        JPushNotificationRequest *notify = [[JPushNotificationRequest alloc] init];
        notify.requestIdentifier = [userInfo[@"_j_msgid"] stringValue];
        notify.content = content;
        notify.trigger = trigger;
        [JPUSHService addNotification:notify];
    }
}
//处理推送消息
- (void)handleNotificationUserinfo:(NSDictionary *)userInfo isForegroundMode:(BOOL)isForeground {
    //处理角标（由于无法监听到用户清除通知，角标直接清零）
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [JPUSHService resetBadge];
    if (!userInfo.count) return;
    //向极光上报APNs
    [JPUSHService handleRemoteNotification:userInfo];
    //处理推送内容
    NSDictionary *aps = userInfo[@"aps"];
    NSDictionary *alert = aps[@"alert"];
    if (isForeground) {
        [ZHAlertView showAlertWithTitle:alert[@"title"] message:alert[@"body"] confirmTitle:@"确定" cancelTitle:@"取消" confirmHandler:^{
            //TODO:目前跳转消息页面
            [AppService handleOpenPage:@"" params:@{}];
        } cancelHandler:nil];
    } else {
        //TODO:跳转
        [AppService handleOpenPage:@"" params:@{}];
    }
    userInfo = nil;
}

#pragma mark - JPUSHRegisterDelegate
//应用在前台时，接收消息并设置如何展示通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    if ([notification.request.trigger isKindOfClass:UNPushNotificationTrigger.class]) {
        NSDictionary *userInfo = notification.request.content.userInfo;
        [self handleNotificationUserinfo:userInfo isForegroundMode:YES];
        completionHandler(UNNotificationPresentationOptionSound);
    }
}
//用户点击通知后调用，直接点击App图标进入App不会调用
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if ([response.notification.request.trigger isKindOfClass:UNPushNotificationTrigger.class]) {
        self.remoteNotificationUserInfo = userInfo;
    } else {
        self.JPushMessageUserInfo = userInfo;
    }
    completionHandler();
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification API_AVAILABLE(ios(10.0)){
    
}

@end
