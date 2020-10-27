//
//  UIView+NoData.m
//  PPYLiFeng
//
//  Created by Murphy on 2020/6/19.
//  Copyright © 2020 Murphy. All rights reserved.
//

#import "UIView+NoData.h"

@implementation UIView (NoData)

- (NoDataView *)addNoDataTip:(UIImage *)image content:(NSString *)content imageCenterY:(CGFloat)imageCenterY
{
    NoDataView *noDataView = [[NoDataView alloc]initWithFrame:self.bounds];
    noDataView.image = image;
    noDataView.content = content;
    noDataView.imageCenterY = imageCenterY;
    [self addSubview:noDataView];
    noDataView.hidden = YES;
    return noDataView;
}

@end



@interface NoDataView ()

@property (strong, nonatomic) UIImageView *tipImage;
@property (strong, nonatomic) UILabel *tipLabel;

@end

@implementation NoDataView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _tipImage = [[UIImageView alloc]init];
        _tipImage.bounds = CGRectMake(0, 0, H(50), H(50));
        _tipImage.center = CGPointMake(frame.size.width/2, frame.size.height/2-H(50));
        [self addSubview:_tipImage];
        
        _tipLabel = [UILabel new];
        _tipLabel.frame = CGRectMake(0, CGRectGetMaxY(_tipImage.frame)+20, self.width, H(20));
        _tipLabel.font = mFont(14);
        _tipLabel.textColor = mRGBgfontcolor;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tipLabel];
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    _tipImage.image = image;
}

- (void)setContent:(NSString *)content
{
    _tipLabel.text = content;
}

- (void)setImageCenterY:(CGFloat)imageCenterY
{
    _imageCenterY = imageCenterY;
    if (imageCenterY)
    {
        _tipImage.centerY = imageCenterY;
        _tipLabel.y = CGRectGetMaxY(_tipImage.frame)+20;
    }
}

@end
