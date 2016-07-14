//
//  APP
//
//  Created by cao_jing on 15/2/27.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "AllScanReaderViewController.h"
#import "VerifyDetailViewController.h"
#import "ScanDrugViewController.h"
#import "InfomationOrderViewController.h"
#import "IndentDetailListViewController.h"
#import "InternalProduct.h"
#import "WebDirectViewController.h"

@interface AllScanReaderViewController ()

@end

@implementation AllScanReaderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(self.scanType==Enum_Scan_Items_Slow){
        self.title = @"请扫描所购商品的条形码";
    }else if(self.scanType==Enum_Scan_Items_Index){
        self.title = @"扫码验证";
    }else if(self.scanType==Enum_Scan_Items_Common){
        self.title = @"请扫描所购商品的条形码";
    }else if(self.scanType==Enum_Scan_Items_QuickOrder){
        self.title = @"扫描运单号";
    }else if (self.scanType==Enum_Scan_Items_InterProduct) {
        self.title = @"扫描药品条形码";
    }else if (self.scanType==Enum_Scan_Items_ProductSales){
        self.title = @"扫描药品";
    }else if (self.scanType==Enum_Scan_Items_AddInternalProduct){
        self.title = @"扫描条形码";
    }else{
        self.title = @"扫码验证";
    }
}

#pragma mark ---- 扫码结果回调 ----

- (void) IOSScanResult: (NSString*) scanCode WithType:(NSString *)type
{
    //进行业务逻辑处理
    [self DealResult:scanCode WithType:(NSString *)type];
}

#pragma mark ---- 根据扫描结果进行业务逻辑处理 ----

- (void)DealResult:(NSString *)scanCode WithType:(NSString *)type
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showError:kWaring12];
        return;
    }
    if(self.scanType==Enum_Scan_Items_Slow)
    {
        [self slowNormalScan:scanCode];
    }else if(self.scanType==Enum_Scan_Items_Index){
        //首页增加外链
        if (([scanCode hasPrefix:@"http://"])||([scanCode hasPrefix:@"https://"])) {
            WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
            WebDirectLocalModel *modelLocal = [[WebDirectLocalModel alloc] init];
            modelLocal.url = scanCode;
            modelLocal.typeLocalWeb = WebLocalTypeOuterLink;
            //此外链不要分享
            modelLocal.typeTitle = WebTitleTypeNone;
            [vcWebDirect setWVWithLocalModel:modelLocal];
            vcWebDirect.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vcWebDirect animated:YES];
            return;
        }
        
        if([type isEqualToString:@"AVMetadataObjectTypeQRCode"] ||[type isEqualToString:@"org.iso.QRCode"] )
        {
            if(self.useType == 3) {
                //曾经的扫码订单
                //[self everNormalScan:scanCode];
            }else{
                //扫描优惠券
                [self scanPromotion:scanCode];
            }
        }else
        {
            // 正常的扫商品
            [self normalScan:scanCode];
        }
    }else if(self.scanType==Enum_Scan_Items_Common){
        [self commonNormalScan:scanCode];
    }else if(self.scanType==Enum_Scan_Items_QuickOrder){
        [self quickOrder:scanCode];
    }else if (self.scanType==Enum_Scan_Items_InterProduct){
        [self scanInternalProduct:scanCode];
    }else if (self.scanType==Enum_Scan_Items_AddInternalProduct){
        [self scanAddInternalProduct:scanCode];
    }
    else if (self.scanType==Enum_Scan_Items_ProductSales)
    {
        [self quickOrder:scanCode];
    }
}

/**
 *  扫描本店商品
 *
 *  @return
 */
