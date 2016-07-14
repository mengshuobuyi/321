//
//  XHMessageTableViewController.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMessageTableViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "TQRichTextURLRun.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "LeveyPopListView.h"
#import "Store.h"
#import "IMApi.h"
#import "PopupMarketActivityView.h"
#import "SearchSliderViewController.h"
#import "HealthQASearchViewController.h"
#import "Activity.h"
#import "DFMultiPhotoSelectorViewController.h"
#import "XMPPStream.h"
#import "UIImage+Ex.h"
#import "QWMessage.h"
#import "HttpClient.h"
#import "Consult.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

#import "QYPhotoAlbum.h"
#import "PhotoAlbum.h"

#import "QuickSearchDrugViewController.h"
#import "DrugModel.h"
#import "ConsultPTP.h"

#import "MarketingActivityViewController.h"
#import "CoupnViewController.h"

@interface XHMessageTableViewController ()<LeveyPopListViewDelegate,MarketActivityViewDelegate,DFMultiPhotoSelectorViewControllerDelegate>
{
    
    UIImage * willsendimg;
}
/**
 *  记录旧的textView contentSize Heigth
 */

@property (nonatomic, strong) PopupMarketActivityView *popupMarketActivityView;

@property (nonatomic, assign) CGFloat previousTextViewContentHeight;

/**
 *  记录键盘的高度，为了适配iPad和iPhone
 */
@property (nonatomic, assign) CGFloat keyboardViewHeight;

@property (nonatomic, assign) XHInputViewType textViewInputViewType;

@property (nonatomic, weak, readwrite) XHMessageInputView *messageInputView;
@property (nonatomic, weak, readwrite) XHShareMenuView *shareMenuView;
@property (nonatomic, weak, readwrite) XHEmotionManagerView *emotionManagerView;
@property (nonatomic, strong, readwrite) XHVoiceRecordHUD *voiceRecordHUD;

@property (nonatomic, strong) UIActivityIndicatorView *loadMoreActivityIndicatorView;

/**
 *  管理本机的摄像和图片库的工具对象
 */
@property (nonatomic, strong) XHPhotographyHelper *photographyHelper;

#pragma mark - DataSource Change
/**
 *  改变数据源需要的子线程
 *
 *  @param queue 子线程执行完成的回调block
 */
- (void)exChangeMessageDataSourceQueue:(void (^)())queue;

/**
 *  执行块代码在主线程
 *
 *  @param queue 主线程执行完成回调block
 */
- (void)exMainQueue:(void (^)())queue;

#pragma mark - Previte Method
/**
 *  判断是否允许滚动
 *
 *  @return 返回判断结果
 */
- (BOOL)shouldAllowScroll;

#pragma mark - Life Cycle
/**
 *  配置默认参数
 */
- (void)setup;

/**
 *  初始化显示控件
 */
- (void)initilzer;

#pragma mark - RecorderPath Helper Method
/**
 *  获取录音的路径
 *
 *  @return 返回录音的路径
 */
- (NSString *)getRecorderPath;

#pragma mark - UITextView Helper Method
/**
 *  获取某个UITextView对象的content高度
 *
 *  @param textView 被获取的textView对象
 *
 *  @return 返回高度
 */
- (CGFloat)getTextViewContentH:(UITextView *)textView;

#pragma mark - Layout Message Input View Helper Method
/**
 *  动态改变TextView的高度
 *
 *  @param textView 被改变的textView对象
 */
- (void)layoutAndAnimateMessageInputTextView:(UITextView *)textView;

#pragma mark - Scroll Message TableView Helper Method
/**
 *  根据bottom的数值配置消息列表的内部布局变化
 *
 *  @param bottom 底部的空缺高度
 */
- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom;

/**
 *  根据底部高度获取UIEdgeInsets常量
 *
 *  @param bottom 底部高度
 *
 *  @return 返回UIEdgeInsets常量
 */
- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom;

#pragma mark - Message Calculate Cell Height
/**
 *  统一计算Cell的高度方法
 *
 *  @param message   被计算目标消息对象
 *  @param indexPath 被计算目标消息所在的位置
 *
 *  @return 返回计算的高度
 */
- (CGFloat)calculateCellHeightWithMessage:(id <XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Message Send helper Method
/**
 *  根据文本开始发送文本消息
 *
 *  @param text 目标文本
 */
- (void)didSendMessageWithText:(NSString *)text;
/**
 *  根据图片开始发送图片消息
 *
 *  @param photo 目标图片
 */
- (void)didSendMessageWithPhoto:(UIImage *)photo;

@end

@implementation XHMessageTableViewController

#pragma mark - DataSource Change

- (void)exChangeMessageDataSourceQueue:(void (^)())queue {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), queue);
}

- (void)exMainQueue:(void (^)())queue
{
    dispatch_async(dispatch_get_main_queue(), queue);
}

- (void)addCacheMessage:(NSMutableArray *)messageList
{
    NSMutableArray *messages = [NSMutableArray arrayWithArray:self.messages];
    
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:10];
    for(NSUInteger index = 0; index < messageList.count ; ++index)
    {
        [indexPaths addObject:[NSIndexPath indexPathForRow:messages.count + index inSection:0]];
    }
    [messages addObjectsFromArray:messageList];
    self.messages = messages;
    [self.messageTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self scrollToBottomAnimated:YES];
    [messageList removeAllObjects];
}

- (void)addMessages:(NSArray *)addedMessages
{
    [self.messages addObjectsFromArray:addedMessages];
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:2];
    [indexPaths addObject:[NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0]];
    [indexPaths addObject:[NSIndexPath indexPathForRow:self.messages.count - 2 inSection:0]];
    WEAKSELF
    [weakSelf exMainQueue:^{
        [weakSelf.messageTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        [weakSelf scrollToBottomAnimated:NO];
    }];
}

- (void)addMessage:(XHMessage *)addedMessage {
    [self.messages addObject:addedMessage];
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:1];
    [indexPaths addObject:[NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0]];
    
    WEAKSELF
    [weakSelf exMainQueue:^{
        [weakSelf.messageTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        [weakSelf scrollToBottomAnimated:NO];
    }];
}

- (void)removeMessageAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.messages.count)
        return;
    [self.messages removeObjectAtIndex:indexPath.row];
    
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:1];
    [indexPaths addObject:indexPath];
    
    [self.messageTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
}

static CGPoint  delayOffset = {0.0};
// http://stackoverflow.com/a/11602040 Keep UITableView static when inserting rows at the top
- (void)insertOldMessages:(NSArray *)oldMessages {
    WEAKSELF
    [self exChangeMessageDataSourceQueue:^{
        NSMutableArray *messages = [NSMutableArray arrayWithArray:oldMessages];
        [messages addObjectsFromArray:self.messages];
        
        delayOffset = weakSelf.messageTableView.contentOffset;
        NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:oldMessages.count];
        [oldMessages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            [indexPaths addObject:indexPath];
            
            delayOffset.y += [weakSelf calculateCellHeightWithMessage:[messages objectAtIndex:idx] atIndexPath:indexPath];
        }];
        
        [weakSelf exMainQueue:^{
            [UIView setAnimationsEnabled:NO];
            [weakSelf.messageTableView beginUpdates];
            weakSelf.messages = messages;
            [weakSelf.messageTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            
            [weakSelf.messageTableView setContentOffset:delayOffset animated:NO];
            [weakSelf.messageTableView endUpdates];
            [UIView setAnimationsEnabled:YES];
            
        }];
    }];
}

#pragma mark - Propertys

- (NSMutableArray *)messages {
    if (!_messages) {
        _messages = [[NSMutableArray alloc] initWithCapacity:50];
    }
    return _messages;
}


- (void)setLoadingMoreMessage:(BOOL)loadingMoreMessage {
    _loadingMoreMessage = loadingMoreMessage;
    if (loadingMoreMessage) {
        [self.loadMoreActivityIndicatorView startAnimating];
    } else {
        [self.loadMoreActivityIndicatorView stopAnimating];
    }
}

