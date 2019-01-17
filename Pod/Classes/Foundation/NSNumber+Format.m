//
//  NSNumber+Format.m
//  ZHKit
//
//  Created by Lee on 2016/6/8.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import "NSNumber+Format.h"

@implementation NSNumber (Format)
/*
 
 */
+ (NSString *)stringFromNumber:(NSNumber *)number withStyle:(NSNumberFormatterStyle)style {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:style];
    return [formatter stringFromNumber:number];
}

+ (NSString *)stringFromNumber:(NSNumber *)number withFormat:(NSString *)format {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:format];
    return [formatter stringFromNumber:number];
}

@end
