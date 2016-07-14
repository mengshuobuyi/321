//
//  VerifyDetailViewController.m
//  wenYao-store
//
//  Created by caojing on 15/8/18.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "VerifyDetailViewController.h"
#import "FirstCoupnTableViewCell.h"
#import "SecondProductTableViewCell.h"
#import "CommonTableViewCell.h"
#import "CoupnProductViewController.h"
#import "IndexViewController.h"
#import "SlowCoupnProductViewController.h"
#import "WebDirectViewController.h"
#import "ThreeCoupnTableViewCell.h"
#import "TipDetailViewController.h"

@interface VerifyDetailViewController ()
{
    BOOL isFlag;
}
@end

@implementation VerifyDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"优惠详情";
    
    // 设置 tableView的header
    self.coupbView.tableHeaderView = self.topView;

    // 设置 UI
    [self setUpUI];
    
    self.Endarray = [NSMutableArray array];
    
    isFlag = NO;
}

- (void)setUpUI
{
    self.confirmButton.layer.masksToBounds = YES;
    self.confirmButton.layer.cornerRadius = 3.0f;
    self.cancleButton.layer.masksToBounds = YES;
    self.cancleButton.layer.cornerRadius = 3.0f;
    self.cancleButton.backgroundColor = [UIColor clearColor];
    self.cancleButton.layer.borderWidth = 1.0f;
    self.cancleButton.layer.borderColor = RGBHex(qwColor15).CGColor;
    [self.cancleButton setTitleColor:RGBHex(qwColor15) forState:UIControlStateNormal];
    self.coupbView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if([self.typeCell isEqualToString:@"1"]){ // 券  1.通用2.慢病3.全部4.礼品券5.商品券
        
        if (self.CoupnList.suitableProductCounts>0)
        {
            // 慢病 商品券 需要所购商品
            if(self.array.count > 0 && [self.total intValue] >= self.CoupnList.limitConsume){
                [self putButtonEnabled];
                isFlag = YES;
            }else{
                [self putButtonDisabled];
                isFlag = NO;
            }
        }else
        {
            // 其他券 直接确认
            [self putButtonEnabled];
            isFlag = YES;
        }
        
    }else{//商品
        [self putButtonEnabled];
        isFlag = YES;
    }
    [self.coupbView reloadData];
}

#pragma mark ---- 确认按钮黄色 可以点击 ----

- (void)putButtonEnabled
{
    self.confirmButton.backgroundColor = RGBHex(qwColor15);
    [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"btn_complete_end_click"] forState:UIControlStateHighlighted];
}

#pragma mark ---- 确认按钮置灰 不可点击 ----

- (void)putButtonDisabled
{
    self.confirmButton.backgroundColor = RGBHex(qwColor9);
    [self.confirmButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
}

#pragma mark ---- 列表代理

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
         if([self.typeCell isEqualToString:@"1"]){ // 优惠券
             return [FirstCoupnTableViewCell getCellHeight:nil];
         }else{ // 优惠商品
             return [SecondProductTableViewCell getCellHeight:nil];
         }
    }else{
        return [CommonTableViewCell getCellHeight:nil];
    }
}

