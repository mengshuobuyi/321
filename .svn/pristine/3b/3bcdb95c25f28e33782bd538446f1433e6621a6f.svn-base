//
//  AddlenseViewController.m
//  wenYao-store
//
//  Created by qwfy0006 on 15/4/2.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "AddlenseViewController.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "SBJson.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "SJAvatarBrowser.h"
#import "Store.h"

@interface AddlenseViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *timeView;
@property (strong, nonatomic) IBOutlet UIDatePicker *timepicker;
@property (strong, nonatomic) IBOutlet UIView *bg_time;

@property (strong, nonatomic) UITextField *text_certifiName;
@property (strong, nonatomic) UIImageView *imgview;
@property (strong, nonatomic) UIButton    *btn_datechose;
@property (strong, nonatomic) NSString    *strInfoOne;
@property (strong, nonatomic) NSString    *url_img;
@property (strong, nonatomic) UIButton    *btn_deletephoto;
@property (strong, nonatomic) UIImageView *img_deletePhoto;
@property (strong, nonatomic) NSString    *defaulttime;
@property (strong, nonatomic) NSString    *idstr;

- (IBAction)sureTime:(id)sender;
- (IBAction)cancelTiime:(id)sender;

@end

@implementation AddlenseViewController

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
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveInfoAction)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    self.text_certifiName.delegate = self;
    
    //    添加时间点击事件
    UITapGestureRecognizer *canceltap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideTimeView)];
    [self.bg_time addGestureRecognizer:canceltap];
    self.view.userInteractionEnabled = YES;
    self.bg_time.userInteractionEnabled = YES;
    
    if (self.lenseclass == addlense) {
        if (self.lensename) {
            self.title = self.lensename;
        }else{
            self.title =@"添加执照";
        }
    }else if (self.lenseclass == shop_typeone){
        self.title = @"药品经营许可证";
    }else if (self.lenseclass == shop_typetwo){
        self.title =@"营业执照";
    }else if (self.lenseclass == shop_typethree){
        self.title = @"GSP认证执照";
    }else if (self.lenseclass == medical_typeone){
        self.title = @"医疗机构执业许可证";
    }
    self.text_certifiName = [[UITextField alloc] init];
    self.text_certifiName.textAlignment = NSTextAlignmentRight;
    self.text_certifiName.borderStyle = UITextBorderStyleNone;
    self.text_certifiName.clearButtonMode = UITextFieldViewModeWhileEditing;
    //    时间选择按钮
    self.btn_datechose = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_datechose.backgroundColor = [UIColor clearColor];
    self.btn_datechose.titleLabel.font = fontSystem(kFontS4);
    [self.btn_datechose setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0f] forState:UIControlStateNormal];
    
    [self.btn_datechose addTarget:self action:@selector(choseTime) forControlEvents:UIControlEventTouchUpInside];
    
    self.img_deletePhoto = [[UIImageView alloc] init];
    self.img_deletePhoto.backgroundColor = [UIColor clearColor];
    self.img_deletePhoto.image = [UIImage imageNamed:@"删除"];
    //    删除图片按钮
    self.btn_deletephoto = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_deletephoto.backgroundColor = [UIColor clearColor];
    [self.btn_deletephoto addTarget:self action:@selector(deletephoto) forControlEvents:UIControlEventTouchUpInside];
    self.btn_deletephoto.backgroundColor = [UIColor clearColor];
    //    [self.btn_deletephoto setImage:[UIImage imageNamed:@"删除@2x.png"] forState:UIControlStateNormal];
    self.btn_deletephoto.hidden = YES;
    self.img_deletePhoto.hidden = YES;
    self.imgview = [[UIImageView alloc] init];
    self.imgview.image = [UIImage imageNamed:@"添加图片"];
    self.imgview.userInteractionEnabled = YES;
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapgest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addlenseimgAction)];
    [self.imgview addGestureRecognizer:tapgest];
    self.text_certifiName.placeholder = @"必填";
    
    if ([QWUserDefault getObjectBy:[NSString stringWithFormat:@"%@/cerfiti/%@",[QWUserDefault getStringBy:QUICK_REGISTERACCOUNT], self.lensename]])
    {
        NSDictionary *dic = [QWUserDefault getObjectBy:[NSString stringWithFormat:@"%@/cerfiti/%@",[QWUserDefault getStringBy:QUICK_REGISTERACCOUNT], self.lensename]];
        
        if ([self.title isEqualToString:@"营业执照"]) {
            self.text_certifiName.text = dic[@"certifiNo"];
        }else{
            self.text_certifiName.text = self.lensename;
        }
        [self.btn_datechose setTitle:dic[@"validEndDate"] forState:UIControlStateNormal];
        [self.imgview setImageWithURL:[NSURL URLWithString:dic[@"imageName"]] placeholderImage:nil];
        
        self.url_img= dic[@"imageName"];
        self.btn_deletephoto.hidden = NO;
        self.img_deletePhoto.hidden = NO;
        self.idstr = dic[@"id"];
    }
    [self setviewcontent];
    [self setUpForDismissKeyboard];
    
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
    [self.text_certifiName resignFirstResponder];
    return YES;
}

