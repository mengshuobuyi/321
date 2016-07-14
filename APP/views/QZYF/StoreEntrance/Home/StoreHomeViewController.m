//
//  StoreHomeViewController.m
//  wenYao-store
//  商户端的首页
//  Created by Cao jing on 16/5/4.
//  Copyright © 2016年 carret. All rights reserved.
//
// @"h5/configInfo/queryBanner"   首页banner
// @"h5/bmmall/queryNotice"       公告
#import "StoreHomeViewController.h"
#import "TrainingListViewController.h"
#import "XLCycleScrollView.h"
#import "UIImageView+WebCache.h"
#import "TitleTableCell.h"
#import "ContentTableCell.h"
#import "NoticeTableCell.h"
#import "ManyCollectionViewCell.h"
#import "ScoreRankViewController.h"
#import "StoreInfomationViewController.h"
#import "InputCodeViewController.h"
#import "MemeberRootListViewController.h"
#import "CampAsignViewController.h"
#import "IMApi.h"
#import "Store.h"
#import "BusinessSenseViewController.h"
#import "OrganAuthTotalViewController.h"
#import "OrganAuthCommitOkViewController.h"
#import "InfoNotifiViewController.h"
#import "HomePageViewController.h"
#import "MsgBoxViewController.h"
#import "WenyaoActivityViewController.h"
#import "WebDirectViewController.h"
#import "ClientMemberViewController.h"
#import "AllScanReaderViewController.h"
#import "QYPhotoAlbum.h"
#import "NoticeCustomView.h"
#import "AppDelegate.h"
#import "NoticeDetailViewController.h"


#define  BANNERhEIGHT  85.0f*kAutoScale

@interface StoreHomeViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,XLCycleScrollViewDatasource,XLCycleScrollViewDelegate>
{
    
    UIImageView *redView;
    
    NSMutableArray              *BannerArray;
    NSMutableArray              *FactoryArray;
    NSMutableArray              *sectionDataStr;

    XLCycleScrollView           *cycScrollBanner;       //Banner
}
// 消息盒子的未读小红点
@property (strong, nonatomic) UIImageView *rightRedDot;
@property (nonatomic, assign) NSInteger intOrderNum;
// 接通知 1数字 0红点 －1无
@property (assign, nonatomic) int passNumber;
// 扫码，验证判断两证是否齐全
@property (strong, nonatomic) BaseAPIModel *isScanModel;
@property (assign, nonatomic) BOOL isUP;
@property (nonatomic, assign) dispatch_once_t onceTokenIns;

@end

@implementation StoreHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.homeTableView.backgroundColor = RGBHex(qwColor11);
    [self setButtonUI];
    self.activityArray=[NSMutableArray array];
    BannerArray=[NSMutableArray array];
    FactoryArray=[NSMutableArray array];
    //有通知，所以在viewdid里面，方便及时更新
    [self configureArray];
    //初始化一次，通过通知控制小红点
    [self setUpRightItem];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isUP=YES;
    // 首页的 数字 与 红点 变化通知
    [QWGLOBALMANAGER refreshAllHint];
    //全局拉消息，更新红点
    //    [QWGLOBALMANAGER getAllConsult];
    //判断两证是否齐全
    [self checkCertVaildate];
    // 判断机构是否认证
    [self configureAuthView];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [cycScrollBanner stopAutoScroll];
    self.isUP=NO;
}


#pragma mark ---- 初始化数组 ----

