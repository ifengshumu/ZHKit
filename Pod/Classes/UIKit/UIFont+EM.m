//
//  UIFont+EM.m
//  ZHKit
//
//  Created by Lee on 2016/9/29.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import "UIFont+EM.h"

@implementation UIFont (EM)
+ (CGFloat)lineSpaceForFont:(UIFont *)font {
    if (font) {
        return font.lineHeight - font.pointSize;
    }else{
        return 0;
    }
}
@end
