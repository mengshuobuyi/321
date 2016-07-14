//
//  EditInformationViewController.m
//  wenyao-store
//
//  Created by qwfy0006 on 15/4/30.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

/*
    账户详情列表
    api/215/employee/getInfo              获取店员信息
    api/215/employee/updateEmployee       更新店员信息
 */

#import "EditInformationViewController.h"
#import "EditInformationCell.h"
#import "EditDetailViewController.h"
#import "SVProgressHUD.h"
#import "SJAvatarBrowser.h"
#import "EmployeeModel.h"
#import "Employee.h"
#import "AliPayCheckPhoneViewController.h"
#import "CustomIdPhotoViewController.h"
#import "UIImage+Ex.h"
#import "EditPhoneViewController.h"

#define  EMPTYURL  @"QW_#_EMPTY"

@interface EditInformationViewController ()<UITableViewDataSource,UITableViewDelegate,EditInformationCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CustomIdPhotoViewControllerDelegate>

{
    BOOL IsHaveFaceImage;           //是否有身份证正面图片
    BOOL IsHaveRearImage;           //是否有身份证背面图片
    NSString *clickImageSign;       //添加图片标志 face正面 rear背面
    NSString *deleteImageSign;      //删除图片标志 face正面 rear背面
    NSString *uploadImageSign;      //上传图片标志 headerIcon头像 IdCard身份证
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;

@property (weak, nonatomic) IBOutlet UIImageView *headerIcon;   //头像

@property (strong, nonatomic) NSArray *dataList;

@property (strong, nonatomic) EmployeeInfoModel *infoModel;

@end

@implementation EditInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详细信息";
    self.dataList = @[@[@"姓名",@"手机号"],@[@"QQ",@"微信"],@[@"支付宝账号",@"银行卡号",@"开户行"],@[@"身份证号",@"身份证正面",@"身份证背面"]];
    
    IsHaveFaceImage = NO;
    IsHaveRearImage = NO;

    self.view.backgroundColor = RGBHex(qwColor11);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.tableHeaderView;
    
    self.headerIcon.image = [UIImage imageNamed:@"expert_ic_people"];
    self.headerIcon.layer.cornerRadius = 32;
    self.headerIcon.layer.masksToBounds = YES;
    self.headerIcon.layer.borderColor = RGBHex(qwColor10).CGColor;
    self.headerIcon.layer.borderWidth = 0.5;
    
    //点击header上传头像
    self.tableHeaderView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadHeadImage)];
    [self.tableHeaderView addGestureRecognizer:tap];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self queryMyInfo];
}

#pragma mark ---- 上传头像Action ----
- (void)uploadHeadImage
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试!" duration:DURATION_SHORT];
        return;
    }else
    {
        uploadImageSign = @"headerIcon";
        [self setUpActionSheet];
    }
}

#pragma ---- 获取我的店员信息 ----
- (void)queryMyInfo
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        
        self.tableView.hidden = YES;
        [SVProgressHUD showErrorWithStatus:kWaring12 duration:0.8];
        [self showInfoView:kWaring12 image:@"img_network"];
        return;
        
    }else
    {
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
        
        [Employee employeeGetInfoWithParam:setting success:^(id responseObj) {
            
            self.infoModel = (EmployeeInfoModel *)responseObj;
            
            if ([self.infoModel.apiStatus integerValue] == 0)
            {
                [self.headerIcon setImageWithURL:[NSURL URLWithString:self.infoModel.headImg] placeholderImage:[UIImage imageNamed:@"expert_ic_people"]];
                [self.tableView reloadData];
            }
            
        } failure:^(HttpException *e) {
            if(e.errorCode!=-999){
                if(e.errorCode == -1001){
                    [self showInfoView:kWarning215N54 image:@"ic_img_fail"];
                }else{
                    [self showInfoView:kWarning215N0 image:@"ic_img_fail"];
                }
            }
        }];
    }
}

