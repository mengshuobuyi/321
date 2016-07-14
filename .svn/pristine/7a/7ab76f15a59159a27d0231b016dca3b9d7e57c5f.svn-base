//
//  MyIndentViewController.m
//  APP
//
//  Created by qw_imac on 15/12/29.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "MyIndentViewController.h"
#import "QCSlideSwitchView.h"
#import "IndentDetailViewController.h"
#import "OrganAuthTotalViewController.h"
#import "OrganAuthCommitOkViewController.h"
#import "WebDirectViewController.h"
@interface MyIndentViewController ()<QCSlideSwitchViewDelegate>
{
    NSMutableArray *viewControllers;
}
@property (nonatomic,strong) QCSlideSwitchView *slideSwitchView;
@property (strong, nonatomic) OrganAuthTotalViewController *vcOrganAuthTotal;
@property (strong, nonatomic) OrganAuthCommitOkViewController *vcOrganAuthCommitOk;
@end

@implementation MyIndentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviBtn];
    self.title = @"订单";
    if (!OrganAuthPass)
    {
        if ([QWGLOBALMANAGER.configure.approveStatus integerValue] == 4 || [QWGLOBALMANAGER.configure.approveStatus integerValue] == 2)
        {
            self.vcOrganAuthTotal = [[UIStoryboard storyboardWithName:@"OrganAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"OrganAuthTotalViewController"];
            [self.view addSubview:self.vcOrganAuthTotal.view];
            return;
            
            
        }else if ([QWGLOBALMANAGER.configure.approveStatus integerValue] == 1)
        {
            self.vcOrganAuthCommitOk = [[UIStoryboard storyboardWithName:@"OrganAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"OrganAuthCommitOkViewController"];
            [self.view addSubview:self.vcOrganAuthCommitOk.view];
            return;
        }
    }

    
    viewControllers = [[NSMutableArray alloc]init];
    
    [self setViewControllers];

    // Do any additional setup after loading the view.
}

-(void)setNaviBtn {
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,120, 40)];
    btn.titleLabel.font = fontSystem(kFontS1);
    [btn setTitle:@"如何处理订单？" forState:UIControlStateNormal];
    [btn setTitleColor:RGBHex(qwColor4) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(howDealTheOrders) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *naviBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = -20;
    
    self.navigationItem.rightBarButtonItems=@[fixed,naviBtn];
//    self.navigationItem.rightBarButtonItem = naviBtn;
}

-(void)howDealTheOrders {
    [QWGLOBALMANAGER statisticsEventId:@"订单_如何处理订单" withLable:nil withParams:nil];
    WebDirectViewController *vcWebMedicine = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
    WebDirectLocalModel *modelLocal = [WebDirectLocalModel new];
    modelLocal.typeLocalWeb = WebLocalTypeOuterLink;
    modelLocal.title = @"日常处理订单";
    modelLocal.url = [NSString stringWithFormat:@"%@QWSH/web/guide/html/cldd/clddjs.html",H5_BASE_URL];
    vcWebMedicine.shouldNotGoback = YES;
    [vcWebMedicine setWVWithLocalModel:modelLocal];
    [self.navigationController pushViewController:vcWebMedicine animated:YES];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!OrganAuthPass)
    {
        if ([QWGLOBALMANAGER.configure.approveStatus integerValue] == 4 || [QWGLOBALMANAGER.configure.approveStatus integerValue] == 2)
        {
            self.vcOrganAuthTotal = [[UIStoryboard storyboardWithName:@"OrganAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"OrganAuthTotalViewController"];
            [self.view addSubview:self.vcOrganAuthTotal.view];
            return;
            
            
        }else if ([QWGLOBALMANAGER.configure.approveStatus integerValue] == 1)
        {
            self.vcOrganAuthCommitOk = [[UIStoryboard storyboardWithName:@"OrganAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"OrganAuthCommitOkViewController"];
            [self.view addSubview:self.vcOrganAuthCommitOk.view];
            return;
        }
    }else {
        if (_index != OrdersIndexUnJump) {
            [self.slideSwitchView jumpToTabAtIndex:_index];
            _index = OrdersIndexUnJump;
        }
    }
}

- (void)jumpToIndexPage:(OrdersIndex)index
{
    [self.slideSwitchView jumpToTabAtIndex:index];
//    _index = OrdersIndexUnJump;
}

#pragma mark - QCSlideViewController
-(void)setViewControllers {
    IndentDetailViewController *VC5 = [IndentDetailViewController new];
    VC5.title = @"全部";
    VC5.status = @"0";
    VC5.navi = self.navigationController;
    VC5.tipsStatus = OrdersTipsAll;
    [viewControllers addObject:VC5];
    
    IndentDetailViewController *VC1 = [IndentDetailViewController new];
    VC1.title = @"待接单";
    VC1.status = @"1";
    VC1.navi = self.navigationController;
    [viewControllers addObject:VC1];
    
    IndentDetailViewController *VC2= [IndentDetailViewController new];
    VC2.title = @"待配送";
    VC2.status = @"2";
    VC2.navi = self.navigationController;
    [viewControllers addObject:VC2];
    
    IndentDetailViewController *VC3 = [IndentDetailViewController new];
    VC3.title = @"配送中";
    VC3.status = @"3";
    VC3.navi = self.navigationController;
    [viewControllers addObject:VC3];
    
    IndentDetailViewController *VC4 = [IndentDetailViewController new];
    VC4.title = @"待取货";
    VC4.status = @"6";
    VC4.navi = self.navigationController;
    [viewControllers addObject:VC4];
    
    
    [self setupSlide];
}

-(void)setupSlide {
    self.slideSwitchView = [[QCSlideSwitchView alloc]initWithFrame:CGRectMake(0, 0, APP_W, APP_H-NAV_H)];
    self.slideSwitchView.tabItemNormalColor = [QCSlideSwitchView colorFromHexRGB:@"666666"];
    [self.slideSwitchView.topScrollView setBackgroundColor:RGBHex(0xffffff)];
    self.slideSwitchView.tabItemSelectedColor = RGBHex(0x6ac5b6);
    [self.slideSwitchView.rigthSideButton.titleLabel setFont:fontSystem(14)];
    self.slideSwitchView.slideSwitchViewDelegate = self;
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"activity_line_show"]
                                        stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];

    self.slideSwitchView.isSpecial = YES;

    DebugLog(@"%f",self.slideSwitchView.shadowImage.size.height);
    self.slideSwitchView.isIndentAdjust=YES;
    [self.slideSwitchView buildUI];
    CGFloat height;
    height = 38.5;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, height, APP_W, 0.5)];
    line.backgroundColor = RGBHex(0xe0e0e0);
    [self.slideSwitchView addSubview:line];
    self.slideSwitchView.rootScrollView.scrollEnabled = YES;
    [self.view addSubview:self.slideSwitchView];
}

-(NSUInteger)numberOfTab:(QCSlideSwitchView *)view {
    return viewControllers.count;
}

-(UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number {
    return viewControllers[number];
}

- (void)slideSwitchView:(QCSlideSwitchView *)view willselectTab:(NSUInteger)number {
    [viewControllers[number] viewWillAppear:NO];
}

@end
