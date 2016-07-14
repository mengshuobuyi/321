//
//  PerfectInfoViewController.m
//  wenYao-store
//
//  Created by qwfy0006 on 15/4/1.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "PerfectInfoViewController.h"
#import "CompanyViewController.h"
#import "UserInfoViewController.h"
#import "IcenseViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"

@interface PerfectInfoViewController ()<finishUserInfoDelegate,finishcompanyInfoDelegate>

- (IBAction)nextStepAction:(id)sender;
- (IBAction)companyAction:(id)sender;
- (IBAction)userInfoAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *img_company;
@property (strong, nonatomic) IBOutlet UIImageView *img_user;
@property (strong, nonatomic) IBOutlet UIImageView *sliderright;
@property (strong, nonatomic) IBOutlet UIImageView *sliderleft;

@end

@implementation PerfectInfoViewController

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
    self.title = @"注册";
    self.sliderleft.backgroundColor = [UIColor colorWithRed:69/255.0f green:192/255.0f blue:26/255.0f alpha:1];
    self.sliderright.backgroundColor = [UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1];
    self.sliderleft.layer.cornerRadius = 5.0f;
    self.sliderleft.layer.masksToBounds = YES;
    self.sliderright.layer.cornerRadius = 5.0f;
    self.sliderright.layer.masksToBounds = YES;
    
    if (self.comefromWrite == NO) {
        [self pushStore];
    }
    if ([QWUserDefault getBoolBy:REGISTER_JG_FINISHCOMPANYINFO]) {
        self.img_company.image = [UIImage imageNamed:@"选中的勾号"];
    }
    if ([QWUserDefault getBoolBy:REGISTER_JG_FINISHUSERINFO]) {
        self.img_user.image = [UIImage imageNamed:@"选中的勾号"];
    }
}

-(void)pushStore{
    
    CompanyViewController *companyInfoVC = [[CompanyViewController alloc] initWithNibName:@"CompanyViewController" bundle:nil];
    companyInfoVC.finishcompanyInfoDelegate =self;
    companyInfoVC.Listchose = YES;
    companyInfoVC.choseaddress = YES;
    [self.navigationController pushViewController:companyInfoVC animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark ====
#pragma mark ==== 下一步

- (IBAction)nextStepAction:(id)sender {
    
    if ([QWUserDefault getBoolBy:REGISTER_JG_FINISHCOMPANYINFO]) {
        
        if ([QWUserDefault getBoolBy:REGISTER_JG_FINISHUSERINFO]) {
            
            IcenseViewController *icenseInfoVC = [[IcenseViewController alloc] initWithNibName:@"IcenseViewController" bundle:nil];
            [self.navigationController pushViewController:icenseInfoVC animated:YES];
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"请完善软件使用人信息" duration:DURATION_SHORT];
            return;
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"请完善机构信息" duration:DURATION_SHORT];
        return;
    }
}

#pragma mark ====
#pragma mark ==== 机构信息

- (IBAction)companyAction:(id)sender {
    CompanyViewController *companyInfoVC = [[CompanyViewController alloc] initWithNibName:@"CompanyViewController" bundle:nil];
    companyInfoVC.finishcompanyInfoDelegate =self;
    if (self.comefromWrite ==YES ) {
        companyInfoVC.choseaddress = NO;
    }
    [self.navigationController pushViewController:companyInfoVC animated:YES];
}

#pragma mark ====
#pragma mark ==== 软件使用人信息

- (IBAction)userInfoAction:(id)sender {
    
    if ([QWUserDefault getBoolBy:REGISTER_JG_FINISHCOMPANYINFO]) {
        
        UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
        userInfoVC.finishUserInfoDelegate =self;
        [self.navigationController pushViewController:userInfoVC animated:YES];
    }else
    {
        [SVProgressHUD showErrorWithStatus:@"请先输入机构信息" duration:DURATION_SHORT];
    }

}

#pragma mark =====
#pragma mark ===== finishcompanyInfoDelegate

-(void)finishcompanyInfoDelegate:(BOOL)finish{
    if (finish == YES) {
        self.img_company.image = [UIImage imageNamed:@"选中的勾号"];
    }
    
}

#pragma mark =====
#pragma mark ===== finishUserInfoDelegate

-(void)finishUserInfoDelegate:(BOOL)finish{
    if (finish == YES) {
        self.img_user.image = [UIImage imageNamed:@"选中的勾号"];
    }
}
@end

