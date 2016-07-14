  //
//  UploadLicenseViewController.m
//  wenYao-store
//
//  Created by YYX on 15/8/19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "UploadLicenseViewController.h"
#import "UploadLicenseCell.h"
#import "UIViewController+LJWKeyboardHandlerHelper.h"
#import "QWTextField.h"
#import "MyDatePicker.h"
#import "CheckUploadLicenseViewController.h"
#import "Branch.h"
#import "OrganInfoCompleteViewController.h"
#import "UploadLicenseModelR.h"
#import "CustomIdPhotoViewController.h"
#import "UIImage+Ex.h"

@interface UploadLicenseViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UploadLicenseCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MyDatePickerDelegate,CheckUploadLicenseViewControllerDelegate,CustomIdPhotoViewControllerDelegate>

{
    int uploadImageType;  // 1 身份证  2 营业执照 3 药品经营许可证
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *footerView;

// 提交按钮
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

// section 名称数组
@property (strong, nonatomic) NSMutableArray *sectionList;

@property (strong, nonatomic) NSMutableArray *titleList;

// 上传图片的提示语 数组
@property (strong, nonatomic) NSMutableArray *imageTipsList;

@property (strong, nonatomic) NSMutableArray *placeHolderList;

// 输入内容的数组
@property (strong, nonatomic) NSMutableArray *textFieldList;

// 图片 url 的数组
@property (strong, nonatomic) NSMutableArray *imageUrlList;

// 日期的数组
@property (strong, nonatomic) NSMutableArray *dateList;

// 保存基本信息时，返回的 id
@property (strong, nonatomic) NSString *approveId;

- (IBAction)commitAction:(id)sender;

@end

@implementation UploadLicenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"上传证照";
    
    if (self.organType == 2)
    {
        // 单体药房
        
        self.sectionList = [NSMutableArray arrayWithObjects:@"法人/企业负责人信息",@"营业执照信息",@"药品经营许可证信息", nil];
        self.titleList = [NSMutableArray arrayWithObjects:@[@"法人/企业负责人姓名",@"身份证号",@"身份证照片"],@[@"营业执照注册号",@"营业执照"],@[@"药品经营许可证号",@"有效期至",@"药品经营许可证照"], nil];
        self.imageTipsList = [NSMutableArray arrayWithObjects:@[@"",@"",@"上传您的身份证正面照"],@[@"",@"上传您的营业执照"],@[@"",@"",@"上传您的药品经营许可证照"], nil];
        self.placeHolderList = [NSMutableArray arrayWithObjects:@[@"请输入姓名",@"请输入身份证号",@""],@[@"请输入注册号",@""],@[@"请输入许可证号",@"",@""], nil];
        
    }else if (self.organType == 3)
    {
        // 医疗机构
        
        self.sectionList = [NSMutableArray arrayWithObjects:@"法人信息",@"营业执照信息",@"医疗机构执业许可证信息", nil];
        self.titleList = [NSMutableArray arrayWithObjects:@[@"法人/企业负责人姓名",@"身份证号",@"身份证照片"],@[@"营业执照注册号",@"营业执照"],@[@"医疗机构执业许可证号",@"有效期至",@"医疗机构许可证照"], nil];
        self.imageTipsList = [NSMutableArray arrayWithObjects:@[@"",@"",@"上传您的身份证正面照"],@[@"",@"上传您的营业执照"],@[@"",@"",@"上传您的医疗机构执业许可证照"], nil];
        self.placeHolderList = [NSMutableArray arrayWithObjects:@[@"请输入姓名",@"请输入身份证号",@""],@[@"请输入注册号",@""],@[@"请输入许可证号",@"",@""], nil];
    }
    
    [self.tableView reloadData];
    self.tableView.tableFooterView = self.footerView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.commitButton.layer.cornerRadius = 3.0;
    self.commitButton.layer.masksToBounds = YES;
    
    [self configureCommitButtonGray];
    
    // 键盘自适应
    [self registerLJWKeyboardHandler];
    
    [self loadCahce];
}

#pragma mark ---- 左侧返回按钮 ----

- (void)popVCAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---- 提交按钮高亮 ----

- (void)configureCommitButtonGray
{
    self.commitButton.enabled = NO;
    [self.commitButton setBackgroundColor:RGBHex(qwColor11)];
    [self.commitButton setBackgroundImage:nil forState:UIControlStateNormal];
}

#pragma mark ---- 提交按钮置灰 ----

