//
//  NSNumber+Format.h
//  ZHKit
//
//  Created by Lee on 2016/6/8.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Format)

/**
 格式化输出数字，根据枚举

 @param number 数字
 @param style NSNumberFormatterStyle
                NSNumberFormatterNoStyle = 98764
                NSNumberFormatterCurrencyStyle = US$98,764.12
                NSNumberFormatterDecimalStyle = 98,764.123
                NSNumberFormatterPercentStyle = 9,876,412%
                NSNumberFormatterScientificStyle = 9.876412345E4
                NSNumberFormatterSpellOutStyle = 九万八千七百六十四点一二三四五
                NSNumberFormatterOrdinalStyle = 第9,8764
                NSNumberFormatterCurrencyISOCodeStyle = USD98,764.12end
                NSNumberFormatterCurrencyPluralStyle = 98,764.12美元
                NSNumberFormatterCurrencyAccountingStyle = US$98,764.12
 */
+ (NSString *)stringFromNumber:(NSNumber *)number withStyle:(NSNumberFormatterStyle)style;

/**
 格式化输出数字，自定义格式

 @param number 数字
 @param format 格式：#,###.##，#,###.##%
                    一个#代表一个数字，.后为小数，,分隔数字；如果格式有多个可以用;隔开
 */
+ (NSString *)stringFromNumber:(NSNumber *)number withFormat:(NSString *)format;

@end

