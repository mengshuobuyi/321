//
//  OrganInfoCompleteViewController.m
//  wenYao-store
//
//  Created by YYX on 15/8/25.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "OrganInfoCompleteViewController.h"

@interface OrganInfoCompleteViewController ()

@property (weak, nonatomic) IBOutlet UIButton *completeButton;

- (IBAction)complteAction:(id)sender;

@end

@implementation OrganInfoCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"机构认证";

    self.navigationItem.hidesBackButton = YES;
    self.view.backgroundColor = RGBHex(qwColor11);
    self.completeButton.layer.cornerRadius = 4.0;
    self.completeButton.layer.masksToBounds = YES;
    self.completeButton.layer.borderColor = RGBHex(qwColor2).CGColor;
    self.completeButton.layer.borderWidth = 1.0;
    ((QWBaseNavigationController *)self.navigationController).canDragBack = NO;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItems = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark ---- 完成 ----

- (IBAction)complteAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
