//
//  SoftwareUserInfoViewController.m
//  wenYao-store
//
//  Created by YYX on 15/7/6.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "SoftwareUserInfoViewController.h"
#import "SoftwareUserInfoCell.h"
#import "SoftwareDetailViewController.h"
#import "SVProgressHUD.h"
#import "SJAvatarBrowser.h"
#import "EmployeeModel.h"
#import "Employee.h"
#import "JGUserViewController.h"
#import "AliPayCheckPhoneViewController.h"
#import "Branch.h"
#import "BranchModel.h"
#import "Store.h"
#import "CustomIdPhotoViewController.h"
#import "UIImage+Ex.h"

#define  EMPTYURL  @"QW_#_EMPTY"

@interface SoftwareUserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SoftwareUserInfoCellDelegate,CustomIdPhotoViewControllerDelegate>

{
    BOOL IsHaveFaceImage;           //是否有身份证正面图片
    BOOL IsHaveRearImage;           //是否有身份证背面图片
    NSString *clickImageSign;       //添加图片标志
    NSString *deleteImageSign;      //删除图片标志
}
@property (nonatomic ,strong) JGUserModel *userModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataList;
@property (strong, nonatomic) EmployeeInfoModel *infoModel;

@end

@implementation SoftwareUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"软件使用人信息";
    self.dataList = @[@[@"软件使用人",@"支付宝账号",@"银行卡号",@"开户行"],@[@"身份证号",@"身份证正面",@"身份证背面"]];
    self.userModel = [[JGUserModel alloc] init];
    self.view.backgroundColor = RGBHex(qwColor11);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    IsHaveFaceImage = NO;
    IsHaveRearImage = NO;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        
        [SVProgressHUD showErrorWithStatus:kWaring12 duration:0.8];
        [self showInfoView:kWaring12 image:@"img_network"];
        return;
        
    }
    
    [self removeInfoView];
    [self queryMyInfo];
    [self loadUserInfomation];
}


- (void)viewInfoClickAction:(id)sender
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        
        [SVProgressHUD showErrorWithStatus:kWaring12 duration:0.8];
        [self showInfoView:kWaring12 image:@"img_network"];
        return;
    }
    
    [self removeInfoView];
    [self queryMyInfo];
    [self loadUserInfomation];
    [self.tableView reloadData];
}

#pragma mark ---- 软件使用人的name 和 phone  by ma ----

- (void)loadUserInfomation
{
    if (!QWGLOBALMANAGER.configure.groupId) {
        return;
    }
    [Store GetBranhBranchInfoWithGroupId:QWGLOBALMANAGER.configure.groupId success:^(id responseObj) {
        BranchInfoModel *branchInfo = (BranchInfoModel *)responseObj;
        self.userModel.contactInfo = branchInfo.contactInfo;
        self.userModel.contactStatus = branchInfo.contactStatus;
        [self.tableView reloadData];
    } failure:^(HttpException *e) {
    }];
}

#pragma ---- 获取软件使用人信息 ----

