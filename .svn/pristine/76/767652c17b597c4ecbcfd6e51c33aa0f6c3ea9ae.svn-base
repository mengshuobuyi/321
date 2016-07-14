

#import "QWJSAccelerometerExt.h"
#if TARGET_IPHONE_SIMULATOR
#endif
@implementation QWJSAccelerometerExt
@synthesize jsCallbackId_;


#if TARGET_IPHONE_SIMULATOR
- (void)startAccelerometer:(NSArray *)arguments withDict:(NSDictionary *)options{
    if ([arguments count] > 0) {
        self.jsCallbackId_ = [arguments objectAtIndex:0];
        [self writeScript:self.jsCallbackId_ messageString:@"no support" state:2 keepCallback:NO];
    }
}
- (void)stopAccelerometer:(NSArray *)arguments withDict:(NSDictionary *)options{
}

#else
- (void)startAccelerometer:(NSArray *)arguments withDict:(NSDictionary *)options{
    if ([arguments count]>1) {
        self.jsCallbackId_ = [arguments objectAtIndex:0];
        NSTimeInterval interval = [(NSNumber *)[arguments objectAtIndex:1] doubleValue];
        [[UIAccelerometer sharedAccelerometer] setDelegate:self];
        [[UIAccelerometer sharedAccelerometer] setUpdateInterval:interval];
    }
}
- (void)stopAccelerometer:(NSArray *)arguments withDict:(NSDictionary *)options{
    if ([arguments count]>0) {
        self.jsCallbackId_ = [arguments objectAtIndex:0];
        [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
        //        NSString *script = [NSString stringWithFormat:@"delete EMPJSBridge.callbacks[\"%@\"];",self.jsCallbackId_];
        //        [self.webView stringByEvaluatingJavaScriptFromString:script];
        [self writeScript:self.jsCallbackId_ message:@"null" state:0 keepCallback:NO];
    }
}

#pragma mark -
#pragma mark UIAccelerometerDelegate
//注：在setcallback和在callback中调用stop，这之间可能执行多次callback。
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    if (self.jsCallbackId_) {
        NSString *message = [NSString stringWithFormat:@"new Acceleration(%f,%f,%f)",acceleration.x,acceleration.y,acceleration.z];
        [self writeScript:self.jsCallbackId_ message:message state:0 keepCallback:YES];
    }
}
#endif

- (void)dealloc{
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
    //    NSString *script = [NSString stringWithFormat:@"delete EMPJSBridge.callbacks[\"%@\"];",self.jsCallbackId_];
    //    [self.webView stringByEvaluatingJavaScriptFromString:script];
    [self writeScript:self.jsCallbackId_ message:@"null" state:0 keepCallback:NO];
 
}
@end
