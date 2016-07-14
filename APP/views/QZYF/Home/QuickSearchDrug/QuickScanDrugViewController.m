//
//  QuickScanDrugViewController.m
//  wenYao-store
//
//  Created by YYX on 15/6/9.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QuickScanDrugViewController.h"
#import "QuickScanDrugListViewController.h"
#import "Drug.h"
#import "SVProgressHUD.h"
#import "DrugModel.h"

@interface QuickScanDrugViewController ()
@end

@implementation QuickScanDrugViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"条形码";
}

- (void)popVCAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)reStartScan
{
    if (self.timer) {
        self.timer = nil;
    }
    if (self.iosScanView) {
        [self.iosScanView startRunning];
    }
}


- (void) IOSScanResult: (NSString*) scanCode WithType:(NSString *)type
{
    //进行业务逻辑处理
    DebugLog(@" IOSScanResult扫到的条码 ===>%@",scanCode);

    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showError:kWaring12];
        return;
    }
    
    if(scanCode.length <= 15){
        [self normalScan:scanCode];
        return;
    }
}

- (void)normalScan:(NSString *)proId
{
    
    //扫码获取商品信息
    
    if (self.sendMedicineByStore)
    {
        //本店咨询
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"branchId"] = StrFromObj(QWGLOBALMANAGER.configure.groupId);
        setting[@"key"] = StrFromObj(proId);
        
        [Drug MmallByBarcodeWithParams:setting success:^(id DFUserModel) {
            
            StoreSearchMedicinePageModel *page = [StoreSearchMedicinePageModel parse:DFUserModel Elements:[ExpertSearchMedicineListModel class] forAttribute:@"productList"];
            
            if([page.apiStatus intValue] == 0)
            {
                if (page.productList.count > 0)
                {
                    ExpertSearchMedicineListModel *model = page.productList[0];
                    
                    QuickScanDrugListViewController *scan = [[QuickScanDrugListViewController alloc]initWithNibName:@"QuickScanDrugListViewController" bundle:nil];
                    scan.product = model;
                    scan.sendMedicineByStore = self.sendMedicineByStore;
                    [self.navigationController pushViewController:scan animated:YES];
                    
                    if (self.block) {
                        scan.block = ^(id model){
                            productclassBykwId *product = model;
                            self.block(product);
                        };
                    }
                }else
                {
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(reStartScan) userInfo:nil repeats:NO];
                    [SVProgressHUD showErrorWithStatus:@"条码无效或本店暂无此药品销售" duration:DURATION_SHORT];
                }
            }else
            {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(reStartScan) userInfo:nil repeats:NO];
                [SVProgressHUD showErrorWithStatus:@"条码无效或本店暂无此药品销售" duration:DURATION_SHORT];
            }
        } failure:^(HttpException *e) {
            [SVProgressHUD showErrorWithStatus:e.Edescription duration:DURATION_SHORT];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(reStartScan) userInfo:nil repeats:NO];
        }];
        
    }else
    {
        //专家咨询
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"barCode"] = StrFromObj(proId);
        
        [Drug ProductQueryProductByBarCodeWithParams:setting success:^(id DFUserModel) {
            
            ExpertSearchMedicinePageModel *page = [ExpertSearchMedicinePageModel parse:DFUserModel Elements:[ExpertSearchMedicineListModel class] forAttribute:@"qwProductList"];
            
            if([page.apiStatus intValue] == 0)
            {
                
                if (page.qwProductList.count > 0)
                {
                    ExpertSearchMedicineListModel *model = page.qwProductList[0];
                    QuickScanDrugListViewController *scan = [[QuickScanDrugListViewController alloc]initWithNibName:@"QuickScanDrugListViewController" bundle:nil];
                    scan.product = model;
                    scan.sendMedicineByStore = self.sendMedicineByStore;
                    [self.navigationController pushViewController:scan animated:YES];
                    
                    if (self.block) {
                        scan.block = ^(id model){
                            productclassBykwId *product = model;
                            self.block(product);
                        };
                    }
                }else
                {
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(reStartScan) userInfo:nil repeats:NO];
                    [SVProgressHUD showErrorWithStatus:@"未搜索到此商品" duration:DURATION_SHORT];
                }
                
            }else
            {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(reStartScan) userInfo:nil repeats:NO];
                [SVProgressHUD showErrorWithStatus:@"未搜索到此商品" duration:DURATION_SHORT];
            }
            
        } failure:^(HttpException *e) {
            [SVProgressHUD showErrorWithStatus:e.Edescription duration:DURATION_SHORT];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(reStartScan) userInfo:nil repeats:NO];

        }];
    }
}


@end
