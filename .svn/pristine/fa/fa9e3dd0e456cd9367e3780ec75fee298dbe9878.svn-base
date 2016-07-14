//
//  OrganInfoEditViewController.m
//  wenYao-store
//
//  Created by YYX on 15/8/19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "OrganInfoEditViewController.h"
#import "OrganInfoEditCell.h"
#import "UIViewController+LJWKeyboardHandlerHelper.h"
#import "OrganLocationViewController.h"
#import "UploadLicenseViewController.h"
#import "Branch.h"
#import "OrganInfoEditModel.h"

@interface OrganInfoEditViewController ()<UITableViewDataSource,UITableViewDelegate,OrganInfoEditCellDelegaet,OrganLocationViewControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *footerView;

// 下一步
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;

@property (strong, nonatomic) NSMutableArray *titleArray;

@property (strong, nonatomic) NSMutableArray *placeHolderArray;

// textField 输入集合
@property (strong, nonatomic) NSMutableArray *textFieldArray;

// button text集合
@property (strong, nonatomic) NSMutableArray *buttonTextArray;

// 维度
@property (strong, nonatomic) NSString *latitude;

// 经度
@property (strong, nonatomic) NSString *longitude;

// 省
@property (strong, nonatomic) NSString *provinceName;

// 市
@property (strong, nonatomic) NSString *cityName;

// 区
@property (strong, nonatomic) NSString *countyName;

// 下一页 上传证照 的数组 缓存使用
@property (strong, nonatomic) NSArray *licenseArray;

@property (strong, nonatomic) NSString *shitType;


- (IBAction)nextStepAction:(id)sender;

@end

@implementation OrganInfoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"机构信息";
    
    self.titleArray = [NSMutableArray arrayWithObjects:@"门店名称",@"门店地址",@"地理位置",@"电话",@"姓名", nil];
    self.placeHolderArray = [NSMutableArray arrayWithObjects:@"输入门店名称",@"必须与营业执照上地址一致",@"",@"请填写电话",@"请输入您的姓名", nil];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = self.footerView;
    
    self.nextStepButton.layer.cornerRadius = 3.0;
    self.nextStepButton.layer.masksToBounds = YES;
    
    [self configureNextButtonGray];
    
    // tableView 编辑 键盘 up down
    [self registerLJWKeyboardHandler];
    
    [self loadCache];
}

#pragma mark ---- 下一步按钮高亮 ----

- (void)configureNextButtonGray
{
    self.nextStepButton.enabled = NO;
    [self.nextStepButton setBackgroundColor:RGBHex(qwColor9)];
    [self.nextStepButton setBackgroundImage:nil forState:UIControlStateNormal];
}

#pragma mark ---- 下一步按钮置灰 ----

- (void)ConfigureNextButtonBlue
{
    self.nextStepButton.enabled = YES;
    [self.nextStepButton setBackgroundImage:[UIImage imageNamed:@"login_green_bg"] forState:UIControlStateNormal];
    [self.nextStepButton setBackgroundImage:[UIImage imageNamed:@"login_green_bg_click"] forState:UIControlStateHighlighted];
    [self.nextStepButton setBackgroundImage:[UIImage imageNamed:@"login_green_bg_click"] forState:UIControlStateSelected];
}

#pragma mark ---- 去缓存 ----

- (void)loadCache
{
    self.textFieldArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"", nil];
    self.buttonTextArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"", nil];
    
    OrganInfoEditModel *infoModel = [QWUserDefault getObjectBy:[NSString stringWithFormat:@"OrganInfo+%@",QWGLOBALMANAGER.configure.passportId]];
    if (infoModel)
    {
        // 有缓存的时候
        [self configureArray:infoModel];
        
    }else
    {
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable)
        {
            // 什么都没有的时候
            [self noCacheAboutOrganInfo];
            [SVProgressHUD showErrorWithStatus:kWarning215N6 duration:0.8];
            
        }else
        {
            NSMutableDictionary *setting = [NSMutableDictionary dictionary];
            setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
            [Branch BranchApproveWithParams:setting success:^(id obj) {
                
                OrganInfoEditModel * mod = (OrganInfoEditModel *)obj;
                if ([mod.apiStatus integerValue] == 0)
                {
                    self.licenseArray = mod.licenses;
                    self.shitType = mod.type;
                    [self configureArray:mod];
                    
                }else
                {
                    // 什么都没有的时候
                    [self noCacheAboutOrganInfo];
                }
                
            } failure:^(HttpException *e) {
                
                // 什么都没有的时候
                [self noCacheAboutOrganInfo];
            }];
        }
    }
}

