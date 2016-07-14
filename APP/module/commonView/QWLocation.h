/*!
 @header QWLocation.h
 @abstract 此协议包括获取GPS定位信息,并将GPS定位信息解码成城市街道信息
 @author .
 @version 1.00 2015/01/01  (1.00)
 */

#import <CoreLocation/CLLocation.h>
#import <AMapSearchKit/AMapCommonObj.h>
#import <AMapSearchKit/AMapSearchObj.h>
#import <AMapSearchKit/AMapSearchAPI.h>

/*!
 @protocol
 @brief 此协议包括获取GPS定位信息,并将GPS定位信息解码成城市街道信息
 @discussion
 */




@interface QWLocation : NSObject

typedef NS_ENUM(NSInteger, LocationType) {
    LocationNone,         // 不准确的（范围＞5000米 ，最后时间> 10分钟前）
    LocationCity,         // 5000米或更大范围，在最后10分钟  -- 最低精度
    LocationNeighborhood, // 1000米或更大范围，在最后5分钟
    LocationCreate,       // 100米或更大范围，在最后的1分钟
    LocationHouse,        // 15米或更大范围，在最后15秒
    LocationRoom,         // 5米或更大范围，在最后5秒——最高精度
};

typedef NS_ENUM(NSInteger, LocationStatus) {
    /* 这些状态将伴随着一个有效的位置。 */
    LocationSuccess,                // 在所需的精度水平下获取坐标成功
    LocationTimeout,                // 在所需的精度水平下获取坐标超时
    
    /* 这些状态指示某种错误，并将伴随一个零位置。 */
    LocationServicesNotDetermined,  // 用户没有回应权限对话框
    LocationServicesDenied,         // 用户已明确否认这个程序允许访问位置
    LocationServicesRestricted,     // 用户没有启用位置服务的能力（例如，父母控制，公司政策，等等）
    LocationServicesDisabled,       // 用户未开启定位服务
    LocationError,                  // 在使用系统的位置服务时出错
    LocationRegeocodeSuccess,       //经纬度以及逆地理编码解析都成功
    LocationRegeocodeFailed         //经纬度解析成功,但逆地理编码解析失败
};

typedef void (^ReGeocodeBlock)(CLLocation *currentLocation,AMapReGeocodeSearchResponse *response, LocationStatus status);

/*!
 @property
 @brief GPS服务实例方法
 */

+ (instancetype)sharedInstance;


/*!
 @property
 @brief GPS服务是否可用
 */
+ (BOOL)locationServicesAvailable;

/*!
 @method
 @brief 开始GPS定位,并返回地球坐标
 @discussion
 @result
 */


- (NSInteger)request:(LocationType)type
          block:(void (^)(CLLocation *currentLocation, LocationStatus status))block;

/*!
 @method
 @brief 开始GPS定位,并返回地球坐标以及可阅读地理位置
 @discussion  如果已经有经纬度信息,则不会重新获取
 */

- (void)requetWithCache:(LocationType)type
                timeout:(NSUInteger)timeout
                  block:(ReGeocodeBlock)block;

/*!
 @method
 @brief 开始GPS定位,并返回地球坐标以及可阅读地理位置
 @discussion  定位当前经纬度,并根据高德地图逆地理解析
 */

- (void)requetWithReGoecode:(LocationType)type
                    timeout:(NSUInteger)timeout
                      block:(ReGeocodeBlock)block;
/*!
 @method
 @brief 停止GPS定位
 @discussion
 @result
 */

- (void)cancel:(NSInteger)requestID;

/*!
 @method
 @brief 保存上一次定位信息
 @discussion
 @result
 */
- (void)saveLastLoation:(CLLocation *)lastLocation
           lastResponse:(AMapReGeocodeSearchResponse *)lastResponse;
/*!
 @method
 @brief GPS返回的最后一次位置信息
 @discussion
 @result
 */
- (CLLocation *)lastWellLocation;


/*!
 @method
 @brief 将经纬度信息解码为城市街道信息(同步方法, 如果在主线程中使用, 会阻塞主线程)暂时只支持中国的火星坐标, 你懂的
 @param latitude 经度
 @param longitude 纬度
 @param pError 错误信息
 @discussion
 @result 解码后的城市街道信息(eg: 中国北京市海淀区中关村彩和坊路)
 */
- (NSString *)decodeAddressFromLatitude:(double)latitude
                           andLongitude:(double)longitude
                                  error:(QWError **)pError;

/*!
 @method
 @brief 将经纬度信息解码为城市街道信息(异步方法, 解码完成后, 会调用didDecodeAddress 回调方法)暂时只支持中国的火星坐标, 你懂的
 @param latitude 经度
 @param longitude 纬度
 @discussion
 @result
 */
- (void)asyncDecodeAddressFromLatitude:(double)latitude
                          andLongitude:(double)longitude;

/*!
 @method
 @brief 将经纬度信息解码为城市街道信息(异步方法)暂时只支持中国的火星坐标, 你懂的
 @param latitude 经度
 @param longitude 纬度
 @param completion 解码完成后的回调block
 @param queue 回调block时的线程
 @discussion
 @result
 */
- (void)asyncDecodeAddressFromLatitude:(double)latitude
                          andLongitude:(double)longitude
                            completion:(void (^)(NSString *address, QWError *))completion
                               onQueue:(dispatch_queue_t)queue;

/*!
 @method
 @brief	世界标准地理坐标(WGS-84) 转换成 中国国测局地理坐标（GCJ-02）<火星坐标>
 ####只在中国大陆的范围的坐标有效，以外直接返回世界标准坐标
 @param 	location 	世界标准地理坐标(WGS-84)
 @return	中国国测局地理坐标（GCJ-02）<火星坐标>
 */
+  (CLLocation *)wgs84ToGcj02;



/*!
 @method
 @brief	世界标准地理坐标(WGS-84) 转换成 百度地理坐标（BD-09)
 @param 	location 	世界标准地理坐标(WGS-84)
 @return	百度地理坐标（BD-09)
 */
+ (CLLocation *)wgs84ToBd09;

/*!
 @method
 @brief	中国国测局地理坐标（GCJ-02）<火星坐标> 转换成 百度地理坐标（BD-09)
 @param 	location 	中国国测局地理坐标（GCJ-02）<火星坐标>
 @return	百度地理坐标（BD-09)
 */
+ (CLLocation *)gcj02ToBd09;

/*!
 @method
 @brief	百度地理坐标（BD-09) 转换成 中国国测局地理坐标（GCJ-02）<火星坐标>
 @param 	百度地理坐标（BD-09)
 @return	中国国测局地理坐标（GCJ-02）<火星坐标>
 */

+ (CLLocation *)Bd09Togcj02;

@end
