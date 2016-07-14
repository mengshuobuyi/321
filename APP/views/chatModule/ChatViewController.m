//
//  ChatViewController.m
//  APP
//
//  Created by carret on 15/5/21.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "ChatViewController.h"

//系统库
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

//控制器
#import "DFMultiPhotoSelectorViewController.h"
#import "SearchSliderViewController.h"
#import "HealthQASearchViewController.h"
#import "MarketingActivityViewController.h"
#import "CoupnViewController.h"

//第三方UI控件
#import "XHShareMenuView.h"
#import "XHMessageInputView.h"
#import "XHEmotionManager.h"
#import "XHEmotionManagerView.h"
#import "ChatManagerDefs.h"
#import "ChatBubbleViewHeader.h"


//cell
#import "ChatTableViewCell.h"
#import "ChatOutgoingTableViewCell.h"

//第三方数据类
#import "XHMessage.h"
#import "XMPPStream.h"
#import "SVProgressHUD.h"
#import "SBJson.h"
#import "PopupMarketActivityView.h"
#import "LeveyPopListView.h"

//相册
#import "QYImage.h"
#import "QYPhotoAlbum.h"
#import "PhotoAlbum.h"

//图片浏览
#import "PhotoPreView.h"

//扩展
#import "UIImage+Ex.h"
#import "UIScrollView+XHkeyboardControl.h"

#import "UIImageView+WebCache.h"
//消息中心
#import "PTPMessageCenter.h"

#import "MessageModel.h"
#import "ChatIncomeTableViewCell.h"
#import "ChatOutgoingTableViewCell.h"
#import "SJAvatarBrowser.h"

#import "testFrame.h"
#import "CouponModel.h"
#import "Store.h"
#import "IMApi.h"
#import "DrugModel.h"
#import "CouponModel.h"

#import "QuickSearchDrugViewController.h"

#import "PhotoChatBubbleView.h"
//语音
#import "XHVoiceRecordHUD.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "XHAudioPlayerHelper.h"
#import "VoiceChatBubbleView.h"
#import "XHVoiceRecordHelper.h"
#import "ConsultPTP.h"
#import "Customer.h"
#import "CustomerModelR.h"
#import "MyCustomerBaseModel.h"
#import "ClientMMDetailViewController.h"

//优惠
#import "BranchViewController.h"
#import "BranchdetailCViewController.h"
#import "WebDirectViewController.h"
#import "StoreSendMedicineViewController.h"

BOOL const allowsSendFace = YES;
BOOL const allowsSendVoice = YES;
BOOL const allowsSendMultiMedia = YES;
BOOL const allowsPanToDismissKeyboard = NO;//是否允许手势关闭键盘，默认是允许
const int alertResendIdentifier = 10000;
const int alertDeleteIdentifier = 10001;

#define kOffSet        45  //tableView偏移量
#define kInputViewHeight   45  //输入框的高度
#define kEmojiKeyboardHeight 216 //表情键盘的高度
#define kShareMenuHeight    95*2 //shareMenu键盘的高度
//self.view的高度  因为点击发送药品时，self.view的高度含导航栏，特此区别
#define kViewHeight  [UIScreen mainScreen].bounds.size.height - NAV_H - STATUS_H

@interface ChatViewController ()<LeveyPopListViewDelegate,XHMessageInputViewDelegate,XHShareMenuViewDelegate,XHEmotionManagerViewDataSource,XHEmotionManagerViewDelegate,UITableViewDataSource,UITableViewDelegate,DFMultiPhotoSelectorViewControllerDelegate,UINavigationControllerDelegate,MLEmojiLabelDelegate, UIImagePickerControllerDelegate,UIAlertViewDelegate,MarketActivityViewDelegate,XHAudioPlayerHelperDelegate,UIActionSheetDelegate>
{
    UIImage * willsendimg;
    PTPMessageCenter *msgCenter;
    UIMenuController    *_menuController;
    UIMenuItem          *_copyMenuItem;
    UIMenuItem          *_deleteMenuItem;
    NSIndexPath         *_longPressIndexPath;
    NSInteger           _recordingCount;
    dispatch_queue_t    _messageQueue;
    NSMutableArray      *_messages;
    BOOL                _isScrollToBottom;
    //浏览图片数组
    NSArray *arrPhotos;
    MessageModel        *playingMessageModel;
}



@property (nonatomic, weak, readwrite) XHShareMenuView *shareMenuView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTableFoot;
@property (nonatomic, assign) BOOL isUserScrolling;
/**
 *  第三方接入的功能，也包括系统自身的功能，比如拍照、发送地理位置
 */
@property (nonatomic, strong) NSArray *shareMenuItems;
/**
 *  管理第三方gif表情的控件
 */
@property (nonatomic, weak, readwrite) XHEmotionManagerView *emotionManagerView;
/**
 *  表情数据源
 */
@property (nonatomic, strong) NSArray *emotionManagers;

/**
 *  用于显示发送消息类型控制的工具条，在底部
 */
@property (nonatomic, strong, readonly) XHMessageInputView *messageInputView;
/**
 *  记录旧的textView contentSize Heigth
 */
@property (nonatomic, assign) CGFloat previousTextViewContentHeight;
//录音UI,按住说话,松开发送,拖拽出button 取消发送
@property (nonatomic, strong, readwrite) XHVoiceRecordHUD *voiceRecordHUD;

/**
 *  管理录音工具对象
 */
@property (nonatomic, strong) XHVoiceRecordHelper *voiceRecordHelper;
/**
 *  判断是不是超出了录音最大时长
 */
@property (nonatomic) BOOL isMaxTimeStop;
/**
 *  用来记录需要重发的字典对象
 */
@property (nonatomic, strong) NSDictionary *dicNeedResend;
@property (nonatomic, strong) NSMutableArray *CommonWords;
/**
 *  用来记录需要删除的字典对象
 */
@property (nonatomic, strong) NSDictionary *dicNeedDelete;

@property (nonatomic, assign) XHInputViewType textViewInputViewType;

@property (nonatomic, strong) PopupMarketActivityView *popupMarketActivityView;
@property (nonatomic, strong) NSMutableArray *arrNeedAdded;
@property (nonatomic, assign) CGPoint rectHistory;


@property (nonatomic ,assign)BOOL  didScrollOrReload;

@property (nonatomic ,assign)BOOL  didScrollOrLoad;
/**
 *  动态改变TextView的高度
 *
 *  @param textView 被改变的textView对象
 */
- (void)layoutAndAnimateMessageInputTextView:(UITextView *)textView;

@property (nonatomic, assign) BOOL              canSendMessage;
@property (nonatomic, assign) BOOL              canSendTimeoutMessage;

@end

#pragma mark
#pragma mark  ↑↑↑以上是声明部分↑↑↑
#pragma mark
@implementation ChatViewController
@synthesize emotionManagerView = _emotionManagerView;

#pragma mark
#pragma mark self viewController init
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {

    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)UIGlobal
{
    [super UIGlobal];
    [self.tableMain setBackgroundColor:RGBHex(qwColor11)];
}

#pragma mark
#pragma mark view基本回调
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableMain setupPanGestureControlKeyboardHide:allowsPanToDismissKeyboard];
    // KVO 检查contentSize
    [self.messageInputView.inputTextView addObserver:self
                                          forKeyPath:@"contentSize"
                                             options:NSKeyValueObservingOptionNew
                                             context:nil];
    
    //[self layoutOtherMenuViewHiden:NO];
    //不要删注释
    if (self.shareMenuView.alpha == 1 || self.emotionManagerView.alpha == 1) {
//        [self layoutOtherMenuViewHiden:NO];
    }else{
        // 设置键盘通知或者手势控制键盘消失
        self.tableMain.contentInset = UIEdgeInsetsMake(0, 0, 0, 0); //UIEdgeInsets( top: t, left: l, bottom: b, right: r)
        self.tableMain.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0); //UIEdgeInsets( top: t, left: l, bottom: b, right: r)
    }
    [self initKeyboardBlock];
    [msgCenter restart];
    
    
    //设置未读数
    self.customerSessionVo.unreadCounts = @"0";
    [PharSessionVo updateObjToDB:self.customerSessionVo WithKey:[NSString stringWithFormat:@"%@",self.customerSessionVo.sessionId]];
    
    //报告未读数
    [QWGLOBALMANAGER updateUnreadCount];

    ((QWBaseNavigationController *)self.navigationController).canDragBack = NO;
    self.constraintTableFoot.constant = -5.0f;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dicNeedDelete = @{};
    self.dicNeedResend = @{};
    self.arrNeedAdded = [@[] mutableCopy];
    self.CommonWords = [NSMutableArray arrayWithCapacity:15];

    [QWGLOBALMANAGER statisticsEventId:@"咨询详情页面_出现" withLable:@"咨询" withParams:nil];
    
    if(self.customerSessionVo && self.customerSessionVo.customerIndex)
    {
        self.title = self.customerSessionVo.customerIndex;
    }else if (self.customerSessionVo && self.customerSessionVo.customerIndex)
        self.title = self.customerSessionVo.customerIndex;
    else{
        self.title = @"聊天";
    }
    
    self.tableMain.footerHidden = YES;
    
    self.popupMarketActivityView = [[[NSBundle mainBundle] loadNibNamed:@"PopupMarketActivityView" owner:self options:nil] objectAtIndex:0];
    
    self.popupMarketActivityView.delegate = self;
    
    //下拉刷新
