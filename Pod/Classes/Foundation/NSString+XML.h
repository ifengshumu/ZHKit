//
//  NSString+XML.h
//
//  Created by Lee on 2017/11/6.
//  Copyright © 2017年 leezhihua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XML)
/**
 xml字符串转换成NSDictionary
 */
-(NSDictionary *)toDictionaryFromXML;

@end
