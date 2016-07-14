//
//  QWShareExt.m
//  APP
//
//  Created by PerryChen on 8/27/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import "QWShareExt.h"
#import "WebDirectViewController.h"
#define SUCCESS 0
#define UNKNOWN_ERROR 1
#define OPEN_SMS_FAIL_ERROR 2
@implementation QWShareExt
-(void):(NSArray *)arguments withDict:(NSDictionary *)options
{
    WebDirectViewController *vcWeb = (WebDirectViewController *)(self.webView.delegate);
    vcWeb.extShare = self;
    NSString* callbackId = [arguments objectAtIndex:0];
    self.jsCallbackId_ = callbackId;
}

//-(void)runExtWithCallBackId:(NSString *)strCallbackID
//{
//   [self writeScript:self.jsCallbackId_ messageString:@"share" state:SUCCESS keepCallback:YES];
//}
@end
