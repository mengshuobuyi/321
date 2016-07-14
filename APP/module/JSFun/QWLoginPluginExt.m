//
//  QWLoginPluginExt.m
//  APP
//
//  Created by PerryChen on 8/26/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import "QWLoginPluginExt.h"
#import "LoginViewController.h"
//#import "QZSettingViewController.h"

#define SUCCESS 0
#define UNKNOWN_ERROR 1
#define OPEN_SMS_FAIL_ERROR 2

@implementation QWLoginPluginExt
-(void)login:(NSArray *)arguments withDict:(NSDictionary *)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    self.jsCallbackId_ = callbackId;
    
    NSLog(@"teh str params is %@",options);
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *navgationController = [[QWBaseNavigationController alloc] initWithRootViewController:loginViewController];
//    loginViewController.isPresentType = YES;
//    
//    loginViewController.passTokenBlock = ^(NSString *token){
    
//        [self writeScript:self.jsCallbackId_ messageString:token state:SUCCESS keepCallback:NO];
//    };
    
    QWWebViewController *webView = (QWWebViewController *)self.webView.delegate;
    [webView presentViewController:navgationController animated:YES completion:nil];
}
@end
