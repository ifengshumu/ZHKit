//
//  UIView+NoData.h
//  PPYLiFeng
//
//  Created by Murphy on 2020/6/19.
//  Copyright © 2020 Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class NoDataView;
@interface UIView (NoData)

// 创建无数据视图
- (NoDataView *)addNoDataTip:(UIImage *)image content:(NSString *)content imageCenterY:(CGFloat)imageCenterY;

@end



@interface NoDataView : UIView

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *content;
@property (assign, nonatomic) CGFloat imageCenterY;

@end

NS_ASSUME_NONNULL_END
