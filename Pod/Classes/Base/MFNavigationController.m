//
//  MFNavigationController.m
//  MFForum
//
//  Created by Mengfei on 16/3/30.
//  Copyright © 2016年 XinMiao. All rights reserved.
//

#import "MFNavigationController.h"
#import "UIButton+TouchAreaInsets.h"
#import "BaseViewController.h"


@interface MFNavigationController ()<UINavigationControllerDelegate>

@end


@implementation MFNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.modalPresentationStyle = 0;
    self.delegate = self;
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:mFontB(16),NSForegroundColorAttributeName:mRGBbfontcolor}];
    [self.navigationBar setBackgroundImage:[[UIColor clearColor] toImg] forBarMetrics:0];
    self.navigationBar.shadowImage = [[UIColor clearColor] toImg];
}

// 重新设置当前导航控制器的路由数组
- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count)
    {
        // 设置返回按钮
        UIViewController *vc = viewController.lastObject;
        [(BaseViewController *)vc initBackNavigationBarButtonItem];
    }
    [super setViewControllers:viewController animated:animated];
}

// 拦截push进来的控制器
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count)
    {
        // 设置返回按钮
        [(BaseViewController *)viewController initBackNavigationBarButtonItem];
        // 隐藏tab
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - 状态栏设置
- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.visibleViewController;
}

@end
