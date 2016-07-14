//
//  ScanDrugViewController.m
//  wenYao-store
//
//  Created by 李坚 on 15/3/26.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "ScanDrugViewController.h"
#import "ScanDrugTableViewCell.h"
#import "DrugDetailViewController.h"
#import "WebDirectViewController.h"


@interface ScanDrugViewController ()

@end

@implementation ScanDrugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"列表";
    
    self.drugTableView.dataSource = self;
    self.drugTableView.delegate = self;
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    self.drugTableView.tableFooterView = view;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 85.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ScanDrugIdentifier = @"ScanDrugCellIdentifier";
    ScanDrugTableViewCell *cell = (ScanDrugTableViewCell *)[self.drugTableView dequeueReusableCellWithIdentifier:ScanDrugIdentifier];
    if(cell == nil){
        UINib *nib = [UINib nibWithNibName:@"ScanDrugTableViewCell" bundle:nil];
        [self.drugTableView registerNib:nib forCellReuseIdentifier:ScanDrugIdentifier];
        cell = (ScanDrugTableViewCell *)[self.drugTableView dequeueReusableCellWithIdentifier:ScanDrugIdentifier];
    }
    
    [cell setCell:self.product];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //跳转药品详情
    WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
    WebDrugDetailModel *modelDrug = [[WebDrugDetailModel alloc] init];
    modelDrug.proDrugID = self.product.proId;
    modelDrug.promotionID = @"";
    
    WebDirectLocalModel *modelLocal = [[WebDirectLocalModel alloc] init];
    modelLocal.modelDrug = modelDrug;
    modelLocal.typeLocalWeb = WebLocalTypeCouponProduct;
    modelLocal.title = @"药品详情";
    [vcWebDirect setWVWithLocalModel:modelLocal];
    
    vcWebDirect.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcWebDirect animated:YES];
    
    
//    DrugDetailViewController *detail = [[DrugDetailViewController alloc]init];
//    detail.proId = self.product.proId;
//    [self.navigationController pushViewController:detail animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