- (void)ConfigureCommitButtonBlue
{
    self.commitButton.enabled = YES;
    [self.commitButton setBackgroundImage:[UIImage imageNamed:@"login_green_bg"] forState:UIControlStateNormal];
    [self.commitButton setBackgroundImage:[UIImage imageNamed:@"login_green_bg_click"] forState:UIControlStateHighlighted];
    [self.commitButton setBackgroundImage:[UIImage imageNamed:@"login_green_bg_click"] forState:UIControlStateSelected];
}

#pragma mark ---- 加载缓存 ----

- (void)loadCahce
{
    /*
     缓存方式：有缓存取缓存，无缓存取网络数据，网络数据是在上个界面获取的 licenseArray 
             法人企业负责人信息，营业执照信息不分type，药品经营许可证，医疗机构执业许可证按type存取
     */
    
    // 法人企业/负责人信息  营业执照信息
    UploadLicenseModelR *uploadModelR = [QWUserDefault getObjectBy:[NSString stringWithFormat:@"uploadLicense+%@",QWGLOBALMANAGER.configure.passportId]];
    
    // 药品经营许可证  医疗机构执业许可证
    ShitModel *shitModel = [QWUserDefault getObjectBy:[NSString stringWithFormat:@"shit+%@+%d",QWGLOBALMANAGER.configure.passportId,self.organType]];
    
    if (uploadModelR) {
        
        // 有缓存的时候
        [self configureArray:uploadModelR shit:shitModel];
        
    }
    else{
        if (self.licenseArray.count == 3) {
            
            // 网络有数据的时候
            UploadLicenseModelR *model = [UploadLicenseModelR new];
            ShitModel *shit = [ShitModel new];
            
            for (NSDictionary *dic in self.licenseArray) {
                
                if ([dic[@"type"] integerValue] == 8)
                {
                    //法人身份证
                    model.personName = dic[@"lawPerson"];
                    model.idNum = dic[@"no"];
                    model.IDUrl = StrFromObj(dic[@"url"]);
                }else if ([dic[@"type"] integerValue] == 1)
                {
                    // 营业执照
                    model.registerNum = StrFromObj(dic[@"no"]);
                    model.registerUrl = StrFromObj(dic[@"url"]);
                    
                }else if ([dic[@"type"] integerValue] == 3 || [dic[@"type"] integerValue] == 10)
                {
                    // 药品经营许可证
                    
                    if ([self.shitType integerValue] == self.organType) {
                        shit.medicineNum = StrFromObj(dic[@"no"]);
                        shit.medcineUrl = StrFromObj(dic[@"url"]);
                        shit.date = StrFromObj(dic[@"end"]);
                        shit.type = [NSString stringWithFormat:@"%d",self.organType];
                    }else{
                        
                    }
                }
            }
            
            
            [self configureArray:model shit:shit];
            
            // 缓存数据
            [QWUserDefault setObject:model key:[NSString stringWithFormat:@"uploadLicense+%@",QWGLOBALMANAGER.configure.passportId]];
            [QWUserDefault setObject:shit key:[NSString stringWithFormat:@"shit+%@+%d",QWGLOBALMANAGER.configure.passportId,self.organType]];
            
        }else
        {
            // 什么都没有的时候
            [self configureArray:nil shit:nil];
        }
    }

}

#pragma mark ---- 初始化数据 ----