- (void)configureArray
{
    
    if(OrganAuthPass){//已认证
        if (QWGLOBALMANAGER.configure.storeType == 3){
            if(AUTHORITY_ROOT){
                sectionDataStr = [[NSMutableArray alloc] initWithObjects:
                                  [NSArray arrayWithObjects:@"培训", @"1", @"icon_training",nil],
                                  [NSArray arrayWithObjects:@"生意经", @"2", @"icon_business", nil],
                                  [NSArray arrayWithObjects:@"积分商城", @"3", @"icon_integralmall", nil],
                                  [NSArray arrayWithObjects:@"本店信息", @"4", @"icon_information", nil],
                                  [NSArray arrayWithObjects:@"营销活动", @"5", @"icon_activity", nil],
                                  [NSArray arrayWithObjects:@"会员营销", @"6", @"icon_members", nil],
                                  nil];
                
            }else{
                sectionDataStr = [[NSMutableArray alloc] initWithObjects:
                                  [NSArray arrayWithObjects:@"培训", @"1", @"icon_training",nil],
                                  [NSArray arrayWithObjects:@"生意经", @"2", @"icon_business", nil],
                                  [NSArray arrayWithObjects:@"积分商城", @"3", @"icon_integralmall", nil],
                                  [NSArray arrayWithObjects:@"本店信息", @"4", @"icon_information", nil],
                                  [NSArray arrayWithObjects:@"营销活动", @"5", @"icon_activity", nil],
                                  [NSArray arrayWithObjects:@"会员", @"6", @"icon_members", nil],
                                  nil];
                
            }
        }else{//非微商
            sectionDataStr = [[NSMutableArray alloc] initWithObjects:
                              [NSArray arrayWithObjects:@"培训", @"1", @"icon_training",nil],
                              [NSArray arrayWithObjects:@"生意经", @"2", @"icon_business", nil],
                              [NSArray arrayWithObjects:@"积分商城", @"3", @"icon_integralmall", nil],
                              [NSArray arrayWithObjects:@"本店信息", @"4", @"icon_information", nil],
                              [NSArray arrayWithObjects:@"营销活动", @"5", @"icon_activity", nil],
                              [NSArray arrayWithObjects:@"会员", @"8", @"icon_members", nil],
                              nil];
        }
        
    }else{//未认证
        sectionDataStr = [[NSMutableArray alloc] initWithObjects:
                          [NSArray arrayWithObjects:@"培训", @"7", @"icon_training",nil],
                          [NSArray arrayWithObjects:@"生意经", @"7", @"icon_business", nil],
                          [NSArray arrayWithObjects:@"积分商城", @"7", @"icon_integralmall", nil],
                          [NSArray arrayWithObjects:@"本店信息", @"7", @"icon_information", nil],
                          [NSArray arrayWithObjects:@"营销活动", @"7", @"icon_activity", nil],
                          [NSArray arrayWithObjects:@"会员营销", @"7", @"icon_members", nil],
                          nil];
    }
    
    
}



#pragma mark ---- 判断机构是否经过认证 改变列表的 frame ----

- (void)configureAuthView
{
    // 判断机构是否经过认证
    if (OrganAuthPass)
    {// 已认证
        self.navigationItem.title=QWGLOBALMANAGER.configure.shortName;
        if(AUTHORITY_ROOT){
            dispatch_once(&_onceTokenIns, ^{
                [self setUpLeftItem];
            });
        }
       
        [self queryBanner:@"6"];
        [self noticeCont];
        [self activityCont];
    }else
    {// 未认证
        self.navigationItem.title=@"尊敬的商户，您好";
        self.navigationItem.leftBarButtonItems=nil;
        if ([QWGLOBALMANAGER.configure.approveStatus integerValue] == 1) {
            // 1, 待审核  资料已提交页面
            [self.buttonRegister setTitle:@"认证审核中" forState:UIControlStateNormal];
        }else if ([QWGLOBALMANAGER.configure.approveStatus integerValue] == 2){
            // 2, 审核不通过  带入老数据的认证流程
            [self.buttonRegister setTitle:@"立即认证" forState:UIControlStateNormal];
        }else if ([QWGLOBALMANAGER.configure.approveStatus integerValue] == 4){
            // 4, 未提交审核  认证流程
            [self.buttonRegister setTitle:@"立即认证" forState:UIControlStateNormal];
        }
        self.countLabel.text = [NSString stringWithFormat:@"您的账号为：%@",QWGLOBALMANAGER.configure.userName];
        self.homeTableView.tableHeaderView=self.headNoView;
    }
}

#pragma mark ---- 设置rightItem ----

