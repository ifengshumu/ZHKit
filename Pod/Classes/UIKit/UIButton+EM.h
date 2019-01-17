//
//  UIButton+EM.h
//  ZHKit
//
//  Created by Lee on 2016/9/29.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, UIButtonImageAlignmentStyle) {
    ///左图右文
    UIButtonImageAlignmentStyleLeft = 0,
    ///左文右图
    UIButtonImageAlignmentStyleRight,
    ///上图下文
    UIButtonImageAlignmentStyleTop,
    ///上文下图
    UIButtonImageAlignmentStyleBottom,
};

@interface UIButton (EM)

/**
 可以让UIButton携带多参数
 */
@property (nonatomic, copy) NSDictionary *userInfo;

/**
 初始化UIButton，只有图片
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame image:(UIImage *)aImage;

/**
 初始化UIButton，只有文字
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)aTitle titleColor:(UIColor *)aColor titleFont:(UIFont *)aFont;

/**
 初始化UIButton，带Block事件
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)aTitle titleColor:(UIColor *)aColor titleFont:(UIFont *)aFont image:(UIImage *)aImage actionHandler:(void(^)(UIButton *sedner))action;

/**
 添加Block事件
 */
- (void)addButtonActionHandler:(void(^)(UIButton *sedner))action;

/**
 设置按钮图片文字排列位置，务必在按钮图片文字和frame设置完毕后调用

 @param style see UIButtonImageTextAlignmentStyle
 @param space 图片文字间距
 */
- (void)setImageTextAlignmentStyle:(UIButtonImageAlignmentStyle)style  space:(CGFloat)space;

/**
 倒计时

 @param dutation 时间
 @param title 倒计时结束时按钮显示标题
 @param remainingTime 剩余时间
 */
- (void)countdownWithDuration:(NSUInteger)dutation endButtonTitle:(NSString *)title remainingTime:(void(^)(NSUInteger time))remainingTime;
@end

