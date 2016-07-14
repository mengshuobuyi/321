//
//  StoreDetailViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/7/7.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "StoreDetailViewController.h"
#import "StoreDetailCell.h"
#import "SJAvatarBrowser.h"
#import "MapViewController.h"
#import "MADateView.h"
#import "UIImage+Ex.h"
#import "UIViewController+LJWKeyboardHandlerHelper.h"
#import "Store.h"

@interface StoreDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,MapViewControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong, nonatomic) IBOutlet UIView *tableFooterView;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView; //门店logo
@property (weak, nonatomic) IBOutlet UIImageView *deleteLogoImage; //删除门店logo
@property (weak, nonatomic) IBOutlet UIButton *deleteLogoBtn; //删除门店logo按钮

@property (weak, nonatomic) IBOutlet UITextField *nameTextField; //门店名称
@property (weak, nonatomic) IBOutlet UITextField *shortNameTextField; //门店简称
@property (weak, nonatomic) IBOutlet UITextField *addressTextField; //门店地址

@property (weak, nonatomic) IBOutlet UILabel *locationLabel; //地理位置
@property (weak, nonatomic) IBOutlet UIButton *locationButton; //定位按钮
@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn; //开始营业时间
@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn; //结束营业时间

@property (strong, nonatomic) NSString *logoImageUrl; //门店logo url
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *startTimeText;
@property (strong, nonatomic) NSString *endTimeText;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableView_layout_top;

//删除门店logo
- (IBAction)deleteLogoAction:(id)sender;

//获取地理位置
- (IBAction)getLocationAction:(id)sender;

//选择营业时间
- (IBAction)selectTimeAction:(id)sender;

@end

@implementation StoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"门店信息";
    
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.tableFooterView = self.tableFooterView;
    
    self.nameTextField.delegate = self;
    self.shortNameTextField.delegate = self;
    self.addressTextField.delegate = self;
    
    self.startTimeBtn.tag = 333;
    self.endTimeBtn.tag = 444;
    
    self.logoImageView.layer.cornerRadius = 2.0;
    self.logoImageView.layer.masksToBounds = YES;
    
    if (AUTHORITY_ROOT)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addLogoAction:)];
        [self.logoImageView addGestureRecognizer:tap];
        
        if (StrIsEmpty(self.logoImageUrl)) {
            self.deleteLogoImage.hidden = YES;
            self.deleteLogoBtn.hidden = YES;
            self.deleteLogoBtn.enabled = NO;
        }else{
            self.deleteLogoImage.hidden = NO;
            self.deleteLogoBtn.hidden = NO;
            self.deleteLogoBtn.enabled = YES;
        }
        
        self.nameTextField.userInteractionEnabled = YES;
        self.shortNameTextField.userInteractionEnabled = YES;
        self.addressTextField.userInteractionEnabled = YES;
        self.locationButton.enabled = YES;
        self.startTimeBtn.enabled = YES;
        self.endTimeBtn.enabled = YES;
    }else
    {
        self.deleteLogoImage.hidden = YES;
        self.deleteLogoBtn.hidden = YES;
        self.deleteLogoBtn.enabled = NO;
        
        self.nameTextField.userInteractionEnabled = NO;
        self.shortNameTextField.userInteractionEnabled = NO;
        self.addressTextField.userInteractionEnabled = NO;
        self.locationButton.enabled = NO;
        self.startTimeBtn.enabled = NO;
        self.endTimeBtn.enabled = NO;
    }

    
    // tableView 编辑 键盘 up down
    [self registerLJWKeyboardHandler];
    
    [self checkTimeTextColor];
    
}

- (void)queryInfo
{
    if (!QWGLOBALMANAGER.configure.groupId) {
        return;
    }
    [Store GetBranhBranchInfoWithGroupId:QWGLOBALMANAGER.configure.groupId success:^(id responseObj) {
        
    } failure:^(HttpException *e) {
    }];
}

- (void)ConfigureData
{
    
}

#pragma mark ---- UITableViewDelegate ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return .1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreDetailCell"];
    return cell;
}

#pragma mark ---- 添加机构logo ----
- (void)addLogoAction:(UITapGestureRecognizer *)tap
{
    if (StrIsEmpty(self.logoImageUrl))
    {
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照设置图片", @"从相册选择图片", nil];
        [actionSheet showInView:self.view];
    }else
    {
        [SJAvatarBrowser showImage:(UIImageView *)tap.view];
    }
}

#pragma mark ---- UIActionSheetDelegate ----
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
            alertView.tag = 1;
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
                self.logoImageUrl = imageUrl;
                [self.logoImageView setImageWithURL:[NSURL URLWithString:self.logoImageUrl] placeholderImage:[UIImage imageNamed:@"添加图片.png"]];
                self.deleteLogoImage.hidden = NO;
                self.deleteLogoBtn.enabled = YES;
                self.deleteLogoBtn.hidden = NO;
            }else
            {
                [SVProgressHUD showErrorWithStatus:responseObj[@"apiMessage"] duration:0.8f];
            }
        } failure:^(HttpException *e) {
        } uploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        }];
    }
}

