//
//  UIView+Gradient.h
//  PPYLiFeng
//
//  Created by 陈子介 on 2020/5/9.
//  Copyright © 2020 Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Gradient)

- (void)addGradientWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor cornerRadius:(CGFloat)cornerRadius;

- (void)removeGradient;

@end

NS_ASSUME_NONNULL_END
