//
//  ExpertSetPwdViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/4/13.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ExpertSetPwdViewController.h"
#import "Mbr.h"

@interface ExpertSetPwdViewController ()
{
    BOOL isVisible; // 密码是否可见
}
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIImageView *visibleImageView;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

- (IBAction)setPasswordVisibleAction:(id)sender;
- (IBAction)commitAction:(id)sender;

@end

@implementation ExpertSetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置新密码";
    
    self.phoneLabel.text = QWGLOBALMANAGER.configure.expertMobile;
    
    isVisible = NO;
    self.visibleImageView.image = [UIImage imageNamed:@"login_icon_eye"];
    self.pwdTextField.secureTextEntry = YES;
    
    self.commitButton.layer.cornerRadius = 4.0;
    self.commitButton.layer.masksToBounds = YES;
    
    self.pwdTextField.keyboardType = UIKeyboardTypeDefault;
    [self.pwdTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
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
- (IBAction)setPasswordVisibleAction:(id)sender
{
    if (isVisible)
    {
        // 密码隐藏
        
        self.visibleImageView.image = [UIImage imageNamed:@"login_icon_eye"];
        self.pwdTextField.secureTextEntry = YES;
        isVisible = NO;
        
    }else
    {
        // 密码可见
        
        self.visibleImageView.image = [UIImage imageNamed:@"login_icon_eye_click"];
        self.pwdTextField.secureTextEntry = NO;
        isVisible = YES;
    }
}

#pragma mark ---- 提交 ----
- (IBAction)commitAction:(id)sender
{
    [self.view endEditing:YES];
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:@"网络未连接，请重试" duration:0.8f];
        self.commitButton.enabled = YES;
        return;
    }
    
    if (self.pwdTextField.text.length < 6 || self.pwdTextField.text.length > 16) {
        [SVProgressHUD showErrorWithStatus:@"密码输入不符合规范，请重新输入"];
        self.commitButton.enabled = YES;
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"newPwd"] = StrFromObj(self.pwdTextField.text);
    [Mbr MbrExpertUpdatePasswordWithParams:setting success:^(id DFUserModel) {
        
        BaseAPIModel *model = [BaseAPIModel parse:DFUserModel];
        if ([model.apiStatus integerValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"密码设置成功"];
            QWGLOBALMANAGER.configure.expertIsSetPwd = YES;
            QWGLOBALMANAGER.configure.expertPassword = StrFromObj(self.pwdTextField.text);
            [QWGLOBALMANAGER saveAppConfigure];
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            self.commitButton.enabled = YES;
            [SVProgressHUD showErrorWithStatus:model.apiMessage];
        }
        
    } failure:^(HttpException *e) {
        self.commitButton.enabled = YES;
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
