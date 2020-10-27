// NSString+Extension.h
// Tommy
//
// 字符串扩展方法
//
// Created by KangQiang on 2014-6-9.
// Copyright (c) 2014年 YekuMob.com. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NSString (Extension)

// 将字符串转换为URL地址的编码
- (NSString *)stringUrlEncode;

// 根据文件名生成缓存文件路径
- (NSString *)cacheFilePath;

// 从URL中解析类名
+ (NSString *)classNameFrom:(NSURL *)aURL;

// 安全获取字符串,若字符串为nil，则返回@""，否则直接返回字符串
+ (NSString *)strOrEmpty:(NSString *)mStr;

// 去掉首尾空格
+ (NSString *)stripWhiteSpace:(NSString *)mStr;

// 去掉首尾空格和换行符
+ (NSString *)stripWhiteSpaceAndNewLineCharacter:(NSString *)mStr;

// 获取字符串中的数字
+ (NSString *)getNumFromStr:(NSString *)mStr;

// 添加人民币符号
+ (NSString *)addMoneySymbol:(NSString*)mStr;

// 替换字符串中带双引号的特殊字符
+ (NSString *)htmlShuangyinhao:(NSString *)values;

// 替换(null)、<null>、null 这些特殊字符
+ (NSString *)nullDefultString:(NSString *)fromString null:(NSString *)nullStr;

// 获取某个字符串或者汉字的首字母.
+ (NSString *)firstCharactorWithString:(NSString *)string;

@end



// 去掉首尾空格
extern NSString* stripWhiteSpace(NSString *mStr);

// 去掉首尾空格和换行符
extern NSString* stripWhiteSpaceAndNewLineCharacter(NSString *mStr);

// 获取字符串中的数字
extern NSString* getNumFromStr(NSString *mStr);

// 判断是否手机号码格式
extern BOOL isMobileNumber(NSString *mobileNum);