#pragma mark ---- UITableViewDelegate ----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = self.dataList[section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }
    return 8.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditInformationCell"];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        //姓名
        
        cell.delegate = self;
        cell.label.text = self.infoModel.name;
        cell.addImage.hidden = YES;
        cell.deleteImage.hidden = YES;
        
    }else if (indexPath.section == 0 && indexPath.row == 1){
        
        //手机号
        
        cell.delegate = self;
        cell.label.text = self.infoModel.mobile;
        cell.addImage.hidden = YES;
        cell.deleteImage.hidden = YES;
        
    }else if (indexPath.section == 1 && indexPath.row == 0)
    {
        //QQ
        
        cell.delegate = self;
        cell.label.text = self.infoModel.qq;
        cell.addImage.hidden = YES;
        cell.deleteImage.hidden = YES;
        
    }else if (indexPath.section == 1 && indexPath.row == 1)
    {
        //微信
        
        cell.delegate = self;
        cell.label.text = self.infoModel.wx;
        cell.addImage.hidden = YES;
        cell.deleteImage.hidden = YES;
        
    }else if (indexPath.section == 2 && indexPath.row == 0){
        
        //支付宝账号
        
        cell.delegate = self;
        cell.label.text = [self makePayAccountHide:self.infoModel.alipay];
        cell.addImage.hidden = YES;
        cell.deleteImage.hidden = YES;
        
    }else if (indexPath.section == 2 && indexPath.row == 1){
        
        //银行卡号
        
        cell.delegate = self;
        cell.label.text = [self makeBankAccountHide:self.infoModel.bankCard];
        cell.addImage.hidden = YES;
        cell.deleteImage.hidden = YES;
        
    }else if (indexPath.section == 2 && indexPath.row == 2){
        
        //开户行
        
        cell.delegate = self;
        NSString *str = self.infoModel.bankName;
        if (str == nil || [str isEqualToString:@""]) {
            cell.label.text = @"";
        }else
        {
            cell.label.text = str;
        }
        cell.addImage.hidden = YES;
        cell.deleteImage.hidden = YES;
        
    }else if (indexPath.section == 3 && indexPath.row == 0){
        
        //身份证号
        
        cell.delegate = self;
        cell.label.text = [self makeIDCardHide:self.infoModel.ic];
        cell.addImage.hidden = YES;
        cell.deleteImage.hidden = YES;
        
    }else if (indexPath.section == 3 && indexPath.row == 1){
        
        //身份证正面
        
        cell.pushButton.hidden = YES;
        cell.label.hidden = YES;
        cell.delegate = self;
        
        if (self.infoModel.icImgF && ![self.infoModel.icImgF isEqualToString:@""]) {
            
            IsHaveFaceImage = YES;
            [cell.addImage setImageWithURL:[NSURL URLWithString:self.infoModel.icImgF]];
            cell.deleteImage.hidden = NO;
            
        }else{
            
            IsHaveFaceImage = NO;
            cell.addImage.image = [UIImage imageNamed:@"添加图片"];
            cell.deleteImage.hidden = YES;
        }
        
    }else if (indexPath.section == 3 && indexPath.row == 2){
        
        //身份证背面
        
        cell.pushButton.hidden = YES;
        cell.label.hidden = YES;
        cell.delegate = self;
        
        if (self.infoModel.icImgB && ![self.infoModel.icImgB isEqualToString:@""]) {
            
            IsHaveRearImage = YES;
            [cell.addImage setImageWithURL:[NSURL URLWithString:self.infoModel.icImgB]];
            cell.deleteImage.hidden = NO;
        }else
        {
            IsHaveRearImage = NO;
            cell.addImage.image = [UIImage imageNamed:@"添加图片"];
            cell.deleteImage.hidden = YES;
        }
    }
    
    cell.pushButton.obj = indexPath;
    cell.addTapBg.tag = indexPath.row +1000;
    cell.deleteTapBg.tag = indexPath.row+10000;
    
    cell.titleLabel.text = self.dataList[indexPath.section][indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ---- 跳转到编辑页面代理 ----

- (void)pushToNextDelegate:(id)sender
{
    QWButton *button = (QWButton *)sender;
    NSIndexPath *indexPath = button.obj;
    EditInformationCell *cell = (EditInformationCell *)[self.tableView cellForRowAtIndexPath:indexPath                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   ];
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        //姓名 （店长可编辑）
        if (AUTHORITY_ROOT) {
            EditDetailViewController *detail = [[UIStoryboard storyboardWithName:@"EditInformation" bundle:nil] instantiateViewControllerWithIdentifier:@"EditDetailViewController"];
            detail.title = @"姓名";
            detail.type = Enum_Edit_Type_Name;
            detail.content = cell.label.text;
            detail.trueStr = self.infoModel.name;
            detail.trueString = self.infoModel.name;
            detail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detail animated:YES];
        }
        
    }else if (indexPath.section == 0 && indexPath.row == 1)
    {
        //手机号
        EditPhoneViewController *detail = [[UIStoryboard storyboardWithName:@"EditInformation" bundle:nil] instantiateViewControllerWithIdentifier:@"EditPhoneViewController"];
        detail.title = @"手机号";
        detail.phoneNumber = self.infoModel.mobile;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];

    }else if (indexPath.section == 1 && indexPath.row == 0)
    {
        //QQ
        
        EditDetailViewController *detail = [[UIStoryboard storyboardWithName:@"EditInformation" bundle:nil] instantiateViewControllerWithIdentifier:@"EditDetailViewController"];
        detail.title = @"QQ号";
        detail.type = Enum_Edit_Type_QQ;
        detail.content = cell.label.text;
        detail.trueStr = self.infoModel.qq;
        detail.trueString = self.infoModel.qq;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
        
    }else if (indexPath.section == 1 && indexPath.row == 1)
    {
        //微信
        
        EditDetailViewController *detail = [[UIStoryboard storyboardWithName:@"EditInformation" bundle:nil] instantiateViewControllerWithIdentifier:@"EditDetailViewController"];
        detail.title = @"微信号";
        detail.type = Enum_Edit_Type_WeChat;
        detail.content = cell.label.text;
        detail.trueStr = self.infoModel.wx;
        detail.trueString = self.infoModel.wx;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
        
    }else if (indexPath.section == 2 && indexPath.row == 0)
    {
        //支付宝
        
        if (self.infoModel.alipay && ![self.infoModel.alipay isEqualToString:@""]) {
            
            AliPayCheckPhoneViewController *check = [[UIStoryboard storyboardWithName:@"SoftwareUserInfo" bundle:nil] instantiateViewControllerWithIdentifier:@"AliPayCheckPhoneViewController"];
            check.content = cell.label.text;
            check.trueStr = self.infoModel.alipay;
            check.trueString = self.infoModel.alipay;
            check.phoneNumber = self.infoModel.mobile;
            check.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:check animated:YES];
        }else
        {
            EditDetailViewController *detail = [[UIStoryboard storyboardWithName:@"EditInformation" bundle:nil] instantiateViewControllerWithIdentifier:@"EditDetailViewController"];
            detail.title = @"支付宝账号";
            detail.type = Enum_Edit_Type_PayAccount;
            detail.content = cell.label.text;
            detail.trueStr = self.infoModel.alipay;
            detail.trueString = self.infoModel.alipay;
            detail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detail animated:YES];
        }
        
    }else if (indexPath.section == 2 && indexPath.row == 1){
            
        //银行卡
        EditDetailViewController *detail = [[UIStoryboard storyboardWithName:@"EditInformation" bundle:nil] instantiateViewControllerWithIdentifier:@"EditDetailViewController"];
        detail.title = @"银行卡号";
        detail.type = Enum_Edit_Type_BankAccount;
        detail.content = cell.label.text;
        detail.trueStr = self.infoModel.bankCard;
        detail.trueString = self.infoModel.bankCard;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
            
    }else if (indexPath.section == 2 && indexPath.row == 2){
                
        //开户行
        EditDetailViewController *detail = [[UIStoryboard storyboardWithName:@"EditInformation" bundle:nil] instantiateViewControllerWithIdentifier:@"EditDetailViewController"];
        detail.title = @"开户行";
        detail.type = Enum_Edit_Type_OpenBank;
        detail.content = cell.label.text;
        detail.trueStr = self.infoModel.bankName;
        detail.trueString = self.infoModel.bankName;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
                
    }else if (indexPath.section == 3 && indexPath.row == 0){
                    
        //身份证号
        EditDetailViewController *detail = [[UIStoryboard storyboardWithName:@"EditInformation" bundle:nil] instantiateViewControllerWithIdentifier:@"EditDetailViewController"];
        detail.title = @"身份证号";
        detail.type = Enum_Edit_Type_IDCard;
        detail.content = cell.label.text;
        detail.trueStr = self.infoModel.ic;
        detail.trueString = self.infoModel.ic;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
                    
    }

}

