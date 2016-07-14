//
//  OrganAuthBridgeViewController.m
//  wenYao-store
//
//  Created by YYX on 15/8/20.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "OrganAuthBridgeViewController.h"
#import "OrganAuthTotalViewController.h"

@interface OrganAuthBridgeViewController ()

- (IBAction)organaAuthAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *button;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnBottomConstraint;

@end

@implementation OrganAuthBridgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"机构认证";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.button.layer.cornerRadius = 3.0;
    self.button.layer.masksToBounds = YES;
    
    self.imageHeightConstraint.constant = SCREEN_W-22-23;
    
    if (IS_IPHONE_4_OR_LESS) {
        self.btnBottomConstraint.constant = 35;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)organaAuthAction:(id)sender
{
    OrganAuthTotalViewController *vc = [[UIStoryboard storyboardWithName:@"OrganAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"OrganAuthTotalViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