- (XHShareMenuView *)shareMenuView {
    if (!_shareMenuView) {
        XHShareMenuView *shareMenuView = [[XHShareMenuView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), 180)];
        shareMenuView.delegate = self;
        shareMenuView.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
        shareMenuView.alpha = 0.0;
        shareMenuView.shareMenuItems = self.shareMenuItems;
        [self.view addSubview:shareMenuView];
        _shareMenuView = shareMenuView;
    }
    [self.view bringSubviewToFront:_shareMenuView];
    return _shareMenuView;
}

- (XHEmotionManagerView *)emotionManagerView {
    if (!_emotionManagerView) {
        XHEmotionManagerView *emotionManagerView = [[XHEmotionManagerView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), self.keyboardViewHeight)];
        emotionManagerView.delegate = self;
        emotionManagerView.dataSource = self;
        emotionManagerView.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
        emotionManagerView.alpha = 0.0;
        [emotionManagerView.emotionSectionBar.storeManagerItemButton addTarget:self action:@selector(didSendTextMessage:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:emotionManagerView];
        _emotionManagerView = emotionManagerView;
    }
    [self.view bringSubviewToFront:_emotionManagerView];
    return _emotionManagerView;
}

- (XHPhotographyHelper *)photographyHelper {
    if (!_photographyHelper) {
        _photographyHelper = [[XHPhotographyHelper alloc] init];
    }
    return _photographyHelper;
}

#pragma mark - Messages View Controller
- (void)finishSendMessageWithBubbleMessageType:(XHBubbleMessageMediaType)mediaType {
    switch (mediaType) {
        case XHBubbleMessageMediaTypeText: {
            [self.messageInputView.inputTextView setText:nil];
            //[self.messageInputView.inputTextView resignFirstResponder];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                self.messageInputView.inputTextView.enablesReturnKeyAutomatically = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.messageInputView.inputTextView.enablesReturnKeyAutomatically = YES;
                    [self.messageInputView.inputTextView reloadInputViews];
                    self.popupMarketActivityView.replyTextField.text = @"";
                });
            }
            break;
        }
        default:
            break;
    }
}

- (void)setBackgroundColor:(UIColor *)color {
    self.view.backgroundColor = color;
    _messageTableView.backgroundColor = color;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    self.messageTableView.backgroundView = nil;
    self.messageTableView.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
}

- (void)scrollToBottomAnimated:(BOOL)animated {
	if (![self shouldAllowScroll] || self.shouldPreventAutoScrolling)
        return;
	
    NSInteger rows = [self.messageTableView numberOfRowsInSection:0];
    
    if (rows > 0) {
        [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath
			  atScrollPosition:(UITableViewScrollPosition)position
					  animated:(BOOL)animated {
	if (![self shouldAllowScroll])
        return;
	
	[self.messageTableView scrollToRowAtIndexPath:indexPath
						  atScrollPosition:position
								  animated:animated];
}

#pragma mark - Previte Method

- (BOOL)shouldAllowScroll {
    if (self.isUserScrolling) {
        if ([self.delegate respondsToSelector:@selector(shouldPreventScrollToBottomWhileUserScrolling)]
            && [self.delegate shouldPreventScrollToBottomWhileUserScrolling]) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - Life Cycle
- (void)setup {
    // iPhone or iPad keyboard view height set here.
    self.keyboardViewHeight = (kIsiPad ? 264 : 216);
    _allowsPanToDismissKeyboard = YES;
    _allowsSendVoice = NO;
    _allowsSendMultiMedia = YES;
    _allowsSendFace = YES;
    _inputViewStyle = XHMessageInputViewStyleFlat;
    
    self.delegate = self;
    self.dataSource = self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [self setup];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    
}

- (void)footerRereshing
{
    
}

- (void)initilzer {
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    // 默认设置用户滚动为NO
    _isUserScrolling = NO;
    
    // 初始化message tableView
    CGRect rect = self.view.bounds;
    rect.size.height -= 45 ;
	XHMessageTableView *messageTableView = [[XHMessageTableView alloc] initWithFrame:rect style:UITableViewStylePlain];
	messageTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth ;
	messageTableView.dataSource = self;
	messageTableView.delegate = self;
    messageTableView.separatorColor = [UIColor clearColor];
    messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //[messageTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    [self enableSimpleRefresh:messageTableView block:^(SRRefreshView *sender) {
        [self headerRereshing];
    }];
    
    messageTableView.headerPullToRefreshText = @"下拉可以刷新了";
    messageTableView.headerReleaseToRefreshText = @"松开马上刷新了";
    messageTableView.headerRefreshingText = @"正在帮你刷新中";
    
    [self.view addSubview:messageTableView];
    [self.view sendSubviewToBack:messageTableView];
	_messageTableView = messageTableView;
    
    // 设置Message TableView 的bottom edg
    
    // 设置整体背景颜色
    [self setBackgroundColor:RGBHex(qwColor11)];
    // 输入工具条的frame
    [self layoutDifferentMessageType];
    // 设置手势滑动，默认添加一个bar的高度值
    self.messageTableView.messageInputBarHeight = CGRectGetHeight(_messageInputView.bounds);
}

//根据不同的消息类型,初始化底部以及顶部状态栏(新建问题,解答中,已过期,已关闭)
- (void)layoutDifferentMessageType
{
    CGFloat inputViewHeight = (self.inputViewStyle == XHMessageInputViewStyleFlat) ? 45.0f : 40.0f;
    [self setTableViewInsetsWithBottomValue:inputViewHeight - 45];
    CGRect inputFrame = CGRectMake(0.0f,
                                   self.view.frame.size.height - inputViewHeight,
                                   self.view.frame.size.width,
                                   inputViewHeight);
    UIView *bottomView = nil;
    if(!_messageInputView) {
        _messageInputView = [self setupMessageInputView:inputFrame];
        [self.view addSubview:_messageInputView];
        [self.view bringSubviewToFront:_messageInputView];
    }
    [[self.view viewWithTag:1445] removeFromSuperview];
    if(self.showType == MessageShowTypeAsking)
    {
        bottomView = [self setupRacingBottomView:inputFrame];
        CGRect rect = self.messageTableView.frame;
        rect.size.height = self.view.frame.size.height - 64 - inputFrame.size.height;
        self.messageTableView.frame = rect;
        _messageInputView.alpha = 0.0f;
        [QWCLICKEVENT qwTrackPageBegin:@"XHDemoWeChatMessageTableViewController-dqd"];
    }else if(self.showType == MessageShowTypeClose){
        _messageInputView.alpha = 0.0f;
        bottomView = [self setupClosedBottomView:inputFrame];
        CGRect rect = self.messageTableView.frame;
        rect.size.height = self.view.frame.size.height - 64 - inputFrame.size.height;
        self.messageTableView.frame = rect;
        [QWCLICKEVENT qwTrackPageBegin:@"XHDemoWeChatMessageTableViewController-ygb"];
    }else{
        if(self.accountType != OfficialType) {
            self.headerHintView = [self setupCountDownHeaderView];
            if(self.mustAnswer) {
                self.headerHintView.hidden = NO;
                CGRect rect = self.messageTableView.frame;
                rect.size.height = self.view.frame.size.height - 64 - 32 - inputFrame.size.height;
                self.messageTableView.frame = rect;
                [self.view addSubview:self.headerHintView];
                
            }else{
                self.headerHintView.hidden = YES;
                CGRect rect = self.messageTableView.frame;
                rect.size.height = self.view.frame.size.height - 64 - inputFrame.size.height;
                self.messageTableView.frame = rect;
                [self.view addSubview:self.headerHintView];
            }
        }else{
            [QWCLICKEVENT qwTrackPageBegin:@"XHDemoWeChatMessageTableViewController-jdz"];
            CGRect rect = self.messageTableView.frame;
            rect.size.height = self.view.frame.size.height - 64 - inputFrame.size.height;
            self.messageTableView.frame = rect;
        }
        _messageInputView.alpha = 1.0f;
        //bottomView = _messageInputView;
    }
    if(bottomView) {
        bottomView.tag = 1445;
        [self.view addSubview:bottomView];
        [self.view bringSubviewToFront:bottomView];
    }
}

- (XHMessageInputView *)setupMessageInputView:(CGRect)inputFrame
{
    XHMessageInputView *inputView = [[XHMessageInputView alloc] initWithFrame:inputFrame];
    inputView.allowsSendFace = self.allowsSendFace;
    inputView.allowsSendVoice = self.allowsSendVoice;
    inputView.allowsSendMultiMedia = self.allowsSendMultiMedia;
    inputView.delegate = self;
    return inputView;
}

- (UIView *)setupCountDownHeaderView
{
    UIView *headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 32)];
    [headerView setBackgroundColor:RGBHex(qwColor15)];
    headerView.layer.borderWidth = 0.5;
    headerView.layer.borderColor = RGBHex(0xefd8ac).CGColor;
    headerView.alpha = 1.0;
    self.countDownLabel = [[UILabel alloc] init];
    _countDownLabel.font = [UIFont systemFontOfSize:13.0f];
    _countDownLabel.textColor = RGBHex(qwColor2);
    _countDownLabel.frame = headerView.bounds;
    _countDownLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:_countDownLabel];
    
    _alarmLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, (32.0 - 18 ) / 2.0f, 18, 18)];
    _alarmLogo.image = [UIImage imageNamed:@"icon_clock.png"];
    [headerView addSubview:_alarmLogo];
    [self setCountDownLabelText:@"该问题24小时后关闭"];
    return headerView;
}

