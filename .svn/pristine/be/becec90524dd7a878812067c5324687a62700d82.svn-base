//
//  BaseChatViewController.m
//  wenYao-store
//
//  Created by 李坚 on 16/3/22.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "BaseChatViewController.h"
#import "WebDirectViewController.h"
#import "UIImage+Resize.h"

#define kOffSet        45  //tableView偏移量
#define kInputViewHeight   45  //输入框的高度
#define kEmojiKeyboardHeight 216 //表情键盘的高度
#define kShareMenuHeight    95 //shareMenu键盘的高度
//self.view的高度  因为点击发送药品时，self.view的高度含导航栏，特此区别
#define kViewHeight  [UIScreen mainScreen].bounds.size.height - NAV_H - STATUS_H

@interface BaseChatViewController ()<XHEmotionManagerViewDataSource,XHEmotionManagerViewDelegate,XHMessageInputViewDelegate,XHShareMenuViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    
    MessageModel        *playingMessageModel;//语音临时Model
    
}


@property (nonatomic, assign) CGFloat previousTextViewContentHeight;//记录旧的textView contentSize Heigth

@end

@implementation BaseChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initilzer];
    [self shareMenuView];
    [self setupShareMenuViewImgArr:@[@"photo_image.png",@"take_photo_image.png"] andTitleArr:@[@"相册",@"拍照"]];
    [self setupEmotionManagerView];
    [self setUpEmojiManager];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // KVO 检查contentSize
    [self.messageInputView.inputTextView addObserver:self
                                          forKeyPath:@"contentSize"
                                             options:NSKeyValueObservingOptionNew
                                             context:nil];
    
    if (self.shareMenuView.alpha == 1 || self.emotionManagerView.alpha == 1) {
        //        [self layoutOtherMenuViewHiden:NO];
    }else{
        // 设置键盘通知或者手势控制键盘消失
        self.tableMain.contentInset = UIEdgeInsetsMake(0, 0, 0, 0); //UIEdgeInsets( top: t, left: l, bottom: b, right: r)
        self.tableMain.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0); //UIEdgeInsets( top: t, left: l, bottom: b, right: r)
    }
    
    [self initKeyboardBlock];
    
    // 取消输入框
    [self.messageInputView.inputTextView resignFirstResponder];
    [self setEditing:NO animated:YES];
    // remove键盘通知或者手势
    [self.myTableView disSetupPanGestureControlKeyboardHide:NO];
    
    ((QWBaseNavigationController *)self.navigationController).canDragBack = NO;
}

#pragma mark - Key-value Observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == self.messageInputView.inputTextView && [keyPath isEqualToString:@"contentSize"])
    {
        [self layoutAndAnimateMessageInputTextView:object];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.messageInputView.inputTextView resignFirstResponder];
    [self.messageInputView.inputTextView removeObserver:self forKeyPath:@"contentSize"];
    
    ((QWBaseNavigationController *)self.navigationController).canDragBack = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XHMessageInputView
