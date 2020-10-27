//
//  BaseViewController.h
//  MFGoShopping
//
//  Created by Mengfei on 16/3/31.
//  Copyright © 2016年 XinMiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "FLAnimatedImage.h"
#import "BRPickerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

// 是否隐藏导航栏白色底色（默认显示白色）
@property (assign, nonatomic) BOOL isHideNavView;
// 是否隐藏导航栏下面的灰色线条（默认显示）
@property (assign, nonatomic) BOOL isHideNavLine;
///侧滑手势是否可用，默认YES
@property (assign, nonatomic) BOOL popGestureRecognizerEnabled;
///导航右按钮
@property (nonatomic, strong) UIButton *rightNaviButton;

/// Grouped TableView
- (BaseTableView *)initializeGroupedTableViewWithProtocol:(nullable id<UITableViewDelegate, UITableViewDataSource>)protocol;
/// Grouped TableView, set frame
- (BaseTableView *)initializeGroupedTableViewWithFrame:(CGRect)frame protocol:(nullable id<UITableViewDelegate, UITableViewDataSource>)protocol;
/// Plain TableView
- (BaseTableView *)initializePlainTableViewWithProtocol:(nullable id<UITableViewDelegate, UITableViewDataSource>)protocol;
/// Plain TableView, set frame
- (BaseTableView *)initializePlainTableViewWithFrame:(CGRect)frame protocol:(nullable id<UITableViewDelegate, UITableViewDataSource>)protocol;

//  是否支持左右滑动
- (void)isPopGesture:(BOOL)enabled;

/// 键盘管理
- (void)setKeyboardManagerEnable:(BOOL)enable;

/// 设置页面横屏，YES-横屏，NO-竖屏
- (void)setLandscapeOrientation:(BOOL)landscape;

/// 隐藏返回按钮
- (void)hidesBackButton;

/// 返回按钮
- (void)initBackNavigationBarButtonItem;

/// 返回按钮方法
- (void)backHandler;

/// 导航栏右按钮-渐变色文案
- (void)initRightNavigationBarButtonItemWithGradientedTitle:(NSString *)title;
/// 导航栏右按钮-普通文案
- (void)initRightNavigationBarButtonItemWithNoramlTitle:(NSString *)title;
/// 导航栏右按钮-图片
- (void)initRightNavigationBarButtonItemWithImage:(NSString *)imageName;
/// 导航栏右按钮点击方法
- (void)rightBarButtonItemHandler;
/// 设置导航栏右按钮可用
- (void)setRightBarButtonEnabled:(BOOL)enable;

/// 文字选择
- (void)showStringPickerWithDataSource:(NSArray<NSString *> *)dataSource
                          defaultValue:(nullable NSString *)defaultSelValue
                           resultBlock:(void(^)(NSString *value))resultBlock;
/// 日前选择-年-月-日
- (void)showDatePickerWithDefaultValue:(nullable NSString *)defaultSelValue
                           resultBlock:(void(^)(NSString *value))resultBlock;
/// 日前选择-指定格式
- (void)showDatePickerWithMode:(BRDatePickerMode)type
                  defaultValue:(NSString *)defaultSelValue
                   resultBlock:(void(^)(NSString *value))resultBlock;

/// 双日期选择
- (void)showDoubleDatePickerWithMode:(BRDatePickerMode)mode
                        defaultValue:(NSString *)defaultSelValue
                         resultBlock:(void(^)(NSString *value))resultBlock;

///底部按钮
- (UIButton *)layoutBottomButtonWithTitle:(NSString *)title;


@end

NS_ASSUME_NONNULL_END
