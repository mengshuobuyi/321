//
//  ExpertRegisterViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/4/18.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ExpertRegisterViewController.h"
#import "Mbr.h"
#import "ExpertRegisterNextViewController.h"
#import "ServiceSpecificationViewController.h"
#import "Store.h"
#import "ExpertModel.h"
#import "WebDirectViewController.h"

#define ServiceSpeciticationnnUrl         API_APPEND_V2(@"api/helpClass/sjzcxy")
#define nnnnnn        [NSString stringWithFormat:@"%@QWAPP/v311/QWSH/web/ruleDesc/html/expertRegist.html",H5_DOMAIN_URL]


@interface ExpertRegisterViewController ()

@property (weak, nonatomic) IBOutlet UIView *topBgView;

@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@property (weak, nonatomic) IBOutlet UIView *phoneBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneBgView_layout_top;

@property (weak, nonatomic) IBOutlet UIView *codeBgView;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;

@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UIView *protocolBgView;
@property (weak, nonatomic) IBOutlet UILabel *protocolLabel;
@property (weak, nonatomic) IBOutlet UILabel *expertLoginTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeRegisterTipLabel;

- (IBAction)checkProtocolAction:(id)sender;

- (IBAction)getCodeAction:(id)sender;

- (IBAction)nextAction:(id)sender;

@end

@implementation ExpertRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.jumpType == 1)
    {
        self.title = @"注册";
        self.phoneBgView_layout_top.constant = 60;
        self.topBgView.hidden = NO;
        self.protocolBgView.hidden = NO;
        self.protocolLabel.text = @"《问药商家注册协议》";
        self.expertLoginTipLabel.hidden = YES;
        self.storeRegisterTipLabel.hidden = NO;
        NSString *desc = @"温馨提示：若您已签订线下协议，请使用手机号码直接登录";
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 2;
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        NSDictionary *attributes = @{NSFontAttributeName:fontSystem(12),NSParagraphStyleAttributeName:paragraphStyle};
        self.storeRegisterTipLabel.attributedText = [[NSAttributedString alloc] initWithString:desc attributes:attributes];
    }else if (self.jumpType == 2)
    {
        self.title = @"注册";
        self.phoneBgView_layout_top.constant = 60;
        self.topBgView.hidden = NO;
        self.protocolBgView.hidden = NO;
        self.protocolLabel.text = @"《问药专家注册协议》";
        self.expertLoginTipLabel.hidden = YES;
        self.storeRegisterTipLabel.hidden = YES;
    }else if (self.jumpType == 3)
    {
        self.title = @"无密码登录";
        self.phoneBgView_layout_top.constant = 15;
        self.topBgView.hidden = YES;
        self.protocolBgView.hidden = YES;
        self.expertLoginTipLabel.hidden = NO;
        self.storeRegisterTipLabel.hidden = YES;
    }
    
    // 设置UI
    [self configureUI];
    
    // 点击空白 键盘down
    [self setUpForDismissKeyboard];
}

- (void)configureUI
{
    self.getCodeButton.enabled = YES;
    
    self.topBgView.backgroundColor = [UIColor whiteColor];
    self.phoneBgView.backgroundColor = [UIColor whiteColor];
    self.codeBgView.backgroundColor = [UIColor whiteColor];
    
    NSString *str = @"1.填写手机号   >   2.短信验证   >   3.设置密码";
    NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange range1 = [[AttributedStr1 string]rangeOfString:@"1.填写手机号"];
    [AttributedStr1 addAttribute:NSForegroundColorAttributeName
                           value:RGBHex(qwColor1)
                           range:range1];
    self.topLabel.attributedText = AttributedStr1;
    
    
    self.phoneBgView.layer.cornerRadius = 4.0;
    self.phoneBgView.layer.masksToBounds = YES;
    self.phoneBgView.layer.borderColor = RGBHex(qwColor10).CGColor;
    self.phoneBgView.layer.borderWidth = 1.0;
    
    self.codeBgView.layer.cornerRadius = 4.0;
    self.codeBgView.layer.masksToBounds = YES;
    self.codeBgView.layer.borderColor = RGBHex(qwColor10).CGColor;
    self.codeBgView.layer.borderWidth = 1.0;
    
    self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    self.codeTextField.keyboardType = UIKeyboardTypeDefault;
    self.phoneTextField.delegate = self;
    self.codeTextField.delegate = self;
    self.phoneTextField.tag = 1;
    self.codeTextField.tag = 2;
    
    [self.phoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.codeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.phoneTextField setValue:RGBHex(0xaaaaaa) forKeyPath:@"_placeholderLabel.textColor"];
    [self.codeTextField setValue:RGBHex(0xaaaaaa) forKeyPath:@"_placeholderLabel.textColor"];
    
    self.nextButton.layer.cornerRadius = 4.0;
    self.nextButton.layer.masksToBounds = YES;
    
    self.codeTextField.secureTextEntry = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.codeImageView.image = [UIImage imageNamed:@"img_validation"];
    
    if ([QWGLOBALMANAGER isTelPhoneNumber:self.phoneTextField.text]) {
        NSURL* imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/h5/mbr/imageCode?mobile=%@&id=%f", DE_H5_DOMAIN_URL, self.phoneTextField.text, [[NSDate new] timeIntervalSince1970]]];
        
        [self.codeImageView setImageWithURL:imageURL];
    }
    
    if (self.phoneTextField.text.length == 0) {
        self.codeTextField.enabled = NO;
    }
    
    // 按钮置灰
    [self configureNextButtonGray];
    self.codeTextField.text = @"";
}

