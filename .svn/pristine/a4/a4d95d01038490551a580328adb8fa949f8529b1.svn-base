

#import "QWJSExtension.h"

@interface QWJSDeviceExt : QWJSExtension
{
    NSString                    *jsCallbackId_;

}
@property (nonatomic, copy) NSString *jsCallbackId_;

/**
    获取设备信息
 */
- (void)getDeviceInfo:(NSArray *)arguments withDict:(NSDictionary *)options;

/**
 "status":1,"message":{"name":"iPhone Simulator","uuid":"EEBC4992-EEF0-4132-88F8-6D2A68EF6FBA","platform":"iPhone Simulator","version":"6.0","cordova":"2.1.0"},"keepCallback":false
 */
- (NSDictionary*) deviceProperties;

@end
