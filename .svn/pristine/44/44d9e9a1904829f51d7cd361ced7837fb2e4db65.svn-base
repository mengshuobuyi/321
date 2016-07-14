//
//  ApothecaryViewController.m
//  wenYao-store
//
//  Created by qwfy0006 on 15/4/2.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "ApothecaryViewController.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "SBJson.h"
#import "SVProgressHUD.h"
#import "SJAvatarBrowser.h"
#import "UIImageView+WebCache.h"
#import "Store.h"

@interface ApothecaryViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UITextField *text_apothecarName;
@property (strong, nonatomic) IBOutlet UITextField *text_idCard;
@property (strong, nonatomic) IBOutlet UIImageView *img_zigecard;
@property (strong, nonatomic) IBOutlet UILabel *lbl_sex;
@property (strong, nonatomic) IBOutlet UIImageView *img_zhiyecard;
@property (strong, nonatomic) IBOutlet UIButton *btn_chosetime;
@property (strong, nonatomic) IBOutlet UIView *view_bgone;
@property (strong, nonatomic) IBOutlet UIView *view_bgtwo;
@property (strong, nonatomic) IBOutlet UIButton *btn_deleteone;
@property (strong, nonatomic) IBOutlet UIImageView *img_deleteone;
@property (strong, nonatomic) IBOutlet UIButton *btn_deletetwo;
@property (strong, nonatomic) IBOutlet UIImageView *img_deletetwo;
@property (strong, nonatomic) IBOutlet UIDatePicker *datepicker;

@property (strong, nonatomic) NSString *imgzige_url;
@property (strong, nonatomic) NSString *imgzhiye_url;
@property (strong, nonatomic) NSString *pickind;
@property (strong, nonatomic) NSString *defaulttime;
@property (strong, nonatomic) NSString *pid;

- (IBAction)choseSexAction:(id)sender;
- (IBAction)chosetimeAction:(id)sender;
- (IBAction)finishAction:(id)sender;
- (IBAction)cancelChoseAction:(id)sender;
- (IBAction)surechoseAction:(id)sender;
- (IBAction)delete_oneaction:(id)sender;
- (IBAction)deletetwoAction:(id)sender;

@end

@implementation ApothecaryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"编辑药师信息";
    [self chosePhoto];
    [self setUpForDismissKeyboard];
    NSDate *datetime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 为日期格式器设置格式字符串
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    // 使用日期格式器格式化日期、时间
    self.defaulttime = [dateFormatter stringFromDate:datetime];
    [self.btn_chosetime setTitle:self.defaulttime forState:UIControlStateNormal];
    [self.btn_chosetime setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0f] forState:UIControlStateNormal];
    UITapGestureRecognizer *canceltime = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(canceltime)];
    [self.view_bgtwo addGestureRecognizer:canceltime];
    self.view_bgtwo.userInteractionEnabled = YES;
    
    if ([QWUserDefault getObjectBy:REGISTER_JG_PAPOTHECARY]) {
        NSDictionary *Infodic = [QWUserDefault getObjectBy:REGISTER_JG_PAPOTHECARY];
        if (Infodic[@"pid"]) {
            self.pid = Infodic[@"pid"];
        }
        if (Infodic[@"name"] ) {
            self.text_apothecarName.text = Infodic[@"name"];
        }
        if (Infodic[@"sex"]) {
            if ([Infodic[@"sex"] isEqualToString:@"0"]) {
                self.lbl_sex.text =@"男";
            }else{
                self.lbl_sex.text= @"女";
            }
        }
        
        if (Infodic[@"cardNo"]) {
            self.text_idCard.text = Infodic[@"cardNo"];
        }
        if (Infodic[@"certImgUrl"]) {
            [self.img_zigecard setImageWithURL:[NSURL URLWithString:Infodic[@"certImgUrl"]] placeholderImage:nil];
            self.imgzige_url = Infodic[@"certImgUrl"];
            self.img_deleteone.hidden = NO;
            self.btn_deleteone.hidden = NO;
        }
        if (Infodic[@"practiceImgUrl"]) {
            [self.img_zhiyecard setImageWithURL:[NSURL URLWithString:Infodic[@"practiceImgUrl"]] placeholderImage:nil];
            self.imgzhiye_url = Infodic[@"practiceImgUrl"];
            self.img_deletetwo.hidden = NO;
            self.btn_deletetwo.hidden = NO;
        }
        if (Infodic[@"practiceEndTime"]) {
            [self.btn_chosetime setTitle:Infodic[@"practiceEndTime"] forState:UIControlStateNormal];
            [self.btn_chosetime setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0f] forState:UIControlStateNormal];
        }
    }
}

