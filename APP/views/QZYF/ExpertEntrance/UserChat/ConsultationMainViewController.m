//
//  ConsultationMainViewController.m
//  wenYao-store
//  砖家端登录后咨询Tab对应VC
//  
//  Created by 李坚 on 16/3/4.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ConsultationMainViewController.h"
#import "QCSlideSwitchView.h"
#import "MessageSegmentControl.h"
#import "PrivateMessageListViewController.h"
#import "InterlocuationViewController.h"
#import "ExpertMessageModel.h"
#import "InterlocutionListViewController.h"

@interface ConsultationMainViewController ()<QCSlideSwitchViewDelegate,MessageSegmentControlDatasource,MessageSegmentControlDelegate>{

    NSArray *itemArray;
}

@property (nonatomic ,strong) NSMutableArray * viewControllerArray;
@property (nonatomic ,strong) QCSlideSwitchView * slideSwitchView;
@property (nonatomic, strong) InterlocuationViewController *InterlocutionList;

@end

@implementation ConsultationMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    itemArray = [NSArray arrayWithObjects:@"私聊",@"问答", nil];
    self.selectedNum = 0;

    [self setupCustomSegmentView];
    [self setupViewControllers];
    [self setupSliderView];
    
    [QWGLOBALMANAGER statisticsEventId:@"咨询页面_出现" withLable:@"圈子" withParams:nil];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.InterlocutionList ) {
        [self .InterlocutionList viewWillAppear:animated];
    }
    
    QWGLOBALMANAGER.vcConsultMain = self;
    
    [QWGLOBALMANAGER getAllExpertConsult];
    
    PrivateMessageListViewController *PMListVC = [self.viewControllerArray objectAtIndex:0];
    
    PMListVC.dataArray = [NSMutableArray arrayWithArray:[IMChatPointVo getArrayFromDBWithWhere:@"" WithorderBy:@"respondDate DESC"]];

    if(PMListVC.dataArray.count){
        [PMListVC.mainTableView reloadData];
    }

    if([IMChatPointVo checkPMUnread] || QWGLOBALMANAGER.configure.hadWaitingMessage || QWGLOBALMANAGER.configure.hadAnswerMessage){
        
        [QWGLOBALMANAGER.tabBar showBadgePoint:YES itemTag:Enum_TabBar_Items_ExpertChat];
        
        if ([IMChatPointVo checkPMUnread]) {
            [_segmentControl showBadgePoint:YES itemTag:0];
        }else{
            [_segmentControl showBadgePoint:NO itemTag:0];
        }
        
        if (QWGLOBALMANAGER.configure.hadWaitingMessage || QWGLOBALMANAGER.configure.hadAnswerMessage){
            [_segmentControl showBadgePoint:YES itemTag:1];
        }else{
            [_segmentControl showBadgePoint:NO itemTag:1];
        }
    }else{
        [_segmentControl showBadgePoint:NO itemTag:0];
        [_segmentControl showBadgePoint:NO itemTag:1];
        //显示TabBar小红点
        [QWGLOBALMANAGER.tabBar showBadgePoint:NO itemTag:Enum_TabBar_Items_ExpertChat];
    }
}

- (void)viewDidCurrentView
{
    QWGLOBALMANAGER.vcConsultMain = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    QWGLOBALMANAGER.vcConsultMain = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([QWGLOBALMANAGER.expertChatPushType isEqualToString:@"1"] || [QWGLOBALMANAGER.expertChatPushType isEqualToString:@"2"]) {
        [self.segmentControl segementSelectAtIndex:1];
        QWGLOBALMANAGER.expertChatPushType = @"0";
    }
}

- (void)pushChangeInterlocutionTab
{
    if ([QWGLOBALMANAGER.expertChatPushType isEqualToString:@"1"] || [QWGLOBALMANAGER.expertChatPushType isEqualToString:@"2"]) {
        [_segmentControl segementSelectAtIndex:1];
         QWGLOBALMANAGER.expertChatPushType = @"0";
    }
}

- (void)pushChangePrivateMessageTab{
    
    [_segmentControl segementSelectAtIndex:0];
}

