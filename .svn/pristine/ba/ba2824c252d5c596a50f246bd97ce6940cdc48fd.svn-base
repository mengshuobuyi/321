

#import "QWJSGeolocationExt.h"

#define SUCCESS 0
#define UNKNOWN_ERROR 1
#define OPEN_SMS_FAIL_ERROR 2

@implementation QWJSGeolocationExt
@synthesize jsCallbackId_;
- (void)getCurrentLocation:(NSArray *)arguments withDict:(NSDictionary *)options{

    DebugLog(@"getCurrentLocation:%@ options:%@",arguments,options);
    NSString* callbackId = [arguments firstObject];
    self.jsCallbackId_ = callbackId;
    
    //读取本地数据
//    [QWGLOBALMANAGER readLocationWhetherReLocation:NO block:^(MapInfoModel *mm) {
//        DebugLog(@"readLocation %@",mm);
//        if (mm) {
//            [self callBackSuccess:mm];
//        }
//        else {
//            CLLocationDegrees latitude = DEFAULT_LATITUDE;
//            CLLocationDegrees longitude = DEFAULT_LONGITUDE;
//            CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
//            mm = [MapInfoModel new];
//            mm.location = location;
//            mm.city = DEFAULT_CITY;
//            mm.province = DEFAULT_PROVINCE;
//            [self callBackFail:mm];
//        }
//    }];
    //    [self callBackSuccess:nil];
    NSString *cityName = QWGLOBALMANAGER.configure.storeCity;
    //    if (!StrIsEmpty(cityName)) {
    MapInfoModel *model = [MapInfoModel new];
    model.city = cityName;
    [self callBackSuccess:model];
    //    }else {
    //        CLLocationDegrees latitude = DEFAULT_LATITUDE;
    //        CLLocationDegrees longitude = DEFAULT_LONGITUDE;
    //        CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    //        MapInfoModel *model = [MapInfoModel new];
    //        model.location = location;
    //        model.city = DEFAULT_CITY;
    //        model.province = DEFAULT_PROVINCE;
    //        [self callBackFail:model];
    //    }
}

- (void)callBackSuccess:(MapInfoModel*)model
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self writeScript:self.jsCallbackId_ messageString:[self message:model state:YES] state:SUCCESS keepCallback:NO];
        
    });
}

- (void)callBackFail:(MapInfoModel*)model
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self writeScript:self.jsCallbackId_ messageString:[self message:model state:NO] state:UNKNOWN_ERROR keepCallback:NO];
        
    });
}

- (NSString*)message:(MapInfoModel*)model state:(BOOL)state{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    if (model.location) dd[@"lat"]=[NSNumber numberWithDouble:model.location.coordinate.latitude];
    if (model.location) dd[@"lng"]=[NSNumber numberWithDouble:model.location.coordinate.longitude];
    if (model.formattedAddress) dd[@"desc"]=model.formattedAddress;
    if (model.city) dd[@"cityName"]=model.city;
    if (model.province) dd[@"provinceName"]=model.province;
    //    if (1) dd[@"provinceCode"]=@"25";
    //    if (1) dd[@"cityCode"]=@"0215";
    dd[@"isLocation"]=[NSNumber numberWithBool:state];
    
    NSString *jsonString = nil;
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dd options:NSJSONWritingPrettyPrinted error:&error];
    if([jsonData length] > 0 && error == nil) {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"data:%@",jsonString);
//        jsonString=[self encodeURLStr:jsonString];
    }
    return jsonString;
}

- (NSString*)encodeURLStr:(NSString*)str{
    NSString *encodedString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes
    (
     NULL, /* allocator */
     (__bridge CFStringRef)str,
     NULL, /* charactersToLeaveUnescaped */
     (CFStringRef)@"!*'();:@&=+$,/?%#[]",
     kCFStringEncodingUTF8
     );
    return encodedString;
}
@end
