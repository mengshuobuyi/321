//
//  ExpertLoginViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 15/12/29.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "ExpertLoginViewController.h"
#import "AppDelegate.h"
#import "ExpertAuthViewController.h"
#import "Store.h"
#import "Mbr.h"
#import "ExpertAuthCommitViewController.h"
#import "ExpertModel.h"
#import "Circle.h"

@interface ExpertLoginViewController ()

// scrollview的contentview的相对view的高约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *anchorHeightConstraint;
// contentView的顶部约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewTopConstraint;
// topImage顶部图片高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBgHeightConstraint;

// 手机号 验证码 输入框
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

// 发送验证码
@property (weak, nonatomic) IBOutlet UILabel *getCodeLabel;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
- (IBAction)getCodeAction:(id)sender;

// 登陆
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)loginAction:(id)sender;

// 返回
- (IBAction)backAction:(id)sender;

@end

@implementation ExpertLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 按钮置灰
    [self configureNextButtonGray];
    
    // 设置UI
    [self configureUI];
    
    // 不同设备改变图片高度
    self.topBgHeightConstraint.constant = APP_W*170/320;
    
    // 点击空白 键盘down
    [self setUpForDismissKeyboard];

}

- (void)configureUI
{
    self.getCodeButton.enabled = YES;
    [self ConfigureCodeButtonWith:@"发送验证码" color:RGBHex(qwColor1)];
    
    self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    self.codeTextField.keyboardType = UIKeyboardTypePhonePad;
    self.phoneTextField.delegate = self;
    self.codeTextField.delegate = self;
    self.phoneTextField.tag = 1;
    self.codeTextField.tag = 2;
    
    [self.phoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.codeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.phoneTextField setValue:RGBHex(0xaaaaaa) forKeyPath:@"_placeholderLabel.textColor"];
    [self.codeTextField setValue:RGBHex(0xaaaaaa) forKeyPath:@"_placeholderLabel.textColor"];
    
    self.loginButton.layer.cornerRadius = 3.0;
    self.loginButton.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (IS_IPHONE_4_OR_LESS) {
        
        self.anchorHeightConstraint.constant = 480;
        
    }else if (IS_IPHONE_5){
        
        self.anchorHeightConstraint.constant = 568;
        
    }else if (IS_IPHONE_6){
        
        self.anchorHeightConstraint.constant = 667;
        
    }else if (IS_IPHONE_6P){
        
        self.anchorHeightConstraint.constant = 736;
    }
    
    if (QWGLOBALMANAGER.getCommonRegisterCd > 0) {
        [self ConfigureCodeButtonWith:[NSString stringWithFormat:@"验证码(%d)s",QWGLOBALMANAGER.getCommonRegisterCd] color:RGBHex(qwColor9)];
    }else{
        [self ConfigureCodeButtonWith:@"发送验证码" color:RGBHex(qwColor1)];
    }
    
    if([QWUserDefault getBoolBy:APP_LOGIN_STATUS])
    {
        if ([[QWUserDefault getObjectBy:@"noNeedFade"] isEqualToString:@"1"]) {
            [QWUserDefault removeObjectBy:@"noNeedFade"];
        }else{
            [[UIApplication sharedApplication].keyWindow addSubview:QWGLOBALMANAGER.fadeCover];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark ---- UITextFieldDelegate ----

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (IS_IPHONE_5) {
        
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.3 animations:^{
            self.anchorHeightConstraint.constant += 30;
            self.contentViewTopConstraint.constant = -30;
            [self.view layoutIfNeeded];
        }];
        
    }else if (IS_IPHONE_4_OR_LESS){
        
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.3 animations:^{
            self.anchorHeightConstraint.constant += 110;
            self.contentViewTopConstraint.constant = -110;
            [self.view layoutIfNeeded];
        }];
        
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (IS_IPHONE_5) {
        
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.3 animations:^{
            self.anchorHeightConstraint.constant -= 30;
            self.contentViewTopConstraint.constant = 0;
            [self.view layoutIfNeeded];
        }];
        
    }else if (IS_IPHONE_4_OR_LESS){
        
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.3 animations:^{
            self.anchorHeightConstraint.constant -= 110;
            self.contentViewTopConstraint.constant = 0;
            [self.view layoutIfNeeded];
        }];
        
    }
}

