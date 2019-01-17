//
//  UITextField+EM.h
//  ZHKit
//
//  Created by Lee on 2016/9/29.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (EM)
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, strong) UIFont *placeholderFont;
@property (nonatomic, strong) UIColor *cursorColor; // 光标颜色
@property (nonatomic, assign) NSUInteger maxLength; // 最大输入字数
@end
