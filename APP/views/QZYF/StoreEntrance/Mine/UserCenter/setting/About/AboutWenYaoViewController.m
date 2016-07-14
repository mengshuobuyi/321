//
//  AboutWenYaoViewController.m
//  APP
//
//  Created by qwfy0006 on 15/3/18.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "AboutWenYaoViewController.h"
#import "SVProgressHUD.h"
#import "ServiceSpecificationViewController.h"
#import "AppDelegate.h"
#import "AboutWenYaoCell.h"

#define FunctionIntroduceUrl           API_APPEND_V2(@"api/helpClass/sjgnjs")
#define ServiceInformationUrl          API_APPEND_V2(@"api/helpClass/sjfwzn")
#define ServiceSpeciticationUrl         API_APPEND_V2(@"api/helpClass/sjfwtk")

@interface AboutWenYaoViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet  UITableView         *tbViewContent;

@property (strong, nonatomic) IBOutlet  UILabel             *lblVersionNum;
@property (strong, nonatomic)           NSString            *strDownload;

@property (strong, nonatomic)           NSArray             *titleArray;
@property (strong, nonatomic) IBOutlet  UIView              *headerView;
@property (weak, nonatomic)   IBOutlet  UILabel             *headerSepaterLine;

@end

@implementation AboutWenYaoViewController

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
    
    self.title = @"问药商家";
    self.titleArray = @[@"去评价",@"功能介绍",@"服务指南",@"服务规范"];
    
    self.tbViewContent.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tbViewContent.tableHeaderView = self.headerView;
    self.headerSepaterLine.backgroundColor = RGBAHex(qwColor10, 1);
    self.headerSepaterLine.frame = CGRectMake(self.headerSepaterLine.frame.origin.x, self.headerSepaterLine.frame.origin.y, self.headerSepaterLine.frame.size.width, 0.5);
    
    self.lblVersionNum.text=[NSString stringWithFormat:@"V%@",APP_VERSION];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tbViewContent reloadData];
}

- (NSInteger)getIntValueFromVersionStr:(NSString *)strVersion
{
    NSArray *arrVer = [strVersion componentsSeparatedByString:@"."];
    NSString *strVer = [arrVer componentsJoinedByString:@""];
    NSInteger intVer = [strVer integerValue];
    return intVer;
}

#pragma mark ---- 列表代理 ----

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"AboutWenYaoCell";
    AboutWenYaoCell * cell = (AboutWenYaoCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"AboutWenYaoCell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //功能介绍 首次安装加小红点
    
    if (indexPath.row == 1) {
        cell.redPoint.hidden = NO;
    }else{
        cell.redPoint.hidden = YES;
    }
    
    if ([QWUserDefault getBoolBy:isReadIntroduction]) {
        cell.redPoint.hidden = YES;
    }
    cell.titleLabel.text = self.titleArray[indexPath.row];
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
        [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试" duration:DURATION_SHORT];
        return;
    }
    
    if (indexPath.row == 0)
    {
        //去评价
        NSString  *nsStringToOpen = [NSString  stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/wen-yao-shang-jia/id945606633?mt=8"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nsStringToOpen]];
        
    } else if (indexPath.row == 1)
    {
        //功能介绍
        ServiceSpecificationViewController *serviceV = [[ServiceSpecificationViewController alloc]initWithNibName:@"ServiceSpecificationViewController" bundle:nil];
        serviceV.TitleStr = @"功能介绍";
        serviceV.UrlStr = FunctionIntroduceUrl;
        [self.navigationController pushViewController:serviceV animated:YES];
        
        [QWUserDefault setBool:YES key:isReadIntroduction];
        
    } else if (indexPath.row == 2)
    {
        //服务指南
        ServiceSpecificationViewController *serviceV = [[ServiceSpecificationViewController alloc]initWithNibName:@"ServiceSpecificationViewController" bundle:nil];
        serviceV.TitleStr = @"服务指南";
        serviceV.UrlStr = ServiceInformationUrl;
        [self.navigationController pushViewController:serviceV animated:YES];
        
    } else if (indexPath.row == 3)
    {
        //服务规范
        ServiceSpecificationViewController *serviceV = [[ServiceSpecificationViewController alloc]initWithNibName:@"ServiceSpecificationViewController" bundle:nil];
        serviceV.TitleStr = @"服务规范";
        serviceV.UrlStr = ServiceSpeciticationUrl;
        [self.navigationController pushViewController:serviceV animated:YES];
    }
}


#pragma mark - UIAlertView methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10000) {
        if (buttonIndex == 0) {
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.strDownload]];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
