//
//  SPTextField.m
//  
//
//  Created by 李志华 on 2019/12/18.
//

#import "SPTextField.h"

@implementation SPTextField

//显示时 位置及显示范围（显示范围0-clearButton.x）
- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect rect = [super textRectForBounds:bounds];
    CGRect clear = [self clearButtonRectForBounds:bounds];
    return CGRectMake(0, rect.origin.y, CGRectGetMidX(clear) - 3, rect.size.height);
}
//编辑时 位置及显示范围（显示范围0-clearButton.x）
- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect rect = [super editingRectForBounds:bounds];
    CGRect clear = [self clearButtonRectForBounds:bounds];
    return CGRectMake(0, rect.origin.y, CGRectGetMidX(clear) - 3, rect.size.height);
}
//清除按钮 位置及显示范围（向左移动+间距）
- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    CGRect rect = [super clearButtonRectForBounds:bounds];
    return CGRectOffset(rect, -(CGRectGetWidth(rect) + 10), 0);
}
//左视图 位置 及 显示范围 (移到rightView位置，充当rightView)
- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    CGRect rect = [super leftViewRectForBounds:bounds];
    return CGRectOffset(rect, CGRectGetWidth(self.frame) - CGRectGetWidth(rect), 0);
}

@end
