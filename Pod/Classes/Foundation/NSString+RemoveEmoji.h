//
//  NSString+RemoveEmoji.h
//  MFLingLingQi
//
//  Created by Murphy on 2017/9/29.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RemoveEmoji)

- (BOOL)isIncludingEmoji;

- (instancetype)removedEmojiString;

@end
