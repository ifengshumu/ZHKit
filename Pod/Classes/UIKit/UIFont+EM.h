//
//  UIFont+EM.h
//  ZHKit
//
//  Created by Lee on 2016/9/29.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (EM)

/**
 字体的上下间距，UI布局时一般要减去上下间距
 */
+ (CGFloat)lineSpaceForFont:(UIFont *)font;
@end

