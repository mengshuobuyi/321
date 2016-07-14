

#import "QWJSHttpExt.h"

@implementation QWJSHttpExt
@synthesize connectionType;
@synthesize jsCallbackId_;
@synthesize reachability_;

+ (instancetype)sharedInstance {
    static QWJSHttpExt *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[QWJSHttpExt alloc]init];
    });
    return _sharedInstance;
}

- (NSString*) w3cConnectionTypeFor:(Reachability*)reachability
{
	NetworkStatus networkStatus = [reachability currentReachabilityStatus];
	switch(networkStatus)
	{
        case NotReachable:
			return @"UNKNOWN";
        case ReachableViaWWAN:
			return @"WWAN"; // no generic default, so we use the lowest common denominator
        case ReachableViaWiFi:
			return @"WIFI";
		default:
			return @"none";
    }
}
- (void)updateConnectionType:(NSNotification *)notification{
    Reachability *reach = notification.object;
    if (reach != nil && [reach isKindOfClass:[Reachability class]])
	{   NSString *currentConnectionType = [self w3cConnectionTypeFor:reach];
        if ([self.connectionType isEqualToString:currentConnectionType]) {
            return;
        }
        self.connectionType = currentConnectionType;
        NSString *js = [NSString stringWithFormat:@"http.connectType = '%@';", self.connectionType];
        [self.webView stringByEvaluatingJavaScriptFromString:js];
        
        
	}
}
- (void) prepare
{
    self.reachability_ = [Reachability reachabilityForInternetConnection];
    [self.reachability_ startNotifier];
    
    self.connectionType = [self w3cConnectionTypeFor:self.reachability_];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateConnectionType:) name:kReachabilityChangedNotification object:nil];
	
}
- (QWJSExtension *)initWithWebView:(UIWebView *)theWebView{
    if (self = [super initWithWebView:theWebView]) {
        
        self.connectionType = @"none";
        [self prepare];
        
    }
    return self;
}

- (void)getConnectionInfo:(NSArray *)arguments withDict:(NSDictionary *)options{
    if ([arguments count]>0) {
        self.jsCallbackId_ = [arguments objectAtIndex:0];

        [self writeScript:self.jsCallbackId_ messageString:self.connectionType state:0 keepCallback:NO];

    }
}
- (void)isReachable:(NSArray *)arguments withDict:(NSDictionary *)options{
    if ([arguments count]>1) {
        self.jsCallbackId_ = [arguments objectAtIndex:0];
        NSString *uri = [arguments objectAtIndex:1];
        NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        uri = [uri stringByTrimmingCharactersInSet:characterSet];
        NSURL *url = [NSURL URLWithString:uri];
        NSString *hostName = url.host;
  
        Reachability *hostReach = [Reachability reachabilityWithHostName:hostName];
        NetworkStatus netStatus = [hostReach currentReachabilityStatus];
        BOOL reachable = NO;
        if (netStatus != kNotReachable) {
            reachable = YES;
        }

        [self writeScript:self.jsCallbackId_ message:reachable?@"true":@"false" state:0 keepCallback:NO];
    }
}


- (void)get:(NSArray *)arguments withDict:(NSDictionary *)options{
    
    if ([arguments count]>1) {
        self.jsCallbackId_ = [arguments objectAtIndex:0];
//        NSString *url=[options objectForKey:@"url"];
        NSString *url = [arguments objectAtIndex:1];
        NSDictionary *messageDictionary=nil;
        if([arguments count]>2){
            NSString *json = [arguments objectAtIndex:2];
            messageDictionary=[self jsonToDictionay:json];
        }
        [[HttpClient sharedInstance] getWithoutProgress:url params:messageDictionary success:^(id responseObj) {
            DebugLog(@"responseObj===>%@",responseObj);
            NSString *message=[self DataTOjsonString:responseObj];
            [self writeScript:self.jsCallbackId_ messageString:message state:0 keepCallback:NO];
        } failure:^(HttpException *e) {
            DebugLog(@"%@",e);
            [self writeScript:self.jsCallbackId_ message:@"fail" state:0 keepCallback:NO];
        }];
        
       
    }
}

-(NSDictionary*)jsonToDictionay:(NSString *)jsonNString{
//    NSString *jsonString = @"{\"Code\":\"111\",\"Remark\":\"成功\",\"Total\":1,\"Data\":{\"date\":[{\"Guid\":\"test\"}]}}";
    NSString *jsonString =jsonNString;
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *object = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    return object;
}



- (void)post:(NSArray *)arguments withDict:(NSDictionary *)options{
    if ([arguments count]>1) {
        self.jsCallbackId_ = [arguments objectAtIndex:0];
        NSString *url = [arguments objectAtIndex:1];
        NSDictionary *messageDictionary=nil;
        if([arguments count]>2){
        NSString *json = [arguments objectAtIndex:2];
        messageDictionary=[self jsonToDictionay:json];
        }
        [[HttpClient sharedInstance] postWithoutProgress:url params:messageDictionary success:^(id responseObj) {
            DebugLog(@"responseObj===>%@",responseObj);
            NSString *message=[self DataTOjsonString:responseObj];
            [self writeScript:self.jsCallbackId_ messageString:message state:0 keepCallback:NO];
        } failure:^(HttpException *e) {
            DebugLog(@"%@",e);
            [self writeScript:self.jsCallbackId_ message:@"fail" state:0 keepCallback:NO];
        }];
        
        
    }

}


-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
