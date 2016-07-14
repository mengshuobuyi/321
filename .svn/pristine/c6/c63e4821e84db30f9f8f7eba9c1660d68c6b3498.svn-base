//
//  ExpertRegisterNextViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/4/21.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ExpertRegisterNextViewController.h"
#import "QWInputTextField.h"
#import "ExpertRegisterFinallyViewController.h"
#import "Mbr.h"
#import "ExpertModel.h"
#import "ExpertAuthViewController.h"
#import "AppDelegate.h"
#import "ExpertAuthCommitViewController.h"

@interface ExpertRegisterNextViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top_layout_top;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet QWInputTextField *textField;

@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;

//回复框是否显示placeHolder
@property (assign, nonatomic) BOOL showPlaceholder;

@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *getCodeButton;
@property (strong, nonatomic) UILabel *getCodeLabel;

@end

@implementation ExpertRegisterNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.jumpType == 1) {
        //门店普通注册
        self.title = @"注册";
        self.topView.hidden = NO;
        self.top_layout_top.constant = 61;
    }else if (self.jumpType == 2)
    {
        //专家注册
        self.title = @"注册";
        self.topView.hidden = NO;
        self.top_layout_top.constant = 61;
    }else if (self.jumpType == 3)
    {
        //专家无密码登录
        self.title = @"登录";
        self.topView.hidden = YES;
        self.top_layout_top.constant = 32;
    }
    
    
    self.textField.inputCount = 4;
    
    if (!StrIsEmpty(self.phoneNumber) && self.phoneNumber.length == 11) {
        NSString *str = [NSString stringWithFormat:@"%@ %@ %@",[self.phoneNumber substringWithRange:NSMakeRange(0, 3)],[self.phoneNumber substringWithRange:NSMakeRange(3, 4)],[self.phoneNumber substringWithRange:NSMakeRange(7, 4)]];
        self.phoneLabel.text = str;
    }
    
    // 点击空白 键盘down
    [self setUpForDismissKeyboard];
    
    self.textField.delegate = self;
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.topView.backgroundColor = [UIColor whiteColor];
    
    NSString *str = @"1.填写手机号   >   2.短信验证   >   3.设置密码";
    NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange range1 = [[AttributedStr1 string]rangeOfString:@"1.填写手机号   >   2.短信验证"];
    [AttributedStr1 addAttribute:NSForegroundColorAttributeName
                           value:RGBHex(qwColor1)
                           range:range1];
    self.topLabel.attributedText = AttributedStr1;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItems = nil;
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setHidesBackButton:YES];
    
    [self.textField clearText];
    [self setTextViewPlaceholder:YES];
    
    [self setLeftItem];
    
    if (self.jumpType == 1)
    {
        if (QWGLOBALMANAGER.getCommonRegisterCd > 0) {
            [self ConfigureCodeButtonWith:[NSString stringWithFormat:@"%ds 后重新获取",QWGLOBALMANAGER.getCommonRegisterCd] color:RGBHex(qwColor9)];
        }else{
            [self ConfigureCodeButtonWith:@"重新获取" color:RGBHex(qwColor1)];
        }
    }else if (self.jumpType == 2)
    {
        if (QWGLOBALMANAGER.getExpertRegisterCd > 0) {
            [self ConfigureCodeButtonWith:[NSString stringWithFormat:@"%ds 后重新获取",QWGLOBALMANAGER.getExpertRegisterCd] color:RGBHex(qwColor9)];
        }else{
            [self ConfigureCodeButtonWith:@"重新获取" color:RGBHex(qwColor1)];
        }
    }else if (self.jumpType == 3)
    {
        if (QWGLOBALMANAGER.getExpertLoginCd > 0) {
            [self ConfigureCodeButtonWith:[NSString stringWithFormat:@"%ds 后重新获取",QWGLOBALMANAGER.getExpertLoginCd] color:RGBHex(qwColor9)];
        }else{
            [self ConfigureCodeButtonWith:@"重新获取" color:RGBHex(qwColor1)];
        }
    }
    
}

