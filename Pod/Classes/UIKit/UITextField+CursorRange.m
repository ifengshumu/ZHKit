//
//  UITextField+CursorRange.m
//  PPYLingLingQi
//
//  Created by Murphy on 2018/7/26.
//  Copyright © 2018年 Murphy. All rights reserved.
//

#import "UITextField+CursorRange.h"

@implementation UITextField (CursorRange)

- (NSRange)selectedRange
{
    UITextPosition* beginning = self.beginningOfDocument;
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

- (void)setSelectedRange:(NSRange)range
{
    UITextPosition* beginning = self.beginningOfDocument;
    UITextPosition* startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectionRange];
}


- (CGFloat)cursorOffset
{
    NSArray *textrect = [self selectionRectsForRange:[self selectedTextRange]];
    CGRect rect = ((UITextSelectionRect *)textrect[0]).rect;
    
    if (rect.origin.x > 100000)
    {
        CGSize size = [self boundingRectWithSize:CGSizeMake(0, CGRectGetHeight(self.frame))];
        if (self.textAlignment == NSTextAlignmentCenter)
        {
            CGSize size = [self boundingRectWithSize:CGSizeMake(0, CGRectGetHeight(self.frame))];
            CGFloat width = CGRectGetWidth(self.frame);
            return width - (width - size.width)/2.0f;
        }else if (self.textAlignment == NSTextAlignmentRight)
        {
            return CGRectGetWidth(self.frame);
        }else
        {
            return size.width;
        }
    }
    return rect.origin.x;
}

- (NSMutableArray *)cursorOffsetArr
{
    NSMutableArray *cursorOffsetArr = [NSMutableArray array];
    for (int i = 0; i < self.text.length+1; i++)
    {
        UITextPosition *beginning = self.beginningOfDocument;
        UITextPosition *start = [self positionFromPosition:beginning offset:i];
        UITextPosition *end = [self positionFromPosition:beginning offset:i];
        UITextRange *textRange = [self textRangeFromPosition:start toPosition:end];
        NSArray *textrect = [self selectionRectsForRange:textRange];
        CGRect rect = ((UITextSelectionRect *)textrect[0]).rect;
        if (rect.origin.x > 100000)
        {
            CGSize size = [self boundingRectWithSize:CGSizeMake(0, CGRectGetHeight(self.frame))];
            if (self.textAlignment == NSTextAlignmentCenter)
            {
                CGSize size = [self boundingRectWithSize:CGSizeMake(0, CGRectGetHeight(self.frame))];
                CGFloat width = CGRectGetWidth(self.frame);
                NSNumber *oneChar_X = [NSNumber numberWithFloat:width - (width - size.width)/2.0f];
                [cursorOffsetArr addObject:oneChar_X];
                continue;
            }else if (self.textAlignment == NSTextAlignmentRight)
            {
                NSNumber *oneChar_X = [NSNumber numberWithFloat:CGRectGetWidth(self.frame)];
                [cursorOffsetArr addObject:oneChar_X];
                continue;
            }else
            {
                NSNumber *oneChar_X = [NSNumber numberWithFloat:size.width];
                [cursorOffsetArr addObject:oneChar_X];
                continue;
            }
        }
        NSNumber *oneChar_X = [NSNumber numberWithFloat:rect.origin.x];
        [cursorOffsetArr addObject:oneChar_X];
    }
    return cursorOffsetArr;
}


- (CGSize)boundingRectWithSize:(CGSize)size
{
//    NSLog(@"333 =");
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}



@end
