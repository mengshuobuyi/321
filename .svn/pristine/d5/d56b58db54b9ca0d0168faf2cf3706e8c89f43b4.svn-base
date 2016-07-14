//
//  NoticeCustomView.m
//  APP
//  公告自定义弹出框
//  Created by 李坚 on 16/3/9.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "NoticeCustomView.h"
#import "QWGlobalManager.h"

@implementation NoticeCustomView

+ (NoticeCustomView *)showNoticeViewInView:(UIWindow *)window WithTitle:(NSString *)title content:(NSString *)noticeStr{
    
    NoticeCustomView *noticeView = [[NoticeCustomView alloc]initWithFrame:CGRectMake(0, 0, APP_W, APP_H + 20)];
    noticeView.alpha = 0.0f;
    CGFloat LabelHeight = [QWGLOBALMANAGER sizeText:noticeStr font:fontSystem(kFontS1) limitWidth:APP_W - 40].height;
    
//    noticeView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.95f];
    
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, APP_W, APP_H + 20)];
    backImageView.image = [UIImage imageNamed:@"bg_drugstore_announcement"];
    [noticeView addSubview:backImageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 162, APP_W, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = RGBHex(qwColor6);
    label.font = fontSystemBold(kFontS2);
    label.text = title;
    [noticeView addSubview:label];
    
    UILabel *noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 203, APP_W - 40, LabelHeight)];
    noticeLabel.textColor = RGBHex(qwColor6);
    noticeLabel.font = fontSystem(kFontS1);
    noticeLabel.text = noticeStr;
    noticeLabel.numberOfLines = 0;
    [noticeView addSubview:noticeLabel];
    
    if(IS_IPHONE_4_OR_LESS){
        label.frame = CGRectMake(0, 40, APP_W, 20);
        noticeLabel.frame = CGRectMake(20, 81, APP_W - 40, LabelHeight);
    }
    
    noticeView.btn = [[UIButton alloc]initWithFrame:CGRectMake((APP_W / 2.0f) - 100, APP_H - 64, 200, 40)];
    [noticeView.btn setImage:[UIImage imageNamed:@"icon_drugstore_close"] forState:UIControlStateNormal];
    [noticeView addSubview:noticeView.btn];
    
    
    
    if(!noticeView.superview) {
        [window addSubview:noticeView];
    }
    [window bringSubviewToFront:noticeView];
    
    
    [UIView animateWithDuration:0.25f animations:^{
        noticeView.alpha = 1.0f;
    }];
    
    return noticeView;
}


+ (NoticeCustomView *)showPerformViewInView:(UIWindow *)window WithTitle:(NSString *)title content:(NSString *)noticeStr{
    
    NoticeCustomView *noticeView = [[NoticeCustomView alloc]initWithFrame:CGRectMake(0, 0, APP_W, APP_H+20)];
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, APP_W, APP_H + 20)];
    backImageView.image = [UIImage imageNamed:@"bg_drugstore_announcement"];
    [noticeView addSubview:backImageView];
    noticeView.alpha = 1.0f;
    UIWebView * webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, APP_W, APP_H+20)];

    NSString *webStr = [NSString stringWithFormat:@"%@/QWAPP/v310/QWYH/web/cart/html/warrantIos.html?bname=%@",DE_H5_DOMAIN_URL,[noticeStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] ;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webStr]]];
    [noticeView addSubview:webView];
    noticeView.btn = [[UIButton alloc]initWithFrame:CGRectMake((APP_W / 2.0f) - 100, APP_H - 64, 200, 40)];
    [noticeView.btn setImage:[UIImage imageNamed:@"icon_drugstore_close"] forState:UIControlStateNormal];
    [noticeView addSubview:noticeView.btn];
    
    
    if(!noticeView.superview) {
        [window addSubview:noticeView];
    }
    [window bringSubviewToFront:noticeView];
    
    return noticeView;
}



- (void)awakeFromNib{
    [super awakeFromNib];
    
    
}

- (void)addSubview:(UIView *)view{
    [super addSubview:view];
    
    [_btn addTarget:self action:@selector(hideViewAction:) forControlEvents:UIControlEventTouchDown];
}

- (void)hideViewAction:(id)sender {
    [self removeFromSuperview];
}
@end