- (void)setCountDownLabelText:(NSString *)text
{
    _countDownLabel.text = text;
    if(!self.mustAnswer && self.showType == MessageShowTypeAnswer) {
        self.headerHintView.alpha = 0.0f;
        [self delayDismissHeaderLabel];
    }else{
        CGFloat width = [text sizeWithFont:[UIFont systemFontOfSize:13.0f]].width;
        CGRect rect = _countDownLabel.frame;
        rect.size.width = width;
        rect.origin.x = (APP_W - width ) / 2.0 + 12.5f;
        _countDownLabel.frame = rect;
        
        rect = _alarmLogo.frame;
        rect.origin.x = (APP_W - width ) / 2.0 - 12.5;
        _alarmLogo.frame = rect;
    }
}

- (void)delayDismissHeaderLabel
{
    if(!_animateButton)
        _animateButton = [[NSBundle mainBundle] loadNibNamed:@"ExpandAnimateButton" owner:self options:nil][0];
    [self.view addSubview:_animateButton];
    [_animateButton setHintText:self.countDownLabel.text];
    NSLayoutConstraint *xConstraint = [NSLayoutConstraint constraintWithItem:_animateButton attribute:NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:APP_W - 50];
    xConstraint.priority = 750;
    [self.view addConstraint:xConstraint];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_animateButton attribute:NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:_animateButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:_animateButton.frame.size.width];
    widthConstraint.priority = 99;
    [_animateButton addConstraint:widthConstraint];
    
    [_animateButton addConstraint:[NSLayoutConstraint constraintWithItem:_animateButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:_animateButton.frame.size.height]];
    if(!self.countDownLabel.text || [self.countDownLabel.text isEqualToString:@""]) {
        _animateButton.hidden = YES;
    }
}

- (UIView *)setupRacingBottomView:(CGRect)inputFrame
{
    inputFrame.origin.y -= 64;
    UIView *bottomView = [[UIView alloc] initWithFrame:inputFrame];
    [bottomView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_bottom_answer"]]];
    UIButton *racingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [racingButton setBackgroundImage:[UIImage imageNamed:@"btn_answer_bg"] forState:UIControlStateNormal];
    [racingButton setTitle:@"我来答药" forState:UIControlStateNormal];
    racingButton.titleLabel.textColor = [UIColor whiteColor];
    racingButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [racingButton setBackgroundImage:[UIImage imageNamed:@"btn_answer_bg_selected"] forState:UIControlStateHighlighted];
    [racingButton setBackgroundImage:[UIImage imageNamed:@"btn_answer_bg_selected"] forState:UIControlStateSelected];
    [racingButton addTarget:self action:@selector(racingQuestion:) forControlEvents:UIControlEventTouchDown];
    racingButton.frame = CGRectMake(65, 4.5, 190, 36);
    [bottomView addSubview:racingButton];
    
    return bottomView;
}

- (UIView *)setupClosedBottomView:(CGRect)inputFrame
{
    inputFrame.origin.y -= 64;
    UIView *bottomView = [[UIView alloc] initWithFrame:inputFrame];
    [bottomView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_bottom_answer.png"]]];
    
    UILabel *closeLabel = [[UILabel alloc] init];
    [closeLabel setText:@"该问题已关闭"];
    closeLabel.font = [UIFont systemFontOfSize:16.0f];
    closeLabel.textColor = RGBHex(qwColor6);
    closeLabel.frame = CGRectMake(65, 4.5, 190, 36);
    closeLabel.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:closeLabel];
    return bottomView;
}

- (void)racingQuestion:(id)sender
{
    ConsultReplyFirstgModelR *consultReplyFirstModelR = [ConsultReplyFirstgModelR new];
    consultReplyFirstModelR.token = QWGLOBALMANAGER.configure.userToken;
    consultReplyFirstModelR.consultId = self.messageSender;
    [Consult consultReplyFirstWithParams:consultReplyFirstModelR success:^(BaseAPIModel *model) {
        if([model.apiStatus integerValue] == 0)
        {
            self.mustAnswer = YES;
            [UIView animateWithDuration:0.5 animations:^{
                self.showType = MessageShowTypeAnswer;
                [self layoutDifferentMessageType];
                [QWGLOBALMANAGER postNotif:NotifPollNewMessageStatus data:nil object:nil];
            }];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:model.apiMessage duration:0.8f];
        }
    } failure:NULL];
}

- (void)unLoadKeyboardBlock
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardDidHideNotification object:nil];
    self.messageTableView.keyboardDidScrollToPoint = NULL;
    self.messageTableView.keyboardWillSnapBackToPoint = NULL;
    self.messageTableView.keyboardWillBeDismissed = NULL;
    self.messageTableView.keyboardWillChange = NULL;
    self.messageTableView.keyboardDidChange = NULL;
    self.messageTableView.keyboardDidHide = NULL;
}

