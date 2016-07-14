//
//  ExpertPageViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/15.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ExpertPageViewController.h"
#import "NSString+WPAttributedMarkup.h"
#import "CircleDetailNextViewController.h"
#import "CircleModel.h"
#import "Circle.h"
#import "TaReplyViewController.h"
#import "GUITabScrollView.h"

@interface ExpertPageViewController ()<GUITabPagerDataSource, GUITabPagerDelegate,CircleDetailNextViewControllerDelegaet,TaReplyViewControllerDelegaet>
{
    CGFloat rowHeight;
    int tabNum;
    CircleDetailNextViewController *currentViewController;
    BOOL isHeaderRefresh;
}

@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *headerIcon;       //头像
@property (weak, nonatomic) IBOutlet UILabel *expertName;           //姓名
@property (weak, nonatomic) IBOutlet UILabel *expertBrandLabel;     //品牌
@property (weak, nonatomic) IBOutlet UILabel *goodFieldLabel;       //擅长领域
@property (weak, nonatomic) IBOutlet UILabel *funsLabel;            //粉丝
@property (weak, nonatomic) IBOutlet UILabel *flowerLabel;          //鲜花
@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;       //关注
@property (weak, nonatomic) IBOutlet UILabel *cancelAttentionLabel; //取消关注
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;     //关注按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expertBrand_layout_width;

@property (strong, nonatomic) CircleMaserlistModel *expertInfoModel;

@property (strong, nonatomic) NSMutableArray * sliderTabLists;
@property (strong, nonatomic) NSMutableArray *viewControllerssss;

@property (strong, nonatomic) CircleDetailNextViewController *lookViewController;
@property (strong, nonatomic) TaReplyViewController *replyViewController;
- (IBAction)attentionAction:(id)sender;


@end

@implementation ExpertPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDataSource:self];
    [self setDelegate:self];
    
    if (self.expertType == 3) {
        self.title = @"药师专栏";
    }else{
        self.title = @"营养师专栏";
    }
    
    self.viewControllerssss = [NSMutableArray array];
    self.sliderTabLists = [NSMutableArray array];

    self.expertInfoModel = [CircleMaserlistModel new];
    
    [self queryExpertInfo];
    
    //设置tableviewheader
    [self setUpTableHeaderView];
    
    [self setupSliderViewControllers];
    
    //下拉刷新
    __weak ExpertPageViewController *weakSelf = self;
    [self enableSimpleRefresh:self.tableView block:^(SRRefreshView *sender) {
        
        if (QWGLOBALMANAGER.currentNetWork != kNotReachable)
        {
            HttpClientMgr.progressEnabled = NO;
            isHeaderRefresh = YES;
            [weakSelf queryExpertInfo];
            [self selectTabbarIndex:tabNum];
            [weakSelf refreshPostListWithTabIndex:tabNum];
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"网络未连接，请重试！" duration:0.8];
        }
    }];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self reloadData];
    
    [self refreshPostListWithTabIndex:0];
    
    [QWGLOBALMANAGER statisticsEventId:@"专栏_Ta的发文_出现" withLable:@"圈子" withParams:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ((QWBaseNavigationController *)self.navigationController).canDragBack = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    ((QWBaseNavigationController *)self.navigationController).canDragBack = YES;
}

- (NSInteger)numberOfViewControllers {
    return self.sliderTabLists.count;
}

- (UIViewController<GUITabViewControllerObject> *)viewControllerForIndex:(NSInteger)index
{
    if (index == 0)
    {
        self.lookViewController.delegate = self;
        CGRect rect = self.view.bounds;
        rect.size.height -= 44.f;
        self.lookViewController.view.frame = rect;
        self.lookViewController.delegate = self;
        return self.lookViewController;
    }else
    {
        self.replyViewController.delegate = self;
        CGRect rect = self.view.bounds;
        rect.size.height -= 44.f;
        self.replyViewController.view.frame = rect;
        self.replyViewController.delegate = self;
        return self.replyViewController;
    }
}

