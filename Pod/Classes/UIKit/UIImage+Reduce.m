//
//  UIImage+Reduce.m
//  MFNongYe
//
//  Created by Mengfei on 16/5/26.
//  Copyright © 2016年 XinMiao. All rights reserved.
//

#import "UIImage+Reduce.h"

#define mImageHW          (mScreenWidth-W(60))/3

@implementation UIImage (Reduce)

//  单张照片的缩小
- (UIImage *)reduce:(UIImage *)image
{
    if (image.size.width > mScreenWidth-20)
    {
        image = [self imageWithImageSimpleScaledToSize:CGSizeMake(mScreenWidth-20, image.size.height*(mScreenWidth-20)/image.size.width)];
    }
    return image;
}

//  多张照片缩小
-(UIImage *)setSizeOfImage:(UIImage *)image
{
    if (image.size.width>image.size.height)
    {
        image = [self imageWithImageSimpleScaledToSize:CGSizeMake(image.size.width*mImageHW/image.size.height, mImageHW)];
    }else
    {
        image = [self imageWithImageSimpleScaledToSize:CGSizeMake(mImageHW, image.size.height*mImageHW/image.size.width)];
    }
    image = [self cutImage:image];
    
    return image;
}


//  压缩图片
- (UIImage *)imageWithImageSimpleScaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

//  裁剪图片
- (UIImage *)cutImage:(UIImage *)image
{
    //  压缩图片
    CGSize newSize;
    CGImageRef imageRef = nil;
    if ((image.size.width / image.size.height) < 1)
    {
        newSize.width = image.size.width;
        newSize.height = image.size.width;
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
    } else
    {
        newSize.height = image.size.height;
        newSize.width = image.size.height;
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
    }
    return [UIImage imageWithCGImage:imageRef];
}


// 通过坐标区域切割图片
- (UIImage *)clipImageInRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return thumbScale;
}


- (UIImage *)ct_imageFromImage:(UIImage *)image inRect:(CGRect)rect
{
    //把像 素rect 转化为 点rect（如无转化则按原图像素取部分图片）
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat x= rect.origin.x*scale,y = rect.origin.y*scale,w=rect.size.width*scale,h=rect.size.height*scale;
    CGRect dianRect = CGRectMake(x, y, w, h);
    
    //截取部分图片并生成新图片
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, dianRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    return newImage;
}






// 将图片缩放到指定的CGSize大小，UIImage image 原始的图片，CGSize size 要缩放到的大小
+ (UIImage *)image:(UIImage *)image scaleToSize:(CGSize)size
{
    // 得到图片上下文，指定绘制范围
    UIGraphicsBeginImageContext(size);
    // 将图片按照指定大小绘制
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前图片上下文中导出图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 当前图片上下文出栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}


// 从图片中按指定的位置大小截取图片的一部分，UIImage image 原始的图片，CGRect rect 要截取的区域
+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect
{
    // 将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [image CGImage];
    // 按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    // 将CGImageRef转换成UIImage
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    // 返回剪裁后的图片
    return newImage;
}

// 添加文字水印到指定图片上
+ (UIImage *)addWaterText:(NSString *)text Attributes:(NSDictionary*)atts toImage:(UIImage *)img rect:(CGRect)rect
{
    CGFloat height = img.size.height;
    CGFloat width = img.size.width;
    // 开启一个图形上下文
    UIGraphicsBeginImageContext(img.size);
    // 在图片上下文中绘制图片
    [img drawInRect:CGRectMake(0, 0,width,height)];
    // 在图片的指定位置绘制文字   -- 7.0以后才有这个方法
    [text drawInRect:rect withAttributes:atts];
    // 从图形上下文拿到最终的图片
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图片上下文
    UIGraphicsEndImageContext();
    
    return newImg;
}

// 给图片添加图片水印
+ (UIImage *)addWaterImage:(UIImage *)waterImg toImage:(UIImage *)img rect:(CGRect)rect
{
    CGFloat height = img.size.height;
    CGFloat width = img.size.width;
    // 开启一个图形上下文
    UIGraphicsBeginImageContextWithOptions(img.size, YES, 0);
    // 在图片上下文中绘制图片
    [img drawInRect:CGRectMake(0, 0,width,height)];
    // 在图片指定位置绘制图片
    [waterImg drawInRect:rect];
    // 从图形上下文拿到最终的图片
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图片上下文
    UIGraphicsEndImageContext();
    
    return newImg;
}


@end
