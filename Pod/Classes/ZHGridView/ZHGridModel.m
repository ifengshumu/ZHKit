//
//  ZHGridModel.m
//  
//
//  Created by 李志华 on 2019/7/10.
//

#import "ZHGridModel.h"

@implementation ZHGridModel

+ (ZHGridModel *)modelWithData:(id)data {
    ZHGridModel *model = [[ZHGridModel alloc] init];
    if ([data isKindOfClass:UIImage.class]) {
        model.image = data;
    } else if ([data isKindOfClass:NSString.class]) {
        model.imageURLString = data;
    } else if ([data isKindOfClass:NSURL.class]){
        model.videoURL = data;
    } else if ([data isKindOfClass:ZHGridModel.class]) {
        model = data;
    } else {
        return nil;
    }
    return model;
}

+ (ZHGridModel *)modelWithAddImageName:(NSString *)name {
    ZHGridModel *model = [[ZHGridModel alloc] init];
    model.image = [UIImage imageNamed:name];
    model.key = @"add";
    return model;
}

+ (NSMutableArray<ZHGridModel *> *)modelWithDataArray:(NSArray *)datas {
    if (datas.count == 0) {
        return nil;
    }
    NSMutableArray *models = [NSMutableArray arrayWithCapacity:0];
    for (id data in datas) {
        ZHGridModel *m = [ZHGridModel modelWithData:data];
        [models addObject:m];
    }
    return models;
}

@end
