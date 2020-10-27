//
//  ZHShareManager.h
//  ZHShareManager
//
//  Created by 李志华 on 2018/11/5.
//  Copyright © 2018 CoderApple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHShareEnum.h"

@class ZHShareMenu;
@class ZHShareObject;
@interface ZHShareManager : NSObject

/**
*  是否过滤不存在的平台，默认YES；一般调试阶段设为NO。
*/
@property (nonatomic, assign, getter=isFilterNotExistPlatform) BOOL filterNotExistPlatform;

+ (instancetype)sharedManager;

/**
 *  设置社会化分享appkey，eg:友盟分享的appkey
 */
+ (void)setSocialShareAppkey:(NSString *)appkey;

/**
 平台是否安装
 */
+ (BOOL)isInstallPlatform:(SharePlatformType)platform;
/**
 *  平台是否支持分享
 */
+ (BOOL)isSupportPlatform:(SharePlatformType)platform;

/**
 设置分享平台的appkey
 */
+ (BOOL)setPlaform:(SharePlatformType)platform
            appKey:(NSString *)appKey
         appSecret:(NSString *)appSecret
       redirectURL:(NSString *)redirectURL;

/**
 分享回调，iOS 9.0开始使用
 @note - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;
 */
+ (BOOL)handleOpenURL:(NSURL *)url options:(NSDictionary*)options;

/**
 调用默认分享页面

 @param menus 分享菜单
 @param didSelectPlatform 选择分享平台回调
 @param completion 分享完成回调
 */
- (void)showDefaultShareMenus:(NSArray<ZHShareMenu *> *)menus selectPlatform:(void(^)(SharePlatformType platformType, NSDictionary *userInfo))didSelectPlatform completion:(void(^)(id result, NSError *error))completion;

/**
 调用定制分享页面
 
 @param menus 分享菜单
 @param didSelectPlatform 选择分享平台回调
 @param completion 分享完成回调
 */
- (void)showActionSheetShareMenus:(NSArray<ZHShareMenu *> *)menus selectPlatform:(void(^)(SharePlatformType platformType, NSDictionary *userInfo))didSelectPlatform completion:(void(^)(id result, NSError *error))completion;

/**
 调用定制分享页面（锚点视图）

 @param menus 分享菜单
 @param anchorView 锚点视图
 @param didSelectPlatform 选择分享平台回调
 @param completion 分享完成回调
 */
- (void)showAnchorShareMenus:(NSArray<ZHShareMenu *> *)menus anchorView:(UIView *)anchorView selectPlatform:(void(^)(SharePlatformType platformType, NSDictionary *userInfo))didSelectPlatform completion:(void(^)(id result, NSError *error))completion;
/**
 调用定制分享页面（锚点）
 
 @param menus 分享菜单
 @param anchor 锚点
 @param didSelectPlatform 选择分享平台回调
 @param completion 分享完成回调
 */
- (void)showAnchorShareMenu:(NSArray<ZHShareMenu *> *)menus anchor:(CGPoint)anchor onSelectPlatform:(void(^)(SharePlatformType platformType, NSDictionary *userInfo))didSelectPlatform completion:(void(^)(id result, NSError *error))completion;

/**
 分享

 @param object 分享内容对象
 @param completion 分享完成回调
 */
- (void)shareObject:(ZHShareObject *)object completion:(void(^)(id result, NSError *error))completion;

@end
