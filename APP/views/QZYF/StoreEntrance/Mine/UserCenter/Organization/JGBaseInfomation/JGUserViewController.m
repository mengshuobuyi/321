//
//  JGUserViewController.m
//  wenyao-store
//
//  Created by Meng on 14-10-23.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "JGUserViewController.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "ZhPMethod.h"
#import "Store.h"
#import "Mbr.h"
#import "StoreModelR.h"

@interface JGUserViewController ()<UITextFieldDelegate>
{
    NSTimer *_reGetVerifyTimer;
    
    NSString    *userName;
    NSString    *userPhone;
    UIBarButtonItem * rightBarButton;
}

@property (weak, nonatomic) IBOutlet UITextField    *checkField;
@property (weak, nonatomic) IBOutlet UIButton       *checkButton;
@property (weak, nonatomic) IBOutlet UILabel        *checkLabel;
@property (weak, nonatomic) IBOutlet UITextField    *userField;
@property (weak, nonatomic) IBOutlet UITextField    *numberField;

@property (weak, nonatomic) IBOutlet UIView         *nameStatu;
@property (weak, nonatomic) IBOutlet UIView         *phoneStatu;

@property (nonatomic ,strong) NSMutableDictionary   *dataDic;
@property (nonatomic,strong)    NSTimer                 *re ;

//未完善
@property (weak, nonatomic) IBOutlet UILabel        *noName;
@property (weak, nonatomic) IBOutlet UILabel        *noPhone;

@property (nonatomic ,strong) SaveBranchUserModel *saveUserModel;

- (IBAction)checkButtonClick:(id)sender;

@end

@implementation JGUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"软件使用人";
        self.dataDic = [NSMutableDictionary dictionary];
        rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                          style:UIBarButtonItemStyleBordered
                                                         target:self
                                                         action:@selector(rightBarButtonClick)];
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }
    return self;
}

#pragma mark ---- 发送验证码 ui ----

- (void)ConfigureCodeButtonWith:(NSString *)title color:(UIColor *)color
{
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       self.checkLabel.text = title;
                       self.checkLabel.textColor = color;
                       self.checkLabel.layer.borderColor = color.CGColor;
                       self.checkLabel.layer.borderWidth = 0.5;
                       self.checkLabel.layer.cornerRadius = 2.0;
                       [self.checkLabel setNeedsDisplay];
                   });
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    rightBarButton.enabled = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    rightBarButton.enabled = YES;
    
    if (QWGLOBALMANAGER.getChangePhoneCd >0) {
        
        [self ConfigureCodeButtonWith:[NSString stringWithFormat:@"验证码(%ds)",QWGLOBALMANAGER.getChangePhoneCd] color:RGBHex(qwColor9)];
    
    }else{
        
        [self ConfigureCodeButtonWith:@"发送验证码" color:RGBHex(qwColor1)];
    }
    
    [self loadData];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.saveUserModel = [[SaveBranchUserModel alloc] init];
    
}

- (void)loadData
{
    ContactInfoModel *InfoModel = self.userModel.contactInfo;
    SaveItemModel *itemModel = nil;
    //机构名称 name
    itemModel = [[SaveItemModel alloc] init];
    BranchItemModel *nameModel = InfoModel.contact;
    NSInteger nameStatus = [nameModel.status integerValue];
    switch (nameStatus) {
        case 0://0 正常
        {
            self.userField.text = nameModel.oldValue;
            itemModel.oldValue = nameModel.oldValue;
        }
            break;
        case 1://待审
        {
            self.nameStatu.hidden = NO;
            self.userField.userInteractionEnabled = NO;
            self.userField.text = nameModel.newValue;
            itemModel.oldValue = nameModel.newValue;
        }
            break;
        case 2://2未完善
        {
            self.noName.hidden = NO;
        }
            break;
        default:
            break;
    }
    self.saveUserModel.name = itemModel;
    
    
    
    
    BranchItemModel *mobileModel = InfoModel.mobile;
    itemModel = [[SaveItemModel alloc] init];
    NSInteger mobileStatus = [mobileModel.status integerValue];
    switch (mobileStatus) {
        case 0://0 正常
        {
            self.numberField.text = mobileModel.oldValue;
            itemModel.oldValue = mobileModel.oldValue;
        }
            break;
        case 1://待审
        {
            self.phoneStatu.hidden = NO;
            self.numberField.userInteractionEnabled = NO;
            self.numberField.text = mobileModel.newValue;
            itemModel.oldValue = mobileModel.newValue;
        }
            break;
        case 2://2未完善
        {
            self.noPhone.hidden = NO;
        }
            break;
        default:
            break;
    }
    self.saveUserModel.mobile = itemModel;
    
//    if (self.nameStatu.hidden == NO && self.phoneStatu.hidden == NO) {//如果两个都是审核中，就禁掉获取验证码功能
//        [self checkButtonDisable];
//    }
    
    if (self.phoneStatu.hidden == NO) {//如果两个都是审核中，就禁掉获取验证码功能
        [self checkButtonDisable];
    }
}

