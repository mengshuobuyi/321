//
//  EditPhoneViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/6/8.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "EditPhoneViewController.h"
#import "Mbr.h"
#import "Store.h"

@interface EditPhoneViewController ()

// 手机号
@property (weak, nonatomic) IBOutlet UIView *phoneBgView;

// 验证码
@property (weak, nonatomic) IBOutlet UIView *codeBgView;

// 手机号
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

// 验证码
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

// 获取验证码
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;

@property (weak, nonatomic) IBOutlet UILabel *getCodeLabel;

// 发送验证码
- (IBAction)getCodeAction:(id)sender;

@end

@implementation EditPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"手机号";
    
    self.getCodeButton.userInteractionEnabled = YES;
    [self ConfigureCodeButtonWith:@"发送验证码" color:RGBHex(qwColor1)];

    self.phoneTextField.text = self.phoneNumber;
    
    self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    self.codeTextField.keyboardType = UIKeyboardTypePhonePad;
    self.phoneTextField.delegate = self;
    self.codeTextField.delegate = self;
    self.phoneTextField.tag = 1;
    self.codeTextField.tag = 2;
    
    [self.phoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.codeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.phoneTextField setValue:RGBHex(qwColor9) forKeyPath:@"_placeholderLabel.textColor"];
    [self.codeTextField setValue:RGBHex(qwColor9) forKeyPath:@"_placeholderLabel.textColor"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
}

#pragma mark ---- 保存 ----
- (void)saveAction
{
    [self.view endEditing:YES];
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
        return;
    }

    if ([[self.phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]length] == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号" duration:DURATION_SHORT];
        return;
    }else if (![QWGLOBALMANAGER isPhoneNumber:[self.phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]){
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号" duration:DURATION_SHORT];
        return;
    }
    
    if ([[self.codeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]length] == 0) {
        [SVProgressHUD showErrorWithStatus:kWaring41 duration:DURATION_SHORT];
        return;
    }
    //先校验验证码
    ValidVerifyCodeModelR *validModelR = [[ValidVerifyCodeModelR alloc] init];
    validModelR.mobile = self.phoneTextField.text;
    validModelR.code = self.codeTextField.text;
    validModelR.type = @6;
    [Mbr ValidVerifyCodeWithParam:validModelR success:^(id responseObj) {
        
        StoreModel *model=responseObj;
        if([model.apiStatus intValue]==0)
        {
            [Mbr MobileValidWithMobile:[QWGLOBALMANAGER removeSpace:self.phoneTextField.text] success:^(id responseObj) {
                
                if ([responseObj[@"apiStatus"] integerValue] == 0)
                {
                    //手机号未注册
                    NSString *comlun = [NSString stringWithFormat:@"%@",@"account.mobile"];
                    
                    NSString *oldValue = [NSString stringWithFormat:@"%@",StrFromObj(self.phoneNumber)];
                    NSString *newValue = [NSString stringWithFormat:@"%@",[QWGLOBALMANAGER removeSpace:self.phoneTextField.text]];
                    
                    [self commitInfoWithComlun:comlun oldValue:oldValue newValue:newValue];
                }else
                {
                    [SVProgressHUD showErrorWithStatus:responseObj[@"apiMessage"] duration:DURATION_SHORT];
                }
                
            } failure:^(HttpException *e) {

            }];
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:model.apiMessage duration:DURATION_SHORT];
        }
    } failure:^(HttpException *e) {

    }];
}

- (void)commitInfoWithComlun:(NSString *)comlun oldValue:(NSString *)oldValue newValue:(NSString *)newValue{
    NSMutableDictionary * setting = [NSMutableDictionary dictionary];
    
    setting[@"branchId"] = QWGLOBALMANAGER.configure.groupId;
    setting[@"column"] = comlun;
    setting[@"oldValue"] = oldValue;
    setting[@"newValue"] = newValue;
    [Store UpdateBranchWithParams:setting success:^(id responseObj) {
        
        [SVProgressHUD showSuccessWithStatus:@"保存成功！" duration:DURATION_LONG];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(HttpException *e) {

    }];
}

#pragma mark ---- 获取验证码 ui 改变 ----

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

#pragma mark ---- 键盘down ----

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if (QWGLOBALMANAGER.getStoreEditPhoneCd>0) {
        [self ConfigureCodeButtonWith:[NSString stringWithFormat:@"验证码(%d)s",QWGLOBALMANAGER.getStoreEditPhoneCd] color:RGBHex(qwColor9)];
    }else{
        [self ConfigureCodeButtonWith:@"发送验证码" color:RGBHex(qwColor1)];
    }
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
            [self judgeTextFieldTextChange:textField];
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        [self judgeTextFieldTextChange:textField];
    }
}

- (void)judgeTextFieldTextChange:(UITextField *)textField
{
    UITextField *textView = textField;
    NSString *toBeString = textView.text;
    
    int maxNum;
    
    if (textView.tag == 1) {//手机号码
        maxNum = 11;
    }else if (textView.tag == 2){//验证码
        maxNum = 6;
    }
    
    if (toBeString.length > maxNum) {
        textView.text = [toBeString substringToIndex:maxNum];
    }
    
}

#pragma mark ---- 计时器执行方法 ----

- (void)reGetVerifyCodeControl:(NSInteger)count
{
    if (count == 0) {
        self.getCodeButton.userInteractionEnabled = YES;
        [self ConfigureCodeButtonWith:@"发送验证码" color:RGBHex(qwColor1)];
    }else{
        self.getCodeButton.userInteractionEnabled = NO;
        [self ConfigureCodeButtonWith:[NSString stringWithFormat:@"验证码(%ld)s",(long)count] color:RGBHex(qwColor9)];
        
    }
}

- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    if(type == NotiCountStoreEditPhone) {
        [self reGetVerifyCodeControl:[data integerValue]];
    }
}

- (IBAction)getCodeAction:(id)sender
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
        return;
    }
    
    //手机号
    if (self.phoneTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号" duration:0.8];
        return;
    }
    
    if (![QWGLOBALMANAGER isTelPhoneNumber:self.phoneTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号" duration:0.8];
        return;
    }
    
    [Mbr MobileValidWithMobile:[QWGLOBALMANAGER removeSpace:self.phoneTextField.text] success:^(id responseObj) {
        if ([responseObj[@"apiStatus"] isEqualToNumber:@0])
        {
            //手机号未注册
            [QWGLOBALMANAGER startStoreEditPhoneVerifyCode:self.phoneTextField.text];
            
        }else if([responseObj[@"apiStatus"] isEqualToNumber:@1])
        {
            //此号码已存在,则发送验证码
            [SVProgressHUD showErrorWithStatus:responseObj[@"apiMessage"] duration:DURATION_SHORT];
        }else
        {
            //手机号不能为空
            [SVProgressHUD showErrorWithStatus:responseObj[@"apiMessage"] duration:DURATION_SHORT];
        }
    } failure:^(HttpException *e) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
