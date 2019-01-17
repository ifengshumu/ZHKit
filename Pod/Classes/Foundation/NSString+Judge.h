//
//  NSString+Judge.h
//  ZHKit
//
//  Created by Lee on 2016/6/8.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Judge)
/**
 判断是否是空字符串
 */
+ (BOOL)isBlankString:(NSString *)string;

/**
 是否中文
 */
+ (BOOL)isChinese:(NSString *)string;

/**
 字符串是否只包含字母
 */
+ (BOOL)containsOnlyLetters:(NSString *)string;

/**
 字符串是否只包含数字
 */
+ (BOOL)containsOnlyNumbers:(NSString *)string;

/**
 字符串只包括字母和数字
 */
+ (BOOL)containsOnlyNumbersAndLetters:(NSString *)string;
@end

