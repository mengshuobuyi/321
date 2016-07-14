//
//  AppealUtil.m
//  APP
//
//  Created by Martin.Liu on 16/7/12.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "AppealUtil.h"
#import "QWGlobalManager.h"
#import "ConstraintsUtility.h"
#import "AppDelegate.h"
#import "cssex.h"
#import "SilenceAppealViewController.h"
#import "Forum.h"

typedef NS_ENUM(NSInteger, AppealStatus) {
    AppealStatus_Silence,
    AppealStatus_CheckSilence,
};

@interface AppealUtil()

@property (nonatomic, strong) UIViewController* currentVC;
@property (nonatomic, strong) UIView* appealView;
@property (nonatomic, strong) UIView* checkAppealView;
@property (nonatomic, strong) UIView* backView;
@end

@implementation AppealUtil

+ (instancetype)sharedInstance
{
    static AppealUtil* instance;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[AppealUtil alloc] init];
    });
    return instance;
}

- (BOOL)checkSilenceStatusWithVC:(UIViewController *)vc
{
    // 如果没有登录则不检验
    if (!QWGLOBALMANAGER.loginStatus || StrIsEmpty(QWGLOBALMANAGER.configure.expertToken)) {
        return YES;
    }
    _currentVC = vc;
    if (QWGLOBALMANAGER.configure.appealFlag)
    {
        [self alertWithAppealStatus:AppealStatus_CheckSilence];
        [self synchronizeSilenceStatus];
        return NO;
    }
    else if (QWGLOBALMANAGER.configure.silencedFlag) {
        [self alertWithAppealStatus:AppealStatus_Silence];
        [self synchronizeSilenceStatus];
        return NO;
    }
    else
    {
       _currentVC = nil;
        return YES;
    }
}

- (void)synchronizeSilenceStatus
{
    if (QWGLOBALMANAGER.loginStatus && !StrIsEmpty(QWGLOBALMANAGER.configure.expertToken)) {
        GetSilenceStatusR* param = [[GetSilenceStatusR alloc] init];
        param.token = QWGLOBALMANAGER.configure.expertToken;
        [Forum getSilenceStatus:param success:^(SilenceStatusModel *silenceStatusModel) {
            QWGLOBALMANAGER.configure.silencedFlag = silenceStatusModel.silencedFlag;
            QWGLOBALMANAGER.configure.appealFlag = silenceStatusModel.appealFlag;
        } failure:^(HttpException *e) {
            DDLogError(@"get Silence status error : %@", e);
        }];
    }
}

- (void)alertWithAppealStatus:(AppealStatus)status
{
    UIView* tmpView;
    UIView* keyWindow = ((AppDelegate *)([UIApplication sharedApplication].delegate)).window;
    if (status == AppealStatus_Silence) {
        [self.backView addSubview:self.appealView];
        tmpView = self.appealView;
    }
    else if(status == AppealStatus_CheckSilence)
    {
        [self.backView addSubview:self.checkAppealView];
        tmpView = self.checkAppealView;
    }
    else
    {
        return;
    }
    
    [keyWindow addSubview:self.backView];
    PREPCONSTRAINTS(self.backView);
    PREPCONSTRAINTS(tmpView);
    
    ALIGN_TOPLEFT(self.backView, 0);
    ALIGN_BOTTOMRIGHT(self.backView, 0);
    
    CENTER(tmpView);
    ALIGN_LEADING(tmpView, 35);
    
    self.backView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.backView.alpha = 1;
    }];
}

- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = RGBAHex(0x000000, 0.7);
    }
    return _backView;
}

