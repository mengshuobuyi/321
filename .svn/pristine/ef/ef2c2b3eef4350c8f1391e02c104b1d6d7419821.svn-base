//
//  ExpertForgetPwdViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/4/18.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ExpertForgetPwdViewController.h"
#import "Mbr.h"
#import "ExpertModel.h"

@interface ExpertForgetPwdViewController ()<UIAlertViewDelegate>
{
    BOOL isVisible; // 密码是否可见
}

@property (weak, nonatomic) IBOutlet UIView *phoneBgView;

@property (weak, nonatomic) IBOutlet UIView *codeBgView;

@property (weak, nonatomic) IBOutlet UIView *passwordBgView;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIImageView *visibleImageView;

@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@property (weak, nonatomic) IBOutlet UILabel *getCodeLabel;

@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;

- (IBAction)getCodeAction:(id)sender;

- (IBAction)setPasswordVisibleAction:(id)sender;

- (IBAction)commitAction:(id)sender;

- (IBAction)contactServiceAction:(id)sender;

@end

@implementation ExpertForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"重置密码";
    
    [self configureUI];
    
    // 按钮置灰
    [self configureCommitButtonGray];
    
    // 点击空白 键盘down
    [self setUpForDismissKeyboard];
}

- (void)configureUI
{
    self.getCodeButton.enabled = YES;
    [self ConfigureCodeButtonWith:@"获取验证码" color:RGBHex(qwColor1)];
    
    isVisible = NO;
    self.visibleImageView.image = [UIImage imageNamed:@"login_icon_eye"];
    self.passwordTextField.secureTextEntry = YES;
    
    self.phoneBgView.backgroundColor = [UIColor whiteColor];
    self.codeBgView.backgroundColor = [UIColor whiteColor];
    self.passwordBgView.backgroundColor = [UIColor whiteColor];
    
    self.phoneBgView.layer.cornerRadius = 3.0;
    self.phoneBgView.layer.masksToBounds = YES;
    self.phoneBgView.layer.borderWidth = 0.5;
    self.phoneBgView.layer.borderColor = RGBHex(qwColor10).CGColor;
    
    self.codeBgView.layer.cornerRadius = 3.0;
    self.codeBgView.layer.masksToBounds = YES;
    self.codeBgView.layer.borderWidth = 0.5;
    self.codeBgView.layer.borderColor = RGBHex(qwColor10).CGColor;
    
    self.passwordBgView.layer.cornerRadius = 3.0;
    self.passwordBgView.layer.masksToBounds = YES;
    self.passwordBgView.layer.borderWidth = 0.5;
    self.passwordBgView.layer.borderColor = RGBHex(qwColor10).CGColor;
    
    self.commitButton.layer.cornerRadius = 4.0;
    self.commitButton.layer.masksToBounds = YES;
    
    self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    self.codeTextField.keyboardType = UIKeyboardTypePhonePad;
    self.passwordTextField.keyboardType = UIKeyboardTypeDefault;
    self.phoneTextField.delegate = self;
    self.codeTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.phoneTextField.tag = 1;
    self.codeTextField.tag = 2;
    self.passwordTextField.tag = 3;
    
    [self.phoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.codeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (QWGLOBALMANAGER.getExpertForgetPwdCd > 0) {
        [self ConfigureCodeButtonWith:[NSString stringWithFormat:@"验证码(%d)s",QWGLOBALMANAGER.getExpertForgetPwdCd] color:RGBHex(qwColor9)];
    }else{
        [self ConfigureCodeButtonWith:@"获取验证码" color:RGBHex(qwColor1)];
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
- (void)configureCommitButtonGray
{
    self.commitButton.enabled = NO;
    [self.commitButton setBackgroundColor:RGBHex(qwColor9)];
    [self.commitButton setBackgroundImage:nil forState:UIControlStateNormal];
}

#pragma mark ---- 下一步按钮高亮 ----
- (void)ConfigureCommitButtonBlue
{
    self.commitButton.enabled = YES;
    [self.commitButton setBackgroundImage:[UIImage imageNamed:@"btn_login_notmal"] forState:UIControlStateNormal];
    [self.commitButton setBackgroundImage:[UIImage imageNamed:@"btn_login_click"] forState:UIControlStateHighlighted];
    [self.commitButton setBackgroundImage:[UIImage imageNamed:@"btn_login_click"] forState:UIControlStateSelected];
}

#pragma mark ---- 发送验证码 ui ----
- (void)ConfigureCodeButtonWith:(NSString *)title color:(UIColor *)color
{
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       self.getCodeLabel.text = title;
                       self.getCodeLabel.layer.cornerRadius = 3.0;
                       self.getCodeLabel.layer.masksToBounds = YES;
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
        maxNum = 11;
    }else if (textView.tag == 2){ //验证码
        maxNum = 6;
    }else if (textView.tag == 3){ //密码
        maxNum = 16;
    }
    
    if (toBeString.length > maxNum) {
        textView.text = [toBeString substringToIndex:maxNum];
    }
    
    if ([QWGLOBALMANAGER isTelPhoneNumber:self.phoneTextField.text] && self.passwordTextField.text.length > 5 && self.codeTextField.text.length > 0) {
        [self ConfigureCommitButtonBlue];
    }else{
        [self configureCommitButtonGray];
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
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"mobile"] = StrFromObj(self.phoneTextField.text);
    [Mbr MbrExpertRegisterValidWithParams:setting success:^(id DFUserModel) {
        
        ExpertIsExistsModel *model = [ExpertIsExistsModel parse:DFUserModel];
        if ([model.apiStatus integerValue] == 0)
        {
            if (model.isExists)
            {
                //已经注册过手机号,直接获取验证码
                [QWGLOBALMANAGER startExpertForgetPwdVerifyCode:self.phoneTextField.text];
            }else
            {
                [SVProgressHUD showErrorWithStatus:@"该手机号码未注册问药专家"];
            }
        }
    } failure:^(HttpException *e) {
        
    }];
}

- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    if(type == NotiCountDownExpertForgetPwd) {
        [self reGetVerifyCodeControl:[data integerValue]];
    }
}

//计时器执行方法
- (void)reGetVerifyCodeControl:(NSInteger)count
{
    if (count == 0) {
        self.getCodeButton.enabled = YES;
        [self ConfigureCodeButtonWith:@"获取验证码" color:RGBHex(qwColor1)];
    }else{
        self.getCodeButton.enabled = NO;
        [self ConfigureCodeButtonWith:[NSString stringWithFormat:@"验证码(%ld)s",(long)count] color:RGBHex(qwColor9)];
    }
}

#pragma mark ----  设置密码是否可见 ----
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

#pragma mark ---- 提交 ----
- (IBAction)commitAction:(id)sender
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        [self ConfigureCommitButtonBlue];
        return;
    }
    
    if (![QWGLOBALMANAGER isTelPhoneNumber:self.phoneTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号码"];
        [self ConfigureCommitButtonBlue];
        return;
    }
    
    if (self.codeTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        [self ConfigureCommitButtonBlue];
        return;
    }
    
    if (self.passwordTextField.text.length < 6 || self.passwordTextField.text.length > 16) {
        [SVProgressHUD showErrorWithStatus:@"密码输入不符合规范，请重新输入"];
        [self ConfigureCommitButtonBlue];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"mobile"] = StrFromObj(self.phoneTextField.text);
    setting[@"code"] = StrFromObj(self.codeTextField.text);
    setting[@"newPwd"] = StrFromObj(self.passwordTextField.text);
    setting[@"newCredentials"] = [AESUtil encryptAESData:self.passwordTextField.text app_key:AES_KEY];
    
    [Mbr MbrExpertResetPasswordWithParams:setting success:^(id DFUserModel) {
        
        BaseAPIModel *model = [BaseAPIModel parse:DFUserModel];
        if ([model.apiStatus integerValue] == 0)
        {
            [SVProgressHUD showSuccessWithStatus:@"密码重置成功"];
            //跳转至密码登录页面
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [SVProgressHUD showErrorWithStatus:model.apiMessage];
            [self ConfigureCommitButtonBlue];
        }
        
    } failure:^(HttpException *e) {
        [self ConfigureCommitButtonBlue];
    }];
    
}

#pragma mark ---- 联系客服 ----
- (IBAction)contactServiceAction:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"0512-87661737" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *tel = @"0512-87661737";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",tel]]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
