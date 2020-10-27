//
//  BaseViewController.m
//  MFGoShopping
//
//  Created by Mengfei on 16/3/31.
//  Copyright © 2016年 XinMiao. All rights reserved.
//

#import "BaseViewController.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "PickListView.h"

@interface BaseViewController ()
@property (strong, nonatomic) UIView *navView;
@property (strong, nonatomic) CALayer *navLine;

@end


@implementation BaseViewController

-(void)dealloc
{
    mRemoveAllNot(self)
    NSLog(@"dealloc--%@",NSStringFromClass([self class]));
    [self.view removeFromSuperview];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self colorView];
    self.view.backgroundColor = UIColor.whiteColor;
//    self.automaticallyAdjustsScrollViewInsets = NO;
}

// 上面自定义导航的颜色和下面的分割线（有颜色）
- (void)colorView
{
    if (!_navView)
    {
        _navView = [UIView new];
        _navView.frame = CGRectMake(0, 0, mScreenWidth, mNavHeight);
        _navView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_navView];
        _navLine = [CALayer new];
        _navLine.frame = CGRectMake(0, mNavHeight-1/mScale, mScreenWidth, 1/mScale);
        _navLine.backgroundColor = mRGBlinecolor.CGColor;
        [_navView.layer addSublayer:_navLine];
    }
    [self.view bringSubviewToFront:_navView];
}

- (void)setIsHideNavView:(BOOL)isHideNavView
{
    _navView.hidden = isHideNavView;
}

- (void)setIsHideNavLine:(BOOL)isHideNavLine
{
    _navLine.hidden = isHideNavLine;
}

- (void)setPopGestureRecognizerEnabled:(BOOL)popGestureRecognizerEnabled {
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = popGestureRecognizerEnabled;
    }
}

#pragma mark - 状态栏设置
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - 屏幕旋转
- (void)setLandscapeOrientation:(BOOL)landscape {
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowLandscape = landscape;

    NSNumber *origin = @(UIDeviceOrientationUnknown);
    [[UIDevice currentDevice] setValue:origin forKey:@"orientation"];
    NSNumber *target = landscape ? @(UIDeviceOrientationLandscapeLeft) : @(UIDeviceOrientationPortrait);
    [[UIDevice currentDevice] setValue:target forKey:@"orientation"];
    [UIViewController attemptRotationToDeviceOrientation];
}

//  是否支持左右滑动
- (void)isPopGesture:(BOOL)enabled {
    self.navigationController.interactivePopGestureRecognizer.enabled = enabled;
}

- (void)setKeyboardManagerEnable:(BOOL)enable {
    [IQKeyboardManager sharedManager].enableAutoToolbar = enable;
}



#pragma mark - 初始化UITableView
- (BaseTableView *)initializeGroupedTableViewWithProtocol:(id<UITableViewDelegate, UITableViewDataSource>)protocol {
    return [self initializeTableViewWithFrame:mSuitableFrame style:UITableViewStyleGrouped protocol:protocol];
}
- (BaseTableView *)initializePlainTableViewWithProtocol:(id<UITableViewDelegate, UITableViewDataSource>)protocol {
    return [self initializeTableViewWithFrame:mSuitableFrame style:UITableViewStylePlain protocol:protocol];
}
- (BaseTableView *)initializeGroupedTableViewWithFrame:(CGRect)frame protocol:(id<UITableViewDelegate, UITableViewDataSource>)protocol {
    return [self initializeTableViewWithFrame:frame style:UITableViewStyleGrouped protocol:protocol];
}
- (BaseTableView *)initializePlainTableViewWithFrame:(CGRect)frame protocol:(id<UITableViewDelegate, UITableViewDataSource>)protocol {
    return [self initializeTableViewWithFrame:frame style:UITableViewStylePlain protocol:protocol];
}
- (BaseTableView *)initializeTableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style protocol:(id<UITableViewDelegate, UITableViewDataSource>)protocol {
    BaseTableView *tableView = [[BaseTableView alloc] initWithFrame:frame style:style];
    if (protocol) {
        tableView.delegate = protocol;
        tableView.dataSource = protocol;
    }
    [self.view addSubview:tableView];
    return tableView;
}

// UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - 导航栏
- (void)hidesBackButton {
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.hidesBackButton = YES;
}

- (void)initBackNavigationBarButtonItem {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button addTarget:self action:@selector(backHandler) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    space.width = mFsystemVersion >= 11.0 ? 0 : -10;
    if (mFsystemVersion >= 11.0) {
        button.touchAreaInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    }
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItems = @[space, backItem];
}

- (void)backHandler {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initRightNavigationBarButtonItemWithNoramlTitle:(NSString *)title {
    [self initRightNavigationBarButtonItemWithTitle:title gradientColor:NO];
}
- (void)initRightNavigationBarButtonItemWithGradientedTitle:(NSString *)title {
    [self initRightNavigationBarButtonItemWithTitle:title gradientColor:YES];
}
- (void)initRightNavigationBarButtonItemWithTitle:(NSString *)title gradientColor:(BOOL)gradientColor {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 28) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:mFont(12)} context:nil].size;
    button.frame = CGRectMake(0, 0, size.width + 48, 28);
    button.titleLabel.font = mFont(12);
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonItemHandler) forControlEvents:UIControlEventTouchUpInside];
    if (gradientColor) {
        button.layer.cornerRadius = 14;
        button.layer.masksToBounds = YES;
        button.backgroundColor = [UIColor gradientColor:button.frame.size];
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    } else {
        [button setTitleColor:UIColor.deepBlueColor forState:UIControlStateNormal];
    }
    if (mFsystemVersion >= 11.0) {
        button.touchAreaInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    }
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    space.width = mFsystemVersion >= 11.0 ? 0 : -10;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[rightItem,space];
    self.rightNaviButton = button;
}


- (void)initRightNavigationBarButtonItemWithImage:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 28, 28);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonItemHandler) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    space.width = mFsystemVersion >= 11.0 ? 0 : -10;
    if (mFsystemVersion >= 11.0) {
        button.touchAreaInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    }
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[rightItem,space];
}

- (void)rightBarButtonItemHandler {
    
}

- (void)setRightBarButtonEnabled:(BOOL)enable {
    self.rightNaviButton.enabled = enable;
    self.rightNaviButton.backgroundColor = enable ? [UIColor gradientColor:self.rightNaviButton.size] : UIColor.regularGrayColor;
}

#pragma mark - 公共方法
- (void)showStringPickerWithDataSource:(NSArray<NSString *> *)dataSource
                          defaultValue:(NSString *)defaultSelValue
                           resultBlock:(void(^)(NSString *value))resultBlock {
    PickListView *list = [[PickListView alloc] initWithList:dataSource defaultValue:defaultSelValue];
    list.doneResult = ^(NSString * _Nonnull text, NSInteger index) {
        if (resultBlock) {
            resultBlock(text);
        }
    };
    [list show];
}
- (void)showDatePickerWithDefaultValue:(NSString *)defaultSelValue
                           resultBlock:(void(^)(NSString *value))resultBlock {
    [self showDatePickerWithMode:BRDatePickerModeYMD defaultValue:defaultSelValue resultBlock:resultBlock];
}
- (void)showDatePickerWithMode:(BRDatePickerMode)mode
                  defaultValue:(NSString *)defaultSelValue
                   resultBlock:(void(^)(NSString *value))resultBlock {
    BRDatePickerView *picker = [[BRDatePickerView alloc] initWithPickerMode:mode];
    picker.title = @"请选择";
    picker.pickerStyle = [self pickerStyle];
    picker.selectValue = defaultSelValue;
    picker.minDate = [NSDate br_setYear:2015 month:1 day:1];
    picker.resultBlock = ^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
        if (resultBlock) {
            resultBlock(selectValue);
        }
    };
    [picker show];
}