- (void)viewDidCurrentView
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.codeImageView.image = [UIImage imageNamed:@"img_validation"];
    
    if ([QWGLOBALMANAGER isTelPhoneNumber:self.phoneTextField.text]) {
        NSURL* imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/h5/mbr/imageCode?mobile=%@&id=%f", DE_H5_DOMAIN_URL, self.phoneTextField.text, [[NSDate new] timeIntervalSince1970]]];
        
        [self.codeImageView setImageWithURL:imageURL];
    }
    
    if (self.phoneTextField.text.length == 0) {
        self.codeTextField.enabled = NO;
    }
    
    // 按钮置灰
    [self configureNextButtonGray];
    self.codeTextField.text = @"";
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

#pragma mark ---- 下一步按钮置灰 ----

- (void)configureNextButtonGray
{
    self.nextButton.enabled = NO;
    [self.nextButton setBackgroundColor:RGBHex(qwColor9)];
    [self.nextButton setBackgroundImage:nil forState:UIControlStateNormal];
}

#pragma mark ---- 下一步按钮高亮 ----

- (void)ConfigureNextButtonBlue
{
    self.nextButton.enabled = YES;
    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"btn_login_notmal"] forState:UIControlStateNormal];
    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"btn_login_click"] forState:UIControlStateHighlighted];
    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"btn_login_click"] forState:UIControlStateSelected];
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
    
    //手机号11位 才可以输入
    
    if (textView.tag == 1)
    {
        if ([QWGLOBALMANAGER isTelPhoneNumber:self.phoneTextField.text] && textView.text.length == 11) {
            self.codeTextField.enabled = YES;
            NSURL* imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/h5/mbr/imageCode?mobile=%@&id=%f", DE_H5_DOMAIN_URL, self.phoneTextField.text, [[NSDate new] timeIntervalSince1970]]];
            
            [self.codeImageView setImageWithURL:imageURL];
        }else if (textView.text.length < 11)
        {
            self.codeTextField.enabled = NO;
            self.codeTextField.text = @"";
            self.codeImageView.image = [UIImage imageNamed:@"img_validation"];
        }
    }
    
    int maxNum;
    if (textView.tag == 1) { //手机号
        maxNum = 11;
    }else if (textView.tag == 2){ //验证码
        maxNum = 6;
    }
    
    if (toBeString.length > maxNum) {
        textView.text = [toBeString substringToIndex:maxNum];
    }
    
    if ([QWGLOBALMANAGER isTelPhoneNumber:self.phoneTextField.text] && self.codeTextField.text.length > 0) {
        [self ConfigureNextButtonBlue];
    }else
    {
        [self configureNextButtonGray];
    }
}


#pragma mark ---- 查看注册协议 ----
- (IBAction)checkProtocolAction:(id)sender
{
    if (self.jumpType == 1)
    {
        ServiceSpecificationViewController *serviceV = [[ServiceSpecificationViewController alloc]initWithNibName:@"ServiceSpecificationViewController" bundle:nil];
        serviceV.TitleStr = @"注册协议";
        serviceV.UrlStr = ServiceSpeciticationnnUrl;
        [self.navigationController pushViewController:serviceV animated:YES];
        
    }else if (self.jumpType == 2)
    {
        //  优惠细则
        WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
        WebCouponConditionModel *modelCondition = [[WebCouponConditionModel alloc] init];
        modelCondition.type = @"1";
        WebDirectLocalModel *modelLocal = [[WebDirectLocalModel alloc] init];
        modelLocal.modelCondition = modelCondition;
        modelLocal.typeLocalWeb = WebLocalTypeExpertRegisterProtocol;
        [vcWebDirect setWVWithLocalModel:modelLocal];
        vcWebDirect.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vcWebDirect animated:YES];
    }
}

#pragma mark ---- 刷新验证码 ----
- (IBAction)getCodeAction:(id)sender
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:0.8f];
        return;
    }
    
    if (self.phoneTextField.text.length < 11) {
        return;
    }
    
    if (![QWGLOBALMANAGER isTelPhoneNumber:self.phoneTextField.text]) {
        [SVProgressHUD showErrorWithStatus:Kwarning220N70 duration:0.8];
        return;
    }
    
    NSURL* imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/h5/mbr/imageCode?mobile=%@&id=%f", DE_H5_DOMAIN_URL, self.phoneTextField.text, [[NSDate new] timeIntervalSince1970]]];
    
    [self.codeImageView setImageWithURL:imageURL];
    
    self.codeTextField.text = @"";
}

