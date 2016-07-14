 

#import "QWWebViewController.h"
#import "QWCommon.h"
#import "QWJSExtensionsList.h"

#import "QWJSExtension.h"
@interface QWWebViewController ()
    <UIWebViewDelegate>
{
    
    NSMutableArray *audioCache;
    NSMutableArray *_videoCache;
}
//@property (nonatomic , retain) QWLoading * m_loadingView;
//@property (nonatomic , retain) UIActivityIndicatorView * m_loadingView ;

-(void)backController;

-(NSURLRequest *)getRequestWithURL:(NSURL *)requestUrl;
@end

@implementation QWWebViewController

@synthesize m_webView;
//@synthesize m_loadingView;
//@synthesize m_loadingView;
static BOOL diagStat = NO;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
//    [QWCommon forceRotateInterfaceOrientation:UIInterfaceOrientationPortrait];
    
}

-(void)viewDidAppear:(BOOL)animated
{
//    [self.navigationController set

//    [self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortrait];
    

}


-(void)viewDidDisappear:(BOOL)animated
{
 
    
//    [QWCommon forceRotateInterfaceOrientation:[[UIDevice currentDevice] orientation]];
    
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{

    
    [super viewDidUnload];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
//    if (m_loadingView) {
//    
//        m_loadingView = nil;
//    }
    m_webView.delegate = nil;
    if (m_webView) {
    
        m_webView = nil;
    }
 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    float bigger;
    float smaller;
    if (self.view.frame.size.width > self.view.frame.size.height) {
        bigger = self.view.frame.size.width;
        smaller = self.view.frame.size.height;
    }
    else {
        bigger = self.view.frame.size.height;
        smaller = self.view.frame.size.width;
    }
    if (UIInterfaceOrientationPortrait == interfaceOrientation || UIInterfaceOrientationPortraitUpsideDown == interfaceOrientation) {
        self.view.frame = CGRectMake(0, 0, smaller, bigger);
        m_webView.frame = CGRectMake(0, 0, smaller, bigger);
//        m_loadingView.frame = CGRectMake(0, 0, smaller, bigger);
        
    }
    else {
        
//        self.view.frame = CGRectMake(0, 0, smaller, bigger);
//        m_webView.frame = CGRectMake(0, 0, smaller, bigger);
//        m_loadingView.frame = CGRectMake(0, 0, smaller, bigger);
        //不支持横屏
        return NO;
        
//        self.view.frame = CGRectMake(0, 0, bigger, smaller);
//        m_webView.frame = CGRectMake(0, 0, bigger, smaller);
//        m_loadingView.frame = CGRectMake(0, 0, bigger, smaller);
        
    }
    
    [self.view setNeedsDisplay];
    
//    m_loadingView.center = m_webView.center;
    
//    NSLog(@"@@@@@@@@@@@@@@@@ %d %@",interfaceOrientation,NSStringFromCGRect(self.view.frame));
    return YES;
}

- (void)popVCAction:(id)sender
{
    if (!self.shouldNotGoback) {
        if (self.m_webView.canGoBack) {
            [self.m_webView goBack];
        } else {
            [super popVCAction:sender];
        }
    } else {
        [super popVCAction:sender];
    }
}

//TODO: 隐藏viewController
-(void)backController
{
//    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismissQRCodeVC
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
//初始化webview
-(void)initWebViewWithURL:(NSURL *)requestUrl
{
    m_webView = [[QWWebView alloc] initWithFrame:CGRectMake(0, 0, APP_W, APP_H-44.0f)];
    m_webView.delegate = self;
    //m_webView.scalesPageToFit = YES;
    m_webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:m_webView];
    
    [m_webView loadRequest:[self getRequestWithURL:requestUrl]];
//    [self loadHtml:requestUrl];
    
//    m_loadingView = [[QWLoading alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 
//                                                                 self.view.frame.size.height)];
//
//    m_loadingView.hidden = NO;
//    
//    [self.view addSubview:m_loadingView];
    
    
    
    UIImage * image = [UIImage imageNamed:@"back1"];
    UIImage * imageH = [UIImage imageNamed:@"back1H"];
    
    UIButton * backBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 
                                                                    image.size.width, 
                                                                    image.size.height)];
    [backBtn addTarget:self action:@selector(backController) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:image forState:UIControlStateNormal];
    [backBtn setBackgroundImage:imageH forState:UIControlStateHighlighted];
    
    [self.view addSubview:backBtn];
    
   
}


