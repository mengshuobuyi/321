 

#import <UIKit/UIKit.h>
#import "QWWebView.h"
//#import "QWLoading.h"
#import "QWBaseVC.h"
#import "QWWebviewInvokedURLCommand.h"

@interface UIWebView (JavaScriptAlert)

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame;

@end
@interface QWWebViewController : QWBaseVC
{
    
    
    //设备标示
    int m_deviceTag;
    
//    QWLoading * m_loadingView;
    
    BOOL                        loadFromString_;
    NSMutableDictionary         *jsExtensions_;
    NSString                    *sessionKey_;
    
    
    //add by chang;
    NSURLRequest              *_request;
    NSString *srcs;
    NSString *curLat;
    NSString *curLog;
    
}



-(void)initWebViewWithURL:(NSURL *)requestUrl;
-(void)reloadWebView;
- (void)loadHtml:(NSString *)src;
@property (nonatomic , strong) QWWebView * m_webView;
@property (nonatomic, copy) NSURL     *reqUrl;
@property (nonatomic, assign) BOOL shouldNotGoback;
/**
 Returns an instance of a RYTJSExtension object, based on its name.  If one exists already, it is returned.
 */

-(void)initWebViewWithURL:(NSURL *)requestUrl  webview:(QWWebView *)view;

- (id)getClassInstance:(NSString*)serviceName;

- (BOOL)execute:(QWWebviewInvokedURLCommand *)command;

- (void)doLuaScript:(NSString *)script;

- (void)copyJSFileToDocument;

- (void)addVideoRef:(id)video;
- (void)addAudioRef:(id)audio;
- (void)removeAudioRef:(id)audio;
- (void)removeVideoRef:(id)video;

- (void)dismissQRCodeVC;

@end
