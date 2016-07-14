//
//  ConsultPharmacyViewController.m
//  wenyao
//
//  Created by xiezhenghong on 14-9-17.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "BranchViewController.h"
#import "BranchCoupnViewController.h"
#import "BranchProductViewController.h"
#import "Coupn.h"
#import "DiscountSearchDrugViewController.h"

@interface BranchViewController ()<UISearchBarDelegate>
{
    __weak QWBaseVC  *currentViewController;
    __weak QWBaseVC  *everViewController;
    UIBarButtonItem             *searchBarButton;
}

// 显示的view数组
@property (strong, nonatomic) NSMutableArray *viewControllerArray;
@property (strong, nonatomic) UISegmentedControl *segementView ;

@end

@implementation BranchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置选择器
    [self setUpSegmentView];
    
    // 设置页面数组
    [self setupViewController];
    
    // 优惠商品 搜索按钮
    searchBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navBar_icon_search_white"] style:UIBarButtonItemStylePlain target:self action:@selector(searchBarButtonClick)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.navigationController.navigationBarHidden==YES){
        // 进入搜索页面 返回到优惠商品
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        self.segementView.selectedSegmentIndex=1;
    }
}

#pragma mark ---- 设置选择器 ----

-(void)setUpSegmentView
{
    self.segementView = [[UISegmentedControl alloc]initWithItems:@[@"优惠券",@"优惠商品"]];
    self.segementView.frame = CGRectMake(0, 0, 150, 30);
    
    NSDictionary *dicSelected = [NSDictionary dictionaryWithObjectsAndKeys:RGBHex(qwColor1),UITextAttributeTextColor,  fontSystem(kFontS5),UITextAttributeFont ,[UIColor clearColor],UITextAttributeTextShadowColor ,nil];
    [self.segementView setTitleTextAttributes:dicSelected forState:UIControlStateSelected];
    NSDictionary *dicNormal = [NSDictionary dictionaryWithObjectsAndKeys:RGBHex(qwColor4),UITextAttributeTextColor,  fontSystem(kFontS5),UITextAttributeFont ,[UIColor clearColor],UITextAttributeTextShadowColor ,nil];
    [self.segementView setTitleTextAttributes:dicNormal forState:UIControlStateNormal];
    self.segementView.selectedSegmentIndex=0;
    [self.segementView addTarget:self action:@selector(segementAction:)forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView=self.segementView;
}

#pragma mark ---- 设置页面数组 ----

- (void)setupViewController{
    
    self.viewControllerArray = [NSMutableArray array];
    
    BranchCoupnViewController *firstView = [[BranchCoupnViewController alloc]init];
    firstView.navigationController = self.navigationController;
    firstView.vcController=self;
    firstView.couponFromIM = self.isFromIM;
    
    BranchProductViewController *secondView = [[BranchProductViewController alloc]init];
//    secondView.navigationController = self.navigationController;
    secondView.vcController=self;
    secondView.productFromIM = self.isFromIM;
    
    currentViewController = firstView;
    everViewController =secondView;
    [self.viewControllerArray addObject:firstView];
    [self.viewControllerArray addObject:secondView];
    
    [self.view addSubview:firstView.view];
    [self.view addSubview:secondView.view];
    
    currentViewController.view.hidden=NO;
    everViewController.view.hidden=YES;
    
}

-(DrugVo *)changeModel:(BranchSearchPromotionProVO*)model{
    DrugVo *mod=[DrugVo new];
    mod.proId=model.proId;
    mod.proName=model.proName;
    mod.spec=model.spec;
    mod.factoryName=model.factory;
    mod.imgUrl=model.imgUrl;
    mod.pid=model.promotionId;
    mod.label=model.lable;
    mod.source=model.source;
    mod.beginDate=model.startDate;
    mod.endDate=model.endDate;
    return mod;
}

#pragma mark ---- 优惠商品搜索 ----

- (void)searchBarButtonClick
{
    if(self.SendNewBranch)
    {
        // IM 搜索优惠商品
        DiscountSearchDrugViewController *vc = [DiscountSearchDrugViewController new];
        vc.SendNewProduct = ^(BranchSearchPromotionProVO *productModel){
            DrugVo *modelDrug=[self changeModel:productModel];
            self.SendNewBranch(nil,modelDrug);
        };
      [self.navigationController pushViewController:vc animated:NO];
    }
    else{
        // 搜索优惠商品
        DiscountSearchDrugViewController *vc = [[DiscountSearchDrugViewController alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
    }
}

#pragma mark ---- segment 点击 ----

- (void)segementAction:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            currentViewController=self.viewControllerArray[0];
            everViewController=self.viewControllerArray[1];
            currentViewController.view.hidden=NO;
            everViewController.view.hidden=YES;
            self.navigationItem.rightBarButtonItems = @[];
            break;
        case 1:
            currentViewController=self.viewControllerArray[1];
            everViewController=self.viewControllerArray[0];
            currentViewController.view.hidden=NO;
            everViewController.view.hidden=YES;
            self.navigationItem.rightBarButtonItems = @[searchBarButton];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
