//
//  ExpertCommentViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/7.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ExpertCommentViewController.h"
#import "MGSwipeButton.h"
#import "ExpertCommentCell.h"
#import "Circle.h"
#import "CircleModel.h"
#import "PostDetailViewController.h"
#import "ExpertInfoViewController.h"

@interface ExpertCommentViewController ()<UITableViewDataSource,UITableViewDelegate,MGSwipeTableCellDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataList;

//回复
@property (strong, nonatomic) UIView *viewBottomBar;
@property (strong, nonatomic) UITextView *applyTextView;
@property (strong, nonatomic) UIView *textFieldBgView;
@property (strong, nonatomic) UILabel *sepatorLine;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *sendButton;
@property (strong, nonatomic) UILabel *placeholder;

// 键盘相关
@property (assign, nonatomic) NSTimeInterval animationDuration;
@property (assign, nonatomic) UIViewAnimationCurve animationCurve;
@property (assign, nonatomic) float viewBottomBarY;
@property (assign, nonatomic) CGRect viewBottomBaRect;
@property (assign, nonatomic) CGRect keyboardFrame;

//回复框是否显示placeHolder
@property (assign, nonatomic) BOOL showPlaceholder;
@property (assign, nonatomic) int indexPathRow;

@end

@implementation ExpertCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.indexPathRow = 0;
    self.dataList = [NSMutableArray array];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self configureApplyUI];
    self.applyTextView.delegate = self;
    
    //下拉刷新
    __weak ExpertCommentViewController *weakSelf = self;
    [self enableSimpleRefresh:self.tableView block:^(SRRefreshView *sender) {
        
        if (QWGLOBALMANAGER.currentNetWork != kNotReachable)
        {
            HttpClientMgr.progressEnabled = NO;
            [weakSelf queryList];
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"网络未连接，请重试！" duration:0.8];
        }
    }];
}

#pragma mark ---- 获取评论数据 ----
- (void)queryList
{    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"msgClass"] = @"1";
    
    [Circle TeamMessageWithParams:setting success:^(id obj) {
        
        TeamMessagePageModel *page = [TeamMessagePageModel parse:obj Elements:[TeamMessageModel class] forAttribute:@"msglist"];
        
        //设置评论消息已读
        [self markMessageRead];
        
        QWGLOBALMANAGER.configure.expertCommentRed = NO;
        [QWGLOBALMANAGER saveAppConfigure];
        [QWGLOBALMANAGER postNotif:NotifHiddenCommentRedPoint data:nil object:nil];
        
        if ([page.apiStatus integerValue] == 0)
        {
            if (page.msglist.count > 0)
            {
                [self.dataList removeAllObjects];
                [self.dataList addObjectsFromArray:page.msglist];
                [self.tableView reloadData];
            }else
            {
                [self showInfoView:@"您还没有消息" image:@"ic_img_fail"];
            }
        }else
        {
            [SVProgressHUD showErrorWithStatus:page.apiMessage];
        }
    } failure:^(HttpException *e) {
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [self showInfoView:kWaring12 image:@"img_network"];
        }else
        {
            if(e.errorCode != -999){
                if(e.errorCode == -1001){
                    [self showInfoView:kWarning215N54 image:@"ic_img_fail"];
                }else{
                    [self showInfoView:kWarning215N0 image:@"ic_img_fail"];
                }
            }
        }
    }];
}

#pragma mark ---- 设置评论消息为已读 ----
- (void)markMessageRead
{
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"readFlag"] = @"Y";
    setting[@"msgClass"] = @"1";
    [Circle TeamChangeMsgReadFlagByMsgClassWithParams:setting success:^(id obj) {
        
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ---- 设置回复框UI ----
- (void)configureApplyUI
{
    self.viewBottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H-39-64, APP_W, 128)];
    [self.view addSubview:self.viewBottomBar];
    [self.view bringSubviewToFront:self.viewBottomBar];
    self.viewBottomBar.backgroundColor = [UIColor whiteColor];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 0.5)];
    line.backgroundColor = RGBHex(qwColor10);
    [self.viewBottomBar addSubview:line];
    
    //取消按钮
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.frame = CGRectMake(0, 5, 70, 30);
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:RGBHex(qwColor6) forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = fontSystem(kFontS1);
    [self.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.viewBottomBar addSubview:self.cancelButton];
    
    //发送按钮
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendButton.frame = CGRectMake(APP_W-70, 5, 70, 30);
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:RGBHex(qwColor6) forState:UIControlStateNormal];
    self.sendButton.titleLabel.font = fontSystem(kFontS1);
    [self.sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [self.viewBottomBar addSubview:self.sendButton];
    
    self.textFieldBgView = [[UIView alloc] initWithFrame:CGRectMake(15, 35, APP_W-30, 85)];
    self.textFieldBgView.layer.cornerRadius = 4.0;
    self.textFieldBgView.layer.masksToBounds = YES;
    self.textFieldBgView.layer.borderColor = RGBHex(qwColor9).CGColor;
    self.textFieldBgView.layer.borderWidth = 0.5;
    [self.viewBottomBar addSubview:self.textFieldBgView];
    
    //输入框
    self.applyTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, APP_W-30, 85)];
    self.applyTextView.delegate = self;
    self.applyTextView.returnKeyType = UIReturnKeyDefault;
    [self.textFieldBgView addSubview:self.applyTextView];
    self.applyTextView.layoutManager.allowsNonContiguousLayout = NO;
    
    self.placeholder = [[UILabel alloc] initWithFrame:CGRectMake(3, 7, 80, 14)];
    self.placeholder.text = @"回复...";
    self.placeholder.font = fontSystem(kFontS5);
    self.placeholder.textColor = RGBHex(qwColor8);
    [self.textFieldBgView addSubview:self.placeholder];
    
}

