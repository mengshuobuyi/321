//
//  ExpertUpdatePwdViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/4/13.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ExpertUpdatePwdViewController.h"
#import "Mbr.h"

@interface ExpertUpdatePwdViewController ()
{
    BOOL isVisible; // 密码是否可见
}
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;

@property (weak, nonatomic) IBOutlet UITextField *newwPaeewordTextField;

@property (weak, nonatomic) IBOutlet UIImageView *visibleImageView;

@property (weak, nonatomic) IBOutlet UIButton *updateButton;

- (IBAction)setPasswordvisibleAction:(id)sender;

- (IBAction)updateAction:(id)sender;

@end

@implementation ExpertUpdatePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改密码";
    isVisible = NO;
    self.visibleImageView.image = [UIImage imageNamed:@"login_icon_eye"];
    self.newwPaeewordTextField.secureTextEntry = YES;
    
    self.updateButton.layer.cornerRadius = 4.0;
    self.updateButton.layer.masksToBounds = YES;
    
    [self.oldPasswordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.newwPaeewordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.oldPasswordTextField.keyboardType = UIKeyboardTypeDefault;
    self.newwPaeewordTextField.keyboardType = UIKeyboardTypeDefault;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardDown)];
    [self.view addGestureRecognizer:tap];
}

- (void)keyBoardDown
{
    [self.view endEditing:YES];
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
    maxNum = 16;
    
    if (toBeString.length > maxNum) {
        textView.text = [toBeString substringToIndex:maxNum];
    }
}

#pragma mark ---- 设置密码是否可见 ----
- (IBAction)setPasswordvisibleAction:(id)sender
{
    if (isVisible)
    {
        // 密码隐藏
        
        self.visibleImageView.image = [UIImage imageNamed:@"login_icon_eye"];
        self.newwPaeewordTextField.secureTextEntry = YES;
        isVisible = NO;
        
    }else
    {
        // 密码可见
        
        self.visibleImageView.image = [UIImage imageNamed:@"login_icon_eye_click"];
        self.newwPaeewordTextField.secureTextEntry = NO;
        isVisible = YES;
    }
}

#pragma mark ---- 确认修改 ----
- (IBAction)updateAction:(id)sender
{
    [self.view endEditing:YES];
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:@"网络未连接，请重试" duration:0.8f];
        self.updateButton.enabled = YES;
        return;
    }
    
    if (self.oldPasswordTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入当前密码"];
         self.updateButton.enabled = YES;
         return;
    }
    
    if (![self.oldPasswordTextField.text isEqualToString:QWGLOBALMANAGER.configure.expertPassword]) {
        [SVProgressHUD showErrorWithStatus:@"当前密码输入错误，请重新输入"];
        self.updateButton.enabled = YES;
        return;
    }
    
    if (self.newwPaeewordTextField.text.length < 6 || self.newwPaeewordTextField.text.length > 16) {
        [SVProgressHUD showErrorWithStatus:@"密码输入不符合规范，请重新输入"];
        self.updateButton.enabled = YES;
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"oldPwd"] = StrFromObj(self.oldPasswordTextField.text);
    setting[@"newPwd"] = StrFromObj(self.newwPaeewordTextField.text);
    setting[@"oldCredentials"] = [AESUtil encryptAESData:self.oldPasswordTextField.text app_key:AES_KEY];
    setting[@"newCredentials"] = [AESUtil encryptAESData:self.newwPaeewordTextField.text app_key:AES_KEY];
    
    [Mbr MbrExpertUpdatePasswordWithParams:setting success:^(id DFUserModel) {
        
        BaseAPIModel *model = [BaseAPIModel parse:DFUserModel];
        if ([model.apiStatus integerValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"密码修改成功，请重新登录"];
            
            //退出登录
            [QWGLOBALMANAGER postNotif:NotifQuitOut data:nil object:nil];
            [QWGLOBALMANAGER saveAppConfigure];
            [QWGLOBALMANAGER clearExpertAccountInformation];
            [QWUserDefault setBool:YES key:@"expertupdatepassword"];
            [QWUserDefault setBool:NO key:APP_LOGIN_STATUS];
        }else
        {
            self.updateButton.enabled = YES;
            [SVProgressHUD showErrorWithStatus:model.apiMessage];
        }
        
    } failure:^(HttpException *e) {
        self.updateButton.enabled = YES;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
