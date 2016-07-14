//
//  ClientAppraiseListViewController.m
//  wenYao-store
//
//  会员订单评价列表
//  h5/branch/appraise/mmall
//  Created by PerryChen on 5/16/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "ClientAppraiseListViewController.h"
#import "BranchAppraiseCell.h"
#import "EvaluationViewController.h"
#import "Branch.h"
@interface ClientAppraiseListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataList;
@property (weak, nonatomic) IBOutlet UITableView *tbViewContent;
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, assign) NSInteger pageSize;

@end

@implementation ClientAppraiseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评价";
    self.dataList = [NSMutableArray array];
    self.curPage = 1;
    self.pageSize = 10;
    [self.tbViewContent addFooterWithCallback:^{
        [HttpClient sharedInstance].progressEnabled = NO;
        self.curPage ++;
        [self queryNewlist];
    }];
    [self setupRightItem];
    [self queryNewlist];
    // Do any additional setup after loading the view.
}
/**
 *  设置导航栏右侧按钮
 */
- (void)setupRightItem
{
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = -15;
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    
    //三个点button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, 0, 70, 40);
    [button setTitle:@"历史评价" forState:UIControlStateNormal];
    button.titleLabel.font = fontSystem(kFontS1);
    [button addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:button];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItems = @[fixed, rightItem];
}

/**
 *  点击导航栏右侧按钮事件
 */
- (void)rightAction
{
    EvaluationViewController *viewcontroller=[[EvaluationViewController alloc] init];
    viewcontroller.customer = self.customerId;
    viewcontroller.comeFrom = nil;
    viewcontroller.fromWechatOld = YES;
    viewcontroller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([self.tbViewContent viewWithTag:1018] == nil) {
        [self enableSimpleRefresh:self.tbViewContent block:^(SRRefreshView *sender) {
            self.curPage = 1;
            [HttpClient sharedInstance].progressEnabled = NO;
            [self.dataList removeAllObjects];
            [self.tbViewContent reloadData];
            self.tbViewContent.footer.canLoadMore = YES;
            [self queryNewlist];
        }];
    }
}
- (void)queryNewlist
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"branchId"] = StrFromObj(QWGLOBALMANAGER.configure.groupId);
    setting[@"page"] = [NSString stringWithFormat:@"%ld",(long)self.curPage];
    setting[@"pageSize"] = @"10";
    setting[@"userId"] = self.customerId;
    [Branch BranchAppraiseMmallWithParams:setting success:^(id obj) {
        
        [self.tbViewContent footerEndRefreshing];
        BranchAppraisePageModel *page = [BranchAppraisePageModel parse:obj Elements:[BranchAppraiseModel class] forAttribute:@"appraises"];
        
        if (page.appraises.count > 0) {
            [self.dataList addObjectsFromArray:page.appraises];
        } else {
            if (self.curPage == 1) {
                [self showInfoView:@"您还没有收到评价" image:@"ic_img_fail"];
            } else {
                self.tbViewContent.footer.canLoadMore = NO;
            }
        }
        [self.tbViewContent reloadData];
    } failure:^(HttpException *e) {
        [self.tbViewContent footerEndRefreshing];
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableView methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 8)];
    vi.backgroundColor = [UIColor clearColor];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 0.5)];
    line1.backgroundColor = RGBHex(qwColor10);
    [vi addSubview:line1];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 7.5, APP_W, 0.5)];
    line2.backgroundColor = RGBHex(qwColor10);
    [vi addSubview:line2];
    return vi;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [BranchAppraiseCell getCellHeight:self.dataList[indexPath.section]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BranchAppraiseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BranchAppraiseCell"];
    [cell setCell:self.dataList[indexPath.section]];
    return cell;
}


@end
