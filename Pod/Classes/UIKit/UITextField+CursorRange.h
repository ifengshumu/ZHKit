//
//  UITextField+CursorRange.h
//  PPYLingLingQi
//
//  Created by Murphy on 2018/7/26.
//  Copyright © 2018年 Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (CursorRange)

// 光标的位置
- (NSRange)selectedRange;

- (void)setSelectedRange:(NSRange)range;

// 光标的坐标
- (CGFloat)cursorOffset;


- (NSMutableArray *)cursorOffsetArr;

@end
