//
//  UITextField+Extend.m
//  CheryNewRetail
//
//  Created by 李志华 on 2019/6/18.
//

#import "UITextField+Extend.h"
#import <objc/runtime.h>

@implementation UITextField (Extend)

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

- (void)setPlaceholder:(NSString *)placeholder color:(UIColor *)color {
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:color}];
}
- (void)setPlaceholder:(NSString *)placeholder font:(UIFont *)font {
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSFontAttributeName:font}];
}
- (void)setPlaceholder:(NSString *)placeholder attributes:(NSDictionary<NSAttributedStringKey, id>*)attributes {
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:attributes];
}


// 基于文首计算出到光标的偏移数值。
- (NSInteger)curOffset
{
    return [self offsetFromPosition:self.beginningOfDocument toPosition:self.selectedTextRange.start];
}

// 实现原理是先获取一个基于文尾的偏移，然后加上要施加的偏移，再重新根据文尾计算位置，最后利用选取来实现光标定位。
- (void)makeOffset:(NSInteger)offset
{
    UITextRange *selectedRange = [self selectedTextRange];
    NSInteger currentOffset = [self offsetFromPosition:self.endOfDocument toPosition:selectedRange.end];
    currentOffset += offset;
    UITextPosition *newPos = [self positionFromPosition:self.endOfDocument offset:currentOffset];
    self.selectedTextRange = [self textRangeFromPosition:newPos toPosition:newPos];
}

// 先把光标移动到文首，然后再调用上面实现的偏移函数。
- (void)makeOffsetFromBeginning:(NSInteger)offset
{
    UITextPosition *begin = self.beginningOfDocument;
    UITextPosition *start = [self positionFromPosition:begin offset:0];
    UITextRange *range = [self textRangeFromPosition:start toPosition:start];
    [self setSelectedTextRange:range];
    [self makeOffset:offset];
}

@end
