//
//  ProfessionCardViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/4/11.
//  Copyright © 2016年 carret. All rights reserved.
//

/*
    药师认证 上传证照
 */

#import "ProfessionCardViewController.h"
#import "ProfessionInfoOneViewController.h"
#import "UIImage+Ex.h"
#import "Circle.h"
#import "ProfessionTempletView.h"
#import "NutritionTempletView.h"

@interface ProfessionCardViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *oneBgView;
@property (weak, nonatomic) IBOutlet UIView *twoBgView;


@property (weak, nonatomic) IBOutlet UIImageView *medicineImageViewOne;
@property (weak, nonatomic) IBOutlet UIImageView *medicineImageViewTwo;

@property (weak, nonatomic) IBOutlet UIImageView *registerImageView;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@property (strong, nonatomic) NSString *professionImageOneUrl; //药师证url
@property (strong, nonatomic) NSString *professionImageTwoUrl; //药师证url
@property (strong, nonatomic) NSString *registerImageUrl;   //注册证url
@property (strong, nonatomic) NSString * selectImageType;   //1药师图1 2药师图2  3注册证

//参考样板
- (IBAction)templetAction:(id)sender;
//提交
- (IBAction)commitAction:(id)sender;

@end

@implementation ProfessionCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"药师认证";
    [self configureUI];
}

- (void)configureUI
{
    self.oneBgView.backgroundColor = [UIColor whiteColor];
    self.twoBgView.backgroundColor = [UIColor whiteColor];
    
    self.medicineImageViewOne.layer.cornerRadius = 3.0;
    self.medicineImageViewOne.layer.masksToBounds = YES;
    self.medicineImageViewOne.layer.borderColor = RGBHex(qwColor9).CGColor;
    self.medicineImageViewOne.layer.borderWidth = 1.0;
    
    self.medicineImageViewTwo.layer.cornerRadius = 3.0;
    self.medicineImageViewTwo.layer.masksToBounds = YES;
    self.medicineImageViewTwo.layer.borderColor = RGBHex(qwColor9).CGColor;
    self.medicineImageViewTwo.layer.borderWidth = 1.0;
    
    self.registerImageView.layer.cornerRadius = 3.0;
    self.registerImageView.layer.masksToBounds = YES;
    self.registerImageView.layer.borderColor = RGBHex(qwColor9).CGColor;
    self.registerImageView.layer.borderWidth = 1.0;
    
    self.commitButton.layer.cornerRadius = 4.0;
    self.commitButton.layer.masksToBounds = YES;
    
    self.medicineImageViewOne.userInteractionEnabled = YES;
    self.medicineImageViewTwo.userInteractionEnabled = YES;
    self.registerImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedProfessionOneImage:)];
    [self.medicineImageViewOne addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedProfessionTwoImage:)];
    [self.medicineImageViewTwo addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedNutritionImage:)];
    [self.registerImageView addGestureRecognizer:tap3];
}

#pragma mark ---- 选择药师证图片1 ----
- (void)selectedProfessionOneImage:(UITapGestureRecognizer *)tap
{
    self.selectImageType = @"1";
    NSString *imgUrl = self.professionImageOneUrl;
    [self clickImageViewWith:imgUrl];
}

#pragma mark ---- 选择药师证图片2 ----
- (void)selectedProfessionTwoImage:(UITapGestureRecognizer *)tap
{
    self.selectImageType = @"2";
    NSString *imgUrl = self.professionImageTwoUrl;
    [self clickImageViewWith:imgUrl];
}

#pragma mark ---- 选择注册证图片 ----
- (void)selectedNutritionImage:(UITapGestureRecognizer *)tap
{
    self.selectImageType = @"3";
    NSString *imgUrl = self.registerImageUrl;
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
                    //药师证1
                    self.professionImageOneUrl = imageUrl;
                    [self.medicineImageViewOne setImageWithURL:[NSURL URLWithString:self.professionImageOneUrl]];
                    
                }else if ([self.selectImageType isEqualToString:@"2"])
                {
                    //药师证2
                    self.professionImageTwoUrl = imageUrl;
                    [self.medicineImageViewTwo setImageWithURL:[NSURL URLWithString:self.professionImageTwoUrl]];
                    
                }else if ([self.selectImageType isEqualToString:@"3"])
                {
                    //注册证
                    self.registerImageUrl = imageUrl;
                    [self.registerImageView setImageWithURL:[NSURL URLWithString:self.registerImageUrl]];
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
    if (btn.tag == 1) {
        [[NutritionTempletView sharedManagerWithImage:@"expert_profession_templet" type:2] show];
    }else if (btn.tag == 2){
        [[NutritionTempletView sharedManagerWithImage:@"bg_three" type:1] show];
    }
}

#pragma mark ---- 提交 ----
- (IBAction)commitAction:(id)sender
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
        return;
    }
    
    if (StrIsEmpty(self.professionImageOneUrl) || StrIsEmpty(self.professionImageTwoUrl)) {
        [SVProgressHUD showErrorWithStatus:Kwarning220N90 duration:DURATION_SHORT];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"certExpertUrl"] = [NSString stringWithFormat:@"%@%@%@",self.professionImageOneUrl,SeparateStr,self.professionImageTwoUrl];
    setting[@"expertType"] = @"1";
    setting[@"certRegistUrl"] = StrFromObj(self.registerImageUrl);
    setting[@"status"] = @"-1";
    
    [Circle TeamUploadCertInfoWithParams:setting success:^(id obj) {
        
        BaseAPIModel *model = [BaseAPIModel parse:obj];
        if ([model.apiStatus integerValue] == 0)
        {
            ProfessionInfoOneViewController *vc = [[UIStoryboard storyboardWithName:@"ExpertAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"ProfessionInfoOneViewController"];
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