- (void)initKeyboardBlock
{
    WEAKSELF
    if (allowsPanToDismissKeyboard) {
        // 控制输入工具条的位置块
        void (^AnimationForMessageInputViewAtPoint)(CGPoint point) = ^(CGPoint point) {
            CGRect inputViewFrame = weakSelf.messageInputView.frame;
            CGPoint keyboardOrigin = [weakSelf.view convertPoint:point fromView:nil];
            inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
            weakSelf.messageInputView.frame = inputViewFrame;
        };
        
        self.myTableView.keyboardDidScrollToPoint = ^(CGPoint point) {
            if (weakSelf.textViewInputViewType == XHInputViewTypeText)
                AnimationForMessageInputViewAtPoint(point);
        };
        
        self.myTableView.keyboardWillSnapBackToPoint = ^(CGPoint point) {
            if (weakSelf.textViewInputViewType == XHInputViewTypeText)
                AnimationForMessageInputViewAtPoint(point);
        };
        
        self.myTableView.keyboardWillBeDismissed = ^() {
            CGRect inputViewFrame = weakSelf.messageInputView.frame;
            inputViewFrame.origin.y = weakSelf.view.bounds.size.height - inputViewFrame.size.height;
            weakSelf.messageInputView.frame = inputViewFrame;
        };
    }
    
    // block回调键盘通知
    self.myTableView.keyboardWillChange = ^(CGRect keyboardRect, UIViewAnimationOptions options, double duration, BOOL showKeyborad) {
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
                                 //ok
                                 [weakSelf setTableViewInsetsWithBottomValue:weakSelf.view.frame.size.height
                                  - weakSelf.messageInputView.frame.origin.y - kOffSet];
                                 if (showKeyborad)
                                     [weakSelf scrollToBottomAnimated:NO];
                             }
                             completion:nil];
        }
    };
    
    self.myTableView.keyboardDidChange = ^(BOOL didShowed) {
        if ([weakSelf.messageInputView.inputTextView isFirstResponder]) {
            if (didShowed) {
                if (weakSelf.textViewInputViewType == XHInputViewTypeText) {
                    weakSelf.shareMenuView.alpha = 0.0;
                    weakSelf.emotionManagerView.alpha = 0.0;
                }
            }
        }
    };
    
    self.myTableView.keyboardDidHide = ^() {
        [weakSelf.messageInputView.inputTextView resignFirstResponder];
    };
}

//XHMessageInputViewDelegate
- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView
{
    self.textViewInputViewType = XHInputViewTypeText;
}

- (void)inputTextViewDidBeginEditing:(XHMessageTextView *)messageInputTextView{
    
}

#pragma mark - 初始化工具
/**
 *  初始化消息界面布局
 */
- (void)initilzer
{
    // 初始化输入工具条
    [self layoutDifferentMessageType];
    // 设置手势滑动，默认添加一个bar的高度值
    self.myTableView.messageInputBarHeight = CGRectGetHeight(_messageInputView.bounds);
}
/**
 *  初始化输入工具条
 */
- (void)layoutDifferentMessageType
{
    CGRect inputFrame = CGRectMake(0.0f,
                                   self.view.frame.size.height - kInputViewHeight,
                                   self.view.frame.size.width,
                                   kInputViewHeight);
    UIView *bottomView = nil;
    
    if (!_messageInputView) {
        _messageInputView = [self setupMessageInputView:inputFrame];
        _messageInputView.delegate = self;
    }
    bottomView = _messageInputView;
    
    if(bottomView) {
        [self.view addSubview:bottomView];
        [self.view bringSubviewToFront:bottomView];
    }
}

/**
 *  单例初始化输入工具条XHMessageInputView
 */
- (XHMessageInputView *)setupMessageInputView:(CGRect)inputFrame
{
    _messageInputView = [[XHMessageInputView alloc] initWithFrame:inputFrame];
    _messageInputView.allowsSendFace = allowsSendFace;
    _messageInputView.allowsSendVoice = allowsSendVoice;
    _messageInputView.allowsSendMultiMedia = allowsSendMultiMedia;
    
    return _messageInputView;
}

#pragma mark - 初始化shareMenuView
- (XHShareMenuView *)shareMenuView {
    if (!_shareMenuView) {
        _shareMenuView = [[XHShareMenuView alloc] initWithFrame:CGRectMake(0, kViewHeight, CGRectGetWidth(self.view.bounds), kShareMenuHeight)];
        _shareMenuView.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
        _shareMenuView.alpha = 0.0;
        _shareMenuView.delegate = self;
        [self.shareMenuView reloadData];
        [self.view addSubview:_shareMenuView];
    }
    //    [self.view bringSubviewToFront:_shareMenuView];
    return _shareMenuView;
}

//开放给子类使用，简化XHShareMenuView初始化赋值，不调用默认有相机和相册
- (void)setupShareMenuViewImgArr:(NSArray *)imgArr andTitleArr:(NSArray *)titleArr{

    NSMutableArray *shareMenuItems = [NSMutableArray array];
    for (NSString *plugIcon in imgArr) {
        XHShareMenuItem *shareMenuItem = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:plugIcon] title:[titleArr objectAtIndex:[imgArr indexOfObject:plugIcon]]];
        [shareMenuItems addObject:shareMenuItem];
    }
    self.shareMenuView.shareMenuItems = shareMenuItems;
    [self.shareMenuView reloadData];
}

