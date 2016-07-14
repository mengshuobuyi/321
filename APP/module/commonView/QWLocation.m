#import "QWLocation.h"
#import "INTULocationManager.h"
#import "CLLocation+YCLocation.h"
#import "QWGlobalManager.h"
#import <CoreLocation/CLLocationManager.h>
#define LOCATION_EXPIRE_IN 60

@interface QWLocation()
@property (strong, atomic) INTULocationManager * locMgr;
@property (strong, atomic) CLLocation * lastLocation;
@property (strong, atomic) CLLocation * tmpLocation;
@property (strong, nonatomic) AMapReGeocodeSearchResponse *lastRegeocode;

@property (nonatomic, strong) AMapSearchAPI               *searchAPI;
@property (nonatomic, copy)   ReGeocodeBlock              reGeocodeBlock;


@property long lastLocationTime;
@end

@implementation QWLocation
 static QWLocation *_sharedInstance = nil;
+ (instancetype)sharedInstance
{
   
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [QWLocation new];
        _sharedInstance.locMgr = [INTULocationManager sharedInstance];
        _sharedInstance.lastLocation = nil;
        _sharedInstance.searchAPI = [[AMapSearchAPI alloc] initWithSearchKey:AMAP_KEY Delegate:_sharedInstance];
        _sharedInstance.searchAPI.timeOut = 8;
    });
    
    return _sharedInstance;
}

+ (BOOL)locationServicesAvailable
{
    if ([CLLocationManager locationServicesEnabled] == NO) {
        return NO;
    } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        return NO;
    } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
        return NO;
    }
    return YES;
}


- (INTULocationAccuracy)getAccuracyFromLocationType:(LocationType)type
{
    switch (type) {
        case LocationNone:
            return INTULocationAccuracyNone;
        case LocationCity:
            return INTULocationAccuracyCity;
        case LocationNeighborhood:
            return INTULocationAccuracyNeighborhood;
        case LocationCreate:
            return INTULocationAccuracyBlock;
        case LocationHouse:
            return INTULocationAccuracyHouse;
        case LocationRoom:
            return INTULocationAccuracyRoom       ;
    }
}

- (NSTimeInterval) getAccuracyFromLocationTimeout:(LocationType)type
{
    switch (type) {
        case LocationNone:
            return 100.0;
        case LocationCity:
            return 50.0;
        case LocationNeighborhood:
            return 25.0;
        case LocationCreate:
            return 12.5;
        case LocationHouse:
            return 10;
        case LocationRoom:
            return 7;
    }
}

- (NSInteger)request:(LocationType)type
          block:(void (^)(CLLocation *currentLocation, LocationStatus status))block
{
    INTULocationAccuracy accuracy = [self getAccuracyFromLocationType:type];
    NSTimeInterval timeout = [self getAccuracyFromLocationTimeout:type];
    
    return [_locMgr requestLocationWithDesiredAccuracy:accuracy
                                        timeout:timeout
                           delayUntilAuthorized:YES
                                          block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                    
                                              if (status == INTULocationStatusSuccess || status == INTULocationStatusTimedOut) {
                                                  _lastLocationTime = (long)([[NSDate date] timeIntervalSince1970] * 1000.0f);
                                              }
                                              
                                              block(currentLocation, (LocationStatus)status);
                                          }];
}

- (void)saveLastLoation:(CLLocation *)lastLocation
           lastResponse:(AMapReGeocodeSearchResponse *)lastResponse
{
    self.lastLocation = lastLocation;
    self.lastRegeocode = lastResponse;
}

//如果已经有经纬度信息,则不会重新获取
- (void)requetWithCache:(LocationType)type
                timeout:(NSUInteger)timeout
                  block:(ReGeocodeBlock)block
{
    if(_lastRegeocode && _lastLocation) {
        if(block) {
            block(self.lastLocation,_lastRegeocode,LocationRegeocodeSuccess);
        }
    }else if(![QWLocation locationServicesAvailable]){
        block(nil,nil,LocationRegeocodeFailed);
    }else if(_lastLocation) {
        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
        request.searchType = AMapSearchType_ReGeocode;
        request.requireExtension = YES;
        request.radius = 50;
        request.location = [AMapGeoPoint locationWithLatitude:_lastLocation.coordinate.latitude longitude:_lastLocation.coordinate.longitude];;
        request.requireExtension = YES;
        self.reGeocodeBlock = block;
        _searchAPI.timeOut = timeout;
        [_searchAPI AMapReGoecodeSearch:request];
    }else{
        [self requetWithReGoecode:type timeout:timeout block:block];
    }
}

//定位当前经纬度,并根据高德地图逆地理解析
- (void)requetWithReGoecode:(LocationType)type
                    timeout:(NSUInteger)timeout
                      block:(ReGeocodeBlock)block
{
    INTULocationAccuracy accuracy = [self getAccuracyFromLocationType:type];
    [_locMgr requestLocationWithDesiredAccuracy:accuracy
                                        timeout:2.5
                           delayUntilAuthorized:YES
                                          block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                              if(status != INTULocationStatusSuccess) {

                                                    block(nil,nil,LocationError);
                                                  
                                              }else{
                                                  //add by xie transform to Mars
                                                  currentLocation = [currentLocation locationMarsFromEarth];
                                                  if (status == INTULocationStatusSuccess || status == INTULocationStatusTimedOut) {
                                                      _lastLocationTime = (long)([[NSDate date] timeIntervalSince1970] * 1000.0f);
                                                      _tmpLocation = currentLocation;
                                                      AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
                                                      request.searchType = AMapSearchType_ReGeocode;
                                                      request.requireExtension = YES;
                                                      request.radius = 50;
                                                      request.location = [AMapGeoPoint locationWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];;
                                                      request.requireExtension = YES;
                                                      self.reGeocodeBlock = block;
                                                      [_searchAPI AMapReGoecodeSearch:request];
                                                      
                                                  }
                                              }
                                          }];
}

#pragma mark -
#pragma mark AMapSearchDelegate
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(self.reGeocodeBlock)
    {
        self.reGeocodeBlock(_tmpLocation,response,LocationRegeocodeSuccess);
    }
}

- (void)searchRequest:(id)request didFailWithError:(NSError *)error
{
    if(self.reGeocodeBlock)
    {
        self.reGeocodeBlock(_tmpLocation,nil,LocationRegeocodeFailed);
    }
}

- (void)cancel:(NSInteger)requestID
{
    [_locMgr cancelLocationRequest:requestID];
}

+ (CLLocation *)wgs84ToGcj02
{
   _sharedInstance.lastLocation = [_sharedInstance lastWellLocation] ;
    return [_sharedInstance.lastLocation locationMarsFromEarth];
}

+ (CLLocation *)wgs84ToBd09
{
    _sharedInstance.lastLocation = [_sharedInstance lastWellLocation] ;
    return [_sharedInstance.lastLocation locationBaiduFromMars];
}
+ (CLLocation *)gcj02ToBd09
{
    _sharedInstance.lastLocation = [self wgs84ToGcj02] ;
    return [_sharedInstance.lastLocation locationBaiduFromMars];
}

+ (CLLocation *)Bd09Togcj02
{
    _sharedInstance.lastLocation = [self wgs84ToGcj02] ;
    return [_sharedInstance.lastLocation locationMarsFromBaidu];
}
- (CLLocation *)lastWellLocation
{
    long now = (long)([[NSDate date] timeIntervalSince1970] * 1000.0f);
    if (now - _lastLocationTime > LOCATION_EXPIRE_IN * 1000) {
        return nil;
    }
    
    return _lastLocation;
}

@end