- (void)setUpRightItem
{
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = -15;
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
    bg.backgroundColor = [UIColor clearColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(18, -1, 60, 44);
    [btn setImage:[UIImage imageNamed:@"icon_index_news"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon_index_news"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(pushToQWYS) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightRedDot = [[UIImageView alloc] initWithFrame:CGRectMake(52, 8, 10, 10)];
    [self.rightRedDot setImage:[UIImage imageNamed:@"img_redDot"]];
    self.rightRedDot.hidden=YES;
    
    [bg addSubview:btn];
    [bg addSubview:self.rightRedDot];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:bg];
    self.navigationItem.rightBarButtonItems = @[fixed,item];
}


#pragma mark ---- 设置leftItem ----

- (void)setUpLeftItem
{
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = -15;
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    bg.backgroundColor = [UIColor clearColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 120, 44);
    [btn addTarget:self action:@selector(pushToConSult) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *view=[[UIImageView alloc]initWithFrame:CGRectMake(18, 11, 22, 22)];
    view.image=[UIImage imageNamed:@"navbar_icon_consulting"];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(45, 12, 80, 20)];
    label.text=@"门店咨询";
    label.font=fontSystem(kFontS4);
    label.textColor=RGBHex(qwColor4);
    
    redView=[[UIImageView alloc]initWithFrame:CGRectMake(101, 10,10, 10)];
    redView.image=[UIImage imageNamed:@"img_redDot"];
    redView.hidden=YES;
    
    [btn addSubview:view];
    [btn addSubview:label];
    [btn addSubview:redView];
    [bg addSubview:btn];
    
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:bg];
    self.navigationItem.leftBarButtonItems = @[fixed,item];
}

#pragma mark ---- 进入右上角的咨询 ----
-(void)pushToConSult{
    [QWGLOBALMANAGER statisticsEventId:@"首页_门店咨询" withLable:@"首页" withParams:nil];
    // 咨询
    HomePageViewController *vc = [[HomePageViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---- 进入全维消息 ----

- (void)pushToQWYS
{
    [QWGLOBALMANAGER statisticsEventId:@"s_sy_xx" withLable:@"首页" withParams:nil];
    MsgBoxViewController *demoViewController = [[MsgBoxViewController alloc] init];
    demoViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:demoViewController animated:YES];
}

#pragma mark --样式的修改
-(void)setButtonUI{
    self.scan.layer.cornerRadius = 4.0;
    self.scan.layer.masksToBounds = YES;
    self.inputCode.layer.cornerRadius = 4.0;
    self.inputCode.layer.masksToBounds = YES;
    self.buttonRegister.layer.cornerRadius = 4.0;
    self.buttonRegister.layer.masksToBounds = YES;
}



#pragma mark --立即认证按钮
- (IBAction)registerAuth:(id)sender {
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

#pragma mark --输入验证码
- (IBAction)inputButton:(id)sender {
    if([self.isScanModel.apiStatus integerValue] == 4) {
        [SVProgressHUD showErrorWithStatus:@"证照不全,无法验证！" duration:2.0f];
        return;
    }
    InputCodeViewController *vc=[[InputCodeViewController alloc] initWithNibName:@"InputCodeViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark --扫码的功能
- (IBAction)scanAction:(id)sender {
    
    if([self.isScanModel.apiStatus integerValue] == 4) {
        [SVProgressHUD showErrorWithStatus:@"证照不全,无法验证！" duration:2.0f];
        return;
    }
    
    if (![QYPhotoAlbum checkCameraAuthorizationStatus]) {
        [QWGLOBALMANAGER getCramePrivate];
        return;
    }
    AllScanReaderViewController *vc = [[AllScanReaderViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.scanType=Enum_Scan_Items_Index;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark ---- 扫码／输入验证码，检测两证是否齐全 ----
- (void)checkCertVaildate
{
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"branchId"] = QWGLOBALMANAGER.configure.groupId;
    setting[@"endpoint"] = @"2";
    [IMApi certcheckIMWithParams:setting success:^(BaseAPIModel *model) {
        self.isScanModel = model;
    } failure:^(HttpException *e) {

    }];
}





#pragma mark - 建立BannerUI
- (void)setupBanner{
    
    if(BannerArray.count==0){
        self.bannerView.hidden=YES;
        self.bannerHeight.constant=0;
        [self.headView setFrame:CGRectMake(0, 0, APP_W, 48.0f)];
        self.homeTableView.tableHeaderView=self.headView;
    }else{
        self.bannerView.hidden=NO;
         self.bannerHeight.constant=BANNERhEIGHT;
        [self.headView setFrame:CGRectMake(0, 0, APP_W, BANNERhEIGHT+48.0f)];
        if(cycScrollBanner)
        {
            return;
        }else{
            cycScrollBanner = [[XLCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, APP_W, BANNERhEIGHT)];
        }
        cycScrollBanner.datasource = self;
        cycScrollBanner.delegate = self;
        cycScrollBanner.userInteractionEnabled = YES;
        [self.bannerView addSubview:cycScrollBanner];
        self.homeTableView.tableHeaderView=self.headView;
    }
}




#pragma mark - XLCycScrollViewDelegate
- (NSInteger)numberOfPages{
    
    if(BannerArray.count > 0){
        if(BannerArray.count  > 1) {
            cycScrollBanner.scrollView.scrollEnabled = NO;
            [cycScrollBanner startAutoScroll:5.0f];
        }else{
            cycScrollBanner.scrollView.scrollEnabled = YES;
        }
        return BannerArray.count;
    }else{
        cycScrollBanner.scrollView.scrollEnabled = NO;
        return 0;
    }
    
}


- (UIView *)pageAtIndex:(NSInteger)index{
    
    if(BannerArray.count > 0) {
        BannerInfoModel *model = BannerArray[index];
        
        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, APP_W, BANNERhEIGHT)];
        [view setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"img_banner_nomal"]];
        return view;
    }else{
        return [UIView new];
    }
}

- (void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index{
    if(BannerArray.count == 0){
        return;
    }
    BannerInfoModel *mode=BannerArray[index];
    [self jumpDetail:mode];
}

-(void)jumpDetail:(BannerInfoModel*)model{
    
    [QWGLOBALMANAGER statisticsEventId:@"s_sy_banner" withLable:@"首页" withParams:nil];
    
    //1 外链  9  无连接  10 工业品 11培训 12生意经
    if([model.type intValue]==1){
        WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
        WebDirectLocalModel *modelLocal = [[WebDirectLocalModel alloc] init];
        if (![model.content hasPrefix:@"http"]) {
            model.content = [NSString stringWithFormat:@"%@%@",H5_BASE_URL,model.content];
        }
        modelLocal.url = model.content;
        modelLocal.title = model.name;
        modelLocal.typeLocalWeb = WebLocalTypeOuterLink;
        if([model.flagShare isEqualToString:@"Y"]){
            modelLocal.typeTitle = WebTitleTypeOnlyShare;
        }else{
            modelLocal.typeTitle = WebTitleTypeNone;
        }
        [vcWebDirect setWVWithLocalModel:modelLocal];
        vcWebDirect.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vcWebDirect animated:YES];
    
    }else if ([model.type intValue]==9){
    
    }else if ([model.type intValue]==10){
        WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
        vcWebDirect.hidesBottomBarWhenPushed = YES;
        WebDirectLocalModel* webModel = [WebDirectLocalModel new];
        webModel.url = [NSString stringWithFormat:@"%@QWSH/web/survey/html/surveyDetail.html?&id=%@", H5_BASE_URL,model.content];
        [vcWebDirect setWVWithLocalModel:webModel];
        [self.navigationController pushViewController:vcWebDirect animated:YES];
    }else if ([model.type intValue]==11){
        WebQuestionnaireDetailModel *modelQuestion = [WebQuestionnaireDetailModel new];
        modelQuestion.trainingId = model.content;
        WebDirectLocalModel *modelLocal = [WebDirectLocalModel new];
        modelLocal.modelQuestionnaire = modelQuestion;
        modelLocal.title = model.name;
        modelLocal.typeLocalWeb = WebLocalTypeTrainingDetail;
        WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
        [vcWebDirect setWVWithLocalModel:modelLocal];
        vcWebDirect.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vcWebDirect animated:YES];
    }else if ([model.type intValue]==12){//生意经
        WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
        vcWebDirect.hidesBottomBarWhenPushed = YES;
        WebDirectLocalModel* webModel = [WebDirectLocalModel new];
        webModel.url = [NSString stringWithFormat:@"%@QWSH/web/survey/html/surveyDetail.html?&id=%@", H5_BASE_URL,model.content];
        [vcWebDirect setWVWithLocalModel:webModel];
        [self.navigationController pushViewController:vcWebDirect animated:YES];
    }else if ([model.type intValue]==15){//问卷
        WebQuestionnaireDetailModel *modelQuestion = [WebQuestionnaireDetailModel new];
        modelQuestion.trainingId = model.content;
        WebDirectLocalModel *modelLocal = [WebDirectLocalModel new];
        modelLocal.modelQuestionnaire = modelQuestion;
        modelLocal.title = model.name;
        modelLocal.typeLocalWeb = WebLocalTypeQuestionnaireDetail;
        WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
        [vcWebDirect setWVWithLocalModel:modelLocal];
    }
}



#pragma mark --获取banner的接口和工业品的接口
-(void)queryBanner:(NSString*)type{
    ConfigInfoQueryModelR *modelR = [ConfigInfoQueryModelR new];
        if(!StrIsEmpty(QWGLOBALMANAGER.configure.storeCity)){
         modelR.city = QWGLOBALMANAGER.configure.storeCity;
        }
        modelR.place=type;
        modelR.platform=@"3";//3 商户端app
        modelR.v=@"223";
        //获取首页Banner接口
        [Store configInfoQueryBanner:modelR success:^(BannerInfoListModel *responModel) {
            if(self.isUP){
                NSArray *bannerList = responModel.list;
                if([responModel.apiStatus intValue] == 0){
                    if([type isEqualToString:@"6"]){
                        [BannerArray removeAllObjects];
                        if(bannerList.count > 0){
                            [BannerArray addObjectsFromArray:bannerList];
                        }
                        [cycScrollBanner reloadData];
                        [self queryBanner:@"8"];
                    }else if([type isEqualToString:@"8"]){
                        [FactoryArray removeAllObjects];
                        if(bannerList.count > 0){
                            [FactoryArray addObjectsFromArray:bannerList];
                        }
                        [self setFactoryUI];
                    }
                    
                }
                [self setupBanner];
                [self.homeTableView reloadData];
            }
            
        } failure:^(HttpException *e) {
             if(self.isUP){
                 if([type isEqualToString:@"6"]){
                     [self queryBanner:@"8"];
                 }
                 [self setupBanner];
                 [self setFactoryUI];
                 [self.homeTableView reloadData];
             }
        }];
}

#pragma mark --/点击工业品的链接
-(void)upInside:(UITapGestureRecognizer *)sender{
    [QWGLOBALMANAGER statisticsEventId:@"s_sy_gyp" withLable:@"首页" withParams:nil];
    UIImageView *im=(UIImageView *)sender.view;
    int index = im.tag-100;
    BannerInfoModel *model = FactoryArray[index];
    if(!StrIsEmpty(model.content)){
        if([model.type intValue]==1){
            WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
            WebDirectLocalModel *modelLocal = [[WebDirectLocalModel alloc] init];
            if (![model.content hasPrefix:@"http"]) {
                model.content = [NSString stringWithFormat:@"%@%@",H5_BASE_URL,model.content];
            }
            modelLocal.url = model.content;
            modelLocal.typeLocalWeb = WebLocalTypeOuterLink;
            if([model.flagShare isEqualToString:@"Y"]){
                modelLocal.typeTitle = WebTitleTypeOnlyShare;
            }else{
                modelLocal.typeTitle = WebTitleTypeNone;
            }
            [vcWebDirect setWVWithLocalModel:modelLocal];
            vcWebDirect.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vcWebDirect animated:YES];
        }else{
            NSString *proID = model.content;

            WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
            vcWebDirect.hidesBottomBarWhenPushed = YES;
            WebDirectLocalModel* webModel = [WebDirectLocalModel new];
            webModel.url = [NSString stringWithFormat:@"%@QWSH/web/survey/html/surveyDetail.html?&id=%@", H5_BASE_URL,proID];
            [vcWebDirect setWVWithLocalModel:webModel];
            [self.navigationController pushViewController:vcWebDirect animated:YES];
        }
    }
    
    
 

}
#pragma mark --工业品的布局
-(void)setFactoryUI{
    for (UIView * subview in [self.factroyScroll subviews]) {
        if([subview isKindOfClass:[UIImageView class]]){
            [subview removeFromSuperview];
        }//这是为了防止滚动条被移除;
    }
    
    __weak UIView *lastView = nil;
    
    for (NSUInteger idx = 0; idx < FactoryArray.count; idx++) {
        BannerInfoModel *model=FactoryArray[idx];
        UIImageView *factroyView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, APP_W, 130)];
        [factroyView setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"img_banner_nomal"]];
        factroyView.layer.cornerRadius=5.0f;
        factroyView.layer.masksToBounds=YES;
        factroyView.translatesAutoresizingMaskIntoConstraints = NO;
        [factroyView addConstraint:[NSLayoutConstraint constraintWithItem:factroyView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:230]];
        
        UITapGestureRecognizer *buttonTip = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(upInside:)];
        factroyView.userInteractionEnabled=YES;
        factroyView.tag = idx+100;
        [factroyView addGestureRecognizer:buttonTip];

        [self.factroyScroll addSubview:factroyView];

        NSMutableArray *constraints = [[NSMutableArray alloc] init];
        
        if (lastView) {
            [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"[lastView]-8-[factroyView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lastView, factroyView)]];
        } else {
            [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|[factroyView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(factroyView)]];
        }
        
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[factroyView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(factroyView)]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:factroyView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.factroyScroll attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
        
        [self.factroyScroll addConstraints:constraints];
        
        
        lastView = factroyView;
    }
    
    if (lastView)
        [self.factroyScroll addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[lastView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lastView)]];
    
    
}