- (void)scanInternalProduct:(NSString *)code
{
    InternalProductSearchModelR *modelR = [InternalProductSearchModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.barcode = code;
    [HttpClient sharedInstance].progressEnabled = YES;
    [InternalProduct queryInternalProductSearch:modelR success:^(InternalProductListModel *responseModel) {
        [self.navigationController popViewControllerAnimated:NO];
        if (self.scanProResult != nil) {
            self.scanProResult([responseModel.list mutableCopy]);
        }
    } failure:^(HttpException *e) {
        [self showError:e.description];
    }];

}

/**
 *  扫描添加本店商品
 *
 *  @return
 */
- (void)scanAddInternalProduct:(NSString *)code
{
    [self.navigationController popViewControllerAnimated:NO];
    if (self.scan != nil) {
        self.scan(code);
    }
}
#pragma mark ---- 首页扫码药品 获取药品信息 ----

- (void)normalScan:(NSString *)barCode
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"barCode"] = barCode;

    [Promotion queryProductByBarCodeWithParam:param Success:^(id resultObj){
        
        ProductListModel *responseModel = resultObj;
        if([responseModel.apiStatus intValue] == 0){
            ProductModel *model = responseModel.list[0];
            ScanDrugViewController *scan = [[ScanDrugViewController alloc]initWithNibName:@"ScanDrugViewController" bundle:nil];
            scan.product = model;
            [self.navigationController pushViewController:scan animated:YES];

        }else{
            [SVProgressHUD showErrorWithStatus:responseModel.apiMessage duration:2.0];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(reStartScan) userInfo:nil repeats:NO];
        }
    }failure:^(HttpException *e){
        [SVProgressHUD showErrorWithStatus:e.Edescription duration:2.0];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(reStartScan) userInfo:nil repeats:NO];
    }];
}

-(void)scanPromotion:(NSString *)code{
    
    InputVerifyModelR *modelR = [InputVerifyModelR new];
    modelR.code = code;
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    
    [Verify GetVerifyWithParams:modelR success:^(id UFModel) {
        
        InputVerifyModel *resonModel = (InputVerifyModel *)UFModel;
        
        if([resonModel.apiStatus intValue] == 0){
            
            if ([resonModel.scope intValue]==4) {//订单收货码的确认
                IndentDetailListViewController *vc = [IndentDetailListViewController new];
                vc.modelShop=resonModel.shopOrderDetailVO;
                vc.isComeFromScan = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                VerifyDetailViewController *vc = [[VerifyDetailViewController alloc] initWithNibName:@"VerifyDetailViewController" bundle:nil];
                if([resonModel.scope intValue]==1){
                    vc.typeCell=@"1";
                    vc.CoupnList=resonModel.coupon;
                }else{
                    vc.typeCell=@"2";
                    vc.drugList=resonModel.promotion;
                }
                vc.scope = resonModel.coupon.scope;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            
            
        }else{
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"" message:resonModel.apiMessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alertView.tag=8;
            [alertView show];
            //点击确定后重新启动扫码
        }
        
    } failure:^(HttpException *e) {
        if(e.Edescription && ![e.Edescription isEqualToString:@""]){
            [SVProgressHUD showErrorWithStatus:e.Edescription duration:2.0];
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(reStartScan) userInfo:nil repeats:NO];
    }];
    
    
}


//#define Kwarning220N64  @"扫码成功，已添加至所购商品列表"
//#define Kwarning220N65  @"未搜索到此商品"
- (void)commonNormalScan:(NSString *)barCode
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"barCode"] = barCode;
    param[@"v"]=@"2.0";
    //扫码获取商品信息
    [Promotion queryProductByBarCodeWithParam:param Success:^(id resultObj){
        
        ProductListModel *responseModel = resultObj;
        if([responseModel.apiStatus intValue] == 0){
            ProductModel *model = responseModel.list[0];
            if(self.addCommonMedicineBlock){
                self.addCommonMedicineBlock(model);
                [SVProgressHUD showSuccessWithStatus:Kwarning220N64 duration:2.0];
                [self performSelector:@selector(alertactionCommon) withObject:nil afterDelay:0.3];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:responseModel.apiMessage duration:2.0];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(reStartScan) userInfo:nil repeats:NO];
        }
    }failure:^(HttpException *e){
        [SVProgressHUD showErrorWithStatus:e.Edescription duration:2.0];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(reStartScan) userInfo:nil repeats:NO];
    }];
}