#pragma mark ====
#pragma mark ==== 选择有效期

-(void)choseTime{
    [self.text_certifiName resignFirstResponder];
    [self.view addSubview:self.bg_time];
}

#pragma mark ====
#pragma mark ==== 设置界面内容

-(void)setviewcontent{
    if (self.lenseclass == shop_typetwo) {
        UIView *contentV = [[UIView alloc] initWithFrame:CGRectMake(10, 10,  [UIScreen mainScreen].applicationFrame.size.width - 20, 135.0f)];
        contentV.backgroundColor = [UIColor whiteColor];
        UILabel *lbl_line = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, contentV.frame.size.width,1)];
        lbl_line.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:239/255.0f alpha:1.0f];
        UILabel *lbl_lenseName= [[UILabel alloc] initWithFrame:CGRectMake(5, 5,200,35)];
        lbl_lenseName.backgroundColor = [UIColor clearColor];
        lbl_lenseName.text = self.title;
        lbl_lenseName.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f];
        UILabel *lbl_line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 89, contentV.frame.size.width,1)];
        lbl_line2.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:239/255.0f alpha:1.0f];;
        UILabel *lbl_lensenum= [[UILabel alloc] initWithFrame:CGRectMake(5, 50,200,35)];
        lbl_lensenum.backgroundColor = [UIColor clearColor];
        lbl_lensenum.text = @"营业执照注册号";
        lbl_lensenum.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f];
        self.text_certifiName.frame =  CGRectMake(120, 50,175,35);
        UILabel *lbl_datetitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 95,170,35)];
        lbl_datetitle.backgroundColor = [UIColor clearColor];
        lbl_datetitle.text = @"有效期至";
        lbl_datetitle.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f];
        self.btn_datechose .Frame=CGRectMake(200, 95,80,35);
        
        if (![QWUserDefault getObjectBy:[NSString stringWithFormat:@"%@/cerfiti/%@",[QWUserDefault getStringBy:QUICK_REGISTERACCOUNT], self.lensename]]){
            NSDate *datetime = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            // 为日期格式器设置格式字符串
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            // 使用日期格式器格式化日期、时间
            self.defaulttime = [dateFormatter stringFromDate:datetime];
            [self.btn_datechose setTitle:self.defaulttime forState:UIControlStateNormal];
            self.btn_deletephoto.hidden = YES;
            self.img_deletePhoto.hidden = YES;
        }
        self.imgview.frame = CGRectMake(245, 7, 30, 30);
        self.img_deletePhoto.frame = CGRectMake(268, 0, 15, 15);
        self.btn_deletephoto.frame = CGRectMake(268, 0, 15 , 40);
        contentV.userInteractionEnabled = YES;
        
        [contentV addSubview:self.text_certifiName];
        [contentV addSubview:self.btn_datechose];
        [contentV addSubview:lbl_lenseName];
        [contentV addSubview:lbl_datetitle];
        [contentV addSubview:lbl_lensenum];
        [contentV addSubview:lbl_line];
        [contentV addSubview:lbl_line2];
        [contentV addSubview: self.imgview];
        [contentV addSubview:self.img_deletePhoto];
        [contentV addSubview:self.btn_deletephoto];
        
        [self.view addSubview:contentV];
    }else if(self.lenseclass == addlense){
        UIView *contentV = [[UIView alloc] initWithFrame:CGRectMake(10, 10,  [UIScreen mainScreen].applicationFrame.size.width - 20, 135.0f)];
        contentV.backgroundColor = [UIColor whiteColor];
        UILabel *lbl_line = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, contentV.frame.size.width,1)];
        lbl_line.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:239/255.0f alpha:1.0f];;
        UILabel *lbl_lenseName= [[UILabel alloc] initWithFrame:CGRectMake(5, 5,200,35)];
        lbl_lenseName.backgroundColor = [UIColor clearColor];
        lbl_lenseName.text = @"执照名称";
        lbl_lenseName.textColor =[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f];
        UILabel *lbl_line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 89, contentV.frame.size.width,1)];
        lbl_line2.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:239/255.0f alpha:1.0f];;
        UILabel *lbl_lensenum= [[UILabel alloc] initWithFrame:CGRectMake(5, 50,200,35)];
        lbl_lensenum.backgroundColor = [UIColor clearColor];
        lbl_lensenum.text = @"上传执照";
        lbl_lensenum.textColor =[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f];
        self.text_certifiName.frame =CGRectMake(170, 5,105,35);
        UILabel *lbl_datetitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 95,170,35)];
        lbl_datetitle.backgroundColor = [UIColor clearColor];
        lbl_datetitle.text = @"有效期至";
        lbl_datetitle.textColor =[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f];
        self.btn_datechose .Frame = CGRectMake(200, 95,80,35);
        
        if (![QWUserDefault getObjectBy:[NSString stringWithFormat:@"%@/cerfiti/%@",[QWUserDefault getStringBy:QUICK_REGISTERACCOUNT], self.lensename]]){
            NSDate *datetime = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            // 为日期格式器设置格式字符串
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            // 使用日期格式器格式化日期、时间
            self.defaulttime = [dateFormatter stringFromDate:datetime];
            [self.btn_datechose setTitle:self.defaulttime forState:UIControlStateNormal];
            self.btn_deletephoto.hidden = YES;
            self.img_deletePhoto.hidden = YES;
        }
        self.imgview.frame = CGRectMake(245, 52, 30, 30);
        self.img_deletePhoto.frame = CGRectMake(268, 45, 15, 15);
        self.btn_deletephoto.frame = CGRectMake(268, 40, 15, 40);
        contentV.userInteractionEnabled = YES;
        
        [contentV addSubview:self.text_certifiName];
        [contentV addSubview:self.btn_datechose];
        [contentV addSubview:lbl_lenseName];
        [contentV addSubview:lbl_datetitle];
        [contentV addSubview:lbl_lensenum];
        [contentV addSubview:lbl_line];
        [contentV addSubview:lbl_line2];
        [contentV addSubview:self.imgview];
        [contentV addSubview:self.img_deletePhoto];
        [contentV addSubview:self.btn_deletephoto];
        [self.view addSubview:contentV];
    }else{
        UIView *contentV = [[UIView alloc] initWithFrame:CGRectMake(10, 10,  [UIScreen mainScreen].applicationFrame.size.width - 20, 90.0f)];
        contentV.backgroundColor = [UIColor whiteColor];
        UILabel *lbl_line = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, contentV.frame.size.width,1)];
        lbl_line.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:239/255.0f alpha:1.0f];;
        UILabel *lbl_lenseName= [[UILabel alloc] initWithFrame:CGRectMake(5, 5,200,35)];
        lbl_lenseName.backgroundColor = [UIColor clearColor];
        lbl_lenseName.text = self.title;
        lbl_lenseName.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f];
        self.imgview.frame = CGRectMake(245,7,30,30);
        self.img_deletePhoto.frame = CGRectMake(268, 0, 15, 15);
        self.btn_deletephoto.frame = CGRectMake(268, 0  , 5, 40);
        UILabel *lbl_datetitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 50,170,35)];
        lbl_datetitle.backgroundColor = [UIColor clearColor];
        lbl_datetitle.text = @"有效期至";
        lbl_datetitle.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f];
        self.btn_datechose .Frame=CGRectMake(200, 50,80,35);
        
        if (![QWUserDefault getObjectBy:[NSString stringWithFormat:@"%@/cerfiti/%@",[QWUserDefault getStringBy:QUICK_REGISTERACCOUNT], self.lensename]]){
            NSDate *datetime = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            // 为日期格式器设置格式字符串
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            // 使用日期格式器格式化日期、时间
            self.defaulttime = [dateFormatter stringFromDate:datetime];
            [self.btn_datechose setTitle:self.defaulttime forState:UIControlStateNormal];
            self.btn_deletephoto.hidden = YES;
            self.img_deletePhoto.hidden = YES;
        }
        
        contentV.userInteractionEnabled = YES;
        [contentV addSubview:self.btn_datechose];
        [contentV addSubview:lbl_datetitle];
        [contentV addSubview:lbl_lenseName];
        [contentV addSubview:lbl_line];
        [contentV addSubview: self.imgview];
        [contentV addSubview:self.img_deletePhoto];
        [contentV addSubview:self.btn_deletephoto];
        [self.view addSubview:contentV];
        
    }
}

