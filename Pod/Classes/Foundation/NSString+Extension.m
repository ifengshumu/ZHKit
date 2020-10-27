/**
 *  NSString+Extension.m
 *  Tommy
 *
 *  字符串扩展方法
 *
 *  Created by KangQiang on 2014-6-9.
 *  Copyright (c) 2014年 YekuMob.com. All rights reserved.
 */

#import "NSString+Extension.h"


@implementation NSString (Extension)

// 将字符串转换为URL地址的编码
- (NSString *)stringUrlEncode
{
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    char sourceLen = strlen((const char *)source);
    
    for (int i = 0; i < sourceLen; ++i)
    {
        const unsigned char thisChar = source[i];
        if ( thisChar == ' ')
        {
            [output appendString:@"+"];
        }else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                 (thisChar >= 'a' && thisChar <= 'z') ||
                 (thisChar >= 'A' && thisChar <= 'Z') ||
                 (thisChar >= '0' && thisChar <= '9'))
        {
            [output appendFormat:@"%c", thisChar];
        }else
        {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

#pragma mark - 设置缓存路径
- (NSString *)cacheFilePath
{
    NSArray *psths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [psths objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingPathComponent:self];
}

#pragma mark - 从URL中解析类名称
+ (NSString *)classNameFrom:(NSURL *)aURL
{
    NSString *className = nil;
    NSArray *pathCompones = [aURL pathComponents];
    assert([pathCompones count] > 0);
    
    if ( [pathCompones count] > 1 )
    {
        className = [pathCompones objectAtIndex:1];
    }
    
    return className.length > 0 ? className : @"";
}


// 安全获取字符串,若字符串为nil，则返回@""，否则直接返回字符串
+ (NSString *)strOrEmpty:(NSString *)mStr
{
    return (!mStr || [mStr class] == [NSNull class] ) ? @"": mStr;
}

// 去掉首尾空格
+ (NSString *)stripWhiteSpace:(NSString *)mStr
{
    return [mStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

// 去掉首尾空格和换行符
+ (NSString *)stripWhiteSpaceAndNewLineCharacter:(NSString *)mStr
{
    return [mStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

// 获取字符串中的数字
+ (NSString *)getNumFromStr:(NSString *)mStr
{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *resultStr = [[mStr componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return resultStr;
}

// 添加人民币符号
+ (NSString *)addMoneySymbol:(NSString*)mStr
{
    return [NSString stringWithFormat:@"￥%.2f",[[NSString strOrEmpty:mStr] floatValue]];
}

+ (NSString *)nullDefultString:(NSString *)fromString null:(NSString *)nullStr
{
    if ([fromString isEqualToString:@""] || [fromString isEqualToString:@"(null)"] || [fromString isEqualToString:@"<null>"] || [fromString isEqualToString:@"null"] || fromString==nil)
    {
        return nullStr;
    }else
    {
        return fromString;
    }
}

+ (NSString *)htmlShuangyinhao:(NSString *)values
{
    if (values == nil)
    {
        return @"";
    }
    /*
     字符串的替换
     注：将字符串中的参数进行替换
     参数1：目标替换值
     参数2：替换成为的值
     参数3：类型为默认：NSLiteralSearch
     参数4：替换的范围
     */
    NSMutableString *temp = [NSMutableString stringWithString:values];
    [temp replaceOccurrencesOfString:@"\"" withString:@"'" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"\r" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    return temp;
}

// 获取某个字符串或者汉字的首字母.
+ (NSString *)firstCharactorWithString:(NSString *)string
{
    NSMutableString *str = [NSMutableString stringWithString:string];
    CFStringTransform((CFMutableStringRef) str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pinYin = [str capitalizedString];
    return [pinYin substringToIndex:1];
}

@end


#pragma mark - 若字符串为nil，则返回空字符串，否则直接返回字符串
inline NSString* strOrEmpty(NSString *mStr)
{
    return (mStr==nil?@"":mStr);
}

#pragma mark - 去掉首尾空格的字符串
inline NSString* stripWhiteSpace(NSString *str)
{
	return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

#pragma mark - 去掉首尾空格和换行符的字符串
inline NSString* stripWhiteSpaceAndNewLineCharacter(NSString *str)
{
	return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark - 筛选出字符串中的数字，并依次拼接起来
inline NSString* getNumFromStr(NSString *mStr)
{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *resultStr = [[mStr componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return resultStr;
}


