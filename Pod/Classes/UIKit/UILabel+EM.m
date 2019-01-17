//
//  UILabel+EM.m
//  ZHKit
//
//  Created by Lee on 2016/9/29.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import "UILabel+EM.h"

@implementation UILabel (EM)

+ (CGSize)sizeForContent:(NSString *)content settledWidth:(CGFloat)width font:(UIFont *)font {
    return [UILabel calculateSizeWithContent:content size:CGSizeMake(width, MAXFLOAT) font:font paragraphStyle:nil];
}

+ (CGSize)sizeForContent:(NSString *)content settledHeight:(CGFloat)height font:(UIFont *)font {
    return [UILabel calculateSizeWithContent:content size:CGSizeMake(MAXFLOAT, height) font:font paragraphStyle:nil];
}

+ (CGSize)sizeForContent:(NSString *)content settledWidth:(CGFloat)width font:(UIFont *)font lineSpace:(CGFloat)lineSpace {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpace;
    return [UILabel calculateSizeWithContent:content size:CGSizeMake(width, MAXFLOAT) font:font paragraphStyle:style];
}

+ (CGSize)sizeForContent:(NSString *)content settledHeight:(CGFloat)height font:(UIFont *)font lineSpace:(CGFloat)lineSpace {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpace;
    return [UILabel calculateSizeWithContent:content size:CGSizeMake(MAXFLOAT, height) font:font paragraphStyle:style];
}

+ (CGSize)sizeForContent:(NSString *)content settledWidth:(CGFloat)width font:(UIFont *)font paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle {
    return [UILabel calculateSizeWithContent:content size:CGSizeMake(width, MAXFLOAT) font:font paragraphStyle:paragraphStyle];
}

+ (CGSize)sizeForContent:(NSString *)content settledHeight:(CGFloat)height font:(UIFont *)font paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle {
    return [UILabel calculateSizeWithContent:content size:CGSizeMake(MAXFLOAT, height) font:font paragraphStyle:paragraphStyle];
}


+ (CGSize)calculateSizeWithContent:(NSString *)content size:(CGSize)size font:(UIFont *)font paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle {
    
    NSMutableDictionary *attributesDic = [NSMutableDictionary dictionaryWithCapacity:0];
    attributesDic[NSFontAttributeName] = font;
    attributesDic[NSParagraphStyleAttributeName] = paragraphStyle;
    
    CGSize cSize =[content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:attributesDic context:nil].size;
    
    return CGSizeMake(ceil(cSize.width), ceil(cSize.height));
}

@end