#pragma mark ---- 键盘操作相关 ----
- (void)viewDidCurrentView
{
    [self queryList];
    [self markMessageRead];
    QWGLOBALMANAGER.configure.expertCommentRed = NO;
    [QWGLOBALMANAGER saveAppConfigure];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewEditChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewEditChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.applyTextView resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification*)aNotification
{
    [self scrollViewForKeyboard:aNotification up:YES];
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
    [self scrollViewForKeyboard:aNotification up:NO];
}

- (void)scrollViewForKeyboard:(NSNotification*)aNotification up:(BOOL) up{
    
    if (aNotification!=nil) {
        NSDictionary* userInfo = [aNotification userInfo];
        
        [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&_animationCurve];
        [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&_animationDuration];
        [[userInfo valueForKey:@"UIKeyboardCenterBeginUserInfoKey"] CGPointValue];
        [[userInfo valueForKey:@"UIKeyboardCenterEndUserInfoKey"] CGPointValue];
        
        self.keyboardFrame = [[userInfo valueForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:self.animationDuration];
    [UIView setAnimationCurve:self.animationCurve];
    
    float nowViewBottomBarY = (up)?SCREEN_H-64-39-self.viewBottomBar.frame.size.height-self.keyboardFrame.size.height:SCREEN_H-64-39;
    [self.viewBottomBar setFrame:CGRectMake(self.viewBottomBar.frame.origin.x,  nowViewBottomBarY, self.viewBottomBar.frame.size.width, self.viewBottomBar.frame.size.height)];
    [UIView commitAnimations];
}

#pragma mark ---- UITableViewDelegate ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 7;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 7)];
    vi.backgroundColor = [UIColor clearColor];
    return vi;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ExpertCommentCell getCellHeight:self.dataList[indexPath.section]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpertCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExpertCommentCell"];
    [cell setCell:self.dataList[indexPath.section]];
    cell.swipeDelegate = self;
    
    //申请按钮
    cell.applyButton.obj = indexPath;
    cell.topicBgView.obj = indexPath;
    [cell.applyButton addTarget:self action:@selector(applyAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //点击进入帖子详情
    cell.topicBgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpCircleDetail:)];
    [cell.topicBgView addGestureRecognizer:tap];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
}

#pragma mark ---- MGSwipeTableCellDelegate ----
- (NSArray *)swipeTableCell:(MGSwipeTableCell*)cell swipeButtonsForDirection:(MGSwipeDirection)direction swipeSettings:(MGSwipeSettings*)swipeSettings expansionSettings:(MGSwipeExpansionSettings*)expansionSettings;
{
    if (direction == MGSwipeDirectionRightToLeft) {
        return [self createRightButtons:1];
    }
    return nil;
}

- (BOOL)swipeTableCell:(MGSwipeTableCell*)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion
{
    NSIndexPath *indexPath = nil;
    if (index == 0)
    {
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
            return NO;
        }
        
        indexPath = [self.tableView indexPathForCell:cell];
        
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [SVProgressHUD showErrorWithStatus:kWaring33];
            return NO;
        }
        
        //接口删除
        TeamMessageModel *model = self.dataList[indexPath.section];
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
        setting[@"showFlag"] = @"N";
        setting[@"msgId"] = StrFromObj(model.id);
        [Circle TeamChangeMessageShowFlagWithParams:setting success:^(id obj) {
            
            if ([obj[@"apiStatus"] integerValue] == 0)
            {
                [SVProgressHUD showSuccessWithStatus:@"删除成功！"];
                [self queryList];
                [self.tableView reloadData];
            }else
            {
                [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"]];
            }
        } failure:^(HttpException *e) {
            
        }];
    }
    return YES;
}

