//
//  BusinessLicenseViewController.m
//  wenyao-store
//
//  Created by Meng on 14-10-23.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "OtherLicenseViewController.h"
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
@interface OtherLicenseViewController ()<UIAlertViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    BOOL haveImage;
    AppDelegate * appDelegate;
    BOOL changeTime;
    BOOL changeImage;
    
    UIBarButtonItem * rightBarButton;
    
    
    NSString *certifiDate;
    NSString *certifiUrl;
}
@property (nonatomic ,strong) NSString *JGType;

@property (weak, nonatomic) IBOutlet UIImageView *addImageView;
@property (weak, nonatomic) IBOutlet UIImageView *deleteImageView;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (strong, nonatomic) NSMutableArray    *cacheHTTP;


@property (weak, nonatomic) IBOutlet UIView *timeOverStatus;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)deleteTapClick:(UIButton *)sender;

//未完善
@property (weak, nonatomic) IBOutlet UILabel *noName;
@property (weak, nonatomic) IBOutlet UILabel *noTime;

//审核
@property (weak, nonatomic) IBOutlet UIView *picStatuView;
@property (weak, nonatomic) IBOutlet UIView *endTimeStatuView;

- (IBAction)timeButtonClick:(UIButton *)sender;

@end

@implementation OtherLicenseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarButtonClick)];
        self.navigationItem.rightBarButtonItem = rightBarButton;
        haveImage = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    rightBarButton.enabled = YES;
    if ([self.JGType isEqualToString:@"6"]) {
        [QWCLICKEVENT qwTrackPageBegin:@"OtherLicenseViewController_gsp"];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.JGType isEqualToString:@"6"]) {
        [QWCLICKEVENT qwTrackPageEnd:@"OtherLicenseViewController_gsp"];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    rightBarButton.enabled = YES;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    changeTime = NO;
    changeImage = NO;
    _cacheHTTP = [NSMutableArray arrayWithCapacity:15];
    UITapGestureRecognizer * addTap = [[UITapGestureRecognizer alloc] init];
    [self.addImageView addGestureRecognizer:addTap];
    [addTap addTarget:self action:@selector(addTapClick:)];
    
    NSString * name = self.certificateModel.name;
//    NSString *typeId;
//    NSDictionary *queryDic = self.infoDict[QueryKey];
//    if (queryDic && queryDic.count > 0) {//审核
//        typeId = self.infoDict[@"certificateType"];
//        name = self.infoDict[@"certificateName"];
//    }else{//查询
//        typeId = self.infoDict[@"typeId"];
//        name = self.infoDict[@"valueName"];
//    }
//    self.JGType = typeId;
    //FIXME: 这个需要fix  note by meng
    CGSize size = [QWGLOBALMANAGER getTextSizeWithContent:name WithUIFont:fontSystem(14) WithWidth:APP_W];
    self.titleLabel.text = name;

    self.titleLabel.font = fontSystem(14);
    [self.titleLabel setFrame:CGRectMake(20, 40 + 50/2 - size.height/2, size.width, size.height)];
    [self.noName setFrame:CGRectMake(self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 8, self.noName.frame.origin.y, self.noName.frame.size.width, self.noName.frame.size.height)];
    [self.picStatuView setFrame:CGRectMake(self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 8, self.picStatuView.frame.origin.y, self.picStatuView.frame.size.width, self.picStatuView.frame.size.height)];
    [self.timeOverStatus setFrame:CGRectMake(self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 8, self.timeOverStatus.frame.origin.y, self.timeOverStatus.frame.size.width, self.timeOverStatus.frame.size.height)];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
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
                    self.noName.hidden = NO;
                    [self deleteImageViewOption:YES];
                    publicStr = nil;
                }
                    break;
                case 2: //过期
                {
                    publicStr = oldNewValue;
                    [self deleteImageViewOption:NO];
                }
                    break;
                case 3: //审核中
                {
                    publicStr = theNewValue;
                    [self deleteImageViewOption:YES];
                }
                    break;
                    
                default://正常
                {
                    publicStr = oldNewValue;
                    [self deleteImageViewOption:NO];
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
            self.titleLabel.text = itemModel.name;
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
        self.titleLabel.userInteractionEnabled = NO;
        self.deleteImageView.hidden = YES;
        self.deleteButton.hidden = YES;
        self.timeButton.userInteractionEnabled = NO;
    }
}

