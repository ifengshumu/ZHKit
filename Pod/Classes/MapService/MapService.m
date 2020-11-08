//
//  MapService.m
//
//  Created by 李志华 on 2019/4/9.
//  Copyright © 2019 Ruiding. All rights reserved.
//

#import "MapService.h"

@interface MapService ()<AMapLocationManagerDelegate, AMapSearchDelegate, ZHActionSheetDelegate>
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *mapSearch;
@property (nonatomic, copy) void(^geocodeResult)(AMapGeocode *geocode);
@property (nonatomic, copy) void(^reGoecodeResult)(AMapReGeocode *reGeocode);
@property (nonatomic, copy) void(^searchPOIAroundResult)(NSArray<AMapPOI *> *pois);
@property (nonatomic, copy) void(^searchInputResult)(NSArray<AMapTip *> *tips);
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) ZHAuthManager *permission;
@property (nonatomic, strong) NSMutableArray *driveURLs;

@end

//高德地图key
static NSString *const GaoDeApiKey = @"7407f5435f686814926e604cf0f95c3c";

@implementation MapService

+ (MapService *)sharedMapService {
    static MapService *map = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        map = [[MapService alloc] init];
    });
    return map;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [AMapServices sharedServices].apiKey = GaoDeApiKey;
    }
    return self;
}

#pragma mark - 地图
//初始化地图
+ (MAMapView *)mapViewWithFrame:(CGRect)frame delegate:(id<MAMapViewDelegate>)delegate {
    MapService *mapService = [MapService sharedMapService];
    if (mapService.mapView == nil) {
        MAMapView *mapView = [[MAMapView alloc] init];
        mapView.mapType = MAMapTypeStandard;
        mapView.rotateEnabled = NO;
        mapView.rotateCameraEnabled = NO;
        mapView.showsCompass = NO;
        mapView.showsScale = NO;
        mapView.pausesLocationUpdatesAutomatically = NO;
        mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
        mapView.customMapStyleEnabled = YES;
        MAMapCustomStyleOptions *options = [[MAMapCustomStyleOptions alloc] init];
        options.styleData = [MapService mapStyleData:@"style"];
        options.styleExtraData = [MapService mapStyleData:@"style_extra"];
        [mapView setCustomMapStyleOptions:options];
        [mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
        mapService.mapView = mapView;
    }
    MAMapView *mapView = mapService.mapView;
    if (mapView.overlays.count) {
        [mapView removeOverlays:mapView.overlays];
    }
    if (mapView.annotations) {
        [mapView removeAnnotations:mapView.annotations];
    }
    mapView.frame = frame;
    mapView.delegate = delegate;
    mapView.showsUserLocation = YES;
    [mapView setCenterCoordinate:mapService.userLocation.coordinate animated:YES];
    [mapView setZoomLevel:16 animated:YES];
    return mapView;
}
+ (NSData *)mapStyleData:(NSString *)dataName {
    NSString *file = [[NSBundle mainBundle] pathForResource:dataName ofType:@"data"];
    NSData *data = [NSData dataWithContentsOfFile:file];
    return data;
}
- (void)setShowLocationCurrentButton:(BOOL)showLocationCurrentButton {
    //定位
    UIButton *currentLocation = [self.mapView viewWithTag:1234];
    if (!currentLocation) {
        currentLocation = [UIButton buttonWithType:UIButtonTypeCustom];
        currentLocation.backgroundColor = [UIColor whiteColor];
        currentLocation.layer.cornerRadius = 22.5;
        currentLocation.tag = 1234;
        [currentLocation setImage:[UIImage imageNamed:@"daohang"] forState:UIControlStateNormal];
        [currentLocation addTarget:self action:@selector(locationCurrentAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.mapView addSubview:currentLocation];
    }
    currentLocation.hidden = !showLocationCurrentButton;
    //地图frame无法立即得到
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        currentLocation.frame = CGRectMake(CGRectGetMaxX(self.mapView.frame)-60, CGRectGetMaxY(self.mapView.frame)-60, 45, 45);
    });
}
- (void)locationCurrentAction:(UIButton *)sender {
    if (self.locationCurrentHandler) {
        self.locationCurrentHandler(sender);
    }
}
#pragma mark - 搜索
//懒加载搜索服务
- (AMapSearchAPI *)mapSearch {
    if (!_mapSearch) {
        _mapSearch = [[AMapSearchAPI alloc] init];
        _mapSearch.delegate = self;
    }
    return _mapSearch;
}