- (void)queryMyInfo
{
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
    
    [Branch getSoftwareuserPhoneNumberWithParams:setting success:^(id obj) {
        
        self.infoModel = (EmployeeInfoModel *)obj;
        
        if ([self.infoModel.apiStatus integerValue] == 0) {
            
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

#pragma mark ---- 列表代理 ----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(NSArray *)self.dataList[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 65;
    }else
    {
        return 43;
    }
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
    SoftwareUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SoftwareUserInfoCell"];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        //姓名
        ContactInfoModel *contactInfoModel = self.userModel.contactInfo;
        BranchItemModel *nameModel = contactInfoModel.contact;
        BranchItemModel *mobileModel = contactInfoModel.mobile;
        
        NSString *name = nil;
        NSString *mobile = nil;
        NSInteger contactStatus = [self.userModel.contactStatus integerValue];
        switch (contactStatus) {
            case 1://审核中
            {
                cell.checkImage.hidden = NO;
                cell.checkLabel.hidden = NO;
                cell.noOKUser.hidden = YES;
                NSInteger nameStatus = [nameModel.status integerValue];
                NSInteger mobileStatus = [mobileModel.status integerValue];
                //status 0 正常  1 待审 2未完善
                //判断各个item是否在审核中
                //名字
                if (nameStatus == 0) {
                    name = nameModel.oldValue;
                }else if (nameStatus == 1){
                    name = nameModel.newValue;
                }
                //手机号
                if (mobileStatus == 0) {
                    mobile = mobileModel.oldValue;
                }else if (mobileStatus == 1){
                    mobile = mobileModel.newValue;
                }
            }
                break;
            case 2://未完善
                cell.checkImage.hidden = YES;
                cell.checkLabel.hidden = YES;
                cell.noOKUser.hidden = NO;
                name = nameModel.oldValue;
                mobile = mobileModel.oldValue;
                break;
            case 0://正常
                //do nothing
                name = nameModel.oldValue;
                mobile = mobileModel.oldValue;
                cell.checkImage.hidden = YES;
                cell.checkLabel.hidden = YES;
                cell.noOKUser.hidden = YES;
                break;
            default:
                break;
        }
        
        cell.softwareUserInfoCellDelegate = self;
        cell.namelabel.text = name;
        cell.phoneLabel.text = mobile;
        cell.label.hidden = YES;
        cell.addImage.hidden = YES;
        cell.deleteImage.hidden = YES;
        
    }else if (indexPath.section == 0 && indexPath.row == 1){
        
        //支付宝账号
        
        cell.softwareUserInfoCellDelegate = self;
        cell.label.text = [self makePayAccountHide:self.infoModel.alipay];
        cell.addImage.hidden = YES;
        cell.deleteImage.hidden = YES;
        cell.checkLabel.hidden = YES;
        cell.checkImage.hidden = YES;
        cell.namelabel.hidden = YES;
        cell.phoneLabel.hidden = YES;
        
    }else if (indexPath.section == 0 && indexPath.row == 2){
        
        //银行卡号
        
        cell.softwareUserInfoCellDelegate = self;
        cell.label.text = [self makeBankAccountHide:self.infoModel.bankCard];
        cell.addImage.hidden = YES;
        cell.deleteImage.hidden = YES;
        cell.checkLabel.hidden = YES;
        cell.checkImage.hidden = YES;
        cell.namelabel.hidden = YES;
        cell.phoneLabel.hidden = YES;
        
    }else if (indexPath.section == 0 && indexPath.row == 3){
        
        //开户行
        
        cell.softwareUserInfoCellDelegate = self;
        NSString *str = self.infoModel.bankName;
        if (str == nil || [str isEqualToString:@""]) {
            cell.label.text = @"";
        }else
        {
            cell.label.text = str;
        }
        cell.addImage.hidden = YES;
        cell.deleteImage.hidden = YES;
        cell.checkLabel.hidden = YES;
        cell.checkImage.hidden = YES;
        cell.namelabel.hidden = YES;
        cell.phoneLabel.hidden = YES;
        
    }else if (indexPath.section == 1 && indexPath.row == 0){
        
        //身份证号
        
        cell.softwareUserInfoCellDelegate = self;
        cell.label.text = [self makeIDCardHide:self.infoModel.ic];
        cell.addImage.hidden = YES;
        cell.deleteImage.hidden = YES;
        cell.checkLabel.hidden = YES;
        cell.checkImage.hidden = YES;
        cell.namelabel.hidden = YES;
        cell.phoneLabel.hidden = YES;
        
    }else if (indexPath.section == 1 && indexPath.row == 1){
        
        //身份证正面
        
        cell.pushButton.hidden = YES;
        cell.label.hidden = YES;
        cell.softwareUserInfoCellDelegate = self;
        cell.checkLabel.hidden = YES;
        cell.checkImage.hidden = YES;
        cell.namelabel.hidden = YES;
        cell.phoneLabel.hidden = YES;
        
        if (self.infoModel.icImgF && ![self.infoModel.icImgF isEqualToString:@""]) {
            
            IsHaveFaceImage = YES;
            [cell.addImage setImageWithURL:[NSURL URLWithString:self.infoModel.icImgF]];
            cell.deleteImage.hidden = NO;
            
        }else{
            
            IsHaveFaceImage = NO;
            cell.addImage.image = [UIImage imageNamed:@"添加图片"];
            cell.deleteImage.hidden = YES;
        }
        
    }else if (indexPath.section == 1 && indexPath.row == 2){
        
        //身份证背面
        
        cell.pushButton.hidden = YES;
        cell.label.hidden = YES;
        cell.softwareUserInfoCellDelegate = self;
        cell.checkLabel.hidden = YES;
        cell.checkImage.hidden = YES;
        cell.namelabel.hidden = YES;
        cell.phoneLabel.hidden = YES;
        
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
    SoftwareUserInfoCell *cell = (SoftwareUserInfoCell *)[self.tableView cellForRowAtIndexPath:indexPath                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   ];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        //软件使用人信息 
        
        JGUserViewController * user = [[JGUserViewController alloc] initWithNibName:@"JGUserViewController" bundle:nil];
        user.hidesBottomBarWhenPushed = YES;
        user.userModel = self.userModel;
        [self.navigationController pushViewController:user animated:YES];
        
    }else if (indexPath.section == 0 && indexPath.row == 1)
    {
        //支付宝
        
        if (self.infoModel.alipay && ![self.infoModel.alipay isEqualToString:@""]) {
            
            // 判断手机号的状态
            BranchItemModel *mobileModel = self.userModel.contactInfo.mobile;
            //status;//0 正常  1 待审 2未完善
            NSInteger status = [mobileModel.status integerValue];
            
            if (status == 1) {
                [SVProgressHUD showErrorWithStatus:kWarning215N58 duration:1.0];
                return;
            }else if (status == 2){
                [SVProgressHUD showErrorWithStatus:kWarning215N57 duration:1.0];
                return;
            }
            
            
            AliPayCheckPhoneViewController *check = [[UIStoryboard storyboardWithName:@"SoftwareUserInfo" bundle:nil] instantiateViewControllerWithIdentifier:@"AliPayCheckPhoneViewController"];
            check.content = cell.label.text;
            check.trueStr = self.infoModel.alipay;
            check.trueString = self.infoModel.alipay;
            check.phoneNumber = mobileModel.oldValue;
            check.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:check animated:YES];
        }else
        {
            SoftwareDetailViewController *detail = [[UIStoryboard storyboardWithName:@"SoftwareUserInfo" bundle:nil] instantiateViewControllerWithIdentifier:@"SoftwareDetailViewController"];
            detail.title = @"支付宝账号";
            detail.type = Enum_SoftwareUser_Type_PayAccount;
            detail.content = cell.label.text;
            detail.trueStr = self.infoModel.alipay;
            detail.trueString = self.infoModel.alipay;
            detail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detail animated:YES];
        }
        
    }else if (indexPath.section == 0 && indexPath.row == 2){
        
        //银行卡
        
        SoftwareDetailViewController *detail = [[UIStoryboard storyboardWithName:@"SoftwareUserInfo" bundle:nil] instantiateViewControllerWithIdentifier:@"SoftwareDetailViewController"];
        detail.title = @"银行卡号";
        detail.type = Enum_SoftwareUser_Type_BankAccount;
        detail.content = cell.label.text;
        detail.trueStr = self.infoModel.bankCard;
        detail.trueString = self.infoModel.bankCard;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
        
    }else if (indexPath.section == 0 && indexPath.row == 3){
        
        //开户行
        
       SoftwareDetailViewController *detail = [[UIStoryboard storyboardWithName:@"SoftwareUserInfo" bundle:nil] instantiateViewControllerWithIdentifier:@"SoftwareDetailViewController"];
        detail.title = @"开户行";
        detail.type = Enum_SoftwareUser_Type_OpenBank;
        detail.content = cell.label.text;
        detail.trueStr = self.infoModel.bankName;
        detail.trueString = self.infoModel.bankName;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
        
    }else if (indexPath.section == 1 && indexPath.row == 0){
        
        //身份证号
        
        SoftwareDetailViewController *detail = [[UIStoryboard storyboardWithName:@"SoftwareUserInfo" bundle:nil] instantiateViewControllerWithIdentifier:@"SoftwareDetailViewController"];
        detail.title = @"身份证号";
        detail.type = Enum_SoftwareUser_Type_IDCard;
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
    
    SoftwareUserInfoCell *cell = (SoftwareUserInfoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath-1000 inSection:1]];
    if (indexPath == 1+1000) {
        
        //正面身份证
        
        clickImageSign = @"face";
        if (IsHaveFaceImage) {
            [SJAvatarBrowser showImage:cell.addImage];
        }else{
            
            if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
                [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试!" duration:DURATION_SHORT];
                return;
            }else
            {
                [self setUpActionSheet];
            }
        }
        
    }else if (indexPath == 2+1000){
        
        //背面身份证
        
        clickImageSign = @"rear";
        if (IsHaveRearImage) {
            [SJAvatarBrowser showImage:cell.addImage];
        }else{
            
            if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
                [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试!" duration:DURATION_SHORT];
                return;
            }else
            {
                [self setUpActionSheet];
            }
            
        }
    }
    
    
    
}

