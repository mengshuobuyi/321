

#import "QWJSExtension.h"
#import "URICode.h"

@implementation QWJSExtension

@synthesize webView;

- (QWJSExtension *)initWithWebView:(UIWebView *)theWebView {
    self = [super init];
    
    if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppTerminate) name:UIApplicationWillTerminateNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
		self.webView = theWebView;
    }
		
    return self;
}

/* NOTE: calls into JavaScript must not call or trigger any blocking UI, like alerts */
- (void)onAppTerminate {
	// override this if you need to do any cleanup on app exit
}

- (void)onMemoryWarning {
	// override to remove caches, etc
}

- (NSString *)evaluatingJavascript:(NSString *)javascript {
	return [self.webView stringByEvaluatingJavaScriptFromString:javascript];
}
- (void)writeScript:(NSString *)callbackId messageString:(NSString *)message state:(int)state keepCallback:(BOOL)keep{

    NSString *js = [NSString stringWithFormat:@"args = {status:%i,message:\"%@\",keepCallback:%i};  QWJSBridge.callback(\"%@\",args);",state,[URICode escapeURIComponent:message],keep?1:0,callbackId];
    [self evaluatingJavascript:js];
}
- (void)writeScript:(NSString *)callbackId message:(NSString *)message state:(int)state keepCallback:(BOOL)keep{
    
    NSString *js = [NSString stringWithFormat:@"args = {status:%i,message:%@,keepCallback:%i};  QWJSBridge.callback(\"%@\",args);",state,message,keep?1:0,callbackId];
    [self evaluatingJavascript:js];
}
- (void)dealloc {
    self.webView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
   
}
    
@end
