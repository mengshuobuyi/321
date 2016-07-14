

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QWWebViewController.h"





@interface QWJSExtension : NSObject {
}

@property (nonatomic, retain) QWWebView *webView;

///---------------------------------------------------------------------------------------
/// @name Initialization & disposal
///---------------------------------------------------------------------------------------
- (QWJSExtension *)initWithWebView:(UIWebView *)theWebView;

///---------------------------------------------------------------------------------------
/// @name load script
///---------------------------------------------------------------------------------------

/**
    加载，执行javascript 脚本
 */
- (NSString *)evaluatingJavascript:(NSString *)javascript;
/**
    执行回调语句
 @param callbackId 回调方法的索引
 @param message    回调方法返回的信息，为js字符串
 @param state      执行状态
    
 */
- (void)writeScript:(NSString *)callbackId messageString:(NSString *)message state:(int)state keepCallback:(BOOL)keep;

/**
 执行回调语句
 @param callbackId 回调方法的索引
 @param message    回调方法返回的信息，js对象
 @param state      执行状态
 
 */
- (void)writeScript:(NSString *)callbackId message:(NSString *)message state:(int)state keepCallback:(BOOL)keep;

///---------------------------------------------------------------------------------------
/// @name memory conrrol
///---------------------------------------------------------------------------------------

/**
    you can override this if you need to do any cleanup on app exit
 */
- (void)onAppTerminate;

/**
    you can override to remove caches, etc
 */
- (void)onMemoryWarning;

@end