//XHShareMenuViewDelegate点击“+”号键盘里地单个功能回调
- (void)didSelecteShareMenuItem:(XHShareMenuItem *)shareMenuItem atIndex:(NSInteger)index{
    
    [self didSelectedShareMenuViewAtIndex:index];
}

//XHShareMenuView点击某个item触发，开发给子类使用
- (void)didSelectedShareMenuViewAtIndex:(NSInteger)index{
    
    
}

#pragma mark - 初始化XHEmotionManagerView
//初始化表情manager,最好能做成异步(暂时不处理)
- (void)setUpEmojiManager
{
    NSString *emojiPath = [[NSBundle mainBundle] pathForResource:@"expressionImage_custom" ofType:@"plist"];
    NSMutableDictionary *emotionDict = [[NSMutableDictionary alloc] initWithContentsOfFile:emojiPath];
    NSArray *allKeys = [emotionDict allKeys];
    XHEmotionManager *emotionManager = [[XHEmotionManager alloc] init];
    NSMutableArray *emotionManagers = [NSMutableArray arrayWithCapacity:100];
    
#define ROW_NUM     3
#define COLUMN_NUM  7
    for(NSUInteger index = 0; index < [allKeys count]; ++index)
    {
        NSString *key = allKeys[index];
        if(index != 0 && (index % (ROW_NUM * COLUMN_NUM - 1)) == 0){
            [emotionManager.emotions addObject:[self addDeleteItem]];
        }
        XHEmotionManager *subEmotion = [[XHEmotionManager alloc] init];
        subEmotion.emotionName = key;
        subEmotion.imageName = emotionDict[key];
        [emotionManager.emotions addObject:subEmotion];
        if (index == [allKeys count] - 1)
        {
            [emotionManager.emotions addObject:[self addDeleteItem]];
        }
    }
    [emotionManagers addObject:emotionManager];
    self.emotionManagers = emotionManagers;
    [self.emotionManagerView reloadData];
}
//加上删除按钮
- (XHEmotionManager *)addDeleteItem
{
    XHEmotionManager *subEmotion = [[XHEmotionManager alloc] init];
    subEmotion.emotionName = @"删除";
    subEmotion.imageName = @"backFaceSelect";
    return subEmotion;
}

//初始化表情XHEmotionManagerView
- (XHEmotionManagerView *)setupEmotionManagerView {
    if (!_emotionManagerView) {
        _emotionManagerView = [[XHEmotionManagerView alloc] initWithFrame:CGRectMake(0, kViewHeight, CGRectGetWidth(self.view.bounds), kEmojiKeyboardHeight)];
        _emotionManagerView.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
        _emotionManagerView.alpha = 0.0;
        _emotionManagerView.delegate = self;
        _emotionManagerView.dataSource = self;
        [_emotionManagerView.emotionSectionBar.storeManagerItemButton addTarget:self action:@selector(didSendEmojiTextAction:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:_emotionManagerView];
        _emotionManagerView.userInteractionEnabled = YES;
        
    }
    [self.view bringSubviewToFront:_emotionManagerView];
    return _emotionManagerView;
}

//表情点击发送触发Action
- (void)didSendEmojiTextAction:(id)sender{
    
}

//XHEmotionManagerViewDataSource
- (NSInteger)numberOfEmotionManagers
{
    return self.emotionManagers.count;
}
- (XHEmotionManager *)emotionManagerForColumn:(NSInteger)column
{
    return [self.emotionManagers objectAtIndex:column];
}
- (NSArray *)emotionManagersAtManager
{
    return self.emotionManagers;
}
//XHEmotionManagerViewDelegate - 点击单个表情触发
- (void)didSelecteEmotion:(XHEmotion *)emotion atIndexPath:(NSIndexPath *)indexPath
{
    if (emotion.emotionPath) {
        NSString *text = self.messageInputView.inputTextView.text;
        if([emotion.emotionPath isEqualToString:@"删除"])
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
        }else{
            text = [text stringByAppendingString:emotion.emotionPath];
            self.messageInputView.inputTextView.text = text;
        }
    }
}

