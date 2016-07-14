//
//  HealthDetailViewController.m
//  wenyao
//
//  Created by Meng on 14-10-17.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "NoticeDetailViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface NoticeDetailViewController ()
{
    NSURL *url;
}
@property (nonatomic ,strong) UIWebView * webView;


@end

@implementation NoticeDetailViewController

- (id)init{
    if (self = [super init]) {
        self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, APP_W, APP_H-NAV_H)];
        self.webView.backgroundColor = RGBHex(qwColor4);
        self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
        [self.view addSubview:self.webView];
        UIScrollView * s = self.webView.scrollView;
        s.showsHorizontalScrollIndicator = NO;
        s.showsVerticalScrollIndicator = NO;
        self.view.backgroundColor = RGBHex(qwColor11);
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"公告";
//    self.webView.scalesPageToFit = YES;
   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    url = [NSURL URLWithString:self.htmlUrl];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
     [self.webView loadHTMLString:self.htmlUrl baseURL:nil];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.webView stopLoading];
    
}
- (void)viewInfoClickAction:(id)sender
{
    if (QWGLOBALMANAGER.currentNetWork != kNotReachable) {
        [self removeInfoView];
         url = [NSURL URLWithString:self.htmlUrl];
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
