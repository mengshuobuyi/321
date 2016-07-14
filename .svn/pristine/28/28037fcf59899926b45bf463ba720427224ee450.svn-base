//
//  DoingDetailViewController.m
//  wenYao-store
//
//  Created by caojing on 15/8/22.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "DoingDetailViewController.h"
#import "Activity.h"
#import "ConsultCouponTableViewCell.h"
#import "SecondProductTableViewCell.h"
#import "BranchdetailCViewController.h"
#import "WebDirectViewController.h"

@interface DoingDetailViewController ()<UITableViewDataSource,UITableViewDelegate,ConsultCouponTableViewCellDelegate>{

    NSMutableArray *coupnList;
    NSMutableArray *productList;
    NSInteger currentPage;
}
@property (strong,nonatomic)UITableView *tableView;
@end

@implementation DoingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, APP_W, APP_H-NAV_H) style:UITableViewStyleGrouped];
    currentPage=1;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor=RGBHex(qwColor11);
    [self setupRefresh];
    [self.view addSubview:self.tableView];
    
    self.title=self.titlela;
    
    coupnList=[NSMutableArray array];
    productList=[NSMutableArray array];
    
   
}


- (void)btnShareClicked
{
    
    ShareContentModel *modelShare = [[ShareContentModel alloc] init];
    modelShare.shareID =self.packPromotionId;
    modelShare.title = self.titlela;
    modelShare.content = self.descla;
//    modelShare.imgURL = self.imagela;
    modelShare.imgURL =QWGLOBALMANAGER.configure.avatarUrl;
    modelShare.typeShare = ShareTypeCoupon;
    
    ShareSaveLogModel *modelR = [ShareSaveLogModel new];
    [QWGLOBALMANAGER readLocationInformation:^(MapInfoModel *mapInfoModel) {
        if(mapInfoModel) {
            modelR.city = mapInfoModel.city;
            modelR.province = mapInfoModel.province;
        }else{
            modelR.city = @"苏州市";
            modelR.province = @"";
        }
    }];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.shareObj = @"3";
    modelR.shareObjId = self.packPromotionId;
    modelShare.modelSavelog = modelR;
    [self popUpShareView:modelShare];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem.enabled=YES;
    [self detail];
    [self products];
   
}

-(void)setupRefresh{
    [self.tableView addFooterWithTarget:self action:@selector(footreshing)];
    self.tableView.footerPullToRefreshText = kWaring6;
    self.tableView.footerReleaseToRefreshText =kWaring7;
    self.tableView.footerRefreshingText = kWaring8;
    self.tableView.footerNoDataText = kWaring55;
}




