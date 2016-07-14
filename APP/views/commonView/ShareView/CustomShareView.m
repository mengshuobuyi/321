//
//  CustomShareView.m
//  APP
//
//  Created by PerryChen on 6/5/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import "CustomShareView.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "QWUserDefault.h"
#import "UserDefault.h"

@implementation CustomShareView
-(void)awakeFromNib {
    BOOL show = [QWUserDefault getBoolBy:kLocationAudition];
    if(![QQApiInterface isQQInstalled]){
        self.QQZone.hidden = YES;
    }else {
        self.QQZone.hidden = NO;
    }
    if (![WXApi isWXAppInstalled] || show) {
        self.wechatSession.hidden = YES;
        self.wechatTimeline.hidden = YES;
        self.constraintSinaLeadToSuper.priority = 1000;
        self.constraintSinaLeadToPre.priority = 999;
    }else {
        self.wechatSession.hidden = NO;
        self.wechatTimeline.hidden = NO;
        self.constraintSinaLeadToSuper.priority = 999;
        self.constraintSinaLeadToPre.priority = 1000;
    }
    [self layoutIfNeeded];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
