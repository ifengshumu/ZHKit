//
//  ZHGridCell.m
//
//  Created by 李志华 on 16/8/4.
//  Copyright © 2016年 李志华. All rights reserved.
//

#import "ZHGridCell.h"
#import <UIButton+WebCache.h>

@interface ZHGridCell ()

@end

@implementation ZHGridCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.layer.cornerRadius = 8;
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"zh_delete"] forState:UIControlStateNormal];
        [self addSubview:_deleteButton];
        [self bringSubviewToFront:_deleteButton];
        [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self);
            make.width.height.equalTo(@20);
        }];
        
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editButton setImage:[UIImage imageNamed:@"zh_edit"] forState:UIControlStateNormal];
        [self addSubview:_editButton];
        [self bringSubviewToFront:_editButton];
        [_editButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self);
            make.width.equalTo(@30);
            make.height.equalTo(@24);
        }];
    }
    return self;
}

- (void)configWithData:(ZHGridModel *)data
      placeHolderImage:(UIImage *)phImage
              addImage:(UIImage *)addImage
              canDelete:(BOOL)isDelete
               canEdit:(BOOL)isEdit {
    if (data) {
        self.deleteButton.hidden = !isDelete;
        self.editButton.hidden = !isEdit;
        if (data.imageURLString) {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:data.imageURLString] placeholderImage:phImage];
        } else if (data.image) {
            self.imageView.image = data.image;
        } else if (data.videoURL) {
            self.imageView.image = [self videoImageWithvideoURL:data.videoURL];
        } else {
            
        }
    } else {
        self.deleteButton.hidden = YES;
        self.editButton.hidden = YES;
        self.imageView.image = addImage;
    }
}

- (UIImage *)videoImageWithvideoURL:(NSURL *)videoURL {
    //先从缓存中查找是否有图片
    SDImageCache *cache = [SDImageCache sharedImageCache];
    UIImage *image = [cache imageFromCacheForKey:videoURL.absoluteString];
    [cache imageFromMemoryCacheForKey:videoURL.absoluteString];
    if (image) {
        return image;
    } else {
        //如果不存在，截取第一秒的画面，转成图片缓存至磁盘
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
        AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
        assetImageGenerator.appliesPreferredTrackTransform = YES;
        assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
        CGImageRef thumbnailImageRef = NULL;
        CFTimeInterval thumbnailImageTime = 1;
        NSError *thumbnailImageGenerationError = nil;
        thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
        if(thumbnailImageRef) {
            UIImage *thumbnailImage = [UIImage imageWithCGImage:thumbnailImageRef];
            UIImage *playImg = [UIImage imageNamed:@"zh_play"];
            CGSize size = self.frame.size;
            CGSize playSize = playImg.size;
            CGRect rect = CGRectMake((size.width-playSize.width)/2.0, (size.height-playSize.height)/2.0, playSize.width, playSize.height);
            UIGraphicsBeginImageContextWithOptions(size, YES, 0);
            [thumbnailImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
            [playImg drawInRect:rect];
            UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [cache storeImage:newImg forKey:videoURL.absoluteString toDisk:YES completion:nil];
            return newImg;
        } else {
            return nil;
        }
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL flag = NO;
    for (UIView *view in self.subviews) {
        if (CGRectContainsPoint(view.frame, point)) {
            flag = YES;
            break;
        }
    }
    return flag;
}

@end
