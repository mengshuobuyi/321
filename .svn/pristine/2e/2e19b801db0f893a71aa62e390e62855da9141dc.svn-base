//
//  EvaluationViewController.m
//  wenyao
//
//  Created by xiezhenghong on 14-10-6.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "EvaluationViewController.h"
#import "PharmacyCommentTableViewCell.h"
#import "Branch.h"
#import "Appraise.h"

@interface EvaluationViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger currentPage;
}
@property (nonatomic, strong) NSMutableArray        *infoList;

@end

@implementation EvaluationViewController

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.fromWechatOld) {
        self.title = @"评价历史";
    } else {
        self.title = @"订单评价";
    }
    
    self.infoList = [NSMutableArray array];
    
    [self setUpTableView];
    
    currentPage = 1;
    if(self.comeFrom){
        [self loadDataOld];
    }else{
        if (self.fromWechatOld) {   // 从开通微商的会员详情进入
            [self loadDataFromWechat];
        } else {
            [self loadData];
        }
    }
    
}

- (void)setUpTableView
{
    CGRect rect = self.view.frame;
    rect.size.height=rect.size.height-64;
    [self.tableMain setFrame:rect];
    self.tableMain.delegate = self;
    self.tableMain.dataSource = self;
    self.tableMain.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableMain setBackgroundColor:[UIColor clearColor]];
    self.tableMain.allowsSelection=NO;
    self.tableMain.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableMain];
}

#pragma mark ---- 下拉刷新 ----

- (void)footerRereshing
{
    if(self.comeFrom){
        [self loadDataOld];
    }else{
        if (self.fromWechatOld) {   // 从开通微商的会员详情进入
            [self loadDataFromWechat];
        } else {
            [self loadData];
        }
    }
}


- (void)loadDataOld
{
    QueryAppraiseModelR *modelR=[QueryAppraiseModelR new];
    modelR.groupId=QWGLOBALMANAGER.configure.groupId;
    modelR.currPage=[NSString stringWithFormat:@"%ld",(long)currentPage];
    modelR.pageSize=@"10";
    
    if (self.customer.length > 0) {
        modelR.customer = self.customer;
    }
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWaring12 image:@"img_network"];
        return;
    } else{
        
        [Appraise QueryAppraiseWithParams:modelR success:^(id UFmodel){
            
            [self.tableMain footerEndRefreshing];
            AppraiseModel *page=(AppraiseModel *)UFmodel;
            
            if (page.list.count == 0) {
                self.tableMain.footer.canLoadMore = NO;
            }
            
            [self.infoList addObjectsFromArray:page.list];
            if (self.infoList.count > 0) {
                
                for (int i = 0; i < self.infoList.count; i++) {
                    QueryAppraiseModel *mo=(QueryAppraiseModel *)self.infoList[i];
                    mo.read=@"1" ;//1表示已读
                }
                [self.tableMain reloadData];
                currentPage++;
            }else{
                if(currentPage==1){
                    [self showInfoView:@"您还没有收到评价" image:@"ic_img_fail"];
                }
            }
        } failure:^(HttpException *e){
            [self.tableMain footerEndRefreshing];
        }];
    }
}




#pragma mark ---- 服务器请求数据 ----

- (void)loadData
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWaring12 image:@"img_network"];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"branchId"] = QWGLOBALMANAGER.configure.groupId;
    setting[@"page"] = [NSString stringWithFormat:@"%ld",(long)currentPage];
    setting[@"pageSize"] = @"10";
    HttpClientMgr.progressEnabled = NO;
    [Branch BranchAppraiseNormalWithParams:setting success:^(id obj) {
        
        [self.tableMain footerEndRefreshing];
        BranchAppraisePageModel *page = [BranchAppraisePageModel parse:obj Elements:[BranchAppraiseModel class] forAttribute:@"appraises"];
        
        if (page.appraises.count == 0) {
            self.tableMain.footer.canLoadMore = NO;
        }
        
        [self.infoList addObjectsFromArray:page.appraises];
        if (self.infoList.count > 0) {
            [self.tableMain reloadData];
            currentPage++;
        }else{
            if(currentPage==1){
                [self showInfoView:@"您还没有收到评价" image:@"ic_img_fail"];
            }
        }
    } failure:^(HttpException *e) {
        [self.tableMain footerEndRefreshing];
    }];

}

- (void)loadDataFromWechat
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWaring12 image:@"img_network"];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"branchId"] = QWGLOBALMANAGER.configure.groupId;
    setting[@"userId"] = self.customer;
    setting[@"page"] = [NSString stringWithFormat:@"%ld",(long)currentPage];
    setting[@"pageSize"] = @"10";
    HttpClientMgr.progressEnabled = NO;
    [Branch BranchAppraiseNormalWithParams:setting success:^(id obj) {
        
        [self.tableMain footerEndRefreshing];
        BranchAppraisePageModel *page = [BranchAppraisePageModel parse:obj Elements:[BranchAppraiseModel class] forAttribute:@"appraises"];
        
        if (page.appraises.count == 0) {
            self.tableMain.footer.canLoadMore = NO;
        }
        
        [self.infoList addObjectsFromArray:page.appraises];
        if (self.infoList.count > 0) {
            [self.tableMain reloadData];
            currentPage++;
        }else{
            if(currentPage==1){
                [self showInfoView:@"您还没有收到评价" image:@"ic_img_fail"];
            }
        }
    } failure:^(HttpException *e) {
        [self.tableMain footerEndRefreshing];
    }];
    
}


#pragma mark ---- 列表代理 ----

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(self.comeFrom){
        QueryAppraiseModel *dict = self.infoList[indexPath.row];
        return [PharmacyCommentTableViewCell getOldCellHeight:dict];
    }else{
        return [PharmacyCommentTableViewCell getCellHeight:self.infoList[indexPath.row]];
    }

}

- (NSInteger)tableView:(UITableView *)atableView numberOfRowsInSection:(NSInteger)section
{
    return self.infoList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)atableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *PharmacyCommentIdentifier = @"ConsultPharmacyIdentifier";
    PharmacyCommentTableViewCell *cell = (PharmacyCommentTableViewCell *)[atableView dequeueReusableCellWithIdentifier:PharmacyCommentIdentifier];
    if(cell == nil){
        UINib *nib = [UINib nibWithNibName:@"PharmacyCommentTableViewCell" bundle:nil];
        [atableView registerNib:nib forCellReuseIdentifier:PharmacyCommentIdentifier];
        cell = (PharmacyCommentTableViewCell *)[atableView dequeueReusableCellWithIdentifier:PharmacyCommentIdentifier];
    }
    if(self.comeFrom){
        QueryAppraiseModel *dict = self.infoList[indexPath.row];
        [cell setOldCell:dict];
    }else{
        [cell setCell:self.infoList[indexPath.row]];
    }
    

    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