//    self.tableMain.headerPullToRefreshText = @"下拉刷新";
//    self.tableMain.headerReleaseToRefreshText = @"松开刷新";
//    self.tableMain.headerRefreshingText = @"正在刷新";
//    [self.tableMain addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self enableSimpleRefresh:self.tableMain block:^(SRRefreshView *sender) {
        [self headerRereshing];
    }];
    [self initilzer];
    [self setUpSharedMenuItem];
    [self setUpEmojiManager];
    [self messageCenterInit];
    self.messageInputView.userInteractionEnabled = NO;
    [self checkCertVaildate];
    
    self.didScrollOrReload = YES;
    self.didScrollOrLoad = NO;
    self.tableMain.hidden = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 取消输入框
    [self unLoadKeyboardBlock];
    [self.messageInputView.inputTextView resignFirstResponder];
    [self setEditing:NO animated:YES];
    
    // remove键盘通知或者手势
    [self.tableMain disSetupPanGestureControlKeyboardHide:NO];
    
    // remove KVO
    [self.messageInputView.inputTextView removeObserver:self forKeyPath:@"contentSize"];
    ((QWBaseNavigationController *)self.navigationController).canDragBack = YES;
    if(playingMessageModel) {
        playingMessageModel.audioPlaying = NO;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[msgCenter getMessageIndex:playingMessageModel] inSection:0];
        ChatTableViewCell *cell = (ChatTableViewCell *)[self.tableMain cellForRowAtIndexPath:indexPath];
        [cell stopVoicePlay];
        [[XHAudioPlayerHelper shareInstance] stopAudio];
        playingMessageModel = nil;
    }
    [[XHAudioPlayerHelper shareInstance] setDelegate:nil];
    
}

- (void)checkCertVaildate
{
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"branchId"] = QWGLOBALMANAGER.configure.groupId;
    setting[@"endpoint"] = @"2";
    [IMApi certcheckIMWithParams:setting success:^(BaseAPIModel *model) {
        
        if([model.apiStatus integerValue] == 3) {
            [SVProgressHUD showErrorWithStatus:model.apiMessage duration:2.0f];
            self.canSendMessage = YES;
            [self check24Hour];
        }else if([model.apiStatus integerValue] == 0) {
            self.canSendMessage = YES;
            [self check24Hour];
        }else{
            self.canSendMessage = NO;
            [SVProgressHUD showErrorWithStatus:model.apiMessage duration:2.0f];
            self.messageInputView.userInteractionEnabled = NO;
        }
    } failure:^(HttpException *e) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:0.8f];
    }];
}

//24小时过期判断,药店不能主动发起聊天
- (void)check24Hour
{
//    PTP24Check *setting = [PTP24Check new];
//    setting.sessionId = self.customerSessionVo.sessionId;
//    [ConsultPTP ptpCheckTimeoutWithParams:setting success:^(BaseAPIModel *model) {
//        if([model.apiStatus integerValue] == 0) {
//            self.canSendTimeoutMessage = YES;
//            self.messageInputView.userInteractionEnabled = YES;
//        }else{
//            self.canSendTimeoutMessage = NO;
//            [SVProgressHUD showErrorWithStatus:model.apiMessage duration:2.0f];
//            self.messageInputView.userInteractionEnabled = NO;
//        }
//    } failure:NULL];
    self.canSendTimeoutMessage = YES;
    self.messageInputView.userInteractionEnabled = YES;
}

- (void)headerRereshing
{
    //测试翻页历史数据
    self.rectHistory = self.tableMain.contentOffset;
    [self getHistory];
    [self.tableMain headerEndRefreshing];
}

#pragma mark
#pragma mark 获取数据源
- (void)dealloc{
    self.emotionManagers = nil;
    [[XHAudioPlayerHelper shareInstance] setDelegate:nil];
    [self closeMessageCenter];
    
}
- (void)viewDidDisappear:(BOOL)animated
{
//    [self showOrHideHeaderView];
}
#pragma mark - 消息中心
- (void)messageCenterInit{
    if (msgCenter == nil){
        DebugLog(@"AAAAAAAAAAAAAAAAAAAAAAA");
        msgCenter=[[PTPMessageCenter alloc]initWithID:self.branchId type:self.chatType];
        msgCenter.sessionID = self.sessionID;
        msgCenter.shopName = self.title;
        [msgCenter start];
        DebugLog(@"VVVVVVVVVVVVVVVVVVVVVVV");
    }

    //最新的消息回话，会实时刷新
    IMListBlock currentMsgBlock = ^(NSArray* list, IMListType gotType){
        //这里写刷新table的代码
        DebugLog(@"IIIIIIIIIIIIIMMMMMMMMMMMMM:%@",list);
//        return ;
// 
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:msgCenter.count -1 inSection:0];
//        
////        if (indexPath) {
//            //                 dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableMain beginUpdates];
//            [self.tableMain reloadRowsAtIndexPaths:@[indexPath]
//                                  withRowAnimation:UITableViewRowAnimationNone];
//            [self.tableMain endUpdates];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableMain reloadData];
            [self setTableViewInsetsWithBottomValue:self.view.frame.size.height
             - self.messageInputView.frame.origin.y - kOffSet];
            [self scrollToBottomAnimated:NO];
            self.tableMain.hidden = NO;
        });
        if (gotType == IMListAll) {
            if(self.sendConsultType == Enum_SendConsult_Drug) {
//                MessageModel *message = [self buildMedicineShowOnceMessage:nil];
//                [msgCenter addMessage:message];
            }else if (self.sendConsultType == Enum_SendConsult_Coupn) {
//                MessageModel *message = [self buildSpecialOffersShowOnceMessage:nil];
//                [msgCenter addMessage:message];
            }
//            [self performSelector:@selector(scrollToBottomAnimated:) withObject:[NSNumber numberWithBool:NO] afterDelay:0.2];

        }if (gotType == IMListDelete) {
            
        }
        else
        {
            
//            [self setTableViewInsetsWithBottomValue:self.view.frame.size.height
//             - self.messageInputView.frame.origin.y - kOffSet];
//            [self scrollToBottomAnimated:YES];
        }
        
     };
    [msgCenter getMessages:currentMsgBlock success:^(id successObj) {

        if (successObj !=nil) {
            PharSessionDetailList *model = successObj;
            
            
            
         }
   
        
    } failure:^(id failureObj) {
        
    }];
}

- (void)getHistory{
    //根据页码翻上一页
    IMHistoryBlock historyMsgBlock = ^(BOOL hadHistory){
        if (hadHistory)
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self tableMain] reloadData];
//            [self.tableMain reloadData];

        });        else {
            
        }
    };
    
    [msgCenter getHistory:historyMsgBlock success:^(id successObj) {
     }failure:^(id failureObj) {
    
    }];
}

- (CGFloat) firstRowHeight
{
    return [self tableView:[self tableMain] heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}


- (void)deleteMessage:(MessageModel *)model{
    [msgCenter removeMessage:model success:^(id successObj) {
        //刷新table
    } failure:^(id failureObj) {
        //
    }];
}

- (void)closeMessageCenter{
    if (msgCenter) {
        [msgCenter close];
        msgCenter = nil;
    }
}

#pragma mark
#pragma mark 消息发送中心
- (void)sendMessage:(MessageModel *)messageModel messageBodyType:(MessageBodyType)messageType
{
    switch (messageType) {
        case MessageMediaTypeText:   //发送纯文本
        {
            
            [msgCenter sendMessage:messageModel success:^(id successObj) {
                [self messageToPharMsg:messageModel send:MessageDeliveryState_Delivered ];
                [self.tableMain reloadData];
            } failure:^(id failureObj) {
                [self.tableMain reloadData];
                [self messageToPharMsg:messageModel send:MessageDeliveryState_Failure ];
            }];
        }
        break;
        case MessageMediaTypePhoto:     //发送图片
        {
            
//            [self progressUpdate:messageModel.UUID progress:0];
            [msgCenter sendFileMessage:messageModel success:^(id successObj) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[msgCenter getMessageIndex:messageModel] inSection:0];
                ChatOutgoingTableViewCell *cell = (ChatOutgoingTableViewCell *)[self.tableMain cellForRowAtIndexPath:indexPath];
                ((PhotoChatBubbleView *)cell.bubbleView).dpMeterView.activeShow.hidden = YES;
                ((PhotoChatBubbleView *)cell.bubbleView).dpMeterView.hidden = YES;
                ((PhotoChatBubbleView *)cell.bubbleView).dpMeterView.progressLabel.text = [NSString stringWithFormat:@"%d%@",0,@"%"];
                [self messageToPharMsg:messageModel send:MessageDeliveryState_Delivered ];
                [self.tableMain reloadData];
            } failure:^(id failureObj) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[msgCenter getMessageIndex:messageModel] inSection:0];
                ChatOutgoingTableViewCell *cell = (ChatOutgoingTableViewCell *)[self.tableMain cellForRowAtIndexPath:indexPath];
                
                ((PhotoChatBubbleView *)cell.bubbleView).dpMeterView.activeShow.hidden = YES;
                ((PhotoChatBubbleView *)cell.bubbleView).dpMeterView.hidden = YES;
                ((PhotoChatBubbleView *)cell.bubbleView).dpMeterView.progressLabel.text = [NSString stringWithFormat:@"%d%@",0,@"%"];
                [self.tableMain reloadData];
                 [self messageToPharMsg:messageModel  send:MessageDeliveryState_Failure];
            } uploadProgressBlock:^(MessageModel *target, float progress) {
               
                [self progressUpdate:messageModel.UUID progress:progress];
                
            }];
            break;
        }
        case MessageMediaTypeMedicineSpecialOffers://优惠活动
        {
            
            [msgCenter sendMessage:messageModel success:^(id successObj) {
                [self messageToPharMsg:messageModel send:MessageDeliveryState_Delivered ];
                [self.tableMain reloadData];
            } failure:^(id failureObj) {
                [self.tableMain reloadData];
                [self messageToPharMsg:messageModel  send:MessageDeliveryState_Failure];
            }];
            break;
        }
        case MessageMediaTypeCoupon:
        case MessageMediaTypeMedicineCoupon:
        case MessageMediaTypeMedicine: {
            [msgCenter sendMessage:messageModel success:^(id successObj) {
                [self messageToPharMsg:messageModel  send:MessageDeliveryState_Delivered];
                [self.tableMain reloadData];
            } failure:^(id failureObj) {
                [self.tableMain reloadData];
                [self messageToPharMsg:messageModel  send:MessageDeliveryState_Failure];
            }];
            break;
        }
        case MessageMediaTypeStoreMedicine: {
            [msgCenter sendMessage:messageModel success:^(id successObj) {
                [self messageToPharMsg:messageModel  send:MessageDeliveryState_Delivered];
                [self.tableMain reloadData];
            } failure:^(id failureObj) {
                [self.tableMain reloadData];
                [self messageToPharMsg:messageModel  send:MessageDeliveryState_Failure];
            }];
            break;
        }
        case MessageMediaTypeVoice:{
            //note by meng ，等待消息bubber调试完成后打开
            //发送语音文件
            [msgCenter sendFileMessage:messageModel success:^(id successObj) {
                [self messageToPharMsg:messageModel  send:MessageDeliveryState_Delivered];
                [self.tableMain reloadData];
            } failure:^(id failureObj) {
                [self.tableMain reloadData];
                [self messageToPharMsg:messageModel  send:MessageDeliveryState_Failure];
            } uploadProgressBlock:^(MessageModel *target, float progress) {
                
                
                
            }];
            break;
        }
        case MessageMediaTypeLocalPosition://发送地理位置
        {
            [msgCenter sendMessage:messageModel success:^(id successObj) {
                [self messageToPharMsg:messageModel  send:MessageDeliveryState_Delivered];
                [self.tableMain reloadData];
            } failure:^(id failureObj) {
                [self.tableMain reloadData];
                [self messageToPharMsg:messageModel  send:MessageDeliveryState_Failure];
            }];
            break;
        }
            case MessageMediaTypeActivity:
        {
            [msgCenter sendMessage:messageModel success:^(id successObj) {
                [self messageToPharMsg:messageModel  send:MessageDeliveryState_Delivered];
                [self.tableMain reloadData];
            } failure:^(id failureObj) {
                [self.tableMain reloadData];
                [self messageToPharMsg:messageModel  send:MessageDeliveryState_Failure];
            }];
            break;
        }
        break;
        default:
            break;
    }
}

