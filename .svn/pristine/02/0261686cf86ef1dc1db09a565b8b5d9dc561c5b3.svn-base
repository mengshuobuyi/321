//
//  CouponDeatilViewController.m
//  wenyao
//
//  Created by 李坚 on 15/1/19.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import "CouponDeatilViewController.h"
#import "MedicineListCell.h"
#import "UIImageView+WebCache.h"
#import "LoginViewController.h"
#import "DrugDetailViewController.h"
#import "WebDirectViewController.h"
#import "Consult.h"

@interface CouponDeatilViewController ()
{
    NSDictionary *dic;
    UIImageView * buttonImage;
    NSInteger totalFrameSize;
    UIImageView *deleted;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeight;


@property (strong, nonatomic) NSString *collectButtonImageName;
@property (strong, nonatomic) NSString *collectButtonName;


@property (weak, nonatomic) IBOutlet UIButton *collectButton;


@end

@implementation CouponDeatilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.drugList = [NSMutableArray array];
    [self.tableView setFrame:CGRectMake(0, 0, APP_W-NAV_H, 1000)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.pushBtn.layer.masksToBounds = YES;
    self.pushBtn.layer.cornerRadius = 4;
    self.title = @"优惠详情";
    [self loadData];
}

-(void)loadData{
    
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"promotion"] = self.commonPromotionId;
        [Consult queryCoupnDetailWithParam:setting success:^(id UFModel) {
            
            CouponDetailModel *couponDetailModel = (CouponDetailModel *)UFModel;
    
            if([couponDetailModel.apiStatus intValue] == 0){
                [self.drugList addObjectsFromArray:couponDetailModel.products];
                self.coupnDetail=couponDetailModel;
                [self stInfomation];
                
            }
        }failure:^(HttpException *e) {
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



- (void)stInfomation{
    
    self.detailButton.layer.masksToBounds = YES;
    self.detailButton.layer.cornerRadius = 2.0f;
    self.detailButton.layer.borderWidth = 1.0f;
    self.detailButton.layer.borderColor = RGBHex(qwColor1).CGColor;
    [self.detailButton setTitleColor:RGBHex(qwColor1) forState:UIControlStateNormal];
    self.pushBtn.layer.masksToBounds = YES;
    self.pushBtn.layer.cornerRadius = 2.0f;
    
    self.descriptionLabel.text = self.coupnDetail.desc;
    CGSize descSize = [GLOBALMANAGER sizeText:self.coupnDetail.desc font:fontSystem(kFontS4) limitWidth:APP_W-100];
    
    
    CGSize totalSize;
    totalSize.height = 160.0f;
    totalSize.height = totalSize.height + descSize.height;
    if([self.coupnDetail.limitTotal intValue] == 0){
        
        totalSize.height -= 40;
        [self.tickets removeFromSuperview];
        [self.leftChanges removeFromSuperview];
        [self.line101 removeFromSuperview];
    }
    if([self.coupnDetail.limitPersonTimes intValue] == 0){
        
        totalSize.height -= 40;
        [self.couponTimes removeFromSuperview];
        [self.couponTimesLabel removeFromSuperview];
        [self.line102 removeFromSuperview];
    }
    else{
        self.couponTimesLabel.text = [NSString stringWithFormat:@"每人享受%@次优惠",self.coupnDetail.limitPersonTimes];
    }
    self.startTime.text = self.coupnDetail.validBegin;
    self.endTime.text = self.coupnDetail.validEnd;
    
    switch([self.coupnDetail.type intValue]){
        case 1://type = 1代表折扣券
            break;
        case 2://type = 2代表代金券
            break;
        case 3://type = 3代表买赠券
            break;
    }
    self.tickets.text = [NSString stringWithFormat:@"%d次（共%d次）",[self.coupnDetail.limitTotal intValue] - [self.coupnDetail.statTotal intValue],[self.coupnDetail.limitTotal intValue]];
    
    
    self.consulteLabel.text = [NSString stringWithFormat:@"%@家",self.coupnDetail.statBranch];
    
    [self.tableView setBackgroundColor:RGBHex(qwColor11)];
    
    if(self.coupnDetail.title){
        
        self.titleLabel.text = self.coupnDetail.title;
        
        CGSize size = [QWGLOBALMANAGER getTextSizeWithContent:self.coupnDetail.title WithUIFont:fontSystem(kFontS2) WithWidth:APP_W - 20];
        
        self.headerView.frame = CGRectMake(0, 0, APP_W, size.height + 22);
        
        self.tableView.tableHeaderView = self.headerView;
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
    totalFrameSize=totalSize.height;
    [self.tableView reloadData];
        if (deleted) {
            [deleted removeFromSuperview];
            deleted = nil;
        }
        deleted=[[UIImageView alloc]initWithFrame:CGRectMake(APP_W-120, 100, 100, 100)];
        if(self.coupnDetail.pushStatus &&([self.coupnDetail.pushStatus intValue] == 2)){
            [deleted setImage:[UIImage imageNamed:@"bg-activity delete.PNG"]];
            [self.view addSubview:deleted];
        }else{
            if(self.coupnDetail.status  &&([self.coupnDetail.status intValue] == 3)){
                [deleted setImage:[UIImage imageNamed:@"bg-activity expired.PNG"]];
                [self.view addSubview:deleted];
            }
        }
    
    self.footerView.hidden=NO;
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }else if (section == 1)
    {
        return 10;
    }else
    {
        return 0.1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectZero;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0){//商品
        return 0.1;
    }else { //优惠活动详情
        return totalFrameSize;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    UIView * coupnView = [[UIView alloc]init];
    
    
    if(section==1){
        self.footerView.frame = CGRectMake(0, 0, SCREEN_W, totalFrameSize);
        coupnView = self.footerView;
        return coupnView;
    }
    return coupnView;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        if(self.drugList.count > 0){
            return 1;
        }
        else{
            return 0;
        }
    }else {
        return 0;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        return [MedicineListCell getCellHeight:nil];
    }else{
        return 133;//85.0f;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==0){
        NSString * cellIdentifier = @"cellIdentifier";
        MedicineListCell * cell = (MedicineListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"MedicineListCell" owner:self options:nil][0];
            cell.separatorHidden=YES;
            [cell setBackgroundColor:[UIColor whiteColor]];
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, [MedicineListCell getCellHeight:nil] - 0.5, APP_W, 0.5)];
            line.backgroundColor = RGBHex(qwColor10);
            [cell addSubview:line];
        }
        
                ProductsModel *products = (ProductsModel *)self.drugList[indexPath.row];
       
        cell.proName.text = products.name;
        cell.spec.text = products.spec;
        cell.factory.text = products.factory;
        
//        [cell.headImageView setImageWithURL:[NSURL URLWithString:PORID_IMAGE(products.proId)] placeholderImage:[UIImage imageNamed:@"药品默认图片.png"]];
        [cell.headImageView setImageWithURL:[NSURL URLWithString:products.imgUrl] placeholderImage:[UIImage imageNamed:@"药品默认图片.png"]];
        return cell;
    }else
    {
        return nil;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        NSIndexPath *selection = [tableView indexPathForSelectedRow];
        if (selection) {
            [self.tableView deselectRowAtIndexPath:selection animated:YES];
        }
    ProductsModel *products = (ProductsModel *)self.drugList[indexPath.row];
    
    WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
    WebDrugDetailModel *modelDrug = [[WebDrugDetailModel alloc] init];
    modelDrug.proDrugID = products.proId;
    modelDrug.promotionID = @"";
    
    WebDirectLocalModel *modelLocal = [[WebDirectLocalModel alloc] init];
    modelLocal.modelDrug = modelDrug;
    modelLocal.typeLocalWeb = WebLocalTypeCouponProduct;
    modelLocal.title = @"药品详情";
    [vcWebDirect setWVWithLocalModel:modelLocal];
    
    vcWebDirect.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcWebDirect animated:YES];
    
//    DrugDetailViewController *drugDetailViewController = [[DrugDetailViewController alloc] init];
//    ProductsModel *products = (ProductsModel *)self.drugList[indexPath.row];
//    drugDetailViewController.proId = products.proId;
//    [self.navigationController pushViewController:drugDetailViewController animated:YES];
}



@end
