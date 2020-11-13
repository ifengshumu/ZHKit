//
//  ZHAlert.m
//
//  Created by 李志华 on 2019/7/2.
//

#import "ZHAlertView.h"
#import "SCLAlertView.h"
#import "MBProgressHUD.h"

static NSInteger const LoadingViewTag       = 1235911;
static NSInteger const ToastViewTag         = 246810;

@implementation ZHAlertView

#pragma mark - 弹框
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle cancelTitle:(NSString *)cancelTitle confirmHandler:(void(^)(void))confirmHandler cancelHandler:(void(^)(void))cancelHandler {
    SCLAlertView *alert = [self creatAlertWithConfirmTitle:confirmTitle cancelTitle:cancelTitle confirmHandler:confirmHandler cancelHandler:cancelHandler];
    alert.viewText.textAlignment = [self textAlignmentOfMessage:message];
    if ([self textAlignmentOfMessage:message] == NSTextAlignmentLeft) {
        alert.attributedFormatBlock = ^NSAttributedString *(NSString *value) {
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.lineSpacing = 5;
            NSAttributedString *attr = [[NSAttributedString alloc] initWithString:value attributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:UIColorFromHEX(0x666666)}];
            return attr;
        };
    }
    [alert removeTopCircle];
    [alert showSuccess:[self currentViewController] title:title subTitle:message closeButtonTitle:nil duration:0];
}
+ (void)showAlertWithTitle:(NSString *)title confirmTitle:(NSString *)confirmTitle cancelTitle:(NSString *)cancelTitle confirmHandler:(void(^)(void))confirmHandler cancelHandler:(void(^)(void))cancelHandler {
    SCLAlertView *alert = [self creatAlertWithConfirmTitle:confirmTitle cancelTitle:cancelTitle confirmHandler:confirmHandler cancelHandler:cancelHandler];
    alert.labelTitle.font = [UIFont systemFontOfSize:16];
    [alert removeTopCircle];
    [alert showSuccess:[self currentViewController] title:title subTitle:nil closeButtonTitle:nil duration:0];
}
+ (void)showAlertWithMessage:(NSString *)message confirmTitle:(NSString *)confirmTitle cancelTitle:(NSString *)cancelTitle confirmHandler:(void(^)(void))confirmHandler cancelHandler:(void(^)(void))cancelHandler {
    [self showAlertWithTitle:nil message:message confirmTitle:confirmTitle cancelTitle:cancelTitle confirmHandler:confirmHandler cancelHandler:cancelHandler];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message handlerTitle:(NSString *)handlerTitle  handler:(void(^)(void))handler {
    [self showAlertWithTitle:title message:message confirmTitle:handlerTitle cancelTitle:nil confirmHandler:handler cancelHandler:nil];
}
+ (void)showAlertWithTitle:(NSString *)title handlerTitle:(NSString *)handlerTitle  handler:(void(^)(void))handler {
    SCLAlertView *alert = [self creatAlertWithConfirmTitle:handlerTitle cancelTitle:nil confirmHandler:handler cancelHandler:nil];
    alert.labelTitle.font = [UIFont systemFontOfSize:16];
    [alert removeTopCircle];
    [alert showSuccess:[self currentViewController] title:title subTitle:nil closeButtonTitle:nil duration:0];
}
+ (void)showAlertWithMessage:(NSString *)message handlerTitle:(NSString *)handlerTitle handler:(void(^)(void))handler {
    [self showAlertWithTitle:nil message:message handlerTitle:handlerTitle handler:handler];
}

+ (void)showAlertWithIcon:(NSString *)icon title:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle cancelTitle:(NSString *)cancelTitle confirmHandler:(void(^)(void))confirmHandler cancelHandler:(void(^)(void))cancelHandler {
    SCLAlertView *alert = [self creatIconAlertWithConfirmTitle:confirmTitle cancelTitle:cancelTitle confirmHandler:confirmHandler cancelHandler:cancelHandler];
    [alert showCustom:[self currentViewController] image:[UIImage imageNamed:icon] color:nil title:title subTitle:message closeButtonTitle:nil duration:0];
}

+ (void)showInputAlertWithTitle:(NSString *)title placeholder:(NSString *)placeholder confirmTitle:(NSString *)confirmTitle cancelTitle:(NSString *)cancelTitle confirmHandler:(void(^)(NSString *text))confirmHandler cancelHandler:(void(^)(void))cancelHandler {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindowWidth:mScreenWidth-W(50)*2];
    alert.horizontalButtons = YES;
    alert.horizontalButtonEqualWidth = YES;
    alert.labelTitle.textColor = UIColorFromHEX(0x333333);
    alert.labelTitle.font = [UIFont systemFontOfSize:16];
    alert.showAnimationType = SCLAlertViewShowAnimationSlideInToCenter;
    alert.hideAnimationType = SCLAlertViewHideAnimationSlideOutToCenter;
    SCLTextView *tv = [alert addTextField:placeholder];
    [alert alertShowAnimationIsCompleted:^{
        CGRect rect = alert.view.frame;
        rect.size.height = mScreenHeight;
        alert.view.frame = rect;
    }];
    if (cancelTitle.length) {
        SCLButton *cancle = [alert addButton:cancelTitle actionBlock:cancelHandler];
        cancle.buttonFormatBlock = ^NSDictionary *{
            return @{@"backgroundColor": UIColor.whiteColor,
                     @"textColor": UIColorFromHEX(0x909399),
                     @"font": [UIFont systemFontOfSize:16]
                     };
        };
    }
    SCLButton *confirm = [alert addButton:confirmTitle actionBlock:^{
        if (confirmHandler) {
            confirmHandler(tv.text);
        }
    }];
    confirm.buttonFormatBlock = ^NSDictionary *{
        return @{@"backgroundColor": UIColor.whiteColor,
                 @"textColor": UIColorFromHEX(0x7657A4),
                 @"font": [UIFont systemFontOfSize:16]
                 };
    };
    [alert removeTopCircle];
    [alert showCustom:[self currentViewController] image:nil color:UIColorFromHEX(0x909399) title:title subTitle:nil closeButtonTitle:nil duration:0];
}


