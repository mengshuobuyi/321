//
//  commonTelView.m
//  wenYao-store
//
//  Created by caojing on 16/5/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "commonTelView.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "QWGlobalManager.h"
#import "Coupn.h"

@implementation commonTelView

+ (commonTelView *)showAlertViewAtView:(UIWindow *)aView withType:(NSString *)promotionType andId:(NSString *)promotionId callBack:(disMissCallback)callBack{
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"commonTelView" owner:nil options:nil];
    commonTelView *alertView = [nibView objectAtIndex:0];
    alertView.dismissCallback = callBack;
    alertView.frame = CGRectMake(0, 0, aView.frame.size.width, aView.frame.size.height);
    alertView.CustomAlertView.transform = CGAffineTransformMakeScale(0, 0);
    alertView.bkView.alpha = 0.0f;
    alertView.promotionType=promotionType;
    alertView.promotionId=promotionId;
    [aView addSubview:alertView];
    
    [UIView animateWithDuration:0.3 animations:^{
        alertView.bkView.alpha = 0.4f;
        alertView.CustomAlertView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        
    }];
    
    return alertView;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.btn.layer.masksToBounds = YES;
    self.btn.layer.cornerRadius = 4.0f;

    self.CustomAlertView.layer.masksToBounds = YES;
    self.CustomAlertView.layer.cornerRadius = 10.0f;
    
    self.texdFie.layer.borderWidth = 0.5f;
    self.texdFie.layer.cornerRadius = 4;
    self.texdFie.layer.borderColor = RGBHex(qwColor10).CGColor;
    self.texdFie.delegate=self;
    self.texdFie.keyboardType = UIKeyboardTypeNumberPad;
    [self.texdFie addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    CGFloat offset=self.bkView.frame.size.height-(self.CustomAlertView.frame.origin.y+self.CustomAlertView.frame.size.height+216);
    if(offset<=0){
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame=self.CustomAlertView.frame;
        frame.origin.y=frame.origin.y+offset;
        self.CustomAlertView.frame=frame;
    }];
    }
    return YES;
}



-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame=self.CustomAlertView.frame;
        frame.origin.y=192.0;
        self.CustomAlertView.frame=frame;
    }];
    return YES;
}



#pragma mark ---- 监听文本变化 四位空格 ----

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;  {
    if (textField == self.texdFie) {
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


- (void)addSubview:(UIView *)view{
    [super addSubview:view];
}



- (IBAction)dimissView:(id)sender {
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    
    if (![QWGLOBALMANAGER isTelPhoneNumber:[self.texdFie.text stringByReplacingOccurrencesOfString:@" " withString:@""]]) {
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
    setting[@"mobile"] = StrFromObj([self.texdFie.text stringByReplacingOccurrencesOfString:@" " withString:@""]);
    
    [Coupn couponPresentPromotionWithParams:setting success:^(id obj) {
        
        if ([obj[@"apiStatus"] intValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"送券成功！" duration:2.0];
            [self dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"]];
        }
        
    } failure:^(HttpException *e) {
        
    }];
}
- (IBAction)dismiss:(id)sender {
    [self dismiss];
}

- (void)dismiss{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bkView.alpha = 0.0f;
        self.CustomAlertView.transform = CGAffineTransformMakeScale(0, 0);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        if (self.dismissCallback) {
            self.dismissCallback(nil);
        }
    }];
}

@end

