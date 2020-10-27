//
//  UIView+Extension.h
//  MFShowcaseImage
//
//  Created by Mengfei on 16/5/13.
//  Copyright © 2016年 XinMiao. All rights reserved.
//

#import <UIKit/UIKit.h>

/// AutoLayout完成
void didAutoLayout(void(^layout)(void));

CGPoint CGRectGetCenter(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);


typedef NS_OPTIONS(NSUInteger, UIBorderSide) {
    UIBorderSideAll     = 0,
    UIBorderSideTop     = 1 << 0,
    UIBorderSideBottom  = 1 << 1,
    UIBorderSideLeft    = 1 << 2,
    UIBorderSideRight   = 1 << 3,
};

@interface UIView (Extension)

@property CGPoint origin;
@property CGSize size;
@property (nonatomic, assign)CGFloat centerX;
@property (nonatomic, assign)CGFloat centerY;
@property (nonatomic, assign)CGFloat x;
@property (nonatomic, assign)CGFloat y;

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

@property CGFloat height;
@property CGFloat width;

@property CGFloat top;
@property CGFloat left;

@property CGFloat bottom;
@property CGFloat right;

/**设置圆角*/
@property (nonatomic,assign)IBInspectable CGFloat cornerRidus;

- (void) moveBy: (CGPoint) delta;
- (void) scaleBy: (CGFloat) scaleFactor;
- (void) fitInSize: (CGSize) aSize;


#pragma mark - 线条
/**
 添加顶部线条，指定线条颜色、范围
 */
- (void)addTopLineWithColor:(id)aColor edge:(UIEdgeInsets)edge;

/**
 添加顶部线条，指定线条颜色
 */
- (void)addTopLineWithColor:(id)aColor;

/**
 添加顶部线条，线条颜色#E6E6E6，指定范围
 */
- (void)addTopLineWithEdge:(UIEdgeInsets)edge;

/**
 添加顶部线条，线条颜色#E6E6E6
 */
- (void)addTopLine;

/**
 移除顶部线条
 */
- (void)removeTopLine;

/**
 添加底部线条，指定线条颜色、范围
 */
- (void)addUnderLineWithColor:(id)aColor edge:(UIEdgeInsets)edge;

/**
 添加底部线条，线条颜色#E6E6E6，指定范围
 */
- (void)addUnderLineWithEdge:(UIEdgeInsets)edge;

/**
 添加底部线条，指定线条颜色
 */
- (void)addUnderLineWithColor:(id)aColor;

/**
 添加底部线条，线条颜色#E6E6E6
 */
- (void)addUnderLine;

/**
 移除底部线条
 */
- (void)removeUnderLine;


#pragma mark - 圆角，边框
/**
 设置圆角，可单独设置某个角
 */
- (void)setCornerRadius:(CGFloat)radius corners:(UIRectCorner)corners;

/**
 同时设置阴影和圆角
*/
- (void)setCornerRadius:(CGFloat)cornerRadius
                corners:(UIRectCorner)cornecrs
            shadowColor:(UIColor *)color
                 offset:(CGSize)offset
                 radius:(CGFloat)radius
                opacity:(CGFloat)opacity;

/**
 设置阴影
*/
- (void)setShadowColor:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius opacity:(CGFloat)opacity;

/**
 设置layer
 */
- (UIView *)setBorderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth;

/**
 设置某一边的layer
 */
- (UIView *)setBorderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderSide:(UIBorderSide)borderSide;

#pragma mark - 快速
/// 创建UILabel
- (UILabel *)labelTextColor:(UIColor *)textColor font:(UIFont *)font;
/// 创建UILabel，设置文本
- (UILabel *)labelText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font;

/// 创建UIImageView
- (UIImageView *)imageView;
/// 创建UIImageView，设置图片
- (UIImageView *)imageViewWithImage:(UIImage *)image;

/// 创建UIButton，填充文本
- (UIButton *)buttonTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font;
/// 创建UIButton，填充图片
- (UIButton *)buttonImage:(UIImage *)img;
/// 创建UIButton，填充文本+图片
- (UIButton *)buttonTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font image:(UIImage *)img;

@end