- (void)checkButtonDisable
{
    self.checkButton.userInteractionEnabled = NO;
    [self ConfigureCodeButtonWith:@"发送验证码" color:RGBHex(qwColor9)];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([QWGLOBALMANAGER judgeTheKeyboardInputModeIsEmojiOrNot:textField]) {
        return NO;
    }else{
        return YES;
    }
}

- (IBAction)checkButtonClick:(id)sender {
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
        return;
    }
    
    if (self.phoneStatu.hidden == NO && self.nameStatu.hidden == NO) {
        [SVProgressHUD showErrorWithStatus:@"信息审核中,无法获取验证码" duration:DURATION_SHORT];
        return;
    }else{
        
        
        //手机号
        if ([[self.numberField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]length] == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入使用人手机" duration:DURATION_SHORT];
            return;
        }else if (![QWGLOBALMANAGER isPhoneNumber:[self.numberField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]){
            [SVProgressHUD showErrorWithStatus:@"使用人手机格式不正确" duration:DURATION_SHORT];
            return;
        }
        
        
        
        SaveItemModel *itemMod = nil;
        
        //名字
        itemMod = self.saveUserModel.name;
        BOOL nameChange = NO; //未改变
        
        if (StrIsEmpty(itemMod.oldValue)) {
            if (StrIsEmpty([QWGLOBALMANAGER removeSpace:self.userField.text])) {
                nameChange = NO;
            }else{
               nameChange = YES;
            }
            
        }else if([itemMod.oldValue isEqualToString:[QWGLOBALMANAGER removeSpace:self.userField.text]]){
            nameChange = NO;
        }else{
            nameChange = YES;
        }
        itemMod.change = nameChange;
        
        //手机号
        itemMod = self.saveUserModel.mobile;
        BOOL mobileChange = NO; //未改变
        
        if (StrIsEmpty(itemMod.oldValue)) {
            mobileChange = YES;
        }else if([itemMod.oldValue isEqualToString:[QWGLOBALMANAGER removeSpace:self.numberField.text]]){
            mobileChange = NO;
        }else{
            mobileChange = YES;
        }
        itemMod.change = mobileChange;
        
        if (!nameChange && !mobileChange){
            [SVProgressHUD showErrorWithStatus:@"您未修改任何信息,无须获取验证码哦!" duration:DURATION_LONG];
            return;
        }
        
        if (mobileChange == YES) {
            //如果改变手机号,发送验证码之前要校验手机号
            [Mbr MobileValidWithMobile:[QWGLOBALMANAGER removeSpace:self.numberField.text] success:^(id responseObj) {
                rightBarButton.enabled = YES;
                if ([responseObj[@"apiStatus"] isEqualToNumber:@0])
                {//手机号未注册
                    
//                    SaveItemModel *mod = self.saveUserModel.mobile;
//                    if (mod.oldValue && ![mod.oldValue isEqualToString:@""]) {
//                        [QWGLOBALMANAGER startChangePhoneVerifyCode:mod.oldValue];
//                    }else{
//                        [QWGLOBALMANAGER startChangePhoneVerifyCode:self.numberField.text];
//                    }
                    
                    [QWGLOBALMANAGER startChangePhoneVerifyCode:self.numberField.text];

                }else if([responseObj[@"apiStatus"] isEqualToNumber:@1])
                {//此号码已存在,则发送验证码
                    [SVProgressHUD showErrorWithStatus:responseObj[@"apiMessage"] duration:DURATION_SHORT];
                }else
                {//手机号不能为空
                    [SVProgressHUD showErrorWithStatus:responseObj[@"apiMessage"] duration:DURATION_SHORT];
                }
            } failure:^(HttpException *e) {
                rightBarButton.enabled = YES;
            }];
        }else{
            [QWGLOBALMANAGER startChangePhoneVerifyCode:self.numberField.text];
        }
    }
}

