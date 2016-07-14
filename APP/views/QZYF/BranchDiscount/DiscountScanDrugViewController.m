//
//  QuickScanDrugViewController.m
//  wenYao-store
//
//  Created by YYX on 15/6/9.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "DiscountScanDrugViewController.h"
#import "DiscountSearchDrugViewController.h"
#import "Drug.h"

@interface DiscountScanDrugViewController ()

@end

@implementation DiscountScanDrugViewController

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
    //进行业务逻辑处理 优惠商品的扫码搜索页面
    [self normalScan:scanCode];
}

- (void)normalScan:(NSString *)proId
{
    DiscountSearchDrugViewController *vc = [[DiscountSearchDrugViewController alloc] init];
    vc.typeSearch = @"1";
    vc.scanSource=[NSMutableArray array];
    vc.SendNewProduct = self.HoldSendNewProduct;
    
    GetCoupnScanKeywordR *modelR = [GetCoupnScanKeywordR new];
    modelR.barCode = proId;
    modelR.branchId = QWGLOBALMANAGER.configure.groupId;
    //扫码获取商品信息
    [Drug scansearchCoupnKeywordsWithParam:modelR Success:^(id UFModel) {
        
        GetSearchKeywordsModel *searchModel = UFModel;
        if([searchModel.apiStatus intValue] == 0){
            
            if(self.SendNewScan){
                self.SendNewScan((NSMutableArray *)searchModel.list);
            }
            if(self.holdViewController) {
                self.holdViewController.typeSearch = @"1";
                self.holdViewController.scanSource = (NSMutableArray *)searchModel.list;
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                vc.scanSource = (NSMutableArray *)searchModel.list;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else{
            if(self.holdViewController) {
                self.holdViewController.typeSearch = @"1";
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }failure:^(HttpException *e){
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(reStartScan) userInfo:nil repeats:NO];
    }];
    
}

-(DrugVo *)changeModel:(BranchSearchPromotionProVO*)model{
    DrugVo *mod=[DrugVo new];
    mod.proId=model.proId;
    mod.proName=model.proName;
    mod.spec=model.spec;
    mod.factoryName=model.factory;
    mod.imgUrl=model.imgUrl;
    mod.pid=model.promotionId;
    mod.label=model.lable;
    mod.source=model.source;
    mod.beginDate=model.startDate;
    mod.endDate=model.endDate;
    return mod;
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
