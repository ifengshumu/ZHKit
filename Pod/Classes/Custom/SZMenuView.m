//
//  SZMenuView.m
//  PPYLiFeng
//
//  Created by 李志华 on 2020/6/4.
//  Copyright © 2020 Murphy. All rights reserved.
//

#import "SZMenuView.h"

@interface SZMenuView ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray<UIView *> *menuViews;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, strong) NSMutableArray *numLabelArray;
@end

@implementation SZMenuView

- (instancetype)initWithFrame:(CGRect)frame menus:(NSArray *)menus {
    return [[SZMenuView alloc] initWithFrame:frame menus:menus nums:@[]];
}

- (instancetype)initWithFrame:(CGRect)frame menus:(NSArray *)menus nums:(NSArray *)nums {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.backgroundColor;
        self.defaultColor = UIColor.lightBlackColor;
        self.selectedColor = UIColor.deepBlueColor;
        self.lineWidth = 28;
        [self layoutMenus:menus nums:nums];
    }
    return self;
}

- (void)layoutMenus:(NSArray *)menus nums:(NSArray *)nums {
    self.menuViews = [NSMutableArray arrayWithCapacity:0];
    self.numLabelArray = [NSMutableArray arrayWithArray:0];
    for (int i = 0; i < menus.count; i++) {
        UIView *menuView = [[UIView alloc] init];
        menuView.tag = 1111 + i;
        [menuView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [self menuClick:gestureRecoginzer.view animated:YES];
            if (self.menuClickHandler) {
                self.menuClickHandler(menuView.tag - 1111);
            }
        }];
        [self addSubview:menuView];
        [self.menuViews addObject:menuView];
        [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
        }];
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = menus[i];
        nameLabel.font = mFontM(14);
        nameLabel.textColor = self.defaultColor;
        [menuView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@15);
            make.centerX.equalTo(menuView);
            make.bottom.equalTo(@-15);
        }];
        if (nums.count) {
            UILabel *numLabel = [[UILabel alloc] init];
            numLabel.text = nums[i];
            numLabel.font = [UIFont systemFontOfSize:10];
            numLabel.textColor = UIColor.deepRedColor;
            numLabel.textAlignment = NSTextAlignmentCenter;
            numLabel.layer.cornerRadius = 8;
            numLabel.layer.borderColor = numLabel.textColor.CGColor;
            numLabel.layer.borderWidth = 1;
            numLabel.hidden = !numLabel.text.integerValue;
            [menuView addSubview:numLabel];
            [self.numLabelArray addObject:numLabel];
            [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(nameLabel.mas_right).offset(-3);
                make.top.equalTo(nameLabel.mas_top);
                make.width.height.equalTo(@16);
            }];
        }
        
        if (i == 0) {
            self.selectView = menuView;
            nameLabel.textColor = self.selectedColor;
        }
    }
    [self.menuViews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UIColor.deepBlueColor;
    line.layer.cornerRadius = 2;
    self.lineView = line;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.centerX.equalTo(self.menuViews.firstObject);
        make.width.equalTo(@(self.lineWidth));
        make.height.equalTo(@4);
    }];
}

- (void)setLineWidth:(CGFloat)lineWidth {
    if (_lineWidth != lineWidth) {
        _lineWidth = lineWidth;
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(lineWidth));
        }];
    }
}

- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self menuClick:self.menuViews[index] animated:animated];
    });
}

- (void)setNumbers:(NSArray<NSString *> *)numbers {
    if (self.numLabelArray.count != numbers.count) {
        return;
    }
    for (int i = 0; i < numbers.count; i++) {
        [self setNumber:numbers[i] atIndex:i];
    }
}

- (void)setNumber:(NSString *)number atIndex:(NSInteger)idx {
    idx = MIN(idx, self.numLabelArray.count - 1);
    UILabel *label = self.numLabelArray[idx];
    label.text = number;
    label.hidden = !number.integerValue;
}

- (void)menuClick:(UIView *)menuView animated:(BOOL)animated {
    if (self.selectView != menuView) {
        UILabel *nameLabel = self.selectView.subviews.firstObject;
        nameLabel.textColor = self.defaultColor;
        self.selectView = menuView;
    }
    UILabel *nameLabel = self.selectView.subviews.firstObject;
    nameLabel.textColor = self.selectedColor;
    CGPoint point = CGPointMake(self.selectView.center.x, self.lineView.center.y);
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.lineView.center = point;
        }];
    } else {
        self.lineView.center = point;
    }
}

@end
