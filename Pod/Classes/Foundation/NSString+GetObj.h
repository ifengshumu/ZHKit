//
//  NSString+GetObj.h
//  ZHKit
//
//  Created by Lee on 2016/6/8.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (GetObj)
/**
 从字符串中获取数字
 */
+ (NSString *)getNumberFromString:(NSString *)string;

/**
 移除子字符串
 */
+ (NSString *)removeSubString:(NSString *)subString fromString:(NSString *)string;

/**
 去掉两端的空格
 */
+ (NSString *)removeInclusiveSpaceString:(NSString *)string;

/**
 去掉多余的空格
 */
+ (NSString *)removeExtraSpaceString:(NSString *)string;

/**
 阿拉伯数字转成汉字小写(1234 -> 一二三四)
 */
+ (NSString *)chineseLowercaseNumber:(long long)string;

/**
 阿拉伯数字转成汉字大写(3564 -> 叁仟伍佰陆拾肆)
 */
+ (NSString *)chineseCapitalNumber:(long long)string;

/**
 编码

 @param string 要编码的字符串
 @param characters 需要编码的字符
 */
+ (NSString *)encodeString:(NSString *)string withCharacters:(NSString *)characters;

/**
 编码url
 */
+ (NSString *)encodedURL:(NSString *)string;

/**
 解码url
 */
+ (NSString *)decodedURL:(NSString *)string;

/**
 移除特殊字符串
 */
+ (NSString *)removeCharactersForString:(NSString *)string;

/**
 移除特殊字符串，指定要特殊字符串
 @param character 特殊字符串
 */
+ (NSString *)removeCharacters:(NSString *)character forString:(NSString *)string;

/**
 汉字转拼音
 */
+ (NSString *)pinYin:(NSString *)string;

/**
 汉字字符串中第一个汉字的大写拼音首字母
 */
+ (NSString *)firstWordUpperCaseChinese:(NSString *)string;

/**
 汉字字符串的大写拼音首字母
 */
+ (NSString *)allFirstWordUpperCaseChinese:(NSString *)string;

/**
 从身份证号中获取出生年月日
 */
+ (NSString *)birthdayFromIDCard:(NSString *)idCard;

/**
 从身份证号中获取性别
 */
+ (NSString *)genderFromIDCard:(NSString *)idCard;

/**
 反转字符串
 */
+ (NSString *)reverseString:(NSString *)string;

/**
 根据文件url 返回对应的MIMEType
 */
+ (NSString *)MIMEType:(NSString *)string;

/**
 根据文件url后缀 返回对应的MIMEType
 */
+ (NSString *)MIMETypeForExtension:(NSString *)extension;

/**
 常见MIME集合
 */
+ (NSDictionary *)MIMEDictionary;
@end

