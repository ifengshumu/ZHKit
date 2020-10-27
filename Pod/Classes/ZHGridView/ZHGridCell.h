//
//  ZHGridCell.h
//
//  Created by 李志华 on 16/8/4.
//  Copyright © 2016年 李志华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHGridModel.h"

@interface ZHGridCell : UICollectionViewCell
@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readonly) UIButton *deleteButton;
@property (nonatomic, strong, readonly) UIButton *editButton;

- (void)configWithData:(ZHGridModel *)data
      placeHolderImage:(UIImage *)phImage
              addImage:(UIImage *)addImage
             canDelete:(BOOL)isDelete
               canEdit:(BOOL)isEdit;
@end