- (UIScrollView<GUITabScrollViewObject> *)tabScrollView
{
    NSMutableArray *arrM = [NSMutableArray array];
    for (int i = 0; i < self.sliderTabLists.count; i++) {
        [arrM addObject:[self titleForTabAtIndex:i]];
    }
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    frame.size.height = 44.0f;
    return [[GUITabScrollView alloc] initWithFrame:frame tabTitles:[arrM copy] tabBarHeight:44.0f tabIndicatorHeight:2.0f seperatorHeight:0.5f tabIndicatorColor:RGBHex(qwColor3) seperatorColor:[UIColor lightGrayColor] backgroundColor:[UIColor whiteColor] selectedTabIndex:0 centerSepColor:RGBHex(qwColor9)];
}

- (UIView *)tabPagerHeaderView
{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 140)];
//    view.backgroundColor = [UIColor clearColor];
//    return view;
    return self.tableHeaderView;
}

- (NSString *)titleForTabAtIndex:(NSInteger)index
{
    return self.sliderTabLists[index];
}

/* 代理 */
#pragma mark - Tab Pager Delegate

- (void)tabPager:(GUITabPagerViewController *)tabPager willTransitionToTabAtIndex:(NSInteger)index {
    tabNum = index;
    [self refreshPostListWithTabIndex:tabNum];
    
    if (index == 0)
    {
        [QWGLOBALMANAGER statisticsEventId:@"专栏_Ta的发文_出现" withLable:@"圈子" withParams:nil];
    }else if (index == 1)
    {
        [QWGLOBALMANAGER statisticsEventId:@"专栏_Ta的回帖_出现" withLable:@"圈子" withParams:nil];
    }
}

- (void)tabPager:(GUITabPagerViewController *)tabPager didTransitionToTabAtIndex:(NSInteger)index {
}

#pragma mark - scrollToTop delegate

/* 外部调整scrollToTop的表现 */
- (void)didScrollToTop:(CircleDetailNextViewController *)vc
{
    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.contentOffset = CGPointZero;
    }];
    UIScrollView *sc = (UIScrollView *)vc.view;
//    sc.bounces  = NO;
    self.tableView.bounces = NO;
}

- (void)expertDidScrollToTop:(TaReplyViewController *)vc;
{
    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.contentOffset = CGPointZero;
    }];
    UIScrollView *sc = (UIScrollView *)vc.view;
//        sc.bounces  = NO;
    self.tableView.bounces = NO;
}


#pragma mark ---- 设置界面数组 ----
- (void)setupSliderViewControllers
{
    if (self.lookViewController == nil) {
        self.lookViewController = [[UIStoryboard storyboardWithName:@"Circle" bundle:nil] instantiateViewControllerWithIdentifier:@"CircleDetailNextViewController"];
        self.lookViewController.navigationController = self.navigationController;
        self.lookViewController.requestType = @"1";
        self.lookViewController.jumpType = @"2";
        self.lookViewController.sliderTabIndex = @"1";
         [self.viewControllerssss addObject:self.lookViewController];
        currentViewController = self.lookViewController;
    }
    if (self.replyViewController == nil) {
        self.replyViewController = [[UIStoryboard storyboardWithName:@"ExpertPage" bundle:nil] instantiateViewControllerWithIdentifier:@"TaReplyViewController"];
        self.replyViewController.navigationController = self.navigationController;
        [self.viewControllerssss addObject:self.replyViewController];
    }
    
    self.sliderTabLists = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"Ta的发文（%d）",self.expertInfoModel.postCount],[NSString stringWithFormat:@"Ta的回帖（%d）",self.expertInfoModel.replyCount], nil];
    
    [self reloadData];
}

