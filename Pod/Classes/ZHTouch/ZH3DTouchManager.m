//
//  ZH3DTouchManager.m
//
//
//  Created by 李志华 on 2017/8/28.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "ZH3DTouchManager.h"
#import <Social/Social.h>

@implementation ZHTouchItem

@end


static ZH3DTouchManager *manager = nil;
@implementation ZH3DTouchManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

#pragma mark - ShortcutItem
+ (NSArray<ZHTouchItem *> *)defaultTouchItem {
    NSArray *titles = @[@"",@""];
    NSArray *icons = @[@"",@""];
    NSArray *types = @[@"",@""];
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:0];
    [titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZHTouchItem *item = [[ZHTouchItem alloc] init];
        item.title = obj;
        item.icon = icons[idx];
        item.type = types[idx];
        [items addObject:item];
    }];
    return items.copy;
}

+ (void)addTouchItems:(NSArray<ZHTouchItem *> *)items {
    //UIApplicationShortcutItem标签最多4个，从下往上排列。
    NSMutableArray *touchItems = [NSMutableArray arrayWithCapacity:0];
    [items enumerateObjectsUsingBlock:^(ZHTouchItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIApplicationShortcutIcon *icon = nil;
        if ([obj.icon isKindOfClass:[NSNumber class]]) {
            icon = [UIApplicationShortcutIcon iconWithType:[obj.icon integerValue]];
        } else {
            icon = [UIApplicationShortcutIcon iconWithTemplateImageName:obj.icon];
        }
        UIApplicationShortcutItem *item = [[UIApplicationShortcutItem alloc] initWithType:obj.type localizedTitle:obj.title localizedSubtitle:obj.subtitle icon:icon userInfo:obj.userInfo];
        [touchItems addObject:item];
    }];
    //将标签添加到UIApplication的shortcutItems中
    [UIApplication sharedApplication].shortcutItems = touchItems;
    //touchItems.reverseObjectEnumerator.allObjects;
}

+ (void)handleItem:(UIApplicationShortcutItem *)item {
    if ([AppService isLogin]) {
        UIViewController *vc = [[NSClassFromString(item.type) alloc] init];
        //[AppService.navigationController pushViewController:vc animated:YES];
    } else {
        //先登录，再跳转
        
    }
}

#pragma mark - Peek & Pop
+ (void)registerForPreviewingContext:(UIViewController<UIViewControllerPreviewingDelegate> *)delegate sourceView:(UIView *)sourceView {
    if (delegate.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [delegate registerForPreviewingWithDelegate:delegate sourceView:sourceView];
    }
}

@end
