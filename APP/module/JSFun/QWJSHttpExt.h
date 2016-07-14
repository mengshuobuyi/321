

#import "QWJSExtension.h"
#import "HttpClient.h"
/**
    JS 网络接口
 
 */
#define  JSHttpClient [QWJSHttpExt sharedInstance]
@interface QWJSHttpExt : QWJSExtension {

    NSString *connectionType;
    NSString                    *jsCallbackId_;
    Reachability                *reachability_;
}

@property (nonatomic,copy) NSString *connectionType;
@property (nonatomic, retain) Reachability *reachability_;
@property (nonatomic,copy) NSString *jsCallbackId_;

@property (nonatomic, readwrite) NSString * baseUrl;
@property (nonatomic ,strong) NSString *requestType;

+ (instancetype)sharedInstance;
/**
    获取网络连接状态
 */
- (void)getConnectionInfo:(NSArray *)arguments withDict:(NSDictionary *)options;

/**
    检测某个地址能否连接
 */
- (void)isReachable:(NSArray *)arguments withDict:(NSDictionary *)options;

/**
 get请求
 */
- (void)get:(NSArray *)arguments withDict:(NSDictionary *)options;
/**
 post请求
 */
- (void)post:(NSArray *)arguments withDict:(NSDictionary *)options;


/**
 登出接口
 by wsl;
 */
-(void)login_out:(NSArray *)arguments withDict:(NSDictionary *)options;

@end
