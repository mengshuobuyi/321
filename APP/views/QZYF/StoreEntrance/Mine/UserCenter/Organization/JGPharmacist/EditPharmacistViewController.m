//
//  EditPharmacistViewController.m
//  wenyao-store
//
//  Created by Meng on 14-10-24.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "EditPharmacistViewController.h"
#import "SJAvatarBrowser.h"
#import "UIImageView+WebCache.h"
#import "SBJson.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "MengClass.h"
#import "ApothecaryViewController.h"
#import "UIImage+Utility.h"
#import "MengClass.h"
#import "HttpClient.h"
#import "Store.h"
#import "MADateView.h"
#import "BranchModel.h"
#import "UIImage+Ex.h"
typedef enum : NSUInteger {
    JGImageTypeCertImgUrl = 0, //药师资格证
    JGImageTypePracticeImgUrl, //执业药师注册证
} JGPharmacistImageType;

CGFloat const gestureMinimumTranslation = 20.0 ;

typedef enum : NSInteger {
    
    kCameraMoveDirectionNone,
    
    kCameraMoveDirectionUp,
    
    kCameraMoveDirectionDown,
    
    kCameraMoveDirectionRight,
    
    kCameraMoveDirectionLeft
    
} CameraMoveDirection;


@interface EditPharmacistViewController ()<UIActionSheetDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
{
    NSInteger imageTag;
    AppDelegate * appDelegate;
    
    BOOL isChange;
    BOOL haveNormal;
    BOOL haveSpecial;
    CameraMoveDirection direction;
}
@property (weak, nonatomic) IBOutlet UITextField *nameField;

@property (weak, nonatomic) IBOutlet UIButton *sexButton;
- (IBAction)sexButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *IDCardField;
@property (weak, nonatomic) IBOutlet UIImageView *addNormal;
@property (weak, nonatomic) IBOutlet UIImageView *deleteNormal;
@property (weak, nonatomic) IBOutlet UIImageView *addSpecial;
@property (weak, nonatomic) IBOutlet UIImageView *deleteSpecial;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
- (IBAction)timeButtonClick:(id)sender;

//执照过期
@property (weak, nonatomic) IBOutlet UIView *timeOutView;
@property (nonatomic ,strong) UIBarButtonItem *rightBarButton;


//状态view
@property (weak, nonatomic) IBOutlet UIView *nameStatusView;
@property (weak, nonatomic) IBOutlet UIView *sexStatusView;
@property (weak, nonatomic) IBOutlet UIView *IDStatusView;
@property (weak, nonatomic) IBOutlet UIView *normalStatusView;
@property (weak, nonatomic) IBOutlet UIView *specialStatusView;
@property (weak, nonatomic) IBOutlet UIView *dateStatusView;

//未完善
@property (weak, nonatomic) IBOutlet UILabel *noPerfectName;
@property (weak, nonatomic) IBOutlet UILabel *noPerfectSex;
@property (weak, nonatomic) IBOutlet UILabel *noPerfectID;
@property (weak, nonatomic) IBOutlet UILabel *noPerfectPic;

@property (weak, nonatomic) IBOutlet UIButton *deleteNomalButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteSpecialButton;
- (IBAction)deleteTapClick:(UIButton *)sender;


@property (nonatomic ,strong) PharmacistSaveModel *saveOldModel;
@property (nonatomic ,strong) PharmacistSaveModel *saveNewModel;
@property (nonatomic ,assign) JGPharmacistImageType pharmacistImageType;

@end

@implementation EditPharmacistViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        
//        appDelegate = [UIApplication sharedApplication].delegate;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.rightBarButton.enabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.rightBarButton.enabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nameField.delegate = self;
    self.IDCardField.delegate = self;
    self.nameField.returnKeyType = UIReturnKeyDone;
    self.IDCardField.returnKeyType = UIReturnKeyDone;
    
    //滑动隐藏键盘
