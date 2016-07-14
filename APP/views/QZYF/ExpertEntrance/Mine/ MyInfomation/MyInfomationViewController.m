//
//  MyInfomationViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/6.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "MyInfomationViewController.h"
#import "MyInfomationCell.h"
#import "UIImage+Ex.h"
#import "SJAvatarBrowser.h"
#import "GoodFieldViewController.h"
#import "MyBrandViewController.h"
#import "CircleModel.h"
#import "Circle.h"

@interface MyInfomationViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,GoodFieldViewControllerDelegate,MyBrandViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *headerIcon;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UIImageView *changeFieldRightArrow;
@property (weak, nonatomic) IBOutlet UILabel *changeFieldLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeFieldBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeStoreButton;
@property (weak, nonatomic) IBOutlet UILabel *changeStoreLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *storeLabel_layout_right;

- (IBAction)changeMyField:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *tableFooterView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerBg_layout_height;



@property (weak, nonatomic) IBOutlet UILabel *myStoreName;
- (IBAction)changeMyStore:(id)sender;

@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) NSString *headerImageUrl;

@end

@implementation MyInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"我的资料";
    self.dataList = [NSMutableArray array];
    
    [QWGLOBALMANAGER statisticsEventId:@"我的_我的资料_出现" withLable:@"圈子" withParams:nil];
    
    //擅长领域
    if (self.goodField.length > 0 || [self.goodField containsString:SeparateStr]) {
        NSArray *arr = [self.goodField componentsSeparatedByString:SeparateStr];
        [self.dataList addObjectsFromArray:arr];
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.tableFooterView = self.tableFooterView;
    
    //头像
    self.headerImageUrl = self.headerUrl;
    
    //设置content
    [self setUpHeader];
    
}

- (void)setUpHeader
{
    //头像
    self.headerIcon.layer.cornerRadius = 28;
    self.headerIcon.layer.masksToBounds = YES;
    [self.headerIcon setImageWithURL:[NSURL URLWithString:self.headerImageUrl] placeholderImage:[UIImage imageNamed:@"expert_ic_people"]];
    
    //头像增加点击事件
    self.headerIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeader)];
    [self.headerIcon addGestureRecognizer:tap];
    
    //姓名
    self.nameTextField.userInteractionEnabled = NO;
    self.nameTextField.text = self.nickName;
    
    //我的品牌 （如果是审核中 不能点击修改品牌状态）
    NSString *brand = @"";
    
    int width;
    if (self.groupStatu && ![self.groupStatu isEqualToString:@""]) {
        brand = [NSString stringWithFormat:@"%@ (%@)",self.groupName,self.groupStatu];
    }else{
        brand = [NSString stringWithFormat:@"%@",self.groupName];;
    }
    width = APP_W-171;
    if ([self.groupStatu isEqualToString:@"审核中"]) {
        self.changeStoreButton.hidden = YES;
        self.changeStoreButton.enabled = NO;
        self.changeStoreLabel.hidden = YES;
        self.storeLabel_layout_right.constant = 4;
        width = APP_W-111;
        brand = @"审核中";
    }
    
    CGSize titleSize = [QWGLOBALMANAGER sizeText:brand font:fontSystem(14) limitWidth:width];
    self.footerBg_layout_height.constant = 45-18+titleSize.height;
    self.myStoreName.text = brand;
    
    
    //我擅长的领域
    if ([self.expertType isEqualToString:@"2"])
    {
        //营养师
        self.changeFieldRightArrow.hidden = YES;
        self.changeFieldLabel.hidden = YES;
        self.changeFieldBtn.enabled = NO;
    }
}

#pragma mark ---- 修改领域的delegeate ----
- (void)changeGoodField:(NSArray *)array
{
    if (array.count > 0) {
        
        [self.dataList removeAllObjects];
        for (GoodFieldModel *model in array) {
            [self.dataList addObject:model.dicValue];
        }
        [self.tableView reloadData];
    }
}

#pragma mark ---- 修改品牌delegate ----
- (void)changeMyBrand
{
    self.groupStatu = @"审核中";
    [self setUpHeader];
}

#pragma mark ---- 列表代理 ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyInfomationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyInfomationCell"];
    cell.fieldName.text = self.dataList[indexPath.row];
    cell.fieldImage.hidden = YES;
    return cell;
}

