//
//  QuickRegisterPerfectViewController.m
//  wenyao-store
//
//  Created by Meng on 14-10-10.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//


#import "MapViewController.h"

#import "ZhPMethod.h"
#import "StoreModelR.h"
#import "Mbr.h"
#import "Store.h"
#import "QuickRegisterPerfectViewController.h"
#import "AppDelegate.h"
#import "Mbr.h"
#import "SVProgressHUD.h"
#import "Circle.h"
@interface QuickRegisterPerfectViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *text_PhoneNum;
@property (strong, nonatomic) IBOutlet UITextField *text_CheckNum;
@property (strong, nonatomic) IBOutlet UITextField *text_UserName;
@property (strong, nonatomic) IBOutlet UITextField *text_Password;
@property (strong, nonatomic) IBOutlet UITextField *text_PwdAgain;
@property(assign, nonatomic) int seconds;
//@property(strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) IBOutlet UIButton *btn_finish;
- (IBAction)nextStepAction:(id)sender;
- (IBAction)getCheckAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lbl_time;
@property (strong, nonatomic) IBOutlet UIButton *btn_checkNum;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *anchorHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewTopConstraint;

@end

@implementation QuickRegisterPerfectViewController

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
    self.title = @"注册";

    [self setUpForDismissKeyboard];
    
    self.btn_finish.layer.cornerRadius = 3.0;
    self.btn_finish.layer.masksToBounds = YES;
    if ([QWUserDefault getBoolBy:QUICK_HASLATITUDE]== YES) {
        [self.btn_finish setTitle:@"完成" forState:UIControlStateNormal];
    }else{
        [self.btn_finish setTitle:@"下一步" forState:UIControlStateNormal];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.text_PhoneNum becomeFirstResponder];
    
    
    if (IS_IPHONE_4_OR_LESS) {
        
        self.anchorHeightConstraint.constant = 480-64;
        
    }else if (IS_IPHONE_5){
        
        self.anchorHeightConstraint.constant = 568-64;
        
    }else if (IS_IPHONE_6){
        
        self.anchorHeightConstraint.constant = 667-64;
        
    }else if (IS_IPHONE_6P){
        
        self.anchorHeightConstraint.constant = 736-64;
    }

    self.btn_finish.enabled = YES;
    self.btn_finish.backgroundColor = RGBHex(qwColor1);
    
    if (QWGLOBALMANAGER.getVerifyCd > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self ConfigureCodeButtonWith:[NSString stringWithFormat:@"验证码(%d)s",QWGLOBALMANAGER.getVerifyCd] color:RGBHex(qwColor9)];
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self ConfigureCodeButtonWith:@"发送验证码" color:RGBHex(qwColor1)];
        });
    }
    
}

#pragma mark ---- 获取验证码 ui 改变 ----

