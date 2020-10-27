//
//  NSString+Ext.h
//  MFShowcaseImage
//
//  Created by Mengfei on 16/5/13.
//  Copyright © 2016年 XinMiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Ext)

// 获取字符串宽度
+ (float)getStrwidth:(NSString *)aTip height:(CGFloat)aHeight font:(UIFont *)aFont;

// 获取字符串高度
+ (float)getStrHeight:(NSString *)aTip width:(CGFloat)aWidth font:(UIFont *)aFont;

// 得到带首行缩进字符串的高度
+ (float)getStrAttHeight:(NSString *)aTip width:(CGFloat)aWidth font:(UIFont *)aFont isHideRow:(BOOL)isHideRow indent:(CGFloat)indent lineSpace:(CGFloat)lineSpace;

// 设置行间距和首行缩进
+ (NSMutableAttributedString *)getAttrString:(NSString *)aTip font:(UIFont *)aFont isHideRow:(BOOL)isHideRow indent:(CGFloat)indent lineSpace:(CGFloat)lineSpace;



//  通过时间戳计算距离现在多久
+ (NSString *)nowTime:(NSString *)str;

//  得到当前时间戳
+ (NSString *)getNowTimeString;

//  得到当前日期
+ (NSString *)getNowTime;

//  给定一个时间戳，判断是否超过有效期（yyyy-MM-dd HH:mm）
+ (BOOL)isoverWithDate:(NSString *)dateStr;

//  省份市区  去掉最后的省和市的字眼
- (NSString *)setProvinceAndCity;

//  同时含有数字和字母的判断
- (int)checkIsHaveNumAndLetter;

//  根据文件名计算出文件大小
- (unsigned long long)lx_fileSize;

//  生成缓存目录全路径
- (instancetype)cacheDir;

//  生成文档目录全路径
- (instancetype)docDir;

//  生成临时目录全路径
- (instancetype)tmpDir;

//  判断字符串中是否有中文
- (BOOL)isHaveChinese;

//  取本地json数据
+ (NSArray *)loadFileFromeBundle:(NSString *)documentTitle;

//  计算两个经纬度之间的距离
+ (double)distanceBetweenOrderBy:(double)lat1 :(double)lat2 :(double)lng1 :(double)lng2;

// 获取字符串中的电话号码
+ (NSArray *)checkAllTelArr:(NSString *)string;

@end