//    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] init];
//    [self.view addGestureRecognizer:pan];
//    [pan setDelegate:self];
//    [pan addTarget:self action:@selector(hidenKeyboardWithGesture:)];
    
    self.rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarButtonClick)];
    self.navigationItem.rightBarButtonItem = self.rightBarButton;
    
    UITapGestureRecognizer *addNormalTap = [[UITapGestureRecognizer alloc] init];
    [self.addNormal addGestureRecognizer:addNormalTap];
    self.addNormal.tag = 555;
    [addNormalTap addTarget:self action:@selector(addTapClick:)];
    
    
    UITapGestureRecognizer *addSpecialTap = [[UITapGestureRecognizer alloc] init];
    [self.addSpecial addGestureRecognizer:addSpecialTap];
    self.addSpecial.tag = 666;
    [addSpecialTap addTarget: self action:@selector(addTapClick:)];
    
    self.nameField.delegate = self;
    self.IDCardField.delegate = self;
    [self showPharmacistMessage];
}

- (void)hidenKeyboardWithGesture:(UIPanGestureRecognizer *)gesture
{
    
    
    
    
}

- (void)showPharmacistMessage
{
    self.saveNewModel = [[PharmacistSaveModel alloc] init];
    isChange = NO;
    
    if (self.memberModel) {
        //approveStatus 审核状态 (0:未审核,1:审核不通过,2:审核通过),
        if ([self.memberModel.approveStatus integerValue] == 0) {//审核中
            self.nameField.userInteractionEnabled = NO;
            self.sexButton.userInteractionEnabled = NO;
            self.IDCardField.userInteractionEnabled = NO;
            [self deleteNormalOptionHidden:YES];
            [self deleteSpecialOptionHidden:YES];
            self.timeButton.userInteractionEnabled = NO;
        }
        
        self.saveOldModel = [[PharmacistSaveModel alloc] init];
        
        PharmacistInfoModel *pharmacistInfo = self.memberModel.pharmacistInfo;
        
        //名字
        // 0 未审核    1审核不通过    2审核通过
        PharmacistStatusModel *nameModel = pharmacistInfo.name;
        NSInteger nameStatus = [nameModel.fieldStatus integerValue];
        if (nameStatus == 0) {//审核中
            self.nameStatusView.hidden = NO;
        }
        self.nameField.text = nameModel.fieldValue;
        self.saveOldModel.name = nameModel.fieldValue;
        
        
        //性别
        PharmacistStatusModel *sexModel = pharmacistInfo.sex;
        NSInteger sexStatus = [sexModel.fieldStatus integerValue];
        if (sexStatus == 0) {
            self.sexStatusView.hidden = NO;
        }
        NSString *sex = nil;
        if ([sexModel.fieldValue isEqualToString:@"0"]) {
            sex = @"男";
        }else if ([sexModel.fieldValue isEqualToString:@"1"]){
            sex = @"女";
        }
        [self.sexButton setTitle:sex forState:UIControlStateNormal];
        self.saveOldModel.sex = sex;
        
        
        //身份证号
        PharmacistStatusModel *cardNoModel = pharmacistInfo.cardNo;
        NSInteger cardNoStatus = [cardNoModel.fieldStatus integerValue];
        if (cardNoStatus == 0) {
            self.IDStatusView.hidden = NO;
        }
        self.IDCardField.text = cardNoModel.fieldValue;
        self.saveOldModel.cardNo = cardNoModel.fieldValue;
        
        //药师资格证
        PharmacistStatusModel *certImgUrlModel = pharmacistInfo.certImgUrl;
        NSInteger certImgUrlStatus = [certImgUrlModel.fieldStatus integerValue];
        if (certImgUrlStatus == 0) {
            self.normalStatusView.hidden = NO;
            [self deleteNormalOptionHidden:YES];
        }else{
            [self deleteNormalOptionHidden:NO];
        }
        if (!StrIsEmpty(certImgUrlModel.fieldValue)) {
            [self.addNormal setImageWithURL:[NSURL URLWithString:certImgUrlModel.fieldValue]];
            haveNormal = YES;
        }
        self.saveOldModel.certImgUrl = certImgUrlModel.fieldValue;
        
        //执业药师注册证
        PharmacistStatusModel *practiceImgUrlModel = pharmacistInfo.practiceImgUrl;
        NSInteger practiceStatus = [practiceImgUrlModel.fieldStatus integerValue];
        if (practiceStatus == 0) { //审核中
            self.specialStatusView.hidden = NO;
            [self deleteSpecialOptionHidden:YES];
        }else{
            if (StrIsEmpty(practiceImgUrlModel.fieldValue)) {
               [self deleteSpecialOptionHidden:YES];
            }else{
                [self deleteSpecialOptionHidden:NO];
            }
            
        }
        if (!StrIsEmpty(practiceImgUrlModel.fieldValue)) {
            haveSpecial = YES;
            [self.addSpecial setImageWithURL:[NSURL URLWithString:practiceImgUrlModel.fieldValue]];
        }
        self.saveOldModel.practiceImgUrl = practiceImgUrlModel.fieldValue;
        
        //有效期
        if (StrIsEmpty(practiceImgUrlModel.fieldValue)) {
            [self.timeButton setTitle:@"请选择有效期" forState:UIControlStateNormal];
        }else{
            PharmacistStatusModel *practiceEndTimeModel = pharmacistInfo.practiceEndTime;
            NSInteger practiceEndStatus = [practiceEndTimeModel.fieldStatus integerValue];
            if (practiceEndStatus == 0) { //审核中
                self.dateStatusView.hidden = NO;
            }else{
                NSString *endTimevalidResult = StrFromObj(practiceEndTimeModel.validResult);
                if ([endTimevalidResult isEqualToString:@"0"]) {
                    self.timeOutView.hidden = NO;
                }
            }
            [self.timeButton setTitle:practiceEndTimeModel.fieldValue forState:UIControlStateNormal];
        }
    }
}

