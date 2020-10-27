//
//  NSDate+Extension.m
//  MFSinaForum
//
//  Created by Mengfei on 15/12/7.
//  Copyright © 2015年 KuErXinMiao. All rights reserved.
//

#import "NSDate+Extension.h"

// ios,再见了
@implementation MFDateItem

- (NSString *)description
{
    return [NSString stringWithFormat:@"%zd天%zd小时%zd分%zd秒", self.day, self.hour, self.minute, self.second];
}

@end



@implementation NSDate (Extension)

- (NSString *)prettyDateWithReference:(NSDate *)reference
{
    NSString *suffix = @"前";
    float different = [reference timeIntervalSinceDate:self];
    if (different < 0)
    {
        different = -different;
        suffix = @"之后";
    }
    if (different < 60)
    {
        return @"刚刚";
    }
    if (different < 120)
    {
        return [NSString stringWithFormat:@"1分钟%@", suffix];
    }
    if (different < 60*60)
    {
        return [NSString stringWithFormat:@"%d分钟%@", (int)floor(different / 60), suffix];
    }
    if (different < 7200)
    {
        return [NSString stringWithFormat:@"1小时%@", suffix];
    }else
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MMdd"];
        NSString *refrenceStr = [formatter stringFromDate:reference];
        NSString *createStr = [formatter stringFromDate:self];
        if ([refrenceStr isEqualToString:createStr])
        {
            //  是今天 显示几小时之前
            return [NSString stringWithFormat:@"%d小时%@", (int)floor(different / 3600), suffix];
        }
        //  是昨天
        if ([refrenceStr intValue] - [createStr intValue] == 1)
        {
            [formatter setDateFormat:@"HH:mm"];
            NSString *createStrHour = [formatter stringFromDate:self];
            return [NSString stringWithFormat:@"昨天%@",createStrHour];
        }
        //  更久之前 显示MM－dd
        [formatter setDateFormat:@"yy/MM/dd"];
        NSString *createStrDay = [formatter stringFromDate:self];
        return [NSString stringWithFormat:@"%@",createStrDay];
    }
    return self.description;
}

- (NSString *)prettyDateWithReference2:(NSDate *)reference
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MMdd"];
    NSString *refrenceStr = [formatter stringFromDate:reference];
    NSString *createStr = [formatter stringFromDate:self];
    // 是今天
    if ([refrenceStr isEqualToString:createStr])
    {
        [formatter setDateFormat:@"HH:mm"];
        NSString *createStrHour = [formatter stringFromDate:self];
        return [NSString stringWithFormat:@"%@",createStrHour];
    }
    // 不是今天就显示yy/MM/dd
    [formatter setDateFormat:@"yy/MM/dd"];
    NSString *createStrDay = [formatter stringFromDate:self];
    return [NSString stringWithFormat:@"%@",createStrDay];
}

//  通过时间戳计算什么日期
+ (NSString *)getStringTime:(NSString *)str
{
    NSInteger aaa = [str integerValue];
    NSDate *sss = [NSDate dateWithTimeIntervalSince1970:aaa];
    NSDateFormatter *formatter1=[[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *timeStr = [formatter1 stringFromDate:sss];
    
    return timeStr;
}


// 以秒为单位
+ (NSString *)getNowTimeString
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval unixTime = [date timeIntervalSince1970];
    unixTime = unixTime*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.f",unixTime];    
    return timeString;
}

// 以毫秒为单位
+ (NSString *)getNowTimeTimestamp3
{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // 设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
//    // 设置时区,这个对于时间的处理有时很重要
//    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//    [formatter setTimeZone:timeZone];
//    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval unixTime = [date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.3f",unixTime];
    
    return timeString;
}




// 获取今天周几
- (NSInteger)getNowWeekday
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDate *now = [NSDate date];
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    comps = [calendar components:unitFlags fromDate:now];
    return [comps day];
}


//  时间间隔
- (MFDateItem *)mf_timeIntervalSinceDate:(NSDate *)anotherDate
{
    // createdAtDate和nowDate之间的时间间隔
    NSTimeInterval interval = [self timeIntervalSinceDate:anotherDate];
    
    MFDateItem *item = [[MFDateItem alloc] init];
    
    // 相差多少天
    int intInterval = (int)interval;
    int secondsPerDay = 24 * 3600;
    item.day = intInterval / secondsPerDay;
    
    // 相差多少小时
    int secondsPerHour = 3600;
    item.hour = (intInterval % secondsPerDay) / secondsPerHour;
    
    // 相差多少分钟
    int secondsPerMinute = 60;
    item.minute = ((intInterval % secondsPerDay) % secondsPerHour) / secondsPerMinute;
    
    // 相差多少秒
    item.second = ((intInterval % secondsPerDay) % secondsPerHour) % secondsPerMinute;
    
    return item;
}



// 判断self这个日期对象是否为今天
- (BOOL)isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 如果selfCmps和nowCmps的所有元素都一样，就返回YES，否则返回NO
    return [selfCmps isEqual:nowCmps];
