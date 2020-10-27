//
//  NSString+DDAdd.m


#import "NSString+DDAdd.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (DDAdd)


+ (NSString *)documentPath{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)cachePath{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString*)getSecrectStringWithPhoneNumber:(NSString*)phoneNum{
    if (phoneNum.length == 11) {
        NSMutableString *newStr = [NSMutableString stringWithString:phoneNum];
        NSRange range = NSMakeRange(3, 4);
        [newStr replaceCharactersInRange:range withString:@"****"];
        return newStr;
    }
    return nil;
}

+ (NSString*)separatePhoneNumber:(NSString*)phoneNum {
    if (phoneNum.length == 11) {
        NSMutableString *phone = [NSMutableString stringWithString:phoneNum];
        [phone insertString:@" " atIndex:3];
        [phone insertString:@" " atIndex:8];
        return phone.copy;
    }
    return phoneNum;
}

- (NSString *)deleteBlankSpace{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (BOOL)isValidMobileNumber {
    NSString* const MOBILE = @"^1[3-9][0-9]{9}$";
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isValidEmail{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
    
}

- (BOOL)isValidPassword {
    NSString *pwd = @"^(?![A-Za-z]+$)(?!\\d+$)(?![\\W_]+$)\\S{8,16}$";
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwd];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isValidIdentifyFifteen{
    NSString * identifyTest=@"^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$";
    NSPredicate*identifyPredicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",identifyTest];
    return [identifyPredicate evaluateWithObject:self];
}

- (BOOL)isValidIdentifyEighteen{
    NSString * identifyTest=@"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$";
    NSPredicate*identifyPredicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",identifyTest];
    return [identifyPredicate evaluateWithObject:self];
}

- (BOOL)isEnglish {
    NSString *match = @"(^[a-zA-Z]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isChinses {
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isValidName {
    if ([self isKindOfClass:NSString.class]) {
        NSString *match = @"^([\\u4e00-\\u9fa5·?]{2,50}|[a-zA-Z0-9\\s\\·\\-\\•]{2,50})$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
        return [predicate evaluateWithObject:self];
    }
    return NO;
}

- (NSString *)md5WithString{
    if (self==nil || [self length] == 0) {
        return nil;
    }
    const char *value = [self UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
//    return [NSString stringWithFormat:
//
//        @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
//
//        outputBuffer[0], outputBuffer[1], outputBuffer[2], outputBuffer[3],
//
//        outputBuffer[4], outputBuffer[5], outputBuffer[6], outputBuffer[7],
//
//        outputBuffer[8], outputBuffer[9], outputBuffer[10], outputBuffer[11],
//
//        outputBuffer[12], outputBuffer[13], outputBuffer[14], outputBuffer[15]
//
//        ];
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [outputString appendFormat:@"%02x", outputBuffer[i]];
    }
    
    return outputString;
}

+ (NSString *)getStringWithTimestamp:(NSTimeInterval)timestamp formatter:(NSString*)formatter{
    if ([NSString stringWithFormat:@"%@", @(timestamp)].length == 13) {
        timestamp /= 1000.0f;
    }
    NSDate*timestampDate=[NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    NSString *strDate = [dateFormatter stringFromDate:timestampDate];
    
    return strDate;
}

- (CGSize)boundingSizeWithFont:(UIFont *)font size:(CGSize)size {
    CGSize aSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return aSize;
}

+ (NSString *)formatterTailBankName:(NSString *)bankName bankCardNo:(NSString *)bankCardNo {
    if (!bankName || bankCardNo.length < 5) {
        return nil;
    }
    NSString *format = [NSString stringWithFormat:@"%@ 尾号%@", bankName,[bankCardNo substringFromIndex:bankCardNo.length - 4]];
    return format;
}

+ (NSString *)formatterKindBankName:(NSString *)bankName bankCardNo:(NSString *)bankCardNo {
    if (!bankName || bankCardNo.length < 5) {
        return nil;
    }
    NSString *format = [NSString stringWithFormat:@"%@ 储蓄卡 (%@)", bankName,[bankCardNo substringFromIndex:bankCardNo.length - 4]];
    return format;
}

+ (BOOL)isEmpty:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:NSNull.class] || [string isEqualToString:@"null"]) {
        return YES;
    }
    if ([string isKindOfClass:NSString.class]) {
        if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
            return YES;
        }
    }
    return NO;
}

/*
 URLUserAllowedCharacterSet      "#%/:<>?@[\]^
 URLPasswordAllowedCharacterSet  "#%/:<>?@[\]^`{|}
 URLHostAllowedCharacterSet      "#%/<>?@\^`{|}
 URLPathAllowedCharacterSet      "#%;<>?[\]^`{|}
 URLQueryAllowedCharacterSet     "#%<>[\]^`{|}
 URLFragmentAllowedCharacterSet  "#%<>[\]^`{|}
 */
+ (NSString *)encodeString:(NSString *)string withCharacters:(NSString *)characters {
    if ([NSString isEmpty:string]) {
        return nil;
    }
    return [string stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:characters] invertedSet]];
}

+ (NSString *)encodedURL:(NSString *)string {
    return [NSString encodeString:string withCharacters:@"<>^`!*'();:@+$,%#[\\]{|}"];
}

+ (NSString *)decodedURL:(NSString *)string {
    if ([NSString isEmpty:string]) {
        return nil;
    }
    return [string stringByRemovingPercentEncoding];
}

+ (NSString *)removeCharactersForString:(NSString *)string {
    NSString *character = @"@／/:：;；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\"<>《》¥“”";
    return [NSString removeCharacters:character forString:string];
}

+ (NSString *)removeCharacters:(NSString *)character forString:(NSString *)string {
    if ([NSString isEmpty:string]) {
        return nil;
    }
    if ([NSString isEmpty:character]) {
        return string;
    }
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:character] invertedSet];
    return [string stringByTrimmingCharactersInSet:set];
}

@end
