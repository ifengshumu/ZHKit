//
//  UITextView+Extend.h
//  CheryNewRetail
//
//  Created by 李志华 on 2019/6/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (Extend)
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, strong) UIFont *placeholderFont;
/// 最大输入字数
@property (nonatomic, assign) NSUInteger maxLength;

@end

NS_ASSUME_NONNULL_END
