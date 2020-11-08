//
//  ZHSignatureView.h
//
//  Created by 李志华 on 2017/4/1.
//  Copyright © 2017年 leezhihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHSignatureView : UIView

/// 签名图片
@property (nonatomic, copy) void(^signImage)(UIImage *image);

/**
 显示
*/
- (void)show;

/**
 隐藏
*/
- (void)dismiss;

@end
