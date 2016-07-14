//
//  FeedbackViewController.m
//  APP
//
//  Created by qwfy0006 on 15/3/18.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "FeedbackViewController.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "FeedBackModelR.h"
#import "FeedBack.h"

@interface FeedbackViewController ()<UITextViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet    UITextView      *textView;
@property (weak, nonatomic) IBOutlet    UILabel         *placeholder;
@property (weak, nonatomic) IBOutlet    UILabel         *limitWord;
@property (weak, nonatomic) IBOutlet    UITextField     *QQTextField;
@property (weak, nonatomic) IBOutlet    UIButton        *QQButton;

@property (strong, nonatomic) UIButton *feedBackButton;

- (IBAction)QQButtonClick:(id)sender;

@end

@implementation FeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textView.delegate = self;
    self.title = @"意见反馈";
    
    if (iOSv7 && self.view.frame.origin.y==0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    self.feedBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.feedBackButton.frame = CGRectMake(0, 0, 40, 20);
    [self.feedBackButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.feedBackButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.feedBackButton];
    
//    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleBordered target:self action:@selector(rightButtonClick)];
//    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self.view endEditing:YES];
}

#pragma mark ====
#pragma mark ==== 提交意见反馈

- (void)rightButtonClick{
    self.feedBackButton.enabled = NO;
    [self.textView resignFirstResponder];
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:0.8];
        self.feedBackButton.enabled = YES;
        return;
    }
    
    if (self.textView.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"您没有反馈任何意见哦~" duration:DURATION_SHORT];
        self.feedBackButton.enabled = YES;
        return;
    }else if (self.textView.text.length > 200){
        [SVProgressHUD showErrorWithStatus:@"反馈内容不能超过200字哦!" duration:DURATION_SHORT];
        self.feedBackButton.enabled = YES;
        return;
    }else{
        
        FeedBackModelR *model = [FeedBackModelR new];
        model.content = self.textView.text;
        model.source = @"7";
        model.type = @"1";
        
        if (IS_EXPERT_ENTRANCE) {
            if (QWGLOBALMANAGER.configure.expertToken) {
                model.token = QWGLOBALMANAGER.configure.expertToken;
            }
        }else{
            if (QWGLOBALMANAGER.configure.userToken) {
                model.token = QWGLOBALMANAGER.configure.userToken;
            }
        }
        
        [FeedBack SubmitFeedBackWithParams:model success:^(id obj) {
            [SVProgressHUD showSuccessWithStatus:@"收到您的反馈了，非常感谢!" duration:DURATION_LONG];
            
            /** 跳转到聊天界面 **/
            
            self.feedBackButton.enabled = YES;
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(HttpException *e) {
            self.feedBackButton.enabled = YES;
        }];
        
    }
}

#pragma mark ====
#pragma mark ====UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.placeholder.text = @"请提出您的宝贵意见，我们会及时进行解决~~";
        CGFloat length = textView.text.length;
        int len = 200-length;
        self.limitWord.text = [NSString stringWithFormat:@"%d字",len];
    }else{
        self.placeholder.text = @"";
        CGFloat length = textView.text.length;
        int len = 200-length;
        self.limitWord.text = [NSString stringWithFormat:@"%d字",len];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *temp = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (temp.length > 200) {
        textView.text = [temp substringToIndex:200];
        self.limitWord.text =@"0字";
        self.placeholder.text = @"";
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textView resignFirstResponder];
    [self.QQTextField resignFirstResponder];
}

- (IBAction)QQButtonClick:(id)sender {
}


@end