- (void)initKeyboardBlock
{
    WEAKSELF
    if (self.allowsPanToDismissKeyboard) {
        // 控制输入工具条的位置块
        void (^AnimationForMessageInputViewAtPoint)(CGPoint point) = ^(CGPoint point) {
            CGRect inputViewFrame = weakSelf.messageInputView.frame;
            CGPoint keyboardOrigin = [weakSelf.view convertPoint:point fromView:nil];
            inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
            weakSelf.messageInputView.frame = inputViewFrame;
        };
        
        self.messageTableView.keyboardDidScrollToPoint = ^(CGPoint point) {
            if (weakSelf.textViewInputViewType == XHInputViewTypeText)
                AnimationForMessageInputViewAtPoint(point);
        };
        
        self.messageTableView.keyboardWillSnapBackToPoint = ^(CGPoint point) {
            if (weakSelf.textViewInputViewType == XHInputViewTypeText)
                AnimationForMessageInputViewAtPoint(point);
        };
        
        self.messageTableView.keyboardWillBeDismissed = ^() {
            CGRect inputViewFrame = weakSelf.messageInputView.frame;
            inputViewFrame.origin.y = weakSelf.view.bounds.size.height - inputViewFrame.size.height;
            weakSelf.messageInputView.frame = inputViewFrame;
        };
    }
    
    // block回调键盘通知
    self.messageTableView.keyboardWillChange = ^(CGRect keyboardRect, UIViewAnimationOptions options, double duration, BOOL showKeyborad) {
        if(self.shouldPreventAutoScrolling)
            return;
        if (weakSelf.textViewInputViewType == XHInputViewTypeText) {
            [UIView animateWithDuration:duration
                                  delay:0.0
                                options:options
                             animations:^{
                                 CGFloat keyboardY = [weakSelf.view convertRect:keyboardRect fromView:nil].origin.y;
                                 
                                 CGRect inputViewFrame = weakSelf.messageInputView.frame;
                                 CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                                 
                                 // for ipad modal form presentations
                                 CGFloat messageViewFrameBottom = weakSelf.view.frame.size.height - inputViewFrame.size.height;
                                 if (inputViewFrameY > messageViewFrameBottom)
                                     inputViewFrameY = messageViewFrameBottom;
                                 
                                 weakSelf.messageInputView.frame = CGRectMake(inputViewFrame.origin.x,
                                                                              inputViewFrameY,
                                                                              inputViewFrame.size.width,
                                                                              inputViewFrame.size.height);
                                 
                                 [weakSelf setTableViewInsetsWithBottomValue:weakSelf.view.frame.size.height
                                  - weakSelf.messageInputView.frame.origin.y - 45];
                                 if (showKeyborad)
                                     [weakSelf scrollToBottomAnimated:NO];
                             }
                             completion:nil];
        }
    };
    self.messageTableView.keyboardDidChange = ^(BOOL didShowed) {
        if ([weakSelf.messageInputView.inputTextView isFirstResponder]) {
            if (didShowed) {
                if (weakSelf.textViewInputViewType == XHInputViewTypeText) {
                    weakSelf.shareMenuView.alpha = 0.0;
                    weakSelf.emotionManagerView.alpha = 0.0;
                }
            }
        }
    };
    self.messageTableView.keyboardDidHide = ^() {
        [weakSelf.messageInputView.inputTextView resignFirstResponder];
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 设置键盘通知或者手势控制键盘消失
    [self.messageTableView setupPanGestureControlKeyboardHide:self.allowsPanToDismissKeyboard];
    
    // KVO 检查contentSize
    [self.messageInputView.inputTextView addObserver:self
                                     forKeyPath:@"contentSize"
                                        options:NSKeyValueObservingOptionNew
                                        context:nil];
    [self initKeyboardBlock];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unLoadKeyboardBlock];
    // 取消输入框
    [self.messageInputView.inputTextView resignFirstResponder];
    [self setEditing:NO animated:YES];
    
    // remove键盘通知或者手势
    [self.messageTableView disSetupPanGestureControlKeyboardHide:self.allowsPanToDismissKeyboard];

    // remove KVO
    [self.messageInputView.inputTextView removeObserver:self forKeyPath:@"contentSize"];
    [self.marketList removeAllObjects];
    
    if(self.showType == MessageShowTypeClose){
        [QWCLICKEVENT qwTrackPageEnd:@"XHDemoWeChatMessageTableViewController-ygb"];
    }else if (self.showType == MessageShowTypeAsking) {
        [QWCLICKEVENT qwTrackPageEnd:@"XHDemoWeChatMessageTableViewController-dqd"];
    }else if (self.showType == MessageShowTypeAnswer) {
        [QWCLICKEVENT qwTrackPageEnd:@"XHDemoWeChatMessageTableViewController-jdz"];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.CommonWords = [NSMutableArray arrayWithCapacity:15];
    self.marketList = [NSMutableArray arrayWithCapacity:10];
    
    self.popupMarketActivityView = [[[NSBundle mainBundle] loadNibNamed:@"PopupMarketActivityView" owner:self options:nil] objectAtIndex:0];
    CGRect rect = self.popupMarketActivityView.frame;
    self.popupMarketActivityView.frame = rect;
    self.popupMarketActivityView.delegate = self;
    // Do any additional setup after loading the view.
    // 初始化消息页面布局
    [self initilzer];
    self.previousTextViewContentHeight = 36;
    [[XHMessageBubbleView appearance] setFont:[UIFont systemFontOfSize:16.0f]];
    self.photoDic = [NSMutableDictionary dictionary];
    self.photoDicRs = [NSMutableDictionary dictionary];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    _messages = nil;
    //_delegate = nil;
    _dataSource = nil;
    _messageTableView.delegate = nil;
    _messageTableView.dataSource = nil;
    _messageTableView = nil;
    _messageInputView = nil;
    
    _photographyHelper = nil;
}

#pragma mark - RecorderPath Helper Method

- (NSString *)getRecorderPath {
    NSString *recorderPath = nil;
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yy-MMMM-dd";
    recorderPath = [[NSString alloc] initWithFormat:@"%@/Documents/", NSHomeDirectory()];
    dateFormatter.dateFormat = @"yyyy-MM-dd-hh-mm-ss";
    recorderPath = [recorderPath stringByAppendingFormat:@"%@-MySound.caf", [dateFormatter stringFromDate:now]];
    return recorderPath;
}

#pragma mark - UITextView Helper Method

- (CGFloat)getTextViewContentH:(UITextView *)textView {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

#pragma mark - Layout Message Input View Helper Method

- (void)layoutAndAnimateMessageInputTextView:(UITextView *)textView {
    CGFloat maxHeight = [XHMessageInputView maxHeight];
    
    CGFloat contentH = [self getTextViewContentH:textView];
    BOOL isShrinking = contentH < self.previousTextViewContentHeight;
    CGFloat changeInHeight = contentH - _previousTextViewContentHeight;
    
    if (!isShrinking && (self.previousTextViewContentHeight == maxHeight || textView.text.length == 0)) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }
    
    if (changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             [self setTableViewInsetsWithBottomValue:self.messageTableView.contentInset.bottom + changeInHeight];
                             
                             [self scrollToBottomAnimated:NO];
                             
                             if (isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     self.previousTextViewContentHeight = MIN(contentH, maxHeight);
                                 }
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [self.messageInputView adjustTextViewHeightBy:changeInHeight];
                             }
                             
                             CGRect inputViewFrame = self.messageInputView.frame;
                             self.messageInputView.frame = CGRectMake(0.0f,
                                                                      inputViewFrame.origin.y - changeInHeight,
                                                                      inputViewFrame.size.width,
                                                                      inputViewFrame.size.height + changeInHeight);
                             if (!isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     self.previousTextViewContentHeight = MIN(contentH, maxHeight);
                                 }
                                 // growing the view, animate the text view frame AFTER input view frame
                                 [self.messageInputView adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                         }];
        
        self.previousTextViewContentHeight = MIN(contentH, maxHeight);
    }
    
    // Once we reached the max height, we have to consider the bottom offset for the text view.
    // To make visible the last line, again we have to set the content offset.
    if (self.previousTextViewContentHeight == maxHeight) {
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime,
                       dispatch_get_main_queue(),
                       ^(void) {
                           CGPoint bottomOffset = CGPointMake(0.0f, contentH - textView.bounds.size.height);
                           [textView setContentOffset:bottomOffset animated:YES];
                       });
    }
}

#pragma mark - Scroll Message TableView Helper Method

- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom
{
    UIEdgeInsets insets = [self tableViewInsetsWithBottomValue:bottom];
    self.messageTableView.contentInset = insets;
    self.messageTableView.scrollIndicatorInsets = insets;
    self.messageTableView.header.scrollViewOriginalInset = insets;
    self.messageTableView.footer.scrollViewOriginalInset = insets;
}

- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    
//    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
//        insets.top = 64;
//    }
    
    insets.bottom = bottom;
    
    return insets;
}

#pragma mark - Message Calculate Cell Height

- (CGFloat)calculateCellHeightWithMessage:(id <XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = 0;
    
    BOOL displayTimestamp = YES;
    if ([self.delegate respondsToSelector:@selector(shouldDisplayTimestampForRowAtIndexPath:)]) {
        displayTimestamp = [self.delegate shouldDisplayTimestampForRowAtIndexPath:indexPath];
    }
    
    cellHeight = [XHMessageTableViewCell calculateCellHeightWithMessage:message displaysTimestamp:displayTimestamp];
    return cellHeight;
}

#pragma mark - Message Send helper Method

- (void)didSendMessageWithText:(NSString *)text
{
    DLog(@"send text : %@", text);
    if ([self.delegate respondsToSelector:@selector(didSendText:fromSender:onDate:)]) {
        [self.delegate didSendText:text fromSender:self.messageSender onDate:[NSDate date]];
    }
}