#pragma mark ---- 没有缓存数据 ----

- (void)noCacheAboutOrganInfo
{
    NSString *locationStr = @"点击定位地理位置";
    [self.buttonTextArray replaceObjectAtIndex:2 withObject:locationStr];
    [self.tableView reloadData];
}

#pragma mark ---- 初始化数据 ----

- (void)configureArray:(OrganInfoEditModel *)infoModel
{
    // 机构名称
    NSString *organNameStr;
    if (infoModel.name && ![infoModel.name isEqualToString:@""]) {
        organNameStr = infoModel.name;
    }else{
        organNameStr = @"";
    }
    
    // 机构地址
    NSString *organAddressStr;
    if (infoModel.address && ![infoModel.address isEqualToString:@""]) {
        organAddressStr = infoModel.address;
    }else{
        organAddressStr = @"";
    }
    
    // 机构座机
    NSString *organPhoneStr;
    if (infoModel.tel && ![infoModel.tel isEqualToString:@""]) {
        organPhoneStr = infoModel.tel;
    }else{
        organPhoneStr = @"";
    }
    
    // 软件使用人姓名
    NSString *userNameStr;
    if (infoModel.user && ![infoModel.user isEqualToString:@""]) {
        userNameStr = infoModel.user;
    }else{
        userNameStr = @"";
    }
    
    // 地理位置
    NSString *locationStr;
    if (infoModel.latitude && infoModel.longitude && ![StrFromObj(infoModel.latitude) isEqualToString:@""] && ![StrFromObj(infoModel.longitude) isEqualToString:@""]) {
        locationStr = [NSString stringWithFormat:@"经度%.2f 纬度%.2f",[infoModel.longitude floatValue],[infoModel.latitude floatValue]];;
    }else{
        locationStr = @"点击定位地理位置";
    }
    
    if (infoModel.latitude && ![StrFromObj(infoModel.latitude) isEqualToString:@""]) {
        self.latitude = infoModel.latitude;
    }
    
    if (infoModel.longitude && ![StrFromObj(infoModel.longitude) isEqualToString:@""]) {
        self.longitude = infoModel.longitude;
    }
    
    if (infoModel.province && ![infoModel.province isEqualToString:@""]) {
        self.provinceName = infoModel.province;
    }
    
    if (infoModel.city && ![infoModel.city isEqualToString:@""]) {
        self.cityName = infoModel.city;
    }
    
    if (infoModel.county && ![infoModel.county isEqualToString:@""]) {
        self.countyName = infoModel.county;
    }
    
    
    if (organNameStr.length>0 && organAddressStr.length>0 && organPhoneStr.length>0 && userNameStr.length>0 && locationStr.length>0) {
        [self ConfigureNextButtonBlue];
    }
    
    [self.textFieldArray replaceObjectAtIndex:0 withObject:organNameStr];
    [self.textFieldArray replaceObjectAtIndex:1 withObject:organAddressStr];
    [self.textFieldArray replaceObjectAtIndex:3 withObject:organPhoneStr];
    [self.textFieldArray replaceObjectAtIndex:4 withObject:userNameStr];
    [self.buttonTextArray replaceObjectAtIndex:2 withObject:locationStr];
    [self.tableView reloadData];
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
    if (textView.tag == 1000) {// 机构名称
        maxNum = 42;
    }else if (textView.tag == 1001){// 机构地址
        maxNum = 80;
    }else if (textView.tag == 1003){// 机构座机
        maxNum = 13;
    }else if (textView.tag == 1004){// 软件使用人姓名
        maxNum = 10;
    }
    
    if (toBeString.length > maxNum) {
        textView.text = [toBeString substringToIndex:maxNum];
    }
    [self.textFieldArray replaceObjectAtIndex:textView.tag-1000 withObject:textView.text];
    [self judgeCommitButtonEnable];
}