-(void)progressUpdate:(NSString *)uuid progress:(float)newProgress
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        MessageModel *message = [msgCenter getMessageWithUUID:uuid];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[msgCenter getMessageIndex:message] inSection:0];
        ChatOutgoingTableViewCell *cell = (ChatOutgoingTableViewCell *)[self.tableMain cellForRowAtIndexPath:indexPath];
        if (cell) {
           ((PhotoChatBubbleView *)cell.bubbleView).dpMeterView.hidden = NO;
//           ((PhotoChatBubbleView *)cell.resendButton.hidden = YES;
            [((PhotoChatBubbleView *)cell.bubbleView).dpMeterView setProgress:newProgress];
        }
        
    });
    
}

- (void)messageToPharMsg:(MessageModel *)messageModel send:(NSInteger)sended
{
        PharMsgModel *history = [PharMsgModel getObjFromDBWithKey:self.branchId];
        history.title = self.title;
        history.timestamp =[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
        history.formatShowTime = [QWGLOBALMANAGER updateFirstPageTimeDisplayer:[NSDate dateWithTimeIntervalSince1970:[history.timestamp doubleValue]]];
        history.issend = [NSString stringWithFormat:@"%ld",(long)sended];
        switch ( messageModel.messageMediaType ) {
            case MessageMediaTypeText:
            {
                history.content = messageModel.text;
                break;
            }
            case MessageMediaTypePhoto:
            {
                history.content = @"[图片]";
                break;
            }
            case MessageMediaTypeActivity:
            {
                history.content = @"[活动]";
                break;
            }
            case MessageMediaTypeLocation:
            {
                history.content = @"[位置]";
                break;
                
            }
            case MessageMediaTypeMedicine:
            {
                history.content = @"[药品]";
                break;
            }
            case MessageMediaTypeStoreMedicine:
            {
                history.content = @"[药品]";
                break;
            }
            case MessageMediaTypeMedicineSpecialOffers:
            {
                history.content = @"[活动]";
                break;
                
            }
            default:
                break;
        }
        
        [PharMsgModel updateObjToDB:history WithKey:self.branchId];
//    [GLOBALMANAGER postNotif:NotiMessagePTPNeedUpdate data:nil object:nil];
}


/**
 *  点击发送时，做隐藏键盘操作
 */
- (void)finishSendMessageWithBubbleMessageType:(MessageBodyType)mediaType {
    switch (mediaType) {
        case MessageMediaTypeText:
        {
            [self.messageInputView.inputTextView setText:nil];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                self.messageInputView.inputTextView.enablesReturnKeyAutomatically = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.messageInputView.inputTextView.enablesReturnKeyAutomatically = YES;
                    [self.messageInputView.inputTextView reloadInputViews];
                });
            }
        }
            break;
        case MessageMediaTypePhoto:
        {
            
        }
            break;
        default:
            break;
    }
}

#pragma mark
#pragma mark （Action）点击发送文本
- (void)didSendTextAction:(NSString *)text
{
    if([QWGLOBALMANAGER removeSpace:text].length == 0)
    {
        
        [self.messageInputView.inputTextView  resignFirstResponder];
        [SVProgressHUD showErrorWithStatus:kWarning55 duration:DURATION_SHORT];
        return;
    }
    MessageModel *textModel = [[MessageModel alloc] initWithText:text
                                                          sender:self.messageSender
                                                       timestamp:[NSDate date]
                                                            UUID:[XMPPStream generateUUID]];

    [self sendMessage:textModel messageBodyType:MessageMediaTypeText];
    [self finishSendMessageWithBubbleMessageType:MessageMediaTypeText];
}

#pragma mark
#pragma mark （Action）点击表情键盘中的发送按钮
- (void)didSendEmojiTextMessage:(id)sender
{
    if([QWGLOBALMANAGER removeSpace:self.messageInputView.inputTextView.text].length == 0)
        return;
    MessageModel *emojiModel = [[MessageModel alloc] initWithText:self.messageInputView.inputTextView.text
                                                          sender:self.messageSender
                                                       timestamp:[NSDate date]
                                                            UUID:[XMPPStream generateUUID]];
    [self sendMessage:emojiModel messageBodyType:MessageMediaTypeText];
    [self finishSendMessageWithBubbleMessageType:MessageMediaTypeText];
}

#pragma mark
#pragma mark （Action）点击加号“+”
/**
 *  发送多媒体
 */
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

#pragma mark
#pragma mark （Action）调出表情键盘
/**
 *  发送表情
 */
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

#pragma mark
#pragma mark 点击单个表情触发事件
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
- (void)layoutOtherMenuViewHiden:(BOOL)hide {
    [self layoutOtherMenuViewHide:hide fromInputView:YES];
    [self scrollToBottomAnimated:hide];
}




#pragma mark - send Photo
- (void)LocalPhoto
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PhotoAlbum" bundle:nil];
    PhotoAlbum* vc = [sb instantiateViewControllerWithIdentifier:@"PhotoAlbum"];
    [vc selectPhotos:4 selected:nil block:^(NSMutableArray *list) {
        for (PhotoModel *mode in list) {
            if (mode.fullImage) {
                UIImage *image=mode.fullImage;
                [self didChoosePhoto:image];
            }
        }
    } failure:^(NSError *error) {
        DebugLog(@"%@",error);
        [vc closeAction:nil];
    }];
    
    UINavigationController *nav = [[QWBaseNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:^{
    }];
}


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
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        
    }
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
    
}
-(void)didChoosePhoto:(UIImage *)img
{
    NSString *UUID = [XMPPStream generateUUID];
    [[SDImageCache sharedImageCache] storeImage:img forKey:UUID toDisk:YES];
    if (![[SDImageCache sharedImageCache] diskImageExistsWithKey:UUID]) {
        [[SDImageCache sharedImageCache] storeImage:img forKey:UUID toDisk:YES];
    }
    MessageModel *model = [[MessageModel alloc] initWithPhoto:img thumbnailUrl:nil originPhotoUrl:nil sender:self.messageSender timestamp:[NSDate date] UUID:UUID richBody:nil];
    [self sendMessage:model messageBodyType:MessageMediaTypePhoto];
}

#pragma mark
#pragma mark 照相机
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

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
//    if(type == MLEmojiLabelLinkTypeQuickSearch) {
//        QuickSearchViewController *quickSearchViewController = [[QuickSearchViewController alloc] init];
//        quickSearchViewController.backButtonEnabled = YES;
//        [self.navigationController pushViewController:quickSearchViewController animated:YES];
//    }
}