// 禁言申诉视图
- (UIView *)appealView
{
    if (!_appealView) {
        _appealView = [[UIView alloc] init];
        _appealView.backgroundColor = [UIColor whiteColor];
        _appealView.layer.cornerRadius = 4;
        _appealView.clipsToBounds = YES;
        
        UILabel* titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"禁言申诉";
        titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
        titleLabel.textColor = RGBHex(qwColor6);
        
        UILabel* contentLabel = [[UILabel alloc] init];
        contentLabel.numberOfLines = 0;
        QWCSS(contentLabel, 1, 7);
        NSString* contentString = @"非常抱歉，由于您的某些言论，您已被系统禁言，您可在此进行申诉，工作人员会尽快进行处理回复，谢谢!";
        NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 3;
        
        NSAttributedString* attr = [[NSAttributedString alloc] initWithString:contentString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kFontS1],NSForegroundColorAttributeName:RGBHex(qwColor7), NSParagraphStyleAttributeName:style}];
        contentLabel.attributedText = attr;
        
        UIView* hrLine = [[UIView alloc] init];
        hrLine.backgroundColor = RGBHex(qwColor10);
        UIView* vrLine = [[UIView alloc] init];
        vrLine.backgroundColor = RGBHex(qwColor10);
        
        UIButton* cancelBtn = [[UIButton alloc] init];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(dismissView:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton* appealBtn = [[UIButton alloc] init];
        [appealBtn setTitle:@"申诉" forState:UIControlStateNormal];
        [appealBtn addTarget:self action:@selector(gotoAppeal:) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
        appealBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
        [cancelBtn setTitleColor:RGBHex(qwColor1) forState:UIControlStateNormal];
        [appealBtn setTitleColor:RGBHex(qwColor1) forState:UIControlStateNormal];
        
        [_appealView addSubview:titleLabel];
        [_appealView addSubview:contentLabel];
        [_appealView addSubview:hrLine];
        [_appealView addSubview:cancelBtn];
        [_appealView addSubview:vrLine];
        [_appealView addSubview:appealBtn];
        
        PREPCONSTRAINTS(titleLabel);
        PREPCONSTRAINTS(contentLabel);
        PREPCONSTRAINTS(hrLine);
        PREPCONSTRAINTS(cancelBtn);
        PREPCONSTRAINTS(vrLine);
        PREPCONSTRAINTS(appealBtn);
        
        ALIGN_TOP(titleLabel, 30);
        CENTER_H(titleLabel);
        
        LAYOUT_V(titleLabel, 25, contentLabel);
        ALIGN_LEADING(contentLabel, 25);
        
        LAYOUT_V(contentLabel, 25, hrLine);
        ALIGN_LEADING(hrLine, 0);
        CONSTRAIN_HEIGHT(hrLine, 1.0f/[UIScreen mainScreen].scale);
        
        CONSTRAIN_WIDTH(vrLine, 1.0f/[UIScreen mainScreen].scale);
        LAYOUT_V(hrLine, 0, vrLine);
        CONSTRAIN_HEIGHT(vrLine, 50);
        ALIGN_BOTTOM(vrLine, 0);
        
        LAYOUT_V_WITHOUTCENTER(hrLine, 0, cancelBtn);
        ALIGN_LEADING(cancelBtn, 0);
        ALIGN_BOTTOM(cancelBtn, 0);
        LAYOUT_H_WITHOUTCENTER(cancelBtn, 0, vrLine);
        
        LAYOUT_V_WITHOUTCENTER(hrLine, 0, appealBtn);
        LAYOUT_H_WITHOUTCENTER(vrLine, 0, appealBtn);
        ALIGN_BOTTOM(appealBtn, 0);
        ALIGN_TRAILING(appealBtn, 0);
    }
    return _appealView;
}


