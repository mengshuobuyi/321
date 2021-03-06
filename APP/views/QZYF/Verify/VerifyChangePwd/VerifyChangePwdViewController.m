//
//  VerifyChangePwdViewController.m
//  wenYao-store
//
//  Created by YYX on 15/7/6.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "VerifyChangePwdViewController.h"

#import "AppDelegate.h"
#import "Constant.h"
#import "SVProgressHUD.h"
#import "Store.h"

@interface VerifyChangePwdViewController ()<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet      UITextField     *oldpwd;
@property (strong, nonatomic) IBOutlet      UITextField     *pwdagain;
@property (weak, nonatomic)   IBOutlet      UITextField     *neTextField;
- (IBAction)changePwdAction:(id)sender;

@end


@implementation VerifyChangePwdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"修改密码";
    UIBarButtonItem *Rightbtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(changepassword)];
    self.navigationItem.rightBarButtonItem = Rightbtn;
    [self setUpForDismissKeyboard];
}

#pragma mark =====
#pragma mark ===== 点击空白 收起键盘

- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognize{
    //此method会将self.view里所有的subview的first responder都resign掉
    [UIView animateWithDuration:1 animations:^{
        
    } completion:^(BOOL finished) {
    }];
    [self.view endEditing:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.oldpwd) {
        [self.neTextField becomeFirstResponder];
    }else if(textField == self.neTextField){
        [self.pwdagain becomeFirstResponder];
    }else{
        [self.pwdagain resignFirstResponder];
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark =====
#pragma mark ===== 修改密码

- (IBAction)changePwdAction:(id)sender {
    [self changepassword];
}

-(void)changepassword{
    
    //子账号
    if (self.oldpwd.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入旧密码" duration:DURATION_SHORT];
        return;
    }else if(self.oldpwd.text.length >= 6){
        [SVProgressHUD showErrorWithStatus:@"店员账号密码长度应为1-5位数字或字母" duration:DURATION_SHORT];
        return;
    }
    if (self.neTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入新密码" duration:DURATION_SHORT];
        return;
    }else{
        NSCharacterSet *nameCharacters = [[NSCharacterSet
                                           characterSetWithCharactersInString:@"_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
        NSRange userNameRange = [self.neTextField.text rangeOfCharacterFromSet:nameCharacters];
        NSLog(@"userNameRange = %@",NSStringFromRange(userNameRange));
        
        
        if(self.neTextField.text.length >= 6)
        {
            [SVProgressHUD showErrorWithStatus:@"请设置新密码，1~5位数字或字母" duration:DURATION_SHORT];
            return;
        }
        
        if (userNameRange.length == 1) {
            [SVProgressHUD showErrorWithStatus:@"请设置新密码，6~16位数字或字母" duration:DURATION_SHORT];
            return;
        }
    }
    
    
    if (![self.pwdagain.text isEqualToString:self.neTextField.text])
    {
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致" duration:DURATION_SHORT];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
    setting[@"newPwd"] = StrFromObj(self.neTextField.text);
    setting[@"oldPwd"] = StrFromObj(self.oldpwd.text);
    setting[@"newCredentials"] = [AESUtil encryptAESData:self.neTextField.text app_key:AES_KEY ];
    setting[@"oldCredentials"] = [AESUtil encryptAESData:self.oldpwd.text app_key:AES_KEY ];
    
    [Store UpdatePasswordWithParams:setting success:^(id obj) {
        
        if ([obj[@"apiStatus"] intValue] == 0) {
//            [QWUserDefault setBool:NO key:APP_LOGIN_STATUS];
//            [QWGLOBALMANAGER clearAccountInformation];
             QWGLOBALMANAGER.configure.passWord = self.neTextField.text;
            [QWGLOBALMANAGER saveAppConfigure];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [SVProgressHUD showSuccessWithStatus:@"密码修改成功" duration:DURATION_SHORT];
        }else{
            [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"] duration:DURATION_SHORT];
        }
        
    } failure:^(HttpException *e) {
        
    }];
    
}


@end