-(void)chosePhoto{
    self.img_zhiyecard.userInteractionEnabled = YES;
    self.img_zigecard.userInteractionEnabled = YES;
    UITapGestureRecognizer  *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addzhiyecard)];
    [self.img_zhiyecard addGestureRecognizer:recognizer];
    UITapGestureRecognizer  *recognizertwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addzigecard)];
    [self.img_zigecard addGestureRecognizer:recognizertwo];
}

#pragma mark ====
#pragma mark ==== 职业药师注册证

-(void)addzhiyecard{
    if (self.btn_deletetwo. hidden == YES) {
        
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:(id)self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"拍照", @"我的相册",nil];
        self.pickind = @"zhiye";
        actionSheet.tag = 101;
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
    }else{
        [SJAvatarBrowser showImage:self.img_zhiyecard];
    }
}

#pragma mark ====
#pragma mark ==== 药师资格证

-(void)addzigecard{
    [self.text_idCard resignFirstResponder];
    [self.text_apothecarName resignFirstResponder];
    if (self.btn_deleteone.hidden == YES) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:(id)self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"拍照", @"我的相册",nil];
        self.pickind = @"zige";
        actionSheet.tag = 101;
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
    }else{
        [SJAvatarBrowser showImage:self.img_zigecard];
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 101) {
        
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
    }else{
        
        if (buttonIndex == 0) {
            self.lbl_sex .text =@"男";
        }else if(buttonIndex == 1){
            self.lbl_sex .text =@"女";
            
        }
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    /**
     *1.通过相册和相机获取的图片都在此代理中
     *
     *2.图片选择已完成,在此处选择传送至服务器
     */
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    CGRect bounds = CGRectMake(0, 0, APP_W, APP_W);
    UIGraphicsBeginImageContext(bounds.size);
    [image drawInRect:bounds];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (image) {
        //传到服务器
        if ([self.pickind isEqualToString:@"zige"]) {
            [self.img_zigecard setImage: image];
            self.btn_deleteone.hidden = NO;
            self.img_deleteone.hidden = NO;
        }else{
            [self.img_zhiyecard setImage: image];
            self.btn_deletetwo.hidden = NO;
            self.img_deletetwo.hidden = NO;
        }
        
        NSData * imageData = UIImageJPEGRepresentation(image, 0.5);
        
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"type"] = @(5);
        setting[@"token"] = @"";
        
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:imageData];
        
        [[HttpClient sharedInstance] uploaderImg:array params:setting withUrl:NW_uploadFile success:^(id responseObj) {
            
            if ([self.pickind isEqualToString:@"zige"]) {
                self.imgzige_url =  responseObj[@"body"][@"url"];
            }else{
                self.imgzhiye_url =  responseObj[@"body"][@"url"];
            }

            
        } failure:^(HttpException *e) {
            
            
        } uploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            
        }];
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark ====
#pragma mark ==== 点击空白 收起键盘

- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognize{
    //此method会将self.view里所有的subview的first responder都resign掉
    [UIView animateWithDuration:1 animations:^{
        
    } completion:^(BOOL finished) {
    }];
    [self.view endEditing:YES];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.text_apothecarName) {
        [self.text_apothecarName resignFirstResponder];
        
    }else{
        [self.text_idCard resignFirstResponder];
    }
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark ====
#pragma mark ==== 选择性别

