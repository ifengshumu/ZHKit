//
//  ZHGridModel.h
//  
//
//  Created by 李志华 on 2019/7/10.
//

#import <Foundation/Foundation.h>

@interface ZHGridModel : NSObject
@property (nonatomic, copy) NSString *key; //用于标示是否是添加按钮
@property (nonatomic, copy) NSString *imageURLString;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSURL *videoURL;

/// model，可传图片、图片url，视频url
+ (ZHGridModel *)modelWithData:(id)data;

/// 使用数据生成model
+ (NSMutableArray<ZHGridModel *> *)modelWithDataArray:(NSArray *)datas;
@end

