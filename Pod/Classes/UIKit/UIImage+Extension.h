//
//  UIImage+Extension.h
//  ZHKit
//
//  Created by Lee on 2016/9/29.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Creates an image object from the specified named asset.
extern UIImage* UIImageNamed(NSString * name);

@interface UIImage (Extension)

/**
 根据颜色、尺寸创建图片

 @param color 颜色
 @param size 尺寸
 @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;


/// 保存图片到相册
/// @param image 图片
/// @param useCustomized 是否使用自定义相册
/// @param result 结果
+ (void)saveImage:(UIImage *)image useCustomizedAssetCollection:(BOOL)useCustomized result:(nullable void(^)(BOOL granted, BOOL success))result;

/**
 缩放图片到指定尺寸
 */
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size;

/**
缩放图片到指定大小，单位MB
*/
+ (NSData *)scaleImage:(UIImage *)image toMB:(CGFloat)mb;

/**
 旋转图片

 @param image 要旋转的图片
 @param orientation 旋转方向
 @return 旋转后的图片
 */
+ (UIImage *)rotationImage:(UIImage *)image rotation:(UIImageOrientation)orientation;

/**
 截图

@param view 视图
@return 截图
*/
+ (UIImage *)snapshotView:(UIView *)view;


/// 从图片中按指定的位置大小截取图片的一部分
/// @param image 原始的图片
/// @param rect 要截取的区域
+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;

/// 添加文字水印到指定图片上
/// @param text 添加的文字
/// @param atts 文字属性
/// @param img 要添加的图片
/// @param rect 文字要添加的区域
+ (UIImage *)addWaterText:(NSString *)text
               attributes:(NSDictionary*)atts
                  toImage:(UIImage *)img
                     rect:(CGRect)rect;

/// 给图片添加图片水印
+ (UIImage *)addWaterImage:(UIImage *)waterImg
                   toImage:(UIImage *)img
                      rect:(CGRect)rect;


/** 垂直翻转 */
- (UIImage *)flipVertical;

/** 水平翻转 */
- (UIImage *)flipHorizontal;

/** 将图片旋转degrees角度 */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

/** 将图片旋转radians弧度 */
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;


@end

NS_ASSUME_NONNULL_END