#pragma mark ---- 请求专家数据 ----
- (void)queryExpertInfo
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"expertId"] = StrFromObj(self.posterId);
    [Circle TeamExpertInfoWithParams:setting success:^(id obj) {
        
        CircleMaserlistModel *model = [CircleMaserlistModel parse:obj];
        if ([model.apiStatus integerValue] == 0)
        {
            if (model.silencedFlag)
            {
                [self showInfoView:@"该专家被禁言" image:@"ic_img_cry"];
            }else
            {
                self.expertInfoModel = model;
                
                //设置headerView
                [self setUpTableHeaderView];
                
                if (!isHeaderRefresh) {
                    [self setupSliderViewControllers];
                }
            }
        }else
        {
            [SVProgressHUD showErrorWithStatus:model.apiMessage];
        }
        
    } failure:^(HttpException *e) {
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [self showInfoView:kWaring12 image:@"img_network"];
        }else
        {
            if(e.errorCode != -999){
                if(e.errorCode == -1001){
                    [self showInfoView:kWarning215N54 image:@"ic_img_fail"];
                }else{
                    [self showInfoView:kWarning215N0 image:@"ic_img_fail"];
                }
            }
        }
    }];
}

#pragma mark ---- 设置headerView ----
- (void)setUpTableHeaderView
{
    self.tableHeaderView.backgroundColor = [UIColor clearColor];
    
    self.headerIcon.layer.cornerRadius = 28;
    self.headerIcon.layer.masksToBounds = YES;
    
    self.attentionLabel.layer.cornerRadius = 4.0;
    self.attentionLabel.layer.masksToBounds = YES;
    
    self.cancelAttentionLabel.layer.cornerRadius = 4.0;
    self.cancelAttentionLabel.layer.masksToBounds = YES;
    
    self.expertBrandLabel.layer.cornerRadius = 4.0;
    self.expertBrandLabel.layer.masksToBounds = YES;
    
    CircleMaserlistModel *model = (CircleMaserlistModel *)self.expertInfoModel;
    
    //头像
    [self.headerIcon setImageWithURL:[NSURL URLWithString:model.headImageUrl] placeholderImage:[UIImage imageNamed:@"expert_ic_people"]];
    
    //姓名
    NSString *name = model.nickName;
    NSString *logoName = @"";
    if (model.userType == 3) { //药师
        logoName = @"药师";
    }else if (model.userType == 4){ //营养师
        logoName = @"营养师";
    }
    NSString *str = [NSString stringWithFormat:@"%@ %@",name,logoName];
    NSMutableAttributedString *nameAttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange range = [[nameAttributedStr string]rangeOfString:logoName];
    [nameAttributedStr addAttribute:NSFontAttributeName
                              value:fontSystem(kFontS4)
                              range:range];
    [nameAttributedStr addAttribute:NSForegroundColorAttributeName
                              value:RGBHex(qwColor3)
                              range:range];
    self.expertName.attributedText = nameAttributedStr;
    
    //药房品牌
    if (model.userType == 3 || model.userType == 4)
    {
        NSString *store;
        if (model.groupName && ![model.groupName isEqualToString:@""]) {
            store = model.groupName;
        }else{
            store = @"";
        }
        
        if (StrIsEmpty(store))
        {
            self.expertBrandLabel.hidden = YES;
        }else
        {
            self.expertBrandLabel.hidden = NO;
            self.expertBrandLabel.layer.cornerRadius = 4.0;
            self.expertBrandLabel.layer.masksToBounds = YES;
            self.expertBrandLabel.text = store;
            CGSize brandSize = [store sizeWithFont:fontSystem(12) constrainedToSize:CGSizeMake(APP_W-20, CGFLOAT_MAX)];
            self.expertBrand_layout_width.constant = brandSize.width+7;
        }
    }
    
    //粉丝
    NSString *str1 = [NSString stringWithFormat:@"粉丝 %d",model.attnCount];
    NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc]initWithString:str1];
    NSRange range1 = [[AttributedStr1 string]rangeOfString:@"粉丝"];
    [AttributedStr1 addAttribute:NSFontAttributeName
                           value:fontSystem(kFontS4)
                           range:range1];
    [AttributedStr1 addAttribute:NSForegroundColorAttributeName
                           value:RGBHex(qwColor8)
                           range:range1];
    self.funsLabel.attributedText = AttributedStr1;
    
    //鲜花
    NSString *str2 = [NSString stringWithFormat:@"鲜花 %d",model.upVoteCount];
    NSMutableAttributedString *AttributedStr2 = [[NSMutableAttributedString alloc]initWithString:str2];
    NSRange range2 = [[AttributedStr2 string]rangeOfString:@"鲜花"];
    [AttributedStr2 addAttribute:NSFontAttributeName
                           value:fontSystem(kFontS4)
                           range:range2];
    [AttributedStr2 addAttribute:NSForegroundColorAttributeName
                           value:RGBHex(qwColor8)
                           range:range2];
    self.flowerLabel.attributedText = AttributedStr2;
    
    //擅长领域
    
    NSString *goodFieldStr = @"";
    if (model.expertise && ![model.expertise isEqualToString:@""])
    {
        NSArray *arr = [model.expertise componentsSeparatedByString:SeparateStr];
        if (arr.count == 0)
        {
            goodFieldStr = @"";
            
        }else if (arr.count == 1)
        {
            goodFieldStr = [NSString stringWithFormat:@"%@",arr[0]];
            
        }else if (arr.count == 2)
        {
            goodFieldStr = [NSString stringWithFormat:@"%@/%@",arr[0],arr[1]];
            
        }else if (arr.count >= 3)
        {
            goodFieldStr = [NSString stringWithFormat:@"%@/%@/%@",arr[0],arr[1],arr[2]];
        }
    }else
    {
        goodFieldStr = @"";
    }
    
    self.goodFieldLabel.text = [NSString stringWithFormat:@"擅长 : %@",goodFieldStr];
    
    //关注
    if (model.isAttnFlag)
    {
        //关注 显示取消关注
        self.attentionLabel.hidden = YES;
        self.cancelAttentionLabel.hidden = NO;
    }else
    {
        //未关注 显示关注
        self.attentionLabel.hidden = NO;
        self.cancelAttentionLabel.hidden = YES;
    }
    
    
    NSString *store;
    //药师 标识显示药师所属商家
    if (model.groupName && ![model.groupName isEqualToString:@""]) {
        store = model.groupName;
    }else{
        store = @"";
    }
    
    CGRect frame = self.tableHeaderView.frame;
    if (StrIsEmpty(store))
    {
        frame.size.height = 247-16-20;
    }else
    {
        frame.size.height = 247;
    }
    
    self.tableHeaderView.frame = CGRectMake(0, 0, APP_W, frame.size.height);

}