- (IBAction)choseSexAction:(id)sender {
    [self.text_idCard resignFirstResponder];
    [self.text_apothecarName resignFirstResponder];
    UIActionSheet *sexsheet = [[UIActionSheet alloc] initWithTitle:@"选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"男" otherButtonTitles:@"女", nil];
    [sexsheet showInView:self.view];
}

#pragma mark ====
#pragma mark ==== 选择有效期

- (IBAction)chosetimeAction:(id)sender {
    [self.text_idCard resignFirstResponder];
    [self.text_apothecarName resignFirstResponder];
    self.view_bgone.hidden = NO;
    self.view_bgtwo.hidden = NO;
}

#pragma mark ====
#pragma mark ==== 完成action

- (IBAction)finishAction:(id)sender {
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"groupId"] = StrFromObj([[QWUserDefault getObjectBy:REGISTER_JG_REGISTERID] objectForKey:@"groupId"]);
    //1.药师姓名不能超过10个字
    if ([self.text_apothecarName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入药师姓名" duration:DURATION_SHORT];
        return;
    }else if ([self.text_apothecarName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 10) {
        [SVProgressHUD showErrorWithStatus:@"药师姓名不能超过10个字" duration:DURATION_SHORT];
        return;
    }else{
        setting[@"name"] = StrFromObj(self.text_apothecarName.text) ;
    }
    
    //2.校验性别
    
    if ([self.lbl_sex.text isEqualToString:@"男"]) {
        setting[@"sex"] = @"0";
    }else{
        setting[@"sex"] = @"1";
    }
    
    //3.校验身份证号码
    if ([self.text_idCard.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入药师身份证号" duration:DURATION_SHORT];
        return;
    }
    
    BOOL ret = [QWGlobalManager validateIDCardNumber:[self.text_idCard.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    if (ret) {
        setting[@"cardNo"] = StrFromObj([self.text_idCard.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]);
    }else{
        [SVProgressHUD showErrorWithStatus:@"请输入正确的药师身份证号" duration:DURATION_SHORT];
        return;
    }
    
    
    //4.资格证书
    if (self.imgzige_url.length > 0) {
        setting[@"certImgUrl"] = StrFromObj(self.imgzige_url) ;
    }else{
        [SVProgressHUD showErrorWithStatus:@"请上传药师资格证" duration:DURATION_SHORT];
        return;
    }
    //////////////////// 非必填项!
    //5.执业证书
    if (self.imgzhiye_url.length > 0) {
        setting[@"practiceImgUrl"] = StrFromObj(self.imgzhiye_url);
        //6.有效日期
        if (self.btn_chosetime.titleLabel.text) {
            setting[@"practiceEndTime"] = StrFromObj(self.btn_chosetime.titleLabel.text) ;
            
        }
        
    }
    if(self.pid.length > 0)
    {
        setting[@"id"] = StrFromObj(self.pid);
    }
    
    [Store SavePharmacistWithParams:setting success:^(id obj) {
        if ([obj[@"apiStatus"] intValue] == 0) {
            setting[@"pid"] = obj[@"id"];
            [QWUserDefault setObject:setting key:REGISTER_JG_PAPOTHECARY];
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"] duration:DURATION_SHORT];
        }
        
    } failure:^(HttpException *e) {
        
    }];

}
- (IBAction)cancelChoseAction:(id)sender {
    self.view_bgone.hidden = YES;
    self.view_bgtwo.hidden = YES;
}


-(void)canceltime{
    self.view_bgone.hidden = YES;
    self.view_bgtwo.hidden = YES;
    
}
- (IBAction)surechoseAction:(id)sender {
    
    NSDate *time = [self.datepicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 为日期格式器设置格式字符串
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    // 使用日期格式器格式化日期、时间
    NSString *destDateString = [dateFormatter stringFromDate:time];
    [self.btn_chosetime setTitle:destDateString forState:UIControlStateNormal];
    [self.btn_chosetime setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0f] forState:UIControlStateNormal];
    self.view_bgone.hidden = YES;
    self.view_bgtwo.hidden = YES;
}


- (IBAction)delete_oneaction:(id)sender {
    if (self.btn_deleteone.hidden == NO) {
        self.btn_deleteone.hidden =YES;
        self.img_deleteone.hidden = YES;
        self.img_zigecard.image = [UIImage imageNamed:@"添加图片"];
        self.imgzige_url =@"";
    }
}
- (IBAction)deletetwoAction:(id)sender {
    if (self.btn_deletetwo.hidden == NO) {
        self.btn_deletetwo.hidden = YES;
        self.img_deletetwo.hidden = YES;
        self.img_zhiyecard.image = [UIImage imageNamed:@"添加图片"];
        self.imgzhiye_url =@"";

    }
}
@end