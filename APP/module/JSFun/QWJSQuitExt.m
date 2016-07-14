//
//  QWJSQuitExt.m
//  APP
//
//  Created by YYX on 15/8/10.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWJSQuitExt.h"
//#import "QZSettingViewController.h"

@implementation QWJSQuitExt

- (void)calloutQuitVC:(NSArray *)arguments withDict:(NSDictionary *)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    self.jsCallbackId_ = callbackId;
    
//    QZSettingViewController *setting = [[QZSettingViewController alloc] init];
    
//    setting.passTokenBlock = ^(NSString *token){
//        
//        [self writeScript:self.jsCallbackId_ messageString:token state:SUCCESS keepCallback:NO];
//    };
    
    QWWebViewController *webView = (QWWebViewController *)self.webView.delegate;
//    [webView presentViewController:setting animated:YES completion:nil];
}

@end