#pragma mark - 隐藏键盘
- (void)hiddenKeyboard
{
    [self.messageInputView.inputTextView resignFirstResponder];
    [self.messageInputView.faceSendButton setSelected:NO];
    [self.messageInputView.multiMediaSendButton setSelected:NO];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        CGFloat item_Y = 0;
        CGRect otherMenuViewFrame;
        //表情键盘
        item_Y = self.emotionManagerView.frame.origin.y;
        otherMenuViewFrame = self.emotionManagerView.frame;
        if (item_Y < kViewHeight) { //显示在界面上，则隐藏
            otherMenuViewFrame.origin.y = kViewHeight;
            self.emotionManagerView.alpha = 0;
            self.emotionManagerView.frame = otherMenuViewFrame;
            [self setTableViewInsetsWithBottomValue:self.view.frame.size.height
             - self.messageInputView.frame.origin.y - kOffSet];
        }
        //shareMenuView键盘
        item_Y = self.shareMenuView.frame.origin.y;
        otherMenuViewFrame = self.shareMenuView.frame;
        if (item_Y < kViewHeight) { //显示在界面上，则隐藏
            otherMenuViewFrame.origin.y = kViewHeight;
            self.shareMenuView.alpha = 0;
            self.shareMenuView.frame = otherMenuViewFrame;
            [self setTableViewInsetsWithBottomValue:self.view.frame.size.height
             - self.messageInputView.frame.origin.y - kOffSet];
        }
        //输入键盘
        item_Y = self.messageInputView.frame.origin.y;
        otherMenuViewFrame = self.messageInputView.frame;
        if (item_Y < kViewHeight - otherMenuViewFrame.size.height) {
            otherMenuViewFrame.origin.y = kViewHeight - otherMenuViewFrame.size.height;
            self.messageInputView.frame = otherMenuViewFrame;
            [self setTableViewInsetsWithBottomValue:self.view.frame.size.height
             - self.messageInputView.frame.origin.y - kOffSet];
        }
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isUserScrolling = YES;
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    }
    
    if (self.textViewInputViewType != XHInputViewTypeNormal && self.textViewInputViewType != XHInputViewTypeText) {
        [self hiddenKeyboard];
    }else if (self.textViewInputViewType == XHInputViewTypeText)
    {
        [self.messageInputView.inputTextView resignFirstResponder];
    }
    self.didScrollOrReload = NO;
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    
    self.isUserScrolling = NO;

    self.didScrollOrReload = YES;
    if (self.didScrollOrLoad) {
        [self.myTableView reloadData];
        self.didScrollOrLoad = NO;
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
        [UIView animateWithDuration:0.25f animations:^{
            //OK
            [self setTableViewInsetsWithBottomValue:self.myTableView.contentInset.bottom + changeInHeight];
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
                           //                           CGPoint bottomOffset = CGPointMake(0.0f, );
                           CGPoint bottomOffset = CGPointMake(0.0f, contentH - textView.bounds.size.height/2 - 13);
                           [textView setContentOffset:bottomOffset animated:YES];
                       });
    }
}

#pragma mark - 获取textView的高度
- (CGFloat)getTextViewContentH:(UITextView *)textView {
    if (iOSv7) {
        //        return ceilf([textView sizeThatFits:textView.frame.size].height);
        CGRect textFrame=[[textView layoutManager] usedRectForTextContainer:[textView textContainer]];
        return textFrame.size.height - 18;
    } else {
        return textView.contentSize.height;
    }
}

#pragma mark - XHMessageInputView各项点击事件:
//点击加号“+”
- (void)didSelectedMultipleMediaAction
{
    DebugLog(@"%s",__FUNCTION__);
    self.textViewInputViewType = XHInputViewTypeShareMenu;
    if(self.shareMenuView.alpha == 1.0) {
        [self.messageInputView.inputTextView becomeFirstResponder];
    }else{
        [self layoutOtherMenuViewHiden:NO];
    }
}

