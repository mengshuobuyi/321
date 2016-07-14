//
//  VerifyRecordListViewController.m
//  wenYao-store
//
//  Created by PerryChen on 6/15/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "VerifyRecordListViewController.h"
#import "VerifyRecordListCell.h"
#import "VerifyRecords.h"
@interface VerifyRecordListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tbViewContent;
@property (assign, nonatomic) NSInteger pageSize;
@property (assign, nonatomic) NSInteger curPage;
@property (nonatomic, strong) NSMutableArray *arrList;
@end

@implementation VerifyRecordListViewController
static NSString *const VerifyRecordCellIdentifier = @"VerifyRecordListCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"验证记录";
    self.curPage = 1;
    self.pageSize = 10;
    self.arrList = [@[] mutableCopy];
    [self.tbViewContent registerNib:[UINib nibWithNibName:@"VerifyRecordListCell" bundle:nil] forCellReuseIdentifier:VerifyRecordCellIdentifier];
    self.tbViewContent.rowHeight = 91.0f;
    [self.tbViewContent reloadData];
    [self.tbViewContent addFooterWithCallback:^{
        [HttpClient sharedInstance].progressEnabled = NO;
        self.curPage ++;
        [self getVerifyRecordsList];
    }];
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWaring12 image:@"img_network" flatY:40.0f];
    } else {
        [self getVerifyRecordsList];
    }
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([self.tbViewContent viewWithTag:1018] == nil) {
        [self enableSimpleRefresh:self.tbViewContent block:^(SRRefreshView *sender) {
            self.curPage = 1;
            [HttpClient sharedInstance].progressEnabled = NO;
            self.tbViewContent.footer.canLoadMore = YES;
            [self getVerifyRecordsList];
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getVerifyRecordsList
{
    VerifyRecordModelR *modelR = [VerifyRecordModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.page = [NSString stringWithFormat:@"%ld",self.curPage];
    modelR.pageSize = [NSString stringWithFormat:@"%ld",self.pageSize];
    [VerifyRecordsAPI getVerifyRecords:modelR success:^(VerifyRecordListModel *responseModel) {
        [self.tbViewContent.footer endRefreshing];
        if (self.curPage == 1) {
            [self.arrList removeAllObjects];
        }
        if (responseModel.orders.count > 0) {
            [self.arrList addObjectsFromArray:responseModel.orders];
        } else {
            if (self.curPage == 1) {
                [self showInfoView:@"暂无数据" image:@"img_employee_statistical"];
            } else {
                self.tbViewContent.footer.canLoadMore = NO;
            }
        }
        [self.tbViewContent reloadData];
    } failure:^(HttpException *e) {
        [self.tbViewContent.footer endRefreshing];
    }];
}

#pragma mark - UITableView methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VerifyRecordListCell *cell = (VerifyRecordListCell *)[tableView dequeueReusableCellWithIdentifier:VerifyRecordCellIdentifier];
    VerifyRecordModel *model = self.arrList[indexPath.section];
    cell.lblTitle.text = model.title;
    [cell.imgViewContent setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"news_placeholder"]];
    cell.lblRecordOwner.text = [NSString stringWithFormat:@"兑换人: %@",model.userName];
    cell.lblRecordScore.text = [NSString stringWithFormat:@"%@积分",model.score];
    cell.lblVerifyTime.text = [NSString stringWithFormat:@"验证时间: %@",model.drawDate];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *viewSectionFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 5.0f)];
    viewSectionFooter.backgroundColor = [UIColor clearColor];
    return viewSectionFooter;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
