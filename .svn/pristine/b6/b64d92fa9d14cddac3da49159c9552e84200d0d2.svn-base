//
//  CircleViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 15/12/17.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "CircleViewController.h"
#import "MyCircleViewController.h"
#import "HotCircleViewController.h"
#import "AllCircleViewController.h"
#import "ExpertMessageModel.h"
#import "QCSlideSwitchView.h"
#import "ExpertInfoViewController.h"

@interface CircleViewController ()<QCSlideSwitchViewDelegate>

@property (strong, nonatomic) MyCircleViewController  *myVC;  //我的圈
@property (strong, nonatomic) HotCircleViewController *hotVC; //热门帖
@property (strong, nonatomic) AllCircleViewController *allVC; //全部圈子

@property (nonatomic ,strong) NSMutableArray * viewControllerArray;
@property (nonatomic ,strong) QCSlideSwitchView * slideSwitchView;
@property (strong, nonatomic) UIImageView *rightRedPoint;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentController;

- (IBAction)changeMessageType:(id)sender;

@end

@implementation CircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化界面
    [self setUpViewController];
    [self setupSliderView];
    
    //设置导航栏消息盒子
    [self setUpRightItem];
    
    //设置title
    self.navigationItem.titleView = self.segmentController;
    
    [QWGLOBALMANAGER statisticsEventId:@"圈子页面_出现" withLable:@"圈子" withParams:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.myVC) {
        [self.myVC viewWillAppear:animated];
    }
    
    if (self.allVC) {
        [self.allVC viewWillAppear:animated];
    }
    
    if (self.hotVC) {
        [self.hotVC viewWillAppear:animated];
    }
}

#pragma mark ---- 设置导航栏右侧按钮 ----
- (void)setUpRightItem
{
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = -17;
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    bg.backgroundColor = [UIColor clearColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, -1, 50, 44);
    [btn setImage:[UIImage imageNamed:@"icon_news"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon_news_click"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(jumpIntoInfoVC) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:btn];
    
    self.rightRedPoint = [[UIImageView alloc] initWithFrame:CGRectMake(35, 8, 7, 7)];
    self.rightRedPoint.image = [UIImage imageNamed:@"img_redDot"];
    self.rightRedPoint.hidden = YES;
    [bg addSubview:self.rightRedPoint];
    
    if (QWGLOBALMANAGER.configure.expertCommentRed || QWGLOBALMANAGER.configure.expertFlowerRed || QWGLOBALMANAGER.configure.expertAtMineRed || QWGLOBALMANAGER.configure.expertSystemInfoRed) {
        self.rightRedPoint.hidden = NO;
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:bg];
    self.navigationItem.rightBarButtonItems = @[fixed,item];
}

#pragma mark ---- 进入消息页面 ----
- (void)jumpIntoInfoVC
{
    [QWGLOBALMANAGER statisticsEventId:@"圈子_消息盒子按键" withLable:@"圈子" withParams:nil];
    ExpertInfoViewController *vc = [[ExpertInfoViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma ---- 初始化界面 ----
- (void)setUpViewController
{
    self.viewControllerArray = [NSMutableArray new];
    
    //我的圈
    self.myVC = [[UIStoryboard storyboardWithName:@"Circle" bundle:nil] instantiateViewControllerWithIdentifier:@"MyCircleViewController"];
    self.myVC.cusNavigationController = self.navigationController;
    
    //热门帖
    self.hotVC = [[UIStoryboard storyboardWithName:@"Circle" bundle:nil] instantiateViewControllerWithIdentifier:@"HotCircleViewController"];
    self.hotVC.cusNavigationController = self.navigationController;
    
    //全部圈子
    self.allVC = [[UIStoryboard storyboardWithName:@"Circle" bundle:nil] instantiateViewControllerWithIdentifier:@"AllCircleViewController"];
    self.allVC.cusNavigationController = self.navigationController;
    
    [self.viewControllerArray addObject:self.myVC];
    [self.viewControllerArray addObject:self.hotVC];
    [self.viewControllerArray addObject:self.allVC];
    
    self.slideSwitchView.viewArray = self.viewControllerArray;
}

#pragma mark ---- 选项卡 ----
- (IBAction)changeMessageType:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    [self.slideSwitchView jumpToTabAtIndex:seg.selectedSegmentIndex];
    switch (seg.selectedSegmentIndex) {
        case 0:
            [QWGLOBALMANAGER statisticsEventId:@"我的圈页面_出现" withLable:nil withParams:nil];
            break;
        case 1:
            [QWGLOBALMANAGER statisticsEventId:@"热门帖页面_出现" withLable:nil withParams:nil];
            break;
        case 2:
            [QWGLOBALMANAGER statisticsEventId:@"全部圈子页面_出现" withLable:nil withParams:nil];
            break;
        default:
            break;
    }
}

#pragma mark - 建立QCSlideView
- (void)setupSliderView{
    
    self.slideSwitchView = [[QCSlideSwitchView alloc]initWithFrame:CGRectMake(0, -39, APP_W, APP_H-TAB_H)];
    
    [self.slideSwitchView.topScrollView setBackgroundColor:RGBHex(qwColor4)];
    self.slideSwitchView.tabItemSelectedColor = RGBHex(qwColor1);
    self.slideSwitchView.tabItemNormalColor = RGBHex(qwColor6);
    
    [self.slideSwitchView.rigthSideButton.titleLabel setFont:fontSystem(kFontS4)];
    self.slideSwitchView.slideSwitchViewDelegate = self;
    self.slideSwitchView.rootScrollView.scrollEnabled = NO;
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"red_line_and_shadow.png"]
                                        stretchableImageWithLeftCapWidth:84.0f topCapHeight:0.0f];
    
    [self.slideSwitchView buildUI];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 35, APP_W, 0.5)];
    line.backgroundColor = RGBHex(qwColor10);
    [self.slideSwitchView addSubview:line];
    
    [self.view addSubview:self.slideSwitchView];
}

