//
//  UIView+ViewController.h
//  MFShowcaseImage
//
//  Created by Mengfei on 16/5/13.
//  Copyright © 2016年 XinMiao. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (ViewController)

// 找到当前view所在的viewcontroler
@property (readonly) UIViewController *viewController;

@end
