//
//  SearchTextField.m
//  PPYLiFeng
//
//  Created by Murphy on 2020/6/21.
//  Copyright © 2020 Murphy. All rights reserved.
//

#import "SearchTextField.h"


@interface SearchTextField () <UITextFieldDelegate>

@end

@implementation SearchTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.font = mFont(14);
        self.delegate = self;
        self.tintColor = mRGBnavcolor;
        self.layer.cornerRadius = frame.size.height/2;
        self.backgroundColor = mRGBbbackcolor;
        self.returnKeyType = UIReturnKeySearch;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        // 搜索图标
        UIView *left = [UIView new];
        left.width = W(30)+H(30);
        left.height = frame.size.height;
        UIImageView *tipImg = [UIImageView new];
        tipImg.center = CGPointMake(W(30)+H(8), frame.size.height/2);
        tipImg.bounds = CGRectMake(0, 0, H(14), H(14));
        tipImg.image = mImage(@"search");
        [left addSubview:tipImg];
        self.leftView = left;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.searchWithBlock(self);
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.tapWithBlock)
    {
        self.tapWithBlock(YES);
        return NO;
    }
    return YES;
}

@end
