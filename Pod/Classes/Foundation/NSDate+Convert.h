//
//  NSDate+Convert.h
//  ZHKit
//
//  Created by Lee on 2016/6/8.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DateConvertStyle) {
    DateConvertStyleDefault = 0,       // yyyy-MM-dd
    DateConvertStyleDefaultH,          // yyyy-MM-dd HH
    DateConvertStyleDefaultHM,         // yyyy-MM-dd HH:mm
    DateConvertStyleDefaultHMS,        // yyyy-MM-dd HH:mm:ss
    
    DateConvertStyleChinese,           // yyyy年MM月dd日
    DateConvertStyleChineseH,          // yyyy年MM月dd日 HH时
    DateConvertStyleChineseHM,         // yyyy年MM月dd日 HH时mm分
    DateConvertStyleChineseHMS,        // yyyy年MM月dd日 HH时mm分ss秒
    
    DateConvertStyleYear,              // yyyy
    DateConvertStyleYearMonth,         // yyyy-MM
    
    DateConvertStyleChineseYear,       // yyyy年
    DateConvertStyleChineseYearMonth,  // yyyy年MM月
};

@interface NSDate (Convert)

#pragma mark - NSDate和NSString互相转换
/**
 NSDate转NSString，根据枚举
 */
+ (NSString *)stringFromDate:(NSDate *)date withStyle:(DateConvertStyle)style;

/**
 NSDate转NSString，自定义转换时间格式
 */
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format;

/**
 NSString转NSDate，根据枚举
 */
+ (NSDate *)dateFromString:(NSString *)string withStyle:(DateConvertStyle)style;

/**
 NSString转NSDate，自定义转换时间格式
 */
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;


#pragma mark - 时间戳转NSDate和NSString
/**
 时间戳转NSString，根据枚举
 */
+ (NSString *)stringFromTimestamp:(long long)timestamp withStyle:(DateConvertStyle)style;

/**
 时间戳转NSString，自定义转换时间格式
 */
+ (NSString *)stringFromTimestamp:(long long)timestamp withFormat:(NSString *)format;

/**
 时间戳转NSDate，根据枚举
 */
+ (NSDate *)dateFromTimestamp:(long long)timestamp withStyle:(DateConvertStyle)style;

/**
 时间戳转NSDate，自定义转换时间格式
 */
+ (NSDate *)dateFromTimestamp:(long long)timestamp withFormat:(NSString *)format;

#pragma mark - NSDate和NSString转时间戳
/**
 NSString转时间戳，根据枚举
 */
+ (long long)timestampFromString:(NSString *)string withStyle:(DateConvertStyle)style;

/**
 NSString转时间戳，自定义转换时间格式
 */
+ (long long)timestampFromString:(NSString *)string withFormat:(NSString *)format;


/**
 NSDate转时间戳，根据枚举
 */
- (long long)timestampFromDate:(NSDate *)date withStyle:(DateConvertStyle)style;

/**
 NSDate转时间戳，自定义转换时间格式
 */
- (long long)timestampFromDate:(NSDate *)date withFormat:(NSString *)format;

@end
