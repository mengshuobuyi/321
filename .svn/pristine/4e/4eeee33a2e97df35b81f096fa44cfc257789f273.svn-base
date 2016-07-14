//
//  ExpertLoginRootViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/4/18.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ExpertLoginRootViewController.h"
#import "QCSlideSwitchView.h"
#import "ExpertPasswordLoginViewController.h"
#import "ExpertRegisterViewController.h"

@interface ExpertLoginRootViewController ()<QCSlideSwitchViewDelegate>
{
    __weak QWBaseVC  *currentViewController;
}

@property (nonatomic, strong) NSMutableArray *viewControllerArray;
@property (nonatomic ,strong) QCSlideSwitchView * slideSwitchView;

@property (nonatomic, strong) ExpertRegisterViewController *registerVC;

@end

@implementation ExpertLoginRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"问药－专家";
    self.viewControllerArray = [NSMutableArray array];
    
    //初始化界面数组
    [self setupViewController];
    
    //设置sliderView
    [self setupSliderView];
    
    [self setUpRightItem];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if (self.registerVC) {
        [self.registerVC viewWillAppear:animated];
    }

    if([QWUserDefault getBoolBy:APP_LOGIN_STATUS])
    {
        if ([[QWUserDefault getObjectBy:@"noNeedFade"] isEqualToString:@"1"]) {
            [QWUserDefault removeObjectBy:@"noNeedFade"];
        }else{
            [[UIApplication sharedApplication].keyWindow addSubview:QWGLOBALMANAGER.fadeCover];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)setUpRightItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(expertRegisterAction)];;
}

#pragma mark ---- 专家注册 ----
- (void)expertRegisterAction
{
    ExpertRegisterViewController *vc = [[UIStoryboard storyboardWithName:@"ExpertLogin" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertRegisterViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.jumpType = 2;
    vc.navigationController = self.navigationController;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---- 初始化界面数组 ---
- (void)setupViewController{
    
    ExpertPasswordLoginViewController *vc1 = [[UIStoryboard storyboardWithName:@"ExpertLogin" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertPasswordLoginViewController"];
    vc1.title=@"密码登录";
    vc1.navigationController = self.navigationController;
    
    self.registerVC = [[UIStoryboard storyboardWithName:@"ExpertLogin" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertRegisterViewController"];
    self.registerVC.navigationController = self.navigationController;
    self.registerVC.jumpType = 3;
    
    currentViewController = vc1;
    self.viewControllerArray = [NSMutableArray arrayWithObjects:vc1,self.registerVC, nil];
}

- (void)setupSliderView
{
    self.slideSwitchView = [[QCSlideSwitchView alloc]initWithFrame:CGRectMake(0, 0, APP_W, APP_H - 44)];
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
    self.slideSwitchView.rootScrollView.scrollEnabled = YES;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