+ (void)geocodeWithAddress:(NSString *)address city:(NSString *)city result:(void (^)(AMapGeocode * _Nonnull))result {
    AMapGeocodeSearchRequest * request = [[AMapGeocodeSearchRequest alloc] init];
    request.address = address;
    request.city = city;
    [MapService sharedMapService].geocodeResult = result;
    [[MapService sharedMapService].mapSearch AMapGeocodeSearch:request];
}

+ (void)geocodeWithCity:(NSString *)city result:(void (^)(AMapGeocode * _Nonnull))result {
    AMapGeocodeSearchRequest * request = [[AMapGeocodeSearchRequest alloc] init];
    request.address = @"市人民政府";
    request.city = city;
    [MapService sharedMapService].geocodeResult = result;
    [[MapService sharedMapService].mapSearch AMapGeocodeSearch:request];
}

+ (void)reGeecodeWithCoordinate:(CLLocationCoordinate2D)coordinate result:(void(^)(AMapReGeocode *reGeocode))result {
    AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
    request.requireExtension = YES;
    request.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [MapService sharedMapService].reGoecodeResult = result;
    [[MapService sharedMapService].mapSearch AMapReGoecodeSearch:request];
}
+ (void)searchPOIAroundWithType:(NSString *)type page:(NSInteger)page coordinate:(CLLocationCoordinate2D)coordinate result:(void (^)(NSArray<AMapPOI *> * _Nonnull))result {
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.requireExtension = YES;
    request.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    request.keywords = type;
    request.radius = 500;
    request.page = page;
    [MapService sharedMapService].searchPOIAroundResult = result;
    [[MapService sharedMapService].mapSearch AMapPOIAroundSearch:request];
}
+ (void)searchCurrentPOIAroundWithType:(NSString *)type page:(NSInteger)page result:(void (^)(NSArray<AMapPOI *> * _Nonnull))result {
    [self searchPOIAroundWithType:type page:page coordinate:[MapService sharedMapService].userLocation.coordinate result:result];
}
+ (void)searchInputText:(NSString *)inputText city:(NSString *)city result:(void(^)(NSArray<AMapTip *> *tips))result {
    AMapInputTipsSearchRequest *request = [[AMapInputTipsSearchRequest alloc] init];
    request.keywords = inputText;
    request.city = city;
    request.cityLimit = YES;
    [MapService sharedMapService].searchInputResult = result;
    [[MapService sharedMapService].mapSearch AMapInputTipsSearch:request];
}
//地理编码回调
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response {
    if (self.geocodeResult) {
        self.geocodeResult(response.geocodes.firstObject);
    }
}
//逆地理编码回调
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if (self.reGoecodeResult) {
        self.reGoecodeResult(response.regeocode);
    }
}
//poi查询回调
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if (self.searchPOIAroundResult) {
        self.searchPOIAroundResult(response.pois);
    }
}
//输入查询回调
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response {
    if (self.searchInputResult) {
        self.searchInputResult(response.tips);
    }
}

#pragma mark - 定位
- (AMapLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    }
    return _locationManager;
}
//开始定位
+ (void)startLocationWithCompletionResult:(void (^)(CLLocation * _Nullable, AMapLocationReGeocode * _Nullable))result {
    if ([CLLocationManager locationServicesEnabled]) {
        //先取消之前的定位
        [[MapService sharedMapService].locationManager stopUpdatingLocation];
        //再进行
        [[MapService sharedMapService].locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
            if (!error) {
                [MapService sharedMapService].userLocation = location;
                [MapService sharedMapService].userRegeocode = regeocode;
            } else {
                //如果定位失败则再次定位
                //[MapService startLocationWithCompletionResult:result];
                NSLog(@"====定位失败：%@", error.localizedDescription);
            }
            if (result) {
                result(location, regeocode);
            }
        }];
    } else {
        [self handleLocationAuthorizationDisabled];
    }
}
- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager *)locationManager {
    [locationManager requestAlwaysAuthorization];
}
//定位失败
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"定位失败：%@", error.localizedDescription);
}
//定位权限状态改变时回调函数
- (void)amapLocationManager:(AMapLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusDenied) {
        [MapService handleLocationAuthorizationDisabled];
    }
}

