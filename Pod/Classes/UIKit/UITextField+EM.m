//
//  UITextField+EM.m
//  ZHKit
//
//  Created by Lee on 2016/9/29.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import "UITextField+EM.h"
#import <objc/runtime.h>

@implementation UITextField (EM)
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    objc_setAssociatedObject(self, @selector(placeholderColor), placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
}

- (UIColor *)placeholderColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    objc_setAssociatedObject(self, @selector(placeholderFont), placeholderFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setValue:placeholderFont forKeyPath:@"_placeholderLabel.font"];
}

- (UIFont *)placeholderFont {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCursorColor:(UIColor *)cursorColor {
    objc_setAssociatedObject(self, @selector(cursorColor), cursorColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.tintColor = cursorColor;
}

- (UIColor *)cursorColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setMaxLength:(NSUInteger)maxLength {
    objc_setAssociatedObject(self, @selector(maxLength), @(maxLength), OBJC_ASSOCIATION_ASSIGN);
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
- (NSUInteger)maxLength {
    return [objc_getAssociatedObject(self, _cmd) unsignedIntegerValue];
}
- (void)textFieldDidChange:(UITextField *)textField {
    if (textField.text.length > self.maxLength) {
        UITextRange *markedRange = [textField markedTextRange];
        if (markedRange) {
            return;
        }
        NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:self.maxLength];
        textField.text = [textField.text substringToIndex:range.location];
    }
}

@end
