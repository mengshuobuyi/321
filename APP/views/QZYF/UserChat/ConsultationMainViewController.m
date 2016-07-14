//
//  ConsultationMainViewController.m
//  wenYao-store
//
//  Created by 李坚 on 16/3/4.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ConsultationMainViewController.h"
#import "QCSlideSwitchView.h"

#import "PrivateMessageListViewController.h"
#import "InterlocuationViewController.h"

@interface ConsultationMainViewController ()<QCSlideSwitchViewDelegate>

@property (nonatomic, strong) UISegmentedControl *segementView;
@property (nonatomic ,strong) NSMutableArray * viewControllerArray;
@property (nonatomic ,strong) QCSlideSwitchView * slideSwitchView;

@end

@implementation ConsultationMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupSegmentView];
    [self setupViewControllers];
    [self setupSliderView];
}

#pragma mark - 建立SegmentViewControl控件
- (void)setupSegmentView{
    
    _segementView = [[UISegmentedControl alloc]initWithItems:@[@"私聊",@"问答"]];
    _segementView.frame = CGRectMake(0, 0, 110, 30);
    _segementView.tintColor = [UIColor whiteColor];
    NSDictionary *dicSelected = [NSDictionary dictionaryWithObjectsAndKeys:RGBHex(qwMcolor3),UITextAttributeTextColor,  fontSystem(14.0f),UITextAttributeFont ,[UIColor clearColor],UITextAttributeTextShadowColor ,nil];
    [_segementView setTitleTextAttributes:dicSelected forState:UIControlStateSelected];
    NSDictionary *dicNormal = [NSDictionary dictionaryWithObjectsAndKeys:RGBHex(qwMcolor4),UITextAttributeTextColor,  fontSystem(14.0f),UITextAttributeFont ,[UIColor clearColor],UITextAttributeTextShadowColor ,nil];
    [_segementView setTitleTextAttributes:dicNormal forState:UIControlStateNormal];
    
    _segementView.selectedSegmentIndex = 0;
    [_segementView addTarget:self action:@selector(segementAction:)forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView=_segementView;
}

#pragma mark - SegmentViewControlAction
- (void)segementAction:(id)sender{
    
    [self.slideSwitchView jumpToTabAtIndex:_segementView.selectedSegmentIndex];
}

#pragma mark - VC建立
- (void)setupViewControllers{
    
    self.viewControllerArray = [NSMutableArray new];
    
    PrivateMessageListViewController *PrivateMessageList = [[PrivateMessageListViewController alloc]init];
    PrivateMessageList.navController = self.navigationController;
    [self.viewControllerArray addObject:PrivateMessageList];
    
    InterlocuationViewController *InterlocutionList = [[InterlocuationViewController alloc]init];
    InterlocutionList.navController = self.navigationController;
    [self.viewControllerArray addObject:InterlocutionList];
    
    self.slideSwitchView.viewArray = self.viewControllerArray;
}

#pragma mark - 建立slideView
- (void)setupSliderView{

    self.slideSwitchView = [[QCSlideSwitchView alloc]initWithFrame:CGRectMake(0, -35, APP_W, APP_H-NAV_H + 35)];
    
    [self.slideSwitchView.topScrollView setBackgroundColor:RGBHex(qwMcolor4)];
    self.slideSwitchView.tabItemSelectedColor = RGBHex(qwMcolor1);
    self.slideSwitchView.tabItemNormalColor = RGBHex(qwGcolor6);
    
    [self.slideSwitchView.rigthSideButton.titleLabel setFont:fontSystem(kFontS4)];
    self.slideSwitchView.slideSwitchViewDelegate = self;
    self.slideSwitchView.rootScrollView.scrollEnabled = NO;
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"red_line_and_shadow.png"]
                                        stretchableImageWithLeftCapWidth:84.0f topCapHeight:0.0f];
    
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
