//
//  FindPwdViewController.m
//  APP
//
//  Created by qwfy0006 on 15/3/19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "FindPwdViewController.h"
#import "ZhPMethod.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "Store.h"
#import "Mbr.h"
#import "StoreModelR.h"

@interface FindPwdViewController ()<UITextFieldDelegate>
{
    BOOL regist;
}

@property (assign, nonatomic)    CGRect    rectone;
@property (assign, nonatomic)    CGRect    recttwo;
@property (assign, nonatomic)    CGRect    rectthree;
@property (assign, nonatomic)    CGRect    rectfour;
@property (strong, nonatomic)    UILabel   *lable;

@property (strong, nonatomic) IBOutlet   UIButton       *btn_checkNum;
@property (strong, nonatomic) IBOutlet   UITextField    *text_PhoneNum;
@property (strong, nonatomic) IBOutlet   UILabel        *lbl_timeNum;
@property (strong, nonatomic) IBOutlet   UITextField    *text_CheckNum;
@property (strong, nonatomic) IBOutlet   UITextField    *text_Password;
@property (strong, nonatomic) IBOutlet   UITextField    *text_PwdAgain;
@property (strong, nonatomic) IBOutlet   UITextField    *text_userName;
@property (strong, nonatomic) IBOutlet   UIScrollView   *scrollV;
@property (weak, nonatomic)   IBOutlet   UIView         *backviews;
@property (weak, nonatomic)   IBOutlet   UIImageView    *lineview_one;
@property (weak, nonatomic)   IBOutlet   UIImageView    *lineview_two;
@property (weak, nonatomic)   IBOutlet   UIImageView    *lineview_three;
@property (weak, nonatomic)   IBOutlet   UIImageView    *lineview_four;
@property (weak, nonatomic)   IBOutlet   UIImageView    *lineview_five;

- (IBAction)getCheckNumAction:(id)sender;

@end

