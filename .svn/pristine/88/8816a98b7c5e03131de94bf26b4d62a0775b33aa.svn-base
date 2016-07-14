//
//  QWShippingDiscoveryExt.m
//  wenYao-store
//
//  Created by PerryChen on 6/28/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "QWShippingDiscoveryExt.h"
#import "WebDirectModel.h"
#import "WebDirectViewController.h"
#import "QWH5Loading.h"
#define SUCCESS 0
#define UNKNOWN_ERROR 1
#define OPEN_SMS_FAIL_ERROR 2
@implementation QWShippingDiscoveryExt
-(void)getDiscoveryInfo:(NSArray *)arguments withDict:(NSDictionary *)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    self.jsCallbackId_ = callbackId;
    NSLog(@"teh str params is %@",options);
    WebDirectViewController *webView = (WebDirectViewController *)self.webView.delegate;
    if (webView.modelLocal.modelAnswer!=nil) {
        NSMutableDictionary *dd=[NSMutableDictionary dictionary];
        dd[@"title"]=webView.modelLocal.modelAnswer.title;
        dd[@"content"]=webView.modelLocal.modelAnswer.content;
        NSString *jsonString = nil;
        
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dd options:NSJSONWritingPrettyPrinted error:&error];
        if([jsonData length] > 0 && error == nil) {
            jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self writeScript:self.jsCallbackId_ messageString:jsonString state:SUCCESS keepCallback:NO];
        });
    }
}

@end
