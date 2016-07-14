//
//  NutritionAuthInfoViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/5.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "NutritionAuthInfoViewController.h"
#import "UIImage+Ex.h"
#import "SJAvatarBrowser.h"
#import "ExpertAuthCommitViewController.h"
#import "ExpertAuthViewController.h"
#import "Circle.h"

@interface NutritionAuthInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

//头像
@property (weak, nonatomic) IBOutlet UIImageView *headerIcon;
@property (strong, nonatomic) NSString *headerImageUrl;

//姓名
@property (weak, nonatomic) IBOutlet UIView *nameBgView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

//申请按钮
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;
- (IBAction)applyAction:(id)sender;

@end

@implementation NutritionAuthInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    [self configureUI];
}

- (void)configureUI
{
    self.headerIcon.layer.cornerRadius = 28;
    self.headerIcon.layer.masksToBounds = YES;
    self.nameBgView.layer.cornerRadius = 2.0;
    self.nameBgView.layer.masksToBounds = YES;
    self.nameBgView.layer.borderColor = RGBHex(qwColor10).CGColor;
    self.nameBgView.layer.borderWidth = 0.5;
    self.applyBtn.layer.cornerRadius = 3.0;
    self.applyBtn.layer.masksToBounds = YES;
    
    //点击上传头像
    self.headerIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadericon)];
    [self.headerIcon addGestureRecognizer:tap];
}

#pragma mark ---- 点击头像 ---
- (void)tapHeadericon
{
    if (self.headerImageUrl && ![self.headerImageUrl isEqualToString:@""]) {
        // 已经上传图片，点击显示大图
        [SJAvatarBrowser showImage:self.headerIcon];
    }else{
        // 上传图片
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
            return;
        }
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
                self.headerImageUrl = imageUrl;
                [self.headerIcon setImageWithURL:[NSURL URLWithString:self.headerImageUrl] placeholderImage:[UIImage imageNamed:@"expert_ic_people"]];
            }else{
                [SVProgressHUD showErrorWithStatus:responseObj[@"apiMessage"] duration:0.8f];
            }
        } failure:^(HttpException *e) {
        } uploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        }];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark ---- 申请认证 ----
- (IBAction)applyAction:(id)sender
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
        return;
    }
    
    if (StrIsEmpty(self.nameTextField.text) || StrIsEmpty(self.headerImageUrl)) {
        [SVProgressHUD showErrorWithStatus:Kwarning220N91];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"name"] = StrFromObj(self.nameTextField.text);
    setting[@"headImageUrl"] = StrFromObj(self.headerImageUrl);
    setting[@"expertise"] = [NSString stringWithFormat:@"营养保健%@疾病调养",SeparateStr];
    setting[@"status"] = @"1";;
    [Circle TeamUpdateMbrInfoWithParams:setting success:^(id obj) {
        
        BaseAPIModel *model = [BaseAPIModel parse:obj];
        if ([model.apiStatus integerValue] == 0) {
            ExpertAuthCommitViewController *vc = [[UIStoryboard storyboardWithName:@"ExpertAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertAuthCommitViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:model.apiMessage];
        }
    } failure:^(HttpException *e) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
