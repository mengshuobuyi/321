//
//  DoingViewController.m
//  wenYao-store
//
//  Created by caojing on 15/8/21.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "ImDoingViewController.h"
#import "DoingActivityTableViewCell.h"
#import "DoingDetailViewController.h"

@interface ImDoingViewController ()<UITableViewDelegate,UITableViewDataSource>{
    int currentPage;
}
@property (strong, nonatomic) NSMutableArray *couponArray;
@end

@implementation ImDoingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableMain setFrame:CGRectMake(0, 0, APP_W, APP_H-NAV_H)];
    self.tableMain.delegate=self;
    self.tableMain.backgroundColor = RGBHex(qwColor11);
    self.tableMain.dataSource=self;
    [self.view addSubview:self.tableMain];
    self.title=@"优惠活动";
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
    [self loadData];
}

- (void)footerRereshing{
    HttpClientMgr.progressEnabled = NO;
    [self loadData];
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


#pragma mark - HTTP请求
- (void)loadData{
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWaring12 image:@"网络信号icon"];
        return;
    }
    
    [self removeInfoView];
    GetNewBranchPromotionR *getBranchPromotionR = [GetNewBranchPromotionR new];
    getBranchPromotionR.branchId = QWGLOBALMANAGER.configure.groupId;
    getBranchPromotionR.currPage = [NSNumber numberWithInt:currentPage];
    getBranchPromotionR.pageSize = @10;
    getBranchPromotionR.status = @1;
    [Activity getNewStoreBranchPromotion:getBranchPromotionR success:^(id resultObj) {
        BranchPromotionListModel *listModel = (BranchPromotionListModel *)resultObj;
        
        if (listModel.list.count == 0){
            if(currentPage==1){
                [self showInfoView:@"暂无优惠活动" image:@"img_preferential"];
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
                [self showInfoView:kWarning215N54 image:@"img_preferential"];
            }else{
                [self showInfoView:kWarning215N0 image:@"img_preferential"];
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
    
    [cell setCell:mode];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexPath *selection = [tableView indexPathForSelectedRow];
    if (selection) {
        [self.tableMain deselectRowAtIndexPath:selection animated:YES];
    }
    
    if(self.SendNewCoupn){//聊天用的block
        BranchNewPromotionModel *mode = (BranchNewPromotionModel *)self.couponArray[indexPath.row];
        self.SendNewCoupn(mode);
        [self.navigationController popViewControllerAnimated:YES];
    
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
