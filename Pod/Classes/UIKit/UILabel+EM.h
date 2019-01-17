//
//  UILabel+EM.h
//  ZHKit
//
//  Created by Lee on 2016/9/29.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (EM)

/**
 计算label内容size，根据固定的宽、字体
 */
+ (CGSize)sizeForContent:(NSString *)content settledWidth:(CGFloat)width font:(UIFont *)font;

/**
 计算label内容size，根据固定的高、字体
 */
+ (CGSize)sizeForContent:(NSString *)content settledHeight:(CGFloat)height font:(UIFont *)font;

/**
 计算label内容size，根据固定的宽、字体、行间距
 */
+ (CGSize)sizeForContent:(NSString *)content settledWidth:(CGFloat)width font:(UIFont *)font lineSpace:(CGFloat)lineSpace;

/**
 计算label内容size，根据固定的高、字体、行间距
 */
+ (CGSize)sizeForContent:(NSString *)content settledHeight:(CGFloat)height font:(UIFont *)font lineSpace:(CGFloat)lineSpace;

/**
 计算label内容size，根据固定的宽、字体、段落格式
 */
+ (CGSize)sizeForContent:(NSString *)content settledWidth:(CGFloat)width font:(UIFont *)font paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle;

/**
 计算label内容size，根据固定的高、字体、段落格式
 */
+ (CGSize)sizeForContent:(NSString *)content settledHeight:(CGFloat)height font:(UIFont *)font paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle;


@end