#pragma mark ---- 判断提交按钮 是否高亮  ----

- (void)judgeCommitButtonEnable
{
    NSString *organName = self.textFieldArray[0];           // 机构名称
    NSString *organAddress = self.textFieldArray[1];        // 机构地址
    NSString *locationText = self.buttonTextArray[2];       // 定位按钮
    NSString *organPhone = self.textFieldArray[3];          // 机构座机
    NSString *userName = self.textFieldArray[4];            // 软件使用人姓名
    
    if ([QWGLOBALMANAGER removeSpace:locationText].length>0 && ![locationText isEqualToString:@"点击定位地理位置"] && [QWGLOBALMANAGER removeSpace:organName].length>0 && [QWGLOBALMANAGER removeSpace:organAddress].length>0 && [QWGLOBALMANAGER removeSpace:organPhone].length>0 && [QWGLOBALMANAGER removeSpace:userName].length>0) {
        [self ConfigureNextButtonBlue];  // 高亮
    }else{
        [self configureNextButtonGray];  // 置灰
    }
}

#pragma mark ---- 点击定位 ----

- (void)locationAction
{
    OrganLocationViewController *vc = [[UIStoryboard storyboardWithName:@"OrganAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"OrganLocationViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.organLocationViewControllerDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark ---- 地理位置 传经纬度代理 ----

- (void)passLocationValue:(CGFloat)latitude longitude:(CGFloat)longitude otherInfo:(NSDictionary *)dic
{
    NSString *location = [NSString stringWithFormat:@"经度%.2f 纬度%.2f",(float)longitude,(float)latitude];
    [self.buttonTextArray replaceObjectAtIndex:2 withObject:location];
    [self.tableView reloadData];
    
    self.latitude = [NSString stringWithFormat:@"%f",latitude];
    self.longitude = [NSString stringWithFormat:@"%f",longitude];
    self.provinceName = StrFromObj(dic[@"province"]);
    self.cityName = StrFromObj(dic[@"city"]);
    self.countyName = StrFromObj(dic[@"county"]);
    
    NSString *organName = self.textFieldArray[0];           // 机构名称
    NSString *organAddress = self.textFieldArray[1];        // 机构地址
    NSString *locationText = self.buttonTextArray[2];       // 定位按钮
    NSString *organPhone = self.textFieldArray[3];          // 机构座机
    NSString *userName = self.textFieldArray[4];            // 软件使用人姓名
    
    if ([QWGLOBALMANAGER removeSpace:locationText].length>0 && ![locationText isEqualToString:@"点击定位地理位置"] && [QWGLOBALMANAGER removeSpace:organName].length>0 && [QWGLOBALMANAGER removeSpace:organAddress].length>0 && [QWGLOBALMANAGER removeSpace:organPhone].length>0 && [QWGLOBALMANAGER removeSpace:userName].length>0) {
        [self ConfigureNextButtonBlue];
    }else{
        [self configureNextButtonGray];
    }
}

#pragma mark ---- 列表代理 ----

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrganInfoEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrganInfoEditCell"];
    
    if (indexPath.row == 2) {
        cell.inputTextField.hidden = YES;
        cell.locationBg.hidden = NO;
    }else{
        cell.inputTextField.hidden = NO;
        cell.locationBg.hidden = YES;
    }
    
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.inputTextField.placeholder = self.placeHolderArray[indexPath.row];
    cell.inputTextField.text = self.textFieldArray[indexPath.row];
    [cell.locationButton setTitle:self.buttonTextArray[indexPath.row] forState:UIControlStateNormal];
    
    //top, left, bottom, right
    if (cell.locationButton.titleLabel.text.length >0 && ![cell.locationButton.titleLabel.text isEqualToString:@"点击定位地理位置"]) {
        [cell.locationButton setTitleColor:RGBHex(0x333333) forState:UIControlStateNormal];
        [cell.locationButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -5)];
    }else{
        [cell.locationButton setTitleColor:RGBHex(0xaaaaaa) forState:UIControlStateNormal];
        [cell.locationButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -40)];
    }
    
    cell.locationButton.tag = indexPath.row+100;
    cell.organInfoEditCellDelegaet = self;
    
    cell.inputTextField.tag = indexPath.row+1000;
    cell.inputTextField.delegate = self;
    [cell.inputTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [cell.inputTextField setValue:RGBHex(0xaaaaaa) forKeyPath:@"_placeholderLabel.textColor"];
    
    return cell;
}

#pragma mark ---- UITextField Delegate ----

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UITextField *textView = (UITextField *)textField;
    if (textView.text.length == 0) {
        textView.text = @"";
    }
    [self.textFieldArray replaceObjectAtIndex:textView.tag-1000 withObject:textView.text];
    
    [self judgeCommitButtonEnable];
    [self.tableView reloadData];
}

