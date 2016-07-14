//
//  BusinessLicenseViewController.m
//  wenyao-store
//
//  Created by Meng on 14-10-24.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "BusinessLicenseViewController.h"
#import "UIImageView+WebCache.h"
#import "SJAvatarBrowser.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "SBJson.h"
#import "MengClass.h"
#import "ZhPMethod.h"
#import "HttpClient.h"
#import "UIImage+Utility.h"
#import "Store.h"
#import "BranchModel.h"
#import "BranchModelR.h"
#import "MADateView.h"
#import "UIImage+Ex.h"
@interface BusinessLicenseViewController ()<UIAlertViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
{
    BOOL haveImage;
    AppDelegate * appDelegate;
    
    BOOL changeImage;
    BOOL changeTime;
    UIBarButtonItem * rightBarButton;
    
    
    NSString *certifiNO;
    NSString *certifiDate;
    NSString *certifiUrl;
}
@property (nonatomic ,strong) NSMutableArray *cacheHTTP;

@property (weak, nonatomic) IBOutlet UIImageView *addImageView;
@property (weak, nonatomic) IBOutlet UIImageView *deleteImageView;
@property (weak, nonatomic) IBOutlet UITextField *licenseField;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (weak, nonatomic) IBOutlet UILabel *licenseTitle;

@property (weak, nonatomic) IBOutlet UILabel *numberName;

//过期
@property (weak, nonatomic) IBOutlet UIView *timeOverStatus;

//未完善
@property (weak, nonatomic) IBOutlet UILabel *noImage;
@property (weak, nonatomic) IBOutlet UILabel *noNumber;
@property (weak, nonatomic) IBOutlet UILabel *noTime;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)deleteTapClick:(UIButton *)sender;

//审核中
@property (weak, nonatomic) IBOutlet UIView *picStatuView;
@property (weak, nonatomic) IBOutlet UIView *IDNumberStatuView;
@property (weak, nonatomic) IBOutlet UIView *endTimeStatuView;

- (IBAction)timeButtonClick:(id)sender;

//营业执照需要隐藏的控件

@property (weak, nonatomic) IBOutlet UIImageView *endTimeBgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *endTimeArrow;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLable;

@end

@implementation BusinessLicenseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClick)];
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    rightBarButton.enabled = YES;
    
    //2.1.5需求,隐藏有效期相关功能
    if (self.licenseType == LicenseTypeBusiness) {
        
        self.endTimeBgImageView.hidden = YES;
        self.endTimeArrow.hidden = YES;
        self.endTimeLable.hidden = YES;
        self.endTimeStatuView.hidden = YES;
        self.timeOverStatus.hidden = YES;
        self.timeButton.hidden = YES;
        self.noTime.hidden = YES;
    }
    //Talking data统计
    switch (self.licenseType) {
        case LicenseTypeBusiness:
        {
            [QWCLICKEVENT qwTrackPageBegin:@"BusinessLicenseViewController_yyzz"];
        }
            break;
        case LicenseTypeDrug:
        {
            [QWCLICKEVENT qwTrackPageBegin:@"BusinessLicenseViewController_ypjyxkz"];
        }
            break;
        default:
            break;
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    rightBarButton.enabled = YES;
    switch (self.licenseType) {
        case LicenseTypeBusiness:
        {
            [QWCLICKEVENT qwTrackPageEnd:@"BusinessLicenseViewController_yyzz"];
        }
            break;
        case LicenseTypeDrug:
        {
            [QWCLICKEVENT qwTrackPageEnd:@"BusinessLicenseViewController_ypjyxkz"];
        }
            break;
        default:
            break;
    }
}