- (void)configureArray:(UploadLicenseModelR *)uploadModel shit:(ShitModel *)shit
{
    
    // 法人/企业负责人姓名
    NSString *personNameStr;
    if (uploadModel.personName && ![uploadModel.personName isEqualToString:@""]) {
        personNameStr = uploadModel.personName;
    }else{
        personNameStr = @"";
    }
    
    // 身份证号
    NSString *idNumStr;
    if (uploadModel.idNum && ![uploadModel.idNum isEqualToString:@""]) {
        idNumStr = uploadModel.idNum;
    }else{
        idNumStr = @"";
    }
    
    // 营业执照注册号
    NSString *registerNumStr;
    if (uploadModel.registerNum && ![uploadModel.registerNum isEqualToString:@""]) {
        registerNumStr = uploadModel.registerNum;
    }else{
        registerNumStr = @"";
    }
    
    // 药品经营许可证号
    NSString *medicineNumStr;
    if (shit.medicineNum && ![shit.medicineNum isEqualToString:@""]) {
        medicineNumStr = shit.medicineNum;
    }else{
        medicineNumStr = @"";
    }
    
    // 身份证照
    NSString *IDUrlStr;
    if (uploadModel.IDUrl && ![uploadModel.IDUrl isEqualToString:@""]) {
        IDUrlStr = uploadModel.IDUrl;
    }else{
        IDUrlStr = @"";
    }
    
    // 营业执照
    NSString *registerUrlStr;
    if (uploadModel.registerUrl && ![uploadModel.registerUrl isEqualToString:@""]) {
        registerUrlStr = uploadModel.registerUrl;
    }else{
        registerUrlStr = @"";
    }
    
    // 药品经营许可证照
    NSString *medcineUrlStr;
    if (shit.medcineUrl && ![shit.medcineUrl isEqualToString:@""]) {
        medcineUrlStr = shit.medcineUrl;
    }else{
        medcineUrlStr = @"";
    }
    
    if (personNameStr.length>0 && idNumStr.length>0 && registerNumStr.length>0 && medicineNumStr.length>0 && IDUrlStr.length>0 && registerUrlStr.length>0 && medcineUrlStr.length>0) {
        [self ConfigureCommitButtonBlue];
    }
    
    NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:personNameStr,idNumStr,@"", nil];
    NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:registerNumStr,@"", nil];
    NSMutableArray *arr3 = [NSMutableArray arrayWithObjects:medicineNumStr,@"",@"", nil];
    self.textFieldList = [NSMutableArray arrayWithObjects:arr1,arr2,arr3, nil];
    
    NSMutableArray *a1 = [NSMutableArray arrayWithObjects:@"",@"",IDUrlStr, nil];
    NSMutableArray *a2 = [NSMutableArray arrayWithObjects:@"",registerUrlStr, nil];
    NSMutableArray *a3 = [NSMutableArray arrayWithObjects:@"",@"",medcineUrlStr, nil];
    self.imageUrlList = [NSMutableArray arrayWithObjects:a1,a2,a3, nil];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate date];
    
    NSString *dateStr;
    if (shit.date && ![shit.date isEqualToString:@""]) {
        dateStr = shit.date;
    }else{
        dateStr = [formatter stringFromDate:date];
    }
    
    NSMutableArray *aa1 = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    NSMutableArray *aa2 = [NSMutableArray arrayWithObjects:@"",@"", nil];
    NSMutableArray *aa3 = [NSMutableArray arrayWithObjects:@"",dateStr,@"", nil];
    self.dateList = [NSMutableArray arrayWithObjects:aa1,aa2,aa3, nil];
    
    [self.tableView reloadData];

}

#pragma mark ---- 监听文本变化 ----

- (void)textFieldDidChange:(UITextField *)textField
{
    QWTextField *textView = (QWTextField *)textField;
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
    QWTextField *textView = (QWTextField *)textField;
    NSIndexPath *indexPath = textView.obj;
    NSString *toBeString = textView.text;
    
    int maxNUm;
    if (indexPath.section == 0 && indexPath.row == 0){//法人/企业负责人姓名
        maxNUm = 10;
    }else if (indexPath.section == 0 && indexPath.row == 1){//身份证
        maxNUm = 18;
    }else if (indexPath.section == 1 && indexPath.row == 0){// 营业执照注册号
        maxNUm = 32;
    }else if (indexPath.section == 2 && indexPath.row == 0){// 药品经营许可证
        maxNUm = 32;
    }

    if (toBeString.length > maxNUm) {
        textView.text = [toBeString substringToIndex:maxNUm];
    }
    
    NSMutableArray *arr = self.textFieldList[indexPath.section];
    [arr replaceObjectAtIndex:indexPath.row withObject:textView.text];
    [self.textFieldList replaceObjectAtIndex:indexPath.section withObject:arr];
    [self judgeCommitButtonEnable];
    
}

#pragma mark ---- 判断提交按钮 是否高亮  ----

- (void)judgeCommitButtonEnable
{
    NSString *date = self.dateList[2][1];                       // 有效期
    NSString *personName = self.textFieldList[0][0];            // 法人/企业负责人姓名
    NSString *idNum = self.textFieldList[0][1];                 // 身份证号
    NSString *registerNum = self.textFieldList[1][0];           // 营业执照注册号
    NSString *medicineNum = self.textFieldList[2][0];           // 药品经营许可证
    NSString *IDUrl = self.imageUrlList[0][2];                  // 身份证图片
    NSString *registerUrl = self.imageUrlList[1][1];            // 营业执照图片
    NSString *medcineUrl = self.imageUrlList[2][2];             // 药品经营许可证图片
    
    if ([QWGLOBALMANAGER removeSpace:date].length>0 && [QWGLOBALMANAGER removeSpace:personName].length>0 && [QWGLOBALMANAGER removeSpace:idNum].length>0 && [QWGLOBALMANAGER removeSpace:registerNum].length>0 && [QWGLOBALMANAGER removeSpace:medicineNum].length>0 && [QWGLOBALMANAGER removeSpace:IDUrl].length>0 && [QWGLOBALMANAGER removeSpace:registerUrl].length>0 && [QWGLOBALMANAGER removeSpace:medcineUrl].length>0) {
        [self ConfigureCommitButtonBlue];   // 高亮
    }else{
        [self configureCommitButtonGray];   // 置灰
    }
}

