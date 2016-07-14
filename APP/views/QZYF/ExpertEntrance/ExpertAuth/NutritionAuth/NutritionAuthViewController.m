//
//  NutritionAuthViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/5.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "NutritionAuthViewController.h"
#import "UIImage+Ex.h"
#import "NutritionAuthInfoViewController.h"
#import "Circle.h"
@interface NutritionAuthViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

//提交
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
- (IBAction)commitAction:(id)sender;

//营养师证
@property (weak, nonatomic) IBOutlet UIView *nutritionBgView;
@property (weak, nonatomic) IBOutlet UILabel *nutritionUploadLabel;
@property (weak, nonatomic) IBOutlet UIImageView *nutritionImageView;

//删除按钮
@property (weak, nonatomic) IBOutlet UIButton *deleteNutritionBtn;
- (IBAction)deleteNutritionAction:(id)sender;

//营养师证url
@property (strong, nonatomic) NSString *nutritionImageUrl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nutritionBg_layout_height;

@end

@implementation NutritionAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"营养师认证";
    
    self.nutritionBg_layout_height.constant = (APP_W-108)*140/212;
    
    //点击上传图片
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedNutritionImage:)];
    [self.nutritionBgView addGestureRecognizer:tap2];
    
    //设置UI
    [self configureUI];
}

- (void)configureUI
{
    self.commitBtn.layer.cornerRadius = 3.0;
    self.commitBtn.layer.masksToBounds = YES;
    
    self.nutritionUploadLabel.layer.cornerRadius = 4.0;
    self.nutritionUploadLabel.layer.masksToBounds = YES;
    self.nutritionUploadLabel.layer.borderColor = RGBHex(qwColor9).CGColor;
    self.nutritionUploadLabel.layer.borderWidth = 1.0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideOrAppearDeleteButton];
}

#pragma mark ---- 判断删除按钮是否隐藏 ----
- (void)hideOrAppearDeleteButton
{
    if (StrIsEmpty(self.nutritionImageUrl)) {
        self.deleteNutritionBtn.hidden = YES;
        self.deleteNutritionBtn.enabled = NO;
    }else{
        self.deleteNutritionBtn.hidden = NO;
        self.deleteNutritionBtn.enabled = YES;
    }
}

#pragma mark ---- 选择营养师证图片 ----
- (void)selectedNutritionImage:(UITapGestureRecognizer *)tap
{
    NSString *imgUrl = self.nutritionImageUrl;
    [self clickImageViewWith:imgUrl];
}

- (void)clickImageViewWith:(NSString *)imgUrl
{
    if (imgUrl && ![imgUrl isEqualToString:@""])
    {
        // 已经上传图片，点击显示大图
    }else
    {
        // 上传图片
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
            return;
        }
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照设置图片", @"从相册选择图片", nil];
        [actionSheet showInView:self.view];
    }
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
                self.nutritionImageUrl = imageUrl;
                [self.nutritionImageView setImageWithURL:[NSURL URLWithString:self.nutritionImageUrl]];
                [self hideOrAppearDeleteButton];
            }else
            {
                [SVProgressHUD showErrorWithStatus:responseObj[@"apiMessage"] duration:0.8f];
            }
            
        } failure:^(HttpException *e) {
            
        } uploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            
        }];
    }
}

#pragma mark ---- 删除注册证图片 ----
- (IBAction)deleteNutritionAction:(id)sender
{
    self.nutritionImageView.image = nil;
    self.nutritionImageUrl = @"";
    [self hideOrAppearDeleteButton];
}

#pragma mark ---- 提交资料 ----
- (IBAction)commitAction:(id)sender
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
        return;
    }
    
    if (StrIsEmpty(self.nutritionImageUrl)) {
        [SVProgressHUD showErrorWithStatus:Kwarning220N92 duration:DURATION_SHORT];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"certExpertUrl"] = StrFromObj(self.nutritionImageUrl);
    setting[@"expertType"] = @"2";
    setting[@"status"] = @"-1";
    
    [Circle TeamUploadCertInfoWithParams:setting success:^(id obj) {
        
        BaseAPIModel *model = [BaseAPIModel parse:obj];
        if ([model.apiStatus integerValue] == 0)
        {
            NutritionAuthInfoViewController *vc = [[UIStoryboard storyboardWithName:@"ExpertAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"NutritionAuthInfoViewController"];
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
