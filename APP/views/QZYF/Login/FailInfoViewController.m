//
//  FailInfoViewController.m
//  wenYao-store
//
//  Created by qwfy0006 on 15/4/1.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "FailInfoViewController.h"
#import "AppDelegate.h"
#import "SearchInstitutionViewController.h"

@interface FailInfoViewController ()

@property (strong, nonatomic) IBOutlet UITextView *textView_info;
- (IBAction)nextAction:(id)sender;
- (IBAction)callTelAction:(id)sender;

@end

@implementation FailInfoViewController

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
    self.title = @"未通过审核原因";
    self.textView_info.text = [QWUserDefault getObjectBy:REGISTER_JG_FAILINFO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)textView: (UITextView *)textview shouldChangeTextInRange: (NSRange)range replacementText: (NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        
    }
    return YES;
}

#pragma mark =====
#pragma mark ===== 拨打电话

- (IBAction)callTelAction:(id)sender {
    
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:@"tel://0512-87663988"];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
    
}

#pragma mark =====
#pragma mark ===== 立即完善药店信xi

- (IBAction)nextAction:(id)sender {
    
    SearchInstitutionViewController *perfectVC = [[SearchInstitutionViewController alloc] initWithNibName:@"SearchInstitutionViewController" bundle:nil];
    [self.navigationController pushViewController:perfectVC animated:NO];
}


@end
