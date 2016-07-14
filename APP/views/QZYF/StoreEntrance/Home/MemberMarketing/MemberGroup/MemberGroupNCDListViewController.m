//
//  MemberGroupNCDListViewController.m
//  wenYao-store
//
//  会员列表页面
//  h5/customer/queryByNcd
//  Created by PerryChen on 5/13/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "MemberGroupNCDListViewController.h"
#import "MyDefineCell.h"
#import "MemberMarket.h"
#import "ClientMMDetailViewController.h"
#define MyDefineCellIdentifier @"MyDefineCellIdentifier"
@interface MemberGroupNCDListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tbViewContent;
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSMutableArray *arrMember;
@end

@implementation MemberGroupNCDListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"MyDefineCell" bundle:nil];
    [self.tbViewContent registerNib:nib forCellReuseIdentifier:MyDefineCellIdentifier];
    self.arrMember = [NSMutableArray array];
    self.curPage = 1;
    self.pageSize = 10;
    self.navigationItem.title = self.modelNcd.ncdName;
    [self.tbViewContent addFooterWithCallback:^{
        [HttpClient sharedInstance].progressEnabled = NO;
        self.curPage ++;
        [self getNcdMembers];
    }];
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWaring12 image:@"img_network" flatY:40.0f];
    } else {
        [self getNcdMembers];
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
            [self.arrMember removeAllObjects];
            [self.tbViewContent reloadData];
            self.tbViewContent.footer.canLoadMore = YES;
            [self getNcdMembers];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getNcdMembers
{
    MemberQueryByNcdModelR *modelR = [MemberQueryByNcdModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.ncd = self.modelNcd.ncdId;
    modelR.page = [NSString stringWithFormat:@"%d",self.curPage];
    modelR.pageSize = [NSString stringWithFormat:@"%d",self.pageSize];
    [MemberMarket queryCustomerNcdList:modelR success:^(MemberNcdCustomerListVo *responseModel) {
        [self.tbViewContent.footer endRefreshing];
        if (responseModel.customers.count > 0) {
            [self.arrMember addObjectsFromArray:responseModel.customers];
        } else {
            if (self.curPage == 1) {
                [self showInfoView:@"暂无会员" image:@"ic_img_fail"];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMember.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberNcdDetailVo *model = self.arrMember[indexPath.row];
    MyDefineCell *cell = [tableView dequeueReusableCellWithIdentifier:MyDefineCellIdentifier];
    [cell configureCell:model];
    cell.selectButton.hidden = YES;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberNcdDetailVo *model = self.arrMember[indexPath.row];
    ClientMMDetailViewController *info = [[UIStoryboard storyboardWithName:@"ClientInfo" bundle:nil] instantiateViewControllerWithIdentifier:@"ClientMMDetailViewController"];
    info.hidesBottomBarWhenPushed = YES;
    info.customerId = model.userId;
    [self.navigationController pushViewController:info animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
