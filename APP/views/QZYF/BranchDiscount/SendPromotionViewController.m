//
//  SendPromotionViewController.m
//  wenYao-store
//
//  Created by garfield on 15/10/30.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "SendPromotionViewController.h"
#import "Coupn.h"

@interface SendPromotionViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sendCouponButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;

@end

@implementation SendPromotionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.title = @"送券";
    
    [self.phoneNumTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self configUI];
}

#pragma mark ---- 设置 ui ----

- (void)configUI
{
    _sendCouponButton.layer.masksToBounds = YES;
    _sendCouponButton.layer.cornerRadius = 3.0;
    _containerView.layer.masksToBounds = YES;
    _containerView.layer.cornerRadius = 4.0;
    _containerView.layer.borderWidth = 0.5;
    _containerView.layer.borderColor = RGBHex(qwColor10).CGColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark ---- 监听文本变化 四位空格 ----

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;  {
    if (textField == self.phoneNumTextField) {
        // 四位加一个空格
        if ([string isEqualToString:@""]) { // 删除字符
            
            if (textField.text.length == 8) {
                textField.text = [textField.text substringToIndex:textField.text.length - 1];
            }else if (textField.text.length == 3){
                textField.text = [textField.text substringToIndex:textField.text.length - 1];
            }
            
            return YES;
        } else {
            if (textField.text.length == 3) {
                textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
            }else if (textField.text.length == 8){
                textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
            }
        }
        return YES;
    }
    return YES;
}

#pragma mark ---- 监听文本变化 最多13个字 ----

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
            [self judgeTextFieldTextChange:textField];
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        [self judgeTextFieldTextChange:textField];
    }
}

- (void)judgeTextFieldTextChange:(UITextField *)textField
{
    UITextField *textView = textField;
    NSString *toBeString = textView.text;
    
    if (toBeString.length > 13) {
        textView.text = [toBeString substringToIndex:13];
    }
}

#pragma mark ---- 送优惠 action ----

- (IBAction)sendPromotion:(id)sender
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    
    if (![QWGLOBALMANAGER isTelPhoneNumber:[self.phoneNumTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""]]) {
        [SVProgressHUD showErrorWithStatus:@"请填写正确的手机号码" duration:0.8];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
    if ([self.promotionType intValue] == 1) {
        setting[@"promotionType"] = @"Q";
    }else if ([self.promotionType intValue] == 2){
        setting[@"promotionType"] = @"P";
    }
    setting[@"actId"] = StrFromObj(self.promotionId);
    setting[@"mobile"] = StrFromObj([self.phoneNumTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""]);
    
    [Coupn couponPresentPromotionWithParams:setting success:^(id obj) {
        
        if ([obj[@"apiStatus"] intValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"送券成功！" duration:2.0];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"]];
        }
        
    } failure:^(HttpException *e) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