-(void)footreshing{
    HttpClientMgr.progressEnabled = NO;
    [self products];
}
//请求活动详情的优惠商品
-(void)products{

    if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
        [self showInfoView:kWaring12 image:@"img_network"];
        return;
    }
    
    BranchPromotionProductR* modelR=[BranchPromotionProductR new];
    modelR.packPromotionId=self.packPromotionId;
    modelR.branchId=QWGLOBALMANAGER.configure.groupId;
    modelR.currPage=[NSString stringWithFormat:@"%ld",(long)currentPage];
    modelR.pageSize=@"10";
    [Activity getPromotionProductListProduct:modelR success:^(id UFModel){
        NSMutableArray *keyArr = [NSMutableArray array];
        [keyArr addObject:NSStringFromClass([BranchPromotionProVO class])];
        
        NSMutableArray *valueArr = [NSMutableArray array];
        [valueArr addObject:@"list"];
        
        BranchPromotionListModel *model =   [BranchPromotionListModel parse:UFModel ClassArr:keyArr Elements:valueArr];
        
        if (model.list.count!=0){
            [productList addObjectsFromArray:model.list];
            currentPage++;
        }else{
            if(currentPage==1){
                self.tableView.footerHidden=YES;
            }else{
                self.tableView.footer.canLoadMore=NO;
            }
        }
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
    } failure:^(HttpException* e){
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



//请求活动详情的页面
-(void)detail{
    
    if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
        [self showInfoView:kWaring12 image:@"img_network"];
        return;
    }
    
    BranchPromotionDetailR* modelR=[BranchPromotionDetailR new];
    modelR.packPromotionId=self.packPromotionId;
    modelR.branchId=QWGLOBALMANAGER.configure.groupId;
    [Activity getPromotionDetail:modelR success:^(id UFModel){
        NSMutableArray *keyArr = [NSMutableArray array];
        [keyArr addObject:NSStringFromClass([BranchCouponVO class])];
        
        NSMutableArray *valueArr = [NSMutableArray array];
        [valueArr addObject:@"coupons"];
        
        PackPromotionDetailVO *model =   [PackPromotionDetailVO parse:UFModel ClassArr:keyArr Elements:valueArr];
        
        
        if([model.apiStatus intValue]==0){
            self.descla=model.desc;
            self.desc.text=model.desc;
            if(model.desc){
                CGSize size = [QWGLOBALMANAGER getTextSizeWithContent:model.desc WithUIFont:fontSystem(kFontS4) WithWidth:APP_W - 30];
                self.heightCon.constant=size.height+24;
            }
            if(model.imgUrl&&![model.imgUrl isEqualToString:@""]){
                [self.imgUrl setImageWithURL:[NSURL URLWithString:model.imgUrl]];
//                self.imgHeight.constant=143;
                [self.headView setFrame:CGRectMake(0, 0, APP_W, self.heightCon.constant+100)];
            }else{
                self.imgHeight.constant=0;
                [self.headView setFrame:CGRectMake(0, 0, APP_W, self.heightCon.constant)];
            }
            self.tableView.tableHeaderView=self.headView;
            self.tableView.tableHeaderView.backgroundColor=[UIColor whiteColor];
            
            
            if(model.status.intValue==1){//进行中
                
                UIBarButtonItem *barScan = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(btnShareClicked)];
                barScan.title=@"分享";
                self.navigationItem.rightBarButtonItem = barScan;
                self.desc.textColor = RGBHex(qwColor6);
                
                if(model.coupons.count!=0){
                    [coupnList removeAllObjects];
                    [coupnList addObjectsFromArray:model.coupons];
                }
                
                [self.tableView reloadData];
                [self.tableView footerEndRefreshing];
            }else {
                UIImageView *deleted=[[UIImageView alloc]initWithFrame:CGRectMake(APP_W-120, 150, 100, 100)];
                [deleted setImage:[UIImage imageNamed:@"img_bg_expired"]];
                [self.view addSubview:deleted];
                self.desc.textColor = RGBHex(qwColor8);
            }
            
        }else{
            [self showInfoView:model.apiMessage image:@"ic_img_fail"];
        }
        
        
       
    } failure:^(HttpException* e){
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
         [self.tableView footerEndRefreshing];
    }];

    
}