- (void)didSendEvaluateWith:(NSString *)text
{
    if ([self.delegate respondsToSelector:@selector(didSendEvaluateText:fromSender:onDate:)]) {
        [self.delegate didSendEvaluateText:text fromSender:self.messageSender onDate:[NSDate date]];
    }
}

- (void)didSendActivityWithTitle:(NSString *)title
                        imageUrl:(NSString *)imageUrl
                         content:(NSString *)content
                         comment:(NSString *)comment
                        richBody:(NSString *)richbody
{
    if([self.delegate respondsToSelector:@selector(didSendActivityTitle:imageUrl:content:comment:richBody:fromSender:onDate:)]){
        if(imageUrl == nil)
            imageUrl = @"";
        [self.delegate didSendActivityTitle:title imageUrl:imageUrl content:content comment:comment richBody:richbody fromSender:self.messageSender onDate:[NSDate date]];
    }
}

- (void)didSendPTMActivity:(NSString *)title
                  imageUrl:(NSString *)imageUrl
                   content:(NSString *)content
                   comment:(NSString *)comment
                  richBody:(NSString *)richbody
{
    if([self.delegate respondsToSelector:@selector(didSendPTMActivity:content:comment:activityUrl:activityId:fromSender:onDate:)]){
        if(imageUrl == nil)
            imageUrl = @"";
        [self.delegate didSendPTMActivity:title content:content comment:comment activityUrl:imageUrl activityId:richbody fromSender:self.messageSender onDate:[NSDate date]];
    }
}

- (void)didSendMessageWithPhoto:(UIImage *)photo {
    if ([self.delegate respondsToSelector:@selector(didSendPhoto:fromSender:onDate:image:uuid:)]) {
        [self.delegate didSendPhoto:photo fromSender:self.messageSender onDate:[NSDate date] image:nil uuid:@""];
    }
}

//选中表情集,添加占位符到文本框中
- (void)didSendEmotionMessageWithEmotionPath:(XHEmotion *)emotionPath
{
    DLog(@"send emotionPath : %@", emotionPath);
    NSString *text = self.messageInputView.inputTextView.text;
    if([emotionPath.emotionPath isEqualToString:@"删除"])
    {
        NSString *scanString = [NSString stringWithString:text];
        NSUInteger count = 0;
        while (scanString.length > 0)
        {
            NSString *lastString = [scanString substringWithRange:NSMakeRange(scanString.length - 1, 1)];
            if([lastString isEqualToString:@"["] && scanString.length >= 1)
            {
                text = [scanString substringToIndex:scanString.length - 1];
                self.messageInputView.inputTextView.text = text;
                return;
            }
            count++;
            if(count >= 4)
                break;
            scanString = [scanString substringToIndex:scanString.length - 1];
        }
        if(text.length > 0){
            text = [text substringToIndex:text.length - 1];
            self.messageInputView.inputTextView.text = text;
        }
        return;
    }
    
    text = [text stringByAppendingString:emotionPath.emotionPath];
    self.messageInputView.inputTextView.text = text;
}

#pragma mark - Other Menu View Frame Helper Mehtod
- (void)layoutOtherMenuViewHide:(BOOL)hide fromInputView:(BOOL)from
{
    [self.messageInputView.inputTextView resignFirstResponder];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        __block CGRect inputViewFrame = self.messageInputView.frame;
        __block CGRect otherMenuViewFrame;
        
        void (^InputViewAnimation)(BOOL hide) = ^(BOOL hide) {
            inputViewFrame.origin.y = (hide ? (CGRectGetHeight(self.view.bounds) - CGRectGetHeight(inputViewFrame)) : (CGRectGetMinY(otherMenuViewFrame) - CGRectGetHeight(inputViewFrame)));
            self.messageInputView.frame = inputViewFrame;
        };
        
        void (^EmotionManagerViewAnimation)(BOOL hide) = ^(BOOL hide) {
            otherMenuViewFrame = self.emotionManagerView.frame;
            otherMenuViewFrame.origin.y = (hide ? CGRectGetHeight(self.view.frame) : (CGRectGetHeight(self.view.frame) - CGRectGetHeight(otherMenuViewFrame)));
            self.emotionManagerView.alpha = !hide;
            self.emotionManagerView.frame = otherMenuViewFrame;
        };
        
        void (^ShareMenuViewAnimation)(BOOL hide) = ^(BOOL hide) {
            otherMenuViewFrame = self.shareMenuView.frame;
            otherMenuViewFrame.origin.y = (hide ? CGRectGetHeight(self.view.frame) : (CGRectGetHeight(self.view.frame) - CGRectGetHeight(otherMenuViewFrame)));
            if(self.shareMenuView.alpha == 1.0f && from) {
                otherMenuViewFrame.origin.y -= 36;
                [self.messageInputView.inputTextView becomeFirstResponder];
                InputViewAnimation(NO);
            }else{
                InputViewAnimation(hide);
            }
            self.shareMenuView.alpha = !hide;
            self.shareMenuView.frame = otherMenuViewFrame;
            
        };
        
        if (hide) {
            switch (self.textViewInputViewType) {
                case XHInputViewTypeEmotion: {
                    EmotionManagerViewAnimation(hide);
                    break;
                }
                case XHInputViewTypeShareMenu: {
                    ShareMenuViewAnimation(hide);
                    break;
                }
                default:
                    break;
            }
            InputViewAnimation(hide);
        } else {
            
            // 这里需要注意block的执行顺序，因为otherMenuViewFrame是公用的对象，所以对于被隐藏的Menu的frame的origin的y会是最大值
            switch (self.textViewInputViewType) {
                case XHInputViewTypeEmotion: {
                    // 1、先隐藏和自己无关的View
                    ShareMenuViewAnimation(!hide);
                    // 2、再显示和自己相关的View
                    EmotionManagerViewAnimation(hide);
                    InputViewAnimation(hide);
                    break;
                }
                case XHInputViewTypeShareMenu: {
                    // 1、先隐藏和自己无关的View
                    EmotionManagerViewAnimation(!hide);
                    // 2、再显示和自己相关的View
                    ShareMenuViewAnimation(hide);
                    break;
                }
                default:
                    break;
            }
        }
        [self setTableViewInsetsWithBottomValue:self.view.frame.size.height
         - self.messageInputView.frame.origin.y - 45];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)layoutOtherMenuViewHiden:(BOOL)hide {
    [self layoutOtherMenuViewHide:hide fromInputView:YES];
    [self scrollToBottomAnimated:YES];
}

#pragma mark - XHMessageInputView Delegate
- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView
{
    self.textViewInputViewType = XHInputViewTypeText;
}

- (void)inputTextViewDidBeginEditing:(XHMessageTextView *)messageInputTextView
{
    if (!self.previousTextViewContentHeight)
		self.previousTextViewContentHeight = [self getTextViewContentH:messageInputTextView];
}

- (void)didChangeSendVoiceAction:(BOOL)changed
{
    if (changed) {
        if (self.textViewInputViewType == XHInputViewTypeText)
            return;
        // 在这之前，textViewInputViewType已经不是XHTextViewTextInputType
        [self layoutOtherMenuViewHiden:YES];
    }
}

- (void)didSendTextMessage:(id)sender
{
    if(self.messageInputView.inputTextView.text.length == 0)
        return;
    if ([self.delegate respondsToSelector:@selector(didSendText:fromSender:onDate:)]) {
        [self.delegate didSendText:self.messageInputView.inputTextView.text fromSender:self.messageSender onDate:[NSDate date]];
    }
}

- (void)didSendLocation:(NSString *)address
               latitude:(NSString *)latitude
              longitude:(NSString *)longitude
{
    if ([self.delegate respondsToSelector:@selector(didSendLocation:latitude:longitude:fromSender:onDate:)]) {
        [self.delegate didSendLocation:address latitude:latitude longitude:longitude fromSender:self.messageSender onDate:[NSDate date]];
    }
}