// 禁言审核视图
- (UIView *)checkAppealView
{
    if (!_checkAppealView) {
        _checkAppealView = [[UIView alloc] init];
        _checkAppealView.backgroundColor = [UIColor whiteColor];
        _checkAppealView.layer.cornerRadius = 4;
        _checkAppealView.clipsToBounds = YES;
        
        UILabel* titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"禁言申诉";
        titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
        titleLabel.textColor = RGBHex(qwColor6);
        
        UILabel* contentLabel = [[UILabel alloc] init];
        contentLabel.numberOfLines = 0;
        QWCSS(contentLabel, 1, 7);
        NSString* contentString = @"您已被禁言，申诉正在审核中，工作人员会尽快回复，请耐心等待审核结果，谢谢!";
        NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 3;
        
        NSAttributedString* attr = [[NSAttributedString alloc] initWithString:contentString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kFontS1],NSForegroundColorAttributeName:RGBHex(qwColor7), NSParagraphStyleAttributeName:style}];
        contentLabel.attributedText = attr;
        
        UIView* phoneContainerView = [[UIView alloc] init];
        
        UILabel* phoneTipLabel = [[UILabel alloc] init];
        phoneTipLabel.text = @"客服电话:";
        QWCSS(phoneTipLabel, 1, 7);
        
        UIButton* phoneBtn = [[UIButton alloc] init];
        [phoneBtn setTitle:@"0512-87661737" forState:UIControlStateNormal];
        QWCSS(phoneBtn, 1, 5);
        [phoneBtn addTarget:self action:@selector(callPhoneAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView* phoneBtnBottomLine = [[UIView alloc] init];
        phoneBtnBottomLine.backgroundColor = RGBHex(qwColor5);
        
        UIButton* knowBtn = [[UIButton alloc] init];
        [knowBtn setTitle:@"知道了" forState:UIControlStateNormal];
        [knowBtn addTarget:self action:@selector(dismissView:) forControlEvents:UIControlEventTouchUpInside];
        knowBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
        [knowBtn setTitleColor:RGBHex(qwColor1) forState:UIControlStateNormal];
        
        UIView* hrLine = [[UIView alloc] init];
        hrLine.backgroundColor = RGBHex(qwColor10);
        
        [_checkAppealView addSubview:titleLabel];
        [_checkAppealView addSubview:contentLabel];
        [_checkAppealView addSubview:phoneContainerView];
        [phoneContainerView addSubview:phoneTipLabel];
        [phoneContainerView addSubview:phoneBtn];
        [phoneContainerView addSubview:phoneBtnBottomLine];
        [_checkAppealView addSubview:hrLine];
        [_checkAppealView addSubview:knowBtn];
        
        PREPCONSTRAINTS(titleLabel);
        PREPCONSTRAINTS(contentLabel);
        PREPCONSTRAINTS(phoneContainerView);
        PREPCONSTRAINTS(phoneTipLabel);
        PREPCONSTRAINTS(phoneBtn);
        PREPCONSTRAINTS(phoneBtnBottomLine);
        PREPCONSTRAINTS(hrLine);
        PREPCONSTRAINTS(knowBtn);
        
        ALIGN_TOP(titleLabel, 30);
        CENTER_H(titleLabel);
        
        LAYOUT_V(titleLabel, 25, contentLabel);
        ALIGN_LEADING(contentLabel, 25);
        
        LAYOUT_V(contentLabel, 20, phoneContainerView);
        ALIGN_TOP(phoneTipLabel, 0);
        ALIGN_LEADING(phoneTipLabel, 0);
        ALIGN_BOTTOM(phoneTipLabel, 0);
        LAYOUT_H_WITHOUTCENTER(phoneTipLabel, 0, phoneBtn);
        
        ALIGN_TOP(phoneBtn, 0);
        ALIGN_BOTTOM(phoneBtn, 0);
        ALIGN_TRAILING(phoneBtn, 0);
        
        MATCH_WIDTH(phoneBtnBottomLine, phoneBtn);
        CONSTRAIN_HEIGHT(phoneBtnBottomLine, 1);
        ALIGN_TRAILING(phoneBtnBottomLine, 0);
        [[NSLayoutConstraint constraintWithItem:phoneBtnBottomLine attribute:NSLayoutAttributeBaseline relatedBy:NSLayoutRelationEqual toItem:phoneBtn attribute:NSLayoutAttributeBaseline multiplier:1.0 constant:3] install];
        
        LAYOUT_V(phoneContainerView, 15, hrLine);
        ALIGN_LEADING(hrLine, 0);
        CONSTRAIN_HEIGHT(hrLine, 1.0f/[UIScreen mainScreen].scale);
        
        LAYOUT_V_WITHOUTCENTER(hrLine, 0, knowBtn);
        ALIGN_LEADING(knowBtn, 0);
        ALIGN_BOTTOM(knowBtn, 0);
        ALIGN_TRAILING(knowBtn, 0);
        CONSTRAIN_HEIGHT(knowBtn, 50);
    }
    
    return _checkAppealView;
}

- (void)dismissView:(id)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        _backView.alpha = 0;
    } completion:^(BOOL finished) {
        [_appealView removeFromSuperview];
        _appealView = nil;
        [_checkAppealView removeFromSuperview];
        _checkAppealView = nil;
        [_backView removeFromSuperview];
        _backView = nil;
        _currentVC = nil;
    }];
}

- (void)gotoAppeal:(id)sender
{
    if (_currentVC) {
        SilenceAppealViewController* appealVC = [[SilenceAppealViewController alloc] init];
        appealVC.hidesBottomBarWhenPushed = YES;
        [_currentVC.navigationController pushViewController:appealVC animated:YES];
        [self dismissView:nil];
    }
}

- (void)callPhoneAction:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://051287661737"]];
    [self dismissView:nil];
}

- (void)dealloc
{
    _appealView = nil;
    _checkAppealView = nil;
    _backView = nil;
    _currentVC = nil;
}

@end
