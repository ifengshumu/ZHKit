//
//  NSDate+Convert.m
//  ZHKit
//
//  Created by Lee on 2016/6/8.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import "NSDate+Convert.h"
#import "NSDateFormatter+Cache.h"

@implementation NSDate (Convert)

///枚举转时间格式字符串
+ (NSString *)formatFromDateConvertStyle:(DateConvertStyle)style {
    NSString *format = nil;
    switch (style) {
        case DateConvertStyleDefault:
            format = @"yyyy-MM-dd";
            break;
        case DateConvertStyleDefaultH:
            format = @"yyyy-MM-dd HH";
            break;
        case DateConvertStyleDefaultHM:
            format = @"yyyy-MM-dd HH:mm";
            break;
        case DateConvertStyleDefaultHMS:
            format = @"yyyy-MM-dd HH:mm:ss";
            break;
        case DateConvertStyleChinese:
            format = @"yyyy年MM月dd日";
            break;
        case DateConvertStyleChineseH:
            format = @"yyyy年MM月dd日 HH时";
            break;
        case DateConvertStyleChineseHM:
            format = @"yyyy年MM月dd日 HH时mm分";
            break;
        case DateConvertStyleChineseHMS:
            format = @"yyyy年MM月dd日 HH时mm分ss秒";
            break;
        case DateConvertStyleYear:
            format = @"yyyy";
            break;
        case DateConvertStyleYearMonth:
            format = @"yyyy-MM";
            break;
        case DateConvertStyleChineseYear:
            format = @"yyyy年";
            break;
        case DateConvertStyleChineseYearMonth:
            format = @"yyyy年MM月";
            break;
        default:
            format = @"yyyy-MM-dd";
            break;
    }
    return format;
}

#pragma mark - NSDate和NSString互相转换

+ (NSString *)stringFromDate:(NSDate *)date withStyle:(DateConvertStyle)style {
    NSString *format = [NSDate formatFromDateConvertStyle:style];
    NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterWithFormat:format];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterWithFormat:format];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)string withStyle:(DateConvertStyle)style {
    NSString *format = [NSDate formatFromDateConvertStyle:style];
    NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterWithFormat:format];
    return [dateFormatter dateFromString:string];
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterWithFormat:format];
    return [dateFormatter dateFromString:string];
}

#pragma mark - 时间戳转NSDate和NSString

+ (NSString *)stringFromTimestamp:(double)timestamp withStyle:(DateConvertStyle)style {
    if (timestamp == 0) {
        return @"";
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    return [NSDate stringFromDate:date withStyle:style];
}

+ (NSString *)stringFromTimestamp:(double)timestamp withFormat:(NSString *)format {
    if (timestamp == 0) {
        return @"";
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    return [NSDate stringFromDate:date withFormat:format];
}

+ (NSDate *)dateFromTimestamp:(double)timestamp withStyle:(DateConvertStyle)style {
    NSString *string = [NSDate stringFromTimestamp:timestamp withStyle:style];
    return [NSDate dateFromString:string withStyle:style];
}

+ (NSDate *)dateFromTimestamp:(double)timestamp withFormat:(NSString *)format {
    NSString *string = [NSDate stringFromTimestamp:timestamp withFormat:format];
    return [NSDate dateFromString:string withFormat:format];
}

#pragma mark - NSDate和NSString转时间戳

+ (double)timestampFromString:(NSString *)string withStyle:(DateConvertStyle)style {
    NSDate *date = [NSDate dateFromString:string withStyle:style];
    return [date timeIntervalSince1970];
}

+ (double)timestampFromString:(NSString *)string withFormat:(NSString *)format {
    NSDate *date = [NSDate dateFromString:string withFormat:format];
    return [date timeIntervalSince1970];
}

- (double)timestampFromDate:(NSDate *)date withStyle:(DateConvertStyle)style {
    NSString *string = [NSDate stringFromDate:date withStyle:style];
    return [NSDate timestampFromString:string withStyle:style];
}

- (double)timestampFromDate:(NSDate *)date withFormat:(NSString *)format {
    NSString *string = [NSDate stringFromDate:date withFormat:format];
    return [NSDate timestampFromString:string withFormat:format];
}

+ (NSString *)compareNowWithTimestamp:(double)timestamp {
    NSDate *date = [NSDate dateFromTimestamp:timestamp withStyle:DateConvertStyleDefaultHMS];
    return [self compareNowWithDate:date];
}

+ (NSString *)compareNowWithDate:(NSDate *)date {
    NSString *check = nil;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:date];
    NSDateComponents *nowComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:[NSDate date]];
    //本年之前
    if (nowComponents.year > dateComponents.year) {
        check = [NSDate stringFromDate:date withStyle:DateConvertStyleChinese];
    } else {
        BOOL isToday = [[NSCalendar currentCalendar] isDateInToday:date]; //今天
        BOOL isYesterday = [[NSCalendar currentCalendar] isDateInYesterday:date]; //昨天
        if (isToday) {
            NSInteger hour = nowComponents.hour - dateComponents.hour;
            NSInteger minute = nowComponents.minute - dateComponents.minute;
            if (hour == 0) {
                //1小时内
                if (minute < 10) {
                    check = @"刚刚";
                } else {
                    check = [NSString stringWithFormat:@"%02ld分钟前", minute];
                }
            } else {
                //超过一小时
                check = [NSString stringWithFormat:@"%02ld:%02ld", dateComponents.hour, dateComponents.minute];
            }
        } else if (isYesterday) {
            check = [NSString stringWithFormat:@"昨天%02ld:%02ld", dateComponents.hour, dateComponents.minute];
        } else if (nowComponents.month > dateComponents.month || nowComponents.day - dateComponents.day > 1) {
            //昨天之前
            check = [NSDate stringFromDate:date withFormat:@"MM-dd HH:mm"];
        }
    }
    return check;
}


@end