//点击表情-_-
- (void)didSendFaceAction:(BOOL)sendFace
{
    DebugLog(@"%s",__FUNCTION__);
    [self scrollToBottomAnimated:YES];
    if (sendFace) {
        self.textViewInputViewType = XHInputViewTypeEmotion;
        [self layoutOtherMenuViewHide:NO fromInputView:NO];
        [self scrollToBottomAnimated:YES];
    } else {
        [self.messageInputView.inputTextView becomeFirstResponder];
    }
}
- (void)layoutOtherMenuViewHiden:(BOOL)hide {
    [self layoutOtherMenuViewHide:hide fromInputView:YES];
    [self scrollToBottomAnimated:hide];
}

#pragma mark - Other Menu View Frame Helper Mehtod
/**
 *  Description
 *
 *  @param hide 是否隐藏
 *  @param from
 */
- (void)layoutOtherMenuViewHide:(BOOL)hide fromInputView:(BOOL)from {
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
            self.shareMenuView.alpha = 1.0f;
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
        } else {
            
            // 这里需要注意block的执行顺序，因为otherMenuViewFrame是公用的对象，所以对于被隐藏的Menu的frame的origin的y会是最大值
            switch (self.textViewInputViewType) {
                case XHInputViewTypeEmotion: {
                    // 1、先隐藏和自己无关的View
                    ShareMenuViewAnimation(!hide);
                    // 2、再显示和自己相关的View
                    EmotionManagerViewAnimation(hide);
                    break;
                }
                case XHInputViewTypeShareMenu: {
                    // 1、先隐藏和自己无关的View
                    EmotionManagerViewAnimation(!hide);
                    // 2、再显示和自己相关的View
                    ShareMenuViewAnimation(hide);
                    break;
                }
                case XHInputViewTypeVoice:{
                    //先隐藏与自己无关的view
                    ShareMenuViewAnimation(!hide);
                    EmotionManagerViewAnimation(!hide);
                    break;
                }
                default:
                    break;
            }
        }
        
        InputViewAnimation(hide);
        //        CGFloat offset = self.view.frame.size.height - self.messageInputView.frame.origin.y - kOffSet;
        CGFloat offset = self.view.frame.size.height - self.messageInputView.frame.origin.y - 42;
        NSLog(@"offset = %f",offset);
        [self setTableViewInsetsWithBottomValue:offset];
        
        [self scrollToBottomAnimated:NO];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)scrollToBottomAnimated:(BOOL)animated{
    
    if(self.myTableView.tableFooterView == nil) {
        NSInteger rows = [self.myTableView numberOfRowsInSection:0];
        if (rows > 0) {
            [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                                  atScrollPosition:UITableViewScrollPositionBottom
                                          animated:animated];
        }
    }else{
        [self.myTableView scrollRectToVisible:self.myTableView.tableFooterView.frame animated:YES];
    }
}


- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom
{
    UIEdgeInsets insets = [self tableViewInsetsWithBottomValue:bottom];
    self.myTableView.contentInset = insets;
    self.myTableView.scrollIndicatorInsets = insets;
    self.myTableView.header.scrollViewOriginalInset = insets;
    self.myTableView.footer.scrollViewOriginalInset = insets;
}

- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    insets.bottom = bottom;
    return insets;
}


#pragma mark - XHVoiceRecordHUD Helper Method
- (XHVoiceRecordHelper *)voiceRecordHelper {
    if (!_voiceRecordHelper) {
        _isMaxTimeStop = NO;
        
        WEAKSELF
        _voiceRecordHelper = [[XHVoiceRecordHelper alloc] init];
        _voiceRecordHelper.maxTimeStopRecorderCompletion = ^{
            DLog(@"已经达到最大限制时间了，进入下一步的提示");
            
            // Unselect and unhilight the hold down button, and set isMaxTimeStop to YES.
            UIButton *holdDown = weakSelf.messageInputView.holdDownButton;
            holdDown.selected = NO;
            holdDown.highlighted = NO;
            weakSelf.isMaxTimeStop = YES;
            
            [weakSelf finishRecorded];
        };
        _voiceRecordHelper.peakPowerForChannel = ^(float peakPowerForChannel ,float remainTime) {
            [weakSelf.voiceRecordHUD setPeakPower:peakPowerForChannel remainTime:remainTime];
        };
        _voiceRecordHelper.maxRecordTime = kVoiceRecorderTotalTime;
    }
    return _voiceRecordHelper;
}

