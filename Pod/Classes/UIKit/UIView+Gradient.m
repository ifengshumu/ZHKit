//
//  UIView+Gradient.m
//  PPYLiFeng
//
//  Created by 陈子介 on 2020/5/9.
//  Copyright © 2020 Murphy. All rights reserved.
//

#import "UIView+Gradient.h"

@implementation UIView (Gradient)

- (void)addGradientWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor cornerRadius:(CGFloat)cornerRadius{
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer isKindOfClass:[CAGradientLayer class]]) {
            return;
        }
    }
    // gradient
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = self.bounds;
    gl.startPoint = CGPointMake(0, 0.5);
    gl.endPoint = CGPointMake(1, 0.5);
    gl.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
    gl.locations = @[@(0), @(1.0f)];
    gl.cornerRadius = cornerRadius;
    [self.layer insertSublayer:gl atIndex:0];
}

- (void)removeGradient{
    CALayer *gl = nil;
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer isKindOfClass:[CAGradientLayer class]]) {
            gl = layer;
            break;
        }
    }
    if (gl != nil) {
        [gl removeFromSuperlayer];
    }
}

@end
