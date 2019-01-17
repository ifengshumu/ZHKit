//
//  UIImage+EM.h
//  ZHKit
//
//  Created by Lee on 2016/9/29.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (EM)
/**
 根据颜色、尺寸生产图片
 
 @param color 颜色
 @param size 尺寸
 @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 缩放图片

 @param image 图片
 @param size 缩放尺寸
 @return 图片
 */
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size;

/**
 旋转图片
 */
+ (UIImage *)rotationImage:(UIImage *)image rotation:(UIImageOrientation)orientation;


@end

