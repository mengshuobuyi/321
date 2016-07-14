//
//  EditCityExpressViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/7/13.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "EditCityExpressViewController.h"
#import "MADateView.h"
#import "Bmmall.h"

@interface EditCityExpressViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;

@property (weak, nonatomic) IBOutlet UIButton *timeBtn;

@property (weak, nonatomic) IBOutlet UITextField *quickPriceTextField;

@property (weak, nonatomic) IBOutlet UITextField *freePriceTextField;

@property (strong, nonatomic) NSString *timeText;


- (IBAction)selectTimeAction:(id)sender;

- (IBAction)cancleAction:(id)sender;

@end

@implementation EditCityExpressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"同城快递";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.quickPriceTextField.delegate = self;
    self.freePriceTextField.delegate = self;
    
    self.timeText = self.deliverTimeText;
    self.quickPriceTextField.text = self.quickPriceText;
    self.freePriceTextField.text = self.freePriceText;
    
    [self checkTimeTextColor];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length == 1) {
        NSString *prefixStr = [textField.text substringWithRange:NSMakeRange(0, 1)];
        if ([prefixStr isEqualToString:@"0"]) {
            NSString *replaceStr = [textField.text stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:string];
            textField.text = replaceStr;
            return NO;
        }
    }
    
    return YES;
}

#pragma mark ---- UITableViewDelegate ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return .1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"aaaaaaaaaCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell ==  nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    return cell;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark ---- 选择配送时间 ----
- (IBAction)selectTimeAction:(id)sender
{
    [self.view endEditing:YES];
    
    UIButton *button = (UIButton *)sender;
    NSString *buttonTitle = button.titleLabel.text;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *date = [dateFormatter dateFromString:buttonTitle];
    
    __block EditCityExpressViewController *weakSelf = self;
    [MADateView showDateViewWithDate:date Style:DateViewStyleTime CallBack:^(MyWindowClick buttonIndex, NSString *timeStr) {
        
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        
        switch (buttonIndex) {
            case MyWindowClickForOK:
            {
                self.timeText = timeStr;
                [weakSelf.timeBtn setTitle:timeStr forState:UIControlStateNormal];
                [self checkTimeTextColor];
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


- (void)checkTimeTextColor
{
    if (StrIsEmpty(self.timeText))
    {
        [self.timeBtn setTitleColor:RGBHex(qwColor9) forState:UIControlStateNormal];
        [self.timeBtn setTitle:@"请选择时间" forState:UIControlStateNormal];
    }else
    {
        [self.timeBtn setTitleColor:RGBHex(qwColor6) forState:UIControlStateNormal];
        [self.timeBtn setTitle:self.timeText forState:UIControlStateNormal];
    }
    
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
        setting[@"delivery"] = @"3"; //1：到店取货，2：送货上门，3：同城快递
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

#pragma mark ---- 保存 ----
- (void)saveAction
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
        return;
    }
    
    if (StrIsEmpty(self.timeText) || [self.timeText isEqualToString:@"请选择时间"]) {
        [SVProgressHUD showErrorWithStatus:@"请选择发货时间" duration:DURATION_SHORT];
        return;
    }
    
    if (StrIsEmpty(self.quickPriceTextField.text)) {
        [SVProgressHUD showErrorWithStatus:@"请设置快递费" duration:DURATION_SHORT];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
    setting[@"expressFee"] = StrFromObj(self.quickPriceTextField.text);
    setting[@"expressFreeFee"] = StrFromObj(self.freePriceTextField.text);
    setting[@"expressTime"] = StrFromObj(self.timeText);
    
    [Bmmall BmmallDeliveryExpressWithParams:setting success:^(id obj) {
        BaseAPIModel *model = [BaseAPIModel parse:obj];
        if ([model.apiStatus integerValue] == 0) {
            [self.navigationController popViewControllerAnimated:YES];
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
