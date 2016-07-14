//
//  LegalPersonViewController.m
//  wenyao-store
//
//  Created by Meng on 14-10-23.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "LegalPersonViewController.h"
#import "UIImageView+WebCache.h"
#import "SJAvatarBrowser.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "SBJson.h"
#import "AppDelegate.h"
#import "MengClass.h"
#import "HttpClient.h"
#import "UIImage+Utility.h"
#import "Store.h"
#import "BranchModelR.h"
#import "BranchModel.h"
#import "UIImage+Ex.h"
#import "CustomIdPhotoViewController.h"

@interface LegalPersonViewController ()<UIAlertViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,CustomIdPhotoViewControllerDelegate>
{
    BOOL haveImage;
    AppDelegate * appDelegate;
    BOOL changeImage;
    UIBarButtonItem * rightBarButton;
    
    NSString *certifiNO;
    NSString *certifiName;
    NSString *certifiUrl;
}

@property (weak, nonatomic) IBOutlet UIImageView *addImageView;
@property (weak, nonatomic) IBOutlet UIImageView *deleteImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *IDCardField;

@property (strong, nonatomic) NSMutableArray    *cacheHTTP;
//未完善
@property (weak, nonatomic) IBOutlet UILabel *noPic;
@property (weak, nonatomic) IBOutlet UILabel *noName;
@property (weak, nonatomic) IBOutlet UILabel *noNumber;

//审核中
@property (weak, nonatomic) IBOutlet UIView *picStatusView;
@property (weak, nonatomic) IBOutlet UIView *nameStatuView;
@property (weak, nonatomic) IBOutlet UIView *numberStatuView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)deleteButtonClick:(UIButton *)sender;

@end

@implementation LegalPersonViewController

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
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    rightBarButton.enabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _cacheHTTP = [NSMutableArray array];
    changeImage = NO;
    
    [self defineTapGesture];
    
    
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
                    self.noPic.hidden = NO;
                    [self deleteOptionHidden:YES];
                    publicStr = nil;
                }
                    break;
                case 2: //过期
                {
                    publicStr = oldNewValue;
                    [self deleteOptionHidden:NO];
                }
                    break;
                case 3: //审核中
                {
                    self.picStatusView.hidden = NO;
                    publicStr = theNewValue;
                }
                    break;
                    
                default://正常
                {
                    [self deleteOptionHidden:NO];
                    publicStr = oldNewValue;
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
                    self.numberStatuView.hidden = NO;
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
            self.IDCardField.text = publicStr;
        }else
            if ([flag isEqualToString:kHOLDER]) //姓名
        {
            switch (status) {
                case 1: //1未完善
                {
                    self.noName.hidden = NO;
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
                    self.nameStatuView.hidden = NO;
                    publicStr = theNewValue;
                }
                    break;
                    
                default://正常
                {
                    publicStr = oldNewValue;
                }
                    break;
            }
            certifiName = publicStr;
            self.nameField.text = publicStr;
        }
    }
    
    if ([[NSString stringWithFormat:@"%@",self.certificateModel.status] integerValue] == 3) {
        self.nameField.userInteractionEnabled = NO;
        self.IDCardField.userInteractionEnabled = NO;
        [self deleteOptionHidden:YES];
    }
}

- (void)defineTapGesture
{
    UITapGestureRecognizer * addTap = [[UITapGestureRecognizer alloc] init];
    [self.addImageView addGestureRecognizer:addTap];
    [addTap addTarget:self action:@selector(addTapClick:)];
}

//- (void)

#pragma mark ---------手势点击事件----------
- (void)addTapClick:(UITapGestureRecognizer *)tap{
    [self hiddenKeyboard];
    if (haveImage) {
        UIImageView * imageView = (UIImageView *)[tap view];
        [SJAvatarBrowser showImage:imageView];
    }else{
        //设置头像
        if ([[NSString stringWithFormat:@"%@",self.certificateModel.status] integerValue] != 3) {
            UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照设置图片", @"从相册选择图片", nil];
            [actionSheet showInView:self.view];
        }
        
    }
}

- (void)deleteButtonClick:(UIButton *)sender
{
    [self hiddenKeyboard];
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

- (void)deleteOptionHidden:(BOOL)hidden
{
    self.deleteButton.hidden = hidden;
    self.deleteImageView.hidden = hidden;
}

#pragma mark ---------代理事件---------

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UIImage * defaultImage = [UIImage imageNamed:@"添加图片.png"];
        self.addImageView.image = defaultImage;
        [self deleteOptionHidden:YES];
        haveImage = NO;
    }
}
//Savecerfiti
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
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
    self.addImageView.image = image;
    haveImage = YES;
    changeImage = YES;
    [self deleteOptionHidden:NO];
}