- (void)didSendTextAction:(NSString *)text {
    DLog(@"text : %@", text);
    if ([self.delegate respondsToSelector:@selector(didSendText:fromSender:onDate:)]) {
        [self.delegate didSendText:text fromSender:self.messageSender onDate:[NSDate date]];
    }
}

- (void)didSelectedMultipleMediaAction
{
    self.textViewInputViewType = XHInputViewTypeShareMenu;
    if(self.shareMenuView.alpha == 1.0) {
        [self.messageInputView.inputTextView becomeFirstResponder];
    }else{
        [self layoutOtherMenuViewHiden:NO];
    }
}

- (void)didSendFaceAction:(BOOL)sendFace {
    if (sendFace) {
        self.textViewInputViewType = XHInputViewTypeEmotion;
        [self layoutOtherMenuViewHide:NO fromInputView:NO];
        [self scrollToBottomAnimated:YES];
    } else {
        [self.messageInputView.inputTextView becomeFirstResponder];
    }
}

#pragma mark - XHShareMenuView Delegate

- (void)didSelecteShareMenuItem:(XHShareMenuItem *)shareMenuItem atIndex:(NSInteger)index
{
    [self layoutOtherMenuViewHide:YES fromInputView:NO];
    WEAKSELF

    switch (index) {
        case 0:
        {
            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
            if(author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) {
                [SVProgressHUD showErrorWithStatus:@"当前程序未开启相册使用权限" duration:0.8];
                return;
            }
            [self LocalPhoto];
            break;
        }
        case 1:
        {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
                [SVProgressHUD showErrorWithStatus:@"当前程序未开启相机使用权限" duration:0.8];
                return;
            }
            [self takePhoto];
            break;
        }
        case 2:
        {
            if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
                [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试" duration:0.8f];
                return;
            }
            //发送机构地址
            
            BranchGroupModelR *getBranchGroupModelR = [BranchGroupModelR new];
            getBranchGroupModelR.branchId = QWGLOBALMANAGER.configure.groupId;
            [Store GetBranchGroupWithParams:getBranchGroupModelR success:^(id DFModel) {
                BranchGroupModel *groupDetail = (BranchGroupModel *)DFModel;
                NSString *groupAddress = groupDetail.address;
                NSString *latitude = groupDetail.latitude;
                NSString *longitude = groupDetail.longitude;
                if(groupDetail.cityName) {
                    groupAddress = [NSString stringWithFormat:@"%@%@%@",groupDetail.cityName,groupDetail.countryName,groupAddress];
                }
                [weakSelf didSendLocation:groupAddress latitude:latitude longitude:longitude fromSender:self.messageSender onDate:[NSDate date]];
                
            } failure:NULL];
            break;
        }
        case 3: {
            if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
                [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试" duration:0.8f];
                return;
            }
            //营销活动
//            [self showMarketList];
            //本店活动 友盟的链接被注释了，看着怎么放开--cj
            
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"营销活动",@"优惠活动", nil];
            sheet.tag = 1009;
            [sheet showInView:self.view];
            
            break;
        }
        case 4:
        {
            if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
                [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试" duration:0.8f];
                return;
            }
            //常用话术
            if(self.CommonWords.count == 0) {
                [IMApi qReplyIMWithParams:[NSMutableDictionary dictionary] success:^(id array) {
                    [self.CommonWords removeAllObjects];
                    for(IMApiModel *iMApiModel in array) {
                        [self.CommonWords addObject:iMApiModel.content];
                    }
                    [self showRegularTalk];
                } failure:NULL];
            }else{
                [self showRegularTalk];
            }
            break;
        }
        case 5: {
            //医药助手

            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"药事知识库",@"健康问答库",@"快捷发送(药品)", nil];
            sheet.tag = 1002;
            [sheet showInView:self.view];
            break;
        }
        default:
            break;
    }
    [self layoutOtherMenuViewHiden:YES];
}

#pragma mark -
#pragma mark 知识库的Action回调
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 1002)
    {
        if(buttonIndex == 0) {
            //药事知识库
            SearchSliderViewController *sliderViewController = [[SearchSliderViewController alloc] init];
            //sliderViewController.keyBoardShow = YES;
            [self.navigationController pushViewController:sliderViewController animated:NO];
            
        }else if(buttonIndex == 1){
            //健康问答库
            UIStoryboard *sbHealthQA = [UIStoryboard storyboardWithName:@"HealthQALibrary" bundle:nil];
            HealthQASearchViewController *sliderViewController = [sbHealthQA instantiateViewControllerWithIdentifier:@"HealthQASearchViewController"];
            sliderViewController.delegatePopVC = self;
            [self.navigationController pushViewController:sliderViewController animated:NO];
        }else if (buttonIndex == 2) {
            //药品快捷发送
            QuickSearchDrugViewController *quickSearchDrugViewController = [QuickSearchDrugViewController new];
            quickSearchDrugViewController.returnValueBlock = ^(productclassBykwId *model){
//                [self didSendMedicineName:model.proName imageUrl:PORID_IMAGE(model.proId) productId:model.proId];
            [self didSendMedicineName:model.proName imageUrl:model.imgUrl productId:model.proId];
            };
            [self.navigationController pushViewController:quickSearchDrugViewController animated:NO];
        }
    }else if(actionSheet.tag==1009){
        if(buttonIndex == 0) {
            //营销活动
             MarketingActivityViewController *marketViewController = [[MarketingActivityViewController alloc] init];
            marketViewController.SendActivity = ^(QueryActivityInfo *model) {
                NSDictionary *mode=[model dictionaryModel];
                NSMutableDictionary *dic2 =[NSMutableDictionary dictionaryWithDictionary:mode];
                [self showPopMarkActivityDetail:dic2];
            };
            [self.navigationController pushViewController:marketViewController animated:NO];
        }else if(buttonIndex == 1){
            //优惠活动
            CoupnViewController *coupnViewController = [CoupnViewController new];
            coupnViewController.SendBranchCoupn = ^(BranchPromotionModel *model) {
                NSDictionary *mode=[model dictionaryModel];
                NSMutableDictionary *dic2 =[NSMutableDictionary dictionaryWithDictionary:mode];
            [self showCoupnActivityDetail:dic2];
            };
            [self.navigationController pushViewController:coupnViewController animated:NO];
        }
    
    }
}



- (void)showRegularTalk
{
    LeveyPopListView *popListView = [[LeveyPopListView alloc] initWithTitle:@"" options:self.CommonWords];
    popListView.delegate = self;
    popListView.tag = 1002;
    [popListView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.6]];
    [popListView showInView:self.view animated:YES];
}

- (void)showMarketList
{
    [self queryBranchActivity];
}

