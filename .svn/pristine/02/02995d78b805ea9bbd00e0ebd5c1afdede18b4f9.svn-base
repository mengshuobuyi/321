//
//  PostCommentViewController.m
//  APP
//
//  Created by Martin.Liu on 16/4/18.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "PostCommentViewController.h"
#import "TKTextView.h"
#import "Forum.h"
#import "SVProgressHUD.h"
#define QWPostCommentTextViewMaxLength 500

@interface PostCommentViewController ()<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet TKTextView *textView;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_tipLabelBottom;

@end

@implementation PostCommentViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"发表评论";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    self.textView.delegate = self;
    [self.textView becomeFirstResponder];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(postNaviBtnAction:)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(backNaviBtnAction:)]];
}

- (void)UIGlobal
{
    if (self.postCommentType == QWPostCommentTypeReplyPost) {
        self.textView.placeholder = @"发表评论...";
//        self.title = @"发表评论";
    }
    else if (self.postCommentType == QWPostCommentTypeReplyComment)
    {
        self.textView.placeholder = @"回复评论...";
//        self.title = @"回复评论";
    }
    self.textView.font = [UIFont systemFontOfSize:kFontS1];
    self.textView.textColor = RGBHex(qwColor6);
    self.tipLabel.font = [UIFont systemFontOfSize:kFontS1];
    self.tipLabel.textColor = RGBHex(qwColor9);
}

- (void)backNaviBtnAction:(UIBarButtonItem*)barbtn
{
    [self popVCAction:nil];
}

- (void)postNaviBtnAction:(UIBarButtonItem*)barbtn
{
    if (self.textView.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写评论内容" duration:DURATION_LONG];
        return;
    }
    if (self.textView.text.length > QWPostCommentTextViewMaxLength) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"评论内容最大支持%d字", QWPostCommentTextViewMaxLength] duration:DURATION_LONG];
        return;
    }
    if (self.textView.text.length > 0 && self.textView.text.length <= QWPostCommentTextViewMaxLength) {
        [self replyPostAction];
    }
}

#pragma mark UITextView delegate
// 控制在500字以内
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (text.length > 0 && textView.text.length >= QWPostCommentTextViewMaxLength) {
        return NO;
    }
    return YES;
}

// 改变提示标签的内容
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > QWPostCommentTextViewMaxLength) {
        textView.text = [textView.text substringToIndex:QWPostCommentTextViewMaxLength];
    }
    self.tipLabel.text = [NSString stringWithFormat:@"%ld/%d", textView.text.length, QWPostCommentTextViewMaxLength];
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSValue* keyRectVal = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyFrame = [keyRectVal CGRectValue];
    if (keyFrame.size.height > self.constraint_tipLabelBottom.constant) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.constraint_tipLabelBottom.constant = keyFrame.size.height + 0.5;
            [self.view layoutIfNeeded];
        
        } completion:nil];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark 回帖操作
- (void)replyPostAction
{
    // 隐藏键盘
    [self.view endEditing:YES];
    
    ReplyPostR* replyPostR = [ReplyPostR new];
    replyPostR.token = QWGLOBALMANAGER.configure.expertToken;
    replyPostR.posterId = QWGLOBALMANAGER.configure.expertPassportId;
    replyPostR.teamId = self.teamId;
    replyPostR.postId = self.postId;
    replyPostR.postTitle = self.postTitle;
    replyPostR.content = self.textView.text;
    replyPostR.replyId = self.replyId;
    [Forum replyPost:replyPostR success:^(BaseAPIModel *baseAPIModel) {
        if ([baseAPIModel.apiStatus integerValue] ==0) {
            NSString* successMessage = StrIsEmpty(baseAPIModel.apiMessage) ? @"发表成功" : baseAPIModel.apiMessage;
            [SVProgressHUD showSuccessWithStatus:successMessage];
            // 返回上一页
            [QWGLOBALMANAGER postNotif:NotiPostCommentSuccess data:nil object:nil];
            [self popVCAction:nil];
        }
        else
        {
            NSString* errorMessage = StrIsEmpty(baseAPIModel.apiMessage) ? @"发表失败！" : baseAPIModel.apiMessage;
            [SVProgressHUD showErrorWithStatus:errorMessage];
        }
    } failure:^(HttpException *e) {
        DebugLog(@"reply post error : %@", e);
    }];
}

@end
