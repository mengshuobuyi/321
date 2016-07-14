//
//  OrganAuthTotalViewController.m
//  wenYao-store
//
//  Created by YYX on 15/8/19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "OrganAuthTotalViewController.h"
#import "OrganAuthEditViewController.h"
#import "OrganInfoEditViewController.h"
#import "AppDelegate.h"

@interface OrganAuthTotalViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;

@property (strong, nonatomic) IBOutlet UIView *tableFooterView;

@property (weak, nonatomic) IBOutlet UIButton *oneButton;

@property (weak, nonatomic) IBOutlet UIButton *twoButton;

@property (weak, nonatomic) IBOutlet UIButton *threeButton;

- (IBAction)organAuthOneAction:(id)sender;

- (IBAction)organAuthTwoAction:(id)sender;

- (IBAction)organAuthThreeAction:(id)sender;

@end

@implementation OrganAuthTotalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"机构认证";
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.tableFooterView = self.tableFooterView;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableHeaderView.backgroundColor = RGBHex(qwColor11);
    [self configureUI];
}

- (void)configureUI
{
    self.oneButton.layer.cornerRadius = 3.0;
    self.oneButton.layer.masksToBounds = YES;
    self.oneButton.layer.borderColor = RGBHex(qwColor1).CGColor;
    self.oneButton.layer.borderWidth = 1.0;
    self.twoButton.layer.cornerRadius = 3.0;
    self.twoButton.layer.masksToBounds = YES;
    self.twoButton.layer.borderColor = RGBHex(qwColor1).CGColor;
    self.twoButton.layer.borderWidth = 1.0;
    self.threeButton.layer.cornerRadius = 3.0;
    self.threeButton.layer.masksToBounds = YES;
    self.threeButton.layer.borderColor = RGBHex(qwColor1).CGColor;
    self.threeButton.layer.borderWidth = 1.0;
    [self.oneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.oneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.twoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.twoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.threeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.threeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
}

#pragma mark ---- UITableViewDelegate ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"ScoreRankDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell ==  nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    return cell;
}


#pragma mark ---- 我是连锁药房/医疗机构 ----

- (IBAction)organAuthOneAction:(id)sender
{
    OrganAuthEditViewController *vc = [[UIStoryboard storyboardWithName:@"OrganAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"OrganAuthEditViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    UITabBarController      *tabBarController = ((UITabBarController *)app.window.rootViewController);
    UINavigationController  *navgationController = [[tabBarController viewControllers] objectAtIndex:tabBarController.selectedIndex];
    [navgationController pushViewController:vc animated:YES];
}

#pragma mark ---- 我是单体药房 ----

- (IBAction)organAuthTwoAction:(id)sender
{
    OrganInfoEditViewController *vc = [[UIStoryboard storyboardWithName:@"OrganAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"OrganInfoEditViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.organType = 2;
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    UITabBarController      *tabBarController = ((UITabBarController *)app.window.rootViewController);
    UINavigationController  *navgationController = [[tabBarController viewControllers] objectAtIndex:tabBarController.selectedIndex];
    [navgationController pushViewController:vc animated:YES];
}

#pragma mark ---- 我是医疗机构 ----

- (IBAction)organAuthThreeAction:(id)sender
{
    OrganInfoEditViewController *vc = [[UIStoryboard storyboardWithName:@"OrganAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"OrganInfoEditViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.organType = 3;
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    UITabBarController      *tabBarController = ((UITabBarController *)app.window.rootViewController);
    UINavigationController  *navgationController = [[tabBarController viewControllers] objectAtIndex:tabBarController.selectedIndex];
    [navgationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
