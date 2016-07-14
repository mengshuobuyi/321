//
//  ExpertAuthViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 15/12/29.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "ExpertAuthViewController.h"
#import "LaunchEntranceViewController.h"
#import "ProfessionCardViewController.h"
#import "NutritionCardViewController.h"
@interface ExpertAuthViewController ()

//职业药师
@property (weak, nonatomic) IBOutlet UIButton *professionBtn;
//营养药师
@property (weak, nonatomic) IBOutlet UIButton *nutritionBtn;

- (IBAction)professionAction:(id)sender;

- (IBAction)nutritionAction:(id)sender;

@end

@implementation ExpertAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"专家认证";
    [self configureUI];
}

#pragma mark ---- 设置UI ----
- (void)configureUI
{
    self.professionBtn.layer.cornerRadius = 4.0;
    self.professionBtn.layer.masksToBounds = YES;
    self.professionBtn.layer.borderColor = RGBHex(qwColor10).CGColor;
    self.professionBtn.layer.borderWidth = 0.5;
    
    self.nutritionBtn.layer.cornerRadius = 4.0;
    self.nutritionBtn.layer.masksToBounds = YES;
    self.nutritionBtn.layer.borderColor = RGBHex(qwColor10).CGColor;
    self.nutritionBtn.layer.borderWidth = 0.5;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setHidesBackButton:YES];
    [self naviLeftBottonImage:[UIImage imageNamed:@"ic_whiteclose"] action:@selector(backAction)];
    //侧滑禁止
    ((QWBaseNavigationController *)self.navigationController).canDragBack = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //侧滑开启
    ((QWBaseNavigationController *)self.navigationController).canDragBack = YES;
}

#pragma mark ---- 返回按钮 ----
- (void)naviLeftBottonImage:(UIImage*)aImg action:(SEL)action{
    
    CGFloat margin=10;
    CGFloat ww=40, hh=44;
    CGFloat bw,bh;
    bw=aImg.size.width;
    bh=aImg.size.height;
    
    CGRect frm = CGRectMake(0,0,ww,hh);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frm;
    [btn setImage:aImg forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake((hh-bh)/2, margin, (hh-bh)/2, ww-margin-bw)];
    
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.backgroundColor=[UIColor clearColor];
    
    
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = -13;
    
    UIBarButtonItem* btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItems = @[fixed,btnItem];
}

#pragma mark ---- 返回Action ----
- (void)backAction
{
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIViewController *viewController=(UIViewController *)obj;
        if ([viewController isKindOfClass:[LaunchEntranceViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
            
            //清除登陆信息
            [QWGLOBALMANAGER clearExpertAccountInformation];
            
        }else if(idx == (self.navigationController.viewControllers.count - 1)){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark ---- 我是职业药师 ----
- (IBAction)professionAction:(id)sender
{
    ProfessionCardViewController *vc = [[UIStoryboard storyboardWithName:@"ExpertAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"ProfessionCardViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---- 我是营养师 ----
- (IBAction)nutritionAction:(id)sender
{
    NutritionCardViewController *vc = [[UIStoryboard storyboardWithName:@"ExpertAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"NutritionCardViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
