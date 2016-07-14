//
//  AddNewMarketActivityViewController.m
//  wenyao-store
//
//  Created by xiezhenghong on 14-10-22.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "AddNewMarketActivityViewController.h"
#import "SBJson.h"
#import "UIImageView+WebCache.h"
#import "MarketDetailViewController.h"
#import "MarketingActivityViewController.h"
#import "Order.h"
#import "OrderMedelR.h"
#import "SVProgressHUD.h"
#import "QYImage.h"
@interface AddNewMarketActivityViewController ()
{
    UIBarButtonItem *pushlishBarbutton;
}

@property (weak, nonatomic) IBOutlet UIView *viewAddImage;

@end

@implementation AddNewMarketActivityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=RGBHex(qwColor11);
    self.view.frame = [UIScreen mainScreen].bounds;
    self.title = @"新增门店海报";
    
 
    UIBarButtonItem *previewBarbutton = [[UIBarButtonItem alloc] initWithTitle:@"预览" style:UIBarButtonItemStylePlain target:self action:@selector(previewMarketActivity:)];
    pushlishBarbutton = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publishMarketActivity:)];
    self.navigationItem.rightBarButtonItems = @[pushlishBarbutton,previewBarbutton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    self.infoNewDict = [QueryActivityInfo new];
    if(self.oldDict) {
        self.infoNewDict = self.oldDict;
    }
    self.titleTextField.text = self.infoNewDict.title;
    self.textView.text = self.infoNewDict.content;
    if(self.infoNewDict.title)
    {
        NSString *content = self.textView.text;
        if(content.length > 0) {
            self.hintLabel.hidden = YES;
            self.countLabel.text = [NSString stringWithFormat:@"(%d/200)",(int)content.length];
        }
    }
    if(([self.infoNewDict.imgUrl isEqualToString:@""])||(!self.infoNewDict.imgUrl)) {
        self.delImageButton.hidden = YES;
        self.previewImage.hidden = YES;
    }else{
        self.delImageButton.hidden = NO;
        self.previewImage.hidden = NO;
        [self.previewImage setImageWithURL:[NSURL URLWithString:self.infoNewDict.imgUrl] placeholderImage:[UIImage imageNamed:@"img_goods_default"] options:SDWebImageRetryFailed|SDWebImageContinueInBackground];
    }
    [self textFieldDidChange:nil];
    
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, 49.5, APP_W, 0.5)];
    line1.backgroundColor=RGBHex(qwColor10);
    [self.topview addSubview:line1];
    
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_W, 0.5)];
    line2.backgroundColor=RGBHex(qwColor10);
    [self.centerview addSubview:line2];
    
    UIView *line3=[[UIView alloc]initWithFrame:CGRectMake(0, 134.5, APP_W, 0.5)];
    line3.backgroundColor=RGBHex(qwColor10);
    [self.centerview addSubview:line3];
    
    UIView *line4=[[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_W, 0.5)];
    line4.backgroundColor=RGBHex(qwColor10);
    [self.viewAddImage addSubview:line4];
    
    UIView *line5=[[UIView alloc]initWithFrame:CGRectMake(0, 96.5, APP_W, 0.5)];
    line5.backgroundColor=RGBHex(qwColor10);
    [self.viewAddImage addSubview:line5];
    
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UITapGestureRecognizer *tapGestrue=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyboard:)];
    tapGestrue.numberOfTapsRequired=1;
    tapGestrue.numberOfTouchesRequired=1;
    [self.view addGestureRecognizer:tapGestrue];
    
    [self.titleTextField setValue:RGBHex(0x9B9B9B) forKeyPath:@"_placeholderLabel.textColor"];
    [self.titleTextField setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
}
-(void)hiddenKeyboard:(UITapGestureRecognizer *)tapGestrue{
    [self.view endEditing:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    return YES;
    
    
}

#pragma mark -
#pragma mark UITextViewDelegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{

    CGFloat offset=self.view.frame.size.height-(textView.frame.origin.y+textView.frame.size.height+216+90);
    
    if(offset<=0){
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame=self.view.frame;
            frame.origin.y=offset;
            self.view.frame=frame;
        }];
    }
    return YES;

}


