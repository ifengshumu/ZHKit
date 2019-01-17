//
//  NSArray+JSON.h
//  ZHKit
//
//  Created by Lee on 2016/6/8.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (JSON)
///数组转JSON二进制数据
- (NSData *)toJSONData;
///数组转JSON字符串
- (NSString *)toJSONString;
@end

