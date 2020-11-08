//
//  SZSwitch.h
//  PPYLiFeng
//
//  Created by 李志华 on 2020/6/4.
//  Copyright © 2020 Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SZSwitch : UIView

/// 开关
@property (nonatomic, assign, getter=isOn) BOOL on;

/// 值变化block
@property (nonatomic, copy) void(^swithValue)(BOOL isOn);

/// 设置开关文本
- (void)setOnText:(NSString *)onT offText:(NSString *)offT;

/// 设置开关
- (void)setOn:(BOOL)on animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
