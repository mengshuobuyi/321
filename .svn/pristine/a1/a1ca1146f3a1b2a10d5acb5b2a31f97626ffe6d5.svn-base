//
//  NutritionInfoTwoViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/4/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "NutritionInfoTwoViewController.h"
#import "ExpertAuthCommitViewController.h"
#import "Circle.h"

@interface NutritionInfoTwoViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *topBgView;
@property (weak, nonatomic) IBOutlet UIView *textFieldBgView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;

- (IBAction)applyAction:(id)sender;

@end

@implementation NutritionInfoTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人资料";
    [self configureUI];
}

- (void)configureUI
{
    self.topBgView.backgroundColor = [UIColor clearColor];
    self.textFieldBgView.layer.cornerRadius = 3.0;
    self.textFieldBgView.layer.masksToBounds = YES;
    self.textFieldBgView.layer.borderColor = RGBHex(qwColor10).CGColor;
    self.textFieldBgView.layer.borderWidth = 0.5;
    
    self.applyButton.layer.cornerRadius = 4.0;
    self.applyButton.layer.masksToBounds = YES;
    
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

#pragma mark ---- 申请认证 ----
- (IBAction)applyAction:(id)sender
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
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"name"] = StrFromObj(nameStr);
    setting[@"headImageUrl"] = StrFromObj(self.headerImageUrl);
    setting[@"expertise"] = [NSString stringWithFormat:@"营养保健%@疾病调养",SeparateStr];
    setting[@"status"] = @"1";;
    [Circle TeamUpdateMbrInfoWithParams:setting success:^(id obj) {
        
        BaseAPIModel *model = [BaseAPIModel parse:obj];
        if ([model.apiStatus integerValue] == 0) {
            ExpertAuthCommitViewController *vc = [[UIStoryboard storyboardWithName:@"ExpertAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertAuthCommitViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:model.apiMessage];
        }
    } failure:^(HttpException *e) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