#pragma UItableviewdelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (OrganAuthPass){
        return 2;
    }else{
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(OrganAuthPass){
        if(section==0){//collectionView
            return 204.0f;
        }else if (section==1){//factoryView
            if(FactoryArray.count>0){
                return 146.0f;
            }else{
                return 0.1f;
            }
            
        }else {
            return 0.1f;
        }
    }else{
        if(section==0){//collectionView
            return 204.0f;
        }else {
            return 0.1f;
        }
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(OrganAuthPass){
        if(section==0){//collectionView
            return self.manySectionView;
        }else if (section==1){//factoryView
            if(FactoryArray.count>0){
              return self.factorySectionView;
            }else{
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.1)];
                return view;
            }
        }else {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.1)];
            return view;
        }
    }else{
        if(section==0){//collectionView
            return self.manySectionView;
        }else {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.1)];
            return view;
        }
    }
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(OrganAuthPass){
        if(indexPath.section==0){//公告
            if(!StrIsEmpty(self.noticeContent)&&QWGLOBALMANAGER.configure.storeType == 3){
                return 52.0f;
            }else{
                return 0.1f;
            }
        }else if(indexPath.section==1){//问药活动
            if(indexPath.row==0){
                return 37.0f;
            }else{
                return 44.0f;
            }
            
        }else{
            return 44.0f;
        }
    }else{
        return 0.1;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(OrganAuthPass){
        if(section == 0){//公告
            if(!StrIsEmpty(self.noticeContent)&&QWGLOBALMANAGER.configure.storeType == 3){
                return 1;
            }else{
                return 0;
            }
            
        }else if(section==1){
            if(self.activityArray.count==0){
                return 0;
            }else{
                return self.activityArray.count+1;
            }
            
            
        }else{
            return 0;
        }
    }else{
            return 0;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(OrganAuthPass){
        if(indexPath.section == 0){//公告
            if(!StrIsEmpty(self.noticeContent)&&QWGLOBALMANAGER.configure.storeType == 3){
            NoticeTableCell *noticeCell=[tableView dequeueReusableCellWithIdentifier:@"noticeTableCell"];
                noticeCell.noticeContentLable.text=self.noticeContent;
                return noticeCell;
            }else{
                return nil;
            }
            
        }else if (indexPath.section==1){//问药活动
            TitleTableCell *titleCell=[tableView dequeueReusableCellWithIdentifier:@"titleTableCell"];
            ContentTableCell *contentCell=[tableView dequeueReusableCellWithIdentifier:@"contentTableCell"];
            if(indexPath.row==0){
                return titleCell;
            }else{
                ActNoticeModel *model=(ActNoticeModel*)self.activityArray[indexPath.row-1];
                contentCell.contentLable.text=model.title;
                switch (model.actStatus) {
                    case 1:
                        contentCell.statusLable.text=@"报名中";
                        contentCell.statusLable.textColor=RGBHex(qwColor1);
                        break;
                    case 2:
                        contentCell.statusLable.text=@"已截止";
                        contentCell.statusLable.textColor=RGBHex(qwColor8);
                        break;
                    case 3:
                        contentCell.statusLable.text=@"进行中";
                        contentCell.statusLable.textColor=RGBHex(qwColor1);
                        break;
                    case 4:
                        contentCell.statusLable.text=@"已结束";
                        contentCell.statusLable.textColor=RGBHex(qwColor8);
                        break;
                        
                    default:
                        break;
                }
                
                
                return contentCell;
            }
            
        }else{
            return nil;
        }
    }else{
        return nil;
    }

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
        [SVProgressHUD showErrorWithStatus:kWaring12];
        return;
    }
    if(indexPath.section==0){
        [QWGLOBALMANAGER statisticsEventId:@"s_sy_gg" withLable:@"首页" withParams:nil];
        WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
        vcWebDirect.hidesBottomBarWhenPushed = YES;
        WebDirectLocalModel* webModel = [WebDirectLocalModel new];
        webModel.title=@"公告";
        webModel.url = [NSString stringWithFormat:@"%@QWSH/web/ruleDesc/html/notice.html", H5_BASE_URL];
        [vcWebDirect setWVWithLocalModel:webModel];
        [self.navigationController pushViewController:vcWebDirect animated:YES];
        
        
    }else  if(indexPath.section==1){//问药活动
        
         [QWGLOBALMANAGER statisticsEventId:@"s_sy_wyhd" withLable:@"首页" withParams:nil];
        
        if(indexPath.row==0){
            WenyaoActivityViewController *VC=[[WenyaoActivityViewController alloc]init];
            VC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:VC animated:YES];
        
        }else{
            ActNoticeModel* actNoticeModel = self.activityArray[indexPath.row-1];
            WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
            vcWebDirect.hidesBottomBarWhenPushed = YES;
            WebDirectLocalModel* webModel = [WebDirectLocalModel new];
            webModel.title = @"活动详情";
            webModel.url = [NSString stringWithFormat:@"%@QWSH/web/eventDetail/html/detail.html?id=%@", H5_BASE_URL,actNoticeModel.id];
            [vcWebDirect setWVWithLocalModel:webModel];
            [self.navigationController pushViewController:vcWebDirect animated:YES];
        }
        
    }
    
}