#pragma mark ---- 列表代理 ----

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 38;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 38)];
    vi.backgroundColor = RGBHex(qwColor11);
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, 200, 14)];
    lab.text = self.sectionList[section];
    lab.font = [UIFont systemFontOfSize:13];
    lab.textColor = RGBHex(0x999999);
    [vi addSubview:lab];
    return vi;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = self.titleList[section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = self.titleList[indexPath.section];
    if (indexPath.row == arr.count-1) {
        return 187;
    }else{
        return 46;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UploadLicenseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UploadLicenseCell"];
    
    cell.titleLabel.text = self.titleList[indexPath.section][indexPath.row];
    cell.inputTextField.placeholder = self.placeHolderList[indexPath.section][indexPath.row];
    cell.inputTextField.text = self.textFieldList[indexPath.section][indexPath.row];
    
    cell.inputTextField.obj = indexPath;
    cell.inputTextField.delegate = self;
    [cell.inputTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [cell.inputTextField setValue:RGBHex(0xaaaaaa) forKeyPath:@"_placeholderLabel.textColor"];
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        cell.bgView.hidden = NO;
        cell.inputTextField.hidden = YES;
    }else if (indexPath.section == 1 && indexPath.row == 1){
        cell.bgView.hidden = NO;
        cell.inputTextField.hidden = YES;
    }else if (indexPath.section == 2 && indexPath.row == 2){
        cell.bgView.hidden = NO;
        cell.inputTextField.hidden = YES;
    }else{
        cell.bgView.hidden = YES;
        cell.inputTextField.hidden = NO;
    }
    
    NSString *url = self.imageUrlList[indexPath.section][indexPath.row];
    if (url && ![url isEqualToString:@""]) {
        cell.noImageView.hidden = YES;
        cell.uploadImage.hidden = NO;
        [cell.uploadImage setImageWithURL:[NSURL URLWithString:self.imageUrlList[indexPath.section][indexPath.row]] placeholderImage:nil];
    }else{
        cell.uploadImage.hidden = YES;
        cell.noImageView.hidden = NO;
        cell.noImageView.image = [UIImage imageNamed:@"img_uploadPictures"];
    }
    
    cell.tipsOne.text = self.imageTipsList[indexPath.section][indexPath.row];
    cell.bgView.obj = indexPath;
    cell.uploadLicenseCellDelegate = self;
    
    cell.dateButton.obj = indexPath;
    [cell.dateButton setTitle:self.dateList[indexPath.section][indexPath.row] forState:UIControlStateNormal];
    
    // 有效期
    if (indexPath.section == 2 && indexPath.row == 1) {
        cell.inputTextField.hidden = YES;
    }
    if (indexPath.section == 2 && indexPath.row == 1) {
        cell.dateButton.hidden = NO;
        cell.rightArrowImage.hidden = NO;
    }else{
        cell.dateButton.hidden = YES;
        cell.rightArrowImage.hidden = YES;
    }
    
    // 改变身份证距离左侧约束
    if (indexPath.section == 0 && indexPath.row == 1) {
        cell.textFieldLeftConstraint.constant = 100;
    }else{
        cell.textFieldLeftConstraint.constant = 161;
    }
    
    return cell;
}

#pragma mark ---- 选择日期代理 ----

- (void)getDateActionWithIndexPath:(NSIndexPath *)indexPath;
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str = self.dateList[indexPath.section][indexPath.row];
    NSDate *date = [formatter dateFromString:str];
    
    MyDatePicker *datePicker = [[MyDatePicker alloc] initWithDate:date IndexPath:indexPath];
    datePicker.delegate = self;
    [datePicker show];
}

#pragma mark ---- 日期控件代理 ----

