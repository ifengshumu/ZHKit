//
//  UIButton+Submitting.h
//  MFShowcaseImage
//
//  Created by Mengfei on 16/5/13.
//  Copyright © 2016年 XinMiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Submitting)

// 按钮点击后，禁用按钮并在按钮上显示ActivityIndicator，以及title（按钮上显示的文字）
- (void)beginSubmitting:(NSString *)title;

// 按钮点击后，恢复按钮点击前的状态
- (void)endSubmitting;

// 按钮是否正在提交中
@property(nonatomic, readonly, getter=isSubmitting) NSNumber *submitting;

@end
