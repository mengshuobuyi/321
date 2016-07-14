//
//  ContactServiceView.m
//  wenYao-store
//
//  Created by YYX on 15/8/19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "ContactServiceView.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "Warning.h"

@implementation ContactServiceView

{
    UIWindow *window;
}

// 拨号
- (IBAction)callAction:(id)sender
{
    [self hidden];
    NSString *tel = self.phoneLabel.text;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",tel]]];
}

// 复制qq
- (IBAction)copyQQAction:(id)sender
{
    [[UIPasteboard generalPasteboard] setString:self.qqLabel.text];
    [SVProgressHUD showSuccessWithStatus:Kwarning220N68 duration:0.8];
    [self hidden];
}

// 复制 微信
- (IBAction)copyWechatAction:(id)sender
{
    [[UIPasteboard generalPasteboard] setString:self.wechatLabel.text];
    [SVProgressHUD showSuccessWithStatus:Kwarning220N68 duration:0.8];
    [self hidden];
}

// 取消
- (IBAction)cancelAction:(id)sender
{
    [self hidden];
}

+ (ContactServiceView *)sharedManager
{
    return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (self) {
        NSArray *array = [[NSBundle mainBundle ] loadNibNamed:@"ContactServiceView" owner:self options:nil];
        self = array[0];
        self.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        
        self.cancelButton.layer.cornerRadius = 4.0;
        self.cancelButton.layer.masksToBounds = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapAction
{
    [self hidden];
}

-(void)show
{
    self.bgView.alpha = 0;
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app.window addSubview:self];
    
    self.bg.frame = CGRectMake(0, SCREEN_H, SCREEN_W, self.bg.frame.size.height);
    __weak ContactServiceView *weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.bgView.alpha = 0.4;
        weakSelf.bg.frame = CGRectMake(0, SCREEN_H - self.bg.frame.size.height, SCREEN_W, self.bg.frame.size.height);
    }];
}

-(void)hidden
{
    __weak ContactServiceView *weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.bg.frame = CGRectMake(0, SCREEN_H, SCREEN_W, self.bg.frame.size.height);
        weakSelf.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}


@end
