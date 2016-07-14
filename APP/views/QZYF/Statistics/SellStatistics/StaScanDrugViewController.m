//
//  QuickScanDrugViewController.m
//  wenYao-store
//
//  Created by YYX on 15/6/9.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "StaScanDrugViewController.h"
#import "StaSearchDrugViewController.h"
#import "SellStatistics.h"

@interface StaScanDrugViewController ()

@end

@implementation StaScanDrugViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"条形码";
}

- (void)popVCAction:(id)sender{

    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark ---- 扫码结果回调 ----

- (void) IOSScanResult: (NSString*) scanCode WithType:(NSString *)type
{
    //进行业务逻辑处理
    [self normalScan:scanCode];
}

- (void)normalScan:(NSString *)proId
{
    QuerySearchPSModelR *modelR = [QuerySearchPSModelR new];
    modelR.barcode = proId;
    modelR.token= QWGLOBALMANAGER.configure.userToken;
    //扫码获取商品信息
    StaSearchDrugViewController *vc = [[StaSearchDrugViewController alloc] init];
    vc.typeSearch = @"1";
    vc.scanSource=[NSMutableArray array];
    
    [SellStatistics GetSearchPSWithParams:modelR success:^(id UFModel) {
        
        RptProductArrayVo *searchkey=[RptProductArrayVo parse:UFModel Elements:[RptProductVo class] forAttribute:@"products"];
        if([searchkey.apiStatus intValue] == 0){
            vc.scanSource = searchkey.products;
        }
        [self.navigationController pushViewController:vc animated:YES];
        
    }failure:^(HttpException *e){
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(reStartScan) userInfo:nil repeats:NO];
    }];
}

#pragma mark ---- 重新扫描 ----

- (void)reStartScan
{
    if (self.timer) {
        self.timer = nil;
    }
    if (self.iosScanView) {
        [self.iosScanView startRunning];
    }
}

@end
