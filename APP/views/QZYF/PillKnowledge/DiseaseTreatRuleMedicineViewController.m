//
//  TreatMedicineViewController.m
//  APP
//
//  Created by Meng on 15/6/10.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "DiseaseTreatRuleMedicineViewController.h"
#import "Order.h"
#import "CouponPromotionTableViewCell.h"
#import "WebDirectViewController.h"

#define CollectCellHeight 188

static NSString * const TreatMedicineCellIdentifier = @"TreatMedicineCellIdentifier";

@interface DiseaseTreatRuleMedicineViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger currentPage;
}
@property (nonatomic ,strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView    *tableView;

@end

@implementation DiseaseTreatRuleMedicineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [NSMutableArray array];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_W, self.view.frame.size.height)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.showsHorizontalScrollIndicator = NO;
//    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"CouponPromotionTableViewCell" bundle:nil] forCellReuseIdentifier:@"CouponPromotionTableViewCell"];
    
    [self.view addSubview:self.tableView];
}

- (void)setUpTableFrame:(CGRect)rect
{
    self.tableView.frame = rect;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)currentViewSelected:(void (^)(CGFloat))finishLoading
{
    if (self.dataSource.count > 0) {
        if (finishLoading) {
            finishLoading(self.dataSource.count * 81 + 10);
        }
    }

    currentPage = 1;
    DiseaseProductListR *productr=[DiseaseProductListR new];
    productr.diseaseId = self.diseaseId;
    productr.type = self.requestType;
    productr.currPage = [NSString stringWithFormat:@"%ld",(long)currentPage];
    productr.pageSize = @"12";
    productr.v = @"2.0";
    //新增城市和省
    [QWGLOBALMANAGER readLocationInformation:^(MapInfoModel *mapInfoModel) {
        if(mapInfoModel) {
            productr.province = StrFromObj(mapInfoModel.province);
            productr.city = StrFromObj(mapInfoModel.city);
        }else{
            productr.province = @"江苏省";
            productr.city = @"苏州市";
        }
        [HttpClientMgr setProgressEnabled:NO];
        [Order queryThreeWithParam:productr Success:^(id DFUserModel) {
            [self removeInfoView];
            [self.dataSource removeAllObjects];
            DiseaseFormulaPruduct *productModel = (DiseaseFormulaPruduct *)DFUserModel;
            [self.dataSource addObjectsFromArray:productModel.list];
            if (self.dataSource.count > 0) {
                currentPage ++;
                [self.tableView reloadData];
                CGFloat height = 81 * self.dataSource.count;
                self.tableView.contentSize = CGSizeMake(APP_W, height);
                [self.tableView setFrame:CGRectMake(0, 10, APP_W, height)];
                NSInteger type = [self.requestType integerValue];
                [self.view setFrame:CGRectMake((type - 1) * APP_W, 0, APP_W, height + 10)];
                
                if (finishLoading) {
                    finishLoading(self.dataSource.count * 81 + 10);
                }
                
            }else{
                if (finishLoading) {
                    finishLoading(400);
                }
                [self showInfoView:@"无相关药品" image:@"ic_img_fail"];
            }
            
        } failure:^(HttpException *e) {
            if(e.errorCode!=-999){
                if(e.errorCode == -1001){
                    [self showInfoView:kWarning215N54 image:@"img_preferential"];
                }else{
                    [self showInfoView:kWarning215N0 image:@"img_preferential"];
                }
            }
            return;
        }];
        
    }];
   
}

- (void)footerRereshing:(void (^)(CGFloat))finishRefresh :(void (^)(BOOL))canLoadMore :(void (^)())failure
{
    if(self.dataSource.count == 0) {
        if (finishRefresh) {
            finishRefresh(350);
        }
        [self showInfoView:@"无相关药品" image:@"ic_img_fail"];
        return;
    }
    DiseaseProductListR *productr=[DiseaseProductListR new];
    productr.diseaseId = self.diseaseId;
    productr.type = self.requestType;
    productr.currPage = [NSString stringWithFormat:@"%ld",(long)currentPage];
    productr.pageSize = @"12";
    productr.v = @"2.0";
    //新增城市和省
    [QWGLOBALMANAGER readLocationInformation:^(MapInfoModel *mapInfoModel) {
        if(mapInfoModel) {
             productr.province = StrFromObj(mapInfoModel.province);
             productr.city = StrFromObj(mapInfoModel.city);
        }else{
             productr.province = @"江苏省";
             productr.city = @"苏州市";
        }
        [HttpClientMgr setProgressEnabled:NO];
        [Order queryThreeWithParam:productr Success:^(id DFUserModel) {
            DiseaseFormulaPruduct *productModel = (DiseaseFormulaPruduct *)DFUserModel;
            [self.dataSource addObjectsFromArray:productModel.list];
            if (productModel.list.count == 0) {
                if (canLoadMore) {
                    canLoadMore(NO);
                }
            }
            if (self.dataSource.count > 0) {
                currentPage ++;
                [self.tableView reloadData];
                CGFloat height = 81 * self.dataSource.count;
                self.tableView.contentSize = CGSizeMake(APP_W, height);
                [self.tableView setFrame:CGRectMake(0, 10, APP_W, height)];
                NSInteger type = [self.requestType integerValue];
                [self.view setFrame:CGRectMake((type - 1) * APP_W, 0, APP_W, height + 10)];
                if (finishRefresh) {
                    finishRefresh(height + 10);
                }
            }else{
                if (finishRefresh) {
                    finishRefresh(400);
                }
                [self showInfoView:@"无相关药品" image:@"ic_img_fail"];
            }
        } failure:^(HttpException *e) {
            if (failure) {
                failure();
            }
            if(e.errorCode!=-999){
                if(e.errorCode == -1001){
                    [self showInfoView:kWarning215N54 image:@"img_preferential"];
                }else{
                    [self showInfoView:kWarning215N0 image:@"img_preferential"];
                }
                
            }
            return;
        }];
    }];
    
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81.0f;
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
    CouponPromotionTableViewCell *cell = [atableView dequeueReusableCellWithIdentifier:@"CouponPromotionTableViewCell"];
    DiseaseFormulaPruductclass *model = self.dataSource[indexPath.row];
    [cell.ImagUrl setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"药品默认图片"]];
    
    cell.proName.text = model.proName;
    cell.spec.text = model.spec;
    cell.factoryName.text = model.factory;

    cell.label.hidden=YES;
    [cell.gift removeFromSuperview];
    [cell.discount removeFromSuperview];
    [cell.voucher removeFromSuperview];
    [cell.special removeFromSuperview];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    DiseaseFormulaPruductclass *model = self.dataSource[indexPath.row];
//    [self pushToDrugDetailWithDrugID:model.proId promotionId:model.promotionId];
    //直接进普通详情（商户端）
    WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
    WebDrugDetailModel *modelDrug = [[WebDrugDetailModel alloc] init];
    modelDrug.proDrugID = model.proId;
    WebDirectLocalModel *modelLocal = [[WebDirectLocalModel alloc] init];
    
    modelLocal.modelDrug = modelDrug;
    modelLocal.typeLocalWeb = WebLocalTypeCouponProduct;
    modelLocal.title = @"药品详情";
    [vcWebDirect setWVWithLocalModel:modelLocal];
    vcWebDirect.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcWebDirect animated:YES];
    
}


@end