#pragma mark - 开放方法
//计算两个经纬度间的距离
+ (double)calculateDistanceFrom:(CLLocationCoordinate2D)from to:(CLLocationCoordinate2D)to {
    if ((to.latitude == 0 && to.longitude == 0) || !CLLocationCoordinate2DIsValid(to)) {
        return 0;
    }
    if ((from.latitude == 0 && from.longitude == 0) || !CLLocationCoordinate2DIsValid(from)) {
        from = [MapService sharedMapService].userLocation.coordinate;
    }
    MAMapPoint current = MAMapPointForCoordinate(from);
    MAMapPoint select = MAMapPointForCoordinate(to);
    CLLocationDistance distance = MAMetersBetweenMapPoints(current, select);
    return distance;
}

+ (void)driveDestination:(NSString *)destination latitude:(double)latitude longitude:(double)longitude {
    NSMutableArray *driveURLs = [NSMutableArray arrayWithCapacity:0];
    [MapService sharedMapService].driveURLs = driveURLs;
    NSMutableArray *mapTitles = [NSMutableArray arrayWithCapacity:0];
    NSString *url = nil;
    double userLatitude = [MapService sharedMapService].userLocation.coordinate.latitude;
    double userLongitude = [MapService sharedMapService].userLocation.coordinate.longitude;
    
    [mapTitles addObject:@"高德地图"];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        url = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&sid=BGVIS1&slat=&slon=&sname=&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&t=0", @"靓车出行", latitude, longitude, destination] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [driveURLs addObject:url];
    } else {
        url = [[NSString stringWithFormat:@"https://uri.amap.com/navigation?&from=%f,%f&to=%f,%f,%@&mode=car&src=ios.lccx.lctravel", userLatitude, userLongitude, latitude, longitude ,destination] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [driveURLs addObject:url];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        url =[[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name:%@&mode=driving&coord_type=wgs84&src=ios.lccx.lctravel", latitude, longitude, destination] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [driveURLs addObject:url];
        [mapTitles addObject:@"百度地图"];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        url = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=%@&coord_type=1&policy=0", latitude, longitude, destination] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [driveURLs addObject:url];
        [mapTitles addObject:@"腾讯地图"];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com/"]]) {
        url = [[NSString stringWithFormat:@"http://maps.apple.com/?daddr=%f,%f&saddr=Current+Location", latitude, longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [driveURLs addObject:url];
        [mapTitles addObject:@"苹果地图"];
    }
    
    ZHActionSheet *sheet = [ZHActionSheet actionSheetWithTitle:@"选择地图" contents:mapTitles cancels:@[@"取消"]];
    sheet.delegate = [MapService sharedMapService];
    sheet.hideWhenTouchExtraArea = YES;
    [sheet show];
}

- (void)actionSheet:(ZHActionSheet *)actionSheet clickedContentAtIndex:(NSUInteger)index {
    NSURL *url = [NSURL URLWithString:self.driveURLs[index]];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - 开放方法
+ (void)checkLocationAuthorization:(void (^)(BOOL))auth {
    [ZHAuthManager requestAuthorization:AuthTypeLocationWhenInUse authorizedResult:^(BOOL granted) {
        BOOL whenInUse = granted;
        [ZHAuthManager requestAuthorization:AuthTypeLocationAlways authorizedResult:^(BOOL granted) {
            auth(whenInUse || granted);
        }];
    }];
}
+ (void)handleLocationAuthorizationDisabled {
    [ZHAlertView showAlertWithTitle:@"无法获取定位信息\n去“设置”开始定位权限" confirmTitle:@"开启" cancelTitle:@"取消" confirmHandler:^{
        [ZHAuthManager setAppAuthorization];
    } cancelHandler:^{
        
    }];
}

@end
