//
//  ProgressView.h
//  MFBiFuQiXiu
//
//  Created by Murphy on 17/5/26.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProgressView : UIView

@property (nonatomic, strong) UIView *pView;
@property (nonatomic, strong) UILabel *number;
@property (nonatomic, assign) CGFloat progress;
- (void)reloadProgress:(CGFloat)maxValue nowValue:(CGFloat)nowValue isAnimation:(BOOL)isAnimation;
- (void)reloadProgress:(CGFloat)progress isAnimation:(BOOL)isAnimation;
@end

