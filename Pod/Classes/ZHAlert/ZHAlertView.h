//
//  ZHAlert.h
//
//  Created by 李志华 on 2019/7/2.
//

#import <UIKit/UIKit.h>

@interface ZHAlertView : NSObject

#pragma mark - Alert
/**
 弹框：标题+内容+两个按钮
 */
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
              confirmTitle:(NSString *)confirmTitle
               cancelTitle:(NSString *)cancelTitle
            confirmHandler:(void(^)(void))confirmHandler
             cancelHandler:(void(^)(void))cancelHandler;

/**
弹框：标题+两个按钮
*/
+ (void)showAlertWithTitle:(NSString *)title
              confirmTitle:(NSString *)confirmTitle
               cancelTitle:(NSString *)cancelTitle
            confirmHandler:(void(^)(void))confirmHandler
             cancelHandler:(void(^)(void))cancelHandler;

/**
弹框：内容+两个按钮
*/
+ (void)showAlertWithMessage:(NSString *)message
                confirmTitle:(NSString *)confirmTitle
                 cancelTitle:(NSString *)cancelTitle
              confirmHandler:(void(^)(void))confirmHandler
               cancelHandler:(void(^)(void))cancelHandler;

/**
 弹框：标题+内容+一个按钮
 */
+  (void)showAlertWithTitle:(NSString *)title
                    message:(NSString *)message
               handlerTitle:(NSString *)handlerTitle
                    handler:(void(^)(void))handler;

/**
弹框：标题+一个按钮
*/
+ (void)showAlertWithTitle:(NSString *)title
              handlerTitle:(NSString *)handlerTitle
                   handler:(void(^)(void))handler;

/**
弹框：内容+一个按钮
*/
+ (void)showAlertWithMessage:(NSString *)message
                handlerTitle:(NSString *)handlerTitle
                     handler:(void(^)(void))handler;

/**
 弹框：两个按钮，自定义顶部图片
 */
+  (void)showAlertWithIcon:(NSString *)icon
                     title:(NSString *)title
                   message:(NSString *)message
              confirmTitle:(NSString *)confirmTitle
               cancelTitle:(NSString *)cancelTitle
            confirmHandler:(void(^)(void))confirmHandler
             cancelHandler:(void(^)(void))cancelHandler;

/**
 弹框：两个按钮，有输入框
*/
+ (void)showInputAlertWithTitle:(NSString *)title
                    placeholder:(NSString *)placeholder
                   confirmTitle:(NSString *)confirmTitle
                    cancelTitle:(NSString *)cancelTitle
                 confirmHandler:(void(^)(NSString *text))confirmHandler
                  cancelHandler:(void(^)(void))cancelHandler;

#pragma mark - Toast & Loading

/**
 Toast，指定文本、图片
 */
+ (void)showToast:(NSString *)text icon:(NSString *)imageName;

/**
 Toast
 */
+ (void)showToast:(NSString *)message;
/**
 Toast，带结束回调
*/
+ (void)showToast:(NSString *)message completion:(void(^)(void))completionBlock;

/**
 成功Toast
 */
+ (void)showSuccessfulToast:(NSString *)message;
/**
 成功Toast，带结束回调
*/
+ (void)showSuccessfulToast:(NSString *)message completion:(void(^)(void))completionBlock;

/**
 失败错误Toast
 */
+ (void)showFailureToast:(NSString *)error;
/**
 失败错误Toast，带结束回调
*/
+ (void)showFailureToast:(NSString *)message completion:(void(^)(void))completionBlock;

/**
Loading，指定显示视图
*/
+ (void)showLoading:(NSString*)message toView:(UIView *)view;

/**
 Loading，自定义动画&文字
 */
+ (void)showLoading:(NSString*)message;

/**
 Loading，无文字
 */
+ (void)showLoading;

/**
Loading隐藏
*/
+ (void)dismissLoadingForView:(UIView *)view;

/**
 Loading隐藏
 */
+ (void)dismissLoading;


+ (void)showToast:(NSString *)message view:(UIView *)view;
+ (void)showSuccessfulToast:(NSString *)message view:(UIView *)view;
+ (void)showFailureToast:(NSString *)error view:(UIView *)view;
+ (void)showLoading:(NSString*)message view:(UIView *)view;
+ (void)showLoadingWithView:(UIView *)view;
+ (void)dismissLoadingWithView:(UIView *)view;

@end

