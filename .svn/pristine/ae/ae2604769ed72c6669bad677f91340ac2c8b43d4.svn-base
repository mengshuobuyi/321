//
//  ExpertPasswordLoginViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/4/18.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ExpertPasswordLoginViewController.h"
#import "ExpertForgetPwdViewController.h"
#import "Mbr.h"
#import "ExpertModel.h"
#import "ExpertAuthViewController.h"
#import "AppDelegate.h"
#import "ExpertAuthCommitViewController.h"

@interface ExpertPasswordLoginViewController ()
{
    BOOL isVisible; // 密码是否可见
}

@property (weak, nonatomic) IBOutlet UIView *phoneBgView;

@property (weak, nonatomic) IBOutlet UIView *passwordBgView;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIImageView *visibleImageView;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)setPasswordVisibleAction:(id)sender;

- (IBAction)loginAction:(id)sender;

- (IBAction)forgetPasswordAction:(id)sender;

@end

@implementation ExpertPasswordLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureUI];
    
    // 按钮置灰
    [self configureLoginButtonGray];
    
    // 点击空白 键盘down
    [self setUpForDismissKeyboard];
    
    if ([QWUserDefault getBoolBy:@"expertupdatepassword" ]) {
        self.phoneTextField.text = QWGLOBALMANAGER.configure.expertMobile;
        [QWUserDefault setBool:NO key:@"expertupdatepassword"];
    }
    
}

- (void)configureUI
{
    isVisible = NO;
    self.visibleImageView.image = [UIImage imageNamed:@"login_icon_eye"];
    self.passwordTextField.secureTextEntry = YES;
    
    self.phoneBgView.backgroundColor = [UIColor whiteColor];
    self.passwordBgView.backgroundColor = [UIColor whiteColor];
    
    self.phoneBgView.layer.cornerRadius = 3.0;
    self.phoneBgView.layer.masksToBounds = YES;
    self.phoneBgView.layer.borderWidth = 0.5;
    self.phoneBgView.layer.borderColor = RGBHex(qwColor10).CGColor;
    
    self.passwordBgView.layer.cornerRadius = 3.0;
    self.passwordBgView.layer.masksToBounds = YES;
    self.passwordBgView.layer.borderWidth = 0.5;
    self.passwordBgView.layer.borderColor = RGBHex(qwColor10).CGColor;
    
    self.loginButton.layer.cornerRadius = 4.0;
    self.loginButton.layer.masksToBounds = YES;
    
    self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    self.passwordTextField.keyboardType = UIKeyboardTypeDefault;
    self.phoneTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.phoneTextField.tag = 1;
    self.passwordTextField.tag = 2;
    
    [self.phoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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
- (void)configureLoginButtonGray
{
    self.loginButton.enabled = NO;
    [self.loginButton setBackgroundColor:RGBHex(qwColor9)];
    [self.loginButton setBackgroundImage:nil forState:UIControlStateNormal];
}

#pragma mark ---- 下一步按钮高亮 ----

- (void)ConfigureLoginButtonBlue
{
    self.loginButton.enabled = YES;
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"btn_login_notmal"] forState:UIControlStateNormal];
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"btn_login_click"] forState:UIControlStateHighlighted];
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"btn_login_click"] forState:UIControlStateSelected];
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
        maxNum = 11;
    }else if (textView.tag == 2){ //密码
        maxNum = 16;
    }
    
    if (toBeString.length > maxNum) {
        textView.text = [toBeString substringToIndex:maxNum];
    }
    
    if ([QWGLOBALMANAGER isTelPhoneNumber:self.phoneTextField.text] && self.passwordTextField.text.length > 0) {
        [self ConfigureLoginButtonBlue];
    }else{
        [self configureLoginButtonGray];
    }
}


#pragma mark ---- 设置密码是否可见 ----
- (IBAction)setPasswordVisibleAction:(id)sender
{
    if (isVisible)
    {
        // 密码隐藏
        
        self.visibleImageView.image = [UIImage imageNamed:@"login_icon_eye"];
        self.passwordTextField.secureTextEntry = YES;
        isVisible = NO;
        
    }else
    {
        // 密码可见
        
        self.visibleImageView.image = [UIImage imageNamed:@"login_icon_eye_click"];
        self.passwordTextField.secureTextEntry = NO;
        isVisible = YES;
    }
}

#pragma mark ---- 登录 ----
- (IBAction)loginAction:(id)sender
{
    [self.view endEditing:YES];
    
    if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
        [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试" duration:DURATION_SHORT];
        [self ConfigureLoginButtonBlue];
        return;
    }
    
    if (![QWGLOBALMANAGER isTelPhoneNumber:self.phoneTextField.text])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号" duration:DURATION_SHORT];
        [self ConfigureLoginButtonBlue];
        return;
    }
    if (self.passwordTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码" duration:DURATION_SHORT];
        [self ConfigureLoginButtonBlue];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"account"] = StrFromObj(self.phoneTextField.text);
    setting[@"password"] = StrFromObj(self.passwordTextField.text);
    setting[@"pushDeviceCode"] = QWGLOBALMANAGER.deviceToken;
    setting[@"deviceCode"] = DEVICE_IDD;
    setting[@"device"] = @"2";
    setting[@"version"] = @"";
    setting[@"credentials"] = [AESUtil encryptAESData:self.passwordTextField.text app_key:AES_KEY];
    
    [Mbr MbrExpertLoginWithParams:setting success:^(id DFUserModel) {
        
        ExpertLoginInfoModel *infoModel = [ExpertLoginInfoModel parse:DFUserModel];
        if ([infoModel.apiStatus integerValue] == 0)
        {
            [QWUserDefault setObject:@"2" key:@"ENTRANCETYPE"];
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            [self loginSuccessWithModel:infoModel];
        }else
        {
            [SVProgressHUD showErrorWithStatus:infoModel.apiMessage];
            [self ConfigureLoginButtonBlue];
        }
        
    } failure:^(HttpException *e) {
        [self ConfigureLoginButtonBlue];
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
    QWGLOBALMANAGER.configure.expertPassword = StrFromObj(self.passwordTextField.text);
    
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


#pragma mark ---- 忘记密码 ----
- (IBAction)forgetPasswordAction:(id)sender
{
    ExpertForgetPwdViewController *vc = [[UIStoryboard storyboardWithName:@"ExpertLogin" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertForgetPwdViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