#pragma mark ---- 删除门店logo ----
- (IBAction)deleteLogoAction:(id)sender
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除图片吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 2;
    [alertView show];
}

#pragma mark ---- UIAlertViewDelegate -----
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2)
    {
        if (buttonIndex == 1)
        {
            self.logoImageUrl = @"";
            self.logoImageView.image = [UIImage imageNamed:@"添加图片.png"];
            self.deleteLogoImage.hidden = YES;
            self.deleteLogoBtn.enabled = NO;
            self.deleteLogoBtn.hidden = YES;
        }
    }
}

#pragma mark ---- 选择地理位置 ----
- (IBAction)getLocationAction:(id)sender
{
    [self.view endEditing:YES];
    
    if(QWGLOBALMANAGER.currentNetWork == NotReachable){
        [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试" duration:0.8f];
        return;
    }
    
//    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
//    [dic setObject:self.branchInfoModel.provinceName forKey:@"provinceName"];
//    [dic setObject:self.branchInfoModel.cityName forKey:@"cityName"];
//    [dic setObject:self.branchInfoModel.countyName forKey:@"countryName"];
//    [dic setObject:self.branchMapModel.title forKey:@"title"];
//    [dic setObject:self.branchMapModel.latitude forKey:@"latitude"];
//    [dic setObject:self.branchMapModel.longitude forKey:@"longitude"];
    
    MapViewController * mapView = [[MapViewController alloc] init];
    mapView.delegate = self;
//    mapView.userLocationDic = [dic copy];
    [self.navigationController pushViewController:mapView animated:YES];
}


#pragma mark ---- 地图代理返回值 ----
- (void)pickUserLocation:(NSDictionary *)location
{
    NSString *latitude = [NSString stringWithFormat:@"%@",location[@"latitude"]];
    NSString *longitude = [NSString stringWithFormat:@"%@",location[@"longitude"]];
    self.latitude = latitude;
    self.longitude = longitude;
    self.locationLabel.text = [NSString stringWithFormat:@"经度: %@ 纬度: %@",longitude,latitude];
}

#pragma mark ---------textFieldDelegate----------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([QWGLOBALMANAGER judgeTheKeyboardInputModeIsEmojiOrNot:textField]) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark ---- 选择营业时间 ----
- (IBAction)selectTimeAction:(id)sender
{
    [self.view endEditing:YES];
    
    if (IS_IPHONE_4_OR_LESS)
    {
        [self.tableView setContentOffset:CGPointMake(0, 100) animated:YES];
    }else if (IS_IPHONE_5)
    {
        [self.tableView setContentOffset:CGPointMake(0, 40) animated:YES];
    }
    
    
    UIButton *button = (UIButton *)sender;
    NSString *buttonTitle = button.titleLabel.text;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *date = [dateFormatter dateFromString:buttonTitle];
    
    NSInteger tag = button.tag;
    __block StoreDetailViewController *weakSelf = self;
    [MADateView showDateViewWithDate:date Style:DateViewStyleTime CallBack:^(MyWindowClick buttonIndex, NSString *timeStr) {
        
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        
        switch (buttonIndex) {
            case MyWindowClickForOK:
            {
                switch (tag) {
                    case 333: //开始时间
                    {
                        self.startTimeText = timeStr;
                        [weakSelf.startTimeBtn setTitle:timeStr forState:UIControlStateNormal];
                        [self checkTimeTextColor];
                    }
                        break;
                    case 444: //结束时间
                    {
                        self.endTimeText = timeStr;
                        [weakSelf.endTimeBtn setTitle:timeStr forState:UIControlStateNormal];
                        [self checkTimeTextColor];
                    }
                    default:
                        break;
                }
            }
                break;
            case MyWindowClickForCancel:
            {
            }
                break;
            default:
                break;
        }
    }];
}

- (void)checkTimeTextColor
{
    if (StrIsEmpty(self.startTimeText))
    {
        [self.startTimeBtn setTitleColor:RGBHex(qwColor9) forState:UIControlStateNormal];
        [self.startTimeBtn setTitle:@"请选择时间" forState:UIControlStateNormal];
    }else
    {
        [self.startTimeBtn setTitleColor:RGBHex(qwColor6) forState:UIControlStateNormal];
    }
    
    if (StrIsEmpty(self.endTimeText))
    {
        [self.endTimeBtn setTitleColor:RGBHex(qwColor9) forState:UIControlStateNormal];
        [self.endTimeBtn setTitle:@"请选择时间" forState:UIControlStateNormal];
    }else
    {
        [self.endTimeBtn setTitleColor:RGBHex(qwColor6) forState:UIControlStateNormal];
    }
    
}

#pragma mark ---- 保存 ----
- (void)saveAction
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
