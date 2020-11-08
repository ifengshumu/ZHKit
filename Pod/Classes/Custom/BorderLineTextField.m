//
//  BorderLineTextField.m
//  MFLingLingQi
//
//  Created by Murphy on 16/11/25.
//  Copyright © 2016年 Murphy. All rights reserved.
//

#import "BorderLineTextField.h"

@implementation BorderLineTextField

- (void)dealloc
{
    NSLog(@"文本框释放");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.isChangeBorder = YES;
        self.font = mFont(14);
        self.layer.cornerRadius = frame.size.height/2;
        self.layer.borderWidth = 1/mScale;
        self.layer.borderColor = mRGBlinecolor.CGColor;
        self.textColor = mRGBbfontcolor;
        self.tintColor = mRGBnavcolor;
        self.backgroundColor = mRGBlnavcolor;
        self.clearButtonMode = UITextFieldViewModeAlways;
        self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, W(15), frame.size.height)];
        self.leftViewMode = UITextFieldViewModeAlways;
        
        // 添加通知监听文本状态
        mAddNot(self, textBeginEditing:, UITextFieldTextDidBeginEditingNotification);
        mAddNot(self, textDidEndEditing:, UITextFieldTextDidEndEditingNotification);
    }
    return self;
}

- (void)textBeginEditing:(NSNotification *)note
{
    if (_isChangeBorder == NO)return;
    [self changBorderwithNote:note];
}

- (void)textDidEndEditing:(NSNotification *)note
{
    if (_isChangeBorder == NO)return;
    [self changBorderwithNote:note];
}

- (void)changBorderwithNote:(NSNotification *)editing
{
    if (![editing.object isEqual:self])return;
    if ([editing.name isEqualToString:UITextFieldTextDidBeginEditingNotification])
    {
        self.layer.borderColor = mRGBnavcolor.CGColor;
        
    }else if ([editing.name isEqualToString:UITextFieldTextDidEndEditingNotification])
    {
        self.layer.borderColor = mRGBlinecolor.CGColor;
    }
}

@end
