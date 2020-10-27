//
//  ZHNotificationManager.h
//
//  Created by 李志华 on 17/3/17.
//

#import <Foundation/Foundation.h>

static NSString *PushRegistrationIDNotificationName = @"PushRegistrationIDNotificationName";

@interface ZHNotificationManager : NSObject

/**
 推送单利
 */
+ (instancetype)sharedManager;

/**
 初始化推送SDK

 @param options 启动信息
 */
- (void)startPushSDKWithOptions:(NSDictionary *)options;

/**
 上报注册APNs的设备数据
 */
- (void)registerDeviceToken:(NSData *)deviceToken;

/**
 JPush标识此设备的 registrationID
 */
- (void)registrationIDCompletionHandler:(void(^)(int resCode,NSString *registrationID))completionHandler;

/**
 处理远程通知
*/
- (void)handleNotificationUserinfo:(NSDictionary *)userInfo isForegroundMode:(BOOL)isForeground;

/**
 处理静默通知
*/
- (void)handleSlientRemoteNotification:(NSDictionary *)userInfo;
@end
