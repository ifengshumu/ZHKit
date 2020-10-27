//
//  UIButton+Gradient.h
//  PPYLiFeng
//
//  Created by 陈子介 on 2020/5/8.
//  Copyright © 2020 Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Gradient)

// 渐变色
- (void)addGradientWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor;

- (void)removeGradient;

@end

NS_ASSUME_NONNULL_END
