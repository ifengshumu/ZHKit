//
//  NSString+Judge.m
//  ZHKit
//
//  Created by Lee on 2016/6/8.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import "NSString+Judge.h"

#define HANZI_START 19968
#define HANZI_COUNT 20902

@implementation NSString (Judge)

+ (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isKindOfClass:[NSString class]]) {
        if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isChinese:(NSString *)string {
    if ([NSString isBlankString:string]) {
        return NO;
    }
    NSUInteger length = [string length];
    for(int i = 0; i < length; i++) {
        int charact = [string characterAtIndex:i];
        if((charact >= 0x4e00 && charact <= 0x9fff) || (charact >= 0x3400 && charact <= 0x4db5) || (charact >= 0xe815 && charact <= 0xe864) || (charact >= 0xd840 && charact <= 0xd875) || (charact >= 0xdc00 && charact <= 0xdfff)){
            continue;
        } else {
            return NO;
        }
    }
    //汉字为3个字节
    const char  *cString = [string UTF8String];
    if (strlen(cString) == 3) {
        return YES;
    }
    return YES;
}

+ (BOOL)containsOnlyLetters:(NSString *)string {
    if ([NSString isBlankString:string]) {
        return NO;
    }
    NSCharacterSet *letterCharacterset = [[NSCharacterSet letterCharacterSet] invertedSet];
    return ([string rangeOfCharacterFromSet:letterCharacterset].location == NSNotFound);
}

+ (BOOL)containsOnlyNumbers:(NSString *)string {
    if ([NSString isBlankString:string]) {
        return NO;
    }
    NSCharacterSet *numbersCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    return ([string rangeOfCharacterFromSet:numbersCharacterSet].location == NSNotFound);
}

+ (BOOL)containsOnlyNumbersAndLetters:(NSString *)string {
    if ([NSString isBlankString:string]) {
        return NO;
    }
    NSCharacterSet *numAndLetterCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return ([string rangeOfCharacterFromSet:numAndLetterCharSet].location == NSNotFound);
}

#pragma 正则匹配邮箱号
+ (BOOL)checkMailInput:(NSString *)mail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:mail];
}

#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *)telNumber
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,183,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[356])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181(增加)
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:telNumber] == YES)
        || ([regextestcm evaluateWithObject:telNumber] == YES)
        || ([regextestct evaluateWithObject:telNumber] == YES)
        || ([regextestcu evaluateWithObject:telNumber] == YES))
    {
        return YES;
    }else
    {
        return NO;
    }
}

// 手机号码验证
+ (BOOL)checkTelMobile:(NSString *)mobile
{
    // 手机号以1只限制1开头，其他不限制
    NSString *phoneRegex = @"^(1[1-9])\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}


#pragma 正则匹配用户密码6-18位数字和字母组合
+ (BOOL)checkPassword:(NSString *)password
{
//    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}

#pragma 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName:(NSString *)userName
{
    NSString *pattern = @"^[A-Za-z0-9]{6,20}+$";
//    NSString *pattern = @"^([\u4e00-\u9fa5]+|([a-zA-Z]+\s?)+)$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:userName];
    return isMatch;
}


#pragma 正则匹配用户身份证号15或18位
+ (BOOL)checkUserIdCard:(NSString *)idCard
{
    BOOL flag;
    if (idCard.length <= 0)
    {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}

#pragma 正则匹员工号,12位的数字
+ (BOOL)checkEmployeeNumber:(NSString *)number
{
    NSString *pattern = @"^[0-9]{12}";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:number];
    return isMatch;
}

#pragma 正则匹配URL
+ (BOOL)checkURL:(NSString *)url
{
    NSString *pattern = @"^[0-9A-Za-z]{1,50}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:url];
    return isMatch;
}

#pragma 正则匹配昵称
+ (BOOL)checkNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    BOOL isMatch = [pred evaluateWithObject:nickname];
    return isMatch;
}

#pragma 正则匹配以C开头的18位字符
+ (BOOL)checkCtooNumberTo18:(NSString *)nickNumber
{
    NSString *nickNum=@"^C{1}[0-9]{18}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nickNum];
    BOOL isMatch = [pred evaluateWithObject:nickNumber];
    return isMatch;
}

#pragma 正则匹配以C开头字符
+ (BOOL)checkCtooNumber:(NSString *)nickNumber
{
    NSString *nickNum=@"^C{1}[0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nickNum];
    BOOL isMatch = [pred evaluateWithObject:nickNumber];
    return isMatch;
}

#pragma 正则匹配银行卡号是否正确
+ (BOOL)checkBankNumber:(NSString *)bankNumber
{
    NSString *bankNum=@"^([0-9]{16}|[0-9]{19})$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",bankNum];
    BOOL isMatch = [pred evaluateWithObject:bankNumber];
    return isMatch;
}

#pragma 正则匹配17位车架号
+ (BOOL)checkCheJiaNumber:(NSString *)CheJiaNumber
{
    NSString *bankNum=@"^(\\d{17})$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",bankNum];
    BOOL isMatch = [pred evaluateWithObject:CheJiaNumber];
    return isMatch;
}

#pragma 正则只能输入数字和字母
+ (BOOL)checkTeshuZifuNumber:(NSString *)CheJiaNumber
{
    NSString *bankNum=@"^[A-Za-z0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",bankNum];
    BOOL isMatch = [pred evaluateWithObject:CheJiaNumber];
    return isMatch;
}

#pragma 车牌号验证
+ (BOOL)checkCarNumber:(NSString *)CarNumber
{
    NSString *bankNum = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",bankNum];
    BOOL isMatch = [pred evaluateWithObject:CarNumber];
    return isMatch;
}

#pragma 车型
+ (BOOL)checkCarType:(NSString *)CarType
{
    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarTypeRegex];
    return [carTest evaluateWithObject:CarType];
}

#pragma 如果字符串==nil or @"" 返回 YES or NO
+ (BOOL)checkStringIsEmpty:(NSString *)mStr
{
    BOOL ret=NO;
    if(mStr==nil)
    {
        ret=YES;
    }else
    {
        NSString * temp=[mStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([temp length]<1)
        {
            ret=YES;
        }
    }
    return ret;
}

#pragma 是否包含中文字符
+ (BOOL)checkChineseCharacters:(NSString *)text
{
    for(int i = 0; i < [(NSString *)text length]; ++i)
    {
        int a = [(NSString *)text characterAtIndex:i];
        
        if ([self isChineseCharacters_utf8:a])
        {
            return YES;
        }else
        {
            continue;
        }
    }
    return NO;
}

+ (BOOL)isChineseCharacters_utf8:(NSInteger)characterAtIndex
{
    if(characterAtIndex >= HANZI_START && characterAtIndex <= HANZI_COUNT+HANZI_START)
    {
        return YES;
    }else
    {
        return NO;
    }
}


@end
