//
//  OrganAuthEditViewController.m
//  wenYao-store
//
//  Created by YYX on 15/8/19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "OrganAuthEditViewController.h"
#import "OrganAuthEditCell.h"
#import "UIViewController+LJWKeyboardHandlerHelper.h"
#import "OrganAuthCompleteViewController.h"
#import "CustomCityView.h"
#import "Branch.h"

@interface OrganAuthEditViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,OrganAuthEditCellDelegate,CustomCityViewDelegaet>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) NSMutableArray *titleArray;

@property (strong, nonatomic) NSMutableArray *placeHolderArray;

// 选择省市 弹出框
@property (strong, nonatomic) CustomCityView *customCityView;

// 省编码
@property (strong, nonatomic) NSString *provinceCode;

// 市编码
@property (strong, nonatomic) NSString *cityCode;

// 提交
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

// 复制 qq
@property (weak, nonatomic) IBOutlet UIButton *cobyQQButton;

// 复制 微信
@property (weak, nonatomic) IBOutlet UIButton *cobyWechatButton;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *qqLabel;

@property (weak, nonatomic) IBOutlet UILabel *weChatLabel;

// 提交
- (IBAction)commitAction:(id)sender;

// 拨号
- (IBAction)callAction:(id)sender;

// 复制 qq
- (IBAction)copyQQAction:(id)sender;

// 复制 微信
- (IBAction)copyWechatAction:(id)sender;

@end

@implementation OrganAuthEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"机构认证";
    
    [self setUpRightItem];
    
    self.titleArray = [NSMutableArray arrayWithObjects:@"所在省市",@"连锁公司名称",@"联系人",@"联系电话", nil];
    self.placeHolderArray = [NSMutableArray arrayWithObjects:@"选择省、市",@"请输入公司名称",@"请输入联系人",@"请输入联系电话",nil];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    
    self.commitButton.layer.cornerRadius = 3.0;
    self.commitButton.layer.masksToBounds = YES;
    [self configureCommitButtonGray];
    
    // tableView编辑 键盘up down
    [self registerLJWKeyboardHandler];
}

#pragma mark ---- 提交按钮置灰 ----

- (void)configureCommitButtonGray
{
    self.commitButton.enabled = NO;
    [self.commitButton setBackgroundColor:RGBHex(qwColor9)];
    [self.commitButton setBackgroundImage:nil forState:UIControlStateNormal];
}

#pragma mark ---- 提交按钮高亮 ----

- (void)ConfigureCommitButtonBlue
{
    self.commitButton.enabled = YES;
    [self.commitButton setBackgroundImage:[UIImage imageNamed:@"login_green_bg"] forState:UIControlStateNormal];
    [self.commitButton setBackgroundImage:[UIImage imageNamed:@"login_green_bg_click"] forState:UIControlStateHighlighted];
    [self.commitButton setBackgroundImage:[UIImage imageNamed:@"login_green_bg_click"] forState:UIControlStateSelected];
}

#pragma mark ---- 关闭 ----

- (void)setUpRightItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeAction)];
}

- (void)closeAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
            [self judgeTextFieldText:textView];
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        [self judgeTextFieldText:textView];
    }
}

- (void)judgeTextFieldText:(UITextField *)textField
{
    UITextField *textView = textField;
    NSString *toBeString = textView.text;
    
    int maxNum;
    if (textView.tag == 1001){ //连锁机构名称
        maxNum = 42;
    }else if (textView.tag == 1002){ //联系人
        maxNum = 10;
    }else if (textView.tag == 1003){ // 联系电话
        maxNum = 13;
    }
    
    if (toBeString.length > maxNum) {
        textView.text = [toBeString substringToIndex:maxNum];
    }
    [self judgeCommitButtonEnable];

}

#pragma mark ---- 判断提交按钮 是否高亮  ----

- (void)judgeCommitButtonEnable
{
    UILabel *cityLabel = (UILabel *)[self.view viewWithTag:100];                        // 省市区
    UITextField *organNameTextField = (UITextField *)[self.view viewWithTag:1001];      // 连锁机构名称
    UITextField *contactNameTextField = (UITextField *)[self.view viewWithTag:1002];    // 联系人
    UITextField *contactPhoneTextField = (UITextField *)[self.view viewWithTag:1003];   // 联系电话
    
    if ([QWGLOBALMANAGER removeSpace:cityLabel.text].length>0 && ![cityLabel.text isEqualToString:@"选择省、市"] && [QWGLOBALMANAGER removeSpace:organNameTextField.text].length>0 && [QWGLOBALMANAGER removeSpace:contactNameTextField.text].length>0 && [QWGLOBALMANAGER removeSpace:contactPhoneTextField.text].length>0) {
        [self ConfigureCommitButtonBlue];  // 高亮
    }else{
        [self configureCommitButtonGray];  // 置灰
    }
}

#pragma mark ---- 弹出省市区代理 ----

- (void)provinceAndCityUp
{
    self.customCityView = [CustomCityView sharedManager];
    [self.customCityView show];
    self.customCityView.delegate = self;
    [self.view endEditing:YES];
}

#pragma mark ---- 选择省市区代理 ----

