//
//  EditDetailViewController.m
//  wenYao-store
//
//  Created by Young on 15/5/2.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "EditDetailViewController.h"
#import "SVProgressHUD.h"
#import "EditInformationViewController.h"
#import "Employee.h"

static NSInteger maxPayAccountNum = 100;    //支付宝最大数字
static NSInteger maxBankAccountNum = 19;    //银行卡最大数字
static NSInteger maxOpenBankNameNum = 50;   //开户行最大数字
static NSInteger maxIDCardNum = 18;         //身份证最大数字
static NSInteger maxNameNum = 10;           //姓名最大数字
static NSInteger maxNameQQ = 20;            //qq最大数字
static NSInteger maxNameWeCaht = 50;        //微信最大数字

@interface EditDetailViewController ()<UITextFieldDelegate>

{
    BOOL isFirst;       // 传来的content是否有值
    BOOL isHaveEdited;  // 是否已经编辑过账号内容
}

@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *openBankTips;

@end

@implementation EditDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    isHaveEdited = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction:)];
    
    self.view.backgroundColor = RGBHex(qwColor11);
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.borderColor = RGBHex(qwColor10).CGColor;
    self.textField.delegate = self;

    //银行卡调取数字键盘
    if (self.type == Enum_Edit_Type_BankAccount) {
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    //开户行显示tip提示语
    if (self.type == Enum_Edit_Type_OpenBank) {
        self.openBankTips.hidden = NO;
    }
    
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //如果列表传过来的有值，则显示在输入框中，否则调出键盘
    if (self.content && ![self.content isEqualToString:@""])
    {
        self.textField.text = self.content;
        isFirst = YES;
        
    }else
    {
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
    NSString *lang = [[textView textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            
            [self judgeTextField:textView];
            
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        
        [self judgeTextField:textView];
    }
}

- (void)judgeTextField:(UITextField *)textField
{
    UITextField *textView = textField;
    NSString *toBeString = textView.text;
    
    if (self.type == Enum_Edit_Type_Name)
    {
        //姓名
        
        if (toBeString.length > maxNameNum) {
            textView.text = [toBeString substringToIndex:maxNameNum];
            [SVProgressHUD showErrorWithStatus:@"姓名不能超过10位字符" duration:0.8];
        }
        self.trueStr = textView.text;
        
    }else if (self.type == Enum_Edit_Type_QQ)
    {
        //QQ
        
        if (toBeString.length > maxNameQQ) {
            textView.text = [toBeString substringToIndex:maxNameQQ];
            [SVProgressHUD showErrorWithStatus:@"QQ不能超过20位字符" duration:0.8];
        }
        self.trueStr = textView.text;
        
    }else if (self.type == Enum_Edit_Type_WeChat)
    {
        //微信
        
        if (toBeString.length > maxNameWeCaht) {
            textView.text = [toBeString substringToIndex:maxNameWeCaht];
            [SVProgressHUD showErrorWithStatus:@"微信不能超过50位字符" duration:0.8];
        }
        self.trueStr = textView.text;
        
    }else if (self.type == Enum_Edit_Type_PayAccount)
    {
        //支付宝
        
        if (toBeString.length > maxPayAccountNum) {
            textView.text = [toBeString substringToIndex:maxPayAccountNum];
            [SVProgressHUD showErrorWithStatus:kWarning215N16 duration:0.8];
        }
        self.trueStr = textView.text;
        
    }else if (self.type == Enum_Edit_Type_BankAccount)
    {
        //银行卡号
        
        if (toBeString.length > maxBankAccountNum) {
            textView.text = [toBeString substringToIndex:maxBankAccountNum];
            [SVProgressHUD showErrorWithStatus:kWarning215N17 duration:0.8];
        }
        self.trueStr = textView.text;
        
    }else if (self.type == Enum_Edit_Type_OpenBank)
    {
        //开户行
        
        if (toBeString.length > maxOpenBankNameNum) {
            textView.text = [toBeString substringToIndex:maxOpenBankNameNum];
            [SVProgressHUD showErrorWithStatus:kWarning215N26 duration:0.8];
        }
        self.trueStr = textView.text;
        
    }else if (self.type == Enum_Edit_Type_IDCard)
    {
        //身份证
        
        if (toBeString.length > maxIDCardNum) {
            textView.text = [toBeString substringToIndex:maxIDCardNum];
            [SVProgressHUD showErrorWithStatus:kWarning215N18 duration:0.8];
        }
        self.trueStr = textView.text;
    }
}

#pragma mark ---- UITextFieldDelegate ----

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    isHaveEdited = YES;
    
    if (isFirst)
    {
        //如果列表传到详情页面的content有值
        
        if (self.type == Enum_Edit_Type_OpenBank || self.type == Enum_Edit_Type_QQ || self.type == Enum_Edit_Type_WeChat || self.type == Enum_Edit_Type_Name)
        {
            //开户行，qq，微信，姓名，调出键盘，光标定位在最后一位
        }else
        {
            //调出键盘，清空内容
            self.textField.text = @"";
            self.trueStr = self.textField.text;
            isFirst = NO;
        }
    }
}

#pragma mark ---- 保存数据 ----

- (void)saveAction:(id)sender
{
    [self.textField resignFirstResponder];
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable)
    {
        [SVProgressHUD showErrorWithStatus:kWaring12 duration:0.8];
        return;
    }else
    {
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);  //token
        
        if (self.type == Enum_Edit_Type_Name)
        {
            //姓名
            
            self.trueStr = [self.trueStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            if (self.trueStr.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"请输入姓名" duration:0.8];
                return;
            }
            
            setting[@"name"] = self.trueStr;
            
        }else if (self.type == Enum_Edit_Type_QQ)
        {
            //QQ
            
            self.trueStr = [self.trueStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            if (self.trueStr.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"请输入QQ号" duration:0.8];
                return;
            }
            if (![QWGLOBALMANAGER isAllNum:self.trueStr]) {
                [SVProgressHUD showErrorWithStatus:@"请输入正确的QQ号" duration:0.8];
                return;
            }
            
            setting[@"qq"] = self.trueStr;
            
        }else if (self.type == Enum_Edit_Type_WeChat)
        {
            //微信
            
            self.trueStr = [self.trueStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            if (self.trueStr.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"请输入微信号" duration:0.8];
                return;
            }
            
            setting[@"wx"] = self.trueStr;
            
        }else if (self.type == Enum_Edit_Type_PayAccount)
        {
            //支付宝
            
             self.trueStr = [self.trueStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            if (self.trueStr.length == 0) {
                [SVProgressHUD showErrorWithStatus:kWarning215N30 duration:0.8];
                return;
            }
            if (self.trueStr.length > 0) {
                if (![QWGLOBALMANAGER isPhoneNumber:self.trueStr] && ![QWGLOBALMANAGER isEmailAddress:self.trueStr])
                {
                    [SVProgressHUD showErrorWithStatus:kWarning215N15 duration:0.8];
                    return;
                }
            }
            
            setting[@"alipay"] = self.trueStr;
            
        }else if (self.type == Enum_Edit_Type_BankAccount)
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
            
            
        }else if (self.type == Enum_Edit_Type_OpenBank)
        {
            //开户行
            
            if (self.trueStr.length == 0) {
                [SVProgressHUD showErrorWithStatus:kWarning215N33 duration:0.8];
                return;
            }
            setting[@"bankName"] = self.trueStr;
            
        }else if (self.type == Enum_Edit_Type_IDCard)
        {
            //身份证
            
            if (self.trueStr.length == 0) {
                [SVProgressHUD showErrorWithStatus:kWarning215N34 duration:0.8];
                return;
            }
            if (self.trueStr.length > 0) {
                if (![QWGlobalManager validateIDCardNumber:self.trueStr]) {
                    [SVProgressHUD showErrorWithStatus:kWarning215N19 duration:0.8];
                    return;
                }
            }
            setting[@"ic"] = self.trueStr;
        }
        
        if (isHaveEdited)
        {
            //如果编辑过输入框
            if (![self.textField.text isEqualToString:self.trueString])
            {
                //调接口上传数据
                [Employee employeeUpdateEmployeeWithParam:setting success:^(id responseObj) {
                    
                    if ([responseObj[@"apiStatus"] integerValue] == 0)
                    {
                        [self saveAndPopAction];
                    }else
                    {
                        [SVProgressHUD showErrorWithStatus:responseObj[@"apiMessage"] duration:0.8];
                    }
                    
                } failure:^(HttpException *e) {
                    [SVProgressHUD showErrorWithStatus:@"保存失败！" duration:0.8];
                }];

            }else
            {
                //编辑过的文案与原来相同，直接返回，提示保存成功
                [self saveAndPopAction];
            }
        }else
        {
            //未编辑，直接返回，提示保存成功
            [self saveAndPopAction];
        }
    }
}

- (void)saveAndPopAction
{
    if (self.type == Enum_Edit_Type_PayAccount) {
        
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIViewController *viewController=(UIViewController *)obj;
            if ([viewController isKindOfClass:[EditInformationViewController class]]) {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
