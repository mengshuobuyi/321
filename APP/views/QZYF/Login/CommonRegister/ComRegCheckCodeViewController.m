//
//  ComRegCheckCodeViewController.m
//  wenYao-store
//
//  Created by YYX on 15/8/17.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "ComRegCheckCodeViewController.h"
#import "SVProgressHUD.h"
#import "Mbr.h"
#import "ComRegSetAccountViewController.h"
#import "Branch.h"
#import "Store.h"
#import "ServiceSpecificationViewController.h"

#define ServiceSpeciticationnnUrl         API_APPEND_V2(@"api/helpClass/sjzcxy")

@interface ComRegCheckCodeViewController ()<UITextFieldDelegate>

// 发送验证码
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;

// 发送验证码
@property (retain, nonatomic) IBOutlet UILabel *getCodeLabel;

// 下一步
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

// 发送验证码 方法
- (IBAction)getCodeAction:(id)sender;

// 下一步 方法
- (IBAction)nextStepAction:(id)sender;

// 商户版服务规范
- (IBAction)storeServiceAction:(id)sender;

@end

@implementation ComRegCheckCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"注册";

    self.getCodeButton.enabled = YES;
    [self ConfigureCodeButtonWith:@"发送验证码" color:RGBHex(qwColor1)];
    
    self.nextStepButton.layer.cornerRadius = 3.0;
    self.nextStepButton.layer.masksToBounds = YES;
    
    [self configureNextButtonGray];
    
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

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if (QWGLOBALMANAGER.getCommonRegisterCd>0) {
        [self ConfigureCodeButtonWith:[NSString stringWithFormat:@"验证码(%d)s",QWGLOBALMANAGER.getCommonRegisterCd] color:RGBHex(qwColor9)];
    }else{
        [self ConfigureCodeButtonWith:@"发送验证码" color:RGBHex(qwColor1)];
    }
}

#pragma mark ---- 下一步按钮置灰 ----

- (void)configureNextButtonGray
{
    self.nextStepButton.enabled = NO;
    [self.nextStepButton setBackgroundColor:RGBHex(qwColor9)];
    [self.nextStepButton setBackgroundImage:nil forState:UIControlStateNormal];
}

#pragma mark ---- 下一步按钮高亮 ----

- (void)ConfigureNextButtonBlue
{
    self.nextStepButton.enabled = YES;
    [self.nextStepButton setBackgroundImage:[UIImage imageNamed:@"btn_login_notmal"] forState:UIControlStateNormal];
    [self.nextStepButton setBackgroundImage:[UIImage imageNamed:@"btn_login_click"] forState:UIControlStateHighlighted];
    [self.nextStepButton setBackgroundImage:[UIImage imageNamed:@"btn_login_click"] forState:UIControlStateSelected];
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


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark ---- 获取验证码 ----

- (IBAction)getCodeAction:(id)sender
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:@"网络未连接，请重试" duration:0.8f];
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
    
    //检测用户手机是否注册
    MobileValidModelR *model = [MobileValidModelR new];
    model.mobile = self.phoneTextField.text;
    [Store MobileValidWithParams:model success:^(id obj) {
        
        if ([obj[@"apiStatus"] intValue] == 0) {

            [QWGLOBALMANAGER startCommonRegisterVerifyCode:self.phoneTextField.text];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"此手机号已注册，请重新填写" duration:DURATION_SHORT];
        }
        
    } failure:^(HttpException *e) {
        
    }];
    
}

//计时器执行方法
- (void)reGetVerifyCodeControl:(NSInteger)count
{
    DebugLog(@"++++++++++++++++ %li",(long)count);
    if (count == 0) {
        self.getCodeButton.enabled = YES;
        [self ConfigureCodeButtonWith:@"发送验证码" color:RGBHex(qwColor1)];
    }else{
        self.getCodeButton.enabled = NO;
        [self ConfigureCodeButtonWith:[NSString stringWithFormat:@"验证码(%ld)s",(long)count] color:RGBHex(qwColor9)];
        
    }
    
    
}

- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    if(type == NotiCountDownCommonRegister) {
        [self reGetVerifyCodeControl:[data integerValue]];
    }
}

#pragma mark ---- 下一步 ----

- (IBAction)nextStepAction:(id)sender
{
    self.nextStepButton.enabled = NO;
    [self.view endEditing:YES];
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:@"网络未连接，请重试" duration:0.8f];
        self.nextStepButton.enabled = YES;
        return;
    }
    
    if (self.codeTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码" duration:DURATION_SHORT];
        self.nextStepButton.enabled = YES;
        return;
    }
    //  如果验证码正确,那么就跳转
    
    //先校验验证码
    ValidVerifyCodeModelR *validModelR = [[ValidVerifyCodeModelR alloc] init];
    validModelR.mobile = self.phoneTextField.text;
    validModelR.code = self.codeTextField.text;
    validModelR.type = @4;
    [Mbr ValidVerifyCodeWithParam:validModelR success:^(id responseObj) {
        self.nextStepButton.enabled = YES;
        StoreModel *model=responseObj;
        if([model.apiStatus intValue]==0){
            
            ComRegSetAccountViewController *vc = [[UIStoryboard storyboardWithName:@"CommonRegister" bundle:nil] instantiateViewControllerWithIdentifier:@"ComRegSetAccountViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            vc.mobile = self.phoneTextField.text;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            [SVProgressHUD showErrorWithStatus:model.apiMessage duration:DURATION_SHORT];
        }
    } failure:^(HttpException *e) {
        self.nextStepButton.enabled = YES;
        
    }];

}

#pragma mark ---- 商户版注册协议 ----

- (IBAction)storeServiceAction:(id)sender
{
    ServiceSpecificationViewController *serviceV = [[ServiceSpecificationViewController alloc]initWithNibName:@"ServiceSpecificationViewController" bundle:nil];
    serviceV.TitleStr = @"注册协议";
    serviceV.UrlStr = ServiceSpeciticationnnUrl;
    [self.navigationController pushViewController:serviceV animated:YES];
}

@end
