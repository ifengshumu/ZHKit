//
//  ZZCameraBrowerViewController.h
//  ZZPhotoKit
//
//  Created by 袁亮 on 16/5/27.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZCameraBrowerViewController;

@protocol ZZCameraBrowerDataSource <NSObject>

@required
-(NSInteger)zzbrowserPickerPhotoNum:(ZZCameraBrowerViewController *)controller;
-(NSArray<UIImage *> *)zzbrowserPickerPhoto:(ZZCameraBrowerViewController *)controller;

@end

@interface ZZCameraBrowerViewController : UIViewController

@property (nonatomic,   weak) id <ZZCameraBrowerDataSource> delegate;

//滚动到指定位置(滚动到那张图片，通过下面属性)
@property (nonatomic, strong) NSIndexPath *indexPath;

-(void)reloadData;

-(void)showIn:(UIViewController *)controller;

@end
