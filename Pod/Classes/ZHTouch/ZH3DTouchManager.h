//
//  ZH3DTouchManager.h
//
//
//  Created by 李志华 on 2017/8/28.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZHTouchItem : NSObject
/// @(UIApplicationShortcutIconType)-系统，NSString-自定义图片(镂空图标,2倍图为70*70)
@property (nonatomic, strong) id icon;
/// touch item唯一标识，判断点击的item
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSDictionary *userInfo;
@end

@interface ZH3DTouchManager : NSObject

/**
 默认的touch item
 */
+ (NSArray<ZHTouchItem *> *)defaultTouchItem;

/**
 添加touch item

 @param items item 数组
 */
+ (void)addTouchItems:(NSArray<ZHTouchItem *> *)items;

/**
 处理Item
 @note - (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler
 @param item item
 */
+ (void)handleItem:(UIApplicationShortcutItem *)item;


/**
 注册Pop & Peek
 */
+ (void)registerForPreviewingContext:(UIViewController<UIViewControllerPreviewingDelegate> *)delegate sourceView:(UIView *)sourceView;
@end