#pragma mark ---- 上传头像 ----
- (void)clickHeader
{
    [self.view endEditing:YES];
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
                self.headerImageUrl = imageUrl;
                [self.headerIcon setImageWithURL:[NSURL URLWithString:self.headerImageUrl] placeholderImage:[UIImage imageNamed:@"expert_ic_people"]];
                [self saveAction];
                
            }else{
                [SVProgressHUD showErrorWithStatus:responseObj[@"apiMessage"] duration:0.8f];
            }
        } failure:^(HttpException *e) {
        } uploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        }];
    }
}

#pragma mark ---- 修改我的品牌 ----
- (IBAction)changeMyStore:(id)sender
{
    MyBrandViewController *vc = [[UIStoryboard storyboardWithName:@"MyInfomation" bundle:nil] instantiateViewControllerWithIdentifier:@"MyBrandViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.myBrandViewControllerDelegate = self;
    vc.expertType = self.expertType;
    vc.registerUrl = self.registerUrl;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---- 修改我的擅长领域 ----
- (IBAction)changeMyField:(id)sender
{
    
    [QWGLOBALMANAGER statisticsEventId:@"我的_我的资料_我擅长的领域_点击修改按键" withLable:@"我的" withParams:nil];
    
    GoodFieldViewController *vc = [[UIStoryboard storyboardWithName:@"MyInfomation" bundle:nil] instantiateViewControllerWithIdentifier:@"GoodFieldViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.goodFieldViewControllerDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---- 保存 ----
- (void)saveAction
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    
//    if ([self.expertType integerValue] == 1) {
//        //药师
//        if (StrIsEmpty(self.nameTextField.text) || StrIsEmpty(self.headerImageUrl) || self.dataList.count == 0) {
//            [SVProgressHUD showErrorWithStatus:@"请完善资料"];
//            return;
//        }
//    }else if ([self.expertType integerValue] == 2){
//        //营养师
//        if (StrIsEmpty(self.nameTextField.text) || StrIsEmpty(self.headerImageUrl)) {
//            [SVProgressHUD showErrorWithStatus:@"请完善资料"];
//            return;
//        }
//    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"name"] = StrFromObj(self.nameTextField.text);
    setting[@"headImageUrl"] = StrFromObj(self.headerImageUrl);
    setting[@"status"] = @"-1";
    [Circle TeamUpdateMbrInfoWithParams:setting success:^(id obj) {
        
        BaseAPIModel *model = [BaseAPIModel parse:obj];
        if ([model.apiStatus integerValue] == 0) {
            
            //本地保存头像
            QWGLOBALMANAGER.configure.expertAvatarUrl = self.headerImageUrl;
            QWGLOBALMANAGER.configure.expertNickName = self.nameTextField.text;
            [QWGLOBALMANAGER saveAppConfigure];
            [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:model.apiMessage];
        }
        
    } failure:^(HttpException *e) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.dataList removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark ---- 监听文本变化 ----

- (void)textFieldDidChange:(UITextField *)textField
{
    UITextField *textView = textField;
    NSString *lang = [[textView textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            [self judgeTextFieldChange:textView];
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        [self judgeTextFieldChange:textView];
    }
}

- (void)judgeTextFieldChange:(UITextField *)textField
{
    UITextField *textView = textField;
    NSString *toBeString = textView.text;
    
    int maxNum;
    maxNum = 6;
    
    if (toBeString.length > maxNum) {
        textView.text = [toBeString substringToIndex:maxNum];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)setUpRightItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    
    [self.nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    // 药师 擅长领域可以拖动排序
    if ([self.expertType isEqualToString:@"1"]) {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
        [self.tableView addGestureRecognizer:longPress];
    }
}
 
- (void)longPressGestureRecognized:(id)sender
{
    [self.view endEditing:YES];
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;
    static NSIndexPath  *sourceIndexPath = nil;
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                snapshot = [self customSnapshoFromView:cell];
                
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                } completion:^(BOOL finished) {
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                [self.dataList exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                sourceIndexPath = indexPath;
            }
            break;
        }
            
        default: {
            // Clean up.
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            
            [UIView animateWithDuration:0.25 animations:^{
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
            } completion:^(BOOL finished) {
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            break;
        }
    }
    
}

#pragma mark - Helper methods
- (UIView *)customSnapshoFromView:(UIView *)inputView
{
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    return snapshot;
}
*/
 
@end
