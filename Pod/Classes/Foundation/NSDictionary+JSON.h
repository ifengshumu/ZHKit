//
//  NSDictionary+JSON.h
//  ZHKit
//
//  Created by Lee on 2016/6/8.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSON)

///字典转换成JSON二进制数据
- (NSData *)toJSONData;

///字典转换成JSON字符串
- (NSString *)toJSONString;

/**
 将NSDictionary转换成url 参数字符串
 */
- (NSString *)toURLQueryString;

/**
 将NSDictionary转换成XML字符串
 */
- (NSString *)toXMLString;
@end