#pragma mark ---- 添加图片 -----

- (void)addImageAction:(NSInteger)indexPath
{
    
    EditInformationCell *cell = (EditInformationCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath-1000 inSection:2]];
    if (indexPath == 1+1000)
    {
        //点击身份证正面
        
        clickImageSign = @"face";
        if (IsHaveFaceImage)
        {
            //如果有图片，显示大图
            [SJAvatarBrowser showImage:cell.addImage];
        }else
        {
            //如果没有，则上传图片
            if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
                [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试!" duration:DURATION_SHORT];
                return;
            }else
            {
                uploadImageSign = @"IdCard";
                [self setUpActionSheet];
            }
        }
        
    }else if (indexPath == 2+1000)
    {
        //点击身份证背面
        
        clickImageSign = @"rear";
        if (IsHaveRearImage)
        {
            //如果有图片，显示大图
            [SJAvatarBrowser showImage:cell.addImage];
        }else
        {
            //如果没有，则上传图片
            if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
                [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试!" duration:DURATION_SHORT];
                return;
            }else
            {
                uploadImageSign = @"IdCard";
                [self setUpActionSheet];
            }

        }
    }
}

#pragma mark ---- 弹出ActionSheet选择框 ----
- (void)setUpActionSheet
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照设置图片", @"从相册选择图片", nil];
    [actionSheet showInView:self.view];
}