@implementation FindPwdViewController

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
    
      self.title = @"找回密码";
    self.rectone=self.lineview_three.frame;
    self.recttwo=self.lineview_five.frame;
    self.rectthree=self.text_Password.frame;
    self.rectfour=self.text_PwdAgain.frame;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getusername:) name:UITextFieldTextDidChangeNotification object:nil];
    
    self.lable=[[UILabel alloc]initWithFrame:CGRectMake(10, self.lineview_four.frame.origin.y+self.lineview_four.frame.size.height+15, 310, 30)];
    self.lable.font=[UIFont systemFontOfSize:14.0f];
    self.lable.textColor=[UIColor colorWithRed:156/255.0f green:156/255.0f blue:156/255.0f alpha:1];
  
    self.scrollV.backgroundColor=[UIColor colorWithRed:236/255.0f green:240/255.0f blue:241/255.0f alpha:1];
    
    self.lineview_one.layer.borderWidth = 0.5f;
    self.lineview_one.layer.borderColor = RGBHex(kColor8).CGColor;
    
    self.lineview_three.layer.borderWidth = 0.5f;
    self.lineview_three.layer.borderColor = RGBHex(kColor8).CGColor;
    
    self.lineview_two.layer.borderWidth = 0.5f;
    self.lineview_two.layer.borderColor = RGBHex(kColor8).CGColor;
    
    self.lineview_four.layer.borderWidth = 0.5f;
    self.lineview_four.layer.borderColor = RGBHex(kColor8).CGColor;
    
    self.lineview_five.layer.borderWidth = 0.5f;
    self.lineview_five.layer.borderColor = RGBHex(kColor8).CGColor;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 18);
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = fontSystem(kFontSize15);
    [btn addTarget:self action:@selector(saveNewPwdAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    btn.backgroundColor= [UIColor clearColor];
    
//    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(saveNewPwdAction)];
//    self.navigationItem.rightBarButtonItem = rightBtn;
    
    if (self.accout.length > 0) {
        self.text_userName.text = self.accout;
    }
    [self setUpForDismissKeyboard];
    
}


//点击空白 收起键盘
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
        self.scrollV.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        
    }];
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if(QWGLOBALMANAGER.getForgetPasswordTimer) {
//        NSMutableDictionary *userInfo = QWGLOBALMANAGER.getForgetPasswordTimer.userInfo;
//        NSInteger countDonw = [userInfo[@"countDown"] integerValue];
//        self.lbl_timeNum.backgroundColor = [UIColor grayColor];
//        self.lbl_timeNum.text = [NSString stringWithFormat:@"验证码(%ds)", countDonw];;
//    }else{
//        self.lbl_timeNum.backgroundColor = [UIColor colorWithRed:236/255.0f green:153/255.0f blue:38/255.0f alpha:1.0];
//    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.text_PhoneNum) {
        [self.text_CheckNum becomeFirstResponder];
    }
    if (textField == self.text_CheckNum) {
        [self.text_Password becomeFirstResponder];
    }
    if (textField == self.text_Password) {
        [self.text_PwdAgain becomeFirstResponder];
    }
    if (textField == self.text_PwdAgain) {
        [self.text_PwdAgain resignFirstResponder];
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return YES;
}
-(void)getusername:(NSNotification *)sender{
    UITextField *text=(UITextField *)sender.object;
    if (text==self.text_PhoneNum) {
        if ([self.text_PhoneNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0) {
            [self.lable removeFromSuperview];
            self.lineview_three.frame=self.rectone;
            self.lineview_five.frame=self.recttwo;
            self.text_Password.frame=self.rectthree;
            self.text_PwdAgain.frame=self.rectfour;
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == self.text_Password) {
        [UIView animateWithDuration:0.8 animations:^{
            self.scrollV.contentOffset = CGPointMake(0, 70);
        } completion:^(BOOL finished) {
        }];
    }
    if (textField == self.text_PwdAgain) {
        [UIView animateWithDuration:1 animations:^{
            self.scrollV.contentOffset = CGPointMake(0, 120);
        } completion:^(BOOL finished) {
        }];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark ====
#pragma mark ==== 获取验证码

- (IBAction)getCheckNumAction:(id)sender {
    
    if (self.text_PhoneNum.text.length == 11 &&isPhoneNumber(self.text_PhoneNum.text) ){//如果是手机号
        //检测用户手机是否注册
        MobileValidModelR *model = [MobileValidModelR new];
        model.mobile = self.text_PhoneNum.text;
        
        [Store MobileValidWithParams:model success:^(id obj) {
            
            if ([obj[@"apiStatus"] intValue] == 0) {
                
                [SVProgressHUD showErrorWithStatus:@"此手机号还未注册，请重新填写" duration:DURATION_SHORT];
                
            }else{
                
                self.lbl_timeNum.backgroundColor = [UIColor grayColor];
                self.lbl_timeNum.text=@"验证码(60s)";
                self.btn_checkNum.enabled=NO;
                [QWGLOBALMANAGER startForgetPasswordVerifyCode:self.text_PhoneNum.text];
                
                NSMutableDictionary *dics=[NSMutableDictionary dictionary];
                dics[@"mobile"] = StrFromObj([self.text_PhoneNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]);
                
                [Store FetchLoginNameByPhoneWithParams:dics success:^(id obj) {
                    
                    NSString *username = obj[@"loginName"];
                    NSString *str=[NSString stringWithFormat:@"您的账号为:%@",username];
                    self.lable.text=str;
                    [self.scrollV addSubview:self.lable];
                    self.lineview_three.frame=CGRectMake(self.lineview_three.frame.origin.x,self.lineview_three.frame.origin.y+20,self.lineview_three.frame.size.width, self.lineview_three.frame.size.height);
                    self.lineview_five.frame=CGRectMake(self.lineview_five.frame.origin.x,self.lineview_five.frame.origin.y+20,self.lineview_five.frame.size.width, self.lineview_five.frame.size.height);
                    self.text_Password.frame=CGRectMake(self.text_Password.frame.origin.x,self.text_Password.frame.origin.y+20,self.text_Password.frame.size.width, self.text_Password.frame.size.height);
                    self.text_PwdAgain.frame=CGRectMake(self.text_PwdAgain.frame.origin.x,self.text_PwdAgain.frame.origin.y+20,self.text_PwdAgain.frame.size.width, self.text_PwdAgain.frame.size.height);
                    
                } failure:^(HttpException *e) {
                    
                }];
            }
 
        } failure:^(HttpException *e) {
   
        }];
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"请输入手机号，11位数字" duration:DURATION_SHORT];
    }
    
}

#pragma mark =====
#pragma mark ===== 验证码倒计时

-(void)receiveNumAction:(NSInteger)count
{
    self.lbl_timeNum.backgroundColor = [UIColor grayColor];
    self.lbl_timeNum.text =[NSString stringWithFormat:@"验证码(%ds)", count];
    if ( count <= 0) {
        self.lbl_timeNum.text = @"获取验证码" ;
        self.lbl_timeNum.backgroundColor = [UIColor colorWithRed:236/255.0f green:153/255.0f blue:38/255.0f alpha:1.0];
        self.btn_checkNum.enabled = YES;
    }else{

        self.btn_checkNum.enabled = NO;
    }
}

#pragma mark ======
#pragma mark ====== 保存新密码

-(void)saveNewPwdAction{
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试" duration:DURATION_SHORT];
        return;
    }
    
    if ([self.text_PhoneNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length < 11 || [self.text_PhoneNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号，11位数字" duration:DURATION_SHORT];
    }else if (!isPhoneNumber([self.text_PhoneNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]])) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码" duration:DURATION_SHORT];
    }
    
    else if (self.text_Password.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请设置密码" duration:DURATION_SHORT];
    }else if(!isSpecialstring(self.text_Password.text)){
        [SVProgressHUD showErrorWithStatus:@"密码格式应为数字或字母" duration:DURATION_SHORT];
    }else if (self.text_PwdAgain.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"两次密码不一致" duration:DURATION_SHORT];
    }else if (![self.text_PwdAgain.text isEqualToString:self.text_Password.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次密码不一致" duration:DURATION_SHORT];
    }else{
        NSMutableDictionary * setting = [NSMutableDictionary dictionary];
        setting[@"account"] = StrFromObj([self.lable.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]);
        setting[@"mobile"] = StrFromObj([self.text_PhoneNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]);
        setting[@"newPwd"] = StrFromObj(self.text_Password.text);
        setting[@"code"] = StrFromObj([self.text_CheckNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]);
        //有可能替换的
        StatisticsModel *model = [StatisticsModel new];
        model.eventId = @"d-wjmm";
        [QWCLICKEVENT qwTrackEventModel:model];

        [Store ResetPasswordWithParams:setting success:^(id obj) {
            
            if ([obj[@"apiStatus"] intValue] == 0) {
                [SVProgressHUD showErrorWithStatus:@"密码修改成功" duration:DURATION_SHORT];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                
                [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"] duration:DURATION_SHORT];
            }
            
        } failure:^(HttpException *e) {
            
        }];
        
    }
}

- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    if(type == NotiCountDonwForgetPassword) {
        [self receiveNumAction:[data integerValue]];
    }
}

@end