#pragma mark ---------手势点击事件----------
- (void)addTapClick:(UITapGestureRecognizer *)tap{
    if (haveImage) {
        UIImageView * imageView = (UIImageView *)[tap view];
        [SJAvatarBrowser showImage:imageView];
    }else{
        //设置头像
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

- (void)deleteImageViewOption:(BOOL)hidden
{
    self.deleteButton.hidden = hidden;
    self.deleteImageView.hidden = hidden;
}

#pragma mark ---------代理事件---------

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UIImage * defaultImage = [UIImage imageNamed:@"添加图片.png"];
        self.addImageView.image = defaultImage;
        haveImage = NO;
        [self deleteImageViewOption:YES];
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
    [self deleteImageViewOption:NO];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightBarButtonClick{
    
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试!" duration:DURATION_SHORT];
        return;
    }
    
    if ([[NSString stringWithFormat:@"%@",self.certificateModel.status] integerValue] == 3) {
        [SVProgressHUD showErrorWithStatus:@"信息审核中,无法修改" duration:DURATION_SHORT];
        return;
    }
    if (haveImage == NO) {
        if ([self.JGType isEqualToString:@"6"]) {
            [SVProgressHUD showErrorWithStatus:@"请上传GSP证书" duration:DURATION_SHORT];
        }else if ([self.JGType isEqualToString:@"3"]) {
            [SVProgressHUD showErrorWithStatus:@"请上传药品经营许可证" duration:DURATION_SHORT];
        }else if ([self.JGType isEqualToString:@"10"]){
            [SVProgressHUD showErrorWithStatus:@"请上传医疗机构许可证" duration:DURATION_SHORT];
        }else{
            [SVProgressHUD showErrorWithStatus:@"请上传机构执照" duration:DURATION_SHORT];
        }
        return;
    }
    
    if ([[self.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]length] == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入执照名称" duration:DURATION_SHORT];
        return;
    }
    if (self.timeButton.titleLabel.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择执照有效期" duration:DURATION_SHORT];
        return;
    }
    
    if (changeImage == NO && changeTime == NO) {
        [SVProgressHUD showErrorWithStatus:@"您未修改任何信息" duration:DURATION_SHORT];
        return;
    }
    rightBarButton.enabled = NO;
    if (changeImage) {
        UIImage *image = self.addImageView.image;
        CGRect bounds = CGRectMake(0, 0, APP_W, APP_W);
        UIGraphicsBeginImageContext(bounds.size);
        [image drawInRect:bounds];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (image) {
            
            if (!QWGLOBALMANAGER.loginStatus) {
                return;
            }
            //传到服务器
            //传到服务器
            rightBarButton.enabled = NO;
            
            //            image = [UIImage compressImage:image];
            image = [image imageByScalingToMinSize];
            NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
            NSMutableArray *array = [NSMutableArray arrayWithObject:imageData];
            
            NSMutableDictionary *setting = [NSMutableDictionary dictionary];
            setting[@"type"] = @"4";
            __weak OtherLicenseViewController *weakSelf = self;
            [[HttpClient sharedInstance] uploaderImg:array params:setting withUrl:NW_uploadFile success:^(id responseObj) {
                rightBarButton.enabled = YES;
                if (!StrIsEmpty(StrFromObj(responseObj[@"body"][@"url"]))) {
                    NSString *url = responseObj[@"body"][@"url"];
                    [weakSelf updateInfomation:url];
                }
            } failure:^(HttpException *e) {
                rightBarButton.enabled = YES;
                NSLog(@"%@类中 -> %@",NSStringFromClass([weakSelf class]),e);
            } uploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                
            }];
        }
        
    }else{
        [self updateInfomation:nil];
    }
}


- (void)updateInfomation:(NSString *)imageUrl
{
    BranchCertifiSaveModelR *saveModelR = [[BranchCertifiSaveModelR alloc] init];
    NSString * uid = self.certificateModel.id;
    if (uid.length > 0) {
        saveModelR.id = uid;
    }
    if (!QWGLOBALMANAGER.configure.groupId) {
        return;
    }
    saveModelR.groupId = QWGLOBALMANAGER.configure.groupId;
    saveModelR.typeId = @([self.certificateModel.type integerValue]);
    if (!StrIsEmpty(imageUrl)) {
        saveModelR.imageName = imageUrl;
    }else{
        saveModelR.imageName = certifiUrl;
    }
    saveModelR.certifiName = self.certificateModel.name;
    saveModelR.validEndDate = [QWGLOBALMANAGER removeSpace:self.timeButton.titleLabel.text];
    
    [Store updateCertifiWithParams:saveModelR success:^(id responseObj) {
        rightBarButton.enabled = YES;
        [SVProgressHUD dismiss];
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
        NSLog(@"%@ -> %@",NSStringFromClass([self class]),e);
    }];
}

- (IBAction)timeButtonClick:(UIButton *)sender {
    [self.titleLabel resignFirstResponder];
    
    if (haveImage) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *timeLable = self.timeButton.titleLabel.text;
        NSDate *date;
        if (!StrIsEmpty(timeLable)) {
            date = [dateFormatter dateFromString:timeLable];
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
        if ([self.JGType isEqualToString:@"6"]) {
            [SVProgressHUD showErrorWithStatus:@"请上传GSP证书" duration:DURATION_SHORT];
        }else if ([self.JGType isEqualToString:@"3"]) {
            [SVProgressHUD showErrorWithStatus:@"请上传药品经营许可证" duration:DURATION_SHORT];
        }else if ([self.JGType isEqualToString:@"10"]){
            [SVProgressHUD showErrorWithStatus:@"请上传医疗机构许可证" duration:DURATION_SHORT];
        }else{
            [SVProgressHUD showErrorWithStatus:@"请上传机构执照" duration:DURATION_SHORT];
        }
        
    }
    
}

@end