#pragma mark ---- 删除图片 -----

- (void)deleteImageAction:(NSInteger)indexPath
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable)
    {
        [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试!" duration:DURATION_SHORT];
        return;
    }else
    {
        if (indexPath == 1+10000)
        {
            //正面
            if (IsHaveFaceImage) {
                deleteImageSign = @"face";
                [self setUpAlertView];
            }
        }else if (indexPath == 2+10000)
        {
            //背面
            if (IsHaveRearImage) {
                deleteImageSign = @"rear";
                [self setUpAlertView];
            }
        }
    }
}

#pragma mark ---- 弹出删除图片的alert ----

- (void)setUpAlertView
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除图片吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

#pragma mark -------提示框代理--------

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        //删除身份证图片
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
        if ([deleteImageSign isEqualToString:@"face"]){//删除身份证正面图片
            param[@"icImgF"] = EMPTYURL;
        }else if ([deleteImageSign isEqualToString:@"rear"]){//删除身份证背面图片
            param[@"icImgB"] = EMPTYURL;
        }
        [Employee employeeUpdateEmployeeWithParam:param success:^(id responseObj) {
            
            if ([responseObj[@"apiStatus"] integerValue] == 0)
            {
                [SVProgressHUD showSuccessWithStatus:kWarning215N36 duration:0.8];
                [self queryMyInfo];
                [self.tableView reloadData];
            }else
            {
                [SVProgressHUD showErrorWithStatus:responseObj[@"apiMessage"] duration:0.8];
            }
        } failure:^(HttpException *e) {
            
        }];
    }
}

#pragma mark ---- UIActionSheetDelegate ----

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerControllerSourceType sourceType;
    if (buttonIndex == 0)
    {
        //拍照
        
        if ([uploadImageSign isEqualToString:@"headerIcon"])
        {
            //头像调系统相机
            sourceType = UIImagePickerControllerSourceTypeCamera;
            if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"Sorry,您的设备不支持该功能!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                return;
            }
            
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = NO;
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:nil];
            
        }else if ([uploadImageSign isEqualToString:@"IdCard"])
        {
            //身份证调自定义相机
            UINavigationController *nav= [[UIStoryboard storyboardWithName:@"CustomIdPhoto" bundle:nil]  instantiateInitialViewController];
            CustomIdPhotoViewController *vc = nav.viewControllers[0];
            vc.CustomIdPhotoViewControllerDelegate = self;
            [self presentViewController:nav animated:YES completion:^{
            }];
        }
        
    }else if (buttonIndex == 1)
    {
        //相册
        
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"Sorry,您的设备不支持该功能!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else if (buttonIndex == 2)
    {
        //取消
        return;
    }
    
}

#pragma mark ---- 通过自定义相机获取图片 ----

-(void)idCardPhotoResult:(UIImage *)result
{
    UIImage *image = result;
    [self dealWithImage:image];
}

#pragma mark ---- 通过系统相机相册获取图片 ----

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dealWithImage:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ---- 处理图片 ----

