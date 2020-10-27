//
//  ZHAlbumMultiPicker.h
//
//  Created by 李志华 on 2017/1/14.
//  Copyright © 2017 leezhihua. All rights reserved.
//  相册图片选择

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface ZHAlbumMultiPicker : NSObject
+ (instancetype)albumMultiPickerWithMaxImagesCount:(NSInteger)maxImagesCount columnNumber:(NSInteger)columnNumber;
@property (nonatomic, strong, readonly) UINavigationController *picker;
/// default 700
@property (nonatomic, assign) CGFloat photoWidth;
///选择结果回调
@property (nonatomic, copy) void (^didFinishPickingPhotosHandler)(NSArray<UIImage *> *photos,NSArray<PHAsset *> *assets);
@end