- (void)makeSureDateActionWithDate:(NSDate *)date indexPath:(NSIndexPath *)indexPath;
{
    [date compare:date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSMutableArray *arr = self.dateList[2];
    [arr replaceObjectAtIndex:1 withObject:[formatter stringFromDate:date]];
    [self.dateList replaceObjectAtIndex:2 withObject:arr];
    
    [self judgeCommitButtonEnable];
    [self.tableView reloadData];
}


#pragma mark ---- UITextField Delegate ----

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    QWTextField *textView = (QWTextField *)textField;
    NSIndexPath *indexPath = textView.obj;
    
    if (textView.text.length == 0) {
        textView.text = @"";
    }
    NSMutableArray *arr = self.textFieldList[indexPath.section];
    [arr replaceObjectAtIndex:indexPath.row withObject:textView.text];
    [self.textFieldList replaceObjectAtIndex:indexPath.section withObject:arr];
    
    [self judgeCommitButtonEnable];
    [self.tableView reloadData];
}

#pragma mark ---- 选择图片代理 ----

- (void)clickImageActionWithIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    NSString *imgUrl = self.imageUrlList[indexPath.section][indexPath.row];
    if (imgUrl && ![imgUrl isEqualToString:@""]) {
        
        // 跳转下一页
        
        CheckUploadLicenseViewController *vc = [[UIStoryboard storyboardWithName:@"OrganAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"CheckUploadLicenseViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.imageUrl = imgUrl;
        vc.indexPath = indexPath;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        // 上传照片
        
        if (indexPath.section == 0 && indexPath.row == 2) {
            
            uploadImageType = 1;
        }else if (indexPath.section == 1 && indexPath.row == 1){
            
            uploadImageType = 2;
        }else if (indexPath.section == 2 && indexPath.row == 2){
            
            uploadImageType = 3;
        }
        
        
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试!" duration:DURATION_SHORT];
            return;
        }else
        {
            UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照设置图片", @"从相册选择图片", nil];
            [actionSheet showInView:self.view];
        }
    }
}

#pragma mark ---- 删除图片代理 ----

- (void)deleteImageActionWithIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 2) {
        
        // 身份证照片
        NSMutableArray *arr = self.imageUrlList[0];
        [arr replaceObjectAtIndex:2 withObject:@""];
        [self.imageUrlList replaceObjectAtIndex:0 withObject:arr];
        
    }else if (indexPath.section == 1 && indexPath.row == 1){
        
        // 营业执照
        NSMutableArray *arr = self.imageUrlList[1];
        [arr replaceObjectAtIndex:1 withObject:@""];
        [self.imageUrlList replaceObjectAtIndex:1 withObject:arr];
        
    }else if (indexPath.section == 2 && indexPath.row == 2){
        
        // 药品经营许可证
        NSMutableArray *arr = self.imageUrlList[2];
        [arr replaceObjectAtIndex:2 withObject:@""];
        [self.imageUrlList replaceObjectAtIndex:2 withObject:arr];
    }
    
    [self judgeCommitButtonEnable];
    [self.tableView reloadData];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerControllerSourceType sourceType;
    if (buttonIndex == 0) {
        //拍照
        
        if (uploadImageType == 1)
        {
            // 身份证 自定义相机
            UINavigationController *nav= [[UIStoryboard storyboardWithName:@"CustomIdPhoto" bundle:nil]  instantiateInitialViewController];
            CustomIdPhotoViewController *vc = nav.viewControllers[0];
            vc.CustomIdPhotoViewControllerDelegate = self;
            [self presentViewController:nav animated:YES completion:^{
            }];
            
        }else
        {
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
        }
        
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

#pragma mark --------相册相机图片回调--------

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
                NSString *imageUrl =  responseObj[@"body"][@"url"];
                
                if (uploadImageType == 1)
                {
                    //身份证正面
                    
                    NSMutableArray *arr = self.imageUrlList[0];
                    [arr replaceObjectAtIndex:2 withObject:imageUrl];
                    [self.imageUrlList replaceObjectAtIndex:0 withObject:arr];
                    
                }else if (uploadImageType == 2)
                {
                    //营业执照
                    
                    NSMutableArray *arr = self.imageUrlList[1];
                    [arr replaceObjectAtIndex:1 withObject:imageUrl];
                    [self.imageUrlList replaceObjectAtIndex:1 withObject:arr];
                    
                }else if (uploadImageType == 3)
                {
                    // 药品经营许可证照
                    
                    NSMutableArray *arr = self.imageUrlList[2];
                    [arr replaceObjectAtIndex:2 withObject:imageUrl];
                    [self.imageUrlList replaceObjectAtIndex:2 withObject:arr];
                    
                }
                
                [self judgeCommitButtonEnable];
                [self.tableView reloadData];
                
            }else{
                [SVProgressHUD showErrorWithStatus:responseObj[@"apiMessage"] duration:0.8f];
            }
            
        } failure:^(HttpException *e) {
            
        } uploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            
        }];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//比较两个日期大小