/*
 JGImageTypeCertImgUrl = 0, //药师资格证
 JGImageTypePracticeImgUrl, //执业药师注册证
 */

#pragma mark -------图片点击事件-------
- (void)addTapClick:(UITapGestureRecognizer *)tap{
    [self.IDCardField resignFirstResponder];
    [self.nameField resignFirstResponder];
    UIImageView *imageView = (UIImageView *)tap.view;
    if (imageView == self.addNormal) {
        if (haveNormal) {
            [SJAvatarBrowser showImage:imageView];
        }else{
            if (self.memberModel && [self.memberModel.approveStatus integerValue] == 0) {//审核中
                return;
            }
            self.pharmacistImageType = JGImageTypeCertImgUrl;
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照设置图片", @"从相册选择图片", nil];
            actionSheet.tag = 888;
            [actionSheet showInView:self.view];
        }
    }else if(imageView == self.addSpecial){
        if (haveSpecial) {
            [SJAvatarBrowser showImage:imageView];
        }else{
            if (self.memberModel && [self.memberModel.approveStatus integerValue] == 0) {//审核中
                return;
            }
            self.pharmacistImageType = JGImageTypePracticeImgUrl;
            UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照设置图片", @"从相册选择图片", nil];
            actionSheet.tag = 888;
            [actionSheet showInView:self.view];
        }
    }
}

- (IBAction)deleteTapClick:(UIButton *)sender {
    [self.IDCardField resignFirstResponder];
    [self.nameField resignFirstResponder];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除图片吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = sender.tag;
    [alertView show];
}

- (void)deleteNormalOptionHidden:(BOOL)hidden
{
    self.deleteNormal.hidden = hidden;
    self.deleteNomalButton.hidden = hidden;
}

- (void)deleteSpecialOptionHidden:(BOOL)hidden
{
    self.deleteSpecial.hidden = hidden;
    self.deleteSpecialButton.hidden = hidden;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (alertView.tag) {
        case 556:
        {
            if (buttonIndex == 1) {
                self.addNormal.image = [UIImage imageNamed:@"添加图片.png"];
                self.saveNewModel.certImgUrl = @"";
                isChange = YES;
                haveNormal = NO;
                [self deleteNormalOptionHidden:YES];
            }
        }
            break;
        case 667:
        {
            if (buttonIndex == 1) {
                self.addSpecial.image = [UIImage imageNamed:@"添加图片.png"];
                isChange = YES;
                haveSpecial = NO;
                [self.timeButton setTitle:@"请选择有效期" forState:UIControlStateNormal];
                [self deleteSpecialOptionHidden:YES];
            }
        }
            break;
        default:
            break;
    }
}



