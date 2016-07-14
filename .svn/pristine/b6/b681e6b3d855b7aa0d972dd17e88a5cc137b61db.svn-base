//
//  CorporationViewController.m
//  wenYao-store
//
//  Created by qwfy0006 on 15/4/2.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "CorporationViewController.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "SBJson.h"
#import "UIImageView+WebCache.h"
#import "SJAvatarBrowser.h"
#import "SVProgressHUD.h"
#import "Store.h"

@interface CorporationViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *img_delete;
@property (strong, nonatomic) IBOutlet UIImageView *img_card;
@property (strong, nonatomic) IBOutlet UITextField *lbl_name;
@property (strong, nonatomic) IBOutlet UITextField *lbl_cardNum;
@property (strong, nonatomic) IBOutlet UIButton *btn_delete;
@property (strong, nonatomic) NSString *url_img;
@property (strong, nonatomic) NSString *idstr;

- (IBAction)photodelete:(id)sender;

@end

@implementation CorporationViewController

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
    self.title = @"法人/企业负责人身份证";
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveInfoAction)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    UITapGestureRecognizer  *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addlenseimgAction)];
    
    if ([QWUserDefault getObjectBy:REGISTER_JG_CORPORATION]) {
        NSMutableDictionary * dic = [QWUserDefault getObjectBy:REGISTER_JG_CORPORATION];
        self.lbl_cardNum.text = [dic objectForKey:@"certifiNo"];
        self.lbl_name.text = [dic objectForKey:@"certifiName"];
        [self.img_card setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"imageName"]] placeholderImage:nil];
        self.btn_delete.hidden = NO;
        self.img_delete.hidden =NO;
        self.url_img = [dic objectForKey:@"imageName"];
        self.idstr = [dic objectForKey:@"id"];
    }
    
    self.img_card.userInteractionEnabled = YES;
    [self.img_card addGestureRecognizer:recognizer];
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
    if (textField == self.lbl_name) {
        [self.lbl_cardNum becomeFirstResponder];
        
    }else{
        [self.lbl_cardNum resignFirstResponder];
    }
    return YES;
}

+ (BOOL)validateIdentityCard:(NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

#pragma mark ====
#pragma mark ==== 保存法人信息

-(void)saveInfoAction{
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"groupId"] = StrFromObj([[QWUserDefault getObjectBy:REGISTER_JG_REGISTERID] objectForKey:@"groupId"]);
    setting[@"typeId"] =@"8";
    if (self.url_img.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请上传法人/企业负责人身份证" duration:DURATION_SHORT];
        return;
    }else{
        
        setting [@"imageName"] = StrFromObj(self.url_img);
    }
    setting[@"certifiName"] = StrFromObj([self.lbl_name.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]);
    if ([self.lbl_name.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入姓名" duration:DURATION_SHORT];
        return;
    }
    if ([self.lbl_name.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 10) {
        [SVProgressHUD showErrorWithStatus:@"法人姓名不超过10个字" duration:DURATION_SHORT];
        return;
    }
    setting[@"certifiNo"] = StrFromObj([self.lbl_cardNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]);
    if ([self.lbl_cardNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入身份证号码" duration:DURATION_SHORT];
        return;
    }
    BOOL ret = [QWGlobalManager validateIDCardNumber:[self.lbl_cardNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    if (ret) {
        setting[@"cardNo"] = StrFromObj([self.lbl_cardNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]);
    }else{
        [SVProgressHUD showErrorWithStatus:@"请输入18位身份证号，数字或字母" duration:DURATION_SHORT];
        return;
    }
    
    setting[@"validEndDate"] = @"";
    if (self.idstr > 0) {
        setting[@"id"]= StrFromObj(self.idstr);
    }
    
    [Store SavecerfitiWithParams:setting success:^(id obj) {
        
        if ([obj[@"apiStatus"] intValue] == 0) {
            setting[@"id"] = obj[@"id"];
            [QWUserDefault setObject:setting key:REGISTER_JG_CORPORATION];
            [self.finishcorporationInfoDelegate finishcorporationInfo:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
             [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"] duration:DURATION_SHORT];
        }
        
    } failure:^(HttpException *e) {
       
    }];
    
}

-(void)addlenseimgAction{
    [self.lbl_cardNum resignFirstResponder];
    [self.lbl_name resignFirstResponder];
    if (self.btn_delete.hidden == YES) {
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
        [SJAvatarBrowser showImage:self.img_card];
        
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
    
    //    UIImageView * imageView = (UIImageView *)[self.view viewWithTag:9999];
    //    imageView.image = image;
    if (image) {
        //传到服务器
        [self.img_card setImage:image];
        NSData * imageData = UIImageJPEGRepresentation(image, 0.5);
        
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"type"] = @(1);
        setting[@"token"] = @"";
        
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:imageData];
        
        [[HttpClient sharedInstance] uploaderImg:array params:setting withUrl:NW_uploadFile success:^(id responseObj) {
            
             self.url_img = responseObj[@"body"][@"url"];
            
        } failure:^(HttpException *e) {
            
        } uploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            
        }];
    }
    self.btn_delete.hidden = NO;
    self.img_delete.hidden = NO;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)photodelete:(id)sender {
    if (self.btn_delete.hidden == NO) {
        self.img_card.image = [UIImage imageNamed:@"添加图片"];
        self.btn_delete.hidden = YES;
        self.img_delete.hidden = YES;
        self.url_img = @"";
    }
}
@end