#pragma mark - QCSlideSwitchViewDelegate
- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    return self.viewControllerArray.count;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    return self.viewControllerArray[number];
}

#pragma mark - 新消息接收通知
- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj{
    
    if(type == NotiRefreshPrivateExpert){
        
        if([IMChatPointVo checkPMUnread]){
            //显示TabBar小红点
            [QWGLOBALMANAGER.tabBar showBadgePoint:YES itemTag:Enum_TabBar_Items_ExpertChat];
        }else{
            
            //判断是否有问答
            if (type == NotiRefreshWaitingMessage || type == NotiRefreshAnswerMessage) {
                [QWGLOBALMANAGER.tabBar showBadgePoint:YES itemTag:Enum_TabBar_Items_ExpertChat];
            }else{
                [QWGLOBALMANAGER.tabBar showBadgePoint:NO itemTag:Enum_TabBar_Items_ExpertChat];
            }
            
        }
    }else if (NotifKickOff == type)
    {
        [QWGLOBALMANAGER postNotif:NotifQuitOut data:nil object:nil];
        [QWGLOBALMANAGER saveAppConfigure];
        [QWGLOBALMANAGER clearExpertAccountInformation];
        [QWUserDefault setBool:NO key:APP_LOGIN_STATUS];
        
        if (QWGLOBALMANAGER.configure.expertIsSetPwd) {
            [QWUserDefault setBool:YES key:@"expertupdatepassword"];
        }
    }else if (NotifCircleMessage == type)
    {
        //圈子消息小红点
        NSDictionary *dd=data;
        if (dd[@"messageType"])
        {
            int type = [dd[@"messageType"] integerValue];
            if (type == 1 || type == 2 || type == 3 || type == 99)
            {
                self.rightRedPoint.hidden = NO;
            }
        }
    }else if (NotifHiddenCircleMessage == type)
    {
        self.rightRedPoint.hidden = YES;
        [QWGLOBALMANAGER.tabBar showBadgePoint:NO itemTag:Enum_TabBar_Items_ExpertMine];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
