//
//  QWPluAppPluginExt.m
//  APP
//
//  Created by PerryChen on 8/25/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import "QWPluAppPluginExt.h"
#import "WebDirectModel.h"
#import "WebDirectViewController.h"
#import "QWH5Loading.h"
@implementation QWPluAppPluginExt
-(void)startAppPlugin:(NSArray *)arguments withDict:(NSDictionary *)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    self.jsCallbackId_ = callbackId;
    
    NSLog(@"teh str params is %@",options);
    
    WebDirectViewController *vcWeb = (WebDirectViewController *)(self.webView.delegate);
    
    WebPluginModel *modelPlu = [WebPluginModel parse:options Elements:[WebPluginParamsModel class] forAttribute:@"params"];
    
    if ([modelPlu.type intValue] == 1) {
        
        // title 替换
        vcWeb.title = modelPlu.params.title;
    } else if ([modelPlu.type intValue] == 2) {
        // 打电话
        [vcWeb actionPhoneWithNumber:modelPlu.message];
    } else if ([modelPlu.type intValue] == 3) {
        // 分享
        [vcWeb actionShare:modelPlu];
    } else if ([modelPlu.type intValue] == 4) {
        // 提示框
        [vcWeb showAlertWithMessage:modelPlu.message];
    } else if ([modelPlu.type intValue] == 6) {
        // 显示原生Loading框
        [QWH5LOADING showLoading];
    } else if ([modelPlu.type intValue] == 7) {
        // 隐藏原生loading框
        [QWH5LOADING closeLoading];
    } else if ([modelPlu.type intValue] == 8) {
        [vcWeb popCurVC];
    }
    else if ([modelPlu.type intValue] == 9) {
        // H5通知加分享
        [vcWeb rightItemNeedShare];
    }    else if ([modelPlu.type intValue] == 14) {
        // title 替换
        vcWeb.title = modelPlu.message;
    }
}
@end