#pragma mark ---- 点击空白 收起键盘 ----

- (void)setUpForDismissKeyboard
{
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    [self.view addGestureRecognizer:singleTapGR];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognize{
    //此method会将self.view里所有的subview的first responder都resign掉
    [UIView animateWithDuration:1 animations:^{
        
    } completion:^(BOOL finished) {
    }];
    [self.view endEditing:YES];
}

#pragma mark ---- 下一步按钮置灰 ----

- (void)configureNextButtonGray
{
    self.loginButton.enabled = NO;
    [self.loginButton setBackgroundColor:RGBHex(qwColor9)];
    [self.loginButton setBackgroundImage:nil forState:UIControlStateNormal];
}

#pragma mark ---- 下一步按钮高亮 ----

- (void)ConfigureNextButtonBlue
{
    self.loginButton.enabled = YES;
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"btn_login_notmal"] forState:UIControlStateNormal];
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"btn_login_click"] forState:UIControlStateHighlighted];
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"btn_login_click"] forState:UIControlStateSelected];
}

#pragma mark ---- 发送验证码 ui ----

- (void)ConfigureCodeButtonWith:(NSString *)title color:(UIColor *)color
{
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       self.getCodeLabel.text = title;
                       self.getCodeLabel.textColor = color;
                       self.getCodeLabel.layer.borderColor = color.CGColor;
                       self.getCodeLabel.layer.borderWidth = 0.5;
                       self.getCodeLabel.layer.cornerRadius = 2.0;
                       [self.getCodeLabel setNeedsDisplay];
                   });
}

#pragma mark ---- 监听文本变化 ----

- (void)textFieldDidChange:(UITextField *)textField
{
    UITextField *textView = textField;
    NSString *lang = [[textView textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            [self judgeTextFieldChange:textView];
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        [self judgeTextFieldChange:textView];
    }
}

- (void)judgeTextFieldChange:(UITextField *)textField
{
    UITextField *textView = textField;
    NSString *toBeString = textView.text;
    
    int maxNum;
    if (textView.tag == 1) { //手机号
        maxNum = 13;
    }else if (textView.tag == 2){ //验证码
        maxNum = 6;
    }
    
    if (toBeString.length > maxNum) {
        textView.text = [toBeString substringToIndex:maxNum];
    }
    
    if ([QWGLOBALMANAGER isTelPhoneNumber:self.phoneTextField.text] && self.codeTextField.text.length > 0) {
        [self ConfigureNextButtonBlue];
    }else
    {
        [self configureNextButtonGray];
    }
}

#pragma mark ---- 获取验证码 ----

- (IBAction)getCodeAction:(id)sender
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:0.8f];
        return;
    }
    
    if (self.phoneTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:Kwarning220N69 duration:0.8];
        return;
    }
    
    if (![QWGLOBALMANAGER isTelPhoneNumber:self.phoneTextField.text]) {
        [SVProgressHUD showErrorWithStatus:Kwarning220N70 duration:0.8];
        return;
    }
    
    [QWGLOBALMANAGER startExpertLoginVerifyCode:self.phoneTextField.text];
}

- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    if(type == NotiCountDownExpertLogin) {
        [self reGetVerifyCodeControl:[data integerValue]];
    }
}

//计时器执行方法
- (void)reGetVerifyCodeControl:(NSInteger)count
{
    if (count == 0) {
        self.getCodeButton.enabled = YES;
        [self ConfigureCodeButtonWith:@"发送验证码" color:RGBHex(qwColor1)];
    }else{
        self.getCodeButton.enabled = NO;
        [self ConfigureCodeButtonWith:[NSString stringWithFormat:@"验证码(%ld)s",(long)count] color:RGBHex(qwColor9)];
    }
}

#pragma mark ---- login ----

