//
//  UserCenterViewController.m
//  APP
//  接口
//  获取客服热线  ：   h5/system/getServiceTel
//  店员信息      :   h5/mbr/branch/queryEmployees
//  Created by qwfy0006 on 15/3/17.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "UserCenterViewController.h"
#import "JGPharmacistViewController.h"
#import "SetMainViewController.h"
#import "InstitutionInfoViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "SJAvatarBrowser.h"
#import "RatingView.h"
#import "JGinfoAndQuickViewController.h"
#import "UserCenterCell.h"
#import "Store.h"
#import "StoreModel.h"
//#import "MapViewController.h"
//#import "AppraiseModel.h"
#import "QWMessage.h"
#import "NSString+WPAttributedMarkup.h"
#import "EditInformationViewController.h"
#import "EmployInfoViewController.h"
#import "OrganAuthTotalViewController.h"
#import "OrganAuthCommitOkViewController.h"
//#import "MyorderViewController.h"
#import "EvaluationViewController.h"
#import "MyActivityViewController.h"
#import "InteractiveStatisticViewController.h"
#import "OrganAuthTotalViewController.h"
#import "WebDirectViewController.h"
#import "RefCode.h"
#import "MyLevelInfoViewController.h"
#import "StoreUserCenterCell.h"     // 新的cell
#import "FeedbackViewController.h"  // 意见反馈页面
#import "MyPerformanceOrderListViewController.h"
#import "MyLevelInfoViewController.h"
#import "MAUILabel.h"
#import "MyQRCodeInfoViewController.h"      // 我的二维码
#import "StoreCreditViewController.h"       // 我的积分
#import "MyReceiveAddressViewController.h"
#import "VerifyRecordListViewController.h"  // 验证记录
#import "Mbr.h"
#import "EmployeeModel.h"
#import "QWProgressHUD.h"
NSString *const kCellTitleCredit              = @"积分";
NSString *const kCellTitleCreditStore         = @"积分商城";
NSString *const kCellTitleMyAchievementsOrder = @"我的分销订单";
NSString *const kCellTitleMyQRCodeInfo        = @"我的二维码";
NSString *const kCellTitleMyReceiveAddress    = @"我的收货地址";
NSString *const kCellTitleAuthenticationRecords = @"验证记录";
NSString *const kCellTitleSotreHotLine        = @"商家服务热线";
NSString *const kCellTitleFeedBack            = @"意见反馈";
NSString *const kCellTitleSettings            = @"设置";
NSString *const kCellTitleNewerGuide          = @"新手引导";


@interface UserCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) NSMutableArray *titleArray;
@property (strong, nonatomic) NSMutableArray *imageArray;
@property (strong, nonatomic) NSMutableArray *telPhoneArray;


// 列表的headerView
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *topBackGroundView;
@property (strong, nonatomic) IBOutlet UIView *headImageBackView;
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;           // 用户昵称标签
@property (strong, nonatomic) IBOutlet UILabel *subTitleLabel;        // 手机号标签
@property (strong, nonatomic) IBOutlet MAUILabel *positionLabel;
@property (strong, nonatomic) IBOutlet UIButton *gotoLevelBtn;
@property (strong, nonatomic) IBOutlet UIButton *signBtn;               // 签到按钮
@property (weak, nonatomic) IBOutlet UILabel *statusTagLabel;



// 未认证的列表的headerView
@property (strong, nonatomic) IBOutlet UIView *authHeaderView;
@property (strong, nonatomic) IBOutlet UILabel *accountLabel;
@property (strong, nonatomic) IBOutlet UIButton *authButton;

@property (strong ,nonatomic) IBOutlet UITableView       *tableView;
@property (nonatomic ,strong) StoreGroupDetail  *groupModel;
@property (nonatomic, strong) EmployeeInfoModel * employeeInfoModel;

// 进入个人中心
- (IBAction)gotoInfoCenterVC:(id)sender;
// 点击销售新手
- (IBAction)gotoLevelVCAction:(id)sender;
// 签到
- (IBAction)signBtnAction:(id)sender;

// 立即认证
- (IBAction)goToAuthAction:(id)sender;

@end