- (XHVoiceRecordHUD *)voiceRecordHUD {
    if (!_voiceRecordHUD) {
        _voiceRecordHUD = [[XHVoiceRecordHUD alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
    }
    return _voiceRecordHUD;
}

#pragma mark - 初始化语音XHVoiceRecordHUD
- (NSString *)getRecorderPath {
    NSString *recorderPath = nil;
    recorderPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    recorderPath = [recorderPath stringByAppendingFormat:@"%@-MySound.caf", [dateFormatter stringFromDate:now]];
    return recorderPath;
}

//Voice Recording Helper Method
- (void)prepareRecordWithCompletion:(XHPrepareRecorderCompletion)completion {
    [self.voiceRecordHelper prepareRecordingWithPath:[self getRecorderPath] prepareRecorderCompletion:completion];
}

- (void)startRecord {
    [self.voiceRecordHUD startRecordingHUDAtView:self.view];
    [self.voiceRecordHelper startRecordingWithStartRecorderCompletion:^{
        if(playingMessageModel) {
//            playingMessageModel.audioPlaying = NO;
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[msgCenter getMessageIndex:playingMessageModel] inSection:0];
//            ChatTableViewCell *cell = (ChatTableViewCell *)[self.myTableView cellForRowAtIndexPath:indexPath];
//            [cell stopVoicePlay];
//            [[XHAudioPlayerHelper shareInstance] stopAudio];
//            playingMessageModel = nil;
            
        }
    }];
}

- (void)finishRecorded {
    WEAKSELF
    [self.voiceRecordHUD stopRecordCompled:^(BOOL fnished) {
        weakSelf.voiceRecordHUD = nil;
    }];
    [self.voiceRecordHelper stopRecordingWithStopRecorderCompletion:^{
        if([weakSelf.voiceRecordHelper.recordDuration doubleValue] < 1.0) {
            [SVProgressHUD showErrorWithStatus:@"录音时间过短!" duration:0.8];
            return;
        }
        NSString *UUID = [XMPPStream generateUUID];
        NSData *amrData = [weakSelf.voiceRecordHelper convertCafToAmr:[NSData dataWithContentsOfFile:weakSelf.voiceRecordHelper.recordPath]];

        NSString *privateName;
        if(IS_EXPERT_ENTRANCE){
            privateName = QWGLOBALMANAGER.configure.expertMobile;
        }else{
            privateName = QWGLOBALMANAGER.configure.userName;
        }
        
        
        NSString *audioPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat: @"Documents/%@/Voice/%@.amr",privateName,UUID]];
        BOOL flag = [amrData writeToFile:audioPath atomically:YES];
        if(flag){
            DebugLog(@"语音文件写入成功 = =");
        }else{
            DebugLog(@"语音文件写入失败 = =");
        }
        NSFileManager *manager = [NSFileManager defaultManager];
        [manager removeItemAtPath:weakSelf.voiceRecordHelper.recordPath error:nil];
        [self didSendAudio:@"[语音]" voicePath:audioPath audioUrl:nil duartion:weakSelf.voiceRecordHelper.recordDuration fromSender:nil onDate:[NSDate date] UUID:UUID];
    }];
}

- (void)pauseRecord {
    [self.voiceRecordHUD pauseRecord];
}

- (void)resumeRecord {
    [self.voiceRecordHUD resaueRecord];
}

- (void)cancelRecord {
    WEAKSELF
    [self.voiceRecordHUD cancelRecordCompled:^(BOOL fnished) {
        weakSelf.voiceRecordHUD = nil;
    }];
    [self.voiceRecordHelper cancelledDeleteWithCompletion:^{
        
    }];
}
- (void)prepareRecordingVoiceActionWithCompletion:(BOOL (^)(void))completion {
    [self prepareRecordWithCompletion:completion];
}

