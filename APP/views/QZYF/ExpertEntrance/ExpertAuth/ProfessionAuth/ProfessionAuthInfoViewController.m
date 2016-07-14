//
//  ProfessionAuthInfoViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/5.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ProfessionAuthInfoViewController.h"
#import "ProfessionAuthInfoCell.h"
#import "UIImage+Ex.h"
#import "SJAvatarBrowser.h"
#import "ExpertAuthCommitViewController.h"
#import "ExpertAuthViewController.h"
#import "Circle.h"
#import "CircleModel.h"

@interface ProfessionAuthInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ProfessionAuthInfoCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableFooterView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;

@property (weak, nonatomic) IBOutlet UIView *nameBgView;
//头像
@property (weak, nonatomic) IBOutlet UIImageView *headerIcon;
//申请按钮
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;
- (IBAction)applyAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField; //姓名
@property (strong, nonatomic) NSString *headerImageUrl;          //头像url
@property (strong, nonatomic) NSMutableArray *tagList;           //获取的领域数组
@property (strong, nonatomic) NSMutableArray *selectedTagList;   //选中的擅长领域数组

@end

@implementation ProfessionAuthInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"个人资料";
    
    self.tagList = [NSMutableArray array];
    self.selectedTagList = [NSMutableArray array];
    
    //设置UI
    [self configureUI];
    
    //网络获取擅长领域
    [self queryTags];
    
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.tableFooterView =self.tableFooterView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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
    
    //点击头像
    self.headerIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadericon)];
    [self.headerIcon addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ((QWBaseNavigationController *)self.navigationController).canDragBack = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    ((QWBaseNavigationController *)self.navigationController).canDragBack = YES;
}

#pragma mark ---- 请求标签数据 ----
- (void)queryTags
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    [Circle TeamExpertiseListWithParams:setting success:^(id obj) {
        
        GoodFieldPageModel *page = [GoodFieldPageModel parse:obj Elements:[GoodFieldModel class] forAttribute:@"skilledFieldList"];
        
        if ([page.apiStatus integerValue] == 0)
        {
            if (page.skilledFieldList.count > 0) {
                [self.tagList removeAllObjects];
                [self.tagList addObjectsFromArray:page.skilledFieldList];
                [self.tableView reloadData];
            }
        }else
        {
            [SVProgressHUD showErrorWithStatus:page.apiMessage];
        }
    } failure:^(HttpException *e) {
        
    }];
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

#pragma mark ---- 点击头像 ---
- (void)tapHeadericon
{
    if (self.headerImageUrl && ![self.headerImageUrl isEqualToString:@""])
    {
        // 已经上传图片，点击显示大图
        [SJAvatarBrowser showImage:self.headerIcon];
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
                self.headerImageUrl = imageUrl;
                [self.headerIcon setImageWithURL:[NSURL URLWithString:self.headerImageUrl] placeholderImage:[UIImage imageNamed:@"expert_ic_people"]];
            }else
            {
                [SVProgressHUD showErrorWithStatus:responseObj[@"apiMessage"] duration:0.8f];
            }
        } failure:^(HttpException *e) {
        } uploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        }];
    }
}

#pragma mark ---- UITableViewDelegate ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = [ProfessionAuthInfoCell getCellHeight:self.tagList];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfessionAuthInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfessionAuthInfoCell"];
    [cell setUpTagsWithAllList:self.tagList selectedList:self.selectedTagList];
    cell.professionAuthInfoCellDelegate = self;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark ---- 选择标签代理 ----
- (void)selectedTagAction:(UIButton *)button
{
    UIButton *btn = button;
    int row = btn.tag-100;
    
    GoodFieldModel *model = self.tagList[row];
    if ([self.selectedTagList containsObject:model])
    {
        [self.selectedTagList removeObject:model];
    }else
    {
        if (self.selectedTagList.count < 3) {
            [self.selectedTagList addObject:model];
        }else{
            [SVProgressHUD showErrorWithStatus:@"最多可选择3个擅长领域"];
        }
    }
    [self.tableView reloadData];
}

#pragma mark ---- 申请认证 ----
- (IBAction)applyAction:(id)sender
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
        return;
    }
    
    if (StrIsEmpty(self.nameTextField.text) || StrIsEmpty(self.headerImageUrl) || self.selectedTagList.count == 0) {
        [SVProgressHUD showErrorWithStatus:Kwarning220N91];
        return;
    }
    
    NSString *tagId =@"";
    NSString *tagStr = @"";
    
    if (self.selectedTagList)
    {
        for (int i = 0; i < self.selectedTagList.count; i++) {
            GoodFieldModel *model = [self.selectedTagList objectAtIndex:i];
            if (i == 0)
            {
                tagId = [NSString stringWithFormat:@"%@",model.id];
                tagStr = [NSString stringWithFormat:@"%@",model.dicValue];
            }else
            {
                tagId = [NSString stringWithFormat:@"%@%@%@",tagId,SeparateStr,model.id];
                tagStr = [NSString stringWithFormat:@"%@%@%@",tagStr,SeparateStr,model.dicValue];
            }
        }
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"name"] = StrFromObj(self.nameTextField.text);
    setting[@"headImageUrl"] = StrFromObj(self.headerImageUrl);
    setting[@"expertiseIds"] = StrFromObj(tagId);
    setting[@"expertise"] = StrFromObj(tagStr);
    setting[@"status"] = @"1";;
    [Circle TeamUpdateMbrInfoWithParams:setting success:^(id obj) {
        
        BaseAPIModel *model = [BaseAPIModel parse:obj];
        if ([model.apiStatus integerValue] == 0)
        {
            ExpertAuthCommitViewController *vc = [[UIStoryboard storyboardWithName:@"ExpertAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertAuthCommitViewController"];
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
