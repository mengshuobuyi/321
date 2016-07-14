//
//  InterlocuationViewController.m
//  wenYao-store
//  问答（QCSildeView）
//  Created by 李坚 on 16/3/4.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "InterlocuationViewController.h"
#import "QCSlideSwitchView.h"
#import "InterlocutionListViewController.h"

@interface InterlocuationViewController ()<QCSlideSwitchViewDelegate>

@property (nonatomic ,strong) NSMutableArray *viewControllerArray;
@property (nonatomic ,strong) QCSlideSwitchView *slideSwitchView;

@end

@implementation InterlocuationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.selectedIndex = 0;
    self.selectedNum = 0;
    self.viewControllerArray = [NSMutableArray array];
    
    //设置界面数组
    [self setupViewControllers];
    
    //设置sliderView
    [self setupSliderView];
    
    //添加小红点
    [self setupRedPoint];
    [QWGLOBALMANAGER statisticsEventId:@"问答页面_出现" withLable:@"圈子" withParams:nil];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    QWGLOBALMANAGER.vcInterlocution = self;
}

- (void)viewDidCurrentView
{
    QWGLOBALMANAGER.vcInterlocution = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    QWGLOBALMANAGER.vcInterlocution = nil;
}

#pragma mark ---- 设置小红点 ----
- (void)setupRedPoint
{
    //待抢答
    self.redPointOne = [[UIImageView alloc] initWithFrame:CGRectMake(APP_W/3-30, 10, 7, 7)];
    self.redPointOne.image = [UIImage imageNamed:@"img_redDot"];
    self.redPointOne.hidden = !QWGLOBALMANAGER.configure.hadWaitingMessage;
    [self.slideSwitchView.topScrollView addSubview:self.redPointOne];
    
    //解答中
    self.redPointTwo = [[UIImageView alloc] initWithFrame:CGRectMake(APP_W*2/3-30, 10, 7, 7)];
    self.redPointTwo.image = [UIImage imageNamed:@"img_redDot"];
    self.redPointTwo.hidden = !QWGLOBALMANAGER.configure.hadAnswerMessage;
    [self.slideSwitchView.topScrollView addSubview:self.redPointTwo];
}

#pragma mark ---- 创建数组 ----
- (void)setupViewControllers
{
    InterlocutionListViewController *waitRobList = [[InterlocutionListViewController alloc]init];
    waitRobList.VCStatus = Enum_Waiting;
    waitRobList.title = @"待抢答";
    waitRobList.navController = self.navController;
    [self.viewControllerArray addObject:waitRobList];
    
    InterlocutionListViewController *answerList = [[InterlocutionListViewController alloc]init];
    answerList.VCStatus = Enum_Answering;
    answerList.title = @"解答中";
    answerList.navController = self.navController;
    [self.viewControllerArray addObject:answerList];
    
    InterlocutionListViewController *closedList = [[InterlocutionListViewController alloc]init];
    closedList.VCStatus = Enum_Closed;
    closedList.title = @"已关闭";
    closedList.navController = self.navController;
    [self.viewControllerArray addObject:closedList];
    
    self.slideSwitchView.viewArray = self.viewControllerArray;
}

#pragma mark ---- 设置sliderView ----
- (void)setupSliderView
{
    self.slideSwitchView = [[QCSlideSwitchView alloc]initWithFrame:CGRectMake(0, 0, APP_W, APP_H)];
    [self.slideSwitchView.topScrollView setBackgroundColor:RGBHex(qwColor4)];
    self.slideSwitchView.tabItemSelectedColor = RGBHex(qwColor1);
    self.slideSwitchView.tabItemNormalColor = RGBHex(qwColor6);
    
    [self.slideSwitchView.rigthSideButton.titleLabel setFont:fontSystem(kFontS4)];
    self.slideSwitchView.slideSwitchViewDelegate = self;
    self.slideSwitchView.rootScrollView.scrollEnabled = YES;
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"activity_line_show"]
                                        stretchableImageWithLeftCapWidth:96.0f topCapHeight:0.0f];
    
    [self.slideSwitchView buildUI];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 39, APP_W, 0.5)];
    line.backgroundColor = RGBHex(qwColor10);
    [self.slideSwitchView addSubview:line];
    [self.view addSubview:self.slideSwitchView];
}

#pragma mark ---- QCSlideSwitchViewDelegate ----
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
    [QWGLOBALMANAGER getAllExpertConsult];
    self.selectedNum = number;
    
    [self.viewControllerArray[number] viewDidCurrentView];
    
    if(number == 0)
    {
//        [QWGLOBALMANAGER statisticsEventId:@"问答_待抢答页面_出现" withLable:@"圈子" withParams:nil];
        //待抢答
        if ([QWUserDefault getBoolBy:isHiddenRacingRedPoint]) {
            self.redPointOne.hidden = YES;
            QWGLOBALMANAGER.configure.hadWaitingMessage = NO;
            [QWGLOBALMANAGER saveAppConfigure];
            [QWGLOBALMANAGER checkInterlocutionRedPoint];
        }else{
            [QWUserDefault setBool:YES key:isHiddenRacingRedPoint];
        }
        
    }else if (number == 1)
    {
//        [QWGLOBALMANAGER statisticsEventId:@"问答_解答中页面_出现" withLable:@"圈子" withParams:nil];
        //解答中
        [QWGLOBALMANAGER pollWaitingConsultData];
        [QWGLOBALMANAGER checkInterlocutionRedPoint];
        
    }else if (number == 2)
    {
//        [QWGLOBALMANAGER statisticsEventId:@"问答_已关闭页面_出现" withLable:@"圈子" withParams:nil];
        //已关闭
        [QWGLOBALMANAGER pollWaitingConsultData];
        [QWGLOBALMANAGER checkInterlocutionRedPoint];
    }
}

@end
