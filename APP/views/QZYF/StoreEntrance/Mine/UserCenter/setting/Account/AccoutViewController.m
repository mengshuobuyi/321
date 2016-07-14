//
//  AccoutViewController.m
//  APP
//
//  Created by qwfy0006 on 15/3/17.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "AccoutViewController.h"
#import "ChangePwdViewController.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "SVProgressHUD.h"

@interface AccoutViewController ()

// 账号
@property (strong, nonatomic) IBOutlet UILabel *lbl_accountName;

// 修改密码
- (IBAction)changePwdAction:(id)sender;

@end

@implementation AccoutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.title = @"账号管理";
    self.lbl_accountName.text = QWGLOBALMANAGER.configure.userName;
}

#pragma mark ---- 修改密码 ----

- (IBAction)changePwdAction:(id)sender
{
    if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
        [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试" duration:DURATION_SHORT];
        return;
    }
    ChangePwdViewController *changV = [[ChangePwdViewController alloc] initWithNibName:@"ChangePwdViewController" bundle:nil];
    [self.navigationController pushViewController:changV animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