- (IBAction)nextAction:(id)sender
{
    self.nextButton.enabled = NO;
    [self.view endEditing:YES];
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:0.8f];
        self.nextButton.enabled = YES;
        return;
    }
    
    if (self.codeTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码" duration:DURATION_SHORT];
        self.nextButton.enabled = YES;
        return;
    }
    
    
    if (self.jumpType == 1)
    {
        //门店注册
        //检测用户手机是否注册
        MobileValidModelR *model = [MobileValidModelR new];
        model.mobile = self.phoneTextField.text;
        [Store MobileValidWithParams:model success:^(id obj) {
            BaseAPIModel *model = [BaseAPIModel parse:obj];
            if ([model.apiStatus integerValue] == 0) {
                [self loginOrRegisteNext];
            }else{
                [SVProgressHUD showErrorWithStatus:model.apiMessage];
                self.nextButton.enabled = YES;
            }
        } failure:^(HttpException *e) {
            self.nextButton.enabled = YES;
        }];
        
    }else if (self.jumpType == 2)
    {
        //专家注册
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"mobile"] = StrFromObj(self.phoneTextField.text);
        [Mbr MbrExpertRegisterValidWithParams:setting success:^(id DFUserModel) {
            
            ExpertIsExistsModel *model = [ExpertIsExistsModel parse:DFUserModel];
            if ([model.apiStatus integerValue] == 0)
            {
                if (model.isExists)
                {
                    //已经注册过手机号
                    [SVProgressHUD showErrorWithStatus:@"该手机号码已经注册，请直接登录"];
                    self.nextButton.enabled = YES;
                }else
                {
                    [self loginOrRegisteNext];
                }
            }
            
        } failure:^(HttpException *e) {
            self.nextButton.enabled = YES;
        }];
        
    }else if (self.jumpType == 3)
    {
        //专家无密码登录
        [self loginOrRegisteNext];
    }
    
    
}

#pragma mark ---- 校验图片验证码并发送验证码 ----
- (void)loginOrRegisteNext
{
    NSMutableDictionary *setting =[NSMutableDictionary dictionary];
    setting[@"mobile"] = StrFromObj(self.phoneTextField.text);
    
    if (self.jumpType == 1) {
        setting[@"type"] = @"4";
    }else if (self.jumpType == 2){
        setting[@"type"] = @"13";
    }else if (self.jumpType == 3){
        setting[@"type"] = @"10";
    }
    
    
    setting[@"imageCode"] = StrFromObj(self.codeTextField.text);
    
    [Mbr MbrCodeSendCodeByImageVerifyWithParams:setting success:^(id DFUserModel) {
        
        BaseAPIModel *model = [BaseAPIModel parse:DFUserModel];
        if ([model.apiStatus integerValue] == 0) {
            
            Countdown *cd=[[Countdown alloc]init];
            [cd setCD:60 block:^(int cd) {
                
                if (self.jumpType == 1)
                {
                    //门店普通注册
                    QWGLOBALMANAGER.getCommonRegisterCd = cd;
                    [QWGLOBALMANAGER postNotif:NotiCountDownCommonRegister data:[NSNumber numberWithInteger:cd] object:nil];
                }else if (self.jumpType == 2)
                {
                    //专家注册
                    QWGLOBALMANAGER.getExpertRegisterCd = cd;
                    [QWGLOBALMANAGER postNotif:NotiCountDownExpertRegister data:[NSNumber numberWithInteger:cd] object:nil];
                }else if (self.jumpType == 3)
                {
                    //专家无密码登录
                    QWGLOBALMANAGER.getExpertLoginCd = cd;
                    [QWGLOBALMANAGER postNotif:NotiCountDownExpertLogin data:[NSNumber numberWithInteger:cd] object:nil];
                }
                
            }];
            
            ExpertRegisterNextViewController *vc = [[UIStoryboard storyboardWithName:@"ExpertLogin" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertRegisterNextViewController"];
            vc.jumpType = self.jumpType;
            vc.phoneNumber = self.phoneTextField.text;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            [SVProgressHUD showErrorWithStatus:model.apiMessage];
            self.nextButton.enabled = YES;
            NSURL* imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/h5/mbr/imageCode?mobile=%@&id=%f", DE_H5_DOMAIN_URL, self.phoneTextField.text, [[NSDate new] timeIntervalSince1970]]];
            [self.codeImageView setImageWithURL:imageURL];
            self.codeTextField.text = @"";
        }
        
    } failure:^(HttpException *e) {
        self.nextButton.enabled = YES;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