//特殊字符的替换
- (NSString *)replaceSpecialStringWith:(NSString *)string{
    string = [string stringByReplacingOccurrencesOfString:@"    &nbsp;&nbsp;&nbsp;&nbsp;" withString:@"    "];
    string = [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\r\n"];
    string = [string stringByReplacingOccurrencesOfString:@"<br>" withString:@"\r\n"];
    string = [string stringByReplacingOccurrencesOfString:@"<p/>" withString:@"\r\n"];
    return string;
}

- (void)showPopMarkActivityDetail:(NSMutableDictionary *)dict
{
    if(dict[@"imgUrl"]&&![dict[@"imgUrl"] isEqualToString:@""]){
      [self.popupMarketActivityView setContent:[self replaceSpecialStringWith: dict[@"content"]] avatarUrl:dict[@"imgUrl"]];
    }else{
      [self.popupMarketActivityView setContent:[self replaceSpecialStringWith: dict[@"content"]] avatarUrl:nil];
    }
  
    self.popupMarketActivityView.infoDict = dict;
    self.popupMarketActivityView.enum_type=Enum_Items_Activity;
    [self.popupMarketActivityView showInView:self.view animated:YES];
    [self.view addSubview:self.popupMarketActivityView];
}

- (void)showCoupnActivityDetail:(NSMutableDictionary *)dict
{
    [self.popupMarketActivityView setContent:[self replaceSpecialStringWith: dict[@"desc"]] avatarUrl:dict[@"imgUrl"]];
    self.popupMarketActivityView.infoDict = dict;
    self.popupMarketActivityView.enum_type=Enum_Items_Coupn;
    [self.popupMarketActivityView showInView:self.view animated:YES];
    [self.view addSubview:self.popupMarketActivityView];
}

- (void)didSendMedicineName:(NSString *)drugName imageUrl:(NSString *)imageUrl productId:(NSString *)productId
{
    if ([self.delegate respondsToSelector:@selector(didSendMedicine:productId:imageUrl:fromSender:onDate:)]) {
        if([NSThread isMainThread])
        {
            NSLog(@"is main thread");
        }
       dispatch_async(dispatch_get_main_queue(), ^{
                 [self.delegate didSendMedicine:drugName productId:productId imageUrl:imageUrl fromSender:self.messageSender onDate:[NSDate date]];
      });
    }
}

- (void)didSendMarketActivityWithDict:(NSDictionary *)dict
{
    //营销活动分开。没有type的区分
    if(self.popupMarketActivityView.enum_type==Enum_Items_Coupn){
        [self didSendPTMActivity:dict[@"title"] imageUrl:dict[@"imgUrl"] content:dict[@"desc"] comment:dict[@"replyText"] richBody:dict[@"id"]];
    }else if(self.popupMarketActivityView.enum_type==Enum_Items_Activity){
        [self didSendActivityWithTitle:dict[@"title"] imageUrl:dict[@"imgUrl"] content:dict[@"content"] comment:dict[@"replyText"] richBody:dict[@"activityId"]];
    }
}

- (void)queryBranchActivity
{
    if(self.marketList.count == 0)
    {
        QueryActivityCoupnR *queryActivitysR = [QueryActivityCoupnR new];
        queryActivitysR.token = QWGLOBALMANAGER.configure.userToken;
        queryActivitysR.currPage = @"1";
        queryActivitysR.pageSize = @"100";
        
        [Activity QueryActivityCoupnListWithParams:queryActivitysR success:^(id queryActivitys) {
            [self.marketList removeAllObjects];
            NSArray *array = ((QueryActivityList *)queryActivitys).list;
            for(QueryActivityInfo *queryActivity in array) {
                [self.marketList addObject:[queryActivity dictionaryModel]];
            }
            if(self.marketList.count == 0) {
                [SVProgressHUD showErrorWithStatus:@"您还没有营销活动哦,添加后再发给客户吧~" duration:0.8f];
                return;
            }else if (self.marketList.count == 1) {
                [self showPopMarkActivityDetail:self.marketList[0]];
            }else{
                LeveyPopListView *popListView = [[LeveyPopListView alloc] initWithTitle:@"" options:self.marketList];
                popListView.delegate = self;
                popListView.tag = 1001;
                [popListView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.6]];
                [popListView showInView:self.view animated:YES];
            }            
        } failure:NULL];
    }else if (self.marketList.count == 1) {
        [self showPopMarkActivityDetail:self.marketList[0]];
    }else{
        LeveyPopListView *popListView = [[LeveyPopListView alloc] initWithTitle:@"" options:self.marketList];
        popListView.delegate = self;
        popListView.tag = 1001;
        [popListView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.6]];
        [popListView showInView:self.view animated:YES];
    }
}

- (void)leveyPopListView:(LeveyPopListView *)popListView didSelectedIndex:(NSInteger)anIndex
{
    if(popListView.tag == 1001) {
        NSDictionary *dict = self.marketList[anIndex];
        [self showPopMarkActivityDetail:[NSMutableDictionary dictionaryWithDictionary:dict]];
    }else if (popListView.tag == 1002) {
        NSString *content = self.CommonWords[anIndex];
        self.messageInputView.inputTextView.text = content;
        [self.messageInputView.inputTextView becomeFirstResponder];
    }
}

#pragma mark - XHEmotionManagerView Delegate

- (void)didSelecteEmotion:(XHEmotion *)emotion atIndexPath:(NSIndexPath *)indexPath {
    if (emotion.emotionPath) {
        [self didSendEmotionMessageWithEmotionPath:emotion];
    }
}

#pragma mark - XHEmotionManagerView DataSource

- (NSInteger)numberOfEmotionManagers {
    return 0;
}

- (XHEmotionManager *)emotionManagerForColumn:(NSInteger)column {
    return nil;
}

- (NSArray *)emotionManagersAtManager {
    return nil;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	self.isUserScrolling = YES;
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    }
    
    if (self.textViewInputViewType != XHInputViewTypeNormal && self.textViewInputViewType != XHInputViewTypeText) {
        [self layoutOtherMenuViewHiden:YES];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.isUserScrolling = NO;
}

#pragma mark - XHMessageTableViewController Delegate

- (BOOL)shouldPreventScrollToBottomWhileUserScrolling {
    return YES;
}

#pragma mark - XHMessageTableViewController DataSource

- (id <XHMessageModel>)messageForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.messages[indexPath.row];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id <XHMessageModel> message = [self.dataSource messageForRowAtIndexPath:indexPath];
    
    BOOL displayTimestamp = YES;
    if ([self.delegate respondsToSelector:@selector(shouldDisplayTimestampForRowAtIndexPath:)]) {
        displayTimestamp = [self.delegate shouldDisplayTimestampForRowAtIndexPath:indexPath];
    }
    static NSString *cellIdentifier = @"XHMessageTableViewCell";
    
    XHMessageTableViewCell *messageTableViewCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!messageTableViewCell) {
        messageTableViewCell = [[XHMessageTableViewCell alloc] initWithMessage:message displaysTimestamp:displayTimestamp reuseIdentifier:cellIdentifier];
        messageTableViewCell.delegate = self;
    }
    
    messageTableViewCell.indexPath = indexPath;
    [messageTableViewCell configureCellWithMessage:message displaysTimestamp:displayTimestamp];
    [messageTableViewCell setSended:message.sended];
    [messageTableViewCell setBackgroundColor:tableView.backgroundColor];
    
    if ([self.delegate respondsToSelector:@selector(configureCell:atIndexPath:)]) {
        [self.delegate configureCell:messageTableViewCell atIndexPath:indexPath];
    }
    
    return messageTableViewCell;
}


#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id <XHMessageModel> message = [self.dataSource messageForRowAtIndexPath:indexPath];
    return [self calculateCellHeightWithMessage:message atIndexPath:indexPath];
}

#pragma mark - Key-value Observing

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (object == self.messageInputView.inputTextView && [keyPath isEqualToString:@"contentSize"]) {
        [self layoutAndAnimateMessageInputTextView:object];
    }
}
#pragma mark - send Photo
-(void)takePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        [self performSelector:@selector(showcamera) withObject:nil afterDelay:0.3];
        //        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}
-(void)showcamera
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        //            self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        //              picker.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }
    //         picker.mediaTypes=@[(NSString *)kUTTypeImage];
    //         picker.allowsEditing=YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //    double delayInSeconds = 0.1;
    //    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    //    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    //            [self presentViewController:picker animated:YES completion:nil];
    [self presentViewController:picker animated:YES completion:^{
        
    }];
    //    });
}
-(void)LocalPhoto
{
    
//    DFMultiPhotoSelectorViewController *vc = [[DFMultiPhotoSelectorViewController alloc]init];
//    vc.delegate = self;
//    [self.navigationController pushViewController:vc animated: NO];

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PhotoAlbum" bundle:nil];
    PhotoAlbum* vc = [sb instantiateViewControllerWithIdentifier:@"PhotoAlbum"];
    [vc selectPhotos:4 selected:nil block:^(NSMutableArray *list) {
        for (PhotoModel *mode in list) {
            if (mode.fullImage) {
                [self didChoosePhoto:mode.fullImage];
            }
            
            
        }    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [vc closeAction:nil];
    }];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:^{
    }];
    
}

- (void)multiPhotoSelectorDidCanceled:(DFMultiPhotoSelectorViewController *)selector
{
    
}
- (void)multiPhotoSelector:(DFMultiPhotoSelectorViewController *)selector didSelectedPhotos:(NSArray *)photos
{
    
}
-(void)didChoosePhoto:(UIImage *)img
{
//    WEAKSELF
    NSString *str =[XMPPStream generateUUID];
    
    willsendimg = img;
    [[SDImageCache sharedImageCache] storeImage:img forKey:str];
    
    
    [self performSelectorOnMainThread:@selector(doSendPhoto:) withObject:str  waitUntilDone:NO];
    
    
}