#pragma mark ------选择性别-------
- (IBAction)sexButtonClick:(id)sender {
    [self.nameField resignFirstResponder];
    [self.IDCardField resignFirstResponder];
    UIActionSheet * sexActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"请选择性别" otherButtonTitles:@"男",@"女", nil];
    sexActionSheet.tag = 777;
    [sexActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.tag == 777) {//选择性别
        if (buttonIndex == 1) {
            [self.sexButton setTitle:@"男" forState:UIControlStateNormal];
        }else if (buttonIndex == 2){
            [self.sexButton setTitle:@"女" forState:UIControlStateNormal];
        }
        isChange = YES;
    }else if (actionSheet.tag == 888){ //选择图片
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
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([QWGLOBALMANAGER judgeTheKeyboardInputModeIsEmojiOrNot:textField]) {
        return NO;
    }
    return YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (self.pharmacistImageType == JGImageTypeCertImgUrl) {
        self.addNormal.image = image;
        [self deleteNormalOptionHidden:NO];
    }else if (self.pharmacistImageType == JGImageTypePracticeImgUrl) {
        self.addSpecial.image = image;
        [self deleteSpecialOptionHidden:NO];
    }
    if (image) {
        
        if (!QWGLOBALMANAGER.configure.userToken) {
            return;
        }
        //传到服务器
        
        [SVProgressHUD showWithStatus:@"图片上传中..." maskType:SVProgressHUDMaskTypeClear];
        self.rightBarButton.enabled = NO;
        //        image = [UIImage compressImage:image];
        image = [image imageByScalingToMinSize];
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
        NSMutableArray *array = [NSMutableArray arrayWithObject:imageData];
        
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"type"] = @"5";
        
        __weak EditPharmacistViewController *weakSelf = self;
        [[HttpClient sharedInstance] uploaderImg:array params:setting withUrl:NW_uploadFile success:^(id responseObj) {
            [SVProgressHUD dismiss];
            weakSelf.rightBarButton.enabled = YES;
            if (!StrIsEmpty(StrFromObj(responseObj[@"body"][@"url"]))) {
                
                switch (self.pharmacistImageType) {
                    case JGImageTypeCertImgUrl:
                    {
                        self.saveNewModel.certImgUrl = responseObj[@"body"][@"url"];
                        isChange = YES;
                        haveNormal = YES;
                    }
                        break;
                    case JGImageTypePracticeImgUrl:
                    {
                        self.saveNewModel.practiceImgUrl = responseObj[@"body"][@"url"];
                        isChange = YES;
                        haveSpecial = YES;
                    }
                        break;
                    default:
                        break;
                }
            }
        } failure:^(HttpException *e) {
            [SVProgressHUD dismiss];
            weakSelf.rightBarButton.enabled = YES;
        } uploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            
        }];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ------选择有效期-------
- (IBAction)timeButtonClick:(id)sender {
    [self.nameField resignFirstResponder];
    [self.IDCardField resignFirstResponder];
    
    //如果haveSpecial = 1 ,那就说明有执业药师注册证书(就可以去修改有效期)
    
    if (haveSpecial) {
        [self chooseEndTime];
    }else{
        [SVProgressHUD showErrorWithStatus:@"请先添加执业药师注册证" duration:DURATION_SHORT];
        return;
    }
}

