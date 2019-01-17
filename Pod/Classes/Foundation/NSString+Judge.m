//
//  NSString+Judge.m
//  ZHKit
//
//  Created by Lee on 2016/6/8.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import "NSString+Judge.h"

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
@end