#pragma mark ---- 通过相册获取图片 ----

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.addImageView.image = image;
    haveImage = YES;
    changeImage = YES;
    [self deleteOptionHidden:NO];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightBarButtonClick{
    [self hiddenKeyboard];
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试!" duration:DURATION_SHORT];
        return;
    }
    
    if ([[NSString stringWithFormat:@"%@",self.certificateModel.status] integerValue] == 3) {
        [SVProgressHUD showErrorWithStatus:@"信息审核中,无法修改" duration:DURATION_SHORT];
        return;
    }
    
    if (haveImage == NO) {
        [SVProgressHUD showErrorWithStatus:@"请上传法人/企业负责人身份证" duration:DURATION_SHORT];
        return;
    }
    
    if (self.nameField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入法人姓名" duration:DURATION_SHORT];
        return;
    }else if (self.nameField.text.length > 10) {
        [SVProgressHUD showErrorWithStatus:@"法人姓名不能超过10个字" duration:DURATION_SHORT];
        return;
    }
    if (self.IDCardField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入法人/企业负责人身份证号" duration:DURATION_SHORT];
        return;
    }else if (![MengClass validateIDCardNumber:self.IDCardField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的身份证号" duration:DURATION_SHORT];
        return;
    }
    
    
    if ([self.nameField.text isEqualToString:certifiName] &&
        changeImage == NO &&
        [self.IDCardField.text isEqualToString:certifiNO])
    {
        [SVProgressHUD showErrorWithStatus:@"您未修改任何信息" duration:DURATION_SHORT];
        return;
    }
    /**
     *
     */
    
    
    if (changeImage) {
        UIImage * image = self.addImageView.image;
        
        if (image) {
            
            if (!QWGLOBALMANAGER.loginStatus) {
                return;
            }
            
            //传到服务器
            rightBarButton.enabled = NO;
            
            //            image = [UIImage compressImage:image];
            image = [image imageByScalingToMinSize];
            NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
            NSMutableArray *array = [NSMutableArray arrayWithObject:imageData];
            
            NSMutableDictionary *setting = [NSMutableDictionary dictionary];
            setting[@"type"] = @"4";
            
            __weak LegalPersonViewController *weakSelf = self;
            [[HttpClient sharedInstance] uploaderImg:array params:setting withUrl:NW_uploadFile success:^(id responseObj) {
                rightBarButton.enabled = YES;
                if ([responseObj[@"body"][@"apiStatus"] integerValue] == 0) {
                    if (!StrIsEmpty(StrFromObj(responseObj[@"body"][@"url"]))) {
                        NSString *url = responseObj[@"body"][@"url"];
                        [weakSelf updateInfomation:url];
                    }
                }else{
                    [SVProgressHUD showErrorWithStatus:responseObj[@"body"][@"apiMessage"] duration:DURATION_SHORT];
                    return;
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


- (void)updateInfomation:(NSString *)imageUrl;
{
    NSString *groupId = QWGLOBALMANAGER.configure.groupId;
    if (StrIsEmpty(groupId)) {
        return;
    }
    BranchCertifiSaveModelR *saveModelR = [[BranchCertifiSaveModelR alloc] init];
    
    NSString *uid = self.certificateModel.id;
    if (uid.length > 0) {
        saveModelR.id = uid;
    }
    saveModelR.groupId = groupId;
    saveModelR.typeId = self.certificateModel.type;//法人/企业负责人身份证
    if (!StrIsEmpty(imageUrl)) {
        saveModelR.imageName = imageUrl;
    }else{
        saveModelR.imageName = certifiUrl;
    }
    
    saveModelR.certifiName = [QWGLOBALMANAGER removeSpace:self.nameField.text];
    saveModelR.certifiNo = [QWGLOBALMANAGER removeSpace:self.IDCardField.text];
    rightBarButton.enabled = NO;
    
    [Store updateCertifiWithParams:saveModelR success:^(id responseObj) {
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
        NSLog(@"%@ -> %@",NSStringFromClass([self class]),e);
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self hiddenKeyboard];
}

- (void)hiddenKeyboard
{
    [self.nameField resignFirstResponder];
    [self.IDCardField resignFirstResponder];
}

@end
