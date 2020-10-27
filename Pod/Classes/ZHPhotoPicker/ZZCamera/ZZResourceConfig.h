//
//  ZZResourceConfig.h
//  ZZPhotoKit
//
//  Created by 袁亮 on 16/5/19.
//  Copyright © 2016年 Ace. All rights reserved.
//

#ifndef ZZResourceConfig_h
#define ZZResourceConfig_h
/////配置文件/////


/*
 公共文件
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+WebCache.h"

#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>


/*
 控制器
 */
#define ZZ_VW               (self.view.frame.size.width)
#define ZZ_VH               (self.view.frame.size.height)

#define ZZ_SCREEN_WIDTH     ([UIScreen mainScreen].bounds.size.width)
#define ZZ_SCREEN_HEIGHT    ([UIScreen mainScreen].bounds.size.height)

#define ZZ_iPhoneX          (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ZZ_SCREEN_WIDTH >= 375.0f && ZZ_SCREEN_HEIGHT >= 812.0f
#define ZZ_BOTTOM           (ZZ_iPhoneX?(34.0):(0))


/*
 图片
 */
//   闪光灯按钮图片
#define Flash_On_Pic        [UIImage imageNamed:@"zz_flash_on"]
#define Flash_Off_Pic       [UIImage imageNamed:@"zz_flash_off"]
#define Flash_Auto_Pic      [UIImage imageNamed:@"zz_flash_auto"]
/*
 文字
 */
//   相册详细页面底部Footer显示文字

#define Alert_Max_TakePhoto @"最多连拍%lu张照片"


#endif /* ZZResourceConfig_h */