- (void)getProvinceAndCityAction:(NSString *)str provinceCode:(NSString *)provinceCode cityCode:(NSString *)cityCode;
{
    UILabel *cityLabel = (UILabel *)[self.view viewWithTag:100];                       // 所在省市
    UITextField *organNameTextField = (UITextField *)[self.view viewWithTag:1001];     // 连锁机构名称
    UITextField *contactNameTextField = (UITextField *)[self.view viewWithTag:1002];   // 联系人
    UITextField *contactPhoneTextField = (UITextField *)[self.view viewWithTag:1003];  // 联系电话
    
    cityLabel.textColor = RGBHex(0x333333);
    cityLabel.text = str;
    self.provinceCode = provinceCode;
    self.cityCode = cityCode;
    
    if ([QWGLOBALMANAGER removeSpace:organNameTextField.text].length>0 && [QWGLOBALMANAGER removeSpace:contactNameTextField.text].length>0 && [QWGLOBALMANAGER removeSpace:contactPhoneTextField.text].length>0) {
        [self ConfigureCommitButtonBlue];  // 高亮
    }else{
        [self configureCommitButtonGray];  // 置灰
    }
}

#pragma mark ---- 列表代理 ----

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrganAuthEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrganAuthEditCell"];
    cell.titleLabel.text = self.titleArray[indexPath.row];
    
    if (indexPath.row == 3) {
        cell.inputTextField.keyboardType = UIKeyboardTypePhonePad;
    }
    
    if (indexPath.row == 0) {
        cell.cityLabel.hidden = NO;
        cell.cityButton.hidden = NO;
        cell.inputTextField.hidden = YES;
    }else{
        cell.cityLabel.hidden = YES;
        cell.cityButton.hidden = YES;
        cell.inputTextField.hidden = NO;
    }
    
    // 所在省市 代理
    cell.organAuthEditCellDelegate = self;
    cell.cityLabel.tag = indexPath.row+100;
    
    cell.inputTextField.tag = indexPath.row+1000;
    cell.inputTextField.placeholder = self.placeHolderArray[indexPath.row];
    [cell.inputTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [cell.inputTextField setValue:RGBHex(0xaaaaaa) forKeyPath:@"_placeholderLabel.textColor"];
    
    return cell;
}

#pragma mark ---- 提交 ----

- (IBAction)commitAction:(id)sender
{
    [self.view endEditing:YES];
    
    UILabel *cityLabel = (UILabel *)[self.view viewWithTag:100];                       // 省市区
    UITextField *organNameTextField = (UITextField *)[self.view viewWithTag:1001];     // 连锁公司名称
    UITextField *contactNameTextField = (UITextField *)[self.view viewWithTag:1002];   // 联系人
    UITextField *contactPhoneTextField = (UITextField *)[self.view viewWithTag:1003];  // 联系电话
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:@"网络未连接，请稍后重试！" duration:0.8];
        return;
    }
    
    // 判断4项内容是否填充
    if ([QWGLOBALMANAGER removeSpace:cityLabel.text].length>0 && [QWGLOBALMANAGER removeSpace:organNameTextField.text].length>0 && [QWGLOBALMANAGER removeSpace:contactNameTextField.text].length>0 && [QWGLOBALMANAGER removeSpace:contactPhoneTextField.text].length>0)
    {
        // 判断手机号是否正确
        if (![QWGLOBALMANAGER isTelPhoneNumber:[QWGLOBALMANAGER removeSpace:contactPhoneTextField.text]]) {
            [SVProgressHUD showErrorWithStatus:Kwarning220N70 duration:0.8];
            return;
        }
        
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
        setting[@"provinceCode"] = StrFromObj(self.provinceCode);
        setting[@"cityCode"] = StrFromObj(self.cityCode);
        setting[@"user"] = StrFromObj([QWGLOBALMANAGER removeSpace:contactNameTextField.text]);
        setting[@"tel"] = StrFromObj([QWGLOBALMANAGER removeSpace:contactPhoneTextField.text]);
        setting[@"name"] = StrFromObj([QWGLOBALMANAGER removeSpace:organNameTextField.text]);
        
        [Branch PassportBranchLinkageReserveWithParams:setting success:^(id obj) {
            
            if ([obj[@"apiStatus"] integerValue] == 0) {
                
                OrganAuthCompleteViewController *vc = [[UIStoryboard storyboardWithName:@"OrganAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"OrganAuthCompleteViewController"];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"] duration:0.8];
            }
            
        } failure:^(HttpException *e) {
            
        }];
    }
}

#pragma mark ---- 拨号 ----

- (IBAction)callAction:(id)sender
{
    NSString *tel = self.phoneLabel.text;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",tel]]];
}

#pragma mark ---- 复制 qq ----

- (IBAction)copyQQAction:(id)sender
{
    [[UIPasteboard generalPasteboard] setString:self.qqLabel.text];
    [SVProgressHUD showSuccessWithStatus:Kwarning220N68 duration:0.8];
}

#pragma mark ---- 复制微信 ----

- (IBAction)copyWechatAction:(id)sender
{
    [[UIPasteboard generalPasteboard] setString:self.weChatLabel.text];
    [SVProgressHUD showSuccessWithStatus:Kwarning220N68 duration:0.8];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
