//
//  ZHPhotoManager.m
//
//  Created by 李志华 on 2017/1/14.
//  Copyright © 2017 leezhihua. All rights reserved.
//  

#import "ZHPhotoManager.h"
#import "ZHActionSheet.h"
#import "ZHAlbumMultiPicker.h"
#import "ZZCamera/ZZCameraController.h"
#import "TOCropViewController.h"

@interface ZHPhotoManager ()<ZHActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, TOCropViewControllerDelegate>
@property (nonatomic, copy) void(^pickPhotoDidFinish)(NSArray<UIImage *> *photos, NSArray<NSURL *> *urls);
@property (nonatomic, copy) void(^pickImageDidFinish)(NSArray<UIImage *> *images);
@property (nonatomic, strong) UIViewController *rootViewController;
@end


static ZHPhotoManager *picker = nil;
@implementation ZHPhotoManager
+ (ZHPhotoManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        picker = [[ZHPhotoManager alloc] init];
        picker.pickerType = PhotoPickerTypeAll;
    });
    picker.multiPickMaxCount = 1;
    return picker;
}

- (UIViewController *)rootViewController {
    return [self getCurrentViewController];
}

- (UIViewController *)getCurrentViewController {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentShowVC = [self recursiveFromViewController:rootVC];
    return currentShowVC;
}

- (UIViewController *)recursiveFromViewController:(UIViewController *)from {
    if ([from isKindOfClass:[UINavigationController class]]) {
        return [self recursiveFromViewController:[((UINavigationController *)from) visibleViewController]];
    } else if ([from isKindOfClass:[UITabBarController class]]) {
        return [self recursiveFromViewController:[((UITabBarController *)from) selectedViewController]];
    } else {
        if (from.presentedViewController) {
            return [self recursiveFromViewController:from.presentedViewController];
        } else {
            return from;
        }
    }
}


- (void)setNeedRectCrop:(BOOL)needRectCrop {
    if (_needRectCrop != needRectCrop) {
        _needRectCrop = needRectCrop;
    }
    _needCircleCrop = NO;
}

- (void)setNeedCircleCrop:(BOOL)needCircleCrop {
    if (_needCircleCrop != needCircleCrop) {
        _needCircleCrop = needCircleCrop;
    }
    _needRectCrop = NO;
}

- (void)pickImageDidFinish:(void (^)(NSArray<UIImage *> * _Nonnull))pickImage {
    self.pickImageDidFinish = pickImage;
    if (_pickerType == PhotoPickerTypeAll) {
        ZHActionSheet *sheet = [ZHActionSheet actionSheetWithTitle:nil contents:@[@"拍照",@"相册"] cancels:@[@"取消"]];
        sheet.delegate = self;
        sheet.hideWhenTouchExtraArea = YES;
        [sheet show];
    } else if (_pickerType == PhotoPickerTypeCamera) {
        [self photoPickerWithCamera];
    } else {
        [self pickPhoto];
    }
}

- (void)pickPhotoDidFinish:(void (^)(NSArray<UIImage *> * _Nonnull, NSArray<NSURL *> * _Nonnull))pickPhotos {
    self.pickPhotoDidFinish = pickPhotos;
    if (_pickerType == PhotoPickerTypeAll) {
        ZHActionSheet *sheet = [ZHActionSheet actionSheetWithTitle:nil contents:@[@"拍照",@"相册"] cancels:@[@"取消"]];
        sheet.delegate = self;
        sheet.hideWhenTouchExtraArea = YES;
        [sheet show];
    } else if (_pickerType == PhotoPickerTypeCamera) {
        [self photoPickerWithCamera];
    } else {
        [self pickPhoto];
    }
}

- (void)actionSheet:(ZHActionSheet *)actionSheet clickedContentAtIndex:(NSUInteger)index {
    if (index == 0) {
        [self photoPickerWithCamera];
    } else {
        [self pickPhoto];
    }
}
//拍照
- (void)photoPickerWithCamera {
    if (self.multiPickMaxCount == 1) {
        [self takePhoto];
    } else {
        [self multiTakePhoto];
    }
}

#pragma mark - 单张拍摄
- (void)takePhoto {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"设备不支持相机");
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.rootViewController presentViewController:picker animated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    if (self.multiPickMaxCount == 1 && (self.needRectCrop || self.needCircleCrop)) {
        [self cropImage:image imagePicker:picker];
    } else {
        [picker dismissViewControllerAnimated:YES completion:^{
            [self handleImages:@[image]];
        }];
    }
}

#pragma mark - 多张连续拍摄
- (void)multiTakePhoto {
    ZZCameraController *vc = [[ZZCameraController alloc] init];
    vc.takePhotoOfMax = _multiPickMaxCount;
    [vc showIn:self.rootViewController result:^(NSArray<UIImage *> *responseObject) {
        [self handleImages:responseObject];
    }];
}

#pragma mark - 图片多选、单选
- (void)pickPhoto {
    ZHAlbumMultiPicker *tool = [ZHAlbumMultiPicker albumMultiPickerWithMaxImagesCount:_multiPickMaxCount columnNumber:4];
    @weakify(tool);
    tool.didFinishPickingPhotosHandler = ^(NSArray<UIImage *> *photos, NSArray<PHAsset *> *assets) {
        @strongify(tool);
        if (self.multiPickMaxCount == 1 && (self.needRectCrop || self.needCircleCrop)) {
            [self cropImage:photos.firstObject imagePicker:tool.picker];
        } else {
            [tool.picker dismissViewControllerAnimated:YES completion:^{
                [self handleImages:photos];
            }];
        }
    };
    tool.picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.rootViewController presentViewController:tool.picker animated:YES completion:nil];
}

#pragma mark - 处理图片
- (void)handleImages:(NSArray<UIImage *> *)photos {
    if (self.pickImageDidFinish) {
        [self resetData];
        self.pickImageDidFinish(photos);
    } else {
        NSMutableArray *urls = [NSMutableArray array];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (int i = 0; i < photos.count; i++) {
                NSString *path = [NSString stringWithFormat:@"%@%f.jpg", NSTemporaryDirectory(), [NSDate timeIntervalSinceReferenceDate]];
                NSURL *url = [NSURL fileURLWithPath:path];
                NSData *imageData = UIImageJPEGRepresentation(photos[i], 1.0);
                [imageData writeToURL:url atomically:YES];
                [urls addObject:url];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.pickPhotoDidFinish) {
                    [self resetData];
                    self.pickPhotoDidFinish(photos, urls.copy);
                }
            });
        });
    }
}

- (void)resetData {
    self.multiPickMaxCount = 1;
    self.needRectCrop = NO;
    self.needCircleCrop = NO;
}

#pragma mark - 裁剪
- (void)cropImage:(UIImage *)image imagePicker:(UINavigationController *)picker {
    TOCropViewCroppingStyle style = self.needCircleCrop ? TOCropViewCroppingStyleCircular : TOCropViewCroppingStyleDefault;
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:style image:image];
    cropController.delegate = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.rootViewController presentViewController:cropController animated:YES completion:nil];
    }];
}
// Cropper Delegate
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle {
    [cropViewController dismissViewControllerAnimated:YES completion:^{
        [self handleImages:@[image]];
    }];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToCircularImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle {
    [cropViewController dismissViewControllerAnimated:YES completion:^{
        [self handleImages:@[image]];
    }];
}


@end