- (void)didStartRecordingVoiceAction {
    [self startRecord];
}

- (void)didCancelRecordingVoiceAction {
    [self cancelRecord];
}

- (void)didFinishRecoingVoiceAction {
    DLog(@"didFinishRecoingVoice");
    if (self.isMaxTimeStop == NO) {
        [self finishRecorded];
    } else {
        self.isMaxTimeStop = NO;
    }
}

- (void)didDragOutsideAction {
    [self resumeRecord];
}

- (void)didDragInsideAction {
    [self pauseRecord];
}

/**
 *  发送语音的回调方法
 *
 *  @param text              语音文本
 *  @param audioUrl          语音地址
 *  @param duartion          语音长度
 *  @param sender            发送者
 *  @param date              发送时间
 */
- (void)didSendAudio:(NSString *)text
           voicePath:(NSString *)voicePath
            audioUrl:(NSString *)audioUrl
            duartion:(NSString *)duartion
          fromSender:(NSString *)sender
              onDate:(NSDate *)date
                UUID:(NSString *)UUID
{
    MessageModel *messageModel = [[MessageModel alloc] initWithVoicePath:voicePath voiceUrl:audioUrl voiceDuration:duartion sender:sender timestamp:date UUID:UUID];
    [self didSendVoiceFileAction:messageModel];
}

//Action发送语音触发，开发给子类使用
- (void)didSendVoiceFileAction:(MessageModel *)filePath
{
    
}

#pragma mark - 相册
- (void)LocalPhoto
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PhotoAlbum" bundle:nil];
    PhotoAlbum* vc = [sb instantiateViewControllerWithIdentifier:@"PhotoAlbum"];
    [vc selectPhotos:4 selected:nil block:^(NSMutableArray *list) {
        //相册选择完成后回调
        NSMutableArray *imgArr = [NSMutableArray array];
        for (PhotoModel *mode in list) {
            if (mode.fullImage) {
                [imgArr addObject:mode.fullImage];
            }
        }
        [self didSendImageFileAction:imgArr];
        
    } failure:^(NSError *error) {
        DebugLog(@"%@",error);
        [vc closeAction:nil];
    }];
    
    UINavigationController *nav = [[QWBaseNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:^{
    }];
}

#pragma mark - 拍照
-(void)takePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        [self performSelector:@selector(showcamera) withObject:nil afterDelay:0.3];
    }else{
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

-(void)showcamera
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.videoQuality = UIImagePickerControllerQualityTypeLow;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}
//相机拍照完成后回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    originalImage = [originalImage imageByScalingToMinSize];
    originalImage = [UIImage scaleAndRotateImage:originalImage];
    if (!originalImage)
        return;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        // Resize the image
        UIImage * image = [originalImage resizedImage:originalImage.size interpolationQuality:kCGInterpolationDefault];
        
        // Optionally save the image here...
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // ... Set / use the image here...
            [self didSendImageFileAction:[NSMutableArray arrayWithObjects:image, nil]];
            [self dismissModalViewControllerAnimated:YES];
        });           
    });
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType ==     UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
}

#pragma mark - 相册、相机回调
//图片相关统一回调（相册多张、相机单张 均以UIImage组成的数组返回）
-(void)didSendImageFileAction:(NSMutableArray *)imgArr
{
    //imgArr数组内部数据类型:UIImage
}

- (void)pushToDrugDetailWithDrugID:(NSString *)drugId promotionId:(NSString *)promotionID{
    
    WebDirectViewController *vcWebMedicine = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
    
    WebDrugDetailModel *modelDrug = [[WebDrugDetailModel alloc] init];
    modelDrug.proDrugID = drugId;
    modelDrug.promotionID = promotionID;
    
    WebDirectLocalModel *modelLocal = [[WebDirectLocalModel alloc] init];
    modelLocal.modelDrug = modelDrug;
    modelLocal.typeLocalWeb = WebLocalTypeCouponProduct;
    modelLocal.title = @"药品详情";
    [vcWebMedicine setWVWithLocalModel:modelLocal];
    
    [self.navigationController pushViewController:vcWebMedicine animated:YES];
}
@end