#pragma mark -
#pragma mark 知识库的Action回调
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 1002)
    {
        if(buttonIndex == 0) {
            //药事知识库
            [QWGLOBALMANAGER statisticsEventId:@"咨询详情_医药助手_药事知识库" withLable:@"咨询" withParams:nil];
            SearchSliderViewController *sliderViewController = [[SearchSliderViewController alloc] init];
            //sliderViewController.keyBoardShow = YES;
            [self.navigationController pushViewController:sliderViewController animated:NO];
            
        }else if(buttonIndex == 1){
            //健康问答库
            [QWGLOBALMANAGER statisticsEventId:@"咨询详情_医药助手_健康问答库" withLable:@"咨询" withParams:nil];
            UIStoryboard *sbHealthQA = [UIStoryboard storyboardWithName:@"HealthQALibrary" bundle:nil];
            HealthQASearchViewController *sliderViewController = [sbHealthQA instantiateViewControllerWithIdentifier:@"HealthQASearchViewController"];
            sliderViewController.delegatePopVC = self;
            [self.navigationController pushViewController:sliderViewController animated:NO];
        }else if (buttonIndex == 2) {
            //药品快捷发送
            [QWGLOBALMANAGER statisticsEventId:@"咨询详情_医药助手_快捷发送" withLable:@"咨询" withParams:nil];
            StoreSendMedicineViewController *quickSearchDrugViewController = [StoreSendMedicineViewController new];
            quickSearchDrugViewController.returnValueBlock = ^(ExpertSearchMedicineListModel *model){

                MessageModel *medicineModel = [[MessageModel alloc] initWithStoreMedicine:model.proName
                                                                                productId:model.proId
                                                                                 imageUrl:model.imgUrl
                                                                                     spec:model.spec
                                                                                 branchId:QWGLOBALMANAGER.configure.groupId
                                                                              branchProId:model.productId
                                                                                   sender:self.messageSender
                                                                                timestamp:[NSDate date]
                                                                                     UUID:[XMPPStream generateUUID]];
                [self sendMessage:medicineModel messageBodyType:MessageMediaTypeStoreMedicine];
            };
            [self.navigationController pushViewController:quickSearchDrugViewController animated:NO];
        }
    }else if(actionSheet.tag==1009){
        if(buttonIndex == 0){
            //优惠活动
            
            ImDoingViewController *vc = [ImDoingViewController new];
            vc.SendNewCoupn = ^(BranchNewPromotionModel *model){
//                DebugLog(@"\n####################: %@",model);
                [self performSelector:@selector(toSendActivity:) withObject:model afterDelay:.35];
            };
            
            [self.navigationController pushViewController:vc animated:NO];
        }
        else if(buttonIndex == 1) {
            //海报
            
            MarketingActivityViewController *marketViewController = [[MarketingActivityViewController alloc] init];
            marketViewController.SendActivity = ^(QueryActivityInfo *model) {
//                NSDictionary *mode=[model dictionaryModel];
//                NSMutableDictionary *dic2 =[NSMutableDictionary dictionaryWithDictionary:mode];
//                [self showPopMarkActivityDetail:dic2];
                [self performSelector:@selector(toSendActivity:) withObject:model afterDelay:.35];
            };
            [self.navigationController pushViewController:marketViewController animated:NO];
        }
        
    }
}
- (void)showPopMarkActivityDetail:(NSMutableDictionary *)dict
{
    if(dict[@"imgUrl"]&&![dict[@"imgUrl"] isEqualToString:@""]){
        [self.popupMarketActivityView setContent:[QWGLOBALMANAGER replaceSpecialStringWith:dict[@"content"]] avatarUrl:dict[@"imgUrl"]];
    }else{
        [self.popupMarketActivityView setContent:[QWGLOBALMANAGER replaceSpecialStringWith: dict[@"content"]] avatarUrl:nil];
    }
    
    self.popupMarketActivityView.infoDict = dict;
    self.popupMarketActivityView.enum_type=Enum_Items_Activity;
    [self.popupMarketActivityView showInView:self.view animated:YES];
    [self.view addSubview:self.popupMarketActivityView];
}
- (void)showCoupnActivityDetail:(NSMutableDictionary *)dict
{
    [self.popupMarketActivityView setContent:[QWGLOBALMANAGER replaceSpecialStringWith: dict[@"desc"]] avatarUrl:dict[@"imgUrl"]];
    self.popupMarketActivityView.infoDict = dict;
    self.popupMarketActivityView.enum_type=Enum_Items_Coupn;
    [self.popupMarketActivityView showInView:self.view animated:YES];
    [self.view addSubview:self.popupMarketActivityView];
}


#pragma mark
#pragma mark - Scroll Message TableView Helper Method

- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom
{
    UIEdgeInsets insets = [self tableViewInsetsWithBottomValue:bottom];
    self.tableMain.contentInset = insets;
    self.tableMain.scrollIndicatorInsets = insets;
    self.tableMain.header.scrollViewOriginalInset = insets;
    self.tableMain.footer.scrollViewOriginalInset = insets;
}

- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    insets.bottom = bottom;
    return insets;
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    if(self.tableMain.tableFooterView == nil) {
        NSInteger rows = [self.tableMain numberOfRowsInSection:0];
        if (rows > 0) {
//            [self.tableMain scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
//                                         atScrollPosition:UITableViewScrollPositionBottom
//                                                 animated:animated];
//            sleep(10);
//            [self.tableMain setContentOffset:CGPointMake(0, self.tableMain.contentSize.height)];
//            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scrollToBottom) userInfo:nil repeats:NO];
//            [self.tableMain setContentOffset:CGPointMake(0, self.tableMain.contentSize.height) animated:NO];
//            [self.tableMain setContentOffset:CGPointMake(0, self.tableMain.contentSize.height) animated:YES];
            [self.tableMain scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                                  atScrollPosition:UITableViewScrollPositionBottom
                                          animated:animated];
        }
    }else{
        [self.tableMain scrollRectToVisible:self.tableMain.tableFooterView.frame animated:YES];
    }
}

//- (void)scrollToBottom
//{
//    [self.tableMain setContentOffset:CGPointMake(0, self.tableMain.contentSize.height) animated:YES];
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isUserScrolling = YES;
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    }
    
    if (self.textViewInputViewType != XHInputViewTypeNormal && self.textViewInputViewType != XHInputViewTypeText) {
//        [self layoutOtherMenuViewHiden:YES];
        [self hiddenKeyboard];
    }else if (self.textViewInputViewType == XHInputViewTypeText)
    {
        [self.messageInputView.inputTextView resignFirstResponder];
    }
  self.didScrollOrReload = NO;
}

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


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.isUserScrolling = NO;
    
    self.didScrollOrReload = YES;
    if (self.didScrollOrLoad) {
        [self.tableMain reloadData];
        self.didScrollOrLoad = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  是否显示时间轴Label的回调方法
 *  @param indexPath 目标消息的位置IndexPath
 *  @return 根据indexPath获取消息的Model的对象，从而判断返回YES or NO来控制是否显示时间轴Label
 */
- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageModel *message1 = [msgCenter getMessageByIndex:  indexPath.row];
    if(indexPath.row == 0) {
        return YES;
    }else{
        MessageModel *message0 = [msgCenter getMessageByIndex:indexPath.row - 1];
        NSTimeInterval offset = [message1.timestamp timeIntervalSinceDate:message0.timestamp];
        if(offset >= 300.0)
            return YES;
    }
    return NO;
}

#pragma mark - table 刷新数据 UI

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *obj = nil;
    //    [self.dataSource objectAtIndex:indexPath.row];
    obj=[msgCenter getMessageByIndex:indexPath.row];
    //TODO: need update
    BOOL displayTimestamp = YES;
    displayTimestamp = [self shouldDisplayTimestampForRowAtIndexPath:indexPath];
    return [ChatTableViewCell tableView:tableView heightForRowAtIndexPath:indexPath withObject:(MessageModel *)obj hasTimeStamp:displayTimestamp];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (msgCenter) {
        return msgCenter.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel *model;
    model = [msgCenter getMessageByIndex:indexPath.row];
    
    if(model.messageDeliveryType == MessageTypeSending) {
        ChatOutgoingTableViewCell   *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatOutgoingTableViewCell"];
        cell.superParentViewController = self;
        cell.delegate = msgCenter;
        BOOL displayTimestamp = YES;
        displayTimestamp = [self shouldDisplayTimestampForRowAtIndexPath:indexPath];
        [cell setupSubviewsForMessageModel:model];
        cell.displayTimestamp = displayTimestamp;
        cell.messageModel = model;
        [cell updateBubbleViewConsTraint:model];
        [cell.headImageView setImageWithURL:[NSURL URLWithString:QWGLOBALMANAGER.configure.avatarUrl] placeholderImage:[UIImage imageNamed:@"药店默认头像"]];
 
        if (displayTimestamp) {
            [cell configureTimeStampLabel:model];
        }
        
        [cell setupTheBubbleImageView:model];
        
        return cell;
        
    }else{
        ChatIncomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatIncomeTableViewCell"];
        cell.superParentViewController = self;
        cell.delegate = msgCenter;
        BOOL displayTimestamp = YES;
        displayTimestamp = [self shouldDisplayTimestampForRowAtIndexPath:indexPath];
        
        [cell setupSubviewsForMessageModel:model];
        cell.displayTimestamp = displayTimestamp;
        cell.messageModel = model;
        [cell updateBubbleViewConsTraint:model];
        
        [cell.headImageView setImageWithURL:[NSURL URLWithString:model.avatorUrl] placeholderImage:[UIImage imageNamed:@"expert_ic_people"]];
        
        if (displayTimestamp) {
            [cell configureTimeStampLabel:model];
        }
        
        [cell setupTheBubbleImageView:model];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    
}
- (void)reloadData{
     
    [self.tableMain reloadData];
}

//删除某一条记录
- (void)deleteOneMessageAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)stopMusicInOtherBubblePressed
{
    if(playingMessageModel) {
        playingMessageModel.audioPlaying = NO;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[msgCenter getMessageIndex:playingMessageModel] inSection:0];
        ChatTableViewCell *cell = (ChatTableViewCell *)[self.tableMain cellForRowAtIndexPath:indexPath];
        [cell stopVoicePlay];
        XHAudioPlayerHelper *playerHelper = [XHAudioPlayerHelper shareInstance];
        [playerHelper stopAudioWithOutDelegate];
        playingMessageModel = nil;
    }
}


