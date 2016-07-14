//
//  ExpertSetMainViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/4.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ExpertSetMainViewController.h"
#import "ExpertSetMainCell.h"
#import "AboutWenYaoViewController.h"
#import "ServiceSpecificationViewController.h"
#import "NewMessageAwokeViewController.h"
#import "FeedbackViewController.h"
#import "CustomLogoutAlertView.h"
#import "ExpertSetPwdViewController.h"
#import "ExpertUpdatePwdViewController.h"

#define FunctionJiamentUrl          API_APPEND_V2(@"api/helpClass/sjqwys")  //全维药师介绍

@interface ExpertSetMainViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableFooterview;
@property (strong, nonatomic) NSArray *dataList;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

- (IBAction)logoutAction:(id)sender;

@end

@implementation ExpertSetMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    self.tableView.tableFooterView = self.tableFooterview;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.logoutBtn.layer.cornerRadius = 3.0;
    self.logoutBtn.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (QWGLOBALMANAGER.configure.expertIsSetPwd) {
        self.dataList = @[@"修改密码",@"新消息提醒",@"问药商家",@"意见反馈"];
    }else{
        self.dataList = @[@"设置新密码",@"新消息提醒",@"问药商家",@"意见反馈"];
    }
    [self.tableView reloadData];
}

#pragma mark ---- 列表代理 ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 8)];
    vi.backgroundColor = [UIColor clearColor];
    return vi;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpertSetMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExpertSetMainCell"];
    cell.title.text = self.dataList[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        if (QWGLOBALMANAGER.configure.expertIsSetPwd)
        {
            //修改密码
            ExpertUpdatePwdViewController *vc = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertUpdatePwdViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            //设置新密码
            ExpertSetPwdViewController *vc = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertSetPwdViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if (indexPath.section == 1)
    {
        //新消息提醒
        NewMessageAwokeViewController *vc = [[NewMessageAwokeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section == 2)
    {
        //问药商家
        if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
            [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试" duration:DURATION_SHORT];
            return;
        }
        AboutWenYaoViewController *viewControllerAbout = [[AboutWenYaoViewController alloc] initWithNibName:@"AboutWenYaoViewController" bundle:nil];
        [self.navigationController pushViewController:viewControllerAbout animated:YES];
        
    }else if (indexPath.section == 3)
    {
        //意见反馈
        if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
            [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试" duration:DURATION_SHORT];
            return;
        }
        FeedbackViewController *feed = [[FeedbackViewController alloc]initWithNibName:@"FeedbackViewController" bundle:nil];
        [self.navigationController pushViewController:feed animated:YES];
        
    }
    
}

#pragma mark ---- 退出登录 ----

- (IBAction)logoutAction:(id)sender
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
        [QWGLOBALMANAGER saveAppConfigure];
        [QWGLOBALMANAGER clearExpertAccountInformation];
        [QWUserDefault setBool:NO key:APP_LOGIN_STATUS];
        
        if (QWGLOBALMANAGER.configure.expertIsSetPwd) {
            [QWUserDefault setBool:YES key:@"expertupdatepassword"];
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
