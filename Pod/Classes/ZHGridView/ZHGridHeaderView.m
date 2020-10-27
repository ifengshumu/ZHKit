//
//  ZHGridHeaderView.m
//
//  Created by 李志华 on 16/8/4.
//  Copyright © 2016年 李志华. All rights reserved.
//

#import "ZHGridHeaderView.h"

@interface ZHGridHeaderView ()
@property (nonatomic, strong) UIView *line;
@end

@implementation ZHGridHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        _titleLabel.textColor = UIColor.blackColor;
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@15);
            make.left.equalTo(@20);
            make.right.equalTo(@-20);
        }];
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.font = [UIFont systemFontOfSize:14];
        _subtitleLabel.textColor = UIColor.grayColor;
        _subtitleLabel.numberOfLines = 0;
        [self addSubview:_subtitleLabel];
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
            make.left.right.equalTo(self.titleLabel);
            make.bottom.equalTo(@-10);
        }];
    }
    return self;
}

@end