#pragma mark ====
#pragma mark ==== 添加证书照片

-(void)addlenseimgAction{
    [self.text_certifiName resignFirstResponder];
    if (self.btn_deletephoto.hidden == YES) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:(id)self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"拍照", @"我的相册",nil];
        actionSheet.tag = 101;
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
    }else{
        [SJAvatarBrowser showImage:self.imgview];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
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
        self.imgview.image = image;
        NSData * imageData = UIImageJPEGRepresentation(image, 0.5);
        
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"type"] = @(4);
        setting[@"token"] = @"";
        
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:imageData];
        
        [[HttpClient sharedInstance] uploaderImg:array params:setting withUrl:NW_uploadFile success:^(id responseObj) {
            
            if ([responseObj[@"apiStatus"] intValue] == 0) {
                
                self.url_img =  responseObj[@"body"][@"url"];
            }else
            {
                [SVProgressHUD showErrorWithStatus:responseObj[@"apiMessage"] duration:0.8f];
            }
            
        } failure:^(HttpException *e) {
            
        } uploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            
        }];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ====
#pragma mark ==== 上传执照信息的请求方法

-(void)saveInfoAction{
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"groupId"] = StrFromObj([[QWUserDefault getObjectBy:REGISTER_JG_REGISTERID] objectForKey:@"groupId"]);
    if (self.lenseclass == shop_typetwo) {
        setting[@"typeId"] =@"1";
        setting[@"certifiName"] = StrFromObj(self.title);
        if (self.url_img.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请上传营业执照图片"
                                      duration:DURATION_SHORT];
            return;
            
        }
        if([self.text_certifiName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length  == 0){
            [SVProgressHUD showErrorWithStatus:@"请输入营业执照注册号" duration:DURATION_SHORT];
            return;
        }
        
        if([self.text_certifiName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length  > 32){
            [SVProgressHUD showErrorWithStatus:@"请输入正确的营业执照注册号" duration:DURATION_SHORT];
            return;
        }
        setting[@"certifiNo"] = StrFromObj([self.text_certifiName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]);
    }else if (self.lenseclass == shop_typeone) {
        setting[@"typeId"] = @"3";
        setting[@"certifiName"] = StrFromObj(self.title);
        setting[@"certifiNo"] = @"";
    }else if (self.lenseclass == shop_typethree) {
        setting[@"certifiName"] = StrFromObj(self.title);
        setting[@"certifiNo"] = @"";
        setting[@"typeId"] = @"6";
    }else if (self.lenseclass == addlense ) {
        if ([[self.text_certifiName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"组织机构代码证"]) {
            setting[@"typeId"] = @"2";
            setting[@"certifiName"] = StrFromObj(self.text_certifiName.text);
            setting[@"certifiNo"] = @"";
        }else  if ([[self.text_certifiName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"医疗器械许可证"]) {
            setting[@"typeId"] = @"4";
            setting[@"certifiName"] = StrFromObj(self.text_certifiName.text);
            setting[@"certifiNo"] = @"";
        }else if ([[self.text_certifiName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"食品流通许可证"]) {
            setting[@"typeId"] = @"5";
            setting[@"certifiName"] = StrFromObj(self.text_certifiName.text);
            setting[@"certifiNo"] = @"";
        }else if ([[self.text_certifiName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"税务登记证"]) {
            setting[@"typeId"] = @"7";
            setting[@"certifiName"] = StrFromObj([self.text_certifiName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]);
            setting[@"certifiNo"] = @"";
        }else{
            setting[@"typeId"] = @"9";
            setting[@"certifiName"] = StrFromObj([self.text_certifiName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]);
            setting[@"certifiNo"] = @"";
        }
    }else{
        setting[@"typeId"] = @"10";
        setting[@"certifiName"] = @"医疗机构执业许可证";
        setting[@"certifiNo"] = @"";
    }
    if (self.url_img.length > 0) {
        setting [@"imageName"] = StrFromObj(self.url_img);
    }else{
        if([[self.text_certifiName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]length] > 0){
            [SVProgressHUD showErrorWithStatus:@"请上传执照图片"
                                      duration:DURATION_SHORT];
        }else if([[setting[@"certifiName"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0){
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请上传%@图片", setting[@"certifiName"]]
                                      duration:DURATION_SHORT];
        }else{
            [SVProgressHUD showErrorWithStatus:@"请上传执照图片"
                                      duration:DURATION_SHORT];
        }
        return;
    }
    if([[setting[@"certifiName"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0){
        [SVProgressHUD showErrorWithStatus:@"请输入添加的执照名称"
                                  duration:DURATION_SHORT];
        return;
    }
    setting[@"validEndDate"] = StrFromObj([self.btn_datechose.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]);
    if (self.idstr > 0) {
        setting[@"id"] = StrFromObj(self.idstr);
    }
    
    [Store SavecerfitiWithParams:setting success:^(id obj) {
        
        if ([obj[@"apiStatus"] intValue] == 0) {
            
            setting[@"id"]= obj[@"id"];
            [self.finishlenseInfoDelegate finishlenseInfoDelegate];
            [QWUserDefault setObject:setting key:[NSString stringWithFormat:@"%@/cerfiti/%@",[QWUserDefault getStringBy:QUICK_REGISTERACCOUNT], setting[@"certifiName"]]];
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"] duration:DURATION_SHORT];
        }
        
    } failure:^(HttpException *e) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//选择有效期
- (IBAction)sureTime:(id)sender {
    
    NSDate *time = [self.timepicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 为日期格式器设置格式字符串
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    // 使用日期格式器格式化日期、时间
    NSString *destDateString = [dateFormatter stringFromDate:time];
    [self.btn_datechose setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [self.btn_datechose setTitle:destDateString forState:UIControlStateNormal];
    [self.bg_time removeFromSuperview];
}

//取消选择时间
- (IBAction)cancelTiime:(id)sender {
    [self.bg_time removeFromSuperview];
}

-(void)hideTimeView{
    [self.bg_time removeFromSuperview];
    
}

//删除图片
-(void)deletephoto{
    if (self.btn_deletephoto.hidden == NO) {
        self.btn_deletephoto.hidden = YES;
        self.img_deletePhoto.hidden = YES;
        self.imgview.image = [UIImage imageNamed:@"添加图片"];
        self.url_img = @"";
    }
}

@end