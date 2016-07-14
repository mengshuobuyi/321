//
//  ProfessionInfoTwoViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/4/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ProfessionInfoTwoViewController.h"
#import "Circle.h"
#import "ProfessionInfoThreeViewController.h"

@interface ProfessionInfoTwoViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *topBgView;
@property (weak, nonatomic) IBOutlet UIView *textFieldBgvIEW;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

//下一步
- (IBAction)nextAction:(id)sender;

@end

@implementation ProfessionInfoTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人资料";
    [self configureUI];
}

- (void)configureUI
{
    self.topBgView.backgroundColor = [UIColor clearColor];
    self.textFieldBgvIEW.layer.cornerRadius = 3.0;
    self.textFieldBgvIEW.layer.masksToBounds = YES;
    self.textFieldBgvIEW.layer.borderColor = RGBHex(qwColor10).CGColor;
    self.textFieldBgvIEW.layer.borderWidth = 0.5;
    
    self.nextButton.layer.cornerRadius = 4.0;
    self.nextButton.layer.masksToBounds = YES;
    
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.textField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
    maxNum = 6;
    
    if (toBeString.length > maxNum) {
        textView.text = [toBeString substringToIndex:maxNum];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)nextAction:(id)sender
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
        return;
    }
    
    //姓名去空格处理
    
    NSString *nameStr = [self.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (StrIsEmpty(nameStr)) {
        [SVProgressHUD showErrorWithStatus:@"请输入真实姓名"];
        return;
    }
    
    ProfessionInfoThreeViewController *vc = [[UIStoryboard storyboardWithName:@"ExpertAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"ProfessionInfoThreeViewController"];
    vc.headerImageUrl = self.headerImageUrl;
    vc.nameString = nameStr;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