//计时器执行方法
- (void)reGetVerifyCodeControl:(NSInteger)count
{
    if (count == 0) {
        self.checkButton.userInteractionEnabled = YES;
        
        [self ConfigureCodeButtonWith:@"发送验证码" color:RGBHex(qwColor1)];

    }else{
        self.checkButton.userInteractionEnabled = NO;
        
        [self ConfigureCodeButtonWith:[NSString stringWithFormat:@"验证码(%ds)",count] color:RGBHex(qwColor9)];
    }
}

- (void)rightBarButtonClick{
    [self hiddenKeyboard];
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
        return;
    }
    if (self.phoneStatu.hidden == NO && self.nameStatu.hidden == NO) {
        [SVProgressHUD showErrorWithStatus:@"使用人信息审核中,无法修改" duration:DURATION_SHORT];
        return;
    }
#pragma mark
#pragma mark name  phone两个都变了
    
    SaveItemModel *nameModel = self.saveUserModel.name;
    //名字
    nameModel = self.saveUserModel.name;
    BOOL nameChange = NO; //未改变
    
    if (StrIsEmpty(nameModel.oldValue)) {
        if (StrIsEmpty([QWGLOBALMANAGER removeSpace:self.userField.text])) {
            nameChange = NO;
        }else{
            nameChange = YES;
        }
        
    }else if([nameModel.oldValue isEqualToString:[QWGLOBALMANAGER removeSpace:self.userField.text]]){
        nameChange = NO;
    }else{
        nameChange = YES;
    }
    nameModel.change = nameChange;
    
    //手机号
    SaveItemModel *mobileModel = self.saveUserModel.mobile;
    BOOL mobileChange = NO; //未改变
    
    if (StrIsEmpty(mobileModel.oldValue)) {
        mobileChange = YES;
    }else if([mobileModel.oldValue isEqualToString:[QWGLOBALMANAGER removeSpace:self.numberField.text]]){
        mobileChange = NO;
    }else{
        mobileChange = YES;
    }
    mobileModel.change = mobileChange;
    
    if (!nameChange && !mobileChange){
        [SVProgressHUD showErrorWithStatus:kWaring49 duration:DURATION_LONG];
        return;
    }

    
    
    if (nameModel.change == YES && mobileModel.change == YES) { //两个都变了
        //用户名
        if ([[self.userField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]length ]> 10) {
            [SVProgressHUD showErrorWithStatus:@"请输入使用人，10个字以内" duration:DURATION_SHORT];
            return;
        }else if ([[QWGLOBALMANAGER removeSpace:self.userField.text] length] == 0){
            [SVProgressHUD showErrorWithStatus:@"请输入使用人" duration:DURATION_SHORT];
            return;
        }
        //手机号
        if ([[QWGLOBALMANAGER removeSpace:self.numberField.text] length] == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入使用人手机" duration:DURATION_SHORT];
            return;
        }else if (![QWGLOBALMANAGER isPhoneNumber:[QWGLOBALMANAGER removeSpace:self.numberField.text]]){
            [SVProgressHUD showErrorWithStatus:@"使用人手机格式不正确" duration:DURATION_SHORT];
            return;
        }
        if ([[self.checkField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]length] == 0) {
            [SVProgressHUD showErrorWithStatus:kWaring41 duration:DURATION_SHORT];
            return;
        }
        //校验验证码
        rightBarButton.enabled = NO;
        
        ValidVerifyCodeModelR *validModelR = [[ValidVerifyCodeModelR alloc] init];
        validModelR.mobile = self.numberField.text;
//        validModelR.mobile = mobileModel.oldValue;
        validModelR.code = self.checkField.text;
        validModelR.type = @6;
        //校验验证码
        [Mbr ValidVerifyCodeWithParam:validModelR success:^(id responseObj) {
            //校验手机号是否被注册
            NSLog(@"验证码校验成功!");
            StoreModel *model=responseObj;
            
            if([model.apiStatus intValue]==0){
                [Mbr MobileValidWithMobile:[QWGLOBALMANAGER removeSpace:self.numberField.text] success:^(id responseObj) {
                    rightBarButton.enabled = YES;
                    if ([responseObj[@"apiStatus"] isEqualToNumber:@0]) {//手机号未注册
                        //联系人
                        NSString *comlun = [NSString stringWithFormat:@"%@%@%@",@"account.contact",SeparateStr,@"account.mobile"];
                        NSString *oldValue = [NSString stringWithFormat:@"%@%@%@",StrFromObj(nameModel.oldValue),SeparateStr,StrFromObj(mobileModel.oldValue)];
                        NSString *newValue = [NSString stringWithFormat:@"%@%@%@",[QWGLOBALMANAGER removeSpace:self.userField.text],SeparateStr,[QWGLOBALMANAGER removeSpace:self.numberField.text]];
                        
                        [self commitInfoWithComlun:comlun oldValue:oldValue newValue:newValue];
                    }else{
                        [SVProgressHUD showErrorWithStatus:responseObj[@"apiMessage"] duration:DURATION_SHORT];
                        return ;
                    }
                    
                } failure:^(HttpException *e) {
                    rightBarButton.enabled = YES;
                    NSLog(@"%@ -> %@",NSStringFromClass([self class]),e);
                }];
            }else{
                rightBarButton.enabled = YES;
                [SVProgressHUD showErrorWithStatus:model.apiMessage duration:DURATION_SHORT];
            }
        } failure:^(HttpException *e) {
            rightBarButton.enabled = YES;
            NSLog(@"%@ -> %@",NSStringFromClass([self class]),e);
        }];
        
        
#pragma mark
#pragma mark name 只有名字变了
    }else if (nameModel.change == YES) { //只有名字变了
        
        
        if ([[self.userField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]length ]> 9) {
            [SVProgressHUD showErrorWithStatus:@"请输入使用人，10个字以内" duration:DURATION_SHORT];
            return;
        }else if ([[self.userField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]length] == 0){
            [SVProgressHUD showErrorWithStatus:@"请输入使用人" duration:DURATION_SHORT];
            return;
        }
        
        
        
        if ([[self.checkField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]length] == 0) {
            [SVProgressHUD showErrorWithStatus:kWaring41 duration:DURATION_SHORT];
            return;
        }
        //校验验证码
        ValidVerifyCodeModelR *validModelR = [[ValidVerifyCodeModelR alloc] init];
        validModelR.mobile = self.numberField.text;
        validModelR.code = self.checkField.text;
        validModelR.type = @6;
        [Mbr ValidVerifyCodeWithParam:validModelR success:^(id responseObj) {
            
            StoreModel *model=responseObj;
            
            if([model.apiStatus intValue]==0){
            
            rightBarButton.enabled = YES;
                NSString *comlun = [NSString stringWithFormat:@"%@",@"account.contact"];
                NSString *oldValue = [NSString stringWithFormat:@"%@",StrFromObj(nameModel.oldValue)];
                NSString *newValue = [NSString stringWithFormat:@"%@",[QWGLOBALMANAGER removeSpace:self.userField.text]];
                [self commitInfoWithComlun:comlun oldValue:oldValue newValue:newValue];
            }else{
                rightBarButton.enabled = YES;
                [SVProgressHUD showErrorWithStatus:model.apiMessage duration:DURATION_SHORT];
            
            }
        } failure:^(HttpException *e) {
            rightBarButton.enabled = YES;
            NSLog(@"%@ -> %@",NSStringFromClass([self class]),e);
        }];
#pragma mark
#pragma mark phone 只有手机号变了
    }else if (mobileModel.change == YES){ //只有手机号变了
        
        if ([[self.numberField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]length] == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入使用人手机" duration:DURATION_SHORT];
            return;
        }else if (![QWGLOBALMANAGER isPhoneNumber:[self.numberField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]){
            [SVProgressHUD showErrorWithStatus:@"使用人手机格式不正确" duration:DURATION_SHORT];
            return;
        }
        
        if ([[self.checkField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]length] == 0) {
            [SVProgressHUD showErrorWithStatus:kWaring41 duration:DURATION_SHORT];
            return;
        }
        //先校验验证码
        ValidVerifyCodeModelR *validModelR = [[ValidVerifyCodeModelR alloc] init];
        validModelR.mobile = self.numberField.text;
//        validModelR.mobile = mobileModel.oldValue;
        validModelR.code = self.checkField.text;
        validModelR.type = @6;
        [Mbr ValidVerifyCodeWithParam:validModelR success:^(id responseObj) {
            StoreModel *model=responseObj;
            if([model.apiStatus intValue]==0){
            [Mbr MobileValidWithMobile:[QWGLOBALMANAGER removeSpace:self.numberField.text] success:^(id responseObj) {
                
                if ([responseObj[@"apiStatus"] isEqualToNumber:@0]) {//手机号未注册
                    NSString *comlun = [NSString stringWithFormat:@"%@",@"account.mobile"];
                    NSString *oldValue = [NSString stringWithFormat:@"%@",StrFromObj(mobileModel.oldValue)];
                    NSString *newValue = [NSString stringWithFormat:@"%@",[QWGLOBALMANAGER removeSpace:self.numberField.text]];
                    [self commitInfoWithComlun:comlun oldValue:oldValue newValue:newValue];
                }else{
                    [SVProgressHUD showErrorWithStatus:responseObj[@"apiMessage"] duration:DURATION_SHORT];
                }
                
                
            } failure:^(HttpException *e) {
                rightBarButton.enabled = YES;
                NSLog(@"%@ -> %@",NSStringFromClass([self class]),e);
            }];
            }else{
                rightBarButton.enabled = YES;
                [SVProgressHUD showErrorWithStatus:model.apiMessage duration:DURATION_SHORT];
            }
        } failure:^(HttpException *e) {
            rightBarButton.enabled = YES;
            NSLog(@"%@ -> %@",NSStringFromClass([self class]),e);
        }];
        
       
        
        
    }else{
        if([self.numberField.text isEqualToString:@""]){
            [SVProgressHUD showErrorWithStatus:@"请输入使用人手机" duration:DURATION_SHORT];
            return;
        }
        if([self.userField.text isEqualToString:@""]){
            [SVProgressHUD showErrorWithStatus:@"请输入使用人" duration:DURATION_SHORT];
            return;
        }
        if([self.numberField.text isEqualToString:@""]||[self.userField.text isEqualToString:@""]){
            [SVProgressHUD showErrorWithStatus:@"请输入使用人和手机号" duration:DURATION_SHORT];
            return;
        }
        
        [SVProgressHUD showErrorWithStatus:kWaring49 duration:DURATION_SHORT];
        return;
        
    }
}

- (void)commitInfoWithComlun:(NSString *)comlun oldValue:(NSString *)oldValue newValue:(NSString *)newValue{
    NSMutableDictionary * setting = [NSMutableDictionary dictionary];
    
    setting[@"branchId"] = QWGLOBALMANAGER.configure.groupId;
    setting[@"column"] = comlun;
    setting[@"oldValue"] = oldValue;
    setting[@"newValue"] = newValue;
    rightBarButton.enabled = NO;
    [Store UpdateBranchWithParams:setting success:^(id responseObj) {
        rightBarButton.enabled = YES;
        [SVProgressHUD showSuccessWithStatus:kWaring50 duration:DURATION_LONG];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(HttpException *e) {
        rightBarButton.enabled = YES;
        NSLog(@"%@ -> %@",NSStringFromClass([self class]),e);
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self hiddenKeyboard];
}

- (void)hiddenKeyboard
{
    [self.numberField resignFirstResponder];
    [self.userField resignFirstResponder];
    [self.checkField resignFirstResponder];
}

- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    if (type == NotiCountDonwChangePhone) {
        [self reGetVerifyCodeControl:[data integerValue]];
    }
}

@end