#pragma mark - 弹框私有方法
+ (NSTextAlignment)textAlignmentOfMessage:(NSString *)message {
    CGFloat height = [message boundingRectWithSize:CGSizeMake(mScreenWidth-W(50)*2-42, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height;
    if (height > 30) { //多余一行
        return NSTextAlignmentLeft;
    } else {
        return NSTextAlignmentCenter;
    }
}
+ (SCLAlertView *)creatAlertWithConfirmTitle:(NSString *)confirmTitle cancelTitle:(NSString *)cancelTitle confirmHandler:(void(^)(void))confirmHandler cancelHandler:(void(^)(void))cancelHandler {
    [self hideToastOrLoading];
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindowWidth:mScreenWidth-W(50)*2];
    aler.cornerRadius = 18;
    alert.horizontalButtons = YES;
    alert.horizontalButtonEqualWidth = YES;
    alert.labelTitle.textColor = UIColorFromHEX(0x333333);
    alert.labelTitle.font = [UIFont systemFontOfSize:18];
    alert.viewText.textColor = UIColorFromHEX(0x666666);
    alert.viewText.font = [UIFont systemFontOfSize:16];
    alert.showAnimationType = SCLAlertViewShowAnimationSlideInToCenter;
    alert.hideAnimationType = SCLAlertViewHideAnimationSlideOutToCenter;
    [alert alertShowAnimationIsCompleted:^{
        CGRect rect = alert.view.frame;
        rect.size.height = mScreenHeight;
        alert.view.frame = rect;
    }];
    if (cancelTitle.length) {
        SCLButton *cancle = [alert addButton:cancelTitle actionBlock:cancelHandler];
        cancle.buttonFormatBlock = ^NSDictionary *{
            return @{@"backgroundColor": UIColor.whiteColor,
                     @"textColor": UIColorFromHEX(0x909399),
                     @"font": [UIFont systemFontOfSize:16]
                     };
        };
    }
    SCLButton *confirm = [alert addButton:confirmTitle actionBlock:confirmHandler];
    confirm.buttonFormatBlock = ^NSDictionary *{
        return @{@"backgroundColor": UIColor.whiteColor,
                 @"textColor": UIColorFromHEX(0x7657A4),
                 @"font": [UIFont systemFontOfSize:16]
                 };
    };
    return alert;
}

+ (SCLAlertView *)creatIconAlertWithConfirmTitle:(NSString *)confirmTitle cancelTitle:(NSString *)cancelTitle confirmHandler:(void(^)(void))confirmHandler cancelHandler:(void(^)(void))cancelHandler {
    [self hideToastOrLoading];
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindowWidth:mScreenWidth-W(50)*2];
    alert.horizontalButtons = YES;
    alert.labelTitle.textColor = UIColorFromHEX(0x333333);
    alert.labelTitle.font = [UIFont systemFontOfSize:18];
    alert.viewText.textColor = UIColorFromHEX(0x666666);
    alert.viewText.font = [UIFont systemFontOfSize:16];
    alert.showAnimationType = SCLAlertViewShowAnimationSlideInToCenter;
    alert.hideAnimationType = SCLAlertViewHideAnimationSlideOutToCenter;
    if (cancelTitle.length) {
        SCLButton *cancle = [alert addButton:cancelTitle actionBlock:cancelHandler];
        cancle.buttonFormatBlock = ^NSDictionary *{
            return @{@"backgroundColor": UIColor.whiteColor,
                     @"textColor": UIColorFromHEX(0x333333),
                     @"borderColor": UIColorFromHEX(0xDDDDDD),
                     @"borderWidth": @.5f,
                     @"cornerRadius": @4.f,
                     @"font": [UIFont systemFontOfSize:14]
                     };
        };
    }
    SCLButton *confirm = [alert addButton:confirmTitle actionBlock:confirmHandler];
    confirm.buttonFormatBlock = ^NSDictionary *{
        return @{@"backgroundColor": UIColorFromHEX(0xD23139),
                 @"textColor": UIColor.whiteColor,
                 @"cornerRadius": @4.f,
                 @"font": [UIFont systemFontOfSize:14]
                 };
    };
    return alert;
}


