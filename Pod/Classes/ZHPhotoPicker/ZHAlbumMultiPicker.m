//
//  ZHAlbumMultiPicker.m
//
//  Created by 李志华 on 2017/1/14.
//  Copyright © 2017 leezhihua. All rights reserved.
//

#import "ZHAlbumMultiPicker.h"
#import <TZImagePickerController/TZImagePickerController.h>

@implementation ZHAlbumMultiPicker

+ (instancetype)albumMultiPickerWithMaxImagesCount:(NSInteger)maxImagesCount columnNumber:(NSInteger)columnNumber {
    return [[ZHAlbumMultiPicker alloc] initWithMaxImagesCount:maxImagesCount columnNumber:columnNumber];
}

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount columnNumber:(NSInteger)columnNumber {
    self = [super init];
    if (self) {
        TZImagePickerController *picker = [[TZImagePickerController alloc] initWithMaxImagesCount:maxImagesCount columnNumber:columnNumber delegate:nil];
        picker.photoWidth = 700;
        picker.oKButtonTitleColorDisabled = [UIColor.redColor colorWithAlphaComponent:0.5];
        picker.oKButtonTitleColorNormal = UIColor.redColor;
        //照片排列按修改时间升序
        picker.sortAscendingByModificationDate = YES;
        //设置是否可以拍照、选择视频/原图
        //picker.allowTakePicture = NO;
        picker.allowPickingVideo = NO;
        picker.allowPickingOriginalPhoto = NO;
        picker.autoDismiss = NO;
        _picker = picker;
        picker.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            if (self.didFinishPickingPhotosHandler) {
                self.didFinishPickingPhotosHandler(photos, assets);
            }
        };
        @weakify(picker);
        picker.imagePickerControllerDidCancelHandle = ^{
            @strongify(picker);
            [picker dismissViewControllerAnimated:YES completion:nil];
        };
    }
    return self;
}

- (void)setPhotoWidth:(CGFloat)photoWidth {
    [(TZImagePickerController *)self.picker setPhotoWidth:photoWidth];
}

@end