- (NSInteger)tableView:(UITableView *)atableView numberOfRowsInSection:(NSInteger)section
{
    if([self.typeCell isEqualToString:@"1"]){ //优惠券
        if(self.CoupnList.suitableProductCounts == 0) {
            return 2;
        }
        else
            return 3;
    }else{// 优惠商品
        return 2;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)atableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        // 普通券
        static NSString *identifier = @"FirstCoupnCell";
        FirstCoupnTableViewCell *Cell = [atableView dequeueReusableCellWithIdentifier:identifier];
        
        // 优惠商品
        static NSString *Secondidentifier = @"SecondProductCell";
        SecondProductTableViewCell *SecondCell = [atableView dequeueReusableCellWithIdentifier:Secondidentifier];
        
        // 礼品券
        static NSString *ThreeCoupnCell = @"ThreeCoupnCell";
        ThreeCoupnTableViewCell *Threecell = [atableView dequeueReusableCellWithIdentifier:ThreeCoupnCell];
        
        if (Cell == nil) {
            Cell = [[NSBundle mainBundle]loadNibNamed:@"FirstCoupnTableViewCell" owner:self options:nil][0];
        }
        if (SecondCell == nil) {
            SecondCell = [[NSBundle mainBundle]loadNibNamed:@"SecondProductTableViewCell" owner:self options:nil][0];
        }
        if(Threecell == nil){
            Threecell = [[NSBundle mainBundle]loadNibNamed:@"ThreeCoupnTableViewCell" owner:self options:nil][0];
        }
        
        if([self.typeCell isEqualToString:@"1"])
        {
            // 优惠券
            if(!StrIsEmpty(self.CoupnList.giftImgUrl)){// 礼品券 优惠商品券
                [Threecell setCoupnCell:self.CoupnList];
                Threecell.couponRemark.text = self.CoupnList.couponRemark;
                return Threecell;
            }else{// 其他券
                [Cell setCoupnCell:self.CoupnList];
                Cell.couponRemark.text = self.CoupnList.couponRemark;
                return Cell;
            }
        }else{
            // 优惠商品
            [SecondCell setVerifyProductCell:self.drugList];
            return SecondCell;
        }
    }else
    {
        static NSString *commonTableCell = @"commonTableCell";
        CommonTableViewCell *cell = (CommonTableViewCell *)[atableView dequeueReusableCellWithIdentifier:commonTableCell];
        if(cell == nil){
            UINib *nib = [UINib nibWithNibName:@"CommonTableViewCell" bundle:nil];
            [atableView registerNib:nib forCellReuseIdentifier:commonTableCell];
            cell = (CommonTableViewCell *)[atableView dequeueReusableCellWithIdentifier:commonTableCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if(indexPath.row == 1){
          cell.titleLable.text = @"优惠细则";
        }else{
            BranchCouponVo *branchclass = (BranchCouponVo *)self.CoupnList;
            if(branchclass.suitableProductCounts>0){ // 慢病券 商品券 优惠商品券
                if(self.array.count > 0 && [self.total intValue] >= self.CoupnList.limitConsume){
                 cell.titleLable.text = @"所购商品";
                 cell.tipLable.text = @"";
                }else{
                 cell.titleLable.text = @"所购商品";
                 cell.tipLable.text = @"请选择顾客购买的商品";
                }
            }else{ // 礼品券 普通券
                if(self.array.count > 0 && [self.total intValue] >= self.CoupnList.limitConsume){
                    cell.titleLable.text = @"所购商品";
                    cell.tipLable.text = @"";
                }else{
                     cell.titleLable.text = @"所购商品";
                     cell.tipLable.text = @"请添加顾客所购买的商品";
                }
            }
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.coupbView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:0.8f];
        return;
    }
    if(indexPath.row == 0){
    
    }else if(indexPath.row == 1)
    {
         if([self.typeCell isEqualToString:@"1"])
         {
             //优惠券
             WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
             WebCouponConditionModel *modelCondition = [[WebCouponConditionModel alloc] init];
             modelCondition.couponId = self.CoupnList.couponId;
             modelCondition.type = @"1";
             WebDirectLocalModel *modelLocal = [[WebDirectLocalModel alloc] init];
             modelLocal.modelCondition = modelCondition;
             modelLocal.typeLocalWeb = WebLocalTypeCouponCondition;
             [vcWebDirect setWVWithLocalModel:modelLocal];
             vcWebDirect.hidesBottomBarWhenPushed = YES;
             [self.navigationController pushViewController:vcWebDirect animated:YES];
         }else
         {
             WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
             WebCouponConditionModel *modelCondition = [[WebCouponConditionModel alloc] init];
             modelCondition.couponId = self.drugList.pid;
             modelCondition.type = @"2";
             WebDirectLocalModel *modelLocal = [[WebDirectLocalModel alloc] init];
             modelLocal.modelCondition = modelCondition;
             modelLocal.typeLocalWeb = WebLocalTypeCouponCondition;
             [vcWebDirect setWVWithLocalModel:modelLocal];
             vcWebDirect.hidesBottomBarWhenPushed = YES;
             [self.navigationController pushViewController:vcWebDirect animated:YES];
         
         }
    }else if(indexPath.row==2){
        
        if([self.typeCell isEqualToString:@"1"]){//优惠券
            BranchCouponVo *branchclass=(BranchCouponVo *)self.CoupnList;
            if(branchclass.suitableProductCounts>0){
                SlowCoupnProductViewController *vc=[[SlowCoupnProductViewController alloc] initWithNibName:@"SlowCoupnProductViewController" bundle:nil];
                vc.SlowCheckProduct = ^(NSMutableArray *productArray,NSString *total){
                    self.array=productArray;
                    self.total=total;
                };
                vc.addDateSource=self.array;
                vc.totalSum=self.total;
                vc.coupnId=branchclass.couponId;
                vc.CoupnList=self.CoupnList;
//                vc.drugList=self.drugList;
//                vc.typeCell=self.typeCell;
                
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                CoupnProductViewController *vc=[[CoupnProductViewController alloc] initWithNibName:@"CoupnProductViewController" bundle:nil];
                vc.CheckProduct = ^(NSMutableArray *productArray,NSString *total){
                    self.array=productArray;
                    self.total=total;
                };
                vc.addDateSource=self.array;
                vc.totalSum=self.total;
                vc.CoupnList=self.CoupnList;
//                vc.hidesBottomBarWhenPushed=YES;
//                vc.CoupnList=self.CoupnList;
//                vc.drugList=self.drugList;
//                vc.typeCell=self.typeCell;
//                vc.addDateSource=self.array;
//                vc.totalSum=self.total;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

- (IBAction)cancleAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)confirmAction:(id)sender {
    if(isFlag || self.CoupnList.suitableProductCounts == 0){
        [self confirmMyorder];
    }
}

- (void)popVCAction:(id)sender
{
//    __block UIViewController *popViewController = nil;
//    __block NSArray *viewControllers = self.navigationController.viewControllers;
//    [viewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
//        if([vc isKindOfClass:[VerifyDetailViewController class]]) {
//            *stop = YES;
//            popViewController = viewControllers[idx - 1];
//        }
//    }];
//    if(popViewController) {
//        [self.navigationController popToViewController:popViewController animated:YES];
//    }else{
//        [super popVCAction:sender];
//    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//订单确认
-(void)confirmMyorder{
    if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
        [self showInfoView:kWaring12 image:@"img_network"];
        return;
    }
    
    if([self.typeCell isEqualToString:@"1"]){//优惠券
        ConVerifyModelR *branchR=[ConVerifyModelR new];
        branchR.token=QWGLOBALMANAGER.configure.userToken;
        branchR.deviceCode=[QWGLOBALMANAGER deviceToken];
        branchR.amount=self.total;
        branchR.orderId=self.CoupnList.orderId;
        if(self.array.count>0 || self.CoupnList.suitableProductCounts == 0){
            [self.Endarray removeAllObjects];
            for (int i=0; i<self.array.count; i++) {
                JsonVo *mode=[self changeModel:self.array[i]];
                NSDictionary *dic=[mode dictionaryModel];
                [self.Endarray addObject:dic];
            }
            if(self.Endarray.count > 0) {
                NSDictionary *diction=[NSDictionary dictionaryWithObject:self.Endarray forKey:@"couponConsumedProducts"];
            
                branchR.couponConsumedProductInfo=[self toJSONStr:diction];
            }
        }else{
            if([self.CoupnList.scope intValue]==2){
                [SVProgressHUD showErrorWithStatus:@"请添加你要购买的慢病商品" duration:0.6];
                return;
            }else{
                [SVProgressHUD showErrorWithStatus:@"请添加顾客所购买的商品" duration:0.6];
                return;
            }
        }
        
        [Verify PostVerifyWithParams:branchR success:^(id responseObj) {
            
            VerifyModel *model = (VerifyModel*) responseObj;
            
            if([model.apiStatus intValue]==0){
                [SVProgressHUD showSuccessWithStatus:@"该优惠消费成功" duration:0.8];
                [self performSelector:@selector(alertaction:) withObject:@2 afterDelay:0.2];
            }else{
                [SVProgressHUD showErrorWithStatus:model.apiMessage duration:0.6];
            }
            
        } failure:^(HttpException *e) {
        }];
    }else{
        ProductVerifyModelR *branchR=[ProductVerifyModelR new];
        branchR.token=QWGLOBALMANAGER.configure.userToken;
        branchR.orderId=self.drugList.orderId;
        [Verify PostVerifyProductWithParams:branchR success:^(id responseObj) {
              VerifyModel *model = (VerifyModel*) responseObj;
            if([model.apiStatus intValue]==0){
             [SVProgressHUD showSuccessWithStatus:@"该优惠消费成功" duration:0.8];
                [self performSelector:@selector(alertaction:) withObject:@1 afterDelay:0.2];
            }else{
                [SVProgressHUD showErrorWithStatus:model.apiMessage duration:0.6];
            }
            
        } failure:^(HttpException *e) {
            if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
                [self showInfoView:kWaring12 image:@"img_network"];
            }else
            {
                if(e.errorCode!=-999){
                    if(e.errorCode == -1001){
                        [self showInfoView:kWarning215N54 image:@"ic_img_fail"];
                    }else{
                        [self showInfoView:kWarning215N0 image:@"ic_img_fail"];
                    }
                }
            }
        }];
    }

    
 
    
}
//跳转到订单的详情页面
-(void)alertaction:(NSNumber *)typeCell{
    
    //返回到首页
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
//    TipDetailViewController *vc = [[UIStoryboard storyboardWithName:@"TipStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"TipDetailViewControllerId"];
//    vc.hidesBottomBarWhenPushed = YES;
//    if([typeCell intValue]==2){
//    vc.orderId=self.CoupnList.orderId;
//    }else{
//    vc.orderId=self.drugList.orderId;
//    }
//    
//    vc.type=typeCell;//2是优惠券
//    vc.scope = self.scope;
//    [self.navigationController pushViewController:vc animated:YES];
    
}

- (NSString *)toJSONStr:(id)theData{
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];;
        
    }else{
        return nil;
    }
}


-(JsonVo *)changeModel:(CouponProductVo*)model{
    JsonVo *mod=[JsonVo new];
    mod.id=model.productId;
    mod.name=model.productName;
    mod.spec=model.spec;
    mod.factory=model.factory;
    mod.quantity=model.quantity;
    mod.imgUrl=model.productLogo;
    return mod;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
