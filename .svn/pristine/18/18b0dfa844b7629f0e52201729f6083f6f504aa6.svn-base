//
//  FinishViewController.m
//  wenYao-store
//
//  Created by qwfy0006 on 15/4/1.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "FinishViewController.h"
#import "AppDelegate.h"
#import "Constant.h"

@interface FinishViewController ()

@property (strong, nonatomic) IBOutlet UILabel *lbl_useraccount;

@end

@implementation FinishViewController

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
    self.lbl_useraccount.text = [QWUserDefault getObjectBy:REGISTER_JG_ACCOUNT];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