-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame=self.view.frame;
        frame.origin.y=64.0;
        self.view.frame=frame;
    }];
    return YES;
}



- (void)textViewDidChange:(UITextView *)textView
{
    self.countLabel.text = [NSString stringWithFormat:@"(%d/200)",(int)textView.text.length];
    if ([self.textView.text isEqualToString:@""]) {
        self.hintLabel.hidden = NO;
    }else{
        self.hintLabel.hidden = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self.view endEditing:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(textView.text.length <= 1 && [text isEqualToString:@""]){
        self.hintLabel.hidden = NO;
    }else{
        self.hintLabel.hidden = YES;
    }
    NSString *temp = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (temp.length > 200) {
        textView.text = [temp substringToIndex:199];
    }
    
    return YES;
}

- (void)textFieldDidChange:(NSNotification *)notifi
{
    if (notifi.object==self.titleTextField) {
        if(self.titleTextField.text.length > 0) {
            self.delTitleButton.hidden = NO;
        }else{
            self.delTitleButton.hidden = YES;
        }
    }
 
    
}

- (IBAction)deleteTitleField:(UIButton *)sender
{
    self.titleTextField.text = @"";
    sender.hidden = YES;
}

- (IBAction)postImage:(id)sender
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    actionSheet.tag = 100;
    [actionSheet showInView:self.view];
}

- (IBAction)deleteImage:(id)sender
{
    //新的image的内容删除,用来存放image
    self.infoNewDict.imageSrc=nil;
    //隐藏
    self.previewImage.hidden = YES;
    self.previewImage.image = nil;
    
    self.delImageButton.hidden = YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 100) {//设置头像
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
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // bug fixes: UIIMagePickerController使用中偷换StatusBar颜色的问题
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType ==     UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    /*
     *1.通过相册和相机获取的图片都在此代理中
     *
     *2.图片选择已完成,在此处选择传送至服务器
     */
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.previewImage.contentMode=UIViewContentModeScaleAspectFit;
    self.infoNewDict.imageSrc=image;
    self.previewImage.hidden = NO;
    self.delImageButton.hidden = NO;
    //存放在小方框中
    self.previewImage.image = image;
    [self.viewAddImage bringSubviewToFront:self.delImageButton];

    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}



