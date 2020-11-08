//
//  PickListView.h
//  PPYLiFeng
//
//  Created by Steve on 2020/7/1.
//  Copyright © 2020 Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PickListView : UIView

/// 传入数据
- (instancetype)initWithList:(NSArray<NSString *> *)list defaultValue:(nullable NSString *)aValue;

///数据
@property (nonatomic, copy, readonly) NSArray<NSString *> *list;

/// 选择回调
@property (nonatomic, copy) void(^doneResult)(NSString *text, NSInteger index);

///展示
- (void)show;

///消失
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
