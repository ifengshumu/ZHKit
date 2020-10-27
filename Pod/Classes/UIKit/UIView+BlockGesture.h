//
//  UIView+BlockGesture.h
//  MFShowcaseImage
//
//  Created by Mengfei on 16/5/13.
//  Copyright © 2016年 XinMiao. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^GestureActionBlock)(UIGestureRecognizer *gestureRecoginzer);


@interface UIView (BlockGesture)

// 添加tap手势
- (void)addTapActionWithBlock:(GestureActionBlock)block;

// 添加长按手势
- (void)addLongPressActionWithBlock:(GestureActionBlock)block;

// 设置按钮额外热区
@property (nonatomic, assign) UIEdgeInsets touchAreaInsets;

@end