#pragma mark ---- 设置左侧按钮 ----
- (void)setLeftItem
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 44)];
    bgView.backgroundColor = [UIColor clearColor];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(0, 0, 30, 44);
    [self.backButton setImage:[UIImage imageNamed:@"nav_btn_back"] forState:UIControlStateNormal];
    [self.backButton setImage:[UIImage imageNamed:@"nav_btn_back_sel"] forState:UIControlStateHighlighted];
    [self.backButton setImage:[UIImage imageNamed:@"nav_btn_back_sel"] forState:UIControlStateSelected];
    [self.backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    [self.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.backButton.backgroundColor=[UIColor clearColor];
    [bgView addSubview:self.backButton];
    
    
    self.getCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 100, 44)];
    self.getCodeLabel.textColor = [UIColor whiteColor];
    self.getCodeLabel.font = [UIFont systemFontOfSize:13];
    self.getCodeLabel.backgroundColor = [UIColor clearColor];
    [bgView addSubview:self.getCodeLabel];
    
    self.getCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.getCodeButton.frame = CGRectMake(30, 0, 100, 44);
    [self.getCodeButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.getCodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.getCodeButton.backgroundColor=[UIColor clearColor];
    [bgView addSubview:self.getCodeButton];
    
    
    
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = -13;
    UIBarButtonItem* btnItem = [[UIBarButtonItem alloc] initWithCustomView:bgView];
    self.navigationItem.leftBarButtonItems = @[fixed,btnItem];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---- 点击空白 收起键盘 ----

- (void)setUpForDismissKeyboard
{
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    [self.view addGestureRecognizer:singleTapGR];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognize{
    //此method会将self.view里所有的subview的first responder都resign掉
    [UIView animateWithDuration:1 animations:^{
        
    } completion:^(BOOL finished) {
    }];
    [self.view endEditing:YES];
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
    maxNum = 4;
    
    if (toBeString.length > maxNum) {
        textView.text = [toBeString substringToIndex:maxNum];
    }
    
    [self setRemainWord:textView.text.length];
    
    if (textView.text.length == 4) {
        
        if (self.jumpType == 1 || self.jumpType == 2)
        {
            //注册
            [self verifyRegisterCodeAction];
        }else if (self.jumpType == 3)
        {
            //无密码登录
            [self expertNoPwdLogin];
        }
    }
}

// 设置剩余输入字数
- (void)setRemainWord:(NSInteger)wordInputted
{
    if (self.textField.text.length == 0)
    {
        [self setTextViewPlaceholder:YES];
    } else
    {
        [self setTextViewPlaceholder:NO];
    }
}

// 设置文本框的Placeholder
- (void)setTextViewPlaceholder:(BOOL)didSet
{
    if (didSet&&self.textField.text.length == 0)
    {
        self.placeHolderLabel.text = @"请输入收到的验证码";
        self.placeHolderLabel.hidden = NO;
        self.showPlaceholder = YES;
    } else
    {
        self.placeHolderLabel.hidden = YES;
        self.showPlaceholder = NO;
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0)
    {
        //显示提示
        [self setTextViewPlaceholder:YES];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (self.showPlaceholder&&self.textField.text.length>0)
    {
        //光标键入，消失提示
        [self setTextViewPlaceholder:NO];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (self.textField.text.length == 0)
    {
        //内容变化进行的操作
        [self setTextViewPlaceholder:YES];
    }else
    {
        [self setTextViewPlaceholder:NO];
    }
}

- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    if (self.jumpType == 1)
    {
        //门店普通注册
        if(type == NotiCountDownCommonRegister) {
            [self reGetVerifyCodeControl:[data integerValue]];
        }
    }else if (self.jumpType == 2)
    {
        //专家注册
        if(type == NotiCountDownExpertRegister) {
            [self reGetVerifyCodeControl:[data integerValue]];
        }
    }else if (self.jumpType == 3)
    {
        //专家登录
        if(type == NotiCountDownExpertLogin) {
            [self reGetVerifyCodeControl:[data integerValue]];
        }
    }
}

//计时器执行方法
- (void)reGetVerifyCodeControl:(NSInteger)count
{
    if (count == 0) {
        self.getCodeButton.enabled = YES;
        [self ConfigureCodeButtonWith:@"重新获取" color:RGBHex(qwColor1)];
    }else{
        self.getCodeButton.enabled = NO;
        [self ConfigureCodeButtonWith:[NSString stringWithFormat:@"%lds 后重新获取",(long)count] color:RGBHex(qwColor9)];
    }
}

#pragma mark ---- 发送验证码 ui ----
- (void)ConfigureCodeButtonWith:(NSString *)title color:(UIColor *)color
{
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       self.getCodeLabel.text = title;
                       self.getCodeLabel.layer.cornerRadius = 3.0;
                       self.getCodeLabel.layer.masksToBounds = YES;
                       [self.getCodeLabel setNeedsDisplay];
                   });
}


#pragma mark ---- 注册校验验证码 ----
- (void)verifyRegisterCodeAction
{
    [self.view endEditing:YES];
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:0.8f];
        return;
    }
    
    if (self.textField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码" duration:DURATION_SHORT];
        return;
    }
    
    
    //调校验验证码的接口
    /*
    1.用户端 - 注册
    2.用户端 - 重置密码
    3.用户端 - 更换手机号
    4.药店端 - 注册
    5.药店端 - 重置密码
    6.药店端 - 更换手机号
    7.修改支付宝账号
    9.用户端-验证码快捷登录
    10.专家登录
    13.专家注册
    14.专家重置密码
     */
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    
    if (self.jumpType == 1) {
        setting[@"type"] = @"4";
    }else if (self.jumpType == 2){
        setting[@"type"] = @"13";
    }
    setting[@"mobile"] = StrFromObj(self.phoneNumber);
    setting[@"code"] = StrFromObj(self.textField.text);
    [Mbr MbrCodeValidVerifyCodeOnly4checkWithParams:setting success:^(id DFUserModel)
    {
       
        BaseAPIModel *model = [BaseAPIModel parse:DFUserModel];
        if ([model.apiStatus integerValue] == 0) {
            ExpertRegisterFinallyViewController *vc = [[UIStoryboard storyboardWithName:@"ExpertLogin" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertRegisterFinallyViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            vc.phoneNumber = self.phoneNumber;
            vc.codeNumber = self.textField.text;
            vc.jumpType = self.jumpType;
            [self.navigationController pushViewController:vc animated:YES];
            [self.textField clearText];
            [self setTextViewPlaceholder:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:model.apiMessage];
            [self.textField clearText];
            [self setTextViewPlaceholder:YES];
        }
        
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ---- 无密码登录 ----
- (void)expertNoPwdLogin
{
    [self.view endEditing:YES];
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:0.8f];
        return;
    }
    
    if (self.textField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码" duration:DURATION_SHORT];
        return;
    }
    
    // 调登录接口
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"mobile"] = StrFromObj(self.phoneNumber);
    setting[@"validCode"] = StrFromObj(self.textField.text);
    setting[@"pushDeviceCode"] = StrFromObj(QWGLOBALMANAGER.deviceToken);
    setting[@"deviceCode"] = DEVICE_IDD;
    setting[@"device"] = @2;
    [QWGLOBALMANAGER readLocationInformation:^(MapInfoModel *mapInfoModel) {
        if(mapInfoModel) {
            setting[@"city"] = StrFromObj(mapInfoModel.city);
        }else{
            setting[@"city"] = @"苏州市";
        }
    }];
    
    [Mbr MbrUserExpertLoginWithParam:setting success:^(id obj) {
        
        [self.textField clearText];
        [self setTextViewPlaceholder:YES];
        ExpertLoginInfoModel *infoModel = [ExpertLoginInfoModel parse:obj];
        if ([infoModel.apiStatus integerValue] == 0)
        {
            
            [QWUserDefault setObject:@"2" key:@"ENTRANCETYPE"];
            [self loginSuccessWithModel:infoModel];
        }else
        {
            [SVProgressHUD showErrorWithStatus:infoModel.apiMessage];
        }
    } failure:^(HttpException *e) {
    }];
}

#pragma mark ---- 登陆之后的操作 ----
- (void)loginSuccessWithModel:(ExpertLoginInfoModel *)infoModel
{
    //存储登陆返回的基本信息
    QWGLOBALMANAGER.configure.expertToken = infoModel.token;
    QWGLOBALMANAGER.configure.expertPassportId = infoModel.passportId;
    QWGLOBALMANAGER.configure.silencedFlag = infoModel.silencedFlag;
    QWGLOBALMANAGER.configure.expertIsSetPwd = infoModel.isSetPwd;
    
    NSString *nickName = infoModel.nickName;
    if(nickName && ![nickName isEqual:[NSNull null]]){
        QWGLOBALMANAGER.configure.expertNickName = nickName;
    }else{
        QWGLOBALMANAGER.configure.expertNickName = @"";
    }
    NSString *avatarUrl = infoModel.avatarUrl;
    if(avatarUrl && ![avatarUrl isEqual:[NSNull null]]){
        QWGLOBALMANAGER.configure.expertAvatarUrl = avatarUrl;
    }else{
        QWGLOBALMANAGER.configure.expertAvatarUrl = @"";
    }
    
    QWGLOBALMANAGER.configure.expertMobile = infoModel.mobile;
    QWGLOBALMANAGER.configure.expertAuthStatus = infoModel.authStatus;
    
    QWGLOBALMANAGER.loginStatus = YES;
    [QWGLOBALMANAGER saveAppConfigure];
    [QWUserDefault setBool:YES key:APP_LOGIN_STATUS];
    
    [QWGLOBALMANAGER saveOperateLog:@"2"];
    //通知登录成功
    [QWGLOBALMANAGER postNotif:NotifLoginSuccess data:nil object:self];
    [QWGLOBALMANAGER expertLoginSuccess];
    
    // 判断是否认证通过
    QWGLOBALMANAGER.configure.expertAuthStatus = infoModel.authStatus;
    
    //（5:未申请 1:已申请待认证, 2:已认证, 3:认证不通过, 4:认证中）
    if (infoModel.authStatus == 5) //未申请
    {
        ExpertAuthViewController *vc = [[UIStoryboard storyboardWithName:@"ExpertAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertAuthViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (infoModel.authStatus == 2 || infoModel.authStatus == 4) //已认证
    {
        [QWUserDefault setBool:YES key:APP_LOGIN_STATUS];
        if(QWGLOBALMANAGER.tabBar){
            [self dismissViewControllerAnimated:NO completion:nil];
        }else{
            AppDelegate *apppp = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [apppp initTabBar];
        }
        
    }else if (infoModel.authStatus == 3) //认证不通过
    {
        ExpertAuthViewController *vc = [[UIStoryboard storyboardWithName:@"ExpertAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertAuthViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (infoModel.authStatus == 1) //已申请待认证
    {
        ExpertAuthCommitViewController *vc = [[UIStoryboard storyboardWithName:@"ExpertAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertAuthCommitViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