//#define Kwarning220N64  @"扫码成功，已添加至所购商品列表"
//#define Kwarning220N65  @"未搜索到此商品"
//#define Kwarning220N67  @"该商品不适用于此优惠劵"
- (void)slowNormalScan:(NSString *)barCode
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"barCode"] = barCode;
    param[@"v"]=@"2.0";
    //扫码获取商品信息
    [Promotion queryProductByBarCodeWithParam:param Success:^(id resultObj){
        
        ProductListModel *responseModel = resultObj;
        if([responseModel.apiStatus intValue] == 0){
            ProductModel *model = responseModel.list[0];
            if(self.addSlowHasBlock)
            {
                int i=self.addSlowHasBlock(model);
                if(i==1){
                    [SVProgressHUD showErrorWithStatus:Kwarning220N67 duration:2.0];
                }else{
                    [SVProgressHUD showSuccessWithStatus:Kwarning220N64 duration:2.0];
                }
                [self performSelector:@selector(alertactionSlow) withObject:nil afterDelay:0.3];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:responseModel.apiMessage duration:2.0];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(reStartScan) userInfo:nil repeats:NO];
        }
    }failure:^(HttpException *e){
        [SVProgressHUD showErrorWithStatus:e.Edescription duration:2.0];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(reStartScan) userInfo:nil repeats:NO];
    }];

}


-(void)quickOrder:(NSString *)barCode{
    if (self.scan) {
        self.scan(barCode);
        [self popVCAction:nil];
    }
}


//- (void)everNormalScan:(NSString *)barCode{
//    PromotionScanR *modelR = [PromotionScanR new];
//    modelR.code = barCode;
//    modelR.token = QWGLOBALMANAGER.configure.userToken;
//    [Promotion promotionScanWithParams:modelR success:^(id UFModel) {
//        PromotionScanModel *resonModel = (PromotionScanModel *)UFModel;
//        if([resonModel.apiStatus intValue] == 0){
//            
//            OrderclassBranch *branch = [OrderclassBranch new];
//            branch.id       = resonModel.id;
//            branch.banner   = resonModel.url;
//            branch.title    = resonModel.title;
//            branch.type     = resonModel.type;
//            branch.desc     = resonModel.desc;
//            branch.proName  = resonModel.proName;
//            NSString *nik=resonModel.nick;
//            if(nik&&nik.length>=11)
//            {
//                nik=[resonModel.nick stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
//            }
//            branch.nick     = nik;
//            branch.discount = resonModel.discount;
//            branch.useTimes = resonModel.useTimes;
//            branch.date     = resonModel.orderCreateTime;
//            branch.code     = barCode;
//            branch.proId    = resonModel.proId;
//            branch.inviterName = resonModel.inviterName;
//            branch.totalLargess = resonModel.totalLargess;
//            branch.price    = resonModel.price;
//            branch.quantity = resonModel.quantity;
//            branch.passportId=resonModel.passportId;
//            branch.inviter  = resonModel.inviter;
//
//            InfomationOrderViewController *informationOrderViewController = [[InfomationOrderViewController alloc] initWithNibName:@"InfomationOrderViewController" bundle:nil];
//            informationOrderViewController.modeType = 2;
//            informationOrderViewController.orderBranchclass = branch;
//            [self.navigationController pushViewController:informationOrderViewController animated:YES];
//            }else{
//            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"" message:resonModel.apiMessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            alertView.tag=9;
//            [alertView show];
//        }
//
//                
//        } failure:^(HttpException *e) {
//            if(e.Edescription && ![e.Edescription isEqualToString:@""]){
//                [SVProgressHUD showErrorWithStatus:e.Edescription duration:2.0];
//            }
//            self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(reStartScan) userInfo:nil repeats:NO];
//        }];
//}

-(void)alertactionCommon{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"此商品扫码成功" delegate:self cancelButtonTitle:@"完成" otherButtonTitles:@"继续扫码", nil];
    alertView.tag=10;
    [alertView show];
}

-(void)alertactionSlow{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"此商品扫码成功" delegate:self cancelButtonTitle:@"完成" otherButtonTitles:@"继续扫码", nil];
    alertView.tag=11;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==8){//曾经的
        if(buttonIndex==0){
           [self reStartScan];
        }
    }else if(alertView.tag==9){//曾经普通的
        if(buttonIndex==0){
           [self reStartScan];
        }
    }else if(alertView.tag==10){//普通的
        if(buttonIndex==0){
            [self.navigationController popViewControllerAnimated:YES];
        }else if(buttonIndex==1){
            [self reStartScan];
        }
    }else if(alertView.tag==11){//慢病的
        if(buttonIndex==0){
            [self.navigationController popViewControllerAnimated:YES];
        }else if(buttonIndex==1){
            [self reStartScan];
        }
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end