#pragma mark - UIResponder actions

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    if(![eventName isEqualToString:kRouterEventOfVoice]) {
        [self stopMusicInOtherBubblePressed];
    }
    for (ChatTableViewCell *cell in self.tableMain.visibleCells) {
        [cell updateMenuControllerVisiable];
    }
    if([eventName isEqualToString:kRouterEventLocationChat]){
        [self.messageInputView.inputTextView resignFirstResponder];
        MessageModel *model=[userInfo objectForKey:KMESSAGEKEY];
        ShowLocationViewController *showLocationViewController = [[ShowLocationViewController alloc] init];
        showLocationViewController.coordinate =[model location].coordinate;
        showLocationViewController.address = [model text];
        [self.navigationController pushViewController:showLocationViewController animated:YES];
    }
    else if ([eventName isEqualToString:kRouterEventPhotoBubbleTapEventName])
    {
        //点击预览图片
        BubblePhotoImageView *bubble=[userInfo objectForKey:KMESSAGEKEY];
        MessageModel *mm=bubble.messageModel;
        NSString *uuid=StrFromObj(mm.UUID);
        arrPhotos=[msgCenter getImages];
        if (arrPhotos.count==0) {
            return;
        }
        int i = 0;
        for (id obj in arrPhotos) {
            if ([obj isKindOfClass:[NSString class]]) {
                NSString *uid=obj;
                if ([uid isEqualToString:uuid]) {
                    break;
                }
            }
            i++;
        }


        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PhotoAlbum" bundle:nil];
        PhotoPreView* vc = [sb instantiateViewControllerWithIdentifier:@"PhotoPreView"];

        vc.arrPhotos = arrPhotos;     //uiimage或者url数组，用全局数组，否则会crash
        vc.indexSelected = (i==arrPhotos.count)?0:i;
        [self presentViewController:vc animated:YES completion:^{
            
        }];
    }
    else if ([eventName isEqualToString:kRouterEventNoImageActivityBubbleTapEventName] || [eventName isEqualToString:kRouterEventHaveImageActivityBubbleTapEventName] )
    {
        //发送营销活动
        MarketDetailViewController *marketDetailViewController = nil;
        marketDetailViewController = [[MarketDetailViewController alloc] initWithNibName:@"MarketDetailViewController" bundle:nil];
        MessageModel *model=[userInfo objectForKey:KMESSAGEKEY];
        QueryActivityInfo *infoDict = [QueryActivityInfo new];
        infoDict.activityId = model.richBody;
        marketDetailViewController.infoDict = infoDict;
        marketDetailViewController.userType = USETYPE_XM;
        NSDate *date = model.timestamp;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        QueryActivityInfo *modelactivity=[QueryActivityInfo new];
        if (!model.richBody)
        { //空的时候
            modelactivity.title=model.title;
            modelactivity.content=model.text;
            modelactivity.imgUrl=model.activityUrl;
            modelactivity.publishTime=[formatter stringFromDate:date];
            
            marketDetailViewController.infoDict =modelactivity;
        }else{
            modelactivity.title=model.title;
            modelactivity.content=model.text;
            modelactivity.activityId=model.richBody;
            modelactivity.publishTime=[formatter stringFromDate:date];
            marketDetailViewController.infoNewDict =modelactivity;
        }
        [self.navigationController pushViewController:marketDetailViewController animated:YES];
    }
    
    //yqy 优惠活动 PMT
    else if ([eventName isEqualToString:kRouterEventCoupnChat]){
        MessageModel *modelMessage=[userInfo objectForKey:KMESSAGEKEY];
        DoingDetailViewController *vc=[DoingDetailViewController new];
        vc.packPromotionId=modelMessage.richBody;
        vc.titlela=modelMessage.title;
        [self.navigationController pushViewController:vc animated:YES];

    }
    else if([eventName isEqualToString:kRouterEventDrugChat]){
        //220 药品详情
        
        [QWGLOBALMANAGER statisticsEventId:@"咨询详情_药品链接" withLable:@"咨询" withParams:nil];
        MessageModel *model=[userInfo objectForKey:KMESSAGEKEY];
        [self pushToDrugDetailWithDrugID:model.richBody promotionId:nil];
        
//        DrugDetailViewController *drugDetailViewController = [[DrugDetailViewController alloc] init];
//        drugDetailViewController.proId = model.richBody;
//        [self.navigationController pushViewController:drugDetailViewController animated:YES];
    }
    else if ([eventName isEqualToString:kResendButtonTapEventName])
    {
        //重发
        self.dicNeedResend = userInfo;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"重发该消息?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = alertResendIdentifier;
        [alertView show];     
    }else if ([eventName isEqualToString:kDeleteBtnTapEventName])
    {
        //删除
        self.dicNeedDelete = userInfo;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"你确定要删除吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = alertDeleteIdentifier;
        [alertView show];
    }
    else if ([eventName isEqualToString:kRouterEventOfVoice]) {
        MessageModel *model=[userInfo objectForKey:KMESSAGEKEY];
        XHAudioPlayerHelper *playerHelper = [XHAudioPlayerHelper shareInstance];
        [playerHelper setDelegate:self];
        if(playingMessageModel) {
            playingMessageModel.audioPlaying = NO;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[msgCenter getMessageIndex:playingMessageModel] inSection:0];
            ChatTableViewCell *cell = (ChatTableViewCell *)[self.tableMain cellForRowAtIndexPath:indexPath];
            [cell stopVoicePlay];
            if(model == playingMessageModel) {
                [playerHelper stopAudioWithOutDelegate];
                playingMessageModel = nil;
                return;
            }
        }
        
        if(model.download == MessageFileState_Downloading) {
            return;
        }else if(model.download == MessageFileState_Failure || model.download == MessageFileState_Pending) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[msgCenter getMessageIndex:model] inSection:0];
            ChatTableViewCell *cell = (ChatTableViewCell *)[self.tableMain cellForRowAtIndexPath:indexPath];
            [cell redownloadAudio:nil];
        }else{
            
            XHAudioPlayerHelper *playerHelper = [XHAudioPlayerHelper shareInstance];
            [playerHelper stopAudioWithOutDelegate];
            playingMessageModel = model;
            playingMessageModel.audioPlaying = YES;
            if (model.voicePath.length == 0) {
                return;
            }
            NSMutableArray *conpoment = [[model.voicePath componentsSeparatedByString:@"/"] mutableCopy];
            conpoment = [conpoment subarrayWithRange:NSMakeRange(conpoment.count - 4, 4)];
            NSString *amrPath = [NSHomeDirectory() stringByAppendingPathComponent:[conpoment componentsJoinedByString:@"/"]];
            NSData *amrData = [[NSData alloc] initWithContentsOfFile:amrPath];
            if(!amrData || amrData.length == 0) {
                return;
            }
            NSData *cafData = [self.voiceRecordHelper convertAmrToCaf:amrData];
            NSString *cafTempPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat: @"tmp/temp.caf"]];
            [cafData writeToFile:cafTempPath atomically:YES];
            [playerHelper managerAudioWithFileName:cafTempPath toPlay:YES];
        }
        
    }
    else if ([eventName isEqualToString:kHeadImageClickEventName]) {
         // 头像点击
        MessageModel *model=[userInfo objectForKey:KMESSAGEKEY];
        if(model.messageDeliveryType == MessageTypeReceiving) {
            CustomerDetailInfoModelR *modelInfoR = [CustomerDetailInfoModelR new];
            modelInfoR.token = QWGLOBALMANAGER.configure.userToken;
            modelInfoR.customer = StrFromObj(self.branchId);
            
            HttpClientMgr.progressEnabled = NO;
            [Customer QueryCustomerInfoWithParams:modelInfoR success:^(id obj) {
                MyCustomerInfoModel *modelInfo = (MyCustomerInfoModel *)obj;
                if ([modelInfo.apiStatus integerValue] == 0) {
                    
                    ClientMMDetailViewController *info = [[UIStoryboard storyboardWithName:@"ClientInfo" bundle:nil] instantiateViewControllerWithIdentifier:@"ClientMMDetailViewController"];
                    info.hidesBottomBarWhenPushed = YES;
                    info.customerId = self.branchId;
                    [self.navigationController pushViewController:info animated:YES];
                
                }else
                {
                    
                }
                
            } failue:^(HttpException *e) {
                
            }];
        }
    }
    //220 yqy 优惠券
    else if ([eventName isEqualToString:kCouponTickettBubbleView]) {
        MessageModel *mm=[userInfo objectForKey:KMESSAGEKEY];
        BranchCouponVo *tmp=[BranchCouponVo new];
        tmp.groupId=mm.title;
        tmp.groupName=mm.subTitle;
        tmp.couponTag=mm.text;
        tmp.couponValue=mm.richBody;
        tmp.couponId=mm.otherID;
        tmp.scope=mm.style;
        tmp.giftImgUrl=mm.thumbnailUrl;
        tmp.begin=mm.arrList.firstObject;
        tmp.end=mm.arrList.lastObject;
        
        BranchdetailCViewController *vc=[[BranchdetailCViewController alloc] initWithNibName:@"BranchdetailCViewController" bundle:nil];
        vc.hidesBottomBarWhenPushed=YES;
//        vc.model=tmp;
        vc.coupnId=tmp.couponId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    //优惠药品
    else if ([eventName isEqualToString:kCouponMedicineBubbleView]) {
        MessageModel *mm=[userInfo objectForKey:KMESSAGEKEY];
        WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
        WebDrugDetailModel *modelDrug = [[WebDrugDetailModel alloc] init];
        modelDrug.proDrugID = mm.UUID;
        modelDrug.promotionID = mm.otherID;
        
        WebDirectLocalModel *modelLocal = [[WebDirectLocalModel alloc] init];
        modelLocal.modelDrug = modelDrug;
        modelLocal.typeLocalWeb = WebLocalTypeCouponProduct;
        modelLocal.title = @"药品详情";
        [vcWebDirect setWVWithLocalModel:modelLocal];

        vcWebDirect.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vcWebDirect animated:YES];
    }
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
#pragma mark -
#pragma mark XHAudioPlayerHelperDelegate
- (void)didAudioPlayerBeginPlay:(AVAudioPlayer*)audioPlayer
{
    
}

