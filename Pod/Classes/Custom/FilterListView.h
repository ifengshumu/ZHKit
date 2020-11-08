//
//  FilterListView.h
//  PPYLiFeng
//
//  Created by Steve on 2020/6/16.
//  Copyright © 2020 Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FilterListView : UIView

/// 传入触发视图，数据
- (instancetype)initWithTrigger:(UIView *)trigger list:(NSArray<NSString *> *)list;

///数据
@property (nonatomic, copy, readonly) NSArray<NSString *> *list;

/// 默认值，用于设置初始选中
@property (nonatomic, copy) NSString *defaultValue;

/// 选择回调
@property (nonatomic, copy) void(^filterSelectResult)(NSString *text, NSInteger index);

/// 显示隐藏回调
@property (nonatomic, copy) void(^filterShowStatus)(BOOL isShow);

/// 展示
- (void)show;

/// 消失
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
