//
//  EndViewController.m
//  wenYao-store
//
//  Created by caojing on 15/8/21.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "EndViewController.h"
#import "Activity.h"
#import "DoingActivityTableViewCell.h"
#import "DoingDetailViewController.h"
@interface EndViewController ()<UITableViewDelegate,UITableViewDataSource>{
    int currentPage;
}
@property (strong, nonatomic) NSMutableArray *couponArray;

@end

@implementation EndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableMain setFrame:CGRectMake(0, 0, APP_W, APP_H-NAV_H-39)];
//    [self.tableMain addHeaderWithTarget:self action:@selector(headerRefresh)];
    
    [self enableSimpleRefresh:self.tableMain block:^(SRRefreshView *sender) {
        [self headerRefresh];
    }];
    self.tableMain.delegate=self;
    self.tableMain.backgroundColor = RGBHex(qwColor11);
    self.tableMain.dataSource=self;
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

- (void)collectViewDidLoad{
    
    self.couponArray = [[NSMutableArray alloc]init];
    currentPage = 1;
    [self loadDataheader:@"footer"];
}

- (void)footerRereshing{
    HttpClientMgr.progressEnabled = NO;
    [self loadDataheader:@"footer"];
}

- (void)headerRefresh
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
        return;
    }
     currentPage=1;
     self.tableMain.footer.canLoadMore=YES;
     [self loadDataheader:@"header"];
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


#pragma mark UITableViewDelegate
#pragma mark - HTTP请求
- (void)loadDataheader:(NSString*)isHeader{
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWaring12 image:@"网络信号icon"];
        return;
    }
    
    [self removeInfoView];
    GetNewBranchPromotionR *getBranchPromotionR = [GetNewBranchPromotionR new];
    getBranchPromotionR.branchId = QWGLOBALMANAGER.configure.groupId;
    getBranchPromotionR.currPage = [NSNumber numberWithInt:currentPage];
    getBranchPromotionR.pageSize = @10;
    getBranchPromotionR.status = @2;
    [Activity getNewStoreBranchPromotion:getBranchPromotionR success:^(id resultObj) {
        BranchPromotionListModel *listModel = (BranchPromotionListModel *)resultObj;
        
        if (listModel.list.count == 0){
            if(currentPage==1){
                [self showInfoView:@"暂无已结束优惠活动" image:@"img_preferential" flatY:10];
//                [self showInfoView:@"暂无已结束优惠活动" image:@"ic_img_fail"];
            }else{
                self.tableMain.footer.canLoadMore=NO;
            }
        }else{
            if([isHeader isEqualToString:@"header"]){
                [self.couponArray removeAllObjects];
            }
            [self.couponArray addObjectsFromArray:listModel.list];
            currentPage++;
            [self.tableMain reloadData];
        }
        if([isHeader isEqualToString:@"header"]){
            [self.tableMain headerEndRefreshing];
        }else{
            [self.tableMain footerEndRefreshing];
        }
    } failure:^(HttpException *e) {
        if([isHeader isEqualToString:@"header"]){
            [self.tableMain headerEndRefreshing];
        }else{
            [self.tableMain footerEndRefreshing];
        }
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
    return [DoingActivityTableViewCell getCellHeight:nil];
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
    
    static NSString *Identifier = @"CoupnActivityCell";
    
    DoingActivityTableViewCell *cell = (DoingActivityTableViewCell *)[self.tableMain dequeueReusableCellWithIdentifier:Identifier];
    if(cell == nil){
        UINib *nib = [UINib nibWithNibName:@"DoingActivityTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:Identifier];
        cell = (DoingActivityTableViewCell *)[tableView dequeueReusableCellWithIdentifier:Identifier];
        
    }
    BranchNewPromotionModel *mode = (BranchNewPromotionModel *)self.couponArray[indexPath.row];
    cell.title.textColor=[UIColor grayColor];
    [cell setCell:mode];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexPath *selection = [tableView indexPathForSelectedRow];
    if (selection) {
        [self.tableMain deselectRowAtIndexPath:selection animated:YES];
    }
    DoingDetailViewController *vc = [[DoingDetailViewController alloc]initWithNibName:@"DoingDetailViewController" bundle:nil];
    BranchNewPromotionModel *mode = (BranchNewPromotionModel *)self.couponArray[indexPath.row];
    vc.packPromotionId = mode.packPromotionId;//优惠活动的ID
    vc.titlela=mode.title;
    vc.descla=mode.desc;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