- (void)didAudioPlayerStopPlay:(AVAudioPlayer*)audioPlayer
{
    if(playingMessageModel) {
        playingMessageModel.audioPlaying = NO;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[msgCenter getMessageIndex:playingMessageModel] inSection:0];
        ChatTableViewCell *cell = (ChatTableViewCell *)[self.tableMain cellForRowAtIndexPath:indexPath];
        [cell stopVoicePlay];
        playingMessageModel = nil;
    }
}

- (void)didAudioPlayerPausePlay:(AVAudioPlayer*)audioPlayer
{
    
}

//链接被点击
- (void)chatTextCellUrlPressed:(NSURL *)url
{
    if (url) {
        //        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)unLoadKeyboardBlock
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardDidHideNotification object:nil];
    self.tableMain.keyboardDidScrollToPoint = NULL;
    self.tableMain.keyboardWillSnapBackToPoint = NULL;
    self.tableMain.keyboardWillBeDismissed = NULL;
    self.tableMain.keyboardWillChange = NULL;
    self.tableMain.keyboardDidChange = NULL;
    self.tableMain.keyboardDidHide = NULL;
}

#pragma mark
#pragma mark 初始化工具
/**
 *  初始化消息界面布局
 */
- (void)initilzer
{
    // 初始化输入工具条
    [self layoutDifferentMessageType];
    // 设置手势滑动，默认添加一个bar的高度值
    self.tableMain.messageInputBarHeight = CGRectGetHeight(_messageInputView.bounds);
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
    XHMessageInputView *inputView = [[XHMessageInputView alloc] initWithFrame:inputFrame];
    inputView.allowsSendFace = allowsSendFace;
    inputView.allowsSendVoice = allowsSendVoice;
    inputView.allowsSendMultiMedia = allowsSendMultiMedia;
    inputView.delegate = self;
    return inputView;
}

#pragma mark
#pragma mark 初始化shareMenu 及回调方法
- (void)setUpSharedMenuItem
{
    // 添加第三方接入数据
    NSMutableArray *shareMenuItems = [NSMutableArray array];
    
//    NSArray *plugIcons = @[@"photo_image.png",@"take_photo_image.png",@"药店地址.png",@"icon_shopPreferential.png", @"icon_shopActivity.png",@"常用话术.png", @"im_icon_assistant.png"];
//    NSArray *plugTitle = @[@"图片",@"拍照",@"发送药店地址",@"本店优惠", @"本店活动",@"常用话术", @"医药助手"];
    
    NSArray *plugIcons = @[@"photo_image",@"take_photo_image",@"药店地址",@"常用话术", @"im_icon_assistant.png"];
    NSArray *plugTitle = @[@"图片",@"拍照",@"发送药店地址",@"常用话术", @"医药助手"];
    
    for (NSString *plugIcon in plugIcons) {
        XHShareMenuItem *shareMenuItem = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:plugIcon] title:[plugTitle objectAtIndex:[plugIcons indexOfObject:plugIcon]]];
        [shareMenuItems addObject:shareMenuItem];
    }
    self.shareMenuItems = shareMenuItems;
    [self.shareMenuView reloadData];
}

/**
 *  单例初始化shareMenuView
 */
- (XHShareMenuView *)shareMenuView {
    if (!_shareMenuView) {
        XHShareMenuView *shareMenuView = [[XHShareMenuView alloc] initWithFrame:CGRectMake(0, kViewHeight, CGRectGetWidth(self.view.bounds), kShareMenuHeight)];
        shareMenuView.delegate = self;
        shareMenuView.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
        shareMenuView.alpha = 0.0;
        shareMenuView.shareMenuItems = self.shareMenuItems;
        [self.view addSubview:shareMenuView];
        _shareMenuView = shareMenuView;
    }
//    [self.view bringSubviewToFront:_shareMenuView];
    return _shareMenuView;
}

#pragma mark 优惠券等弹出框
- (void)toSendNormalActivity:(QueryActivityInfo *)model{
    [[IMAlertActivity instance] showNormal:model block:^(int tag, id obj) {
        if (tag==1) {
            
            MessageModel *mm = [[MessageModel alloc] initMarketActivity:model.title sender:self.messageSender imageUrl:model.imgUrl content:model.content comment:@"" richBody:model.activityId timestamp:[NSDate date] UUID:[XMPPStream generateUUID]];
            
            
            //            MessageModel *mm = [[MessageModel alloc] initWithSpecialOffers:model.title
            //                                                                   content:model.content
            //                                                               activityUrl:model.imgUrl
            //                                                                activityId:model.activityId
            //                                                                   groupId:QWGLOBALMANAGER.configure.groupId
            //                                                                branchLogo:QWGLOBALMANAGER.configure.avatarUrl
            //                                                                    sender:self.messageSender timestamp:[NSDate date]
            //                                                                      UUID:[XMPPStream generateUUID]];
            [self sendMessage:mm messageBodyType:mm.messageMediaType];
            
            if ([obj isKindOfClass:[NSString class]]) {
                NSString *ss=obj;
                if(ss.length){ //如果有备注信息，则新发一个文本消息
                    MessageModel *replyTextMessageModel = [[MessageModel alloc] initWithText:ss
                                                                                      sender:self.messageSender
                                                                                   timestamp:[NSDate date]
                                                                                        UUID:[XMPPStream generateUUID]];
                    
                    replyTextMessageModel.sended = MessageDeliveryState_Delivering;
                    [msgCenter addMessage:replyTextMessageModel];
                    [self performSelector:@selector(sendMarketActivityTextMessageWithHTTP:) withObject:replyTextMessageModel afterDelay:2.0f];
                }
            }
        }
    }];
}


- (void)toSendActivity:(BranchNewPromotionModel *)model{
    if([model isKindOfClass:[QueryActivityInfo class]]) {
        [self toSendNormalActivity:model];
    }else{
        
        [[IMAlertActivity instance] show:model block:^(int tag, id obj) {
            DebugLog(@"%@",obj);
            if (tag==1) {
                MessageModel *mm = [[MessageModel alloc] initWithSpecialOffers:model.title
                                                                       content:model.desc
                                                                   activityUrl:model.imgUrl
                                                                    activityId:model.packPromotionId
                                                                       groupId:QWGLOBALMANAGER.configure.groupId
                                                                    branchLogo:QWGLOBALMANAGER.configure.avatarUrl
                                                                        sender:self.messageSender timestamp:[NSDate date]
                                                                          UUID:[XMPPStream generateUUID]];
                [self sendMessage:mm messageBodyType:mm.messageMediaType];
                
                if ([obj isKindOfClass:[NSString class]]) {
                    NSString *ss=obj;
                    if(ss.length){ //如果有备注信息，则新发一个文本消息
                        MessageModel *replyTextMessageModel = [[MessageModel alloc] initWithText:ss
                                                                                          sender:self.messageSender
                                                                                       timestamp:[NSDate date]
                                                                                            UUID:[XMPPStream generateUUID]];
                        
                        replyTextMessageModel.sended = MessageDeliveryState_Delivering;
                        [msgCenter addMessage:replyTextMessageModel];
                        [self performSelector:@selector(sendMarketActivityTextMessageWithHTTP:) withObject:replyTextMessageModel afterDelay:2.0f];
                    }
                }
                
            }
        }];
    }
    
}

- (void)toSendCoupon:(BranchCouponVo *)coupnModel{

    [[IMAlertCoupon instance]show:coupnModel block:^(int tag, id obj) {
        DebugLog(@"%i %@\n%@", tag,obj,coupnModel);
        if (tag==1) {
            MessageModel *mm = [[MessageModel alloc] initWithCoupon:coupnModel.groupId
                                                         couponName:coupnModel.groupName
                                                        couponValue:coupnModel.couponValue
                                                          couponTag:coupnModel.couponTag
                                                           couponId:coupnModel.couponId
                                                              begin:coupnModel.begin
                                                                end:coupnModel.end
                                                            scope:coupnModel.scope
                                                                top:coupnModel.top.intValue
                                                             imgUrl:coupnModel.giftImgUrl
                                                             sender:self.messageSender
                                                          timestamp:[NSDate date]
                                                               UUID:[XMPPStream generateUUID]];
            
            [self sendMessage:mm messageBodyType:mm.messageMediaType];
        }
    }];
}

