//
//  CoupnCollectViewController.m
//  APP
//
//  Created by caojing on 15/6/2.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "CoupnViewController.h"
#import "CouponDeatilViewController.h"
@interface CoupnViewController()<UITableViewDelegate,UITableViewDataSource>{
    int   currentPage;
}

@end

@implementation CoupnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"优惠活动";
    [self.tableMain setFrame:CGRectMake(0, 0, APP_W, APP_H-NAV_H)];
    self.tableMain.delegate=self;
    self.tableMain.backgroundColor = RGBHex(qwColor11);
    self.tableMain.dataSource=self;
//    [self.tableMain addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.view addSubview:self.tableMain];
    
    if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
        [self showInfoView:kWaring12 image:@"img_network"];
        return;
    }else{
        [self collectViewDidLoad];
    }
}

- (void)hudStopByTouch:(id)hud{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewInfoClickAction:(id)sender{
    
    if(QWGLOBALMANAGER.currentNetWork != kNotReachable){
        
        [self removeInfoView];
        [self collectViewDidLoad];
    }
}




- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    ((QWBaseNavigationController *)self.navigationController).canDragBack = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    ((QWBaseNavigationController *)self.navigationController).canDragBack = YES;
}

- (void)collectViewDidLoad{
    
    self.couponArray = [[NSMutableArray alloc]init];
    currentPage = 1;
    [self loadData];
}

- (void)footerRereshing{
    HttpClientMgr.progressEnabled = NO;
    [self loadData];
}

#pragma mark - HTTP请求
- (void)loadData{
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWaring12 image:@"网络信号icon"];
        return;
    }
    
        [self removeInfoView];
        GetBranchPromotionR *getBranchPromotionR = [GetBranchPromotionR new];
        getBranchPromotionR.branchId = QWGLOBALMANAGER.configure.groupId;
        getBranchPromotionR.currPage = [NSNumber numberWithInt:currentPage];
        getBranchPromotionR.pageSize = @10;
        [Activity getStoreBranchPromotion:getBranchPromotionR success:^(id resultObj) {
            BranchPromotionListModel *listModel = (BranchPromotionListModel *)resultObj;
           
            if (listModel.list.count == 0){
                if(currentPage==1){
                    [self showInfoView:@"暂无优惠活动" image:@"ic_img_fail"];
                }else{
                    self.tableMain.footer.canLoadMore=NO;
                }
            }else{
                [self.couponArray addObjectsFromArray:listModel.list];
                currentPage++;
                [self.tableMain reloadData];
            }
             [self.tableMain footerEndRefreshing];

        } failure:^(HttpException *e) {
             [self.tableMain footerEndRefreshing];
            if(e.errorCode!=-999){
                if(e.errorCode == -1001){
                    [self showInfoView:kWarning215N54 image:@"ic_img_fail"];
                }else{
                    [self showInfoView:kWarning215N0 image:@"ic_img_fail"];
                }
            }
        }];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CoupnTableViewCell getCellHeight:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.couponArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *Identifier = @"couponCell";
    
    CoupnTableViewCell *cell = (CoupnTableViewCell *)[self.tableMain dequeueReusableCellWithIdentifier:Identifier];
    if(cell == nil){
        UINib *nib = [UINib nibWithNibName:@"CoupnTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:Identifier];
        cell = (CoupnTableViewCell *)[tableView dequeueReusableCellWithIdentifier:Identifier];
        
    }
    BranchPromotionModel *mode = (BranchPromotionModel *)self.couponArray[indexPath.row];
    
    [cell setCell:mode];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexPath *selection = [tableView indexPathForSelectedRow];
    if (selection) {
        [self.tableMain deselectRowAtIndexPath:selection animated:YES];
    }
    if(self.SendBranchCoupn){
        BranchPromotionModel *mode = (BranchPromotionModel *)self.couponArray[indexPath.row];
        if ([mode.status integerValue] != 2 || [mode.pushStatus intValue]==2) {//非正常
            return;
        }
        self.SendBranchCoupn(mode);
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        CouponDeatilViewController *vc = [[CouponDeatilViewController alloc]initWithNibName:@"CouponDeatilViewController" bundle:nil];
        BranchPromotionModel *mode = (BranchPromotionModel *)self.couponArray[indexPath.row];
        vc.commonPromotionId = mode.id;//优惠活动的ID
        [self.navigationController pushViewController:vc animated:YES];
    
    }

}


@end
