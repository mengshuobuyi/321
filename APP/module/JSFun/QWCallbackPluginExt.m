//
//  QWCallbackPluginExt.m
//  APP
//
//  Created by PerryChen on 8/28/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import "QWCallbackPluginExt.h"
#import "WebDirectViewController.h"
#import "WebDirectModel.h"

#define SUCCESS 0
#define UNKNOWN_ERROR 1
#define OPEN_SMS_FAIL_ERROR 2

@implementation QWCallbackPluginExt

-(void):(NSArray *)arguments withDict:(NSDictionary *)options
{
    WebDirectViewController *vcWeb = (WebDirectViewController *)(self.webView.delegate);
    vcWeb.extShare = self;
    NSString* callbackId = [arguments objectAtIndex:0];
    self.jsCallbackId_ = callbackId;
}
-(void)runExtWithCallBackPageType:(NSString *)strPageType
{
    [self writeScript:self.jsCallbackId_ messageString:strPageType state:SUCCESS keepCallback:YES];
}

-(void)runExtWithCallBackId:(CallbackType)callbackType
{
    [self writeScript:self.jsCallbackId_ messageString:[NSString stringWithFormat:@"%ld",callbackType] state:SUCCESS keepCallback:YES];
}
@end
