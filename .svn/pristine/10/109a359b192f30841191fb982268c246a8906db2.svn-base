//
//  StoreCreditViewController.m
//  wenYao-store
//  接口
//  店员信息      :   h5/mbr/branch/queryEmployees
//  Created by Martin.Liu on 16/5/6.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "StoreCreditViewController.h"
#import "StoreCreditTableCell.h"
#import "WebDirectViewController.h"
#import "Store.h"
#import "UITableView+FDTemplateLayoutCell.h"

NSString *const kCellTitle_Sign                = @"签到";
NSString *const kCellTitle_Share               = @"分享";
NSString *const kCellTitle_HandeleOrder        = @"订单处理";
NSString *const kCellTitle_DownAPP             = @"引导顾客下载问药APP";
NSString *const kCellTitle_ShowCreateOrder     = @"线下引导下单";
NSString *const kCellTitle_ShareTransformOrder = @"分享转化订单";
NSString *const kCellTitle_TrainContext        = @"培训模块中的内容";
NSString *const kCellTitle_BusinessContext     = @"生意经中内容";

@interface StoreCreditViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView      *tableHearderView;
@property (weak, nonatomic) IBOutlet UIView      *creditTextContainerView;
@property (weak, nonatomic) IBOutlet UILabel     *creditCountLabel;
@property (weak, nonatomic) IBOutlet UIView      *creditStoreContainerView;

- (IBAction)creditDetailBarBtnAction:(id)sender;
- (IBAction)creditStoreBtnAction:(id)sender;
@end

@implementation StoreCreditViewController
{
    NSArray* storeCreditArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBHex(qwColor11);
    self.creditStoreContainerView.backgroundColor = RGBHex(qwColor2);
    self.creditStoreContainerView.layer.masksToBounds = YES;
    self.creditStoreContainerView.layer.cornerRadius = 4;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.creditCountLabel.text = StrFromInt(self.score);
    if (QWGLOBALMANAGER.configure.storeType == 3)
    {
        // 开通微商
        storeCreditArray = @[[[StoreCreditModel alloc] initWithArray:@[@"integral_btn_one",kCellTitle_Sign,@"每日签到 +5积分，每天限一次",@"+5"]],
                             [[StoreCreditModel alloc] initWithArray:@[@"integral_btn_two",kCellTitle_Share,@"分享加积分，每天限一次",@"+5"]],
                             [[StoreCreditModel alloc] initWithArray:@[@"integral_btn_three",kCellTitle_HandeleOrder,@"接单，待这笔订单完成时，奖励接单人积分",@"+10"]],
                             [[StoreCreditModel alloc] initWithArray:@[@"integral_btn_eight",kCellTitle_DownAPP,@"顾客下载问药APP并添加推荐人，奖励积分",@"+5"]],
                             [[StoreCreditModel alloc] initWithArray:@[@"integral_btn_six",kCellTitle_ShowCreateOrder,@"20分钟内，对引导下单的用户“接单”并确认订单，奖励积分",@"+5"]],
                             [[StoreCreditModel alloc] initWithArray:@[@"integral_btn_seven",kCellTitle_ShareTransformOrder,@"通过分享本店商品和门店，转化成订单",@"+5"]],
                             [[StoreCreditModel alloc] initWithArray:@[@"integral_btn_five",kCellTitle_TrainContext,@"积极完成培训中问答卷和文章阅读奖励积分",@""]],
                             [[StoreCreditModel alloc] initWithArray:@[@"integral_btn_four",kCellTitle_BusinessContext,@"学习指定的资料、视频、奖励积分",@""]]
                             ];
    }
    else
    {
        // 未开通微商
        storeCreditArray = @[[[StoreCreditModel alloc] initWithArray:@[@"integral_btn_one",kCellTitle_Sign,@"每日签到 +5积分，每天限一次",@"+5"]],
                             [[StoreCreditModel alloc] initWithArray:@[@"integral_btn_two",kCellTitle_Share,@"分享加积分，每天限一次",@"+5"]],
                             [[StoreCreditModel alloc] initWithArray:@[@"integral_btn_eight",kCellTitle_DownAPP,@"顾客下载问药APP并添加推荐人，奖励积分",@"+5"]],
                             [[StoreCreditModel alloc] initWithArray:@[@"integral_btn_five",kCellTitle_TrainContext,@"积极完成培训中问答卷和文章阅读奖励积分",@""]],
                             [[StoreCreditModel alloc] initWithArray:@[@"integral_btn_four",kCellTitle_BusinessContext,@"学习指定的资料、视频、奖励积分",@""]]];
    }
    
    // 如果没有传过来积分，调接口
    if (self.score == 0) {
        [self loadData];
    }
    
}

