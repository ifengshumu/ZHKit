//
//  MFTabBarController.m
//  物流
//
//  Created by Mengfei on 15/9/14.
//  Copyright (c) 2015年 KuErGuangGao. All rights reserved.
//

#import "MFTabBarController.h"
#import "MFNavigationController.h"
#import "StartGuideViewController.h"
#import "CameraViewController.h"

@interface MFTabBarController ()<UITabBarControllerDelegate>
@property (nonatomic, strong) NSMutableArray *unSelImgArr;
@property (nonatomic, strong) NSMutableArray *selImgArr;
@property (nonatomic, strong) NSMutableArray *titleArr;
@end


@implementation MFTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _selImgArr = @[@"tab_news_select", @"tab_work_select", @"tab_project_select", @"tab_mine_select"].mutableCopy;
    _unSelImgArr = @[@"tab_news_unselect", @"tab_work_unselect", @"tab_project_unselect", @"tab_mine_unselect"].mutableCopy;
    _titleArr = @[@"消息", @"工作台", @"项目看板", @"我的"].mutableCopy;
    //超级管理员
    if ([AppService isAdmin]) {
        [_selImgArr insertObject:@"tab_add" atIndex:2];
        [_unSelImgArr insertObject:@"tab_add" atIndex:2];
        [_titleArr insertObject:@"" atIndex:2];
    }
    self.delegate = self;
    self.tabBar.tintColor = UIColor.deepBlueColor;
    [self addChildViewController];
    [AppService defaultService].tabBarController = self;
}

- (void)showStartGuide {
    if ([StartGuideViewController needShowGuideView] && [AppService isAdmin]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [StartGuideViewController showsInViewController:self];
        });
    }
}

- (void)addChildViewController {
    NSMutableArray *classNames = @[@"NewsListController",@"WorktableController",@"ProjectBoardController",@"MineInfoController"].mutableCopy;
    if ([AppService isAdmin]) {
        [classNames insertObject:@"UIViewController" atIndex:2];
    }
    
    for (int i = 0; i < classNames.count; i++) {
        Class className = NSClassFromString(classNames[i]);
        UIViewController *vc = [[className alloc] init];
        if ([AppService isAdmin] && i == 2) {
            vc.tabBarItem.imageInsets = UIEdgeInsetsMake(2, 0, -2, 0);
        } else {
            vc.tabBarItem.imageInsets = UIEdgeInsetsMake(-3, 0, 3, 0);
        }
        vc.tabBarItem.image = [[UIImage imageNamed:_unSelImgArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.selectedImage =  [[UIImage imageNamed:_selImgArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.title = _titleArr[i];
        vc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3);
        [vc.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:UIColor.deepBlueColor} forState:UIControlStateSelected];
        [vc.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:UIColor.regularGrayColor} forState:UIControlStateNormal];
        
        vc.title = _titleArr[i];
        MFNavigationController *nav = [[MFNavigationController alloc]initWithRootViewController:vc];
        [self addChildViewController:nav];
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([AppService isAdmin] && tabBarController.selectedIndex == 2) {
        if ([AppService getUserInfo].project_name.length) {
            CameraViewController *vc = [[CameraViewController alloc] init];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:nil];
        } else {
            tabBarController.selectedIndex = [AppService defaultService].pageIndex;
            [self showFailureToast:@"暂无门店，无法新建工单"];
        }
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    [AppService defaultService].pageIndex = tabBarController.selectedIndex;
    return YES;
}

#pragma mark - 状态栏设置
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.selectedViewController;
}

@end
