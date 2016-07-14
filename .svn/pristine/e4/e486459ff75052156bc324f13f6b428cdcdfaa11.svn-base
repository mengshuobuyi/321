//
//  InterlocuationViewController.m
//  wenYao-store
//
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViewControllers];
    [self setupSliderView];
}

#pragma mark - VC建立
- (void)setupViewControllers{
    
    self.viewControllerArray = [NSMutableArray new];
    
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
    answerList.VCStatus = Enum_Closed;
    closedList.title = @"已关闭";
    closedList.navController = self.navController;
    [self.viewControllerArray addObject:closedList];
    
    self.slideSwitchView.viewArray = self.viewControllerArray;
}

#pragma mark - QCSlideSwitchView建立
- (void)setupSliderView{
    
    self.slideSwitchView = [[QCSlideSwitchView alloc]initWithFrame:CGRectMake(0, 0, APP_W, APP_H-NAV_H + 35)];
    
    [self.slideSwitchView.topScrollView setBackgroundColor:RGBHex(qwMcolor4)];
    
    self.slideSwitchView.tabItemSelectedColor = RGBHex(qwMcolor1);
    self.slideSwitchView.tabItemNormalColor = RGBHex(qwGcolor6);
    
    [self.slideSwitchView.rigthSideButton.titleLabel setFont:fontSystem(kFontS4)];
    self.slideSwitchView.slideSwitchViewDelegate = self;
    self.slideSwitchView.rootScrollView.scrollEnabled = YES;
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"blue_line_and_shadow"]
                                        stretchableImageWithLeftCapWidth:54.0f topCapHeight:0.0f];
    
    [self.slideSwitchView buildUI];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 35, APP_W, 0.5)];
    line.backgroundColor = RGBHex(qwGcolor10);
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
    
}

@end
