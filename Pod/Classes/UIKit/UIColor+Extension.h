//
//  UIColor+Extension.h
//  ZHKit
//
//  Created by Lee on 2016/9/29.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *UIColorRGBValue NS_EXTENSIBLE_STRING_ENUM;
UIKIT_EXTERN UIColorRGBValue const UIColorRedValue;
UIKIT_EXTERN UIColorRGBValue const UIColorGreenValue;
UIKIT_EXTERN UIColorRGBValue const UIColorBlueValue;
UIKIT_EXTERN UIColorRGBValue const UIColorAlphaValue;

typedef NS_ENUM(NSUInteger, UIGradientColorDirection) {
    UIGradientColorDirectionHorizontal, /**< 水平 */
    UIGradientColorDirectionVertical,   /**< 垂直 */
};


@interface UIColor (Extension)

/// 从十六进制字符串获取颜色.
// hexString:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
// hexStringt如果为8位则使用颜色值中的透明度（前2位），否则使用指定的透明度
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

/// 从十六进制字符串获取颜色.
// hexStringt如果为8位则使用颜色值中的透明度（前2位），否则透明度 = 1
+ (UIColor *)colorWithHexString:(NSString *)hexString;

/// 渐变颜色
+ (UIColor *)gradientColor:(NSArray<UIColor *> *)colors gradientSize:(CGSize)aSize gradientDirection:(UIGradientColorDirection)direction;

///  随机颜色
+ (UIColor *)randomColor;

///  颜色转化为照片
- (UIImage *)toImg;

/// 颜色转化为十六进制字符串
+ (NSString *)hexFromUIColor:(UIColor*)color;

/**
 UIColor转grb
 */
- (NSDictionary<UIColorRGBValue, NSNumber*> *)rgbValue;

/**
 设置透明度
*/
- (UIColor *(^)(CGFloat))setAlpha;

#pragma mark - APP常用色可在此定义，方便使用
/// #7657A4
@property(class, nonatomic, readonly) UIColor *deepBlueColor;

/// #F3F2FD
@property(class, nonatomic, readonly) UIColor *lightBlueColor;

/// #333333
@property(class, nonatomic, readonly) UIColor *deepBlackColor;

/// #606266
@property(class, nonatomic, readonly) UIColor *lightBlackColor;

/// #909399
@property(class, nonatomic, readonly) UIColor *regularGrayColor;

/// #EBEEF5
@property(class, nonatomic, readonly) UIColor *lineColor;

/// #F9F9F9
@property(class, nonatomic, readonly) UIColor *backgroundColor;

/// #AAAAAA
@property(class, nonatomic, readonly) UIColor *placeholderColor;

/// #D23139
@property(class, nonatomic, readonly) UIColor *deepRedColor;

@end

NS_ASSUME_NONNULL_END
