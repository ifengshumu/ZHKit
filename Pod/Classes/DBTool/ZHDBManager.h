//
//  ZHDBManager.h
//
//  Created by 李志华 on 2019/7/6.
//

#import <Foundation/Foundation.h>
#import "CityDBModel.h"

@interface ZHDBManager : NSObject

/**
 数据库单例
*/
+ (instancetype)manager;

/**
 查询全部城市
 */
- (NSArray<CityDBModel *> *)queryAllCity;

/**
 根据城市名查找对应的模型数据
 */
- (CityDBModel *)modelForCity:(NSString *)city;

/**
 模糊查询城市
 */
- (NSArray<CityDBModel *> *)queryCitysByName:(NSString *)name;

@end

