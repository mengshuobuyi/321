//
//  MyBrandViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/7.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "MyBrandViewController.h"
#import "UIImage+Ex.h"
#import "Circle.h"
#import "CircleModel.h"
#import "ProfessionTempletView.h"

@interface MyBrandViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *registerImageView;

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (weak, nonatomic) IBOutlet UIView *reUploadView;

@property (weak, nonatomic) IBOutlet UILabel *reUploadLabel;

- (IBAction)uploadAction:(id)sender;

- (IBAction)commitAction:(id)sender;

- (IBAction)showTempletAction:(id)sender;

@property (strong, nonatomic) NSString *registerImageUrl;


@end

@implementation MyBrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的品牌";
    
    self.registerImageUrl = self.registerUrl;
    [self configureUI];
    [self.registerImageView setImageWithURL:[NSURL URLWithString:self.registerImageUrl]];
    
    self.reUploadView.layer.cornerRadius = 3.0;
    self.reUploadView.layer.masksToBounds = YES;
    
    [self isShowReUploadView];
    
}

#pragma mark ---- 判断是否有图片 ----
- (void)isShowReUploadView
{
    if (StrIsEmpty(self.registerImageUrl))
    {
        self.reUploadView.hidden = YES;
        self.reUploadLabel.hidden = YES;
    }else
    {
        self.reUploadView.hidden = NO;
        self.reUploadLabel.hidden = NO;
    }
}

- (void)configureUI
{
    if ([self.expertType integerValue] == 1)
    {
        //药师
        self.titleLabel.text = @"请上传您的注册证";
        self.contentLabel.text = @"注册证";
        self.tipsLabel.text = @"注：注册证是证明药师在此品牌公司工作，如不上传此证明，申请认证的药师在圈子里将无品牌公司名牌展示。";
        
    }else if ([self.expertType integerValue] == 2)
    {
        //营养师
        self.titleLabel.text = @"请上传您的挂靠证明";
        self.contentLabel.text = @"挂靠证明";
        self.tipsLabel.text = @"注：品牌营养师证明是证明营养师在此品牌公司工作，如不上传此证明，申请认证的营养师在圈子里将无品牌公司名牌展示。";
    }
    
    self.bgView.backgroundColor = [UIColor whiteColor];
    
    self.registerImageView.layer.cornerRadius = 3.0;
    self.registerImageView.layer.masksToBounds = YES;
    self.registerImageView.layer.borderColor = RGBHex(qwColor9).CGColor;
    self.registerImageView.layer.borderWidth = 1.0;
    
    self.commitBtn.layer.cornerRadius = 3.0;
    self.commitBtn.layer.masksToBounds = YES;
}

#pragma mark ---- 选择营养师证图片 ----
- (IBAction)uploadAction:(id)sender
{
    NSString *imgUrl = self.registerImageUrl;
    [self clickImageViewWith:imgUrl];
}

- (void)clickImageViewWith:(NSString *)imgUrl
{
    // 上传图片
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
        return;
    }else{
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照设置图片", @"从相册选择图片", nil];
        [actionSheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerControllerSourceType sourceType;
    
    if (buttonIndex == 2) {
        //取消
        return;
    }else{
        if (buttonIndex == 0) {
            //拍照
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }else if (buttonIndex == 1){
            //相册
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
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
                self.registerImageUrl = imageUrl;
                [self.registerImageView setImageWithURL:[NSURL URLWithString:self.registerImageUrl]];
                [self isShowReUploadView];
            }else{
                [SVProgressHUD showErrorWithStatus:responseObj[@"apiMessage"] duration:0.8f];
            }
            
        } failure:^(HttpException *e) {
        } uploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        }];
    }
}


#pragma mark ---- 提交资料 ----
- (IBAction)commitAction:(id)sender
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
        return;
    }
    
    if (StrIsEmpty(self.registerImageUrl)) {
        
        if ([self.expertType integerValue] == 1)
        {
            [SVProgressHUD showErrorWithStatus:@"请上传您的注册证，谢谢！" duration:DURATION_SHORT];
        }else if ([self.expertType integerValue] == 2)
        {
            [SVProgressHUD showErrorWithStatus:@"请上传您的挂靠证明，谢谢！" duration:DURATION_SHORT];
        }
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    
    if ([self.expertType integerValue] == 1) {
        setting[@"expertType"] = @"1";
    }else if ([self.expertType integerValue] == 2){
        setting[@"expertType"] = @"2";
    }
    
    setting[@"certRegistUrl"] = StrFromObj(self.registerImageUrl);
    setting[@"status"] = @"4";
    
    [Circle TeamUploadCertInfoWithParams:setting success:^(id obj) {
        
        BaseAPIModel *model = [BaseAPIModel parse:obj];
        if ([model.apiStatus integerValue] == 0) {
            //弹出提示框 知道了
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"申请成功，我们将会在1周内回复您申请结果，请耐心等待，谢谢！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
            [alert show];
        }else{
            [SVProgressHUD showErrorWithStatus:model.apiMessage];
        }
        
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ---- 显示参考样板 ----
- (IBAction)showTempletAction:(id)sender
{
    if ([self.expertType integerValue] == 1)
    {
        [[ProfessionTempletView sharedManagerWithIamge:@"bg_one_new"] show];
    }else if ([self.expertType integerValue] == 2)
    {
        [[ProfessionTempletView sharedManagerWithIamge:@"expert_brand_templet"] show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        if (self.myBrandViewControllerDelegate && [self.myBrandViewControllerDelegate respondsToSelector:@selector(changeMyBrand)]) {
            [self.myBrandViewControllerDelegate changeMyBrand];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