- (void)ConfigureCodeButtonWith:(NSString *)title color:(UIColor *)color
{
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       self.lbl_time.text = title;
                       self.lbl_time.textColor = color;
                       self.lbl_time.layer.borderColor = color.CGColor;
                       self.lbl_time.layer.borderWidth = 0.5;
                       self.lbl_time.layer.cornerRadius = 2.0;
                       [self.lbl_time setNeedsDisplay];
                   });
    
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
    } completion:^(BOOL finished) {
    }];
    [self.view endEditing:YES];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.text_PhoneNum) {
        [self.text_CheckNum becomeFirstResponder];
    }
    if (textField == self.text_CheckNum) {
        [self.text_UserName becomeFirstResponder];
    }
    if (textField == self.text_UserName) {
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (IS_IPHONE_5) {
        
        if (textField == self.text_Password || textField == self.text_PwdAgain)
        {
            [self.view layoutIfNeeded];
            [UIView animateWithDuration:0.3 animations:^{
                self.anchorHeightConstraint.constant -= 30;
                self.contentViewTopConstraint.constant = 0;
                [self.view layoutIfNeeded];
            }];
        }
        
    }else if (IS_IPHONE_4_OR_LESS){
        
        if (textField == self.text_UserName)
        {
            [self.view layoutIfNeeded];
            [UIView animateWithDuration:0.3 animations:^{
                self.anchorHeightConstraint.constant -= 80;
                self.contentViewTopConstraint.constant = 0;
                [self.view layoutIfNeeded];
            }];
        }
        
        
        if (textField == self.text_Password || textField == self.text_PwdAgain)
        {
            [self.view layoutIfNeeded];
            [UIView animateWithDuration:0.3 animations:^{
                self.anchorHeightConstraint.constant -= 110;
                self.contentViewTopConstraint.constant = 0;
                [self.view layoutIfNeeded];
            }];
        }
        
    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (IS_IPHONE_5) {
        
        if (textField == self.text_Password || textField == self.text_PwdAgain)
        {
            [self.view layoutIfNeeded];
            [UIView animateWithDuration:0.3 animations:^{
                self.anchorHeightConstraint.constant += 30;
                self.contentViewTopConstraint.constant = -30;
                [self.view layoutIfNeeded];
            }];
        }
        
        
    }else if (IS_IPHONE_4_OR_LESS){
        
        
        if (textField == self.text_UserName)
        {
            [self.view layoutIfNeeded];
            [UIView animateWithDuration:0.3 animations:^{
                self.anchorHeightConstraint.constant += 80;
                self.contentViewTopConstraint.constant = -80;
                [self.view layoutIfNeeded];
            }];
        }
        
        if (textField == self.text_Password || textField == self.text_PwdAgain)
        {
            [self.view layoutIfNeeded];
            [UIView animateWithDuration:0.3 animations:^{
                self.anchorHeightConstraint.constant += 110;
                self.contentViewTopConstraint.constant = -110;
                [self.view layoutIfNeeded];
            }];
        }
        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


//下一步
- (IBAction)nextStepAction:(id)sender {
    
    if ([QWGlobalManager sharedInstance].currentNetWork == kNotReachable) {
        [self showError:kWaring33];
        return;
    }
    
    
    RegisterModelR *modelR=[RegisterModelR new];
    
    if([self.text_UserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0 ||[self.text_UserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length>20)
    {
        [self showError:kWaring37];
    }else if(!isSpecialstring([self.text_UserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
    {
        [self showError:kWaring38];
    }else if ([self.text_PhoneNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length < 11 || [self.text_PhoneNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 11)
    {
        [self showError:kWaring39];
    }
    else if (!isPhoneNumber([self.text_PhoneNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]))
    {
        [self showError:kWaring40];
    }else if ([self.text_CheckNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
    {
        [self showError:kWaring41];
    }else if ([self.text_Password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
    {
        [self showError:kWaring42];
    }else if(!isSpecialstring(self.text_Password.text))
    {
        [self showError:kWaring42];
    }  else if (self.text_PwdAgain.text.length == 0)
    {
        [self showError:kWaring42];
        
    }else if (self.text_Password.text.length < 6 || self.text_Password.text.length >16)
    {
        [self showError:kWaring42];
        
    }else if (![self.text_PwdAgain.text isEqualToString:self.text_Password.text])
    {
        [self showError:kWaring43];
    }else{

        modelR.account=[self.text_UserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        modelR.mobile = [self.text_PhoneNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        modelR.password = self.text_Password.text;
        modelR.code = [self.text_CheckNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        modelR.type = @"4";
        modelR.groupId =QWGLOBALMANAGER.configure.groupId;
        [QWUserDefault setString:modelR.mobile key:QUICK_REGISTERACCOUNT];

       // 注册请求
        
        self.btn_finish.enabled = NO;
        self.btn_finish.backgroundColor = [UIColor grayColor];
        [Store RegisterWithParams:modelR success:^(id responseobj) {
            StoreModel *modelAll=(StoreModel *)responseobj;
            //序列号通过
            if([modelAll.apiStatus intValue]==0){
                
                
                
            if ([QWUserDefault getBoolBy:QUICK_HASLATITUDE])
            {
                LoginModelR *modeR=[LoginModelR new];
                AppDelegate *appp = (AppDelegate *)[UIApplication sharedApplication].delegate;
                modeR.account=[self.text_UserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                modeR.password = self.text_Password.text;
                modeR.deviceCode = DEVICE_IDD;
                modeR.deviceType = @"2";
                modeR.pushDeviceCode = [QWGLOBALMANAGER deviceToken];
                modeR.credentials=[AESUtil encryptAESData:self.text_Password.text app_key:AES_KEY];
        //成功注册后登录
        [Store loginWithParam:modeR success:^(id obj) {
            
            StoreUserInfoModel *userModel = (StoreUserInfoModel *)obj;
            
            if ([userModel.apiStatus integerValue] == 0) {
                [QWUserDefault setObject:@"1" key:@"ENTRANCETYPE"];
                NSMutableDictionary *setting = [NSMutableDictionary dictionary];
                setting[@"token"] = StrFromObj(userModel.token);
                [Circle InitByBranchWithParams:setting success:^(id obj) {
                    CheckStoreStatuModel *model = [CheckStoreStatuModel parse:obj];
                    if ([model.apiStatus integerValue] == 0) {
                        if (model.type) {
                            QWGLOBALMANAGER.configure.storeType = model.type;
                            QWGLOBALMANAGER.configure.storeCity = model.city;
                            QWGLOBALMANAGER.configure.shortName = model.branchName;
                            [QWGLOBALMANAGER saveAppConfigure];
                        }
                    }else{
                        QWGLOBALMANAGER.configure.storeType = 1;
                        [QWGLOBALMANAGER saveAppConfigure];
                    }
                    [self saveLoginUserInfo:userModel];
                } failure:^(HttpException *e) {
                    QWGLOBALMANAGER.configure.storeType = 1;
                    [QWGLOBALMANAGER saveAppConfigure];
                    [self saveLoginUserInfo:userModel];
                }];
            }else
            {
                [SVProgressHUD showErrorWithStatus:userModel.apiMessage];
            }
            
        } failure:^(HttpException *e) {
            [self showError:kWaring0];
            self.btn_finish.enabled = YES;
            self.btn_finish.backgroundColor = RGBHex(qwColor1);
        }];

        }else{
        // 没有经纬度 跳转到地图界面
        [self changeToMap:modelR];
       }
        //一系列的提示
        }else{
             if([modelAll.apiStatus intValue]==7){
            //  第一次未完成注册 会在updateRegister这个字段中传值,进行下一步操作,完善账号,[resultObj[@"body"][@"updateRegister"]
                 [self changeToMap:modelR];
                 self.btn_finish.enabled = YES;
                 self.btn_finish.backgroundColor = RGBHex(qwColor1);
             }else{
                 [self showError:modelAll.apiMessage];
                 self.btn_finish.enabled = YES;
                 self.btn_finish.backgroundColor = RGBHex(qwColor1);
             }
        }

        }failure:^(HttpException *e) {
                [self showError:kWaring0];
            self.btn_finish.enabled = YES;
            self.btn_finish.backgroundColor = RGBHex(qwColor1);
        }];

        }
    
}
- (void)saveLoginUserInfo:(StoreUserInfoModel *)userModel
{
    NSString * str = userModel.token;
    if (str) {
        QWGLOBALMANAGER.configure.userToken = userModel.token;
        QWGLOBALMANAGER.configure.passportId = userModel.passport;
        QWGLOBALMANAGER.configure.groupId = userModel.branchId;
        QWGLOBALMANAGER.configure.userName = self.text_UserName.text;
        QWGLOBALMANAGER.configure.passWord = self.text_Password.text;
        QWGLOBALMANAGER.configure.type = [NSString stringWithFormat:@"%@",userModel.type];
        QWGLOBALMANAGER.configure.showName = userModel.name;
        QWGLOBALMANAGER.configure.mobile = userModel.mobile;

        /*
         1, 待审核  资料已提交页面
         2, 审核不通过  带入老数据的认证流程
         3, 审核通过    功能正常
         4, 未提交审核  认证流程
         */
        QWGLOBALMANAGER.configure.approveStatus = [NSString stringWithFormat:@"%@",userModel.approveStatus];
        
        if ([QWGLOBALMANAGER.configure.approveStatus integerValue] == 3) {
            // 认证通过后，清除缓存
            [QWUserDefault removeObjectBy:[NSString stringWithFormat:@"uploadLicense+%@",QWGLOBALMANAGER.configure.passportId]];
            [QWUserDefault removeObjectBy:[NSString stringWithFormat:@"OrganInfo+%@",QWGLOBALMANAGER.configure.passportId]];
        }
        
        NSString *nickName = userModel.branchName;
        
        if(nickName && ![nickName isEqual:[NSNull null]]){
            QWGLOBALMANAGER.configure.nickName = nickName;
        }else{
            QWGLOBALMANAGER.configure.nickName = @"";
        }
        NSString *avatarUrl = userModel.branchImgUrl;
        if(avatarUrl && ![avatarUrl isEqual:[NSNull null]]){
            QWGLOBALMANAGER.configure.avatarUrl = avatarUrl;
        }else{
            QWGLOBALMANAGER.configure.avatarUrl = @"";
        }
        QWGLOBALMANAGER.loginStatus = YES;
        [QWGLOBALMANAGER saveAppConfigure];
        //通知登录成功
        [QWGLOBALMANAGER postNotif:NotifLoginSuccess data:userModel object:self];
        [QWGLOBALMANAGER loginSucess];
        
        [QWGLOBALMANAGER saveOperateLog:@"1"];
        [QWGLOBALMANAGER saveOperateLog:@"2"];
        
    }
    if(QWGLOBALMANAGER.tabBar){
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    }else{
        AppDelegate *appDe = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDe initTabBar];
        
    }
}

-(void)changeToMap:(RegisterModelR *)model{

    //没有经纬度 跳转到地图界面
    [QWUserDefault setModel:model key:QUICK_INFO];
    NSMutableDictionary * locationDic = [NSMutableDictionary dictionary];
    BranchGroupModel *company=[QWUserDefault getModelBy:QUICK_COMPANY];
    if (company.name != nil) {
        [locationDic setObject:company.name forKey:@"title"];
    }
    [locationDic setObject:company.provinceName forKey:@"provinceName"];
    [locationDic setObject:company.cityName forKey:@"cityName"];
    [locationDic setObject:company.countryName forKey:@"countryName"];
    [locationDic setObject:company.latitude forKey:@"latitude"];
    [locationDic setObject:company.longitude forKey:@"longitude"];
    MapViewController *mapView = [[MapViewController alloc] init];
    mapView.ComfromQuick = YES;
    mapView.userLocationDic = [locationDic copy];
    [self.navigationController pushViewController:mapView animated:YES];
}

-(void)receiveNumAction:(NSInteger)count
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self ConfigureCodeButtonWith:[NSString stringWithFormat:@"验证码(%d)s",count] color:RGBHex(qwColor9)];
    });
    
    
    if ( count <= 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
             [self ConfigureCodeButtonWith:@"发送验证码" color:RGBHex(qwColor1)];
        });
        self.btn_checkNum.enabled = YES;
    }else{
        self.btn_checkNum.enabled = NO;
    }
}

- (IBAction)getCheckAction:(id)sender {
    
    if ([QWGlobalManager sharedInstance].currentNetWork == kNotReachable) {
        [self showError:kWaring33];
        return;
    }
    
     if ([self.text_PhoneNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 11 ||[self.text_PhoneNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length < 11) {
           [self showError:kWaring39];
         return;
     }
     if (!isPhoneNumber([self.text_PhoneNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]])) {
        [self showError:kWaring40];
         return;
     }
    //add by meng
    [Mbr MobileValidWithMobile:[QWGLOBALMANAGER removeSpace:self.text_PhoneNum.text] success:^(id responseObj) {
        
        if ([responseObj[@"apiStatus"] isEqualToNumber:@0])
        {//手机号未注册,则发送验证码
            [QWGLOBALMANAGER startRgisterVerifyCode:self.text_PhoneNum.text];
            self.btn_checkNum.enabled=NO;
        }else if([responseObj[@"apiStatus"] isEqualToNumber:@1])
        {//此号码已存在,则发送验证码
            [SVProgressHUD showErrorWithStatus:responseObj[@"apiMessage"] duration:DURATION_SHORT];
        }else
        {//手机号不能为空
            [SVProgressHUD showErrorWithStatus:responseObj[@"apiMessage"] duration:DURATION_SHORT];
        }
    } failure:^(HttpException *e) {
    }];
}

- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    if(type == NotiCountDonwRegister) {
        [self receiveNumAction:[data integerValue]];
    }
}
@end
