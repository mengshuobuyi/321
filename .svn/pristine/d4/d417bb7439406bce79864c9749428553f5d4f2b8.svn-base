//
//  baseView.m
//  Show
//
//  Created by YAN Qingyang on 15-2-7.
//  Copyright (c) 2015年 YAN Qingyang. All rights reserved.
//

#import "QWBaseViewController.h"
#import "GlobalManager.h"




@interface QWBaseViewController ()

@end

@implementation QWBaseViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self UIGlobal];
    [self addObserverGlobal];
}

- (void)dealloc{
    [self removeObserverGlobal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//statusbar 用白色字体
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)UIGlobal{
    
}

#pragma mark 全局通知
- (void)addObserverGlobal{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotif:) name:kQWGlobalNotification object:nil];
}

- (void)removeObserverGlobal{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kQWGlobalNotification object:nil];
}

- (void)getNotif:(NSNotification *)sender{
    //NSLog(@"%@",sender);
    NSDictionary *dd=sender.userInfo;
    NSInteger ty=-1;
    id data;
    id obj;
    
    if ([GLOBALMANAGER object:[dd objectForKey:@"type"] isClass:[NSNumber class]]) {
        ty=[[dd objectForKey:@"type"]integerValue];
    }
    data=[dd objectForKey:@"data"];
    obj=[dd objectForKey:@"object"];
    
    [self getNotifType:ty data:data target:obj];
}

- (void)getNotifType:(NSInteger)type data:(id)data target:(id)obj{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

