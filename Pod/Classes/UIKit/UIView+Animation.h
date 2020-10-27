//
//  UIView+Animation.h
//  PPYLiFeng
//
//  Created by Murphy on 2020/7/13.
//  Copyright © 2020 Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface UIView (Animation)

// 添加抖动动画
-(void)addShakeAnimation;

// 翻转动画
- (void)transitionWithType:(NSString *)type WithSubtype:(NSString *)subtype;

@end

NS_ASSUME_NONNULL_END
