//
//  UIButton+Indicator.h
//  MFShowcaseImage
//
//  Created by Mengfei on 16/5/13.
//  Copyright © 2016年 XinMiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Indicator)

// 该方法将显示按钮文本位置的活动指示器
- (void) showIndicator;

// 该方法将指标放回原位按钮文本
- (void) hideIndicator;


@end
