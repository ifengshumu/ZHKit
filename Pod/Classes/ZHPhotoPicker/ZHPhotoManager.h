//
//  ZHPhotoManager.h
//
//  Created by 李志华 on 2017/1/14.
//  Copyright © 2017 leezhihua. All rights reserved.
//  图片(多选)选择-相机、相册

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PhotoPickerType) {
    PhotoPickerTypeAll      = 0,
    PhotoPickerTypeCamera,
    PhotoPickerTypeAlbum,
};

NS_ASSUME_NONNULL_BEGIN

@interface ZHPhotoManager : NSObject
/// 拍照+相册
+ (ZHPhotoManager *)sharedManager;
/// 照片选择方式，默认PhotoPickerTypeAll
@property (nonatomic, assign) PhotoPickerType pickerType;
/// 多选数量
@property (nonatomic, assign) NSUInteger multiPickMaxCount;
/// 需要矩形裁剪框
@property (nonatomic, assign) BOOL needRectCrop;
/// 需要圆形裁剪框
@property (nonatomic, assign) BOOL needCircleCrop;
/// 图片+url
- (void)pickPhotoDidFinish:(void(^)(NSArray<UIImage *> *photos, NSArray<NSURL *> *urls))pickPhotos;
/// 图片
- (void)pickImageDidFinish:(void(^)(NSArray<UIImage *> *images))pickImage;



@end

NS_ASSUME_NONNULL_END