- (void)previewMarketActivity:(id)sender
{
 

    if([self.titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0){
        [self showError:kWaring30];
        return;
    }
    if([self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        [self showError:kWaring31];
        return;
    }
    
    if ([self.titleTextField.text isEqualToString:@""]||[self.textView.text isEqualToString:@""]) {
        [self showError:kWaring32];
        return;
    
    }else{
    MarketDetailViewController *marketDetailViewController = [[MarketDetailViewController alloc] initWithNibName:@"MarketDetailViewController" bundle:nil];
    marketDetailViewController.previewMode = 1;
    QueryActivityInfo *dict = self.infoNewDict;
    dict.title = self.titleTextField.text;
    dict.content = self.textView.text;
    dict.source=@"3";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
    dict.publishTime=[formatter stringFromDate:[NSDate date]];
    marketDetailViewController.infoDict = (QueryActivityInfo *)dict;
        marketDetailViewController.userType = USETYPE_PE;//预览模式
    [self.navigationController pushViewController:marketDetailViewController animated:YES];
    }
}

- (void)publishMarketActivity:(id)sender
{
    
    if (QWGLOBALMANAGER.currentNetWork==kNotReachable) {
        [self showError:kWaring12];
        return;
    }
    
    
    if([self.titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0){
         [self showError:@"您还没有输入标题"];
        return;
    }
    if([self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
         [self showError:@"您还没有输入内容"];
        return;
    }
    if(self.titleTextField.text.length > 20){
        [SVProgressHUD showErrorWithStatus:@"门店海报的标题不能超过20字!"
                                  duration:DURATION_SHORT];
        return;
    }
    if(self.textView.text.length > 200) {
        [SVProgressHUD showErrorWithStatus:@"请填写门店海报的内容不得超过200字!"
                                  duration:DURATION_SHORT];
        return;
    }
   
    if(StrIsEmpty(self.infoNewDict.imageSrc)||(!self.previewImage.image))
    {
        
        [SVProgressHUD showErrorWithStatus:@"请上传海报图片"
                                  duration:DURATION_SHORT];
        return;
    }
    
    
    pushlishBarbutton.enabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    if(self.infoNewDict.imageSrc)
    {
        //图片上传到服务器
        UIImage *image = self.infoNewDict.imageSrc;
        image=[QYImage fixImageOrientation:image];
        NSData *imageData = UIImageJPEGRepresentation(image,1.0);
        
        
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"token"] = QWGLOBALMANAGER.configure.userToken;
        setting[@"type"] = @(2);
        
        
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:imageData];
        
        HttpClientMgr.progressEnabled=YES;
        
        //fixed by lijian at 3.1.0
        [[QWLoading instance] showLoading];

        [[HttpClient sharedInstance]uploaderImg:array params:setting withUrl:NW_uploadFile success:^(id responseObj) {
            
            //fixed by lijian at 3.1.0
            [[QWLoading instance] removeLoading];

            if([responseObj[@"body"][@"apiStatus"] intValue]==1){
            [self showError:responseObj[@"body"][@"apiMessage"]];
            pushlishBarbutton.enabled = YES;
            }else{
             [self publishActivity:responseObj[@"body"][@"url"]];
            }
        } failure:^(HttpException *e) {
            //fixed by lijian at 3.1.0
            [[QWLoading instance] removeLoading];

             pushlishBarbutton.enabled = YES;
        } uploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            //fixed by lijian at 3.1.0
            [[QWLoading instance] removeLoading];

        }];
       
    }else{
    
        if(!self.previewImage.image)
        {
            
            [SVProgressHUD showErrorWithStatus:@"请上传海报图片"
                                      duration:DURATION_SHORT];
            return;
            
//            [self publishActivity:nil];
        }else{
            [self publishActivity:self.infoNewDict.imgUrl];
        }
        
    }

}

- (void)publishActivity:(NSString *)imagrUrl
{
    if([self.oldDict.content isEqualToString:self.textView.text] && [self.oldDict.title isEqualToString:self.titleTextField.text] && ((!imagrUrl && !self.oldDict.imgUrl) || [imagrUrl isEqualToString:self.oldDict.imgUrl]))
    {
        [self.navigationController popViewControllerAnimated:YES];
        [self showError:@"您没有修改任何内容"];
        return;
    }
    
    
    SaveActivityR *modelR=[SaveActivityR new];
    if(imagrUrl) {
        modelR.imgUrl = imagrUrl;
    }
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.title=[self.titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    modelR.content=[self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    [Activity SaveOrUpdateActivityWithParams:modelR success:^(id resultObj) {
        ActivityModel *model=resultObj;
        
        if([model.apiStatus intValue]==0){
            [SVProgressHUD showSuccessWithStatus:@"发布成功"];
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIViewController *viewController=(UIViewController *)obj;
            if ([viewController isKindOfClass:[MarketingActivityViewController class]]) {
                [self.navigationController popToViewController:viewController animated:YES];
            }else if(idx == (self.navigationController.viewControllers.count - 1)){
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        }else{
        [self showError:kWaring35];
        pushlishBarbutton.enabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
        }
    } failure:^(HttpException *e) {
        [self showError:kWaring35];
        pushlishBarbutton.enabled = YES;
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
