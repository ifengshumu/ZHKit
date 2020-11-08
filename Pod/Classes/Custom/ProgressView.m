//
//  ProgressView.m
//  MFBiFuQiXiu
//
//  Created by Murphy on 17/5/26.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "ProgressView.h"


#define mRGBAllcolor      UIColor.deepBlueColor   // 深紫色
#define mRGBGraycolor     UIColor.lightBlueColor  // 浅紫色


@interface ProgressView ()

@end


@implementation ProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = frame.size.height/2;
        self.backgroundColor = UIColor.lightBlueColor;
        
        // 进度
        UIView *pView = [[UIView alloc] init];
        pView.frame = CGRectMake(0, 0, 0, frame.size.height);
        pView.layer.cornerRadius = frame.size.height/2;
        pView.layer.masksToBounds = YES;
        pView.backgroundColor = UIColor.deepBlueColor;
        [self addSubview:pView];
        self.pView = pView;
        
        
        // 当前数值
        _number = [[UILabel alloc] init];
        _number.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        _number.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _number.font = mFont(10);
        _number.textColor = mRGBgfontcolor;
        _number.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_number];
    }
    
    return self;
}

- (void)reloadProgress:(CGFloat)maxValue nowValue:(CGFloat)nowValue isAnimation:(BOOL)isAnimation
{
    if (!isAnimation)
    {
        self.pView.width = 0;
        return;
    }
    
    if (maxValue == 0)
    {
        _progress = 0;
    }else
    {
        _progress = nowValue/maxValue;
        if (_progress < 0)
        {
            _progress = 0;
        }else if (_progress > 1)
        {
            _progress = 1;
        }
    }
    CGFloat maxWidth = self.bounds.size.width;
    
    // 是否做动画显示
    if (isAnimation)
    {
        mWS(weakSelf);
        self.number.text = [NSString stringWithFormat:@"%.lf%%",100*_progress];
        [UIView animateWithDuration:1 animations:^{
//            [UIView setAnimationCurve:7];
            weakSelf.pView.width = maxWidth * weakSelf.progress;
        }];
    }else
    {
        self.pView.width = maxWidth * _progress;
        _number.text = [NSString stringWithFormat:@"%.lf%%",100*_progress];
    }
    if (_progress == 0)
    {
        self.number.width = self.width;
        self.number.textColor = mRGBgfontcolor;
    }else
    {
        self.number.width = maxWidth * _progress;
        self.number.textColor = [UIColor whiteColor];
    }
}

- (void)reloadProgress:(CGFloat)progress isAnimation:(BOOL)isAnimation
{
    if (progress < 0)
    {
        progress = 0;
    }else if (progress > 1)
    {
        progress = 1;
    }
    
    CGFloat maxWidth = self.bounds.size.width;
    // 是否做动画显示
    if (isAnimation)
    {
        mWS(weakSelf);
        [UIView animateWithDuration:1 animations:^{
//            [UIView setAnimationCurve:7];
            weakSelf.pView.width = maxWidth * progress;
        }];
    }else
    {
        self.pView.width = maxWidth * _progress;
    }
}

@end
