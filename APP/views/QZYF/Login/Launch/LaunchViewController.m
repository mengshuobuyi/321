//
//  LaunchViewController.m
//  wenYao-store
//
//  Created by YYX on 15/8/21.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "LaunchViewController.h"
#import "WTScrollView.h"
#import "LoginViewController.h"
#import "LaunchEntranceViewController.h"
#import "AppDelegate.h"

@interface LaunchViewController ()

@property (weak, nonatomic) IBOutlet WTScrollView *scrollView;

// 图片数组
@property (strong, nonatomic) NSMutableArray *imgArray;

// 立即进入
@property (weak, nonatomic) IBOutlet UIButton *jumpButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jumpButton_layout_bottom;


- (IBAction)jumpAction:(id)sender;

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IS_IPHONE_4_OR_LESS)
    {
        self.imgArray = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"guide_one_960"],[UIImage imageNamed:@"guide_two_960"],[UIImage imageNamed:@"guide_three_960"], nil];
    }else if (IS_IPHONE_6P)
    {
        self.imgArray = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"guide_one_1242"],[UIImage imageNamed:@"guide_two_1242"],[UIImage imageNamed:@"guide_three_1242"], nil];
    }else
    {
        self.imgArray = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"guide_one_1136"],[UIImage imageNamed:@"guide_two_1136"],[UIImage imageNamed:@"guide_three_1136"], nil];
    }
    
    self.jumpButton.layer.cornerRadius = 3.0;
    self.jumpButton.layer.masksToBounds = YES;
    self.jumpButton.layer.borderColor = RGBHex(qwColor2).CGColor;
    self.jumpButton.layer.borderWidth = 1.5;
    
    if (IS_IPHONE_4_OR_LESS)
    {
        self.jumpButton_layout_bottom.constant = 30;
    }else if (IS_IPHONE_6P)
    {
        self.jumpButton_layout_bottom.constant = 75;
    }else if (IS_IPHONE_6)
    {
        self.jumpButton_layout_bottom.constant = 65;
    }else{
        self.jumpButton_layout_bottom.constant = 55;
    }
    
    self.scrollView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    
    [self.scrollView setScrollImages:self.imgArray duration:5.0 clickBlock:^(int clickIndex) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.scrollView startTimer];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark ---- 立即进入 ----

- (IBAction)jumpAction:(id)sender
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSNumber numberWithBool:YES] forKey:@"showGuide"];
    [userDefault synchronize];
    
    [QWGLOBALMANAGER postNotif:NotifAppCheckVersion data:nil object:nil];

    LaunchEntranceViewController *vc = [[UIStoryboard storyboardWithName:@"Launch" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchEntranceViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    [self.scrollView stopTimer];
    
}
@end