- (void)layoutUI
{
    NSString *valueName = self.licenseTitle.text;
    //FIXME: 这个需要修改 note by meng
    CGSize valueNameSize = [QWGLOBALMANAGER getTextSizeWithContent:valueName WithUIFont:fontSystem(14) WithWidth:1000];
    self.licenseTitle.frame = CGRectMake(self.licenseTitle.frame.origin.x, self.licenseTitle.frame.origin.y + 2, valueNameSize.width, valueNameSize.height);
    
    CGFloat label_x = self.licenseTitle.frame.origin.x + self.licenseTitle.frame.size.width;
    
    self.noImage.frame = CGRectMake(label_x, self.noImage.frame.origin.y, self.noImage.frame.size.width, self.noImage.frame.size.height);
    self.picStatuView.frame = CGRectMake(label_x, self.picStatuView.frame.origin.y, self.picStatuView.frame.size.width, self.picStatuView.frame.size.height);
    self.timeOverStatus.frame = CGRectMake(label_x, self.timeOverStatus.frame.origin.y, self.timeOverStatus.frame.size.width, self.timeOverStatus.frame.size.height);
    
    NSString *licenseNumberTitle = self.numberName.text;
    CGSize numberSize = [QWGLOBALMANAGER getTextSizeWithContent:licenseNumberTitle WithUIFont:fontSystem(14) WithWidth:1000];
    self.numberName.frame = CGRectMake(self.numberName.frame.origin.x, self.numberName.frame.origin.y + 2, numberSize.width, numberSize.height);
    label_x = self.numberName.frame.origin.x + self.numberName.frame.size.width;
    
    self.noNumber.frame = CGRectMake(label_x, self.noNumber.frame.origin.y, self.noNumber.frame.size.width, self.noNumber.frame.size.height);
    self.IDNumberStatuView.frame = CGRectMake(label_x, self.IDNumberStatuView.frame.origin.y, self.IDNumberStatuView.frame.size.width, self.IDNumberStatuView.frame.size.height);

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cacheHTTP = [NSMutableArray array];
    changeImage = NO;
    changeTime = NO;
    self.licenseField.delegate = self;
    UITapGestureRecognizer * addTap = [[UITapGestureRecognizer alloc] init];
    [self.addImageView addGestureRecognizer:addTap];
    [addTap addTarget:self action:@selector(addTapClick:)];
    
    
    NSArray *arr = self.certificateModel.items;
    //0正常、1未完善、2过期、3审核中
    NSInteger status = 0;
    NSString *theNewValue = nil;
    NSString *oldNewValue = nil;
    NSString *publicStr = nil;
    for (CertificateItemModel *itemModel in arr) {
        NSString *flag = itemModel.flag;
        status = [[NSString stringWithFormat:@"%@",itemModel.status] integerValue];
        theNewValue = itemModel.newValue;
        oldNewValue = itemModel.oldValue;
        if ([flag isEqualToString:kIMG]) //图片
        {
            switch (status) {
                case 1: //1未完善
                {
                    self.noImage.hidden = NO;
                    [self deleteImageHidden:YES];
                    publicStr = nil;
                }
                    break;
                case 2: //过期
                {
                    publicStr = oldNewValue;
                    [self deleteImageHidden:NO];
                }
                    break;
                case 3: //审核中
                {
                    self.picStatuView.hidden = NO;
                    publicStr = theNewValue;
                    [self deleteImageHidden:YES];
                }
                    break;
                    
                default://正常
                {
                    self.deleteImageView.hidden = NO;
                    publicStr = oldNewValue;
                    [self deleteImageHidden:NO];
                }
                    break;
            }
            if (!StrIsEmpty(publicStr)) {
                [self.addImageView setImageWithURL:[NSURL URLWithString:publicStr]];
                certifiUrl = publicStr;
                haveImage = YES;
            }else{
                haveImage = NO;
            }
            self.licenseTitle.text = itemModel.name;
        }else
            if ([flag isEqualToString:kNO]) //编号
            {
                switch (status) {
                    case 1: //1未完善
                    {
                        self.noNumber.hidden = NO;
                        publicStr = nil;
                    }
                        break;
                    case 2: //过期
                    {
                        publicStr = oldNewValue;
                    }
                        break;
                    case 3: //审核中
                    {
                        self.IDNumberStatuView.hidden = NO;
                        publicStr = theNewValue;
                    }
                        break;
                        
                    default://正常
                    {
                        publicStr = oldNewValue;
                    }
                        break;
                }
                certifiNO = publicStr;
                self.licenseField.text = publicStr;
                self.numberName.text = itemModel.name;
            }else
                if ([flag isEqualToString:kDATE]) //有效期
                {
                    switch (status) {
                        case 1: //1未完善
                        {
                            self.noTime.hidden = NO;
                            publicStr = nil;
                        }
                            break;
                        case 2: //过期
                        {
                            publicStr = oldNewValue;
                            self.timeOverStatus.hidden = NO;
                        }
                            break;
                        case 3: //审核中
                        {
                            self.endTimeStatuView.hidden = NO;
                            publicStr = theNewValue;
                        }
                            break;
                            
                        default://正常
                        {
                            publicStr = oldNewValue;
                        }
                            break;
                    }
                    certifiDate = publicStr;
                    if (StrIsEmpty(publicStr)) {
                        [self.timeButton setTitle:@"请选择有效期" forState:UIControlStateNormal];
                    }else{
                        [self.timeButton setTitle:certifiDate forState:UIControlStateNormal];
                    }
                }
    }
    
    if ([[NSString stringWithFormat:@"%@",self.certificateModel.status] integerValue] == 3) { //审核中
        self.licenseField.userInteractionEnabled = NO;
        self.deleteImageView.hidden = YES;
        self.deleteButton.hidden = YES;
        self.timeButton.userInteractionEnabled = NO;
    }
}

