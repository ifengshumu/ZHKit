//
//  CityDBModel.h
//
//  Created by 李志华 on 2019/7/6.
//

#import <Foundation/Foundation.h>

@interface HotCityModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@end

@interface CityDBModel : NSObject

@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *province_code;

@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *city_code;

@property (nonatomic, copy) NSString *pinyin;

@end

