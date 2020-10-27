//
//  UIButton+CountDown.h
//  MFShowcaseImage
//
//  Created by Mengfei on 16/5/13.
//  Copyright © 2016年 XinMiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CountDown)

-(void)startTime:(NSInteger)timeout title:(NSString *)tittle waitTittle:(NSString *)waitTittle downColor:(UIColor *)downColor normalColor:(UIColor *)normalColor;

-(void)startTime:(NSInteger)timeout title:(NSString *)tittle waitTittle:(NSString *)waitTittle downColor:(UIColor *)downColor normalColor:(UIColor *)normalColor titleDisableColor:(UIColor *)titleDisableColor titleNormalColor:(UIColor *)titleNormalColor;

@end
