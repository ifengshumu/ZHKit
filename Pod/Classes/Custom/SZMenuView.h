//
//  SZMenuView.h
//  PPYLiFeng
//
//  Created by 李志华 on 2020/6/4.
//  Copyright © 2020 Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SZMenuView : UIView
/// 菜单视图
- (instancetype)initWithFrame:(CGRect)frame menus:(NSArray *)menus;
/// 右上角显示数字
- (instancetype)initWithFrame:(CGRect)frame menus:(NSArray *)menus nums:(NSArray *)nums;
/// 选择菜单
- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated;

///设置数字
- (void)setNumbers:(NSArray<NSString *> *)numbers;
///按下标设置数字
- (void)setNumber:(NSString *)number atIndex:(NSInteger)idx;

/// 菜单点击
@property (nonatomic, copy) void(^menuClickHandler)(NSInteger index);

@property (nonatomic, strong) UIColor *defaultColor;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, assign) CGFloat lineWidth;
@end

NS_ASSUME_NONNULL_END