//设置头像
- (void)setUpActionSheet
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照设置图片", @"从相册选择图片", nil];
    [actionSheet showInView:self.view];
}

#pragma mark ---- 删除图片 -----

- (void)deleteImageAction:(NSInteger)indexPath
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试!" duration:DURATION_SHORT];
        return;
    }else{
        
        if (indexPath == 1+10000) {
            if (IsHaveFaceImage) {
                deleteImageSign = @"face";
                [self setUpAlertView];
            }
        }else if (indexPath == 2+10000){
            if (IsHaveRearImage) {
                deleteImageSign = @"rear";
                [self setUpAlertView];
            }
        }
    }
}

//设置删除头像view
- (void)setUpAlertView
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除图片吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

#pragma mark
#pragma mark -------提示框代理--------

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        //调接口删除
        if ([deleteImageSign isEqualToString:@"face"]) {
            
            //身份证正面
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
            param[@"icImgF"] = EMPTYURL;
            
            [self deleteICImage:param];
            
        }else if ([deleteImageSign isEqualToString:@"rear"]){
            
            //身份证背面
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
            param[@"icImgB"] = EMPTYURL;
            
            [self deleteICImage:param];
            
        }
    }
}

//从服务器删除图片

- (void)deleteICImage:(NSMutableDictionary *)param
{
    [Branch UpdateSoftwareuserInfoWithParams:param success:^(id obj) {
        
        if ([obj[@"apiStatus"] integerValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:kWarning215N36 duration:0.8];
            [self queryMyInfo];
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"] duration:0.8];
        }
        
    } failure:^(HttpException *e) {
        
    }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerControllerSourceType sourceType;
    if (buttonIndex == 0) {
        //拍照
        
        UINavigationController *nav= [[UIStoryboard storyboardWithName:@"CustomIdPhoto" bundle:nil]  instantiateInitialViewController];
        CustomIdPhotoViewController *vc = nav.viewControllers[0];
        vc.CustomIdPhotoViewControllerDelegate = self;
        [self presentViewController:nav animated:YES completion:^{
        }];
        
    }else if (buttonIndex == 1){
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
    }else if (buttonIndex == 2){
        //取消
        return;
    }
}

#pragma mark ---- 通过相机获取图片 ----

-(void)idCardPhotoResult:(UIImage *)result
{
    UIImage *image = result;
    [self dealWithImage:image];
}

#pragma mark ---- 通过相册获取图片 ----

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dealWithImage:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ---- 处理图片 ----

- (void)dealWithImage:(UIImage *)result
{
    UIImage *image = result;
//    CGRect bounds = CGRectMake(0, 0, APP_W, APP_W);
//    UIGraphicsBeginImageContext(bounds.size);
//    [image drawInRect:bounds];
//    image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
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
            
            if ([responseObj[@"apiStatus"] intValue] == 0) {
                NSString *imageFaceUrl =  responseObj[@"body"][@"url"];
                
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                param[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
                
                if ([clickImageSign isEqualToString:@"face"]) {
                    //身份证正面
                    param[@"icImgF"] = imageFaceUrl;
                }else if ([clickImageSign isEqualToString:@"rear"]){
                    //身份证背面
                    param[@"icImgB"] = imageFaceUrl;
                }
                
                [self addICImageAction:param];
                
            }else{
                [SVProgressHUD showErrorWithStatus:responseObj[@"apiMessage"] duration:0.8f];
            }
            
        } failure:^(HttpException *e) {
            
        } uploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            
        }];
    }

}

// 添加身份证 图片

- (void)addICImageAction:(NSMutableDictionary *)param
{
    [Branch UpdateSoftwareuserInfoWithParams:param success:^(id obj) {
        
        if ([obj[@"apiStatus"] integerValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:kWarning215N35 duration:0.8];
            [self queryMyInfo];
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"] duration:0.8];
        }
        
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ---- 支付宝账号做隐藏处理 ----

- (NSString *)makePayAccountHide:(NSString *)string
{
    if (string == nil || [string isEqualToString:@""])  {
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
    if (string == nil || [string isEqualToString:@""] || string.length!=18) {
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