-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}

#pragma mark ---- 提交 ----

- (IBAction)commitAction:(id)sender
{
    // 缓存正常数据
    UploadLicenseModelR *uploadModel = [UploadLicenseModelR new];
    uploadModel.personName = self.textFieldList[0][0];    // 法人/企业负责人姓名
    uploadModel.idNum = self.textFieldList[0][1];         // 身份证号
    uploadModel.registerNum = self.textFieldList[1][0];   // 营业执照注册号
    uploadModel.IDUrl = self.imageUrlList[0][2];          // 身份证图片
    uploadModel.registerUrl = self.imageUrlList[1][1];    // 营业执照图片
    [QWUserDefault setObject:uploadModel key:[NSString stringWithFormat:@"uploadLicense+%@",QWGLOBALMANAGER.configure.passportId]];
    
    // 缓存变态数据
    ShitModel *shitModel = [ShitModel new];
    shitModel.date = self.dateList[2][1];               // 有效期
    shitModel.medicineNum = self.textFieldList[2][0];   // 药品经营许可证
    shitModel.medcineUrl = self.imageUrlList[2][2];     // 药品经营许可证图片
    shitModel.type = [NSString stringWithFormat:@"%d",self.organType];
    [QWUserDefault setObject:shitModel key:[NSString stringWithFormat:@"shit+%@+%d",QWGLOBALMANAGER.configure.passportId,self.organType]];
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:@"网络未连接，请稍后重试！" duration:0.8];
        return;
    }
    
    if (![QWGlobalManager checkIDCard:uploadModel.idNum ]) {
        [SVProgressHUD showErrorWithStatus:Kwarning220N79 duration:0.8];
        return;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *datee = [NSDate date];
    NSString *today = [formatter stringFromDate:datee];

    int i = [self compareDate:today withDate:shitModel.date];
    if (i != 1) {
        [SVProgressHUD showErrorWithStatus:Kwarning220N80 duration:0.8];
        return;
    }
    
    // 上传基本信息
    
    [Branch BranchApproveInfoSubmitWithParams:self.paramDic success:^(id obj) {
        
        if ([obj[@"apiStatus"] integerValue] == 0) {
            self.approveId = obj[@"approveId"];
            
            // 批量上传证照
            
            NSMutableDictionary *setting = [NSMutableDictionary dictionary];
            setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
            setting[@"approveId"] = StrFromObj(self.approveId);
            if (self.organType == 2) {
                //单体药房
                setting[@"type"] = [NSString stringWithFormat:@"8%@1%@3",SeparateStr,SeparateStr];
            }else if (self.organType == 3){
                //医疗机构
                setting[@"type"] = [NSString stringWithFormat:@"8%@1%@10",SeparateStr,SeparateStr];
            }
            
            setting[@"url"] = [NSString stringWithFormat:@"%@%@%@%@%@",uploadModel.IDUrl,SeparateStr,uploadModel.registerUrl,SeparateStr,shitModel.medcineUrl];
            setting[@"no"] = [NSString stringWithFormat:@"%@%@%@%@%@",uploadModel.idNum,SeparateStr,uploadModel.registerNum,SeparateStr,shitModel.medicineNum];;
            setting[@"end"] = [NSString stringWithFormat:@"%@%@%@%@%@",@" ",SeparateStr,@" ",SeparateStr,shitModel.date];
            setting[@"lawPerson"] = StrFromObj(uploadModel.personName);
            
            [Branch BranchApproveLicenseSubmitWithParams:setting success:^(id obj) {
                
                if ([obj[@"apiStatus"] integerValue] == 0) {
                    
                    QWGLOBALMANAGER.configure.approveStatus = @"1";
                    [QWGLOBALMANAGER saveAppConfigure];
                    
                    OrganInfoCompleteViewController *vc = [[UIStoryboard storyboardWithName:@"OrganAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"OrganInfoCompleteViewController"];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }else{
                    [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"] duration:0.8];
                }
                
            } failure:^(HttpException *e) {
                
            }];
            
        }else{
            [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"] duration:0.8];
        }
        
    } failure:^(HttpException *e) {
        
    }];
    
}

@end
