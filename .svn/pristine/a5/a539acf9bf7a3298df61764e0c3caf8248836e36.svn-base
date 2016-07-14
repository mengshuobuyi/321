//
//  NutritionCardViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/4/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "NutritionCardViewController.h"
#import "UIImage+Ex.h"
#import "Circle.h"
#import "NutritionTempletView.h"
#import "NutritionInfoOneViewController.h"
#import "ProfessionTempletView.h"

@interface NutritionCardViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

//营养师证
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *oneImageView;
@property (weak, nonatomic) IBOutlet UIImageView *twoImageView;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

//挂靠证明
@property (weak, nonatomic) IBOutlet UIView *twoBgView;
@property (weak, nonatomic) IBOutlet UIImageView *proveImageView;

@property (strong, nonatomic) NSString *imageOneUrl;
@property (strong, nonatomic) NSString *imageTwoUrl;
@property (strong, nonatomic) NSString *proveUrl;
@property (strong, nonatomic) NSString *selectImageType;

//参考样板
- (IBAction)templetAction:(id)sender;

//提交
- (IBAction)commitAction:(id)sender;

@end

@implementation NutritionCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"营养师认证";
    [self configureUI];
}

- (void)configureUI
{
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.twoBgView.backgroundColor = [UIColor whiteColor];
    
    self.oneImageView.layer.cornerRadius = 3.0;
    self.oneImageView.layer.masksToBounds = YES;
    self.oneImageView.layer.borderColor = RGBHex(qwColor9).CGColor;
    self.oneImageView.layer.borderWidth = 1.0;
    
    self.twoImageView.layer.cornerRadius = 3.0;
    self.twoImageView.layer.masksToBounds = YES;
    self.twoImageView.layer.borderColor = RGBHex(qwColor9).CGColor;
    self.twoImageView.layer.borderWidth = 1.0;
    
    self.proveImageView.layer.cornerRadius = 3.0;
    self.proveImageView.layer.masksToBounds = YES;
    self.proveImageView.layer.borderColor = RGBHex(qwColor9).CGColor;
    self.proveImageView.layer.borderWidth = 1.0;
    
    self.commitButton.layer.cornerRadius = 4.0;
    self.commitButton.layer.masksToBounds = YES;
    
    self.oneImageView.userInteractionEnabled = YES;
    self.twoImageView.userInteractionEnabled = YES;
    self.proveImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedOneImage:)];
    [self.oneImageView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedTwoImage:)];
    [self.twoImageView addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedProveImage:)];
    [self.proveImageView addGestureRecognizer:tap3];
}

#pragma mark ---- 选择营养师证图片1 ----
- (void)selectedOneImage:(UITapGestureRecognizer *)tap
{
    self.selectImageType = @"1";
    NSString *imgUrl = self.imageOneUrl;
    [self clickImageViewWith:imgUrl];
}

#pragma mark ---- 选择营养师证图片2 ----
- (void)selectedTwoImage:(UITapGestureRecognizer *)tap
{
    self.selectImageType = @"2";
    NSString *imgUrl = self.imageTwoUrl;
    [self clickImageViewWith:imgUrl];
}

#pragma mark ---- 选择挂靠证明图片 ----
- (void)selectedProveImage:(UITapGestureRecognizer *)tap
{
    self.selectImageType = @"3";
    NSString *imgUrl = self.proveUrl;
    [self clickImageViewWith:imgUrl];
}

- (void)clickImageViewWith:(NSString *)imgUrl
{
    // 上传图片
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
        return;
    }
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照设置图片", @"从相册选择图片", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerControllerSourceType sourceType;
    if (buttonIndex == 2)
    {
        //取消
        return;
    }else
    {
        if (buttonIndex == 0)
        {
            //拍照
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }else if (buttonIndex == 1)
        {
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

#pragma mark ---- 相册相机图片回调 ----
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
    
    if (image)
    {
        //传到服务器
        image = [image imageByScalingToMinSize];
        NSData * imageData = UIImageJPEGRepresentation(image, 0.5);
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"type"] = @(4);
        setting[@"token"] = @"";
        
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:imageData];
        
        [[HttpClient sharedInstance] uploaderImg:array params:setting withUrl:NW_uploadFile success:^(id responseObj) {
            
            if ([responseObj[@"apiStatus"] intValue] == 0)
            {
                NSString *imageUrl =  responseObj[@"body"][@"url"];
                
                if ([self.selectImageType isEqualToString:@"1"])
                {
                    //营养师证1
                    self.imageOneUrl = imageUrl;
                    [self.oneImageView setImageWithURL:[NSURL URLWithString:self.imageOneUrl]];
                    
                }else if ([self.selectImageType isEqualToString:@"2"])
                {
                    //营养师证2
                    self.imageTwoUrl = imageUrl;
                    [self.twoImageView setImageWithURL:[NSURL URLWithString:self.imageTwoUrl]];
                    
                }else if ([self.selectImageType isEqualToString:@"3"])
                {
                    //挂靠证明
                    self.proveUrl = imageUrl;
                    [self.proveImageView setImageWithURL:[NSURL URLWithString:self.proveUrl]];
                }
            }else
            {
                [SVProgressHUD showErrorWithStatus:responseObj[@"apiMessage"] duration:0.8f];
            }
            
        } failure:^(HttpException *e) {
            
        } uploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            
        }];
    }
}

#pragma mark ---- 参考样板 ----
- (IBAction)templetAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 1)
    {
        [[NutritionTempletView sharedManagerWithImage:@"bg_two_new" type:2] show];
    }else if (btn.tag == 2)
    {
        [[ProfessionTempletView sharedManagerWithIamge:@"expert_brand_templet"] show];
    }
}

#pragma mark ---- 提交资料 ----
- (IBAction)commitAction:(id)sender
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
        return;
    }
    
    if (StrIsEmpty(self.imageOneUrl) || StrIsEmpty(self.imageTwoUrl)) {
        [SVProgressHUD showErrorWithStatus:Kwarning220N92 duration:DURATION_SHORT];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"certExpertUrl"] = [NSString stringWithFormat:@"%@%@%@",self.imageOneUrl,SeparateStr,self.imageTwoUrl];
    setting[@"expertType"] = @"2";
    setting[@"certRegistUrl"] = StrFromObj(self.proveUrl);
    setting[@"status"] = @"-1";
    
    [Circle TeamUploadCertInfoWithParams:setting success:^(id obj) {
        
        BaseAPIModel *model = [BaseAPIModel parse:obj];
        if ([model.apiStatus integerValue] == 0)
        {
            NutritionInfoOneViewController *vc = [[UIStoryboard storyboardWithName:@"ExpertAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"NutritionInfoOneViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            [SVProgressHUD showErrorWithStatus:model.apiMessage];
        }
    } failure:^(HttpException *e) {
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