//处理留白的问题
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.1)];
        return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1f;
}


#pragma collectionVieindew

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


#pragma mark --定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    NSLog(@"%f",APP_W);
    if(IS_IPHONE_6P){
         return UIEdgeInsetsMake(8, 7.5, 8, 7.5);
    }else if (IS_IPHONE_6){
         return UIEdgeInsetsMake(8, 7.5, 8, 7.5);
    }else{
         return UIEdgeInsetsMake(8, 8.5, 8, 8.5);
    }
    
    
   
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"collectionCell";
    ManyCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.contentLabel.text=[[sectionDataStr objectAtIndex:indexPath.row] objectAtIndex:0];
    cell.contentImage.image=[UIImage imageNamed:[[sectionDataStr objectAtIndex:indexPath.row] objectAtIndex:2]];
    return cell;

}



//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(IS_IPHONE_6P){
        return CGSizeMake((APP_W-15)/3, 94);
    }else if (IS_IPHONE_6){
        return CGSizeMake((APP_W-15)/3, 94);
    }else{
        return CGSizeMake((APP_W-17)/3, 94);
    }
}

#pragma mark --UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSString *objectType=[[sectionDataStr objectAtIndex:indexPath.row] objectAtIndex:1];
    if([objectType intValue]==7){
        [self registerAuth:nil];
    }else{
        if (indexPath.row == 0)
        {
            [QWGLOBALMANAGER statisticsEventId:@"首页_培训" withLable:@"首页" withParams:nil];
            
            // 培训
            TrainingListViewController *vc = [[UIStoryboard storyboardWithName:@"TrainingList" bundle:nil] instantiateViewControllerWithIdentifier:@"TrainingListViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (indexPath.row == 1)
        {
            [QWGLOBALMANAGER statisticsEventId:@"首页_生意经" withLable:@"首页" withParams:nil];
            //生意经
            BusinessSenseViewController *vc = [[BusinessSenseViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (indexPath.row == 2)
        {
            [QWGLOBALMANAGER statisticsEventId:@"s_sy_jfph" withLable:@"首页" withParams:nil];
            WebDirectViewController *vcWebMedicine = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
            WebDirectLocalModel *modelLocal = [WebDirectLocalModel new];
            modelLocal.typeLocalWeb = WebLocalTypeIntegraph;
            modelLocal.typeShare = LocalShareTypeUnknow;
            [vcWebMedicine setWVWithLocalModel:modelLocal];
            [self.navigationController pushViewController:vcWebMedicine animated:YES];
        }else if (indexPath.row == 3)
        {
            [QWGLOBALMANAGER statisticsEventId:@"s_sy_bdxx" withLable:@"首页" withParams:nil];
            //本店信息
            StoreInfomationViewController *vc = [[UIStoryboard storyboardWithName:@"StoreInfo" bundle:nil] instantiateViewControllerWithIdentifier:@"StoreInfomationViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (indexPath.row == 4)
        {
            [QWGLOBALMANAGER statisticsEventId:@"s_sy_yxhd" withLable:@"首页" withParams:nil];
            //营销活动
            CampAsignViewController *camp=[[CampAsignViewController alloc]initWithNibName:@"CampAsignViewController" bundle:nil];
            camp.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:camp animated:YES];
        }else if (indexPath.row == 5)
        {
            if([objectType intValue]==8){//老的会员
                [QWGLOBALMANAGER statisticsEventId:@"s_sy_hy" withLable:@"首页" withParams:nil];
                ClientMemberViewController *vc=[[ClientMemberViewController alloc] init];
                vc.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [QWGLOBALMANAGER statisticsEventId:@"s_sy_hyyx" withLable:@"首页" withParams:nil];
                //会员营销
                MemeberRootListViewController *vc = [[UIStoryboard storyboardWithName:@"MemberMarketing" bundle:nil] instantiateViewControllerWithIdentifier:@"MemeberRootListViewController"];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}



#pragma mark --获取公告
-(void)noticeCont{
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = QWGLOBALMANAGER.configure.userToken;
    [Store noticeWithParams:setting success:^(NoticeModel *model) {
        NoticeModel *mod=[NoticeModel parse:model];
        if([mod.apiStatus intValue]==0){
            self.noticeContent=mod.title;
            self.noticeModel=mod;
            [self.homeTableView reloadData];
        }
        
    } fail:^(HttpException *e) {
        
    }];
    
}
#pragma mark --获取问药活动
-(void)activityCont{
    WenyaoActivityListR *modeR=[WenyaoActivityListR new];
    modeR.page=1;
    modeR.pageSize=3;
    [Store getWenyaoActivityList:modeR success:^(ActNoticeListModel *actNoticeList) {
        if(actNoticeList.list.count==0){
            self.activityArray=[NSMutableArray array];
        }else{
            self.activityArray=[NSMutableArray array];
            [self.activityArray addObjectsFromArray:actNoticeList.list];
            [self.homeTableView reloadData];
            
        }
    } fail:^(HttpException *e) {
        
    }];
    
}



#pragma mark ---- 接收通知 ----

- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    
    if (NotifKickOff == type)
    {
//        [self quitAccount];
        [QWGLOBALMANAGER postNotif:NotifQuitOut data:nil object:nil];
        QWGLOBALMANAGER.configure.passWord = @"";
        [QWGLOBALMANAGER saveAppConfigure];
        [QWGLOBALMANAGER clearAccountInformation];
        [QWUserDefault setBool:NO key:APP_LOGIN_STATUS];
        
        QWGLOBALMANAGER.isCheckToken = YES;
        
    }else if (NotifiIndexRedDotOrNumber == type)
    {
        // 首页咨询小红点
        NSDictionary *dd=data;
        if (dd[@"conslut"]) {
            self.passNumber = [dd[@"conslut"] intValue];
            if(self.passNumber>=0){
                redView.hidden=NO;
            }else{
                redView.hidden=YES;
            }
        }
        self.rightRedDot.hidden = YES;
        //判断是否有全维药事消息
        if ([dd[@"hadMessage"] integerValue]) {
            self.rightRedDot.hidden = NO;   // 显示
        }
        //判断是否有消息盒子消息
        if ([dd[@"hadNotice"] integerValue]) {
            self.rightRedDot.hidden = NO;
        }
        
    }else if (NotifiOrganAuthPass == type)
    {
        // 机构认证通过
        [self configureAuthView];
        [self configureArray];
        [self.homeTableView reloadData];
        
    }else if (NotifiOrganAuthFailure == type)
    {
        // 机构认证失败
        [self configureAuthView];
        [self configureArray];
        [self.homeTableView reloadData];
    }else if (NotifNewOrderCount == type)
    {
        NSString *strCount = (NSString *)data;
        self.intOrderNum = [strCount intValue];
    }
}

#pragma mark ---- 账号被抢登 ----

- (void)quitAccount
{
    QWGLOBALMANAGER.isCheckToken = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:Kwarning220N81 delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    alert.tag=Enum_CAlert_Quite;
    [alert show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==Enum_CAlert_Quite){
        [QWGLOBALMANAGER postNotif:NotifQuitOut data:nil object:nil];
        QWGLOBALMANAGER.configure.passWord = @"";
        [QWGLOBALMANAGER saveAppConfigure];
        [QWGLOBALMANAGER clearAccountInformation];
        [QWUserDefault setBool:NO key:APP_LOGIN_STATUS];
        
        QWGLOBALMANAGER.isCheckToken = YES;
        
    }else if(alertView.tag==Enum_CAlert_Verify){
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
