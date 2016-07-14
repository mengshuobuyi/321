//
//  UserInfoViewController.m
//  wenYao-store
//
//  Created by qwfy0006 on 15/4/2.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "UserInfoViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "Store.h"

@interface UserInfoViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *text_userName;
@property (strong, nonatomic) IBOutlet UITextField *text_userPhone;

@end

@implementation UserInfoViewController

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
    self.title = @"软件使用人";
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveInfoAction)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
//    self.text_userPhone.text =[[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@/registerInfo",app.registerAccount]]objectForKey:@"mobile"];
    
    if ([QWUserDefault getObjectBy:REGISTER_JG_USERINFO]) {
        
        NSMutableDictionary *dic = [QWUserDefault getObjectBy:REGISTER_JG_USERINFO];
        self.text_userName.text = [dic objectForKey:@"name"];
        self.text_userName.delegate =self;
        self.text_userPhone.text = [dic objectForKey:@"phoneNum"];
        
    }else if ([QWUserDefault getObjectBy:REGISTER_JG_MOBILE])
    {
        self.text_userPhone.text = [QWUserDefault getObjectBy:REGISTER_JG_MOBILE];
    }
    
    [self setUpForDismissKeyboard];
}

#pragma mark ====
#pragma mark ==== 点击空白 收起键盘

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
    [self.text_userName resignFirstResponder];
    return YES;
}

#pragma mark ====
#pragma mark ==== 保存使用人信息

-(void)saveInfoAction{
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    
    if ([self.text_userName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0 ) {
        [SVProgressHUD showErrorWithStatus:@"请输入使用人姓名" duration:DURATION_SHORT];
        return;
    }else if([self.text_userName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 10){
        [SVProgressHUD showErrorWithStatus:@"请输入使用人，10个字以内" duration:DURATION_SHORT];
        return;
    }else{
        setting[@"contact"] = StrFromObj([self.text_userName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]);
    }
    
    if ([QWUserDefault getStringBy:QUICK_REGISTERACCOUNT].length > 0) {
        setting[@"mobile"] = StrFromObj([QWUserDefault getStringBy:QUICK_REGISTERACCOUNT]);
    }
    
    [Store UpdateRegisterWithParams:setting success:^(id obj) {
        
        if ([obj[@"apiStatus"] intValue] == 0) {
            [self.finishUserInfoDelegate finishUserInfoDelegate:YES];
            [QWUserDefault setBool:YES key:REGISTER_JG_FINISHUSERINFO];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"phoneNum"] = self.text_userPhone.text;
            dic[@"name"] = self.text_userName.text;
            [QWUserDefault setObject:dic key:REGISTER_JG_USERINFO];
            [self.navigationController popViewControllerAnimated:YES];

        }else{
            
            [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"] duration:DURATION_SHORT];
        }
        
    } failure:^(HttpException *e) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end