#pragma mark ---- 左侧返回按钮 ----

- (void)popVCAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---- 下一步 ----

- (IBAction)nextStepAction:(id)sender
{
    UITextField *organNameTextField = (UITextField *)[self.view viewWithTag:1000];        // 机构名称
    UITextField *organAddressTextField = (UITextField *)[self.view viewWithTag:1001];     // 机构地址
    UITextField *OrganPhoneTextField = (UITextField *)[self.view viewWithTag:1003];       // 机构座机
    UITextField *userNameTextField = (UITextField *)[self.view viewWithTag:1004];         // 软件使用人姓名
    
    NSString *organNameText = [QWGLOBALMANAGER removeSpace:organNameTextField.text];
    NSString *organAddressText =[QWGLOBALMANAGER removeSpace:organAddressTextField.text];
    NSString *organPhoneText = [QWGLOBALMANAGER removeSpace:OrganPhoneTextField.text];
    NSString *userNameText = [QWGLOBALMANAGER removeSpace:userNameTextField.text];
    
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:@"网络未连接，请稍后重试！" duration:0.8];
        return;
    }
    
    // 判断手机号是否正确
    if (![QWGLOBALMANAGER isTelPhoneNumber:organPhoneText]) {
        [SVProgressHUD showErrorWithStatus:Kwarning220N78 duration:0.8];
        return;
    }
    
    
    // 机构的基本信息 缓存
    
    OrganInfoEditModel *infoModel = [[OrganInfoEditModel alloc] init];
    infoModel.name = StrFromObj(organNameText);
    infoModel.address = StrFromObj(organAddressText);
    infoModel.latitude = StrFromObj(self.latitude);
    infoModel.longitude= StrFromObj(self.longitude);
    infoModel.province = StrFromObj(self.provinceName);
    infoModel.city = StrFromObj(self.cityName);
    infoModel.county = StrFromObj(self.countyName);
    infoModel.tel = StrFromObj(organPhoneText);
    infoModel.user = StrFromObj(userNameText);
    infoModel.type = [NSString stringWithFormat:@"%d",self.organType];
    [QWUserDefault setObject:infoModel key:[NSString stringWithFormat:@"OrganInfo+%@",QWGLOBALMANAGER.configure.passportId]];
    
    
    // 下一页保存信息 的请求参数
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
    setting[@"name"] = StrFromObj(organNameText);
    setting[@"address"] = StrFromObj(organAddressText);
    setting[@"province"] = StrFromObj(self.provinceName);
    setting[@"city"] = StrFromObj(self.cityName);
    setting[@"county"] = StrFromObj(self.countyName);
    setting[@"longitude"] = StrFromObj(self.longitude);
    setting[@"latitude"] = StrFromObj(self.latitude);
    setting[@"tel"] = StrFromObj(organPhoneText);
    setting[@"user"] = StrFromObj(userNameText);
    if (self.organType == 2) {
        setting[@"type"] = @"2";
    }else if (self.organType == 3){
        setting[@"type"] = @"3";
    }

    UploadLicenseViewController *vc = [[UIStoryboard storyboardWithName:@"OrganAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"UploadLicenseViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.organType = self.organType;
    vc.paramDic = setting;
    if (self.licenseArray.count>0) {
        vc.licenseArray = self.licenseArray;
    }
    
    if ([self.shitType integerValue] == 0) {
        self.shitType = [NSString stringWithFormat:@"%d",self.organType];
    }
    vc.shitType = self.shitType;
    
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