#pragma uitabledelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if(productList.count>0){
        return 2;
    }else{
        return 1;
    }
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
            //打折领券
        case 0:
        {
            NSString *ConsultPharmacyIdentifier = @"ConsultCouponTableViewCell";
            ConsultCouponTableViewCell *cell = (ConsultCouponTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ConsultPharmacyIdentifier];
            if(cell == nil){
                UINib *nib = [UINib nibWithNibName:@"ConsultCouponTableViewCell" bundle:nil];
                [tableView registerNib:nib forCellReuseIdentifier:ConsultPharmacyIdentifier];
                cell = (ConsultCouponTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ConsultPharmacyIdentifier];
            }
            cell.delegate = self;
            [cell setScrollView:coupnList];
            return cell;
            
        }
            break;
            //优惠商品
        case 1:
        {
                NSString *ConsultPharmacyIdentifier = @"SecondProductCell";
                SecondProductTableViewCell *cell = (SecondProductTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ConsultPharmacyIdentifier];
                if(cell == nil){
                    UINib *nib = [UINib nibWithNibName:@"SecondProductTableViewCell" bundle:nil];
                    [tableView registerNib:nib forCellReuseIdentifier:ConsultPharmacyIdentifier];
                    cell = (SecondProductTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ConsultPharmacyIdentifier];
                }
            BranchPromotionProVO *model=(BranchPromotionProVO*)productList[indexPath.row];
            [cell setAcitivyProductCell:model];
            
                return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==1){
        BranchPromotionProVO *model=(BranchPromotionProVO*)productList[indexPath.row];
        WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
        WebDrugDetailModel *modelDrug = [[WebDrugDetailModel alloc] init];
        modelDrug.proDrugID = model.productId;
        modelDrug.promotionID = model.promotionId;
        
        WebDirectLocalModel *modelLocal = [[WebDirectLocalModel alloc] init];
        modelLocal.modelDrug = modelDrug;
        modelLocal.typeLocalWeb = WebLocalTypeCouponProduct;
        modelLocal.title = @"药品详情";
        [vcWebDirect setWVWithLocalModel:modelLocal];
        
        vcWebDirect.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vcWebDirect animated:YES];
    }

}

#pragma mark ---- cell代理 点击优惠券 进券详情界面 ----

- (void)didSelectedCouponView:(BranchCouponVO *)obj{
    
    BranchdetailCViewController *vc=[[BranchdetailCViewController alloc] initWithNibName:@"BranchdetailCViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed=YES;

    BranchCouponVo * model=[self changeModel:obj];
    
    vc.coupnId = model.couponId;
    [self.navigationController pushViewController:vc animated:YES];
}

-(BranchCouponVo *)changeModel:(BranchCouponVO*)model{
    BranchCouponVo *mod=[BranchCouponVo new];
     mod.couponTag=model.couponTag;
     mod.couponValue=model.couponValue;
     mod.couponId=model.couponId;
     mod.groupName=model.groupName;
     mod.begin=model.startDate;
     mod.end=model.endDate;
     mod.scope=model.scope;
     mod.source=model.source;
    return mod;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section==0){
        if(coupnList.count>0){
            return 80.0f;
        }else{
            return 0;
        }
    }else if(indexPath.section==1){
        if(productList.count>0){
            return [SecondProductTableViewCell getCellHeight:nil];
        }else{
            return 0;
        }
       
    }else{
        return 0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(section==0){
        if(coupnList.count>0){
            return 1;
        }else{
            return 0;
        }
    }else if(section==1){
        if(productList.count>0){
            return productList.count;
        }else{
            return 0;
        }
        
    }else{
        return 0;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section==1){
        if(productList.count>0){
        return 40;
        }else{
            return 0;
        }
    }else{
        return 0;
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
     if (section==1){
    CGFloat height = 0;
    NSString *title;

            height = 40 ;
            title = @"优惠商品";
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, height)];
            view.backgroundColor = [UIColor whiteColor];
            
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_W, 0.5)];
            line.backgroundColor = RGBHex(qwColor10);
            [view addSubview:line];
            
            UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, height - 0.5, APP_W, 0.5)];
            line2.backgroundColor = RGBHex(qwColor10);
            [view addSubview:line2];
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(12, 9 + (height - 9 - 21)/2, APP_W-24, 21)];
            label.text = title;
            label.textColor = RGBHex(qwColor7);
            label.frame = CGRectMake(12, (height - 15)/2, APP_W-24, 21);
            UIImage *image = [UIImage imageNamed:@"arr_right"];
            UIImageView *rightImage = [[UIImageView alloc]initWithImage:image];
            rightImage.frame = CGRectMake(APP_W - 12, (height - 9 - image.size.height)/2, image.size.width, image.size.height);
            [view addSubview:rightImage];

            label.font = fontSystem(15);
            [view addSubview:label];

            return  view;
     }else{
         return nil;
     }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