- (void)toSendCouponMedicine:(DrugVo *)productModel{
//    [[IMAlertCouponMedicine instance] setMainView:self.view];
    [[IMAlertCouponMedicine instance] show:productModel block:^(int tag, id obj) {
        if (tag==1) {
            MessageModel *mm = [[MessageModel alloc] initWithMedicineCoupon:productModel.proName
                                                                  productId:productModel.proId
                                                                   imageUrl:productModel.imgUrl
                                                                   pmtLable:productModel.label
                                                                      pmtID:productModel.pid
                                                                     sender:self.messageSender
                                                                  timestamp:[NSDate date]
                                                                       UUID:[XMPPStream generateUUID]];
            [self sendMessage:mm messageBodyType:mm.messageMediaType];
        }
    }];
    
}
#pragma mark （action）点击“+”号键盘里地单个功能触发的事件
- (void)didSelecteShareMenuItem:(XHShareMenuItem *)shareMenuItem atIndex:(NSInteger)index {
    WEAKSELF
    switch (index) {
        case 0: {
            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
            if(author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) {
                [SVProgressHUD showErrorWithStatus:@"当前程序未开启相册使用权限" duration:0.8];
                return;
            }
            
            [self LocalPhoto];
            break;
        }
        case 1: {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
                [SVProgressHUD showErrorWithStatus:@"当前程序未开启相机使用权限" duration:0.8];
                return;
            }
            
            [self takePhoto];
            break;
        }
        case 2: {
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
                if(groupDetail.cityName) {
                    groupAddress = [NSString stringWithFormat:@"%@%@%@",groupDetail.cityName,groupDetail.countryName,groupAddress];
                }
                MessageModel *locationModel = [[MessageModel alloc] initWithLocation:groupAddress
                                                                            latitude:groupDetail.latitude
                                                                           longitude:groupDetail.longitude
                                                                              sender:self.messageSender
                                                                           timestamp:[NSDate date]
                                                                                UUID:[XMPPStream generateUUID]];
                [weakSelf sendMessage:locationModel messageBodyType:MessageMediaTypeLocalPosition];
            } failure:NULL];
            break;
        }
//        case 3: {
//            if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
//                [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试" duration:0.8f];
//                return;
//            }
//
//            //优惠
//            //cjyyx
//            StatisticsModel *sm = [StatisticsModel new];
//            sm.eventId = @"e_im_discount";
//            [QWCLICKEVENT qwTrackEventModel:sm];
//            
//            BranchViewController *vc = [BranchViewController new];
//            vc.isFromIM = @"1";
//            vc.SendNewBranch = ^(BranchCouponVo *coupnModel,DrugVo *productModel){
//                DebugLog(@"\n1: %@\n2: %@",coupnModel,productModel);
//                if (coupnModel) {
//                    [self performSelector:@selector(toSendCoupon:) withObject:coupnModel afterDelay:.35];
//                }
//                else if (productModel) {
//                    [self performSelector:@selector(toSendCouponMedicine:) withObject:productModel afterDelay:.35];
//                }
//            };
//
//            [self.navigationController pushViewController:vc animated:NO];
//            break;
//        }
//        case 4: {
//            if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
//                [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试" duration:0.8f];
//                return;
//            }
//            //优惠＋海报
//            
//            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"优惠活动",@"门店海报", nil];
//            sheet.tag = 1009;
//            [sheet showInView:self.view];
//            
//            break;
//        }
        case 3:
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
        case 4: {
            
            if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
                [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试" duration:DURATION_SHORT];
                return;
            }
            
            [QWGLOBALMANAGER statisticsEventId:@"咨询详情_医药助手" withLable:@"咨询" withParams:nil];
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"药事知识库",@"健康问答库",@"快捷发送(药品)", nil];
            sheet.tag = 1002;
            [sheet showInView:self.view];
            break;
        }
        default:
            break;
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

- (void)leveyPopListView:(LeveyPopListView *)popListView didSelectedIndex:(NSInteger)anIndex
{
    if(popListView.tag == 1001) {
//        NSDictionary *dict = self.marketList[anIndex];
//        [self showPopMarkActivityDetail:[NSMutableDictionary dictionaryWithDictionary:dict]];
    }else if (popListView.tag == 1002) {
        NSString *content = self.CommonWords[anIndex];
        self.messageInputView.inputTextView.text = content;
        [self.messageInputView.inputTextView becomeFirstResponder];
        self.textViewInputViewType = XHInputViewTypeText;
        //[self inputTextViewWillBeginEditing:self.messageInputView.inputTextView];
    }
}

- (void)didSendMarketActivityWithDict:(NSDictionary *)dict
{
    //营销活动分开。没有type的区分
    if(self.popupMarketActivityView.enum_type==Enum_Items_Coupn){
        MessageModel *popupMarketModel = [[MessageModel alloc] initWithSpecialOffers:dict[@"title"]
                                                                             content:dict[@"desc"]
                                                                         activityUrl:dict[@"imgUrl"]
                                                                          activityId:dict[@"id"]
                                                                             groupId:QWGLOBALMANAGER.configure.groupId
                                                                          branchLogo:QWGLOBALMANAGER.configure.avatarUrl
                                                                              sender:self.messageSender timestamp:[NSDate date]
                                                                                UUID:[XMPPStream generateUUID]];
        [self sendMessage:popupMarketModel messageBodyType:MessageMediaTypeMedicineSpecialOffers];
        NSString *replyText = [QWGLOBALMANAGER removeSpace:dict[@"replyText"]];
        if(!StrIsEmpty(replyText)){ //如果有备注信息，则新发一个文本消息
            MessageModel *replyTextMessageModel = [[MessageModel alloc] initWithText:replyText
                                                                              sender:self.messageSender
                                                                           timestamp:[NSDate date]
                                                                                UUID:[XMPPStream generateUUID]];
            
            replyTextMessageModel.sended = MessageDeliveryState_Delivering;
            [msgCenter addMessage:replyTextMessageModel];
            [self performSelector:@selector(sendMarketActivityTextMessageWithHTTP:) withObject:replyTextMessageModel afterDelay:2.0f];
        }
        
    }else if(self.popupMarketActivityView.enum_type==Enum_Items_Activity){
        MessageModel *marketModel = [[MessageModel alloc] initMarketActivity:dict[@"title"]
                                                                      sender:self.messageSender
                                                                    imageUrl:dict[@"imgUrl"]
                                                                     content:dict[@"content"]
                                                                     comment:dict[@"replyText"]
                                                                    richBody:dict[@"activityId"]
                                                                   timestamp:[NSDate date]
                                                                        UUID:[XMPPStream generateUUID]];
        [self sendMessage:marketModel messageBodyType:MessageMediaTypeActivity];
        
        
        NSString *replyText = [QWGLOBALMANAGER removeSpace:dict[@"replyText"]];
        if(!StrIsEmpty(replyText)){ //如果有备注信息，则新发一个文本消息
            MessageModel *replyTextMessageModel = [[MessageModel alloc] initWithText:replyText
                                                                              sender:self.messageSender
                                                                           timestamp:[NSDate date]
                                                                                UUID:[XMPPStream generateUUID]];
            replyTextMessageModel.sended = MessageDeliveryState_Delivering;
            [msgCenter addMessage:replyTextMessageModel];
            
            [self performSelector:@selector(sendMarketActivityTextMessageWithHTTP:) withObject:replyTextMessageModel afterDelay:2.0f];
        }
    }
}
//发送营销活动时，如果有备注，则新发一个备注文本消息

- (void)sendMarketActivityTextMessageWithHTTP:(MessageModel *)model
{
    [msgCenter sendMessageWithoutMessageQueue:model success:^(id successObj) {
        [self messageToPharMsg:model send:MessageDeliveryState_Delivered ];
        [self.tableMain reloadData];
    } failure:^(id failureObj) {
        [self.tableMain reloadData];
        [self messageToPharMsg:model send:MessageDeliveryState_Failure ];
    }];
}

#pragma mark
#pragma mark 初始化表情emotionManagerView
- (XHEmotionManagerView *)emotionManagerView {
    if (!_emotionManagerView) {
        XHEmotionManagerView *emotionManagerView = [[XHEmotionManagerView alloc] initWithFrame:CGRectMake(0, kViewHeight, CGRectGetWidth(self.view.bounds), kEmojiKeyboardHeight)];
        emotionManagerView.delegate = self;
        emotionManagerView.dataSource = self;
        emotionManagerView.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
        emotionManagerView.alpha = 0.0;
        [self.view addSubview:emotionManagerView];
        [emotionManagerView.emotionSectionBar.storeManagerItemButton addTarget:self action:@selector(didSendEmojiTextMessage:) forControlEvents:UIControlEventTouchDown];
        _emotionManagerView.userInteractionEnabled = YES;
        _emotionManagerView = emotionManagerView;
        
    }
    [self.view bringSubviewToFront:_emotionManagerView];
    return _emotionManagerView;
}
/**
 *  初始化表情manager,最好能做成异步(暂时不处理)
 */
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

- (XHEmotionManager *)addDeleteItem
{
    XHEmotionManager *subEmotion = [[XHEmotionManager alloc] init];
    subEmotion.emotionName = @"删除";
    subEmotion.imageName = @"backFaceSelect";
    return subEmotion;
}