@implementation UserCenterViewController

- (id)init{
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"我的";
    
    // 认证按钮
    self.authButton.layer.cornerRadius = 4.0;
    self.authButton.layer.masksToBounds = YES;
    self.authButton.backgroundColor = RGBHex(qwColor2);
    
    // 设置tableView
    self.tableView.backgroundColor = RGBHex(0xecf0f1);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.bounces = NO;
    [self.tableView reloadData];
    
    // 我的等级入口点击手势
    UITapGestureRecognizer* tapGotoMyLevelVCGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoMyLevelVC:)];
    self.positionLabel.userInteractionEnabled = YES;
    [self.positionLabel addGestureRecognizer:tapGotoMyLevelVCGesture];
    
    // 取缓存
    self.employeeInfoModel =[QWUserDefault getObjectBy:[NSString stringWithFormat:@"EmployeeInfo%@",QWGLOBALMANAGER.configure.passportId]];
    if (!_employeeInfoModel) {
        self.titleLabel.text = nil;
        self.subTitleLabel.text = nil;
        self.positionLabel.hidden = YES;
        self.gotoLevelBtn.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 左侧返回按钮隐藏
    self.navigationItem.leftBarButtonItem=nil;
    
    // 设置不同情况下的 显示的list
    [self configureArray];
    
    // 设置是否认证的 列表的headerView
    [self configureAuthView];
    
    [self.tableView reloadData];

    if (self.telPhoneArray.count == 0) {
        [self loadTelPhoneData];
    }
}

- (void)UIGlobal
{
    self.titleLabel.font = [UIFont systemFontOfSize:kFontS2];
    self.titleLabel.textColor = RGBHex(qwColor4);
    
    self.subTitleLabel.font = [UIFont systemFontOfSize:kFontS5];
    self.subTitleLabel.textColor = RGBHex(qwColor4);
    // 销售大师label进行UI调整
    self.positionLabel.font = [UIFont systemFontOfSize:kFontS6];
    self.positionLabel.textColor = RGBHex(qwColor4);
    self.positionLabel.layer.masksToBounds = YES;
    [self.positionLabel setEdgeInsets:UIEdgeInsetsMake(2, 6, 2, 6)];
    self.positionLabel.layer.cornerRadius = (CGRectGetHeight(self.positionLabel.frame) + 4)/2;
}

#pragma mark ---- 获取客服热线
- (NSMutableArray *)telPhoneArray
{
    if (!_telPhoneArray) {
        _telPhoneArray = [NSMutableArray array];
    }
    return _telPhoneArray;
}

