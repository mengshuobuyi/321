//
//  SoftwareDetailViewController.m
//  wenYao-store
//
//  Created by YYX on 15/7/6.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "SoftwareDetailViewController.h"
#import "SVProgressHUD.h"
#import "Branch.h"
#import "SoftwareUserInfoViewController.h"

static NSInteger maxPayAccountNum = 100;    //支付宝最大数字
static NSInteger maxBankAccountNum = 19;    //银行卡最大数字
static NSInteger maxOpenBankNameNum = 50;   //开户行最大数字
static NSInteger maxIDCardNum = 18;         //身份证最大数字

@interface SoftwareDetailViewController ()

{
    BOOL isFirst;  // 是否第一次进入页面
    BOOL isHaveEdited;  // 是否经过编辑(账号内容是否改变)
}

@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *openBankTips;

@end

@implementation SoftwareDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction:)];
    
    self.view.backgroundColor = RGBHex(qwColor11);
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.borderColor = RGBHex(qwColor10).CGColor;
    self.textField.delegate = self;
    
    //银行卡调取数字键盘
    if (self.type == Enum_SoftwareUser_Type_BankAccount) {
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    if (self.type == Enum_SoftwareUser_Type_OpenBank) {
        self.openBankTips.hidden = NO;
    }
    
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard)];
    [self.view addGestureRecognizer:tap];
    
    isHaveEdited = NO;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.content && ![self.content isEqualToString:@""]) {
        
        // 原账号已有内容  在输入框显示
        self.textField.text = self.content;
        isFirst = YES;
        
    }else
    {
        // 原账号内容为空， 键盘 up
        [self.textField becomeFirstResponder];
    }
}

#pragma mark ---- 键盘down ----

- (void)dismissKeyBoard
{
    [UIView animateWithDuration:0.5 animations:^{
        
    } completion:^(BOOL finished) {
        [self.view endEditing:YES];
    }];
}

#pragma mark ---- 监听文本变化 ----

- (void)textFieldDidChange:(UITextField *)textField
{
    UITextField *textView = textField;
    NSString *toBeString = textView.text;
    NSString *lang = [[textView textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            
            if (self.type == Enum_SoftwareUser_Type_PayAccount)
            {
                //支付宝
                
                if (toBeString.length > maxPayAccountNum) {
                    textView.text = [toBeString substringToIndex:maxPayAccountNum];
                    [SVProgressHUD showErrorWithStatus:kWarning215N16 duration:0.8];
                }
                self.trueStr = textView.text;
                
            }else if (self.type == Enum_SoftwareUser_Type_BankAccount)
            {
                //银行卡号
                
                if (toBeString.length > maxBankAccountNum) {
                    textView.text = [toBeString substringToIndex:maxBankAccountNum];
                    [SVProgressHUD showErrorWithStatus:kWarning215N17 duration:0.8];
                }
                self.trueStr = textView.text;
                
            }else if (self.type == Enum_SoftwareUser_Type_OpenBank)
            {
                //开户行
                
                if (toBeString.length > maxOpenBankNameNum) {
                    textView.text = [toBeString substringToIndex:maxOpenBankNameNum];
                    [SVProgressHUD showErrorWithStatus:kWarning215N26 duration:0.8];
                }
                self.trueStr = textView.text;
                
            }else if (self.type == Enum_SoftwareUser_Type_IDCard)
            {
                //身份证
                
                if (toBeString.length > maxIDCardNum) {
                    textView.text = [toBeString substringToIndex:maxIDCardNum];
                    [SVProgressHUD showErrorWithStatus:kWarning215N18 duration:0.8];
                }
                self.trueStr = textView.text;
                
            }
            
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        
        if (self.type == Enum_SoftwareUser_Type_PayAccount)
        {
            //支付宝
            
            if (toBeString.length > maxPayAccountNum) {
                textView.text = [toBeString substringToIndex:maxPayAccountNum];
                [SVProgressHUD showErrorWithStatus:kWarning215N16 duration:0.8];
            }
            self.trueStr = textView.text;
            
        }else if (self.type == Enum_SoftwareUser_Type_BankAccount)
        {
            //银行卡号
            
            if (toBeString.length > maxBankAccountNum) {
                textView.text = [toBeString substringToIndex:maxBankAccountNum];
                [SVProgressHUD showErrorWithStatus:kWarning215N17 duration:0.8];
            }
            self.trueStr = textView.text;
            
        }else if (self.type == Enum_SoftwareUser_Type_OpenBank)
        {
            //开户行
            
            if (toBeString.length > maxOpenBankNameNum) {
                textView.text = [toBeString substringToIndex:maxOpenBankNameNum];
                [SVProgressHUD showErrorWithStatus:kWarning215N26 duration:0.8];
            }
            self.trueStr = textView.text;
            
        }else if (self.type == Enum_SoftwareUser_Type_IDCard)
        {
            //身份证
            
            if (toBeString.length > maxIDCardNum) {
                textView.text = [toBeString substringToIndex:maxIDCardNum];
                [SVProgressHUD showErrorWithStatus:kWarning215N18 duration:0.8];
            }
            self.trueStr = textView.text;
        }
    }
}

#pragma mark ---- UITextFieldDelegate ----

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    isHaveEdited = YES;  // 已编辑状态
    
    if (isFirst) {
        
        if (self.type == Enum_SoftwareUser_Type_OpenBank) {
            
        }else
        {
            // 光标第一次指向输入框，输入框的内容要清空
            
            self.textField.text = @"";
            self.trueStr = self.textField.text;
            isFirst = NO;
        }
    }else
    {
    }
}

