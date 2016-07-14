//
//  ServiceSpecificationViewController.m
//  APP
//
//  Created by qwfy0006 on 15/3/18.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "ServiceSpecificationViewController.h"

@interface ServiceSpecificationViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *view_web;

@end

@implementation ServiceSpecificationViewController

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
    
    self.title = self.TitleStr;
    CGRect rect = [UIScreen mainScreen].bounds;
    rect.size.height -= 64;
    self.view.frame = rect;
    self.view_web.frame = rect;
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWaring33 image:@"网络信号icon"];
        return;
    }
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.UrlStr]];
    [self.view_web loadRequest:request];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    [[QWLoading instance] showLoading];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [[QWLoading instance] removeLoading];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[QWLoading instance] removeLoading];
}

@end