- (void)loadTelPhoneData
{
    __weak __typeof(self)weakSelf = self;
    [Mbr getServiceTelSuccess:^(ServiceTelModel *serviceTelModel) {
        [weakSelf.telPhoneArray removeAllObjects];
        [weakSelf.telPhoneArray addObjectsFromArray:serviceTelModel.list];
        [weakSelf.tableView reloadData];
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ---- 设置不同情况下的 显示的list ----

- (void)configureArray
{
    if (OrganAuthPass) {
        
        // 已认证
        
        if (QWGLOBALMANAGER.configure.storeType == 3)
        {
            //开通微商
            self.titleArray = [[NSMutableArray alloc]initWithObjects:
                               @[kCellTitleCredit],
                               @[kCellTitleCreditStore,kCellTitleMyAchievementsOrder,kCellTitleMyQRCodeInfo,kCellTitleMyReceiveAddress],
                               @[kCellTitleAuthenticationRecords],
                               @[kCellTitleNewerGuide,kCellTitleSotreHotLine,kCellTitleFeedBack,kCellTitleSettings],nil];
            self.imageArray = [[NSMutableArray alloc]initWithObjects:
                               @[@"my_bg_one"],
                               @[@"my_bg_two",@"my_bg_three",@"my_bg_four",@"my_bg_five"],
                               @[@"ic_my"],
                               @[@"my_bg_six_xinshou",@"my_bg_six",@"my_bg_seven",@"my_bg_eight"],nil];
        }else
        {
            //未开通微商
            self.titleArray = [[NSMutableArray alloc]initWithObjects:
                                        @[kCellTitleCredit],
                                        @[kCellTitleCreditStore,kCellTitleMyQRCodeInfo,kCellTitleMyReceiveAddress],
                                        @[kCellTitleAuthenticationRecords],
                                        @[kCellTitleNewerGuide,kCellTitleSotreHotLine,kCellTitleFeedBack,kCellTitleSettings],nil];
            self.imageArray = [[NSMutableArray alloc]initWithObjects:
                                        @[@"my_bg_one"],
                                        @[@"my_bg_two",@"my_bg_four",@"my_bg_five"],
                                        @[@"ic_my"],
                                        @[@"my_bg_six_xinshou",@"my_bg_six",@"my_bg_seven",@"my_bg_eight"],nil];
        }

        
    }else
    {
        // 未认证
        
        self.titleArray = [[NSMutableArray alloc]initWithObjects:
                           @[kCellTitleSotreHotLine,kCellTitleFeedBack,kCellTitleSettings],nil];
        self.imageArray = [[NSMutableArray alloc]initWithObjects:
                           @[@"my_bg_six",@"my_bg_seven",@"my_bg_eight"],nil];
    }

}

#pragma mark ---- 设置是否认证的 列表的headerView ----

- (void)configureAuthView
{
    // 判断机构是否经过认证
    
    if (OrganAuthPass)
    {
        // 已认证
        self.topView.backgroundColor = RGBHex(qwColor1);
        self.topBackGroundView.backgroundColor = RGBHex(qwColor1);
        self.tableView.tableHeaderView = self.topView;
        
        // 查询机构的详细信息
        [self getJGInfo];
        [self.tableView reloadData];
        
    }else
    {
        // 未认证
        self.authButton.layer.cornerRadius = 4.0;
        self.authButton.layer.masksToBounds = YES;
        
        if ([QWGLOBALMANAGER.configure.approveStatus integerValue] == 1) {
            // 1, 待审核  资料已提交页面
            [self.authButton setTitle:@"认证审核中" forState:UIControlStateNormal];
        }else if ([QWGLOBALMANAGER.configure.approveStatus integerValue] == 2){
            // 2, 审核不通过  带入老数据的认证流程
            [self.authButton setTitle:@"立即认证" forState:UIControlStateNormal];
        }else if ([QWGLOBALMANAGER.configure.approveStatus integerValue] == 4){
            // 4, 未提交审核  认证流程
            [self.authButton setTitle:@"立即认证" forState:UIControlStateNormal];
        }else{
            // 3, 审核通过    功能正常
        }
        
        self.tableView.tableHeaderView = self.authHeaderView;
        self.accountLabel.text = [NSString stringWithFormat:@"您的账号为：%@", QWGLOBALMANAGER.configure.userName];
    }
}

#pragma mark ---- 查询机构的详细信息 ----

- (void)getJGInfo
{
    if(!QWGLOBALMANAGER.loginStatus)
        return;
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) { // 取缓存数据
        self.employeeInfoModel =[QWUserDefault getObjectBy:[NSString stringWithFormat:@"EmployeeInfo%@",QWGLOBALMANAGER.configure.passportId]];
    }
    else{ // 网络请求数据
        
//        HttpClientMgr.progressEnabled = NO;
//        [Store GetBranhGroupDetailWithGroupId:QWGLOBALMANAGER.configure.groupId success:^(id DFModel) {
//            self.groupModel =  [StoreGroupDetail parse:DFModel];
//            if ([self.groupModel.apiStatus integerValue] == 0) {
//                [self setUpTopHeaderUI];
//                [self.tableView reloadData];
//                [QWUserDefault setObject:self.groupModel key:[NSString stringWithFormat:@"storeInfo%@",QWGLOBALMANAGER.configure.groupId]];
//            }
//        } failure:^(HttpException *e) {
//        }];
        if (!StrIsEmpty(QWGLOBALMANAGER.configure.userToken)) {
            __weak __typeof(self)weakSelf = self;
            HttpClientMgr.progressEnabled = NO;
            [Store queryEmployees:@{@"token":QWGLOBALMANAGER.configure.userToken} success:^(EmployeeInfoModel *employeeInfoModel) {
                weakSelf.employeeInfoModel = employeeInfoModel;
                [QWUserDefault setObject:weakSelf.employeeInfoModel key:[NSString stringWithFormat:@"EmployeeInfo%@",QWGLOBALMANAGER.configure.passportId]];
            } fail:^(HttpException *e) {
                ;
            }];
        }
    }
}

- (void)setEmployeeInfoModel:(EmployeeInfoModel *)employeeInfoModel
{
    _employeeInfoModel = employeeInfoModel;
    [self setUpTopHeaderUI];
}

#pragma mark ---- 设置 tableView 的 headerView ----

- (void)setUpTopHeaderUI
{
    if (AUTHORITY_ROOT) {
        self.statusTagLabel.text = @"店长";
    }else{
        self.statusTagLabel.text = @"店员";
    }
    
    self.titleLabel.text = self.employeeInfoModel.name;
    self.subTitleLabel.text = self.employeeInfoModel.mobile;
    self.signBtn.enabled = !self.employeeInfoModel.sign;
    self.headImageBackView.layer.masksToBounds = YES;
    self.headImageBackView.layer.cornerRadius = CGRectGetHeight(self.headImageBackView.frame)/2;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = CGRectGetHeight(self.headImageView.frame)/2;
    
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleClick:)];
//    [self.topView addGestureRecognizer:tap1];
    
//    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageLogoClick:)];
//    [self.headImageView addGestureRecognizer:tap2];

    // 设置机构头像
    [self.headImageView setImageWithURL:[NSURL URLWithString:self.employeeInfoModel.headImg] placeholderImage:[UIImage imageNamed:@"expert_ic_people"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
    }];
    
    [self setUserLevel:self.employeeInfoModel.lvl];
    
    self.tableView.tableHeaderView = self.topView;
    [self.tableView reloadData];
}