#pragma mark - Loading & Toast

+ (MBProgressHUD *)showToast:(NSString *)text icon:(NSString *)imageName view:(UIView *)view {
    if (!text) return nil;
    if (!view) view = [self mainView];
    [self hideToastOrLoading];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.tag = ToastViewTag;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    // 判断是否显示图片
    if (!imageName) {
        hud.bezelView.backgroundColor = [UIColor colorWithHexString:@"#080808" alpha:0.88];
        hud.bezelView.layer.cornerRadius = 6;
        hud.contentColor = UIColor.whiteColor;
        hud.label.text = text;
        hud.label.numberOfLines = 0;
        hud.label.font = [UIFont systemFontOfSize:15];
        //设置最新尺寸
        CGSize size = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:hud.label.font} context:nil].size;
        CGFloat height = MAX(size.height + 26, 43);
        hud.minSize = CGSizeMake(size.width + 32, height);
        hud.mode = MBProgressHUDModeText;
    } else {
        hud.bezelView.backgroundColor = UIColor.clearColor;
        UIView *customView = [[UIView alloc] init];
        customView.backgroundColor = [UIColor colorWithHexString:@"#080808" alpha:0.88];
        customView.layer.cornerRadius = 6;
        [customView setShadowColor:UIColor.blackColor offset:CGSizeMake(0, 1) radius:6 opacity:0.1];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        [customView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(customView);
            make.left.equalTo(@16);
            make.size.mas_equalTo(imageView.image.size);
        }];
        UILabel *label = [[UILabel alloc] init];
        label.text = text;
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = UIColor.whiteColor;
        [customView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@14);
            make.left.equalTo(imageView.mas_right).offset(8);
            make.right.equalTo(@-16);
            make.bottom.equalTo(@-14);
            make.centerY.equalTo(customView);
        }];
        // 设置模式
        hud.mode = MBProgressHUDModeCustomView;
        // 设置图片
        hud.customView = customView;
    }
    // 1.5秒之后再消失
    [hud hideAnimated:YES afterDelay:1.5f];
    return hud;
}

+ (void)showToast:(NSString *)text icon:(NSString *)imageName {
    [self showToast:text icon:imageName view:nil];
}

//Toast
+ (void)showToast:(NSString *)message toView:(UIView *)view{
    [self showToast:message icon:nil view:view];
}
+ (void)showToast:(NSString *)message {
    [self showToast:message toView:nil];
}
+ (void)showToast:(NSString *)message completion:(void(^)(void))completionBlock {
    MBProgressHUD *hud = [self showToast:message icon:nil view:nil];
    hud.completionBlock = completionBlock;
}
//成功Toast
+ (void)showSuccessToast:(NSString *)message toView:(UIView *)view {
    [self showToast:message icon:@"success_alert" view:view];
}
+ (void)showSuccessfulToast:(NSString *)message {
    [self showSuccessToast:message toView:nil];
}
+ (void)showSuccessfulToast:(NSString *)message completion:(void(^)(void))completionBlock {
    MBProgressHUD *hud = [self showToast:message icon:@"success_alert" view:nil];
    hud.completionBlock = completionBlock;
}