- (void)deleteImageHidden:(BOOL)hidden
{
    
    self.deleteImageView.hidden = hidden;
    self.deleteButton.hidden = hidden;
}


#pragma mark ---------手势点击事件----------
- (void)addTapClick:(UITapGestureRecognizer *)tap{
    if (haveImage) {
        UIImageView * imageView = (UIImageView *)[tap view];
        [SJAvatarBrowser showImage:imageView];
    }else{
        //设置头像
        if ([[NSString stringWithFormat:@"%@",self.certificateModel.status] integerValue] == 3) {
            if (haveImage) {
                UIImageView * imageView = (UIImageView *)[tap view];
                [SJAvatarBrowser showImage:imageView];
            }
            return;
        }
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照设置图片", @"从相册选择图片", nil];
        [actionSheet showInView:self.view];
    }
}
- (IBAction)deleteTapClick:(UIButton *)sender {

    if (haveImage) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除图片吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([QWGLOBALMANAGER judgeTheKeyboardInputModeIsEmojiOrNot:textField]) {
        return NO;
    }
    return YES;
}

#pragma mark ---------代理事件---------

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UIImage * defaultImage = [UIImage imageNamed:@"添加图片.png"];
        self.addImageView.image = defaultImage;
        haveImage = NO;
        [self deleteImageHidden:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerControllerSourceType sourceType;
    if (buttonIndex == 0) {
        //拍照
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if (buttonIndex == 1){
        //相册
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else if (buttonIndex == 2){
        //取消
        return;
    }
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

#pragma mark --------相册相机图片回调--------

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    /**
     *1.通过相册和相机获取的图片都在此代理中
     *
     *2.图片选择已完成,在此处选择传送至服务器
     */
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.addImageView.image = image;
    haveImage = YES;
    changeImage = YES;
    [self deleteImageHidden:NO];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightBarButtonClick{
    
    [self.licenseField resignFirstResponder];
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
        return;
    }
    
    if ([[NSString stringWithFormat:@"%@",self.certificateModel.status] integerValue] == 3) {
        [SVProgressHUD showErrorWithStatus:@"信息审核中,无法修改" duration:DURATION_SHORT];
        return;
    }
    
    if (haveImage == NO) {
        if (self.licenseType == LicenseTypeBusiness) {
            [SVProgressHUD showErrorWithStatus:@"请上传营业执照" duration:DURATION_SHORT];
        }else if (self.licenseType == LicenseTypeDrug){
            [SVProgressHUD showErrorWithStatus:@"请上传药品经营许可证" duration:DURATION_SHORT];
        }
        return;
    }
    if([QWGLOBALMANAGER removeSpace:self.licenseField.text].length>32){
        if(self.licenseType == LicenseTypeBusiness){
            [SVProgressHUD showErrorWithStatus:@"请输入正确的营业执照注册号" duration:DURATION_SHORT];
        }else if(self.licenseType == LicenseTypeDrug){
            [SVProgressHUD showErrorWithStatus:@"请输入正确的药品经营许可证号" duration:DURATION_SHORT];
        }
        return;
    }
    if([QWGLOBALMANAGER removeSpace:self.licenseField.text].length == 0){
        if(self.licenseType == LicenseTypeBusiness){
            [SVProgressHUD showErrorWithStatus:@"请输入营业执照注册号" duration:DURATION_SHORT];
        }else if(self.licenseType == LicenseTypeDrug){
            [SVProgressHUD showErrorWithStatus:@"请输入药品经营许可证号" duration:DURATION_SHORT];
        }
        return;
    }
    
    //2.1.5需求,隐藏有效期相关功能
    if (self.licenseType != LicenseTypeBusiness) {
        if (self.timeButton.titleLabel.text.length == 0 || [self.timeButton.titleLabel.text isEqualToString:@"请选择有效期"]) {
            [SVProgressHUD showErrorWithStatus:@"请选择执照有效期" duration:DURATION_SHORT];
            return;
        }
    }
    
    
    
    //证件编号
    if ([certifiNO isEqualToString:self.licenseField.text] && changeTime == NO && changeImage == NO) {
        [SVProgressHUD showErrorWithStatus:kWaring49 duration:DURATION_SHORT];
        return;
    }
    
    rightBarButton.enabled = NO;
    if (changeImage) {
        
        
        UIImage *image = self.addImageView.image;
        
//        image = [UIImage compressImage:image];
        
        image = [image imageByScalingToMinSize];
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
        NSMutableArray *array = [NSMutableArray arrayWithObject:imageData];
        
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"type"] = @"4";
        
        __weak BusinessLicenseViewController *weakSelf = self;
        [[HttpClient sharedInstance] uploaderImg:array params:setting withUrl:NW_uploadFile success:^(id responseObj) {
            rightBarButton.enabled = YES;
            if (!StrIsEmpty(StrFromObj(responseObj[@"body"][@"url"]))) {
                NSString *url = responseObj[@"body"][@"url"];
                [weakSelf updateInfomation:url];
            }
            
            
        } failure:^(HttpException *e) {
            rightBarButton.enabled = YES;
//            NSLog(@"%@类中 -> %@",NSStringFromClass([weakSelf class]),e);
        } uploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            
        }];
    }else{
        [self updateInfomation:nil];
    }
    
}