- (IBAction)loginAction:(id)sender
{
    self.loginButton.enabled = NO;
    [self.view endEditing:YES];
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:0.8f];
        self.loginButton.enabled = YES;
        return;
    }
    
    if (self.codeTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码" duration:DURATION_SHORT];
        self.loginButton.enabled = YES;
        return;
    }
    
    // 调登录接口
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"mobile"] = StrFromObj(self.phoneTextField.text);
    setting[@"validCode"] = StrFromObj(self.codeTextField.text);
    setting[@"pushDeviceCode"] = StrFromObj(QWGLOBALMANAGER.deviceToken);
    setting[@"deviceCode"] = DEVICE_IDD;
    setting[@"device"] = @2;
    [QWGLOBALMANAGER readLocationInformation:^(MapInfoModel *mapInfoModel) {
        if(mapInfoModel) {
            setting[@"city"] = StrFromObj(mapInfoModel.city);
        }else{
            setting[@"city"] = @"苏州市";
        }
    }];
    
    [Mbr MbrUserExpertLoginWithParam:setting success:^(id obj) {
        
        ExpertLoginInfoModel *infoModel = [ExpertLoginInfoModel parse:obj];
        if ([infoModel.apiStatus integerValue] == 0)
        {
            [QWUserDefault setObject:@"2" key:@"ENTRANCETYPE"];
            [self loginSuccessWithModel:infoModel];
        }else
        {
            [SVProgressHUD showErrorWithStatus:infoModel.apiMessage];
            [self ConfigureNextButtonBlue];
        }
    } failure:^(HttpException *e) {
        [self ConfigureNextButtonBlue];
    }];
}

#pragma mark ---- 登陆之后的操作 ----
- (void)loginSuccessWithModel:(ExpertLoginInfoModel *)infoModel
{
    //存储登陆返回的基本信息
    QWGLOBALMANAGER.configure.expertToken = infoModel.token;
    QWGLOBALMANAGER.configure.expertPassportId = infoModel.passportId;
    QWGLOBALMANAGER.configure.silencedFlag = infoModel.silencedFlag;
    QWGLOBALMANAGER.configure.expertIsSetPwd = infoModel.isSetPwd;
    
    NSString *nickName = infoModel.nickName;
    if(nickName && ![nickName isEqual:[NSNull null]]){
        QWGLOBALMANAGER.configure.expertNickName = nickName;
    }else{
        QWGLOBALMANAGER.configure.expertNickName = @"";
    }
    NSString *avatarUrl = infoModel.avatarUrl;
    if(avatarUrl && ![avatarUrl isEqual:[NSNull null]]){
        QWGLOBALMANAGER.configure.expertAvatarUrl = avatarUrl;
    }else{
        QWGLOBALMANAGER.configure.expertAvatarUrl = @"";
    }
    
    QWGLOBALMANAGER.configure.expertMobile = infoModel.mobile;
    QWGLOBALMANAGER.configure.expertAuthStatus = infoModel.authStatus;
    
    QWGLOBALMANAGER.loginStatus = YES;
    [QWGLOBALMANAGER saveAppConfigure];
    [QWUserDefault setBool:YES key:APP_LOGIN_STATUS];
    
    [QWGLOBALMANAGER saveOperateLog:@"2"];
    
    //通知登录成功
    [QWGLOBALMANAGER postNotif:NotifLoginSuccess data:nil object:self];
    [QWGLOBALMANAGER expertLoginSuccess];
    
    // 判断是否认证通过
    QWGLOBALMANAGER.configure.expertAuthStatus = infoModel.authStatus;
    
    //（5:未申请 1:已申请待认证, 2:已认证, 3:认证不通过, 4:认证中）
    if (infoModel.authStatus == 5) //未申请
    {
        ExpertAuthViewController *vc = [[UIStoryboard storyboardWithName:@"ExpertAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertAuthViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (infoModel.authStatus == 2 || infoModel.authStatus == 4) //已认证
    {
        [QWUserDefault setBool:YES key:APP_LOGIN_STATUS];
        if(QWGLOBALMANAGER.tabBar){
            [self dismissViewControllerAnimated:NO completion:nil];
        }else{
            AppDelegate *apppp = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [apppp initTabBar];
        }
        
    }else if (infoModel.authStatus == 3) //认证不通过
    {
        ExpertAuthViewController *vc = [[UIStoryboard storyboardWithName:@"ExpertAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertAuthViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (infoModel.authStatus == 1) //已申请待认证
    {
        ExpertAuthCommitViewController *vc = [[UIStoryboard storyboardWithName:@"ExpertAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertAuthCommitViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }

}
#pragma mark ---- 返回 ----
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