- (void)didChangeSendVoiceAction:(BOOL)changed
{
    DebugLog(@"%s",__FUNCTION__);
    [self scrollToBottomAnimated:YES];
    if (changed) {
        self.textViewInputViewType = XHInputViewTypeVoice;
        [self layoutOtherMenuViewHide:NO fromInputView:NO];
        [self scrollToBottomAnimated:YES];
    } else {
        [self.messageInputView.inputTextView becomeFirstResponder];
    }
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

#pragma mark - Voice Recording Helper Method

- (NSString *)getRecorderPath {
    NSString *recorderPath = nil;
    recorderPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    recorderPath = [recorderPath stringByAppendingFormat:@"%@-MySound.caf", [dateFormatter stringFromDate:now]];
    return recorderPath;
}

#pragma mark - XHVoiceRecordHUD Helper Method

#pragma mark - Voice Recording Helper Method

- (void)prepareRecordWithCompletion:(XHPrepareRecorderCompletion)completion {
    [self.voiceRecordHelper prepareRecordingWithPath:[self getRecorderPath] prepareRecorderCompletion:completion];
}

- (void)startRecord {
    [self.voiceRecordHUD startRecordingHUDAtView:self.view];
    [self.voiceRecordHelper startRecordingWithStartRecorderCompletion:^{
        if(playingMessageModel) {
            playingMessageModel.audioPlaying = NO;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[msgCenter getMessageIndex:playingMessageModel] inSection:0];
            ChatTableViewCell *cell = (ChatTableViewCell *)[self.tableMain cellForRowAtIndexPath:indexPath];
            [cell stopVoicePlay];
            [[XHAudioPlayerHelper shareInstance] stopAudio];
            playingMessageModel = nil;
            
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
        NSString *audioPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat: @"Documents/%@/Voice/%@.amr",QWGLOBALMANAGER.configure.userName,UUID]];
        [amrData writeToFile:audioPath atomically:YES];
        NSFileManager *manager = [NSFileManager defaultManager];
        [manager removeItemAtPath:weakSelf.voiceRecordHelper.recordPath error:nil];
        [self didSendAudio:@"[语音]" voicePath:audioPath audioUrl:nil duartion:weakSelf.voiceRecordHelper.recordDuration fromSender:self.messageSender onDate:[NSDate date] UUID:UUID];
        
    }];
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
    [self sendMessage:messageModel messageBodyType:MessageMediaTypeVoice];
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


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == alertResendIdentifier) {
        if (buttonIndex == 0) {
            
        } else if (buttonIndex == 1) {
            // 重发
            if (self.dicNeedResend) {
                MessageModel *model=[self.dicNeedResend objectForKey:@"kShouldResendModel"];
                switch (model.messageMediaType) {

                    case MessageMediaTypePhoto:
                    {
                        [msgCenter resendFileMessage:model success:^(id successObj) {
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[msgCenter getMessageIndex:model] inSection:0];
                            ChatOutgoingTableViewCell *cell = (ChatOutgoingTableViewCell *)[self.tableMain cellForRowAtIndexPath:indexPath];
                            ((PhotoChatBubbleView *)cell.bubbleView).dpMeterView.activeShow.hidden = YES;
                            ((PhotoChatBubbleView *)cell.bubbleView).dpMeterView.hidden = YES;
                            ((PhotoChatBubbleView *)cell.bubbleView).dpMeterView.progressLabel.text = [NSString stringWithFormat:@"%d%@",0,@"%"];
                            [self messageToPharMsg:model send:MessageDeliveryState_Delivered];
                            [self.tableMain reloadData];

                        } failure:^(id failureObj) {
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[msgCenter getMessageIndex:model] inSection:0];
                            ChatOutgoingTableViewCell *cell = (ChatOutgoingTableViewCell *)[self.tableMain cellForRowAtIndexPath:indexPath];
                            
                            ((PhotoChatBubbleView *)cell.bubbleView).dpMeterView.activeShow.hidden = YES;
                            ((PhotoChatBubbleView *)cell.bubbleView).dpMeterView.hidden = YES;
                            ((PhotoChatBubbleView *)cell.bubbleView).dpMeterView.progressLabel.text = [NSString stringWithFormat:@"%d%@",0,@"%"];
                            [self.tableMain reloadData];
                            [self messageToPharMsg:model  send:MessageDeliveryState_Failure];
                        } uploadProgressBlock:^(MessageModel *target, float progress) {
                            
                            [self progressUpdate:model.UUID progress:progress];
                            
                        }];
 
                    }
                        break;
                    case MessageMediaTypeVoice:
                    {
                        [msgCenter resendFileMessage:model success:^(id successObj) {
                            [self messageToPharMsg:model send:MessageDeliveryState_Delivered];
                            [self.tableMain reloadData];
                        } failure:^(id failureObj) {
                            [self messageToPharMsg:model send:MessageDeliveryState_Failure];
                            [self.tableMain reloadData];
                        } uploadProgressBlock:NULL];
                    }
                        break;
                    default:{
                        
                        [msgCenter resendMessage:model success:^(id successObj) {
                            [self messageToPharMsg:model send:MessageDeliveryState_Delivered];
                            [self.tableMain reloadData];
                        } failure:^(id failureObj) {
                            [self messageToPharMsg:model send:MessageDeliveryState_Failure];
                            [self.tableMain reloadData];
                        }];
                        
                    }
                        break;
                }
            }
        }
    } else if (alertView.tag == alertDeleteIdentifier) {
        if (buttonIndex == 1) {
            // 删除
            if (self.dicNeedDelete) {
                MessageModel *model=[self.dicNeedDelete objectForKey:@"kShouldDeleteModel"];
                [msgCenter removeMessage:model success:^(id successObj) {
                    //
                } failure:^(id failureObj) {
                    //
                }];
            }
        }
    }
}

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
        
        self.tableMain.keyboardDidScrollToPoint = ^(CGPoint point) {
            if (weakSelf.textViewInputViewType == XHInputViewTypeText)
                AnimationForMessageInputViewAtPoint(point);
        };
        
        self.tableMain.keyboardWillSnapBackToPoint = ^(CGPoint point) {
            if (weakSelf.textViewInputViewType == XHInputViewTypeText)
                AnimationForMessageInputViewAtPoint(point);
        };
        
        self.tableMain.keyboardWillBeDismissed = ^() {
            CGRect inputViewFrame = weakSelf.messageInputView.frame;
            inputViewFrame.origin.y = weakSelf.view.bounds.size.height - inputViewFrame.size.height;
            weakSelf.messageInputView.frame = inputViewFrame;
        };
    }
    
    // block回调键盘通知
    self.tableMain.keyboardWillChange = ^(CGRect keyboardRect, UIViewAnimationOptions options, double duration, BOOL showKeyborad) {
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
    
    self.tableMain.keyboardDidChange = ^(BOOL didShowed) {
        if ([weakSelf.messageInputView.inputTextView isFirstResponder]) {
            if (didShowed) {
                if (weakSelf.textViewInputViewType == XHInputViewTypeText) {
                    weakSelf.shareMenuView.alpha = 0.0;
                    weakSelf.emotionManagerView.alpha = 0.0;
                }
            }
        }
    };
    
    self.tableMain.keyboardDidHide = ^() {
        [weakSelf.messageInputView.inputTextView resignFirstResponder];
    };
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
                             [self setTableViewInsetsWithBottomValue:self.tableMain.contentInset.bottom + changeInHeight];
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

#pragma mark - XHMessageInputView Delegate
- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView
{
    self.textViewInputViewType = XHInputViewTypeText;
}

- (void)inputTextViewDidBeginEditing:(XHMessageTextView *)messageInputTextView
{
    
}
//获取textView的高度
- (CGFloat)getTextViewContentH:(UITextView *)textView {
    if (iOSv7) {
//        return ceilf([textView sizeThatFits:textView.frame.size].height);
        CGRect textFrame=[[textView layoutManager] usedRectForTextContainer:[textView textContainer]];
        return textFrame.size.height - 18;
    } else {
        return textView.contentSize.height;
    }
}


#pragma mark
#pragma mark 点击返回
- (IBAction)popVCAction:(id)sender
{
    if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
        if (self.navigationController.viewControllers.count>1)
            [self.navigationController popViewControllerAnimated:NO];
        else if ([self.navigationController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
            [self.navigationController dismissViewControllerAnimated:NO completion:^{
                //
            }];
        }
        
    }
    
//    [super popVCAction:sender];
    [msgCenter deleteMessagesByType:MessageMediaTypeMedicineShowOnce];
    [msgCenter deleteMessagesByType:MessageMediaTypeMedicineSpecialOffersShowOnce];
    [msgCenter stop];
    
}

-(void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    if (type == NotimessageIMTabelUpdate) {
        if (self.didScrollOrReload) {
            [self.tableMain reloadData];
        }else
        {
            self.didScrollOrLoad = YES;
        }//        MessageModel  *model =  data;
//        model = [msgCenter getMessageWithUUID:model.UUID];
//        NSInteger index = [msgCenter getMessageIndex:model];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
// 
//            if (indexPath) {
////                 dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableMain beginUpdates];
//                [self.tableMain reloadRowsAtIndexPaths:@[indexPath]
//                                      withRowAnimation:UITableViewRowAnimationNone];
//                [self.tableMain endUpdates];
//           
////                });
//         }
    }
    else if (type == NotifAppDidEnterBackground) {
        [self stopMusicInOtherBubblePressed];
        if(self.voiceRecordHelper.recorder.isRecording) {
            WEAKSELF
            [self.voiceRecordHUD stopRecordCompled:^(BOOL fnished) {
                weakSelf.voiceRecordHUD = nil;
            }];
            [self.voiceRecordHelper stopRecordingWithStopRecorderCompletion:^{
                
            }];
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}

#pragma mark - XHEmotionManagerView DataSource

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

@end