//失败Toast
+ (void)showErrorToast:(NSString *)error toView:(UIView *)view{
    [self showToast:error icon:@"error_alert" view:view];
}
+ (void)showFailureToast:(NSString *)error {
    [self showErrorToast:error toView:nil];
}
+ (void)showFailureToast:(NSString *)message completion:(void(^)(void))completionBlock {
    MBProgressHUD *hud = [self showToast:message icon:@"error_alert" view:nil];
    hud.completionBlock = completionBlock;
}

//Loading
+ (void)showLoading:(NSString*)message toView:(UIView *)view {
    if (!view) view = [self mainView];
    [self hideToastOrLoading];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.tag = LoadingViewTag;
    //自定义视图
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor; //无背景色
    hud.bezelView.backgroundColor = UIColor.clearColor;
    UIView *customView = [[UIView alloc] init];
    customView.backgroundColor = UIColor.blackColor.setAlpha(0.8);
    customView.layer.cornerRadius = 6;
    [customView setShadowColor:UIColor.blackColor offset:CGSizeMake(0, 1) radius:6 opacity:0.1];
    //loading
    NSMutableArray *loadingImages = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < 25; i++) {
        NSString *imageName = [@"loading_" stringByAppendingFormat:@"%ld", i];
        [loadingImages addObject:UIImageNamed(imageName)];
    }
    UIImageView *loadingView = [[UIImageView alloc] init];
    loadingView.animationImages = loadingImages;
    loadingView.animationDuration = 1.04;
    [loadingView startAnimating];
    [customView addSubview:loadingView];
    if (message.length) {
        UILabel *label = [[UILabel alloc] init];
        label.text = message;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = UIColor.whiteColor.setAlpha(0.6);
        label.textAlignment = NSTextAlignmentCenter;
        [customView addSubview:label];
        [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(customView);
            make.top.left.equalTo(@5);
            make.bottom.right.equalTo(@-5);
            make.width.height.equalTo(@80);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(loadingView.mas_bottom).offset(-5);
            make.left.right.equalTo(loadingView);
        }];
    } else {
        [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(customView);
            make.width.height.equalTo(@80);
        }];
    }
    // 设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 设置图片
    hud.customView = customView;
    //30秒之后再消失
    [hud hideAnimated:YES afterDelay:30.f];
}
+ (void)showLoading:(NSString*)message {
    [self showLoading:message toView:nil];
}
+ (void)showLoading {
    [self showLoading:nil toView:nil];
}

+ (void)dismissLoadingForView:(UIView *)view {
    if (!view) view = [self mainView];
    [MBProgressHUD hideHUDForView:view animated:YES];
}

+ (void)dismissLoading {
    [self dismissLoadingForView:nil];
}

// 新增加
+ (void)showToast:(NSString *)message view:(UIView *)view
{
    [self showToast:message toView:view];
}

+ (void)showSuccessfulToast:(NSString *)message view:(UIView *)view
{
    [self showToast:message icon:@"success_alert" view:view];
}

+ (void)showFailureToast:(NSString *)error view:(UIView *)view
{
    [self showToast:error icon:@"error_alert" view:view];
}

+ (void)showLoading:(NSString*)message view:(UIView *)view
{
    [self showLoading:message toView:view];
}

+ (void)showLoadingWithView:(UIView *)view
{
    [self showLoading:nil toView:view];
}

+ (void)dismissLoadingWithView:(UIView *)view
{
    [ZHAlertView dismissLoadingForView:view];
}







#pragma mark - 窗口
+ (UIViewController *)currentViewController {
    return UIApplication.sharedApplication.delegate.window.rootViewController;
}

+ (UIView *)mainView {
    return UIApplication.sharedApplication.delegate.window;
}

+ (void)hideToastOrLoading {
    UIView *view = [self mainView];
    if ([view viewWithTag:ToastViewTag]) {
        [MBProgressHUD hideHUDForView:view animated:YES];
    }
    if ([view viewWithTag:LoadingViewTag]) {
        [MBProgressHUD hideHUDForView:view animated:YES];
    }
    
}

@end