- (void)loadData
{
    if (!StrIsEmpty(QWGLOBALMANAGER.configure.userToken)) {
        __weak __typeof(self)weakSelf = self;
        HttpClientMgr.progressEnabled = NO;
        [Store queryEmployees:@{@"token":QWGLOBALMANAGER.configure.userToken} success:^(EmployeeInfoModel *employeeInfoModel) {
            weakSelf.score = employeeInfoModel.score;
            weakSelf.creditCountLabel.text = StrFromInt(weakSelf.score);
            [QWUserDefault setObject:employeeInfoModel key:[NSString stringWithFormat:@"EmployeeInfo%@",QWGLOBALMANAGER.configure.passportId]];
        } fail:^(HttpException *e) {
            ;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 使用帮助
- (void)helpBtnAction:(UIButton*)sender
{
    WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
    vcWebDirect.hidesBottomBarWhenPushed = YES;
    WebDirectLocalModel* webModel = [WebDirectLocalModel new];
    webModel.title = @"使用帮助";
    webModel.url = [NSString stringWithFormat:@"%@QWSH/web/ruleDesc/html/useHelp.html", H5_BASE_URL];
    [vcWebDirect setWVWithLocalModel:webModel];
    [self.navigationController pushViewController:vcWebDirect animated:YES];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    // Tableview style 是 Group , 所以有一个默认的高度 ，之所以设置为Group ，是为了sectionview跟着tableview滑动，而不置顶
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, [self tableView:tableView heightForHeaderInSection:section])];
    view.backgroundColor = [UIColor whiteColor];
    UILabel* tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, APP_W/2, CGRectGetHeight(view.frame))];
    tipLabel.font = [UIFont systemFontOfSize:kFontS4];
    tipLabel.textColor = RGBHex(qwColor6);
    tipLabel.text = @"如何赚积分";
    UIImage* helpImage = [UIImage imageNamed:@"icon_jifen_ask"];
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(view.frame) - 15 - helpImage.size.width, (CGRectGetHeight(view.frame) - helpImage.size.height)/2, helpImage.size.width, helpImage.size.height)];
    imageView.image = helpImage;
    UIButton* helpBtn = [[UIButton alloc] initWithFrame:CGRectMake(APP_W*3/4, 0, APP_W/4, CGRectGetHeight(view.frame))];
    [helpBtn addTarget:self action:@selector(helpBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* hrLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(view.frame) - 1, APP_W, 1.0/[UIScreen mainScreen].scale)];
    hrLine.backgroundColor = RGBHex(qwColor10);
    
    [view addSubview:tipLabel];
    [view addSubview:imageView];
    [view addSubview:helpBtn];
    [view addSubview:hrLine];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return storeCreditArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreCreditTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"storeCreditCell" forIndexPath:indexPath];
    [self configure:cell indexPath:indexPath];
    return cell;
}