- (NSArray *)createRightButtons: (int) number
{
    NSMutableArray * result = [NSMutableArray array];
    NSString* titles[1] = {@"删除"};
    UIColor * colors[1] = {RGBHex(qwColor3)};
    for (int i = 0; i < number; ++i)
    {
        MGSwipeButton * button = [MGSwipeButton buttonWithTitle:titles[i] backgroundColor:colors[i] callback:^BOOL(MGSwipeTableCell * sender){
            return YES;
        }];
        [result addObject:button];
    }
    return result;
}

#pragma mark ---- 监听文本变化 ----
-(void)textViewEditChanged:(NSNotification *)obj
{
    UITextView *textView = (UITextView *)obj.object;
    NSString *toBeString = textView.text;
    NSString *lang = [[textView textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 500) {
                textView.text = [toBeString substringToIndex:500];
            }
            [self setRemainWord:textView.text.length];
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > 500) {
            textView.text = [toBeString substringToIndex:500];
        }
        [self setRemainWord:textView.text.length];
    }
}

// 设置剩余输入字数
- (void)setRemainWord:(NSInteger)wordInputted
{
    if (self.applyTextView.text.length == 0)
    {
        [self setTextViewPlaceholder:YES];
    } else
    {
        [self setTextViewPlaceholder:NO];
    }
}

// 设置文本框的Placeholder
- (void)setTextViewPlaceholder:(BOOL)didSet
{
    if (didSet&&self.applyTextView.text.length == 0)
    {
        self.placeholder.text = @"回复...";
        self.placeholder.hidden = NO;
        self.showPlaceholder = YES;
    } else
    {
        self.placeholder.hidden = YES;
        self.showPlaceholder = NO;
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0)
    {
        //显示提示
        [self setTextViewPlaceholder:YES];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (self.showPlaceholder&&self.applyTextView.text.length>0)
    {
        //光标键入，消失提示
        [self setTextViewPlaceholder:NO];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (self.applyTextView.text.length == 0)
    {
        //内容变化进行的操作
        [self setTextViewPlaceholder:YES];
    }else
    {
        [self setTextViewPlaceholder:NO];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    if (location != NSNotFound){
        return YES;
    }
    return YES;
}

#pragma mark ---- 进入帖子详情 ----
- (void)jumpCircleDetail:(UITapGestureRecognizer *)tap
{
    QWView *view = (QWView *)tap.view;
    NSIndexPath *indexPath = (NSIndexPath *)view.obj;
    TeamMessageModel *model = self.dataList[indexPath.section];

    PostDetailViewController* postDetailVC = [[UIStoryboard storyboardWithName:@"Forum" bundle:nil] instantiateViewControllerWithIdentifier:@"PostDetailViewController"];
    postDetailVC.postId = model.sourceId;
    postDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:postDetailVC animated:YES];
}

#pragma mark ---- 回复 ----
- (void)applyAction:(id)sender
{
    QWButton *btn = (QWButton *)sender;
    NSIndexPath *indexPath = (NSIndexPath *)btn.obj;
    
    self.indexPathRow = indexPath.section;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.applyTextView becomeFirstResponder];
    });
}

#pragma mark ---- 取消 ----
- (void)cancelAction
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.applyTextView.text = @"";
        [self.view endEditing:YES];
    });
}

#pragma mark ---- 发送 ----
- (void)sendAction
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    
    TeamMessageModel *model = self.dataList[self.indexPathRow];
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"postId"] = StrFromObj(model.sourceId);
    setting[@"content"] = StrFromObj(self.applyTextView.text);
    setting[@"replyId"] = StrFromObj(model.replyId);
    
    [Circle TeamPostReplyWithParams:setting success:^(id obj) {

        BaseAPIModel *model = [BaseAPIModel parse:obj];
        if ([model.apiStatus integerValue] == 0)
        {
            self.applyTextView.text = @"";
            [self.applyTextView resignFirstResponder];
            [SVProgressHUD showSuccessWithStatus:@"评论成功！"];
        }else if ([model.apiStatus integerValue] == 10 || [model.apiStatus integerValue] == 11)
        {
            [SVProgressHUD showErrorWithStatus:model.apiMessage];
        }
        else
        {
            [self.applyTextView resignFirstResponder];
            [SVProgressHUD showErrorWithStatus:model.apiMessage];
        }
    } failure:^(HttpException *e) {
        self.applyTextView.text = @"";
        [self.applyTextView resignFirstResponder];
    }];
}

- (void)viewInfoClickAction:(id)sender
{
    [self removeInfoView];
    [self queryList];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
