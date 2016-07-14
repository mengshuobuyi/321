//
//  RecommendationListViewController.m
//  wenYao-store
//
//  Created by Martin.Liu on 16/6/3.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "RecommendationListViewController.h"
#import "QCSlideSwitchView.h"
#import "MyRecommendationViewController.h"
#import "MyRecommendMedicineViewController.h"

@interface RecommendationListViewController ()<QCSlideSwitchViewDelegate>
@property (nonatomic, strong) QCSlideSwitchView* slideSwitchView;
@end

@implementation RecommendationListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"我的推荐";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSlide];
}

- (void)setupSlide
{
    MyRecommendationViewController* recommendationVC = [[MyRecommendationViewController alloc] init];
    recommendationVC.title = @"推荐下载问药";
    [self addChildViewController:recommendationVC];
    
    MyRecommendMedicineViewController* recommendMedicineVC = [[MyRecommendMedicineViewController alloc] init];
    recommendMedicineVC.title = @"推荐预定商品";
    [self addChildViewController:recommendMedicineVC];
    
    
    self.slideSwitchView = [[QCSlideSwitchView alloc] initWithFrame:CGRectMake(0, 0, APP_W, APP_H-NAV_H)];
    self.slideSwitchView.tabItemNormalColor = RGBHex(qwColor6);
    [self.slideSwitchView.topScrollView setBackgroundColor:RGBHex(0xffffff)];
    self.slideSwitchView.tabItemSelectedColor = RGBHex(qwColor1);
    [self.slideSwitchView.rigthSideButton.titleLabel setFont:[UIFont systemFontOfSize:kFontS4]];
    self.slideSwitchView.slideSwitchViewDelegate = self;
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"activity_line_show"]
                                        stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)numberOfTab:(QCSlideSwitchView *)view {
    return self.childViewControllers.count;
}

-(UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number {
    return self.childViewControllers[number];
}

- (void)slideSwitchView:(QCSlideSwitchView *)view willselectTab:(NSUInteger)number {
//    [self.childViewControllers[number] viewWillAppear:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
