//
//  BranchdetailCViewController.m
//  wenYao-store
//
//  Created by caojing on 15/8/26.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BranchdetailPViewController.h"
#import "SuitProductTableViewCell.h"
#import "CommonTableViewCell.h"
#import "WebDirectViewController.h"

@interface BranchdetailPViewController ()

@property (nonatomic ,strong) NSMutableArray *dataSource;

@end

@implementation BranchdetailPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"适用商品";
    
    self.dataSource=[NSMutableArray array];
    
    self.coupnDetail.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    //  请求商品数据
    [self querySuitProduct];
}

#pragma mark ---- 请求适用商品数据 ----

-(void)querySuitProduct
{
    if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
        [self showInfoView:kWaring12 image:@"img_network"];
        return;
    }

    CoupnSuitModelR * modelR=[CoupnSuitModelR new];
    modelR.couponId=self.coupnId;

    [Coupn GetAllSuitableParams:modelR success:^(id responseObj) {
        
        CouponProductArrayVo *model = [CouponProductArrayVo parse:responseObj Elements:[CouponProductVo class] forAttribute:@"suitableProducts"];
        
        if(model.suitableProducts.count>0){
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:model.suitableProducts];
            [self.coupnDetail reloadData];
        }else{
            [self showInfoView:@"暂无优惠券" image:@"ic_img_fail"];
        }
        [self.coupnDetail.footer endRefreshing];
        
    } failure:^(HttpException *e) {
        [self.coupnDetail.footer endRefreshing];
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

#pragma mark ---- 列表代理 ----

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SuitProductTableViewCell getCellHeight:nil];
}

- (NSInteger)tableView:(UITableView *)atableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)atableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SecondProductCell = @"SuitProductCell";
    SuitProductTableViewCell *cell = (SuitProductTableViewCell *)[atableView dequeueReusableCellWithIdentifier:SecondProductCell];
    if(cell == nil){
        UINib *nib = [UINib nibWithNibName:@"SuitProductTableViewCell" bundle:nil];
        [atableView registerNib:nib forCellReuseIdentifier:SecondProductCell];
        cell = (SuitProductTableViewCell *)[atableView dequeueReusableCellWithIdentifier:SecondProductCell];
    }
    
    CouponProductVo *model=self.dataSource[indexPath.row];
    [cell setCell:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:0.8f];
        return;
    }
    CouponProductVo *model=self.dataSource[indexPath.row];
  
    // 药品详情

    WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
    WebDrugDetailModel *modelDrug = [[WebDrugDetailModel alloc] init];
    modelDrug.proDrugID = model.productId;
    modelDrug.promotionID = @"";
    
    WebDirectLocalModel *modelLocal = [[WebDirectLocalModel alloc] init];
    modelLocal.modelDrug = modelDrug;
    modelLocal.typeLocalWeb = WebLocalTypeCouponProduct;
    modelLocal.title = @"药品详情";
    [vcWebDirect setWVWithLocalModel:modelLocal];
    
    vcWebDirect.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcWebDirect animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