- (void)configure:(id)cell indexPath:(NSIndexPath*)indexPath
{
    if (storeCreditArray.count > indexPath.row) {
        [cell setCell:storeCreditArray[indexPath.row]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"storeCreditCell" configuration:^(id cell) {
        [self configure:cell indexPath:indexPath];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreCreditTableCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString* url = nil;
    NSString* titleString = cell.myTitleLabel.text;
    // 生意经内容
    if ([titleString isEqualToString:kCellTitle_BusinessContext]) {
        url = @"QWSH/web/guide/html/earnIntegral/sense.html";
    }
    // 引导下载APP
    else if ([titleString isEqualToString:kCellTitle_DownAPP])
    {
        url = @"QWSH/web/guide/html/earnIntegral/guide.html";
    }
    // 订单处理
    else if ([titleString isEqualToString:kCellTitle_HandeleOrder])
    {
        url = @"QWSH/web/guide/html/earnIntegral/orderDeal.html";
    }
    // 分享
    else if ([titleString isEqualToString:kCellTitle_Share])
    {
        url = @"QWSH/web/guide/html/earnIntegral/share.html";
    }
    // 分享转化订单
    else if ([titleString isEqualToString:kCellTitle_ShareTransformOrder])
    {
//        url = @"QWSH/web/guide/html/earnIntegral/transform.html";
        // 3.2.1更新
        url = @"QWSH/web/guide/html/earnIntegral/fxdd.html";
    }
    // 线下引导下单
    else if ([titleString isEqualToString:kCellTitle_ShowCreateOrder])
    {
//        url = @"QWSH/web/guide/html/earnIntegral/transform.html?guide=order";
        // 3.2.1更新
        url = @"QWSH/web/guide/html/earnIntegral/xdsjf.html";
    }
    // 签到
    else if ([titleString isEqualToString:kCellTitle_Sign])
    {
        url = @"QWSH/web/guide/html/earnIntegral/sign.html";
    }
    // 培训内容
    else if ([titleString isEqualToString:kCellTitle_TrainContext])
    {
        url = @"QWSH/web/guide/html/earnIntegral/train.html";
    }
    
    if (StrIsEmpty(url)) {
        return;
    }
    
    WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
    vcWebDirect.hidesBottomBarWhenPushed = YES;
    WebDirectLocalModel* webModel = [WebDirectLocalModel new];
    webModel.url = [NSString stringWithFormat:@"%@%@", H5_BASE_URL,url];
    [vcWebDirect setWVWithLocalModel:webModel];
    [self.navigationController pushViewController:vcWebDirect animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// 积分明细
- (IBAction)creditDetailBarBtnAction:(id)sender {
    
    [QWGLOBALMANAGER statisticsEventId:@"我的积分_积分明细" withLable:@"我的-积分" withParams:nil];
    
    WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
    vcWebDirect.hidesBottomBarWhenPushed = YES;
    WebDirectLocalModel* webModel = [WebDirectLocalModel new];
    webModel.title = @"积分明细";
    webModel.url = [NSString stringWithFormat:@"%@QWSH/web/integralDetail/html/integralDetail.html", H5_BASE_URL];
    [vcWebDirect setWVWithLocalModel:webModel];
    [self.navigationController pushViewController:vcWebDirect animated:YES];
}

// 积分商城
- (IBAction)creditStoreBtnAction:(id)sender {
    // 积分商城
    [QWGLOBALMANAGER statisticsEventId:@"s_wd_jj" withLable:@"我的-积分" withParams:nil];
    WebDirectViewController *vcWebMedicine = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
    WebDirectLocalModel *modelLocal = [WebDirectLocalModel new];
    modelLocal.typeLocalWeb = WebLocalTypeIntegraph;
    [vcWebMedicine setWVWithLocalModel:modelLocal];
    [self.navigationController pushViewController:vcWebMedicine animated:YES];
}

#pragma mark - UIScrollViewDelegate 根据拖拉表格视图放大积分标签的视图
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        CGFloat scale = (self.tableHearderView.frame.size.height - scrollView.contentOffset.y)/self.tableHearderView.frame.size.height;
        scale = scale > 1.5 ? 1.5 : scale;
        self.creditTextContainerView.transform = CGAffineTransformMakeScale(scale, scale);
    }
}

@end
