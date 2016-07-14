//
//  EditToStorePickViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/7/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "EditToStorePickViewController.h"
#import "MADateView.h"
#import "Bmmall.h"

@interface EditToStorePickViewController ()<UITextFieldDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *startTimeTextField;

@property (weak, nonatomic) IBOutlet UITextField *endTimeTextField;

- (IBAction)cancleAction:(id)sender;


@end

@implementation EditToStorePickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"到店取货";
    
    self.startTimeTextField.tag = 1;
    self.endTimeTextField.tag = 2;
    self.startTimeTextField.delegate = self;
    self.endTimeTextField.delegate = self;
    
    if (!StrIsEmpty(self.startTimeText)) {
        self.startTimeTextField.text = self.startTimeText;
    }
    
    if (!StrIsEmpty(self.endTimeText)) {
        self.endTimeTextField.text = self.endTimeText;
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
}

#pragma mark ---- 保存 ----
- (void)saveAction
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    
    if (StrIsEmpty(self.startTimeTextField.text) || StrIsEmpty(self.endTimeTextField.text)) {
        [SVProgressHUD showErrorWithStatus:@"请输入营业时间" duration:DURATION_SHORT];
        return;
    }
    
    if (!StrIsEmpty(self.startTimeTextField.text) && !StrIsEmpty(self.endTimeTextField.text))
    {
        NSArray *startArr = [self.startTimeTextField.text componentsSeparatedByString:@":"];
        NSInteger startTime = [[startArr objectAtIndex:0] integerValue] * 60 + [[startArr objectAtIndex:1] integerValue];
        
        NSArray *endArr = [self.endTimeTextField.text componentsSeparatedByString:@":"];
        NSInteger endTime = [[endArr objectAtIndex:0] integerValue] * 60 + [[endArr objectAtIndex:1] integerValue];
        
        if (endTime <= startTime) {
            [SVProgressHUD showErrorWithStatus:@"请设置正确的营业时间" duration:DURATION_SHORT];
            return;
        }
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = QWGLOBALMANAGER.configure.userToken;
    setting[@"openBegin"] = StrFromObj(self.startTimeTextField.text);
    setting[@"openEnd"] = StrFromObj(self.endTimeTextField.text);
    
    [Bmmall BmmallDeliveryOnsiteWithParams:setting success:^(id obj) {
        
        BaseAPIModel *model = [BaseAPIModel parse:obj];
        if ([model.apiStatus integerValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:model.apiMessage];
        }
        
    } failure:^(HttpException *e) {
        
    }];
}


#pragma mark ---- UITextFieldDelegate ----
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self selectTimeClick:textField];
    return NO;
}

#pragma mark ---- 选择营业时间 ----
- (void)selectTimeClick:(UITextField *)textField
{
    NSString *buttonTitle = textField.text;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *date = [dateFormatter dateFromString:buttonTitle];
    
    NSInteger textFieldTag = textField.tag;
    __block EditToStorePickViewController *weakSelf = self;
    [MADateView showDateViewWithDate:date Style:DateViewStyleTime CallBack:^(MyWindowClick buttonIndex, NSString *timeStr) {
        switch (buttonIndex) {
            case MyWindowClickForOK:
            {
                switch (textFieldTag) {
                    case 1: //开始时间
                    {
                        weakSelf.startTimeTextField.text = timeStr;
                    }
                        break;
                    case 2: //结束时间
                    {
                        weakSelf.endTimeTextField.text = timeStr;
                    }
                    default:
                        break;
                }
            }
                break;
            case MyWindowClickForCancel:
            {
            }
                break;
            default:
                break;
        }
    }];
}


#pragma mark ---- 取消此配送方式 ----
- (IBAction)cancleAction:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要取消此配送方式吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [SVProgressHUD showErrorWithStatus:kWaring33];
            return;
        }
        
        if (self.postTips.count == 1) {
            [SVProgressHUD showErrorWithStatus:@"本店至少要有一种配送方式"];
        }
        
        //取消此配送方式 调接口
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
        setting[@"delivery"] = @"1"; //1：到店取货，2：送货上门，3：同城快递
        [Bmmall BmmallDeliveryCancelWithParams:setting success:^(id obj) {
            
            BaseAPIModel *model = [BaseAPIModel parse:obj];
            if ([model.apiStatus integerValue] == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:model.apiMessage];
            }
        } failure:^(HttpException *e) {
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