#pragma mark ---- 保存数据 ----

- (void)saveAction:(id)sender
{
    [self.textField resignFirstResponder];
    
    // 断网提示
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring12 duration:0.8];
        return;
    }else
    {
        
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);  //token
        
        if (self.type == Enum_SoftwareUser_Type_PayAccount)
        {
            //支付宝
            
             self.trueStr = [self.trueStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            if (self.trueStr.length == 0) {
                [SVProgressHUD showErrorWithStatus:kWarning215N30 duration:0.8];
                return;
            }
            if (self.trueStr.length > 0) {
                
                // 验证支付宝账号是否正确
                
                if (![QWGLOBALMANAGER isPhoneNumber:self.trueStr] && ![QWGLOBALMANAGER isEmailAddress:self.trueStr])
                {
                    [SVProgressHUD showErrorWithStatus:kWarning215N15 duration:0.8];
                    return;
                }
            }
            
            setting[@"alipay"] = self.trueStr;
            
        }else if (self.type == Enum_SoftwareUser_Type_BankAccount)
        {
            //银行卡
            
             self.trueStr = [self.trueStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            if (self.trueStr.length == 0) {
                [SVProgressHUD showErrorWithStatus:kWarning215N32 duration:0.8];
                return;
            }
            if (self.trueStr.length < 16) {
                [SVProgressHUD showErrorWithStatus:kWarning215N38 duration:0.8];
                return;
            }
            
            setting[@"bankCard"] = self.trueStr;
            
            
        }else if (self.type == Enum_SoftwareUser_Type_OpenBank)
        {
            //开户行
            
            if (self.trueStr.length == 0) {
                [SVProgressHUD showErrorWithStatus:kWarning215N33 duration:0.8];
                return;
            }
            setting[@"bankName"] = self.trueStr;
            
        }else if (self.type == Enum_SoftwareUser_Type_IDCard)
        {
            //身份证
            
            if (self.trueStr.length == 0) {
                [SVProgressHUD showErrorWithStatus:kWarning215N34 duration:0.8];
                return;
            }
            if (self.trueStr.length > 0) {
                
                // 验证身份证是否正确
                
                if (![QWGlobalManager validateIDCardNumber:self.trueStr]) {
                    [SVProgressHUD showErrorWithStatus:kWarning215N19 duration:0.8];
                    return;
                }
            }
            setting[@"ic"] = self.trueStr;
        }

        
        if (isHaveEdited)
        {
            //输入框已编辑状态
            
            if (![self.textField.text isEqualToString:self.trueString]) {
            
                // 新输入账号的值 与 原有账号的值不同，需上传服务器
                
                [Branch UpdateSoftwareuserInfoWithParams:setting success:^(id obj) {
                    
                    if ([obj[@"apiStatus"] integerValue] == 0) {
                        
                        if (self.type == Enum_SoftwareUser_Type_PayAccount) {
                            
                            [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                UIViewController *viewController=(UIViewController *)obj;
                                if ([viewController isKindOfClass:[SoftwareUserInfoViewController class]]) {
                                    [self.navigationController popToViewController:viewController animated:YES];
                                    *stop = YES;
                                }else if(idx == (self.navigationController.viewControllers.count - 1)){
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                            }];
                            
                        }else {
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        
                        [SVProgressHUD showSuccessWithStatus:kWarning215N31 duration:0.8];
                        
                    }else
                    {
                        [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"] duration:0.8];
                    }
                    
                } failure:^(HttpException *e) {
                    
                }];

                
            }else
            {
                // 账号的新值 与 旧值 相同 执行成功操作，不许上传服务器
                
                if (self.type == Enum_SoftwareUser_Type_PayAccount) {
                    
                    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        UIViewController *viewController=(UIViewController *)obj;
                        if ([viewController isKindOfClass:[SoftwareUserInfoViewController class]]) {
                            [self.navigationController popToViewController:viewController animated:YES];
                            *stop = YES;
                        }else if(idx == (self.navigationController.viewControllers.count - 1)){
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }];
                    
                }else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
                [SVProgressHUD showSuccessWithStatus:kWarning215N31 duration:0.8];
            }
            
            
            
        }else
        {
            // 输入框未编辑状态
            
            // 账号未改变 执行成功操作，不许上传服务器
            
            if (self.type == Enum_SoftwareUser_Type_PayAccount) {
                
                [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    UIViewController *viewController=(UIViewController *)obj;
                    if ([viewController isKindOfClass:[SoftwareUserInfoViewController class]]) {
                        [self.navigationController popToViewController:viewController animated:YES];
                        *stop = YES;
                    }else if(idx == (self.navigationController.viewControllers.count - 1)){
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
                
            }else {
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            [SVProgressHUD showSuccessWithStatus:kWarning215N31 duration:0.8];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
