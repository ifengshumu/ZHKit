//
//  UIImage+Extension.h
//
//  Created by 李志华 on 2020/4/13.
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

@end

NS_ASSUME_NONNULL_END
