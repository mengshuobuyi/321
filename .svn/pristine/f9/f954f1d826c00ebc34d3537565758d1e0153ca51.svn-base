//
//  SymptomDetailViewController.m
//  quanzhi
//
//  Created by Meng on 14-8-6.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "SymptomDetailViewController.h"
#import "Constant.h"
#import "BaseInfromationViewController.h"
#import "PossibleDiseaseViewController.h"
#import "ZhPMethod.h"
#import "Categorys.h"
#import "AppDelegate.h"
#import "LogInViewController.h"
#import "GlobalManager.h"
#import "Order.h"
#import "OrderMedelR.h"
#import "OrderModel.h"
#import "SVProgressHUD.h"
#import "UIViewController+isNetwork.h"
#define TAG_TITLE       1552
#define TAG_TITLE_DES   1553
#define TAG_DESC        1554
#define TAG_ARROW       1555
#define TAG_FONT_PANEL  1556
#define TAG_FONT_P_BG   1557
#define TAG_FAV_PAN     1558
#define TAG_FAV_BTN     1559
#define TAG_FAV_IMG     1560
#define EDGE            10
@interface SymptomDetailViewController ()<UIAlertViewDelegate>
{
    BOOL m_collected;
    __weak QWBaseVC  *currentViewController;
    UIImageView * buttonImage;
    
    NSInteger m_descFont;
    NSInteger m_titleFont;
    UIFont          *defaultFont;
    BOOL isUp;
}
@property (nonatomic ,strong)NSMutableArray * viewControllerArray;
@property (nonatomic ,strong) NSString *collectButtonImageName;
@end

@implementation SymptomDetailViewController

- (id)init{
    if (self = [super init]) {
        
        isUp = YES;
        m_descFont = kFontS4;
        m_titleFont = kFontS3;
        m_collected = NO;
    }
    return self;
}



- (void)backToPreviousController:(id)sender
{

    if(self.containerViewController) {
        [self.containerViewController.navigationController popViewControllerAnimated:YES];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}

- (void)dealloc
{
    _slideSwitchView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if([self isNetWorking]){
        [self addNetView];
        return;
    }
    [self initRightbutton];
    [self subViewDidLoad];
}
-(void)initRightbutton{
    UIBarButtonItem *button=[[UIBarButtonItem alloc]initWithTitle:@"Aa" style:UIBarButtonItemStylePlain target:self action:@selector(zoomButtonClick)];
    self.navigationItem.rightBarButtonItem=button;
}
- (void)BtnClick{
    
    if(![self isNetWorking]){
        for(UIView *v in [self.view subviews]){
            if(v.tag == 999){
                [v removeFromSuperview];
            }
        }
        [self subViewDidLoad];
    }
}

- (void)subViewDidLoad{
    
    if (iOSv7 && self.view.frame.origin.y==0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    m_collected = NO;
    self.viewControllerArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpViewController];
    [self setupSilderView];
    
    for(UIViewController *controller in self.viewControllerArray) {
        [controller viewWillAppear:YES];
    }
   
}

- (void)zoomButtonClick
{
    [currentViewController zoomClick];
}


- (void)setUpViewController{
    BaseInfromationViewController * baseInformation = [[BaseInfromationViewController alloc]init];
    PossibleDiseaseViewController * possibleDisease = [[PossibleDiseaseViewController alloc]init];
    baseInformation.spmCode = self.spmCode;
    possibleDisease.spmCode = self.spmCode;
    baseInformation.title = @"基本信息";
    possibleDisease.title = @"可能疾病";
    
    possibleDisease.containerViewController = self.containerViewController;
    currentViewController = baseInformation;
    [self.viewControllerArray addObject:baseInformation];
    [self.viewControllerArray addObject:possibleDisease];
}

- (void)setupSilderView
{
    self.slideSwitchView = [[QCSlideSwitchView alloc]initWithFrame:CGRectMake(0, 0, APP_W, APP_H-NAV_H)];
    self.slideSwitchView.tabItemNormalColor = [QCSlideSwitchView colorFromHexRGB:@"7c7c7c"];
    [self.slideSwitchView.topScrollView setBackgroundColor:RGBHex(qwColor11)];
    self.slideSwitchView.tabItemSelectedColor = RGBHex(qwColor1);
    self.slideSwitchView.slideSwitchViewDelegate = self;
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"activity_line_show"]
                                        stretchableImageWithLeftCapWidth:96.0f topCapHeight:0.0f];
    [self.slideSwitchView buildUI];
    [self.view addSubview:self.slideSwitchView];
}

- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view{
    return self.viewControllerArray.count;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number{
    return self.viewControllerArray[number];
}


- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    currentViewController = self.viewControllerArray[number];
    //如果是相关疾病页面  字体放大就隐藏
    if (number == 1) {
        [self.view viewWithTag:TAG_FAV_PAN].hidden = YES;
    }else{
        [self.view viewWithTag:TAG_FAV_PAN].hidden = NO;
    }
    [self.viewControllerArray[number] viewDidCurrentView];
}



@end
