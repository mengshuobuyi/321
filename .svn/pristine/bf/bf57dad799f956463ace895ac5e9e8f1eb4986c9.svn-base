//
//  ExpertAuthCommitViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/5.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ExpertAuthCommitViewController.h"
#import "LaunchEntranceViewController.h"

@interface ExpertAuthCommitViewController ()

@end

@implementation ExpertAuthCommitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setHidesBackButton:YES];
    [self naviLeftBottonImage:[UIImage imageNamed:@"ic_whiteclose"] action:@selector(backAction)];
    ((QWBaseNavigationController *)self.navigationController).canDragBack = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    ((QWBaseNavigationController *)self.navigationController).canDragBack = YES;
}

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
            
            //设置退出登陆
            QWGLOBALMANAGER.loginStatus = NO;
            [QWGLOBALMANAGER postNotif:NotifQuitOut data:nil object:self];
            [QWGLOBALMANAGER releaseMessageTimer];
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            if (QWGLOBALMANAGER.tabBar) {
                UINavigationController *navgationController = QWGLOBALMANAGER.tabBar.viewControllers[0];
                navgationController.tabBarItem.badgeValue = nil;
                [navgationController popToRootViewControllerAnimated:NO];
                navgationController = QWGLOBALMANAGER.tabBar.viewControllers[1];
                [navgationController popToRootViewControllerAnimated:NO];
            }
            [QWUserDefault setBool:NO key:APP_LOGIN_STATUS];
            QWGLOBALMANAGER.configure.expertToken = @"";
            [QWGLOBALMANAGER saveAppConfigure];
            QWGLOBALMANAGER.tabBar = nil;
        }else if(idx == (self.navigationController.viewControllers.count - 1)){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
