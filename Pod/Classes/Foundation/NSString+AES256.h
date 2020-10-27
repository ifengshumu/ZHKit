//
//  NSString+AES256.h
//  PPYLingLingQi
//
//  Created by Murphy on 2018/6/27.
//  Copyright © 2018年 Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "NSData+AES256.h"


@interface NSString(AES256)

// 加密
-(NSString *)aes256_encrypt:(NSString *)key;
// 解密
-(NSString *)aes256_decrypt:(NSString *)key;

@end
