

#import "QWJSDeviceExt.h"
#import "UIDevice+IdentifierAddition.h"
@implementation QWJSDeviceExt
@synthesize jsCallbackId_;

- (void)getDeviceInfo:(NSArray *)arguments withDict:(NSDictionary *)options{
    if ([arguments count]>0) {
        self.jsCallbackId_ = [arguments objectAtIndex:0];
        NSDictionary *deviceProperties = [self deviceProperties];
 
        NSString *script = [NSString stringWithFormat:@"var info = {platform:\"%@\",version:\"%@\",name:\"%@\",uuid:\"%@\"};args = {status:0,message:info,keepCallback:0};  EMPJSBridge.callback(\"%@\",args);",[deviceProperties objectForKey:@"platform"],[deviceProperties objectForKey:@"version"],[deviceProperties objectForKey:@"name"],[deviceProperties objectForKey:@"uuid"],self.jsCallbackId_];
        //script = [NSString stringWithFormat:@"args = {status:EMPJSBridge.callbackStatus.OK,message:null,keepCallback:0}; EMPJSBridge.callbackSuccess(\"%@\",args);",self.jsCallbackId_];
        [self.webView stringByEvaluatingJavaScriptFromString:script];
    }
}

/*
 "status":1,"message":{"name":"iPhone Simulator","uuid":"EEBC4992-EEF0-4132-88F8-6D2A68EF6FBA","platform":"iPhone Simulator","version":"6.0","cordova":"2.1.0"},"keepCallback":false
 */
- (NSDictionary*) deviceProperties
{
    UIDevice *device = [UIDevice currentDevice];
    NSMutableDictionary *devProps = [NSMutableDictionary dictionaryWithCapacity:4];
    [devProps setObject:[device model] forKey:@"platform"];
    [devProps setObject:[device systemVersion] forKey:@"version"];
    [devProps setObject:[device uniqueDeviceIdentifier] forKey:@"uuid"];
    [devProps setObject:[device name] forKey:@"name"];
    
    NSDictionary *devReturn = [NSDictionary dictionaryWithDictionary:devProps];
    return devReturn;
}



@end