- (void)setUserLevel:(NSInteger)level
{
    self.positionLabel.hidden = NO;
    self.gotoLevelBtn.hidden = NO;
    switch (level) {
        case 0:
        {
            self.positionLabel.text = @"销售新手";
            self.positionLabel.textColor = RGBHex(qwColor1);
            self.positionLabel.backgroundColor = RGBHex(qwColor4);
        }
            break;
        case 1:
        {
            self.positionLabel.text = @"销售能手";
            self.positionLabel.textColor = RGBHex(qwColor4);
            self.positionLabel.backgroundColor = RGBHex(qwColor13);
        }
            break;
        case 2:
        {
            self.positionLabel.text = @"销售骨干";
            self.positionLabel.textColor = RGBHex(qwColor4);
            self.positionLabel.backgroundColor = RGBHex(qwColor15);
        }
            break;
        case 3:
        {
            self.positionLabel.text = @"销售达人";
            self.positionLabel.textColor = RGBHex(qwColor4);
            self.positionLabel.backgroundColor = RGBHex(qwColor2);
        }
            break;
        case 4:
        {
            self.positionLabel.text = @"销售专家";
            self.positionLabel.textColor = RGBHex(qwColor4);
            self.positionLabel.backgroundColor = RGBHex(qwColor12);
        }
            break;
        case 5:
        {
            self.positionLabel.text = @"销售大师";
            self.positionLabel.textColor = RGBHex(qwColor4);
            self.positionLabel.backgroundColor = RGBHex(qwColor3);
        }
            break;
        default:
            self.positionLabel.hidden = YES;
            self.gotoLevelBtn.hidden = YES;
            break;
    }
}

#pragma mark ---- 点击headerview  进入药店详情 ----

