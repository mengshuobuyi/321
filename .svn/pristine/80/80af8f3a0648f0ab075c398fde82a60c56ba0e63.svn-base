//
//  ExpertInfoViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/7.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ExpertInfoViewController.h"
#import "QCSlideSwitchView.h"
#import "ExpertCommentViewController.h"
#import "ExpertFlowerViewController.h"
#import "AtMineViewController.h"
#import "ExpertSystemInfoViewController.h"
#import "CustomPopListView.h"
#import "Circle.h"

@interface ExpertInfoViewController ()<QCSlideSwitchViewDelegate,CustomPopListViewDelegate>
{
    __weak QWBaseVC  *currentViewController;
}

@property (nonatomic, strong) NSMutableArray *viewControllerArray;
@property (nonatomic ,strong) QCSlideSwitchView * slideSwitchView;
@property (strong, nonatomic) CustomPopListView *customPopListView;

@property (strong, nonatomic) UIImageView *redPointOne;
@property (strong, nonatomic) UIImageView *redPointTwo;
@property (strong, nonatomic) UIImageView *redPointThree;
@property (strong, nonatomic) UIImageView *redPointFour;

//评论
@property (strong, nonatomic) ExpertCommentViewController *commentViewController;

@end

@implementation ExpertInfoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"圈子消息";
    self.viewControllerArray = [NSMutableArray array];
    
    [QWGLOBALMANAGER statisticsEventId:@"我的_消息" withLable:@"圈子" withParams:nil];
    
    //3.1 change
//    if (QWGLOBALMANAGER.configure.silencedFlag) {
//        [self showInfoView:@"您已被禁言" image:@"ic_img_cry"];
//        return;
//    }
    
    //初始化界面数组
    [self setupViewController];
    
    //设置sliderView
    [self setupSliderView];

    //导航栏右侧按钮
    [self setUpRightItem];
    
    //设置小红点UI
    [self setupRedPoint];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.selectedTab == 2)
    {
        //鲜花
        [self.slideSwitchView jumpToTabAtIndex:1];
        QWGLOBALMANAGER.configure.expertFlowerRed = NO;
    }else if (self.selectedTab == 3)
    {
        //@我的
        [self.slideSwitchView jumpToTabAtIndex:2];
        QWGLOBALMANAGER.configure.expertAtMineRed = NO;
    }else if (self.selectedTab == 99)
    {
        //系统消息
        [self.slideSwitchView jumpToTabAtIndex:3];
        QWGLOBALMANAGER.configure.expertSystemInfoRed = NO;
    }else
    {
        //其他
        QWGLOBALMANAGER.configure.expertCommentRed = NO;
    }
    
    [QWGLOBALMANAGER saveAppConfigure];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.commentViewController) {
        [self.commentViewController viewWillAppear:animated];
    }
}

#pragma mark ---- 设置导航栏右侧按钮 ----
- (void)setUpRightItem
{
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = -15;
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    
    //三个点button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, -2, 50, 40);
    [button setImage:[UIImage imageNamed:@"icon-unfold"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:button];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItems = @[fixed,rightItem];
}

- (void)rightAction
{
    self.customPopListView = [CustomPopListView sharedManagerWithtitleList:@[@"全部标记为已读"]];
    self.customPopListView.delegate = self;
    [self.customPopListView show];
}

#pragma mark ---- 返回action ----
- (void)popVCAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
    if (!QWGLOBALMANAGER.configure.expertCommentRed && !QWGLOBALMANAGER.configure.expertFlowerRed && !QWGLOBALMANAGER.configure.expertAtMineRed && !QWGLOBALMANAGER.configure.expertSystemInfoRed)
    {
        [QWGLOBALMANAGER postNotif:NotifHiddenCircleMessage data:nil object:nil];
    }
}

#pragma mark ---- CustomPopListView 代理 ----
- (void)customPopListView:(CustomPopListView *)ReturnIndexView didSelectedIndex:(NSIndexPath *)indexPath
{
    [self.customPopListView hide];
    
    if (indexPath.row == 0)
    {
        //全部标记为已读
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [SVProgressHUD showErrorWithStatus:kWaring33];
            return;
        }
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
        setting[@"readFlag"] = @"N";
        
        [Circle TeamChangeAllMessageReadFlagWithParams:setting success:^(id obj) {
            BaseAPIModel *model = [BaseAPIModel parse:obj];
            if ([model.apiStatus integerValue] == 0)
            {
                self.redPointOne.hidden = YES;
                self.redPointTwo.hidden = YES;
                self.redPointThree.hidden = YES;
                self.redPointFour.hidden = YES;
                
                QWGLOBALMANAGER.configure.expertCommentRed = NO;
                QWGLOBALMANAGER.configure.expertFlowerRed = NO;
                QWGLOBALMANAGER.configure.expertAtMineRed = NO;
                QWGLOBALMANAGER.configure.expertSystemInfoRed = NO;
                [QWGLOBALMANAGER saveAppConfigure];
            }
        } failure:^(HttpException *e) {
        }];
    }
}

