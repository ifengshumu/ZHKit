//
//  NSDictionary+JSON.m
//  ZHKit
//
//  Created by Lee on 2016/6/8.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import "NSDictionary+JSON.h"

@implementation NSDictionary (JSON)
- (NSData *)toJSONData {
    if (![NSJSONSerialization isValidJSONObject:self]) {
        NSAssert([NSJSONSerialization isValidJSONObject:self], @"字典无法转换成JSON");
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

- (NSString *)toURLQueryString {
    __block NSMutableString *string = [NSMutableString string];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (!string.length) {
            [string appendString:@"?"];
        }
        if (string.length) {
            [string appendString:@"&"];
        }
        [string appendFormat:@"%@=%@", key, obj];
    }];
    return string;
}

- (NSString *)toXMLString {
    __block NSString *xmlStr = @"<xml>";
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        xmlStr = [xmlStr stringByAppendingString:[NSString stringWithFormat:@"<%@>%@</%@>", key, obj, key]];
    }];
    xmlStr = [xmlStr stringByAppendingString:@"</xml>"];
    
    return xmlStr;
}

@end
