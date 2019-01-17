//
//  UITextView+EM.h
//  ZHKit
//
//  Created by Lee on 2016/9/29.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UITextView (EM)
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, strong) UIFont *placeholderFont;
@property (nonatomic, strong) UIColor *cursorColor; // 光标颜色
@property (nonatomic, assign) NSUInteger maxLength; // 最大输入字数
@end