- (void)showDoubleDatePickerWithMode:(BRDatePickerMode)mode
                        defaultValue:(NSString *)defaultSelValue
                         resultBlock:(void(^)(NSString *value))resultBlock {
    __block NSString *fromResult = nil;
    __block NSString *toResult = nil;
    NSArray *value = [defaultSelValue componentsSeparatedByString:@"-"];
    if (value.count != 2) {
        value = @[@"",@""];
    }
    
    BRDatePickerView *fromPicker = [[BRDatePickerView alloc] initWithPickerMode:mode];
    fromPicker.pickerStyle = [self pickerStyle];
    fromPicker.selectValue = value[0];
    fromPicker.isAutoSelect = YES;
    fromPicker.resultBlock = ^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
        fromResult = selectValue;
    };
    BRDatePickerView *toPicker = [[BRDatePickerView alloc] initWithPickerMode:mode];
    toPicker.pickerStyle = [self pickerStyle];
    toPicker.selectValue = value[1];
    toPicker.isAutoSelect = YES;
    toPicker.resultBlock = ^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
        toResult = selectValue;
    };
    
    BRBaseView *base = [[BRBaseView alloc] initWithFrame:mScreenBounds];
    base.title = @"请选择";
    base.pickerStyle = [self pickerStyle];
    @weakify(base);
    base.doneBlock = ^{
        @strongify(base);
        if (resultBlock) {
            if (!fromResult) {
                fromResult = [NSDate br_getDateString:[NSDate date] format:fromPicker.pickerModeFormat];
            }
            if (!toResult) {
                toResult = [NSDate br_getDateString:[NSDate date] format:toPicker.pickerModeFormat];
            }
            NSString *result = [NSString stringWithFormat:@"%@-%@", fromResult, toResult];
            resultBlock(result);
            //关闭动画
            [UIView animateWithDuration:0.2 animations:^{
                CGFloat alertViewHeight = base.alertView.bounds.size.height;
                CGRect rect = base.alertView.frame;
                rect.origin.y += alertViewHeight;
                base.alertView.frame = rect;
                if (!self.pickerStyle.hiddenMaskView) {
                    base.maskView.alpha = 0;
                }
            } completion:^(BOOL finished) {
                [base removeFromSuperview];
            }];
        }
    };
    
    CGFloat width = (CGRectGetWidth(base.alertView.frame) - 10) / 2.0;
    CGFloat height = CGRectGetHeight(base.alertView.frame);
    UIView *from = [[UIView alloc] initWithFrame:CGRectMake(0, 44, width, height)];
    [fromPicker addPickerToView:from];
    UIView *to = [[UIView alloc] initWithFrame:CGRectMake(width + 5, 44, width, height)];
    [toPicker addPickerToView:to];
    
    [base.alertView addSubview:from];
    [base.alertView addSubview:to];
    [base initUI];
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:base];
    // 动画前初始位置
    CGRect rect = base.alertView.frame;
    rect.origin.y = mScreenHeight;
    base.alertView.frame = rect;
    // 弹出动画
    base.maskView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        base.maskView.alpha = 1;
        CGFloat alertViewHeight = base.alertView.bounds.size.height;
        CGRect rect = base.alertView.frame;
        rect.origin.y -= alertViewHeight;
        base.alertView.frame = rect;
    }];
}
- (BRPickerStyle *)pickerStyle {
    BRPickerStyle *style = [[BRPickerStyle alloc] init];
    
    style.topCornerRadius = 8;
    style.titleBarHeight = 44.f;
    
    style.titleLineColor = UIColor.lineColor;
    style.titleTextColor = UIColor.deepBlackColor;
    style.titleTextFont = mFontM(14);
    
    style.cancelTextColor = UIColor.regularGrayColor;
    style.cancelTextFont = mFont(14);
    
    style.doneTextColor = UIColor.deepBlueColor;
    style.doneTextFont = mFont(14);
    
    style.separatorColor = UIColor.lineColor;
    style.pickerTextColor = UIColor.deepBlackColor;
    style.pickerTextFont = mFont(16);
    style.selectRowTextColor = UIColor.deepBlueColor;
    style.selectRowTextFont = mFont(16);
    style.rowHeight = 50;
    
    return style;
}

#pragma mark - 底部按钮
- (UIButton *)layoutBottomButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 25;
    button.layer.masksToBounds = YES;
    button.titleLabel.font = mFont(18);
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

@end