- (void)titleClick:(id)sender
{
    if (!self.employeeInfoModel && QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
        return;
    }
    EditInformationViewController *vc = [[UIStoryboard storyboardWithName:@"EditInformation" bundle:nil] instantiateViewControllerWithIdentifier:@"EditInformationViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---- 点击头像查看大图 ----

- (void)imageLogoClick:(UITapGestureRecognizer *)sender
{
    [SJAvatarBrowser showImage:(UIImageView *)sender.view];
}

#pragma mark ---- 列表代理 ----

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  [StoreUserCenterCell getCellHeight:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return ((NSArray *)self.titleArray[section]).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_W, 10)];
    view.backgroundColor = RGBHex(0xecf0f1);
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifierNomal = @"StoreUserCenterCell";
    static NSString* cellIdentifierCredit = @"StoreUserCenterCreditCell";
    static NSString* cellIdentifierHotLine = @"StoreUserCenterHotLineCell";
    NSString* titleString = self.titleArray[indexPath.section][indexPath.row];
    
    if ([titleString isEqualToString:kCellTitleCredit]) {
        StoreUserCenterCreditCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierCredit];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"StoreUserCenterCell" owner:self options:nil][1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.titleLabel.text = titleString;
        cell.icon.image = [UIImage imageNamed:self.imageArray[indexPath.section][indexPath.row]];
        cell.budge.hidden = YES;
        cell.creditLabel.text = StrFromInt(self.employeeInfoModel.score);
        return cell;
    }
    else if ([titleString isEqualToString:kCellTitleSotreHotLine])
    {
        StoreUserCenterHotLineCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierHotLine];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"StoreUserCenterCell" owner:self options:nil][2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.titleLabel.text = titleString;
        cell.icon.image = [UIImage imageNamed:self.imageArray[indexPath.section][indexPath.row]];
        cell.budge.hidden = YES;
        if (self.telPhoneArray.count > 0) {
            cell.hotLineLabel.text = self.telPhoneArray[0];
        }
        else
        {
            cell.hotLineLabel.text = nil;
        }
        return cell;

    }
    else
    {
        StoreUserCenterCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierNomal];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"StoreUserCenterCell" owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.titleLabel.text = titleString;
        cell.icon.image = [UIImage imageNamed:self.imageArray[indexPath.section][indexPath.row]];
        cell.budge.hidden = YES;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreUserCenterCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    DebugLog(@"cell titlte Label : %@", cell.titleLabel.text);
    NSString* titleString = cell.titleLabel.text;
    // 商家热线
    if ([titleString isEqualToString:kCellTitleSotreHotLine]) {
        [QWGLOBALMANAGER statisticsEventId:@"s_wd_fwrx" withLable:@"我的-商务服务热线" withParams:nil];
        if (self.telPhoneArray.count > 0) {
            UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
            for (NSString* phoneNumber in self.telPhoneArray) {
                [actionSheet addButtonWithTitle:StrFromObj(phoneNumber)];
            }
            [actionSheet showInView:self.view];
        }
    }
    // 意见反馈
    else if ([titleString isEqualToString:kCellTitleFeedBack])
    {
        [QWGLOBALMANAGER statisticsEventId:@"s_wd_yjfk" withLable:@"我的-意见反馈" withParams:nil];
        FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] init];
        feedbackVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:feedbackVC animated:YES];
    }
    // 设置
    else if ([titleString isEqualToString:kCellTitleSettings])
    {
        // 设置
        [QWGLOBALMANAGER statisticsEventId:@"s_wd_sz" withLable:@"我的-设置" withParams:nil];
        SetMainViewController *setVC = [[UIStoryboard storyboardWithName:@"SetMain" bundle:nil] instantiateViewControllerWithIdentifier:@"SetMainViewController"];
        setVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:setVC animated:YES];
    }
    else if ([titleString isEqualToString:kCellTitleMyAchievementsOrder])
    {
        // 我的业绩订单
        [QWGLOBALMANAGER statisticsEventId:@"s_wd_wdyj" withLable:@"我的-我的业绩订单" withParams:nil];
        [self gotoMyAchievementsOrderVC];
    }
    else if ([titleString isEqualToString:kCellTitleMyReceiveAddress])
    {
        // 我的收货地址
        [QWGLOBALMANAGER statisticsEventId:@"s_wd_shdz" withLable:@"我的-我的收货地址" withParams:nil];
        [self gotoMyReceiveAddressVC];
    }
    else if ([titleString isEqualToString:kCellTitleCredit])
    {
        // 我的积分
        [QWGLOBALMANAGER statisticsEventId:@"s_wd_jj" withLable:@"我的-积分" withParams:nil];
        StoreCreditViewController* storeCreditVC = [[UIStoryboard storyboardWithName:@"StoreCreditViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"StoreCreditViewController"];
        storeCreditVC.score = self.employeeInfoModel.score;
        storeCreditVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:storeCreditVC animated:YES];
    }
    else if ([titleString isEqualToString:kCellTitleCreditStore])
    {
        // 积分商城
        [QWGLOBALMANAGER statisticsEventId:@"s_wd_jj" withLable:@"我的-积分" withParams:nil];
        
        [QWGLOBALMANAGER statisticsEventId:@"我的页面_积分商城" withLable:@"我的页面-积分商城" withParams:nil];
        WebDirectViewController *vcWebMedicine = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
        WebDirectLocalModel *modelLocal = [WebDirectLocalModel new];
        modelLocal.typeLocalWeb = WebLocalTypeIntegraph;
        modelLocal.typeShare = LocalShareTypeUnknow;
        [vcWebMedicine setWVWithLocalModel:modelLocal];
        [self.navigationController pushViewController:vcWebMedicine animated:YES];
    }
    else if ([titleString isEqualToString:kCellTitleMyQRCodeInfo])
    {
        // 我的二维码
        [QWGLOBALMANAGER statisticsEventId:@"s_wd_ewm" withLable:@"我的-我的二维码" withParams:nil];
        MyQRCodeInfoViewController* qrCodeInfoVC = [[MyQRCodeInfoViewController alloc] init];
        qrCodeInfoVC.hidesBottomBarWhenPushed = YES;
        qrCodeInfoVC.phoneNumber = self.employeeInfoModel.mobile;
        qrCodeInfoVC.headImageURL = self.employeeInfoModel.headImg;
        qrCodeInfoVC.nickName = self.employeeInfoModel.name;
        [self.navigationController pushViewController:qrCodeInfoVC animated:YES];
    }
    else if ([titleString isEqualToString:kCellTitleNewerGuide])
    {
        [QWGLOBALMANAGER statisticsEventId:@"我的_新手引导" withLable:@"我的" withParams:nil];
        
        // 新手引导
        WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
        vcWebDirect.hidesBottomBarWhenPushed = YES;
        WebDirectLocalModel* webModel = [WebDirectLocalModel new];
        webModel.title = @"选择身份";
        webModel.url = [NSString stringWithFormat:@"%@QWSH/web/guide/html/member.html", H5_BASE_URL];
        [vcWebDirect setWVWithLocalModel:webModel];
        [self.navigationController pushViewController:vcWebDirect animated:YES];
    }
    else if ([titleString isEqualToString:kCellTitleAuthenticationRecords])
    {
        // 验证记录
        VerifyRecordListViewController *vc = [[UIStoryboard storyboardWithName:@"VerifyRecord" bundle:nil] instantiateViewControllerWithIdentifier:@"VerifyRecordListViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

// 进入我的收获地址页面  小朱
- (void)gotoMyReceiveAddressVC
{
    MyReceiveAddressViewController *vc = [[MyReceiveAddressViewController alloc]initWithNibName:@"MyReceiveAddressViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

// 进入我的业绩订单页面  小朱
- (void)gotoMyAchievementsOrderVC
{
    MyPerformanceOrderListViewController *vc = [[MyPerformanceOrderListViewController alloc]initWithNibName:@"MyPerformanceOrderListViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

// 进入我的等级页面 小朱
- (void)gotoMyLevelVC:(id)sender
{
    MyLevelInfoViewController *vc = [[MyLevelInfoViewController alloc]initWithNibName:@"MyLevelInfoViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)actionShare
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showError:@"系统异常，请稍后再试"];
        return;
    } else {
        [self getRefURLWithBlock:^(NSString *strRefURL) {
            ShareContentModel *modelShare = [ShareContentModel new];
            modelShare.title = self.groupModel.shortName.length == 0 ? self.groupModel.name : self.groupModel.shortName;
            modelShare.content = @"多种优惠商品等着你来选择";
            modelShare.shareLink = strRefURL;
            modelShare.typeShare = ShareTypeMerchant;
            modelShare.imgURL = self.groupModel.url;
            [self popUpShareView:modelShare];
        }];
    }
}

#pragma mark ---- 商家品牌宣传预览 ----

- (void)previewTheBranchOfLogo
{
    // 本地跳转H5页面
    WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
    
    // 本地跳转H5model的参数
    WebDirectLocalModel *modelLocal = [[WebDirectLocalModel alloc] init];
    modelLocal.typeLocalWeb = WebLocalTypeBranchLogoPreview;
    modelLocal.title = @"品牌宣传";
    [vcWebDirect setWVWithLocalModel:modelLocal];
    
    vcWebDirect.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcWebDirect animated:YES];
}

#pragma mark ---- 获取refURL ----
- (void)getRefURLWithBlock:(void (^)(NSString *strRefURL))getRefIDBlock
{
    RefCodeModelR *modelR = [RefCodeModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.objId = QWGLOBALMANAGER.configure.groupId;
    modelR.objType = @"3";
    modelR.channel = @"1";
    [RefCode queryRefCode:modelR success:^(RefCodeModel *responseModel) {
        if (getRefIDBlock) {
            getRefIDBlock(responseModel.url);
        }
    } failure:^(HttpException *e) {
        [self showError:@"网络异常，请稍后重试"];
    }];
}

#pragma mark ---- 立即验证 ----

- (IBAction)goToAuthAction:(id)sender
{
    // 未认证
    /*
     1, 待审核  资料已提交页面
     2, 审核不通过  带入老数据的认证流程
     3, 审核通过    功能正常
     4, 未提交审核  认证流程
     */
    
    if ([QWGLOBALMANAGER.configure.approveStatus integerValue] == 4 || [QWGLOBALMANAGER.configure.approveStatus integerValue] == 2)
    {
        OrganAuthTotalViewController *vc = [[UIStoryboard storyboardWithName:@"OrganAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"OrganAuthTotalViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([QWGLOBALMANAGER.configure.approveStatus integerValue] == 1)
    {
        OrganAuthCommitOkViewController *vc = [[UIStoryboard storyboardWithName:@"OrganAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"OrganAuthCommitOkViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark ---- 接收通知 ----

- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    if(NotifiOrganAuthPass == type)
    {
        // 机构认证通过的通知
        [self configureAuthView];
        [self configureArray];
        [self.tableView reloadData];
        
    }else if (NotifiOrganAuthFailure == type)
    {
        // 机构认证失败的通知
        [self configureAuthView];
        [self configureArray];
        [self.tableView reloadData];
    }
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0) {
        if (self.telPhoneArray.count >= buttonIndex) {
            //拨打电话
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.telPhoneArray[buttonIndex - 1]]]];
        }
    }
}

#pragma mark - 签到按钮行为
- (IBAction)signBtnAction:(id)sender {
    [QWGLOBALMANAGER statisticsEventId:@"s_wd_qd" withLable:@"我的-签到" withParams:nil];
    if (QWGLOBALMANAGER.configure.userToken) {
        __weak __typeof(self) weakSelf = self;
        [Store employeeSign:@{@"token":QWGLOBALMANAGER.configure.userToken} success:^(StoreUserSignModel *apiModel) {
            if ([apiModel.apiStatus integerValue] == 0) {
                if (apiModel.rewardScore > 0) {
                    [QWProgressHUD showSuccessWithStatus:@"签到成功" hintString:[NSString stringWithFormat:@"+%ld", (long)apiModel.rewardScore] duration:2.0];
                }
//                [SVProgressHUD showSuccessWithStatus:@"签到成功" duration:2.0f];
                weakSelf.signBtn.enabled = NO;
                weakSelf.employeeInfoModel.sign = YES;
                [weakSelf getJGInfo];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:apiModel.apiMessage duration:DURATION_LONG];
            }
        } fail:^(HttpException *e) {
            ;
        }];
    }
}
- (IBAction)gotoLevelVCAction:(id)sender {
    [self gotoMyLevelVC:nil];
}
// 由于label太小，加一个放大的透明按钮辅助增大热点范围
- (IBAction)gotoInfoCenterVC:(id)sender {
    [self titleClick:nil];
}
@end