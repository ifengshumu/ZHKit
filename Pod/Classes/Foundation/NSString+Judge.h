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

#pragma 正则匹配邮箱号
+ (BOOL)checkMailInput:(NSString *)mail;

#pragma 正则匹配手机号(精确)
+ (BOOL)checkTelNumber:(NSString *)telNumber;

#pragma 正则匹配手机号码验证(初略)
+ (BOOL)checkTelMobile:(NSString *)mobile;

#pragma 正则匹配用户密码6-18位数字和字母组合
+ (BOOL)checkPassword:(NSString *)password;

#pragma 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName : (NSString *)userName;

#pragma 正则匹配用户身份证号
+ (BOOL)checkUserIdCard:(NSString *)idCard;

#pragma 正则匹员工号,12位的数字
+ (BOOL)checkEmployeeNumber:(NSString *)number;

#pragma 正则匹配URL
+ (BOOL)checkURL:(NSString *)url;

#pragma 正则匹配昵称
+ (BOOL)checkNickname:(NSString *)nickname;

#pragma 正则匹配以C开头的18位字符
+ (BOOL)checkCtooNumberTo18:(NSString *)nickNumber;

#pragma 正则匹配以C开头字符
+ (BOOL)checkCtooNumber:(NSString *)nickNumber;

#pragma 正则匹配银行卡号是否正确
+ (BOOL)checkBankNumber:(NSString *)bankNumber;

#pragma 正则匹配17位车架号
+ (BOOL)checkCheJiaNumber:(NSString *)CheJiaNumber;

#pragma 正则只能输入数字和字母
+ (BOOL)checkTeshuZifuNumber:(NSString *)CheJiaNumber;

#pragma 车牌号验证
+ (BOOL)checkCarNumber:(NSString *)CarNumber;

#pragma 车型
+ (BOOL)checkCarType:(NSString *)CarType;

#pragma 如果字符串==nil or @"" 返回 YES or NO
+ (BOOL)checkStringIsEmpty:(NSString *)mStr;

#pragma 是否包含中文字符
+ (BOOL)checkChineseCharacters:(NSString *)text;


@end

