//
//  UIImage+Extension.m
//
//  Created by 李志华 on 2020/4/13.
//

#import "UIImage+Extension.h"
#import <Photos/Photos.h>


UIImage* UIImageNamed(NSString * name) {
    return [UIImage imageNamed:name];
}

@implementation UIImage (Extension)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, UIScreen.mainScreen.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (void)saveImage:(UIImage *)image useCustomizedAssetCollection:(BOOL)useCustomized result:(void (^)(BOOL, BOOL))result {
    [self requestAuthorizationStatus:^(BOOL granted) {
        if (granted) {
            __block PHObjectPlaceholder *asset = nil;
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                //保存图片
                asset = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset;
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (result) {
                        result(YES, success);
                    }
                });
                //移动图片到自定义相册
                if (success && useCustomized) {
                    [self fetchSuitAssetCollection:^(PHAssetCollection *collection) {
                        //移动图片到自定义相册
                        [self removePhotoAsset:asset toAssetCollection:collection];
                    }];
                }
            }];
        } else {
            if (result) {
                result(NO, NO);
            }
        }
    }];
}

+ (void)requestAuthorizationStatus:(void(^)(BOOL granted))granted {
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                granted(YES);
            } else {
                granted(NO);
            }
        }];
    } else if (authStatus == PHAuthorizationStatusAuthorized) {
        granted(YES);
    } else {
        granted(NO);
    }
}

+ (void)fetchSuitAssetCollection:(void(^)(PHAssetCollection *collection))result {
    NSString *name = [[NSBundle mainBundle].infoDictionary objectForKey:(__bridge NSString *)kCFBundleNameKey];
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    __block PHAssetCollection *suitCollection = nil;
    [collections enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.localizedTitle isEqualToString:name]) {
            suitCollection = obj;
            *stop = YES;
        }
    }];
    if (suitCollection) {
        result(suitCollection);
    } else {
        //创建自定义相册
        __block NSString *identifier = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            identifier = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:name].placeholderForCreatedAssetCollection.localIdentifier;
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                suitCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[identifier] options:nil].lastObject;
                result(suitCollection);
            }
        }];
    }
}

+ (void)removePhotoAsset:(PHObject *)asset toAssetCollection:(PHAssetCollection *)collection {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
        [request insertAssets:@[asset] atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
    }];
}

+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image drawInRect:CGRectMake(0.f, 0.f, size.width, size.height)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaleImage;
}

+ (NSData *)scaleImage:(UIImage *)image toMB:(CGFloat)mb {
    CGFloat compression = 1.0f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while (imageData.length > mb*1024 && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    return imageData;
}

+ (UIImage *)rotationImage:(UIImage *)image rotation:(UIImageOrientation)orientation {
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    return newPic;
}

+ (UIImage *)snapshotView:(UIView *)view  {
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenImage;
}

/**
 *  从图片中按指定的位置大小截取图片的一部分
 *
 *  @param image UIImage image 原始的图片
 *  @param rect  CGRect rect 要截取的区域
 *
 *  @return UIImage
 */
+ (UIImage *)ct_imageFromImage:(UIImage *)image inRect:(CGRect)rect{
    
    //把像 素rect 转化为 点rect（如无转化则按原图像素取部分图片）
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat x= rect.origin.x*scale,y=rect.origin.y*scale,w=rect.size.width*scale,h=rect.size.height*scale;
    CGRect dianRect = CGRectMake(x, y, w, h);

    //截取部分图片并生成新图片
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, dianRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    return newImage;
}


@end
