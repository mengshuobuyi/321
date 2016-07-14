//
//  OrganAuthCommitOkViewController.m
//  wenYao-store
//
//  Created by YYX on 15/8/25.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "OrganAuthCommitOkViewController.h"

@interface OrganAuthCommitOkViewController ()

- (IBAction)commitAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *completeButton;

@end

@implementation OrganAuthCommitOkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"机构认证";
    
    self.view.backgroundColor = RGBHex(qwColor11);
    self.completeButton.layer.cornerRadius = 4.0;
    self.completeButton.layer.masksToBounds = YES;
    self.completeButton.layer.borderColor = RGBHex(qwColor2).CGColor;
    self.completeButton.layer.borderWidth = 1.0;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark ---- 提交 ----

- (IBAction)commitAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