#pragma mark - 建立MessageSegmentControl
- (void)setupCustomSegmentView{
    
    _segmentControl = [[MessageSegmentControl alloc]init];
    _segmentControl.datasource = self;
    _segmentControl.delegate = self;
    _segmentControl.layer.cornerRadius = 4.0f;
    _segmentControl.layer.borderColor = RGBHex(qwColor4).CGColor;
    _segmentControl.layer.borderWidth = 1.0f;
    self.navigationItem.titleView = _segmentControl;
}

#pragma mark - MessageSegmentControlDatasource
- (NSInteger)numberOfItems{
    
    return 2;
}

- (NSString *)titleForItem:(NSInteger)index{
    
    return itemArray[index];
}

- (UIColor *)itemTitleSelectedColor{
    return RGBHex(qwColor1);
}

#pragma mark - MessageSegmentControlDelegate
- (void)didCilckItemAtIndex:(MessageSegmentControl *)segmentControl atIndex:(NSInteger)index
{
    [self.slideSwitchView jumpToTabAtIndex:index];
    if(index == 1){
        [QWGLOBALMANAGER getAllExpertConsult];
    }
    
    if (index == 0)
    {
        [QWGLOBALMANAGER statisticsEventId:@"私聊页面_出现" withLable:@"圈子" withParams:nil];
    }else if (index == 1)
    {
        [QWGLOBALMANAGER statisticsEventId:@"问答页面_出现" withLable:@"圈子" withParams:nil];
    }
}

#pragma mark - VC建立
- (void)setupViewControllers{
    
    self.viewControllerArray = [NSMutableArray new];
    
    PrivateMessageListViewController *PrivateMessageList = [[PrivateMessageListViewController alloc]init];
    PrivateMessageList.navController = self.navigationController;
    [self.viewControllerArray addObject:PrivateMessageList];
    
    self.InterlocutionList = [[InterlocuationViewController alloc]init];
    self.InterlocutionList.navController = self.navigationController;
    [self.viewControllerArray addObject:self.InterlocutionList];
    
    self.slideSwitchView.viewArray = self.viewControllerArray;
}

#pragma mark - 建立QCSlideView
- (void)setupSliderView{

    self.slideSwitchView = [[QCSlideSwitchView alloc]initWithFrame:CGRectMake(0, -39, APP_W, APP_H)];
    
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
- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view{
    return self.viewControllerArray.count;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number{
    
    return self.viewControllerArray[number];
}

- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number{
 
    self.selectedNum = number;
    switch (number) {
        case 0:
        {
            [QWGLOBALMANAGER getAllExpertConsult];
            [QWGLOBALMANAGER pollWaitingConsultData];
            [QWGLOBALMANAGER checkInterlocutionRedPoint];
        }
            break;
        case 1:
        {
            [QWGLOBALMANAGER getAllExpertConsult];
            [QWGLOBALMANAGER checkInterlocutionRedPoint];
            
            //点击问答tab的时候，进入待抢答
            if (QWGLOBALMANAGER.vcInterlocution) {
                QWGLOBALMANAGER.vcInterlocution.redPointOne.hidden = YES;
                QWGLOBALMANAGER.configure.hadWaitingMessage = NO;
                [QWGLOBALMANAGER saveAppConfigure];
                [QWGLOBALMANAGER checkInterlocutionRedPoint];
            }
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - 新消息接收通知
- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj{
    
    if(type == NotiRefreshPrivateExpert){
        
        if([IMChatPointVo checkPMUnread]){
            //显示TabBar小红点
            [QWGLOBALMANAGER.tabBar showBadgePoint:YES itemTag:Enum_TabBar_Items_ExpertChat];
            [_segmentControl showBadgePoint:YES itemTag:0];
        }else{
            
            //判断是否有问答
            if (QWGLOBALMANAGER.configure.hadWaitingMessage || QWGLOBALMANAGER.configure.hadAnswerMessage) {
                [QWGLOBALMANAGER.tabBar showBadgePoint:YES itemTag:Enum_TabBar_Items_ExpertChat];
            }else{
                [QWGLOBALMANAGER.tabBar showBadgePoint:NO itemTag:Enum_TabBar_Items_ExpertChat];
            }
            
        }
    }

}



@end