#pragma mark ---- 初始化界面数组 ---
- (void)setupViewController{
    
    self.commentViewController = [[UIStoryboard storyboardWithName:@"ExpertInfo" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertCommentViewController"];
    self.commentViewController.title=@"评论";
    self.commentViewController.navigationController = self.navigationController;
    
    ExpertFlowerViewController *flower = [[UIStoryboard storyboardWithName:@"ExpertInfo" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertFlowerViewController"];
    flower.title=@"鲜花";
    flower.navigationController = self.navigationController;
    
    AtMineViewController *mine = [[UIStoryboard storyboardWithName:@"ExpertInfo" bundle:nil] instantiateViewControllerWithIdentifier:@"AtMineViewController"];
    mine.title=@"@我的";
    mine.navigationController = self.navigationController;
    
    ExpertSystemInfoViewController *system = [[UIStoryboard storyboardWithName:@"ExpertInfo" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertSystemInfoViewController"];
    system.title=@"系统消息";
    system.navigationController = self.navigationController;
    
    currentViewController = self.commentViewController;
    self.viewControllerArray = [NSMutableArray arrayWithObjects:self.commentViewController,flower,mine,system, nil];
}

- (void)setupSliderView
{
    self.slideSwitchView = [[QCSlideSwitchView alloc]initWithFrame:CGRectMake(0, 0, APP_W, APP_H - 44)];
    self.slideSwitchView.tabItemNormalColor = RGBHex(qwColor8);
    [self.slideSwitchView.topScrollView setBackgroundColor:RGBHex(qwColor4)];
    self.slideSwitchView.tabItemSelectedColor = RGBHex(qwColor1);
    self.slideSwitchView.slideSwitchViewDelegate = self;
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"activity_line_show"]
                                        stretchableImageWithLeftCapWidth:96.0f topCapHeight:0.0f];
    
    [self.slideSwitchView buildUI];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 39, APP_W, 0.5)];
    line.backgroundColor = RGBHex(qwColor10);
    [self.slideSwitchView addSubview:line];
    [self.view addSubview:self.slideSwitchView];
    self.slideSwitchView.topScrollView.scrollEnabled = NO;
    self.slideSwitchView.rootScrollView.scrollEnabled = YES;
}

#pragma mark ---- 设置小红点UI ----
- (void)setupRedPoint
{
    self.redPointOne = [[UIImageView alloc] initWithFrame:CGRectMake(APP_W/4-23, 10, 7, 7)];
    self.redPointOne.image = [UIImage imageNamed:@"img_redDot"];
    self.redPointOne.hidden = !QWGLOBALMANAGER.configure.expertCommentRed;
    [self.slideSwitchView.topScrollView addSubview:self.redPointOne];
    
    self.redPointTwo = [[UIImageView alloc] initWithFrame:CGRectMake(APP_W*2/4-23, 10, 7, 7)];
    self.redPointTwo.image = [UIImage imageNamed:@"img_redDot"];
    self.redPointTwo.hidden = !QWGLOBALMANAGER.configure.expertFlowerRed;
    [self.slideSwitchView.topScrollView addSubview:self.redPointTwo];
    
    self.redPointThree = [[UIImageView alloc] initWithFrame:CGRectMake(APP_W*3/4-18, 10, 7, 7)];
    self.redPointThree.image = [UIImage imageNamed:@"img_redDot"];
    self.redPointThree.hidden = !QWGLOBALMANAGER.configure.expertAtMineRed;
    [self.slideSwitchView.topScrollView addSubview:self.redPointThree];
    
    self.redPointFour = [[UIImageView alloc] initWithFrame:CGRectMake(APP_W-11, 10, 7, 7)];
    self.redPointFour.image = [UIImage imageNamed:@"img_redDot"];
    self.redPointFour.hidden = !QWGLOBALMANAGER.configure.expertSystemInfoRed;
    [self.slideSwitchView.topScrollView addSubview:self.redPointFour];
}

#pragma mark ---- QCSlideSwitchView 代理 ----
- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    return self.viewControllerArray.count;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    return self.viewControllerArray[number];
}

- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    if (number == 0)
    {
        //评论
        self.redPointOne.hidden = YES;
    }else if (number == 1)
    {
        //鲜花
        self.redPointTwo.hidden = YES;
    }else if (number == 2)
    {
        //@我的
        self.redPointThree.hidden = YES;
    }else if (number == 3)
    {
        //系统消息
        self.redPointFour.hidden = YES;
    }
    
    [self.viewControllerArray[number] viewDidCurrentView];
}

#pragma mark ---- 接收通知 ----
- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
     if (NotifCircleMessage == type)
    {
        //圈子消息小红点
        NSDictionary *dd=data;
        if (dd[@"messageType"])
        {
            int type = [dd[@"messageType"] integerValue];
            if (type == 1)
            {
                self.redPointOne.hidden = NO;
                
            }else if (type == 2)
            {
                self.redPointTwo.hidden = NO;
                
            }else if (type == 3)
            {
                self.redPointThree.hidden = NO;
                
            }else if (type == 99)
            {
                self.redPointFour.hidden = NO;
            }
        }
    }else if (NotifHiddenCommentRedPoint == type)
    {
        self.redPointOne.hidden = YES;
        
    }else if (NotifHiddenFlowerRedPoint == type)
    {
        self.redPointTwo.hidden = YES;
        
    }else if (NotifHiddenAtMineRedPoint == type)
    {
        self.redPointThree.hidden = YES;
        
    }else if (NotifHiddenSystemInfoRedPoint == type)
    {
        self.redPointFour.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