- (void)dealWithImage:(UIImage *)result
{
    /**
     *1.通过相册和相机获取的图片都在此代理中
     *
     *2.图片选择已完成,在此处选择传送至服务器
     */
    
    UIImage *image = result;
    
    if (image) {
        //传到服务器
        image = [image imageByScalingToMinSize];
        NSData * imageData = UIImageJPEGRepresentation(image, 0.5);
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"type"] = @(4);
        setting[@"token"] = @"";
        
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:imageData];
        
        [[HttpClient sharedInstance] uploaderImg:array params:setting withUrl:NW_uploadFile success:^(id responseObj) {
            
            if ([responseObj[@"apiStatus"] intValue] == 0)
            {
                NSString *imageFaceUrl =  responseObj[@"body"][@"url"];
                
                if ([uploadImageSign isEqualToString:@"headerIcon"])
                {
                    //上传头像
                    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
                    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
                    setting[@"headImg"] = StrFromObj(imageFaceUrl);
                    [Employee employeeUpdateEmployeeWithParam:setting success:^(id responseObj) {
                        
                        if ([responseObj[@"apiStatus"] integerValue] == 0) {
                            
                            [self.headerIcon setImageWithURL:[NSURL URLWithString:imageFaceUrl] placeholderImage:[UIImage imageNamed:@"expert_ic_people"]];
                            [SVProgressHUD showSuccessWithStatus:kWarning215N31 duration:0.8];
                            
                        }else
                        {
                            [SVProgressHUD showErrorWithStatus:responseObj[@"apiMessage"] duration:0.8];
                        }
                        
                    } failure:^(HttpException *e) {
                        
                    }];
 
                }else if ([uploadImageSign isEqualToString:@"IdCard"])
                {
                    //上传身份证
                    NSMutableDictionary *param = [NSMutableDictionary dictionary];
                    param[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
                    if ([clickImageSign isEqualToString:@"face"]) {
                        //身份证正面
                        param[@"icImgF"] = imageFaceUrl;
                    }else if ([clickImageSign isEqualToString:@"rear"]){
                        //身份证背面
                        param[@"icImgB"] = imageFaceUrl;
                    }
                    
                    [Employee employeeUpdateEmployeeWithParam:param success:^(id responseObj) {
                        
                        if ([responseObj[@"apiStatus"] integerValue] == 0) {
                            [SVProgressHUD showSuccessWithStatus:kWarning215N35 duration:0.8];
                            [self queryMyInfo];
                            [self.tableView reloadData];
                        }else{
                            [SVProgressHUD showErrorWithStatus:responseObj[@"apiMessage"] duration:0.8];
                        }
                    } failure:^(HttpException *e) {
                        
                    }];
                }
                
            }else
            {
                [SVProgressHUD showErrorWithStatus:responseObj[@"apiMessage"] duration:0.8f];
            }
            
        } failure:^(HttpException *e) {
            
        } uploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            
        }];
    }
}

#pragma mark ---- 支付宝账号做隐藏处理 ----

- (NSString *)makePayAccountHide:(NSString *)string
{
    if (string == nil || [string isEqualToString:@""])
    {
        return @"";
    }else
    {
        if ([QWGLOBALMANAGER isPhoneNumber:string]) {
            
            NSString *tempStr = [NSString stringWithFormat:@"%@****%@",[string substringToIndex:3],[string substringFromIndex:7]];
            return tempStr;
            
        }else
        {
            if ([string rangeOfString:@"@"].location != NSNotFound) {
                NSRange range =  [string rangeOfString:@"@"];
                NSString *leftStr = [string substringToIndex:range.location];
                NSString *rightStr = [string substringFromIndex:range.location];
                
                if (leftStr.length == 1)
                {
                    NSString *tempStr = [NSString stringWithFormat:@"*%@",rightStr];
                    return tempStr;
                    
                }else if (leftStr.length == 2)
                {
                    NSString *tempStr = [NSString stringWithFormat:@"%@*%@",[string substringToIndex:1],rightStr];
                    return tempStr;
                    
                }else if (leftStr.length == 3)
                {
                    NSString *tempStr = [NSString stringWithFormat:@"%@*%@",[string substringToIndex:2],rightStr];
                    return tempStr;
                    
                }else
                {
                    NSString *subStr = [string substringFromIndex:range.location - 1];
                    NSString *tempStr = [NSString stringWithFormat:@"%@****%@",[string substringToIndex:2],subStr];
                    return tempStr;
                }

            }else
            {
                return nil;
            }
        }
    }
}

#pragma mark ---- 银行卡号做隐藏处理 ----

- (NSString *)makeBankAccountHide:(NSString *)string
{
    if (string == nil || [string isEqualToString:@""]) {
        return @"";
    }else
    {
        int ll = string.length -  4;
        NSString *temp = [NSString stringWithFormat:@"***************%@",[string substringFromIndex:ll]];
        return temp;
    }
}

#pragma mark ---- 身份证隐藏处理 ----

- (NSString *)makeIDCardHide:(NSString *)string
{
    if (string == nil || [string isEqualToString:@""]) {
        return @"";
    }else
    {
        NSString *temp = [NSString stringWithFormat:@"%@****%@",[string substringToIndex:10],[string substringFromIndex:14]];
        return temp;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
