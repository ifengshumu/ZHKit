//
//  LabelAndTextView.m
//  PPYLiFeng
//
//  Created by Steve on 2020/6/10.
//  Copyright © 2020 Murphy. All rights reserved.
//

#import "LabelAndTextView.h"

@implementation LabelAndTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    _leftLabel = [[UILabel alloc] init];
    _leftLabel.textColor = UIColor.deepBlackColor;
    _leftLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_leftLabel];
    [_leftLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(@20);
    }];
    _textView = [[UITextView alloc] init];
    _textView.scrollEnabled = NO;
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.textColor = UIColor.deepBlackColor;
    _textView.textContainerInset = UIEdgeInsetsZero;
    _textView.showsVerticalScrollIndicator = NO;
    _textView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.left.equalTo(@130);
        make.right.equalTo(@-20);
        make.bottom.equalTo(@-15);
        make.height.mas_greaterThanOrEqualTo(20);
    }];
}


@end
