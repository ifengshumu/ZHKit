//
//  NSDate+Extension.h
//  MFSinaForum
//
//  Created by Mengfei on 15/12/7.
//  Copyright © 2015年 KuErXinMiao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MFDateItem : NSObject

@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minute;
@property (nonatomic, assign) NSInteger second;
//  时间间隔
@property (nonatomic, copy, readonly) NSString *description;

@end


@interface NSDate (Extension)

// 对比当前时间,获取传入时间的状态(刚刚,1分钟前,1小时前等...)
- (NSString *)prettyDateWithReference:(NSDate *)reference;

// 对比当前时间,获取传入时间的状态(刚刚,1分钟前,1小时前等...)
- (NSString *)prettyDateWithReference2:(NSDate *)reference;

//  通过时间戳计算什么日期
+ (NSString *)getStringTime:(NSString *)str;


//  获取当前时间(时间戳)
+ (NSString *)getNowTimeString;

// 以毫秒为单位
+ (NSString *)getNowTimeTimestamp3;



// 获取今天周几
- (NSInteger)getNowWeekday;

//  时间间隔
- (MFDateItem *)mf_timeIntervalSinceDate:(NSDate *)anotherDate;

- (BOOL)isToday;
- (BOOL)isYesterday;
- (BOOL)isTomorrow;
- (BOOL)isThisYear;


// 根据date获取当月周几
+ (NSInteger)convertDateToFirstWeekDay:(NSString *)timeStr;
// 根据date获取当月总天数
+ (NSInteger)convertDateToTotalDays:(NSString *)timeStr;
// 计算某个月有几周
+ (NSInteger)getHowWeekByYearMonthDayString:(NSString *)timeStr;
// 获取当前所在的年、月、周
+ (NSDictionary *)getNowYearMonthWeekAndWeekNumOfMonth;
// 获取当前月、天
+ (NSDictionary *)getNowMonthAndDay;

@end
