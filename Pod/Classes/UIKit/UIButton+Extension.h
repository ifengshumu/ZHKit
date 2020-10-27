//
//  UIButton+Extension.h
//
//  Created by 李志华 on 2020/4/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, UIButtonImageAlignment) {
    ///左图右文
    UIButtonImageAlignmentLeft = 0,
    ///左文右图
    UIButtonImageAlignmentRight,
    ///上图下文
    UIButtonImageAlignmentTop,
    ///上文下图
    UIButtonImageAlignmentBottom,
};

@interface UIButton (Extension)

/**
 可以让UIButton携带多参数
 */
@property (nonatomic, copy) NSDictionary *userInfo;

/**
 添加Block点击事件
 */
- (void)addTouchUpInsideEventUsingBlock:(void(^)(UIButton *sender))block;

/**
 添加Block点击事件
 */
- (void)addControlEvent:(UIControlEvents)controlEvent usingBlock:(void(^)(UIButton *sender))block;

/**
 设置按钮图片文字排列位置，务必在按钮图片文字和frame设置完毕后调用
 */
- (void)setImageTextAlignment:(UIButtonImageAlignment)style space:(CGFloat)space;

/**
 加载相应状态的远程图片
 */
- (void)setImageWithURLString:(NSString *)urlString forState:(UIControlState)state;

/**
 加载相应状态的远程图片，设置占位图
 */
- (void)setImageWithURLString:(NSString *)urlString forState:(UIControlState)state placehoderImageName:(NSString *)imageName;

/**
加载相应状态的远程背景图片
*/
- (void)setBackgroundImageWithURL:(NSString *)urlString forState:(UIControlState)state;

/**
 倒计时，间隔1秒
 */
- (void)countdownWithDuration:(NSUInteger)dutation remainingTime:(void(^)(NSUInteger time))remainingTime;

/**
 倒计时，自定义倒计时间隔

 @param dutation 时间
 @param timeInterval 倒计时间隔
 @param remainingTime 剩余时间
 */
- (void)countdownWithDuration:(NSUInteger)dutation timeInterval:(NSUInteger)timeInterval remainingTime:(void(^)(NSUInteger time))remainingTime;

/**
 取消倒计时
 */
- (void)cancelCountdown;

@end

NS_ASSUME_NONNULL_END
