//
//  UIImage+Reduce.h
//  MFNongYe
//
//  Created by Mengfei on 16/5/26.
//  Copyright © 2016年 XinMiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Reduce)

//  单张照片的缩小
- (UIImage *)reduce:(UIImage *)image;

//  多张照片缩小
- (UIImage *)setSizeOfImage:(UIImage *)image;

//  压缩图片
- (UIImage *)imageWithImageSimpleScaledToSize:(CGSize)newSize;

// 通过坐标区域切割图片
- (UIImage *)clipImageInRect:(CGRect)rect;

// 将图片缩放到指定的CGSize大小，UIImage image 原始的图片，CGSize size 要缩放到的大小
+ (UIImage *)image:(UIImage *)image scaleToSize:(CGSize)size;

// 从图片中按指定的位置大小截取图片的一部分，UIImage image 原始的图片，CGRect rect 要截取的区域
+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;

// 添加文字水印到指定图片上
+ (UIImage *)addWaterText:(NSString *)text Attributes:(NSDictionary*)atts toImage:(UIImage *)img rect:(CGRect)rect;

// 给图片添加图片水印
+ (UIImage *)addWaterImage:(UIImage *)waterImg toImage:(UIImage *)img rect:(CGRect)rect;


@end
