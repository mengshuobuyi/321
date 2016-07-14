//
//  SetMainViewController.m
//  APP
//
//  Created by qwfy0006 on 15/3/17.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "SetMainViewController.h"
#import "AccoutViewController.h"
#import "AboutWenYaoViewController.h"
#import "AppDelegate.h"
#import "NewMessageAwokeViewController.h"
#import "ServiceSpecificationViewController.h"
#import "CustomLogoutAlertView.h"
#import "SVProgressHUD.h"
#import "FeedbackViewController.h"
#import "SetMainCell.h"

#define FunctionJiamentUrl          API_APPEND_V2(@"api/helpClass/sjqwys")  //全维药师介绍

@interface SetMainViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *logoutView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *quitButton;
@property (strong ,nonatomic) NSMutableArray *ListTitleArr;

// 退出登录
- (IBAction)quickOutAction:(id)sender;

@end

@implementation SetMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设置";
    self.view.backgroundColor = RGBHex(qwColor11);
    
//    if (AUTHORITY_ROOT) {
//        self.ListTitleArr = [NSMutableArray arrayWithObjects:@[@"账号管理",@"新消息提醒"],@[@"问药商家",@"全维药事介绍"], nil];
//    }else{
//        self.ListTitleArr = [NSMutableArray arrayWithObjects:@[@"账号管理"],@[@"问药商家",@"全维药事介绍"], nil];
//    }
    
    self.ListTitleArr = [NSMutableArray arrayWithObjects:@[@"帐号管理",@"新消息提醒"],@[@"问药商家",@"全维药事介绍"], nil];

    // 设置退出按钮
    self.quitButton.layer.cornerRadius = 3.0;
    self.quitButton.layer.masksToBounds = YES;
    
    self.tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableview.tableFooterView = self.logoutView;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
        [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试" duration:DURATION_SHORT];
    }
    [self.tableview reloadData];
}

#pragma mark ---- 列表代理 ----

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.ListTitleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(NSArray *)[self.ListTitleArr objectAtIndex:section]count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SetMainCell getCellHeight:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SetMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetMainCell"];
    cell.textLabel.textColor = RGBHex(qwColor6);
    cell.textLabel.font = fontSystem(kFontS1);
    cell.textLabel.text=self.ListTitleArr[indexPath.section][indexPath.row];
    
    //功能介绍 首次安装加小红点
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.redPoint.hidden = NO;
    }else{
        cell.redPoint.hidden = YES;
    }
    
    if ([QWUserDefault getBoolBy:isReadIntroduction]) {
        cell.redPoint.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0&&indexPath.section==0)
    {
        //账号管理
        
        if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
            [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试" duration:DURATION_SHORT];
            return;
        }
        AccoutViewController *accoutV = [[UIStoryboard storyboardWithName:@"SetMain" bundle:nil] instantiateViewControllerWithIdentifier:@"AccoutViewController"];
        [self.navigationController pushViewController:accoutV animated:YES];
        
    }else if (indexPath.row == 1&&indexPath.section==0)
    {
        //新消息提醒
        
        NewMessageAwokeViewController *vc = [[NewMessageAwokeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (indexPath.row == 0&&indexPath.section==1)
    {
        //关于问药
        
        if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
            [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试" duration:DURATION_SHORT];
            return;
        }
        AboutWenYaoViewController *viewControllerAbout = [[AboutWenYaoViewController alloc] initWithNibName:@"AboutWenYaoViewController" bundle:nil];
        [self.navigationController pushViewController:viewControllerAbout animated:YES];
        
    } else if (indexPath.row == 1&&indexPath.section==1)
    {
        //全维药事介绍
        
        if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
            [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试" duration:DURATION_SHORT];
            return;
        }
        
        ServiceSpecificationViewController *serviceV = [[ServiceSpecificationViewController alloc]initWithNibName:@"ServiceSpecificationViewController" bundle:nil];
        serviceV.TitleStr = @"全维药事介绍";
        serviceV.UrlStr = FunctionJiamentUrl;
        [self.navigationController pushViewController:serviceV animated:YES];
        
    }
//    else if(indexPath.section==2)
//    {
//        //意见反馈
//        
//        if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
//            [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试" duration:DURATION_SHORT];
//            return;
//        }
//        
//        FeedbackViewController *feed = [[FeedbackViewController alloc]initWithNibName:@"FeedbackViewController" bundle:nil];
//        [self.navigationController pushViewController:feed animated:YES];
//        
//    }
}


#pragma mark ---- 退出登录 ----

- (IBAction)quickOutAction:(id)sender
{
    
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"不了",@"好的", nil];
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"CustomLogoutAlertView" owner:self options:nil];
    CustomLogoutAlertView *viewLogout = [nibViews objectAtIndex:0];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        [alertV setValue:viewLogout forKey:@"accessoryView"];
    }else{
        [alertV addSubview:viewLogout];
    }
    [alertV show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [QWGLOBALMANAGER postNotif:NotifQuitOut data:nil object:nil];
        QWGLOBALMANAGER.configure.passWord = @"";
        [QWGLOBALMANAGER saveAppConfigure];
        [QWGLOBALMANAGER clearAccountInformation];
        [QWUserDefault setBool:NO key:APP_LOGIN_STATUS];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
