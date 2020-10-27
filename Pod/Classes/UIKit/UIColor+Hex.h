//
//  UIColor+Hex.h
//  CheShi
//
//  Created by Mengfei on 16/1/3.
//  Copyright © 2016年 XinMiao. All rights reserved.
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


@interface UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)color;

//  从十六进制字符串获取颜色.
//  color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;


//  颜色转化为照片
- (UIImage *)toImg;


//  随机颜色
+ (UIColor *)RandomColor;


// 颜色转化为十六进制字符串
+ (NSString *)hexFromUIColor:(UIColor*)color;


/**
 UIColor转grb
 */
- (NSDictionary<UIColorRGBValue, NSNumber*> *)rgbValue;

/**
 渐变颜色
 */
+ (UIColor *)gradientColor:(NSArray<UIColor *> *)colors gradientSize:(CGSize)aSize gradientDirection:(UIGradientColorDirection)direction;

/**
 设置透明度
*/
- (UIColor *(^)(CGFloat))setAlpha;

/// #7657A4~#9585F9
+ (UIColor *)gradientColor:(CGSize)size;

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
