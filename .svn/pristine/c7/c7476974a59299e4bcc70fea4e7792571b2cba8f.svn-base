

#import "QWJSLoginExt.h"
#import "QWWebViewController.h"
#import "LoginViewController.h"
//#import "QZSettingViewController.h"

#define SUCCESS 0
#define UNKNOWN_ERROR 1
#define OPEN_SMS_FAIL_ERROR 2


@implementation QWJSLoginExt
@synthesize jsCallbackId_;


- (void)calloutLoginVC:(NSArray *)arguments withDict:(NSDictionary *)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    self.jsCallbackId_ = callbackId;
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *navgationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
//    loginViewController.isPresentType = YES;
//    
//    loginViewController.passTokenBlock = ^(NSString *token){
//        
//        [self writeScript:self.jsCallbackId_ messageString:token state:SUCCESS keepCallback:NO];
//    };
    
    QWWebViewController *webView = (QWWebViewController *)self.webView.delegate;
    [webView presentViewController:navgationController animated:YES completion:nil];
}

- (void)calloutLijianTest:(NSArray *)arguments withDict:(NSDictionary *)options{

    NSString* callbackId = [arguments objectAtIndex:0];
    self.jsCallbackId_ = callbackId;
    [self writeScript:self.jsCallbackId_ messageString:@"lijiangogogo" state:SUCCESS keepCallback:NO];
}

@end
