//
//  UIView+makeImage.m
//  PPYLiFeng
//
//  Created by 陈子介 on 2020/5/9.
//  Copyright © 2020 Murphy. All rights reserved.
//

#import "UIView+makeImage.h"

@implementation UIView (makeImage)

#pragma mark 生成image
- (UIImage *)makeImage{
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale。
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
