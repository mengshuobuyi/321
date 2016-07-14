//
//  CoupnActivityViewController.m
//  wenYao-store
//
//  Created by caojing on 15/8/21.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "CoupnActivityViewController.h"
#import "DoingViewController.h"
#import "EndViewController.h"

@interface CoupnActivityViewController ()
{
    __weak QWBaseVC  *currentViewController;
}

@end

@implementation CoupnActivityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"优惠活动";
    self.viewControllerArray = [NSMutableArray array];

    [self setupViewController];
    [self setupSliderView];
}

- (void)setupViewController{
    
    DoingViewController *firstView = [[DoingViewController alloc]init];
    firstView.title=@"进行中";
    firstView.navigationController = self.navigationController;
    
    EndViewController *secondView = [[EndViewController alloc]init];
    secondView.title=@"已结束";
    secondView.navigationController = self.navigationController;
    
    currentViewController = firstView;
    [self.viewControllerArray addObject:firstView];
    [self.viewControllerArray addObject:secondView];
}

- (void)setupSliderView
{
    self.slideSwitchView = [[QCSlideSwitchView alloc]initWithFrame:CGRectMake(0,0, APP_W, APP_H)];
    self.slideSwitchView.tabItemNormalColor = RGBHex(qwColor6);
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
    [self.viewControllerArray[number] viewDidCurrentView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