- (void)viewInfoClickAction:(id)sender
{
    if (QWGLOBALMANAGER.currentNetWork != kNotReachable) {
        [self removeInfoView];
        [self queryExpertInfo];
    }
}

#pragma mark ---- 刷新帖子列表 ----
- (void)refreshPostListWithTabIndex:(int)index
{
    self.tableView.footerNoDataText = @"已显示全部内容";
    [self.tableView.footer setDiseaseCanLoadMore:YES];
    currentViewController = self.viewControllerssss[index];
    currentViewController.expertId = self.posterId;
    [currentViewController currentViewSelected:^(CGFloat height) {
        
    }];
}

#pragma mark ---- 关注专家 ----
- (IBAction)attentionAction:(id)sender
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    
    if (QWGLOBALMANAGER.configure.silencedFlag) {
        [SVProgressHUD showErrorWithStatus:@"您已被禁言"];
        return;
    }
    
    NSString *type;
    if (self.expertInfoModel.isAttnFlag) {
        type = @"1";
    }else{
        type = @"0";
    }
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"objId"] = StrFromObj(self.posterId);
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"reqBizType"] = type;
    [Circle teamAttentionMbrWithParams:setting success:^(id obj) {
        if ([obj[@"apiStatus"] integerValue] == 0)
        {
            [SVProgressHUD showSuccessWithStatus:obj[@"apiMessage"]];
            self.expertInfoModel.isAttnFlag = !self.expertInfoModel.isAttnFlag;
            [self setUpTableHeaderView];
        }else
        {
            [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"]];
        }
    } failure:^(HttpException *e) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
