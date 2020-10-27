//
//  UIView+Animation.m
//  PPYLiFeng
//
//  Created by Murphy on 2020/7/13.
//  Copyright © 2020 Murphy. All rights reserved.
//

#import "UIView+Animation.h"


@implementation UIView (Animation)

// 添加抖动动画
-(void)addShakeAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    CGFloat currentTx = self.transform.tx;
    animation.duration = 0.5;
    animation.values = @[@(currentTx), @(currentTx + 10), @(currentTx-8), @(currentTx + 8), @(currentTx -5), @(currentTx + 5), @(currentTx)];
    animation.keyTimes = @[@(0), @(0.225), @(0.425), @(0.6), @(0.75), @(0.875), @(1)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:animation forKey:@"kAFViewShakerAnimationKey"];
}

- (void)transitionWithType:(NSString *)type WithSubtype:(NSString *)subtype
{
    CATransition *animation = [CATransition animation];
    animation.duration = 1;
    animation.type = type;
    animation.subtype = subtype;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:animation forKey:@"animation"];
}

@end
