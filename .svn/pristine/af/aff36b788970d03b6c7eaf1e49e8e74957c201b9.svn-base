//
//  AliPayCheckPhoneViewController.m
//  wenYao-store
//
//  Created by YYX on 15/7/7.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "AliPayCheckPhoneViewController.h"
#import "SVProgressHUD.h"
#import "Branch.h"
#import "SoftwareDetailViewController.h"
#import "Mbr.h"
#import "EditDetailViewController.h"

@interface AliPayCheckPhoneViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *verifyButton;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UILabel *getCodeLabel;

@property (weak, nonatomic) IBOutlet UITextField *codeTextfiedld;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) NSTimer *reGetVerifyTimer;

- (IBAction)verifyPhoneAction:(id)sender;
- (IBAction)getVerifyCodeAction:(id)sender;

@end

@implementation AliPayCheckPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"验证";
    self.view.backgroundColor = RGBHex(qwColor11);
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.borderColor = RGBHex(qwColor10).CGColor;
    
    self.verifyButton.layer.cornerRadius = 3.0;
    self.verifyButton.layer.masksToBounds = YES;

    self.getCodeButton.userInteractionEnabled = YES;
    [self ConfigureCodeButtonWith:@"发送验证码" color:RGBHex(qwColor1)];
    
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.phoneLabel.text = self.phoneNumber;
    
    if (QWGLOBALMANAGER.getChangeAlipayCd > 0) {
        [self ConfigureCodeButtonWith:[NSString stringWithFormat:@"发送验证码(%d)s",QWGLOBALMANAGER.getChangeAlipayCd] color:RGBHex(qwColor9)];
    }else{
        [self ConfigureCodeButtonWith:@"发送验证码" color:RGBHex(qwColor1)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//获取验证码

- (IBAction)getVerifyCodeAction:(id)sender
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:@"网络未连接，请重试" duration:0.8f];
        return;
    }
    
    [QWGLOBALMANAGER startChangeAliPayAccountVerifyCode:self.phoneLabel.text];

}

//计时器执行方法
- (void)reGetVerifyCodeControl:(NSInteger)count
{
    if (count == 0) {
        self.getCodeButton.userInteractionEnabled = YES;
        [self ConfigureCodeButtonWith:@"发送验证码" color:RGBHex(qwColor1)];
        
    }else{
        self.getCodeButton.userInteractionEnabled = NO;
        [self ConfigureCodeButtonWith:[NSString stringWithFormat:@"验证码(%d)s",count] color:RGBHex(qwColor9)];
    }
}

//立即验证按钮

- (IBAction)verifyPhoneAction:(id)sender
{
    self.verifyButton.enabled = NO;
    [self.view endEditing:YES];
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:@"网络未连接，请重试" duration:0.8f];
        self.verifyButton.enabled = YES;
        return;
    }
    
    if (self.codeTextfiedld.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码" duration:DURATION_SHORT];
        self.verifyButton.enabled = YES;
        return;
    }
    //  如果验证码正确,那么就跳转
    
    //先校验验证码
    ValidVerifyCodeModelR *validModelR = [[ValidVerifyCodeModelR alloc] init];
    validModelR.mobile = self.phoneLabel.text;
    validModelR.code = self.codeTextfiedld.text;
    validModelR.type = @7;
    [Mbr ValidVerifyCodeWithParam:validModelR success:^(id responseObj) {
        self.verifyButton.enabled = YES;
        StoreModel *model=responseObj;
        if([model.apiStatus intValue]==0){
            
            if (AUTHORITY_ROOT) {
                SoftwareDetailViewController *detail = [[UIStoryboard storyboardWithName:@"SoftwareUserInfo" bundle:nil] instantiateViewControllerWithIdentifier:@"SoftwareDetailViewController"];
                detail.title = @"修改支付宝账号";
                detail.content = self.content;
                detail.trueStr = self.trueStr;
                detail.trueString = self.trueString;
                detail.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:detail animated:YES];
            }else
            {
                EditDetailViewController *detail = [[UIStoryboard storyboardWithName:@"EditInformation" bundle:nil] instantiateViewControllerWithIdentifier:@"EditDetailViewController"];
                detail.title = @"修改支付宝账号";
                detail.content = self.content;
                detail.trueStr = self.trueStr;
                detail.trueString = self.trueString;
                detail.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:detail animated:YES];
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"验证码错误或过期" duration:0.8];
//            [SVProgressHUD showErrorWithStatus:model.apiMessage duration:DURATION_SHORT];
        }
    } failure:^(HttpException *e) {
        self.verifyButton.enabled = YES;
       
    }];

}

- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    if(type == NotiCountDonwChangeAliPayAccount) {
        [self reGetVerifyCodeControl:[data integerValue]];
    }
}


@end
