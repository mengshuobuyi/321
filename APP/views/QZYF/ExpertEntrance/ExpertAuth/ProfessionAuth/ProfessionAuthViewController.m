//
//  ProfessionAuthViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/5.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ProfessionAuthViewController.h"
#import "UIImage+Ex.h"
#import "ProfessionAuthInfoViewController.h"
#import "Circle.h"

@interface ProfessionAuthViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

//提交
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
- (IBAction)commitAction:(id)sender;
@property (strong, nonatomic) NSString * selectImageType;

//药师证
@property (weak, nonatomic) IBOutlet UIView *professionBgView;
@property (weak, nonatomic) IBOutlet UILabel *professionUploadLabel;
@property (weak, nonatomic) IBOutlet UIImageView *professionImageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteProfessionBtn;
- (IBAction)deleteProfessionAction:(id)sender;
@property (strong, nonatomic) NSString *professionImageUrl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *professionBg_layout_height;

//注册证
@property (weak, nonatomic) IBOutlet UIView *nutritionBgView;
@property (weak, nonatomic) IBOutlet UILabel *nutritionUploadLabel;
@property (weak, nonatomic) IBOutlet UIImageView *nutritionImageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteNutritionBtn;
- (IBAction)deleteNutritionAction:(id)sender;
@property (strong, nonatomic) NSString *nutritionImageUrl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nutritionBg_layout_height;

//以下约束适配4s
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTwo_layout_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commitBtn_layout_bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view1_layout_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view2_layout_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteBtn1_layout_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteBtn2_layout_top;

@end

@implementation ProfessionAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"药师认证";
    self.professionImageUrl = @"";
    self.nutritionImageUrl = @"";
    
    self.professionBg_layout_height.constant = (APP_W-108)*140/212;
    self.nutritionBg_layout_height.constant = (APP_W-108)*140/212;
    
    if (IS_IPHONE_4_OR_LESS) {
        self.labelTwo_layout_top.constant = 10;
        self.commitBtn_layout_bottom.constant = 5;
        self.view1_layout_top.constant = 10;
        self.view2_layout_top.constant = 10;
        self.deleteBtn1_layout_top.constant = -5;
        self.deleteBtn2_layout_top.constant = -5;
    }
    
    //设置UI
    [self configureUI];
    
    //点击选择药师证
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedProfessionImage:)];
    [self.professionBgView addGestureRecognizer:tap1];
    
    //点击选择注册证
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedNutritionImage:)];
    [self.nutritionBgView addGestureRecognizer:tap2];
}

- (void)configureUI
{
    self.commitBtn.layer.cornerRadius = 4.0;
    self.commitBtn.layer.masksToBounds = YES;
    
    self.professionUploadLabel.layer.cornerRadius = 4.0;
    self.professionUploadLabel.layer.masksToBounds = YES;
    self.professionUploadLabel.layer.borderColor = RGBHex(qwColor9).CGColor;
    self.professionUploadLabel.layer.borderWidth = 1.0;
    
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
    //药师证
    if (StrIsEmpty(self.professionImageUrl))
    {
        self.deleteProfessionBtn.hidden = YES;
        self.deleteProfessionBtn.enabled = NO;
    }else
    {
        self.deleteProfessionBtn.hidden = NO;
        self.deleteProfessionBtn.enabled = YES;
    }
    
    //注册证
    if (StrIsEmpty(self.nutritionImageUrl))
    {
        self.deleteNutritionBtn.hidden = YES;
        self.deleteNutritionBtn.enabled = NO;
    }else
    {
        self.deleteNutritionBtn.hidden = NO;
        self.deleteNutritionBtn.enabled = YES;
    }
}

#pragma mark ---- 选择药师证图片 ----
- (void)selectedProfessionImage:(UITapGestureRecognizer *)tap
{
    self.selectImageType = @"1";
    NSString *imgUrl = self.professionImageUrl;
    [self clickImageViewWith:imgUrl];
}

#pragma mark ---- 选择注册证图片 ----
- (void)selectedNutritionImage:(UITapGestureRecognizer *)tap
{
    self.selectImageType = @"2";
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
                    //药师证
                    self.professionImageUrl = imageUrl;
                    [self.professionImageView setImageWithURL:[NSURL URLWithString:self.professionImageUrl]];
                    [self hideOrAppearDeleteButton];
                }else if ([self.selectImageType isEqualToString:@"2"])
                {
                    //注册证
                    self.nutritionImageUrl = imageUrl;
                    [self.nutritionImageView setImageWithURL:[NSURL URLWithString:self.nutritionImageUrl]];
                    [self hideOrAppearDeleteButton];
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

#pragma mark ---- 删除药师证图片 ----
- (IBAction)deleteProfessionAction:(id)sender
{
    self.professionImageView.image = nil;
    self.professionImageUrl = @"";
    [self hideOrAppearDeleteButton];
}

#pragma mark ---- 删除注册证图片 ----
- (IBAction)deleteNutritionAction:(id)sender
{
    self.nutritionImageView.image = nil;
    self.nutritionImageUrl = @"";
    [self hideOrAppearDeleteButton];
}

#pragma mark ---- 提交 ----
- (IBAction)commitAction:(id)sender
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
        return;
    }
    
    if (StrIsEmpty(self.professionImageUrl)) {
        [SVProgressHUD showErrorWithStatus:Kwarning220N90 duration:DURATION_SHORT];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"certExpertUrl"] = StrFromObj(self.professionImageUrl);
    setting[@"expertType"] = @"1";
    setting[@"certRegistUrl"] = StrFromObj(self.nutritionImageUrl);
    setting[@"status"] = @"-1";

    [Circle TeamUploadCertInfoWithParams:setting success:^(id obj) {
        
        BaseAPIModel *model = [BaseAPIModel parse:obj];
        if ([model.apiStatus integerValue] == 0)
        {
            ProfessionAuthInfoViewController *vc = [[UIStoryboard storyboardWithName:@"ExpertAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"ProfessionAuthInfoViewController"];
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