//    return selfCmps.year == nowCmps.year
//    && selfCmps.month == nowCmps.month
//    && selfCmps.day == nowCmps.day;
}

// 判断self这个日期对象是否为昨天
- (BOOL)isYesterday
{
    // self 2015-12-09 22:10:01 -> 2015-12-09 00:00:00
    // now  2015-12-10 12:10:01 -> 2015-12-01 00:00:00
    // 昨天：0year 0month 1day 0hour 0minute 0second
    // NSDate * -> NSString * -> NSDate *
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    
    // 生成只有年月日的字符串对象
    NSString *selfString = [fmt stringFromDate:self];
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    
    // 生成只有年月日的日期对象
    NSDate *selfDate = [fmt dateFromString:selfString];
    NSDate *nowDate = [fmt dateFromString:nowString];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [calendar components:unit fromDate:selfDate toDate:nowDate options:0];
    return cmps.year == 0
    && cmps.month == 0
    && cmps.day == 1;
}

- (BOOL)isTomorrow
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    
    // 生成只有年月日的字符串对象
    NSString *selfString = [fmt stringFromDate:self];
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    
    // 生成只有年月日的日期对象
    NSDate *selfDate = [fmt dateFromString:selfString];
    NSDate *nowDate = [fmt dateFromString:nowString];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [calendar components:unit fromDate:selfDate toDate:nowDate options:0];
    return cmps.year == 0
    && cmps.month == 0
    && cmps.day == -1;
}

// 判断self这个日期对象是否为今年
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger selfYear = [calendar components:NSCalendarUnitYear fromDate:self].year;
    NSInteger nowYear = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]].year;
    
    return selfYear == nowYear;
}



// 根据date获取当月周几
+ (NSInteger)convertDateToFirstWeekDay:(NSString *)timeStr
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    NSDate *selfDate = [fmt dateFromString:timeStr];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:selfDate];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;  //美国时间周日为星期的第一天，所以周日-周六为1-7，改为0-6方便计算
}

// 根据date获取当月总天数
+ (NSInteger)convertDateToTotalDays:(NSString *)timeStr
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    NSDate *selfDate = [fmt dateFromString:timeStr];
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:selfDate];
    return daysInOfMonth.length;
}

// 计算某个月有几周
+ (NSInteger)getHowWeekByYearMonthDayString:(NSString *)timeStr
{
    NSInteger fristDayWeek = [NSDate convertDateToFirstWeekDay:timeStr];
    NSInteger allDay = [NSDate convertDateToTotalDays:timeStr];
    if (fristDayWeek == 1 && allDay == 28)
    {
        return 4;
    }
    if (allDay == 31)
    {
        if (fristDayWeek == 6 || fristDayWeek == 0)
        {
            return 6;
        }
    }
    if (allDay == 30)
    {
        if (fristDayWeek == 0)
        {
            return 6;
        }
    }
    return 5;
}

// 获取当前所在的年、月、周
+ (NSDictionary *)getNowYearMonthWeekAndWeekNumOfMonth
{
    // 获取代表公历的NSCalendar对象
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | kCFCalendarUnitWeekday | kCFCalendarUnitWeekdayOrdinal | kCFCalendarUnitWeekOfMonth | kCFCalendarUnitDay;
    NSDateComponents *comp = [gregorian components:unitFlags fromDate:[NSDate date]];
    NSString *year = [NSString stringWithFormat:@"%ld",comp.year];
    NSString *month = [NSString stringWithFormat:@"%ld",comp.month];
    NSString *week = [NSString stringWithFormat:@"%ld",comp.weekOfMonth];
    
    NSString *timeStr = [NSString stringWithFormat:@"%ld%02ld01",[year integerValue],[month integerValue]];
    NSInteger fristDayWeek = [NSDate convertDateToFirstWeekDay:timeStr];
    NSInteger weekNum = [NSDate getHowWeekByYearMonthDayString:timeStr];
    fristDayWeek = fristDayWeek == 0 ? 7 : fristDayWeek;
    if (fristDayWeek == 7)
    {
        if (comp.day != 1)
        {
            if (comp.weekday != 1)
            {
                week = [NSString stringWithFormat:@"%ld",[week integerValue]+1];
            }
        }
    }
    NSString *weekNumStr = [NSString stringWithFormat:@"%ld",weekNum];
    return @{@"year":year, @"month":month, @"week":week, @"weekNum":weekNumStr};
}

// 获取当前月、天
+ (NSDictionary *)getNowMonthAndDay
{
    // 获取代表公历的NSCalendar对象
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | kCFCalendarUnitWeekday | kCFCalendarUnitWeekdayOrdinal | kCFCalendarUnitWeekOfMonth | kCFCalendarUnitDay;
    NSDateComponents *comp = [gregorian components:unitFlags fromDate:[NSDate date]];
    NSString *month = [NSString stringWithFormat:@"%ld",comp.month];
    NSString *day = [NSString stringWithFormat:@"%ld",comp.day];
    return @{@"month":month, @"day":day};
}

@end