#pragma mark UIImagePickerControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType ==     UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    image = [image imageByScalingToMinSize];
    image = [UIImage scaleAndRotateImage:image];

    [self didChoosePhoto:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
-(void)doSendPhoto:(NSString*)str
{
    WEAKSELF
    UIImage *imagedata =  [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:str] ;
     [ weakSelf didSendPhoto:imagedata fromSender:self.messageSender onDate:[NSDate date] image:@"" uuid:str];
}

-(void)resendPhotoWihtUuid:(NSString *)red
{

    
}

-(void)progressUpdate:(NSString *)uuid progress:(float)newProgress
{

    dispatch_async(dispatch_get_main_queue(), ^{
        XHMessage *message = [self getMessageWithUUID:uuid];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.messages indexOfObject:message] inSection:0];
        XHMessageTableViewCell *cell = (XHMessageTableViewCell *)[self.messageTableView cellForRowAtIndexPath:indexPath];
        if (cell) {
            cell.messageBubbleView.dpMeterView.hidden = NO;
            cell.messageBubbleView.resendButton.hidden = YES;
            [cell.messageBubbleView.dpMeterView setProgress:newProgress];
        }

    });
    
}
- (void)addPhotoMessage:(XHMessage *)addedMessage {
    WEAKSELF
    [weakSelf exMainQueue:^{
        if (![self.messages containsObject:addedMessage]) {
            [self.messages addObject:addedMessage];
            
            NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:1];
            [indexPaths addObject:[NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0]];
            [self.messageTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [self scrollToBottomAnimated:NO];
        }
        UIImage *imagedata =  [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:addedMessage.UUID] ;
        NSData * imageData = UIImageJPEGRepresentation(imagedata, 1.0f);
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.messages indexOfObject:addedMessage] inSection:0];
        XHMessageTableViewCell *cell = (XHMessageTableViewCell *)[self.messageTableView cellForRowAtIndexPath:indexPath];
        
        [self progressUpdate:addedMessage.UUID progress:0];
        
        [self sendToSe:addedMessage.UUID imagData:imageData success:^(id responseObj) {
            cell.messageBubbleView.dpMeterView.activeShow.hidden = YES;
            cell.messageBubbleView.dpMeterView.hidden = YES;
            [self requestDidSuccessed:addedMessage.UUID obj:responseObj];
        } failure:^(HttpException *e) {
            cell.messageBubbleView.dpMeterView.activeShow.hidden = YES;
            cell.messageBubbleView.dpMeterView.hidden = YES;
            [self requestDidFaileded:addedMessage.UUID obj:e];
        } uploadProgressBlock:^(NSString *str, float progress) {
            [self progressUpdate:str progress:progress];
        }];
    }];
}
- (void)requestDidSuccessed:(NSString *)uuid obj:(id)responseObj
{
    [self.photoDic removeObjectForKey:uuid];
    NSDictionary * dict = responseObj[@"body"];
    WEAKSELF
    SendPTPMap *consultMap = [SendPTPMap getObjFromDBWithKey:self.customerSessionVo.sessionId];
    if(!consultMap) {
        consultMap = [SendPTPMap new];
        consultMap.sessionId = self.customerSessionVo.sessionId;
    }
    consultMap.body = @"[图片]";
    consultMap.sendStatus = [NSString stringWithFormat:@"%d",Sended];
//    [consultMap saveToDB];
         [SendPTPMap updateObjToDB:consultMap WithKey:self.customerSessionVo.sessionId];
//    HistoryMessages * hmsg = [[HistoryMessages alloc] init];
//    
//    hmsg.issend =[NSString stringWithFormat:@"%d", Sended];
//    
//    [HistoryMessages updateObjToDB:hmsg WithKey:self.messageSender];
      QWMessage * msg =  [QWMessage getObjFromDBWithKey:uuid];
    
//    msg.recvname = self.messageSender;
    msg.issend = [NSString stringWithFormat:@"%d",Sending];
    msg.richbody =[dict objectForKey:@"url"];
    
    [QWMessage updateObjToDB:msg WithKey:uuid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"UUID == %@",uuid];
    NSArray *array = [self.messages filteredArrayUsingPredicate:predicate];
    if([array count] > 0) {
        XHMessage *filterMessage =  array[0];
        filterMessage.sended = Sended;
        [weakSelf sendXmppPhototimestamp:filterMessage.timestamp richBody:[dict objectForKey:@"url"] UUID:uuid];
    }
    [self.messageTableView reloadData];
    
    if ([dict[@"result"] isEqualToString:@"FAIL"]) {
        [SVProgressHUD showErrorWithStatus:dict[@"msg"] duration:DURATION_SHORT];
        return;
    }
    
     [GLOBALMANAGER postNotif:NotimessageBoxUpdate data:nil object:nil];
}

- (void)requestDidFaileded:(NSString *)uuid obj:(id)responseObj
{
//    [app.dataBase updateMessageRichBody:@"" With:request.asiFormDataUUID Status:[NSNumber numberWithInt:SendFailure]];
    QWMessage * msg =  [QWMessage getObjFromDBWithKey:uuid];
 
//    msg.recvname = self.messageSender;
    msg.issend = [NSString stringWithFormat:@"%d",SendFailure];
    msg.richbody = @"";
 
    [QWMessage updateObjToDB:msg WithKey:uuid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"UUID == %@",uuid];
    NSArray *array = [self.messages filteredArrayUsingPredicate:predicate];
 
    if([array count] > 0) {
        XHMessage *filterMessage =  array[0];
        filterMessage.sended = SendFailure;
        [self scrollToBottomAnimated:NO];
    }
    [self.messageTableView reloadData];
    
    SendPTPMap *consultMap = [SendPTPMap getObjFromDBWithKey:self.customerSessionVo.sessionId];
    if(!consultMap) {
        consultMap = [SendPTPMap new];
        consultMap.sessionId = self.customerSessionVo.sessionId;
    }
    consultMap.body = @"[图片]";
    consultMap.sendStatus = [NSString stringWithFormat:@"%d",SendFailure];
//    [consultMap saveToDB];
         [SendPTPMap updateObjToDB:consultMap WithKey:self.customerSessionVo.sessionId];
   [[NSNotificationCenter defaultCenter] postNotificationName:UPDATEBOX object:nil];
    [GLOBALMANAGER postNotif:NotimessageBoxUpdate data:nil object:nil];
}
-(void)sendToSe:(NSString *)str imagData:(NSData *)imageData success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure  uploadProgressBlock:(void (^)(NSString* str, float progress ))uploadProgressBlock
{
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"type"] = @(4);
    setting[@"token"] = QWGLOBALMANAGER.configure.userToken;
    if (!imageData ) {
        return;
    }
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:imageData];
    
    HttpClient *httpClent = [HttpClient new];
    //cj----cj
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *apiUrl = [def objectForKey:@"APIDOMAIN"];
    NSString *h5Url = [def objectForKey:@"H5DOMAIN"];
    if(apiUrl&&![apiUrl isEqualToString:@""]){
        [httpClent setBaseUrl:apiUrl];
    }else{
        [httpClent setBaseUrl:BASE_URL_V2];
    }
    httpClent.progressEnabled = NO;
    HttpClientMgr.progressEnabled=NO;
    [httpClent uploaderImg:array params:setting withUrl:NW_uploadFile success:^(id responseObj) {
        //        self.activeShow.hidden = YES;
        //        self.hidden = YES;
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        //        self.activeShow.hidden = YES;
        //        self.hidden = YES;
        if (failure) {
            failure(e);
        }
    } uploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        if (uploadProgressBlock) {
            uploadProgressBlock(str, ( (double)totalBytesWritten/(double)totalBytesExpectedToWrite ));
        }
        
    }];
    
}
@end
