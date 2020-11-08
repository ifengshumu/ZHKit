//
//  SZSwitch.m
//  PPYLiFeng
//
//  Created by 李志华 on 2020/6/4.
//  Copyright © 2020 Murphy. All rights reserved.
//

#import "SZSwitch.h"

@interface SZSwitch ()
@property (nonatomic, strong) UILabel *yesLabel;
@property (nonatomic, strong) UILabel *noLabel;
@property (nonatomic, strong) UIView *whiteView;
@end

@implementation SZSwitch

- (instancetype)initWithFrame:(CGRect)frame {
    CGRect rect = frame;
    rect.size = CGSizeMake(76, 26);
    self = [super initWithFrame:rect];
    if (self) {
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#A3A3A3"];
    self.layer.cornerRadius = 13;
    
    UIView *white = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 40 - 2, 2, 40, CGRectGetHeight(self.frame) - 4)];
    white.backgroundColor = UIColor.whiteColor;
    white.layer.cornerRadius = 11;
    self.whiteView = white;
    [self addSubview:white];
    
    UILabel *yes = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, CGRectGetWidth(white.frame), CGRectGetHeight(self.frame))];
    yes.text = @"是";
    yes.textColor = UIColor.whiteColor;
    yes.textAlignment = NSTextAlignmentCenter;
    yes.font = mFontM(12);
    self.yesLabel = yes;
    [self addSubview:yes];
    [yes addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        if (self.swithValue && !self.isOn) {
            [self setOn:YES animated:YES];
            self.swithValue(YES);
        }
    }];
    
    UILabel *no = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(white.frame), 0, CGRectGetWidth(white.frame), CGRectGetHeight(self.frame))];
    no.text = @"否";
    no.textColor = UIColor.deepBlackColor;
    no.textAlignment = NSTextAlignmentCenter;
    no.font = mFontM(12);
    self.noLabel = no;
    [self addSubview:no];
    [no addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        if (self.swithValue && self.isOn) {
            [self setOn:NO animated:YES];
            self.swithValue(NO);
        }
    }];
}

- (void)setOnText:(NSString *)onT offText:(NSString *)offT {
    self.yesLabel.text = onT;
    self.noLabel.text = offT;
}

- (void)setOn:(BOOL)on {
    [self setOn:on animated:NO];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated {
    if (self.isOn != on) {
        CGRect rect = self.whiteView.frame;
        _on = on;
        if (on) {
            rect.origin.x = 2;
            self.yesLabel.textColor = UIColor.deepBlackColor;
            self.noLabel.textColor = UIColor.whiteColor;
            self.backgroundColor = UIColor.deepBlueColor;
        } else {
            rect.origin.x = CGRectGetWidth(self.frame) - 40 - 2;
            self.yesLabel.textColor = UIColor.whiteColor;
            self.noLabel.textColor = UIColor.deepBlackColor;
            self.backgroundColor = [UIColor colorWithHexString:@"#A3A3A3"];
        }
        if (animated) {
            [UIView animateWithDuration:0.3 animations:^{
                self.whiteView.frame = rect;
            }];
        } else {
            self.whiteView.frame = rect;
        }
    }
}

@end
