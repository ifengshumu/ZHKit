//
//  MapService.h
//
//  Created by 李志华 on 2019/4/9.
//  Copyright © 2019 Ruiding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface MapService : NSObject
///地图服务单利
+ (MapService *)sharedMapService;
///当前定位CLLocation
@property (nonatomic, strong, nullable) CLLocation *userLocation;
///当前定位逆编码
@property (nonatomic, strong, nullable) AMapLocationReGeocode *userRegeocode;
///是否显示定位当前位置按钮，默认NO
@property (nonatomic, assign) BOOL showLocationCurrentButton;
///定位当前位置按钮Block
@property (nonatomic, copy) void(^locationCurrentHandler)(UIButton *sender);
///初始化地图，frame不能立即得到，布局时需要注意
+ (MAMapView *)mapViewWithFrame:(CGRect)frame delegate:(id<MAMapViewDelegate>)delegate;
//地理编码-地址必须，城市可选
+ (void)geocodeWithAddress:(NSString *)address city:(NSString *)city result:(void(^)(AMapGeocode *geocode))result;
//地理编码-城市（地址为市政府）
+ (void)geocodeWithCity:(NSString *)city result:(void(^)(AMapGeocode *geocode))result;
///逆地理编码
+ (void)reGeecodeWithCoordinate:(CLLocationCoordinate2D)coordinate result:(void(^)(AMapReGeocode *reGeocode))result;
///搜索周边-根据类型、经纬度、页数
+ (void)searchPOIAroundWithType:(nullable NSString *)type page:(NSInteger)page coordinate:(CLLocationCoordinate2D)coordinate result:(void(^)(NSArray<AMapPOI *> *pois))result;
///搜索周边-根据类型、当前定位、页数
+ (void)searchCurrentPOIAroundWithType:(nullable NSString *)type page:(NSInteger)page result:(void(^)(NSArray<AMapPOI *> *pois))result;
///搜索提示-根据关键字，城市
+ (void)searchInputText:(NSString *)inputText city:(nullable NSString *)city result:(void(^)(NSArray<AMapTip *> *tips))result;
///开始定位
+ (void)startLocationWithCompletionResult:(nullable void(^)(CLLocation * _Nullable location,  AMapLocationReGeocode * _Nullable regeocode))result;
///计算两个经纬度间的距离，单位米；如果from为空或无效则取定位点，to为空或无效则返回0米
+ (double)calculateDistanceFrom:(CLLocationCoordinate2D)from to:(CLLocationCoordinate2D)to;
///导航
+ (void)driveDestination:(NSString *)destination latitude:(double)latitude longitude:(double)longitude;
///检查定位权限
+ (void)checkLocationAuthorization:(void(^)(BOOL grant))auth;
///定位权限未开启弹窗
+ (void)handleLocationAuthorizationDisabled;

@end

NS_ASSUME_NONNULL_END
