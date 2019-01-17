//
//  UITextView+EM.m
//  ZHKit
//
//  Created by Lee on 2016/9/29.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import "UITextView+EM.h"
#import <objc/runtime.h>

@interface UITextView ()
@property (nonatomic, strong) UILabel *placeHolderLabel;
@end

@implementation UITextView (EM)
- (void)layoutPlaceHolderLabel {
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    self.placeHolderLabel = placeHolderLabel;
    placeHolderLabel.text = @"请输入内容";
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    [placeHolderLabel sizeToFit];
    [self addSubview:placeHolderLabel];
    [self setValue:placeHolderLabel forKey:@"_placeholderLabel"];
}


- (void)setPlaceHolderLabel:(UILabel *)placeHolderLabel {
    objc_setAssociatedObject(self, @selector(placeHolderLabel), placeHolderLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (!self.placeHolderLabel) {
        [self layoutPlaceHolderLabel];
    }
}
- (UILabel *)placeHolderLabel {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setPlaceholder:(NSString *)placeholder {
    objc_setAssociatedObject(self, @selector(placeholder), placeholder, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.text = placeholder;
    if (!self.placeHolderLabel) {
        [self layoutPlaceHolderLabel];
    }
    self.text = nil;
    self.placeHolderLabel.text = placeholder;
}
- (NSString *)placeholder {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    objc_setAssociatedObject(self, @selector(placeholderColor), placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (!self.placeHolderLabel) {
        [self layoutPlaceHolderLabel];
    }
    self.placeHolderLabel.textColor = placeholderColor;
}
- (UIColor *)placeholderColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    objc_setAssociatedObject(self, @selector(placeholderFont), placeholderFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (!self.placeHolderLabel) {
        [self layoutPlaceHolderLabel];
    }
    self.placeHolderLabel.font = placeholderFont;
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange:) name:UITextViewTextDidChangeNotification object:self];
}
- (NSUInteger)maxLength {
    return [objc_getAssociatedObject(self, _cmd) unsignedIntegerValue];
}
- (void)textViewTextDidChange:(NSNotification *)notify {
    UITextView *textView = notify.object;
    if (textView.text.length > self.maxLength) {
        UITextRange *markedRange = [textView markedTextRange];
        if (markedRange) {
            return;
        }
        NSRange range = [textView.text rangeOfComposedCharacterSequenceAtIndex:self.maxLength];
        textView.text = [textView.text substringToIndex:range.location];
    }
}

@end
