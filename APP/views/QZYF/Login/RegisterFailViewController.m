//
//  RegisterFailViewController.m
//  wenYao-store
//
//  Created by qwfy0006 on 15/4/1.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "RegisterFailViewController.h"
#import "SearchInstitutionViewController.h"
#import "FailInfoViewController.h"

@interface RegisterFailViewController ()

- (IBAction)perfectInfoActin:(id)sender;
- (IBAction)callPhoneAction:(id)sender;
- (IBAction)failInfoAction:(id)sender;

@end

@implementation RegisterFailViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark =====
#pragma mark ===== 立即完善药店信息

- (IBAction)perfectInfoActin:(id)sender {
    
    SearchInstitutionViewController *perfectVC = [[SearchInstitutionViewController alloc] initWithNibName:@"SearchInstitutionViewController" bundle:nil];
    [self.navigationController pushViewController:perfectVC animated:NO];
}

#pragma mark =====
#pragma mark ===== 拨打电话，联系客服

- (IBAction)callPhoneAction:(id)sender {
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:@"tel://0512-87663988"];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}

#pragma mark =====
#pragma mark ===== 为什么没通过

- (IBAction)failInfoAction:(id)sender {
    
    FailInfoViewController *FailVC = [[FailInfoViewController alloc] initWithNibName:@"FailInfoViewController" bundle:nil];
    [self.navigationController pushViewController:FailVC animated:NO];
}
@end
