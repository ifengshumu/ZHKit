//
//  ZHSignatureView.m
//
//  Created by 李志华 on 2017/4/1.
//  Copyright © 2017年 leezhihua. All rights reserved.
//

#define SPACE           10
#define BUTTON_WIDTH    100
#define BUTTON_HEIGHT   50


#import "ZHSignatureView.h"
#import "ZHDrawingView.h"

@interface ZHSignatureView ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) ZHDrawingView *drawView;
@property (nonatomic, strong) UIButton *checkButton;

@end

@implementation ZHSignatureView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:UIScreen.mainScreen.bounds];
    if (self) {
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.4];
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-300, CGRectGetWidth(self.frame), 300)];
    contentView.backgroundColor = UIColor.backgroundColor;
    [self addSubview:contentView];
    ZHDrawingView *draw = [[ZHDrawingView alloc] initWithFrame:CGRectMake(20, CGRectGetHeight(contentView.frame)-235, CGRectGetWidth(contentView.frame)-40, 215)];
    self.drawView = draw;
    draw.backgroundColor = UIColor.whiteColor;
    draw.layer.cornerRadius = 8;
    draw.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
    draw.layer.borderWidth = 1;
    draw.lineWidth = 3;
    [contentView addSubview:draw];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.titleLabel.font = mFont(14);
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:UIColor.regularGrayColor forState:UIControlStateNormal];
    [contentView addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@20);
    }];
    [cancel addTouchUpInsideEventUsingBlock:^(UIButton * _Nonnull sender) {
        [self dismiss];
    }];
    UIButton *reset = [UIButton buttonWithType:UIButtonTypeCustom];
    reset.titleLabel.font = mFont(14);
    [reset setTitle:@"重写" forState:UIControlStateNormal];
    [reset setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [contentView addSubview:reset];
    [reset mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.centerX.equalTo(contentView);
    }];
    [reset addTouchUpInsideEventUsingBlock:^(UIButton * _Nonnull sender) {
        [draw clearAll];
    }];
    
    UIButton *save = [UIButton buttonWithType:UIButtonTypeCustom];
    save.titleLabel.font = mFont(14);
    [save setTitle:@"保存" forState:UIControlStateNormal];
    [save setTitleColor:UIColor.deepBlueColor forState:UIControlStateNormal];
    [contentView addSubview:save];
    [save mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.right.equalTo(@-20);
    }];
    [save addTouchUpInsideEventUsingBlock:^(UIButton * _Nonnull sender) {
        if (!self.checkButton.selected) {
            [ZHAlertView showToast:@"请先勾选"];
            return;
        }
        if (self.signImage) {
            UIImage *img = [draw getSignImage];
            self.signImage(img);
        }
    }];
    
    UIButton *check = [UIButton buttonWithType:UIButtonTypeCustom];
    self.checkButton = check;
    check.frame = CGRectMake(10, CGRectGetMinY(contentView.frame)-72, CGRectGetWidth(self.frame)-20, 57);
    check.backgroundColor = UIColor.whiteColor;
    check.layer.cornerRadius = 8;
    check.titleLabel.font = mFont(14);
    [check setTitle:@"我已阅读此报告所有内容" forState:UIControlStateNormal];
    [check setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [check setImage:[UIImage imageNamed:@"no-choice"] forState:UIControlStateNormal];
    [check setImage:[UIImage imageNamed:@"choice"] forState:UIControlStateSelected];
    [check setImageTextAlignment:UIButtonImageAlignmentLeft space:5];
    [self addSubview:check];
    [check addTouchUpInsideEventUsingBlock:^(UIButton * _Nonnull sender) {
        sender.selected = !sender.selected;
    }];
}


#pragma mark - Public Method
- (void)show {
    //显示前重置
    self.checkButton.selected = NO;
    [self.drawView clearAll];
    
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    [window addSubview:self];
    //From Frame
    self.transform = CGAffineTransformConcat(CGAffineTransformIdentity, CGAffineTransformMakeScale(0.1f, 0.1f));
    self.alpha = 0.0f;
    [UIView animateWithDuration:0.3f animations:^{
        //To Frame
        self.transform = CGAffineTransformConcat(CGAffineTransformIdentity, CGAffineTransformMakeScale(1.0f, 1.0f));
        self.alpha = 1.f;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformConcat(CGAffineTransformIdentity, CGAffineTransformMakeScale(0.1f, 0.1f));
        self.alpha = 0.0f;
    } completion:^(BOOL completed) {
        [UIView animateWithDuration:0.3 animations:^{
            [self removeFromSuperview];
        }];
    }];
}

@end
