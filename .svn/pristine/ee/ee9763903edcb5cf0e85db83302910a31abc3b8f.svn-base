//
//  QWShippingAddressExt.m
//  APP
//  积分商城下兑换邮递物品  调本地选择地址页面
//  Created by PerryChen on 1/15/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "QWShippingAddressExt.h"
#import "WebDirectViewController.h"
#import "MyReceiveAddressViewController.h"
#import "EditAddressViewController.h"
#import "QWGlobalManager.h"
#import "QWLocation.h"
#define SUCCESS 0
#define UNKNOWN_ERROR 1
#define OPEN_SMS_FAIL_ERROR 2
@implementation QWShippingAddressExt
-(void)getAddressInfo:(NSArray *)arguments withDict:(NSDictionary *)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    self.jsCallbackId_ = callbackId;
    MyReceiveAddressViewController *vc = [[MyReceiveAddressViewController alloc]initWithNibName:@"MyReceiveAddressViewController" bundle:nil];
    vc.pageFrom = PageComeFromH5;
    WebDirectViewController *webView = (WebDirectViewController *)self.webView.delegate;
    __weak typeof(self) weakSelf = self;
    vc.addressBlock = ^(NSString *address){
        [weakSelf writeScript:self.jsCallbackId_ messageString:address state:SUCCESS keepCallback:NO];
    };
    [webView.navigationController pushViewController:vc animated:YES];
}
-(void)getNewAddress:(NSArray *)arguments withDict:(NSDictionary *)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    self.jsCallbackId_ = callbackId;
    EditAddressViewController *vc = [[EditAddressViewController alloc]initWithNibName:@"EditAddressViewController" bundle:nil];
    WebDirectViewController *webView = (WebDirectViewController *)self.webView.delegate;
    vc.pageType = AddressPageTypeAdd;
    vc.pageFrom = PageComeFromH5;
      __weak typeof(self) weakSelf = self;
    vc.addressBlock = ^(NSString *address){
        [weakSelf writeScript:self.jsCallbackId_ messageString:address state:SUCCESS keepCallback:NO];
    };
    [webView.navigationController pushViewController:vc animated:YES];
}
@end