-(void)initWebViewWithURL:(NSURL *)requestUrl  webview:(QWWebView *)view
{
    m_webView = view;
    m_webView.delegate = self;
    //m_webView.scalesPageToFit = YES;
    m_webView.backgroundColor = [UIColor clearColor];
    //[self.view addSubview:m_webView];
    
    [m_webView loadRequest:[self getRequestWithURL:requestUrl]];
 
}

//TODO: 重载预留 如需支持Post继承该函数
-(NSURLRequest *)getRequestWithURL:(NSURL *)requestUrl
{
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:requestUrl] ;
    
    return request;
}

//TODO: 刷新
-(void)reloadWebView
{
 
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    NSLog(@"didFailLoadWithError");
    
//    if (m_loadingView.hidden) {
//        [m_loadingView startActivityView];
//        m_loadingView.hidden = NO;
//    }
    DDLogError(@"web fail load %@", [error description]);
    if ([error code] != NSURLErrorCancelled) {
        [self.m_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@app/html/help/fail.html",BASE_URL_V2]]]];
    }
}

- (void)loadHtml:(NSString *)src{
    NSURL *url = nil;
    
    if ([src hasPrefix:@"http://"]) {
        
        url = [NSURL URLWithString:src];
        
    }else if ([src hasPrefix:@"https://"]){
        
        url = [NSURL URLWithString:src];
        
    }else if ([src hasPrefix:@"/"]) {
//        NSString *serverURL = [[RYTConfig sharedRYTConfig] serverURL];
//        
//        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", serverURL, src]];
    }else if ([src hasPrefix:@"local:"]){
        NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [arrayPaths objectAtIndex:0];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *name = [src substringFromIndex:6];
        /*
         先检测插件包，然后离线资源包，write接口写的文件包，最后安装包
         */
        NSString *resourcePath = [docDir stringByAppendingPathComponent:PLUG_IN_RESOURCES];
        NSString *path = [resourcePath stringByAppendingPathComponent:name];
        NSString *finalPath = nil;
        if ([fileManager fileExistsAtPath:path]) {
             finalPath = path;
        }
        if (finalPath == nil) {
            resourcePath = [docDir stringByAppendingPathComponent:OFFLINE_RESOURCES];
            path = [resourcePath stringByAppendingPathComponent:name];
            if ([fileManager fileExistsAtPath:path]) {
                 finalPath = path;
            }
        }
        if (finalPath == nil) {
            resourcePath = [docDir stringByAppendingPathComponent:WRITE_RESOURCES];
            path = [resourcePath stringByAppendingPathComponent:name];
            if ([fileManager fileExistsAtPath:path]) {
                 finalPath = path;
            }
        }
        if (finalPath == nil) {
            path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
            if ([fileManager fileExistsAtPath:path]) {
                 finalPath = path;
            }
        }
        
        if (finalPath) {
            NSData *data = [NSData dataWithContentsOfFile:finalPath];
            if (data) {
                
                url = [NSURL fileURLWithPath:finalPath];
                
                NSURL *baseURL = [url URLByDeletingLastPathComponent];
                [m_webView loadData:data MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:baseURL];
                
                return;
                
            }
            
        }
    }
    
    if (url) {
        
        //        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        //忽略本地缓存
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
        
        //
        /***** move to -webView:shouldStartLoadWithRequest:
         if ([url.absoluteString hasPrefix:@"https:"]) {
         _request = [[NSMutableURLRequest alloc]initWithURL:url];
         [(NSMutableURLRequest *)_request setHTTPMethod:@"GET"];
         NSURLConnection *connect = [NSURLConnection connectionWithRequest:_request delegate:self];
         [connect start];
         
         }else{
         [webview_ loadRequest:request];
         }
         *********/
        [m_webView loadRequest:request];
        
    }
}
//- (CGSize)sizeThatFits:(CGSize)size {
//    
//    [super sizeThatFits:size];
//    
//    
//    [self loadHtml:srcs];
//    
//    //
//    if ([[UIScreen mainScreen] bounds].size.height > 480) {
//        //        self.frame = CGRectMake(0, 0, self.frame.size.width, 457);
//        self.frame = CGRectMake(0, 0, self.frame.size.width, 508); //
//    }
//    return self.frame.size;
//    
//}
- (void)setInnerHTML:(NSString *)content {
    if (m_webView && content) {
        [m_webView loadHTMLString:content baseURL:nil];
    }
}
- (void)addAudioRef:(id)audio{
    if (audioCache == nil) {
        audioCache = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [audioCache addObject:audio];
}
- (void)removeAudioRef:(id)audio{
    
    if (audioCache) {
        [audioCache removeObject:audio];
    }
}
- (void)addVideoRef:(id)video{
    if (_videoCache == nil) {
        _videoCache = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [_videoCache addObject:video];
    
}
- (void)removeVideoRef:(id)video{
    
    if (_videoCache) {
        [_videoCache removeObject:video];
    }
}
- (void)stopAndFreePlay{
    if (audioCache) {
        [self willChangeValueForKey:@"audioCache"];
        [audioCache removeAllObjects];
        [self didChangeValueForKey:@"audioCache"];
        
    }
    if (_videoCache) {
        [self willChangeValueForKey:@"videoCache"];
        [_videoCache removeAllObjects];
        [self didChangeValueForKey:@"videoCache"];
    }
    
}
/**
 Returns an instance of a RYTJSExtension object, based on its name.  If one exists already, it is returned.
 */
- (id)getClassInstance:(NSString*)serviceName {
    // first, we try to find the className in the RYTJSExtensionsList.plist
    // (acts as a whitelist as well) if it does not exist, we return nil
    // NOTE: plugin names are matched as lowercase to avoid problems - however, a
    // possible issue is there can be duplicates possible if you had:
    // "emp.Foo" and "emp.foo" - only the lower-cased entry will match
    NSString* className = [[QWJSExtensionsList sharedRYTJSExtensionsList] classNameByService:serviceName];
    if (className == nil) {
        return nil;
    }
    
    id obj = [jsExtensions_ objectForKey:className];
    if (!obj) {
        obj = [[NSClassFromString(className) alloc] initWithWebView:m_webView];
        
        if (obj != nil) {
            [jsExtensions_ setObject:obj forKey:className];
       
        } else {
            NSLog(@"QWJSBridge class %@ (serviceName: %@) does not exist.", className, serviceName);
        }
    }
    return obj;
}


- (BOOL)execute:(QWWebviewInvokedURLCommand *)command {
    
    if (command.serviceName == nil || command.methodName == nil) {
        return NO;
    }
    
    // Fetch an instance of this class
    id obj = [self getClassInstance:command.serviceName];
    
    if (!([obj isKindOfClass:[QWJSExtension class]])) { // still allow deprecated class, until 1.0 release
        NSLog(@"ERROR: JS Extension Class '%@' not found, or is not a Class. Check your extensions mapping in RYTJSExtensionsList.plist.", command.serviceName);
        return NO;
    }
    
    
    BOOL retVal = YES;
    // construct the fill method name to ammend the second argument.
    NSString *fullMethodName = [[NSString alloc] initWithFormat:@"%@:withDict:", command.methodName];
    if ([obj respondsToSelector:NSSelectorFromString(fullMethodName)]) {
        [obj performSelector:NSSelectorFromString(fullMethodName) withObject:command.arguments withObject:command.options];
    } else {
        // There's no method to call, so throw an error.
        NSLog(@"ERROR: Method '%@' not defined in RYTJSExtension sub class '%@'", fullMethodName, command.serviceName);
        retVal = NO;
    }
 
    
    return retVal;
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if (webView != m_webView) {
        return NO;
    }
    
    NSURL *url = [request URL];
    
    
    //
//    if ([@"https" isEqualToString:[url scheme]] && ![[self.reqUrl absoluteString] isEqualToString:[url absoluteString]]) {
//        self.reqUrl = url;
//        NSURLRequest *req = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0f];
//        NSURLConnection *urlConn = [NSURLConnection connectionWithRequest:req delegate:self];
//        [urlConn start];
//        return NO;
//    }
    
    
    
    
    /*
     * Get Command and Options From URL
     * We are looking for URLS that match emp://<Class>.<command>/[<arguments>][?<dictionary>]
     * We have to strip off the leading slash for the options.
     */
    if ([[url scheme] isEqualToString:@"emp"]) {
        QWWebviewInvokedURLCommand* iuc =  [QWWebviewInvokedURLCommand newFromUrl:url]  ;
        
        // Tell the JS code that we've gotten this command, and we're ready for another
        [webView stringByEvaluatingJavaScriptFromString:@"QWJSBridge.queue.ready = true;"];
        
        // Check to see if we are provided a class:method style command.
        [self execute:iuc];
        
        return NO;
    }
    /*
     * If a URL is being loaded that's a file/http/https URL, just load it internally
     */
    else if ([url isFileURL]) {
        return YES;
    }
    else if ([[url scheme] isEqualToString:@"http"] || [[url scheme] isEqualToString:@"https"]) {
        return YES;
    }
    /*
     *	If we loaded the HTML from a string, we let the app handle it
     */
    else if (loadFromString_ == YES) {
        return YES;
    }
    /*
     * We don't have a PhoneGap or web/local request, load it in the main Safari browser.
     * pass this to the application to handle.  Could be a mailto:dude@duderanch.com or a tel:55555555 or sms:55555555 facetime:55555555
     */
    else {
        NSLog(@"shouldStartLoadWithRequest: Received Unhandled URL %@", url);
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    
    return YES;
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    // /*
    // Share session key with the WebView by setting RYTJSBridge.sessionKey
    NSString *sessionKeyScript = [NSString stringWithFormat:@"QWJSBridge.sessionKey = \"%@\";", sessionKey_];
    [webView stringByEvaluatingJavaScriptFromString:sessionKeyScript];
    
    // load EMPJSBridge.js
    if (![[webView stringByEvaluatingJavaScriptFromString:@"typeof QWJSBridge == 'object'"] isEqualToString:@"true"]) {
//        NSString *filePath = [[NSBundle mainBundle] pathForAuxiliaryExecutable:@"EMPJSBridge.js"];
//        NSString *js = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//        [webView stringByEvaluatingJavaScriptFromString:js];
//        NSString *filePath1 = [[NSBundle mainBundle] pathForAuxiliaryExecutable:@"QWJSBridge-1.0.0.js"];
//        NSString *js1 = [NSString stringWithContentsOfFile:filePath1 encoding:NSUTF8StringEncoding error:nil];
//        [webView stringByEvaluatingJavaScriptFromString:js1];
//        NSString *filePath2 = [[NSBundle mainBundle] pathForAuxiliaryExecutable:@"QWJSBridge-1.0.0.js"];
//        NSString *js2 = [NSString stringWithContentsOfFile:filePath2 encoding:NSUTF8StringEncoding error:nil];
//        [webView stringByEvaluatingJavaScriptFromString:js2];
    }
 
    //  */
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    if (m_webView != webView) {
        return;
    }
    //  /*
    // Share session key with the WebView by setting RYTJSBridge.sessionKey
    NSString *sessionKeyScript = [NSString stringWithFormat:@"QWJSBridge.sessionKey = \"%@\";", sessionKey_];
    [webView stringByEvaluatingJavaScriptFromString:sessionKeyScript];
    
    // load EMPJSBridge.js
    if (![[webView stringByEvaluatingJavaScriptFromString:@"typeof QWJSBridge == 'object'"] isEqualToString:@"true"]) {
//        NSString *filePath = [[NSBundle mainBundle] pathForAuxiliaryExecutable:@"QWJSBridge-1.0.0.js"];
//        NSString *js = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//        [webView stringByEvaluatingJavaScriptFromString:js];
    }
    if([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.delegate webViewDidFinishLoad:webView];
    }
}



#pragma mark - add by chang -
#pragma mark NSURLConnection delegate
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace{
    NSLog(@"canAuthenticateAgainstProtectionSpace ===== %@",protectionSpace.description);
    return YES;
    // return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}
//- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
//    NSLog(@"didReceiveAuthenticationChallenge ====== %@",challenge.description);
//    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
//    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
//    [webview_ loadRequest:_request];
//}

//
//3、添加
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [m_webView loadRequest:[NSURLRequest requestWithURL:self.reqUrl]];
}

//4、修改- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge方法：
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
}

#pragma mark
#pragma mark - CLLocationManager delgate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    curLat = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude] ;
    curLog = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude]  ;
    
    [manager stopUpdatingLocation ];
    NSLog(@"curLatis ->%@",curLat);
    NSLog(@"curLog ->%@",curLog);
    [self loadHtml:srcs];
    
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    curLat = @"";
    curLog = @"";
    [manager stopUpdatingLocation];
    [self loadHtml:srcs];
}

@end
@implementation UIWebView (JavaScriptAlert)

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame {
    
    
    UIAlertView* dialogue = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
    [dialogue show];;
    
   
    
}
-(BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame{
    UIAlertView* dialogue = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"Ok") otherButtonTitles:NSLocalizedString(@"Cancel", @"Cancel"), nil];
    [dialogue show];
    while (dialogue.hidden==NO && dialogue.superview!=nil) {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
    }
    
    return diagStat;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        
         diagStat=YES;
        NSLog(@"buttonIndex==0");
    }else if(buttonIndex==1){
        
         diagStat=NO;
          NSLog(@"buttonIndex==1");;
    }
}
@end