- (void)chooseEndTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:self.timeButton.titleLabel.text];
    [MADateView showDateViewWithDate:date Style:DateViewStyleDate CallBack:^(MyWindowClick buttonIndex, NSString *timeStr) {
        
        switch (buttonIndex) {
            case MyWindowClickForOK:
            {
                
                [self.timeButton setTitle:timeStr forState:UIControlStateNormal];
                isChange = YES;
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
}

- (void)rightBarButtonClick{
    
    [self hidenKeyboard];
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试!" duration:DURATION_SHORT];
        return;
    }
    //approveStatus 审核状态 (0:未审核,1:审核不通过,2:审核通过),
    if (self.memberModel) {
        NSString *appStatus = StrFromObj(self.memberModel.approveStatus);
        if ([appStatus isEqualToString:@"0"]) {
            [SVProgressHUD showErrorWithStatus:kWaring51 duration:DURATION_SHORT];
            return;
        }
    }
    
    if (StrIsEmpty([QWGLOBALMANAGER removeSpace:self.nameField.text]))
    {
        [SVProgressHUD showErrorWithStatus:@"请输入药师姓名" duration:DURATION_SHORT];
        return;
    }else if ([[QWGLOBALMANAGER removeSpace:self.nameField.text] length]> 10){
        [SVProgressHUD showErrorWithStatus:@"药师姓名不超过10个字" duration:DURATION_SHORT];
        return;
    }
    if (StrIsEmpty([QWGLOBALMANAGER removeSpace:self.IDCardField.text]))
    {
        [SVProgressHUD showErrorWithStatus:@"请输入药师身份证号" duration:DURATION_SHORT];
        return;
    }else if (!Chk18PaperId(self.IDCardField.text))
    {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的身份证号" duration:DURATION_SHORT];
        return;
    }
    
    if (haveNormal == NO) {
        [SVProgressHUD showErrorWithStatus:@"请上传药师资格证" duration:DURATION_SHORT];
        return;
    }
    
    if (haveSpecial) {
        if (StrIsEmpty(self.timeButton.currentTitle) || [self.timeButton.currentTitle isEqualToString:@"请选择有效期"]) {
            [SVProgressHUD showErrorWithStatus:@"请选择有效期" duration:DURATION_SHORT];
            return;
        }
    }
    
    if (self.memberModel) {
        BOOL nameChange = NO;
        if ([self.saveOldModel.name isEqualToString:[QWGLOBALMANAGER removeSpace:self.nameField.text]]) {
            nameChange = NO;
        }else{
            nameChange = YES;
        }
        
        BOOL sexChage = NO;
        if ([self.saveOldModel.sex isEqualToString:self.sexButton.currentTitle]) {
            sexChage = NO;
        }else{
            sexChage = YES;
        }
        
        BOOL cardNOChage = NO;
        if ([self.saveOldModel.cardNo isEqualToString:[QWGLOBALMANAGER removeSpace:self.IDCardField.text]]) {
            cardNOChage = NO;
        }else{
            cardNOChage = YES;
        }
        
        if (isChange == NO && nameChange == NO && sexChage == NO && cardNOChage == NO) {
            [SVProgressHUD showErrorWithStatus:kWaring49 duration:DURATION_SHORT];
            return;
        }
        
    }else{
        if (isChange == NO) {
            [SVProgressHUD showErrorWithStatus:kWaring49 duration:DURATION_SHORT];
            return;
        }
    }
    
    
    
    
    //校验是否有改动
    if (isChange == NO) {
        
    }

    [self updateInfo];
}

- (void)updateInfo
{
    if (!QWGLOBALMANAGER.configure.groupId) {
        return;
    }

    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"groupId"] = QWGLOBALMANAGER.configure.groupId;
    setting[@"name"] = [QWGLOBALMANAGER removeSpace:self.nameField.text];
    NSString *sex = [QWGLOBALMANAGER removeSpace:self.sexButton.titleLabel.text];
    if ([sex isEqualToString:@"女"]) {
        sex = @"1";
    }else if ([sex isEqualToString:@"男"]){
        sex = @"0";
    }
    setting[@"sex"] = sex;
    setting[@"cardNo"] = [QWGLOBALMANAGER removeSpace:self.IDCardField.text];
    
    NSString *certImgUrl = nil;
    if (!StrIsEmpty(self.saveNewModel.certImgUrl)) {
        certImgUrl = self.saveNewModel.certImgUrl;
    }else if (!StrIsEmpty(self.saveOldModel.certImgUrl)){
        certImgUrl = self.saveOldModel.certImgUrl;
    }
    setting[@"certImgUrl"] = certImgUrl;
    
    
    NSString *practiceImgUrl = nil;
    NSString *practiceEndTime = nil;
    if (haveSpecial) {
        if (!StrIsEmpty(self.saveNewModel.practiceImgUrl)) {
            practiceImgUrl = self.saveNewModel.practiceImgUrl;
            practiceEndTime = self.timeButton.currentTitle;
        }else{
            practiceImgUrl = self.saveOldModel.practiceImgUrl;
            practiceEndTime = self.timeButton.currentTitle;
        }
        setting[@"practiceImgUrl"] = practiceImgUrl;
        setting[@"practiceEndTime"] = practiceEndTime;
    }
    
    if (self.memberModel) {
        setting[@"id"] = self.memberModel.pid;
    }
    self.rightBarButton.enabled = NO;
    [Store updatePharmacistWithParams:setting success:^(id responseObj) {
        [SVProgressHUD dismiss];
        self.rightBarButton.enabled = YES;
        if ([responseObj[@"apiStatus"] integerValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功！审核通过前，药师信息不变" duration:DURATION_SHORT];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:responseObj[@"apiMessage"] duration:DURATION_SHORT];
        }
    } failure:^(HttpException *e) {
        [SVProgressHUD dismiss];
        self.rightBarButton.enabled = YES;
        NSLog(@"%@ -> %@",NSStringFromClass([self class]),e);
    }];
}

//- ( CameraMoveDirection )determineCameraDirectionIfNeeded:( CGPoint )translation
//
//{
//    
//    if (direction != kCameraMoveDirectionNone)
//        
//        return direction;
//    
//    // determine if horizontal swipe only if you meet some minimum velocity
//    
//    if (fabs(translation.x) > gestureMinimumTranslation)
//        
//    {
//        
//        BOOL gestureHorizontal = NO;
//        
//        if (translation.y == 0.0 )
//            
//            gestureHorizontal = YES;
//        
//        else
//            
//            gestureHorizontal = (fabs(translation.x / translation.y) > 5.0 );
//        
//        if (gestureHorizontal)
//            
//        {
//            
//            if (translation.x > 0.0 )
//                
//                return kCameraMoveDirectionRight;
//            
//            else
//                
//                return kCameraMoveDirectionLeft;
//            
//        }
//        
//    }
//    
//    // determine if vertical swipe only if you meet some minimum velocity
//    
//    else if (fabs(translation.y) > gestureMinimumTranslation)
//        
//    {
//        
//        BOOL gestureVertical = NO;
//        
//        if (translation.x == 0.0 )
//            
//            gestureVertical = YES;
//        
//        else
//            
//            gestureVertical = (fabs(translation.y / translation.x) > 5.0 );
//        
//        if (gestureVertical)
//            
//        {
//            
//            if (translation.y > 0.0 )
//                
//                return kCameraMoveDirectionDown;
//            
//            else
//                return kCameraMoveDirectionUp;
//        }
//        
//    }
//    return direction;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gesture shouldReceiveTouch:(UITouch *)touch
//{
//    CGPoint translation = [gesture locationInView:self.view];
//    
//    if (gesture.state == UIGestureRecognizerStateBegan )
//        
//    {
//        
//        direction = kCameraMoveDirectionNone;
//        
//    }
//    
//    else if (gesture.state == UIGestureRecognizerStateChanged && direction == kCameraMoveDirectionNone)
//        
//    {
//        
//        direction = [ self determineCameraDirectionIfNeeded:translation];
//        
//        // ok, now initiate movement in the direction indicated by the user's gesture
//        
//        switch (direction) {
//                
//            case kCameraMoveDirectionDown:
//                
//                NSLog (@ "Start moving down" );
//                return YES;
//                break ;
//                
//            case kCameraMoveDirectionUp:
//                return YES;
//                NSLog (@ "Start moving up" );
//                
//                break ;
//                
//            case kCameraMoveDirectionRight:
//                return NO;
//                NSLog (@ "Start moving right" );
//                
//                break ;
//                
//            case kCameraMoveDirectionLeft:
//                return NO;
//                NSLog (@ "Start moving left" );
//                
//                break ;
//                
//            default :
//                
//                break ;
//                
//        }
//        
//    }
//    
//    else if (gesture.state == UIGestureRecognizerStateEnded )
//        
//    {
//        
//    }
//    
//    return YES;
//}

#pragma mark --------隐藏键盘---------
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self hidenKeyboard];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self hidenKeyboard];
    return YES;
}

- (void)hidenKeyboard{
    [self.nameField resignFirstResponder];
    [self.IDCardField resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self hidenKeyboard];
}



@end
