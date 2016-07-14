
#import <Foundation/Foundation.h>

@interface QWIPAddress : NSObject

/*!
 @method
 @brief 获取本机ip地址
 @discussion
 @result IP地址
 */

+(NSString *)getLocalIPAddress;

+ (NSString *)getIPAddress:(BOOL)preferIPv4;
+ (NSDictionary *)getIPAddresses;
+ (NSArray *)outPutDNSServers;
+ (BOOL)isIPv6;

@end
