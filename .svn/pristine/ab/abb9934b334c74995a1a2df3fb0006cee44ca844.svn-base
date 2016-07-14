//
//  LaunchEntranceViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 15/12/29.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "LaunchEntranceViewController.h"
#import "LoginViewController.h"
//#import "ExpertLoginViewController.h"
#import "ExpertLoginRootViewController.h"

@interface LaunchEntranceViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImage_layout_height;

@property (weak, nonatomic) IBOutlet UIButton *storeEntranceBtn;

@property (weak, nonatomic) IBOutlet UIButton *expertEntranceBtn;

- (IBAction)storeAction:(id)sender;

- (IBAction)expertAction:(id)sender;

@end

@implementation LaunchEntranceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureUI];
}

- (void)configureUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.storeEntranceBtn.layer.cornerRadius = 3.0;
    self.storeEntranceBtn.layer.masksToBounds = YES;
    self.storeEntranceBtn.layer.borderColor = RGBHex(qwColor1).CGColor;
    self.storeEntranceBtn.layer.borderWidth = 1.0;
    self.expertEntranceBtn.layer.cornerRadius = 3.0;
    self.expertEntranceBtn.layer.masksToBounds = YES;
    self.expertEntranceBtn.layer.borderColor = RGBHex(qwColor1).CGColor;
    self.expertEntranceBtn.layer.borderWidth = 1.0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.topImage_layout_height.constant = APP_W*170/320;
    // 禁止侧滑
    ((QWBaseNavigationController *)self.navigationController).canDragBack = NO;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    ((QWBaseNavigationController *)self.navigationController).canDragBack = YES;
}


#pragma mark ---- 门店入口----
- (IBAction)storeAction:(id)sender
{
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---- 专家入口----
- (IBAction)expertAction:(id)sender
{
    ExpertLoginRootViewController *vc = [[UIStoryboard storyboardWithName:@"ExpertLogin" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertLoginRootViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    [QWUserDefault setObject:@"1" key:@"noNeedFade"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