- (void)updateInfomation:(NSString *)imageUrl
{
    
    BranchCertifiSaveModelR *saveModelR = [[BranchCertifiSaveModelR alloc] init];
    NSString * uid = self.certificateModel.id;
    saveModelR.certifiName = self.certificateModel.name;
    if (uid.length > 0) {
        saveModelR.id = uid;
    }
    
    if (!QWGLOBALMANAGER.configure.groupId) {
        return;
    }
    saveModelR.groupId = QWGLOBALMANAGER.configure.groupId;
    switch (self.licenseType) {
        case LicenseTypeBusiness:
        {
            saveModelR.typeId = @1;//营业执照
        }
            break;
        case LicenseTypeDrug:
        {
            saveModelR.typeId = @3;//药品经营许可证
        }
        default:
            break;
    }
    if (imageUrl) {
        saveModelR.imageName = imageUrl;
    }else{
        saveModelR.imageName = certifiUrl;
    }
    
    saveModelR.certifiNo = [QWGLOBALMANAGER removeSpace:self.licenseField.text];
    
    //2.1.5需求,隐藏有效期相关功能,不校验营业执照有效期
    if (self.licenseType != LicenseTypeBusiness) {
        NSString *timeStr = self.timeButton.currentTitle;
        if (!StrIsEmpty(timeStr)) {
            saveModelR.validEndDate = timeStr;
        }
    }
    
    
    
    [Store updateCertifiWithParams:saveModelR success:^(id responseObj) {
        [SVProgressHUD dismiss];
        rightBarButton.enabled = YES;
        
        BranchModel *branchModel = (BranchModel *)responseObj;
        if ([branchModel.apiStatus integerValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:kWaring50 duration:DURATION_SHORT];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:branchModel.apiMessage duration:DURATION_SHORT];
        }
    } failure:^(HttpException *e) {
        rightBarButton.enabled = YES;
        [SVProgressHUD dismiss];
    }];
}


- (IBAction)timeButtonClick:(id)sender {
    [self.licenseField resignFirstResponder];
    if (haveImage) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *timeStr = self.timeButton.titleLabel.text;
        NSDate *date;
        if (!StrIsEmpty(timeStr)) {
            date = [dateFormatter dateFromString:timeStr];
        }else{
            date = [NSDate date];
        }
        [MADateView showDateViewWithDate:date Style:DateViewStyleDate CallBack:^(MyWindowClick buttonIndex, NSString *timeStr) {
            
            switch (buttonIndex) {
                case MyWindowClickForOK:
                {
                    [self.timeButton setTitle:timeStr forState:UIControlStateNormal];
                    changeTime = YES;
                }
                    break;
                case MyWindowClickForCancel:
                {
                    NSLog(@"cancle!");
                }
                    break;
                default:
                    break;
            }
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"请上传营业执照" duration:DURATION_SHORT];
    }
}

@end
