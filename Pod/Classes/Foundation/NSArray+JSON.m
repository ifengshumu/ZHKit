//
//  NSArray+JSON.m
//  ZHKit
//
//  Created by Lee on 2016/6/8.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import "NSArray+JSON.h"

@implementation NSArray (JSON)
- (NSData *)toJSONData {
    if (![NSJSONSerialization isValidJSONObject:self]) {
        NSAssert([NSJSONSerialization isValidJSONObject:self], @"数组无法转换成JSON");
        return nil;
    }
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    
    if ([jsonData length] && error == nil){
        return jsonData;
    } else {
        NSAssert(error == nil, @"转JSON失败");
        return nil;
    }
}
- (NSString *)toJSONString {
    if ([self toJSONData]) {
        return [[NSString alloc] initWithData:[self toJSONData] encoding:NSUTF8StringEncoding];
    }
    return nil;
}
@end
