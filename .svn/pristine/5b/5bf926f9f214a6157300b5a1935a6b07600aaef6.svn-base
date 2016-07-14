//
//  QWYSViewController.m
//  wenYao-store
//
//  Created by YYX on 15/8/11.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWYSViewController.h"

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
//#import "XHShareMenuView.h"
#import "XHMessageInputView.h"
#import "XHEmotionManager.h"
#import "XHEmotionManagerView.h"
#import "ChatManagerDefs.h"
#import "ChatBubbleViewHeader.h"


//cell
#import "ChatTableViewCell.h"
#import "ChatOutgoingTableViewCell.h"

//第三方数据类
//#import "XHMessage.h"
#import "XMPPStream.h"
#import "SVProgressHUD.h"
#import "SBJson.h"
//#import "PopupMarketActivityView.h"
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
#import "XPMessageCenter.h"

#import "MessageModel.h"
#import "ChatIncomeTableViewCell.h"
#import "ChatOutgoingTableViewCell.h"
#import "SJAvatarBrowser.h"
#import "Consult.h"

#import "testFrame.h"
#import "CouponModel.h"
#import "Store.h"
#import "IMApi.h"
#import "OrderModel.h"
#import "CouponModel.h"

#import "PhotoChatBubbleView.h"
//语音
#import "XHVoiceRecordHUD.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "XHAudioPlayerHelper.h"
#import "VoiceChatBubbleView.h"
#import "XHVoiceRecordHelper.h"
#import "Customer.h"
#import "CustomerModelR.h"
#import "MyCustomerBaseModel.h"
#import "ClientInfoViewController.h"
#import "XHMessage+Helper.h"
#import "IntroduceQwysViewController.h"

BOOL const QWYSXPallowsSendFace = YES;
BOOL const QWYSXPallowsSendVoice = YES;
BOOL const QWYSXPallowsSendMultiMedia = YES;
BOOL const QWYSXPallowsPanToDismissKeyboard = NO;//是否允许手势关闭键盘，默认是允许
const int QWYSXPalertResendIdentifier = 10000;
const int QWYSXPalertDeleteIdentifier = 10001;

#define kOffSet        45  //tableView偏移量
#define kInputViewHeight   45  //输入框的高度
#define kEmojiKeyboardHeight 216 //表情键盘的高度
#define kShareMenuHeight    95*2 //shareMenu键盘的高度
//self.view的高度  因为点击发送药品时，self.view的高度含导航栏，特此区别
#define kViewHeight  [UIScreen mainScreen].bounds.size.height - NAV_H - STATUS_H

@interface QWYSViewController ()<LeveyPopListViewDelegate,XHMessageInputViewDelegate,XHEmotionManagerViewDataSource,XHEmotionManagerViewDelegate,UITableViewDataSource,UITableViewDelegate,DFMultiPhotoSelectorViewControllerDelegate,UINavigationControllerDelegate,MLEmojiLabelDelegate, UIImagePickerControllerDelegate,UIAlertViewDelegate,XHAudioPlayerHelperDelegate,UIActionSheetDelegate>

{
    UIImage * willsendimg;
    XPMessageCenter *msgCenter;
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
    
    BOOL isDisappear;   // 当前页面是否正常消失
}
//@property (nonatomic, weak, readwrite) XHShareMenuView *shareMenuView;
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


@property (nonatomic ,assign)BOOL  didScrollOrReload;

@property (nonatomic ,assign)BOOL  didScrollOrLoad;
/**
 *  用来记录需要删除的字典对象
 */
@property (nonatomic, strong) NSDictionary *dicNeedDelete;

@property (nonatomic, assign) XHInputViewType textViewInputViewType;

//@property (nonatomic, strong) PopupMarketActivityView *popupMarketActivityView;
@property (nonatomic, strong) NSMutableArray *arrNeedAdded;
@property (nonatomic, assign) CGPoint rectHistory;
@property (nonatomic, strong) UIView            *timeoutBottomView;

/**
 *  数据源，显示多少消息
 */
@property (nonatomic, strong) NSMutableArray *messages;

/**
 *  动态改变TextView的高度
 *
 *  @param textView 被改变的textView对象
 */
- (void)layoutAndAnimateMessageInputTextView:(UITextView *)textView;

@end


@implementation QWYSViewController

@synthesize emotionManagerView = _emotionManagerView;

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
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self refreshingRecentMessage];
    
//    self.consultingModel.unreadCounts = @"0";
//    [ConsultConsultingModel updateObjToDB:self.consultingModel WithKey:[NSString stringWithFormat:@"%@",self.consultingModel.consultId]];
    
    [self scrollToBottomAnimated:NO];
    
    //报告未读数
    [QWGLOBALMANAGER updateUnreadCount];
    self.constraintTableFoot.constant = 45.0f;
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
    
    isDisappear = NO;
    [self.tableMain setupPanGestureControlKeyboardHide:allowsPanToDismissKeyboard];
    // KVO 检查contentSize
    [self.messageInputView.inputTextView addObserver:self
                                          forKeyPath:@"contentSize"
                                             options:NSKeyValueObservingOptionNew
                                             context:nil];
    
    //不要删注释
    if (self.emotionManagerView.alpha == 1) {
        //        [self layoutOtherMenuViewHiden:NO];
    }else{
        // 设置键盘通知或者手势控制键盘消失
        self.tableMain.contentInset = UIEdgeInsetsMake(0, 0, 0, 0); //UIEdgeInsets( top: t, left: l, bottom: b, right: r)
        self.tableMain.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0); //UIEdgeInsets( top: t, left: l, bottom: b, right: r)
    }
    [self initKeyboardBlock];
    [msgCenter restart];
    ((QWBaseNavigationController *)self.navigationController).canDragBack = NO;
    self.constraintTableFoot.constant = -5.0f;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dicNeedDelete = @{};
    self.dicNeedResend = @{};
    self.arrNeedAdded = [@[] mutableCopy];
    self.CommonWords = [NSMutableArray arrayWithCapacity:15];
    
    self.messages = [NSMutableArray array];
    
    self.title = @"全维药事";

    self.tableMain.footerHidden = YES;
    
//    self.popupMarketActivityView = [[[NSBundle mainBundle] loadNibNamed:@"PopupMarketActivityView" owner:self options:nil] objectAtIndex:0];
//    
//    self.popupMarketActivityView.delegate = self;

    [self enableSimpleRefresh:self.tableMain block:^(SRRefreshView *sender) {
        [self headerRereshing];
    }];
    [self headerRereshing];
    [self initilzer];
//    [self setUpSharedMenuItem];
    [self setUpEmojiManager];
//    [self messageCenterInit];
    
    [self layoutDifferentMessageType];
    
    self.didScrollOrReload = YES;
    self.didScrollOrLoad = NO;
    self.tableMain.hidden = YES;
    self.messageInputView.userInteractionEnabled = YES;
//    [self checkCertVaildate];
    
    self.messages = [self queryOfficialDataBaseCache];
    self.tableMain.hidden = NO;
    [self.tableMain reloadData];
    
    [self setOfficialMessagesRead];
}

-(void)setOfficialMessagesRead
{
    //设已读
    [OfficialMessages updateSetToDB:@"issend = '2'" WithWhere:nil];
    
    [QWGLOBALMANAGER checkMessage];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    isDisappear = YES;
    // 取消输入框
    [self unLoadKeyboardBlock];
    [self.messageInputView.inputTextView resignFirstResponder];
    [self setEditing:NO animated:YES];
    
    // remove键盘通知或者手势
    [self.tableMain disSetupPanGestureControlKeyboardHide:NO];
    
    // remove KVO
    [self.messageInputView.inputTextView removeObserver:self forKeyPath:@"contentSize"];
    ((QWBaseNavigationController *)self.navigationController).canDragBack = YES;
    if(self.showType == MessageShowTypeClose){
        [QWCLICKEVENT qwTrackPageEnd:@"QWYSViewController_ygb"];
    }else if (self.showType == MessageShowTypeAsking) {
        [QWCLICKEVENT qwTrackPageEnd:@"QWYSViewController_dqd"];
    }else if (self.showType == MessageShowTypeAnswer) {
        [QWCLICKEVENT qwTrackPageEnd:@"QWYSViewController_jdz"];
    }
    if(playingMessageModel) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[msgCenter getMessageIndex:playingMessageModel] inSection:0];
        ChatTableViewCell *cell = (ChatTableViewCell *)[self.tableMain cellForRowAtIndexPath:indexPath];
        [cell stopVoicePlay];
        [[XHAudioPlayerHelper shareInstance] stopAudio];
        playingMessageModel = nil;
    }
    [[XHAudioPlayerHelper shareInstance] setDelegate:nil];
}



- (void)headerRereshing
{
//    //测试翻页历史数据
//    self.rectHistory = self.tableMain.contentOffset;
//    [self getHistory];
//    [self.tableMain headerEndRefreshing];
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"endpoint"] = @"2";
    setting[@"token"] = QWGLOBALMANAGER.configure.userToken;
    setting[@"viewType"] = @"-1";
    setting[@"view"] = @"15";
    if(self.messages.count == 0) {
        setting[@"point"] = [NSString stringWithFormat:@"%0.f",[[NSDate date] timeIntervalSince1970] * 1000];
    }else{
        MessageModel *message = self.messages[0];
        setting[@"point"] = [NSString stringWithFormat:@"%.0f",[message.timestamp timeIntervalSince1970] * 1000.0f];
    }
    setting[@"to"] = @"";
    setting[@"cl"] = @"3";
    [IMApi selectIMQwWithParams:setting
                        success:^(id obj){
                            if (obj) {
                                NSArray *array = obj[@"records"];
                                if([array isKindOfClass:[NSString class]])
                                {
                                    return;
                                }
                                [self.messages addObjectsFromArray:array];
                                [self headerRefreshingMessage:array messages:self.messages];
                                
                                self.messages = [self queryOfficialDataBaseCache];
//                                [self sortMessages];
                                [self.tableMain reloadData];
                            }
                        }
                        failure:^(HttpException *e){
                        }];
    
    
    
}

- (void)headerRefreshingMessage:(NSArray *)array
                       messages:(NSMutableArray *)messages
{
    for(NSDictionary *dict in array)
    {
        NSDictionary *info = dict[@"info"];
        NSString *content = info[@"content"];
        NSString *fromId = info[@"fromId"];
        NSString *toId = info[@"toId"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        double timeStamp = [[formatter dateFromString:info[@"time"]] timeIntervalSince1970];
        NSDate *date = [formatter dateFromString:info[@"time"]];
        NSString *UUID = info[@"id"];
        NSUInteger fromTag = [info[@"fromTag"] integerValue];
        NSUInteger toTag = [info[@"toTag"] integerValue];
        NSUInteger msgType = [info[@"source"] integerValue];
        if(msgType == 0)
            msgType = 1;
        NSString *fromName = info[@"fromName"];
        MessageDeliveryType direction;
        if(fromTag==2)
        {
            direction = MessageTypeSending;
        }else{
            direction = MessageTypeReceiving;
        }
        
        for(NSDictionary *tag in info[@"tags"])
        {
            TagWithMessage* tagTemp = [[TagWithMessage alloc] init];
            
            tagTemp.length = tag[@"length"];
            tagTemp.start = tag[@"start"];
            tagTemp.tagType = tag[@"tag"];
            tagTemp.tagId = tag[@"tagId"];
            tagTemp.title = tag[@"title"];
            tagTemp.UUID = UUID;
            [TagWithMessage updateObjToDB:tagTemp WithKey:UUID];
        }
        
        NSString *where = [NSString stringWithFormat:@"UUID = '%@'",UUID];
        NSArray *tagList = [TagWithMessage getArrayFromDBWithWhere:where];
        OfficialMessages * omsg = [OfficialMessages getObjFromDBWithKey:UUID];
        if (omsg) {
            return;
        }
        TagWithMessage * tag = nil;
        if (tagList.count>0) {
            tag = tagList[0];
        }
        
        OfficialMessages * msg =  [[OfficialMessages alloc] init];
        msg.fromId = fromId;
        msg.toId = toId;
        msg.timestamp = [NSString stringWithFormat:@"%f",timeStamp];
        msg.body = content;
        msg.direction = [NSString stringWithFormat:@"%.0ld",(long)direction];
        msg.messagetype = [NSString stringWithFormat:@"%lu",(unsigned long)msgType];
        msg.UUID = UUID;
        msg.issend = @"2";
        msg.fromTag = fromTag ;
        msg.title = fromName;
        msg.relatedid = fromId;///此处是不是有问题
        msg.subTitle = tag.title;
        [OfficialMessages saveObjToDB:msg];
        //            }
        MessageModel *message = nil;
        switch (msgType)
        {
            case XHBubbleMessageMediaTypeText:
            {
                message = [[MessageModel alloc] initWithText:content sender:fromId timestamp:date UUID:UUID];
                break;
            }
            case XHBubbleMessageMediaTypeAutoSubscription:
            {
                
//                message = [[XHMessage alloc] initWithAutoSubscription:content sender:fromId timestamp:date UUID:UUID tagList:tagList];
                
                break;
            }
            case XHBubbleMessageMediaTypeDrugGuide:
            { TagWithMessage * tag = tagList[0];
                
//                message = [[XHMessage alloc] initWithDrugGuide:content title:fromName sender:fromId timestamp:date UUID:UUID tagList:tagList subTitle:tag.title fromTag:fromTag];
                break;
            }
            case XHBubbleMessageMediaTypePurchaseMedicine:
            {
                
                TagWithMessage * tag = tagList[0];
                
//                message = [[XHMessage alloc]initWithPurchaseMedicine:content sender:fromId timestamp:date UUID:UUID tagList:tagList title:fromName subTitle:tag.title fromTag:fromTag];
                break;
            }
                
            default:
                
                break;
        }
        if (! direction ==1 ) {
            message.avator = [UIImage imageNamed:@"药店默认头像"];
            message.avatorUrl = QWGLOBALMANAGER.configure.avatarUrl;
        }else
        {
            message.avator = [UIImage imageNamed:@"全维药事icon.png"];
            
        }
        message.messageDeliveryType = direction;
        message.officialType = YES;
        if(message)
            [messages addObject:message];
    }

}

- (void)dealloc{
    self.emotionManagers = nil;
    
    if (!isDisappear) {
        // remove KVO
        [self.messageInputView.inputTextView removeObserver:self forKeyPath:@"contentSize"];
    }
}

#pragma mark
#pragma mark 获取数据源

- (void)refreshingRecentMessage
{
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"endpoint"] = @"2";
    setting[@"token"] = QWGLOBALMANAGER.configure.userToken;
    setting[@"viewType"] = @"1";
    setting[@"view"] = @"100";
    setting[@"cl"] = @"5";
    setting[@"to"] = @"";
    [IMApi selectIMQwWithParams:setting
                        success:^(id obj){
                            if (obj) {
                                NSArray *array = obj[@"records"];
                                if([array isKindOfClass:[NSString class]])
                                {
                                    return;
                                }
                                if (array.count==0) {
                                    return;
                                }
                                if(self.messages.count > 1 && array.count > 0)
                                {
                                    XHMessage *lastMessage = [self.messages lastObject];
                                    NSString *UUID = [array lastObject][@"info"][@"id"];
                                    if([lastMessage.UUID isEqualToString:UUID])
                                        return;
                                    double lastTimeStamp = [lastMessage.timestamp timeIntervalSince1970];
                                    if((lastTimeStamp * 1000) >= [[array lastObject][@"info"][@"time"] doubleValue]) {
                                        return;
                                    }
                                }
                                if(array.count >= 15)
                                {
                                    [self.messages removeAllObjects];
                                    [OfficialMessages deleteAllObjFromDB];
                                }
                                
                                [self refreshingRecentMessage:array];
                                
                                self.messages = [self queryOfficialDataBaseCache];
//                                [self sortMessages];
                                [self.tableMain reloadData];
                                [self scrollToBottomAnimated:YES];
                            }
                        }
                        failure:^(HttpException *e){
                        }];

}

- (void)refreshingRecentMessage:(NSArray *)array
{
    for(NSDictionary *dict in array)
    {
        NSDictionary *info = dict[@"info"];
        NSString *content = info[@"content"];
        NSString *fromId = info[@"fromId"];
        NSString *toId = info[@"toId"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        double timeStamp = [[formatter dateFromString:info[@"time"]] timeIntervalSince1970];
        NSDate *date = [formatter dateFromString:info[@"time"]];
        NSString *UUID = info[@"id"];
        NSUInteger fromTag = [info[@"fromTag"] integerValue];
        NSUInteger toTag = [info[@"toTag"] integerValue];
        NSUInteger msgType = [info[@"source"] integerValue];
        NSString *fromName = info[@"fromName"];
        if(msgType == 0)
            msgType = 1;
        NSString *where = [NSString stringWithFormat:@"UUID = '%@'",UUID];
        NSArray *tagList = [TagWithMessage getArrayFromDBWithWhere:where];
        MessageDeliveryType direction;
        if([QWGLOBALMANAGER.configure.passportId isEqualToString:fromId])
        {
            direction = MessageTypeSending;
        }else{
            direction = MessageTypeReceiving;
        }
        
        for(NSDictionary *tag in info[@"tags"])
        {
            TagWithMessage* tagTemp = [[TagWithMessage alloc] init];
            
            tagTemp.length = tag[@"length"];
            tagTemp.start = tag[@"start"];
            tagTemp.tagType = tag[@"tag"];
            tagTemp.tagId = tag[@"tagId"];
            tagTemp.title = tag[@"title"];
            tagTemp.UUID = UUID;
            [TagWithMessage updateObjToDB:tagTemp WithKey:UUID];
        }
        
        OfficialMessages * omsg = [OfficialMessages getObjFromDBWithKey:UUID];
        if (omsg) {
            return;
        }
        
        TagWithMessage * tag = nil;
        if (tagList.count>0) {
            tag = tagList[0];
        }
        OfficialMessages * msg =  [[OfficialMessages alloc] init];
        msg.fromId = fromId;
        msg.toId = toId;
        msg.timestamp = [NSString stringWithFormat:@"%f",timeStamp];
        msg.body = content;
        msg.direction = [NSString stringWithFormat:@"%.0ld",(long)XHBubbleMessageTypeReceiving];
        msg.messagetype = [NSString stringWithFormat:@"%lu",(unsigned long)msgType];
        msg.UUID = UUID;
//        msg.issend = @"1";
        msg.fromTag = fromTag ;
        msg.title = fromName;
        msg.relatedid = fromId;///此处是不是有问题
        msg.subTitle = tag.title;
        [OfficialMessages saveObjToDB:msg];
    }
}

- (NSMutableArray *)queryOfficialDataBaseCache
{
    NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:10];
    
    NSArray *array =  [OfficialMessages getArrayFromDBWithWhere:nil WithorderBy:@"timestamp asc"];
    for (OfficialMessages *msg in array) {
        MessageModel *message = nil;
        double time = [msg.timestamp doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
        NSString *where = [NSString stringWithFormat:@"UUID = '%@'",msg.UUID];
        NSArray *tagList = [TagWithMessage getArrayFromDBWithWhere:where];
        
        switch ([msg.messagetype intValue])
        {
            case XHBubbleMessageMediaTypeAutoSubscription:
            {
//                message = [[XHMessage alloc] initWithAutoSubscription:msg.body sender:@"" timestamp:date UUID:msg.UUID tagList:tagList];
                break;
            }
            case XHBubbleMessageMediaTypeDrugGuide:
            {
//                TagWithMessage *tag = tagList[0];
//                message = [[XHMessage alloc] initWithDrugGuide:msg.body title:msg.title sender:@"" timestamp:date UUID:msg.UUID tagList:tagList subTitle:tag.title fromTag:msg.fromTag];
                break;
            }
            case XHBubbleMessageMediaTypePurchaseMedicine:
            {
//                TagWithMessage * tag = tagList[0];
//                
//                message = [[XHMessage alloc]initWithPurchaseMedicine:msg.body sender:@"" timestamp:date UUID:msg.UUID tagList:tagList title:msg.title subTitle:tag.title fromTag:msg.fromTag];
            }
            case MessageMediaTypeText:
            {
                message = [[MessageModel alloc] initWithText:msg.body sender:@"" timestamp:date UUID:msg.UUID];
                
                break;
            }
        }
        
//        if ([msg.issend integerValue] == 3) {
//            message.sended = MessageDeliveryState_Failure;
//        }
        
        message.sended = [msg.issend integerValue];
        
        if (![msg.direction isEqualToString:@"1"]) {
            message.avator = [UIImage imageNamed:@"药店默认头像"];
            message.avatorUrl = QWGLOBALMANAGER.configure.avatarUrl;
        }else
        {
            message.avator = [UIImage imageNamed:@"全维药事icon.png"];
            
        }
        
        message.officialType = YES;
        message.messageDeliveryType = [msg.direction integerValue];
        if(message)
            [retArray addObject:message];
    }
    
//    if(retArray.count == 0 && self.messages.count == 0)
//    {
//        MessageModel *welcomeMessage = [[MessageModel alloc] initWithText:WELCOME_MESSAGE sender:@"" timestamp:[NSDate date] UUID:[XMPPStream generateUUID]];
//        welcomeMessage.avator = [UIImage imageNamed:@"全维药事icon.png"];
//        welcomeMessage.officialType = YES;
//        welcomeMessage.messageDeliveryType = MessageTypeReceiving;
//        [retArray addObject:welcomeMessage];
//    }
    return retArray;
}


#pragma mark - 消息中心
- (void)messageCenterInit{
    if (msgCenter == nil){
       
        if (!self.branchId) {
            self.branchId = self.consultingModel.consultId;
        }
        msgCenter=[[XPMessageCenter alloc]initWithID:self.branchId type:self.chatType];
        
        //        msgCenter.shopName = self.title;
        [msgCenter start];
        
    }
    
    //最新的消息回话，会实时刷新
    IMListBlock currentMsgBlock = ^(NSArray* list, IMListType gotType){
        //这里写刷新table的代码

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableMain reloadData];
            [self setTableViewInsetsWithBottomValue:self.view.frame.size.height
             - self.messageInputView.frame.origin.y - kOffSet];
            [self scrollToBottomAnimated:NO];
            self.tableMain.hidden = NO;
        });
        if (gotType == IMListAll) {
            
        }if (gotType == IMListDelete) {
            
        }
        else
        {
            [self setTableViewInsetsWithBottomValue:self.view.frame.size.height
             - self.messageInputView.frame.origin.y - kOffSet];
            [self scrollToBottomAnimated:YES];
        }
        
    };
    
    [msgCenter getMessages:currentMsgBlock success:^(id successObj) {
        //        return ;
        
        if (successObj !=nil) {
            //            PharSessionDetailList *model = successObj;
            
        }
        
        
    } failure:^(id failureObj) {
        
    }];
    WEAKSELF
    [msgCenter setPharConsultBlock:^(PharConsultDetail* model){
        //        weakSelf.branchId =  model.branchId;
        if([model.consultStatus integerValue] == 3 || [model.consultStatus integerValue] == 4) {
            
//            [weakSelf.messageInputView.inputTextView resignFirstResponder];
//            weakSelf.showType = MessageShowTypeClose;
//            weakSelf.timeoutBottomView = [weakSelf setupTimeoutBottomView:[model.consultStatus integerValue]];
//            if(!weakSelf.timeoutBottomView.superview) {
//                [weakSelf.view addSubview:weakSelf.timeoutBottomView];
//                [QWGLOBALMANAGER postNotif:NotiRefreshAllConsult data:nil object:nil];
//            }
//            weakSelf.messageInputView.hidden = YES;
//            weakSelf.headerHintView.hidden = YES;
//            weakSelf.mustAnswer = NO;
        }else{
            if(model.consultMessage.length > 0)
                [weakSelf setCountDownLabelText:model.consultMessage];
            
        }
        
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
            
//            if([text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
//            {
//                [SVProgressHUD showErrorWithStatus:@"发送内容不得为空!" duration:0.8f];
//                return;
//            }
            
//            MessageModel *textMessage = [[MessageModel alloc] initWithText:messageModel.text sender:messageModel.sender timestamp:messageModel.timestamp UUID:messageModel.UUID];
//            XHMessage *textMessage = [[XHMessage alloc] initWithText:text sender:sender timestamp:date UUID:[XMPPStream generateUUID]];
            if(QWGLOBALMANAGER.currentNetWork != kNotReachable) {
                messageModel.sended = Sending;
            }else{
                messageModel.sended = SendFailure;
            }
            messageModel.messageMediaType = XHBubbleMessageMediaTypeText;
            messageModel.messageDeliveryType = MessageTypeSending;
            messageModel.avatorUrl = QWGLOBALMANAGER.configure.avatarUrl;
            messageModel.officialType = YES;
            [self addMessage:messageModel];
            [self finishSendMessageWithBubbleMessageType:MessageMediaTypeText];
            
            
            NSMutableDictionary *setting = [NSMutableDictionary dictionary];
            setting[@"endpoint"] = @"2";
            setting[@"content"] = messageModel.text;
            setting[@"token"] = QWGLOBALMANAGER.configure.userToken;
            double timeDouble = [messageModel.timestamp timeIntervalSince1970] * 1000;
            setting[@"time"] = [NSString stringWithFormat:@"%.0f",timeDouble];
            setting[@"uid"] = messageModel.UUID;
            
            OfficialMessages * msg =  [[OfficialMessages alloc] init];
            msg.fromId = QWGLOBALMANAGER.configure.passportId;
            msg.toId = @"";
            msg.timestamp = [NSString stringWithFormat:@"%f",timeDouble / 1000.0f];
            msg.body = messageModel.text;
            msg.direction = [NSString stringWithFormat:@"%ld",(long)XHBubbleMessageTypeSending];
            msg.messagetype = [NSString stringWithFormat:@"%lu",(unsigned long)XHBubbleMessageMediaTypeText];
            msg.UUID = messageModel.UUID;
            msg.issend = [NSString stringWithFormat:@"%d",messageModel.sended];
            msg.relatedid = QWGLOBALMANAGER.configure.passportId;
            msg.unread = @"0";
            [OfficialMessages updateObjToDB:msg WithKey:msg.UUID];
            
            if(QWGLOBALMANAGER.currentNetWork == NotReachable)
            {
                [self.messageInputView.inputTextView resignFirstResponder];
                [self scrollToBottomAnimated:YES];
                [SVProgressHUD showErrorWithStatus:@"网络连接不可用，请稍后重试" duration:0.8f];
                
                OfficialMessages *msg = [OfficialMessages getObjFromDBWithKey:messageModel.UUID];
                if (msg) {
                    msg.timestamp = [NSString stringWithFormat:@"%f",timeDouble/1000];
                    msg.issend = [NSString stringWithFormat:@"%d",messageModel.sended];
                    [OfficialMessages updateObjToDB:msg WithKey:msg.UUID];
                }
                
                return;
            }
            WEAKSELF
            [IMApi addQwIMWithParams:setting
                             success:^(id resultObj){
                                 if (resultObj) {
                                     
                                     NSString *UUID = messageModel.UUID;
                                     MessageModel *filterMessage = [weakSelf getMessageWithUUID:UUID];
                                     
                                     filterMessage.sended = Sended;
                                     double timeDouble = [resultObj[@"point"] doubleValue] / 1000;
                                     
                                     OfficialMessages * msg = [OfficialMessages getObjFromDBWithKey:UUID];
                                     if (msg) {
                                         msg.timestamp = [NSString stringWithFormat:@"%f",timeDouble];
                                         msg.issend = [NSString stringWithFormat:@"%d",filterMessage.sended];
                                         [OfficialMessages updateObjToDB:msg WithKey:msg.UUID];
                                     }
                                     
                                     NSInteger index = [weakSelf.messages indexOfObject:filterMessage];
                                     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                                     [weakSelf.tableMain reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                     [weakSelf.tableMain reloadData];
                                     [self scrollToBottomAnimated:YES];
                                 }
                             }
                             failure:^(HttpException *e){
                                 NSString *UUID = messageModel.UUID;
                                 MessageModel *filterMessage = [weakSelf getMessageWithUUID:UUID];
                                 filterMessage.sended = SendFailure;
                                 NSInteger index = [weakSelf.messages indexOfObject:filterMessage];
                                 
                                 OfficialMessages * msg = [OfficialMessages getObjFromDBWithKey:UUID];
                                 if (msg) {
                                     msg.timestamp = [NSString stringWithFormat:@"%f",timeDouble/1000];
                                     msg.issend = [NSString stringWithFormat:@"%d",messageModel.sended];
                                     [OfficialMessages updateObjToDB:msg WithKey:msg.UUID];
                                 }
                                 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                                 [weakSelf.tableMain reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                 [weakSelf.tableMain reloadData];
                                 [self scrollToBottomAnimated:YES];
                             }];

            
        
        }
            break;
        
        default:
            break;
    }
}

- (void)addMessage:(MessageModel *)addedMessage {
    [self.messages addObject:addedMessage];
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:1];
    [indexPaths addObject:[NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableMain insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        [self scrollToBottomAnimated:NO];
    });
    
}

- (MessageModel *)getMessageWithUUID:(NSString *)uuid
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"UUID == %@",uuid];
    NSArray *array = [self.messages filteredArrayUsingPredicate:predicate];
    if([array count] > 0) {
        return array[0];
    }else{
        return nil;
    }
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
        default:
            break;
    }
    
    [PharMsgModel updateObjToDB:history WithKey:self.branchId];

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
    textModel.officialType = YES;
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
    }else if(actionSheet.tag==1009){
    }
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
            [self.tableMain scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                                  atScrollPosition:UITableViewScrollPositionBottom
                                          animated:animated];
        }
    }else{
        [self.tableMain scrollRectToVisible:self.tableMain.tableFooterView.frame animated:YES];
    }
}

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
        
//        //shareMenuView键盘
//        item_Y = self.shareMenuView.frame.origin.y;
//        otherMenuViewFrame = self.shareMenuView.frame;
//        if (item_Y < kViewHeight) { //显示在界面上，则隐藏
//            otherMenuViewFrame.origin.y = kViewHeight;
//            self.shareMenuView.alpha = 0;
//            self.shareMenuView.frame = otherMenuViewFrame;
//            [self setTableViewInsetsWithBottomValue:self.view.frame.size.height
//             - self.messageInputView.frame.origin.y - kOffSet];
//        }
        
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
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
/**
 *  是否显示时间轴Label的回调方法
 *  @param indexPath 目标消息的位置IndexPath
 *  @return 根据indexPath获取消息的Model的对象，从而判断返回YES or NO来控制是否显示时间轴Label
 */
- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageModel *message1 = self.messages[indexPath.row];
    if(indexPath.row == 0) {
        return YES;
    }else{
        MessageModel *message0 = self.messages[indexPath.row-1];
        NSTimeInterval offset = [message1.timestamp timeIntervalSinceDate:message0.timestamp];
        if(offset >= 300.0)
            return YES;
    }
    return NO;
}

#pragma mark - Table view delegate UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *obj = nil;
    obj=self.messages[indexPath.row];
    //TODO: need update
    BOOL displayTimestamp = YES;
    displayTimestamp = [self shouldDisplayTimestampForRowAtIndexPath:indexPath];
    return [ChatTableViewCell tableView:tableView heightForRowAtIndexPath:indexPath withObject:(MessageModel *)obj hasTimeStamp:displayTimestamp];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel *model;
    model = self.messages[indexPath.row];
    
    
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
        [cell.headImageView setImage:[UIImage imageNamed:@"全维药事icon"]];
        
        if (displayTimestamp) {
            [cell configureTimeStampLabel:model];
        }
        [cell setupTheBubbleImageView:model];
        
        return cell;
    }
    
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
//        [self stopMusicInOtherBubblePressed];
    }
    for (ChatTableViewCell *cell in self.tableMain.visibleCells) {
        [cell updateMenuControllerVisiable];
    }
    if([eventName isEqualToString:kRouterEventLocationChat]){

    }else if ([eventName isEqualToString:kRouterEventPhotoBubbleTapEventName])
    {

    }else if ([eventName isEqualToString:kRouterEventNoImageActivityBubbleTapEventName] || [eventName isEqualToString:kRouterEventHaveImageActivityBubbleTapEventName] )
    {

    }else if ([eventName isEqualToString:kRouterEventCoupnChat]){

        
    }else if([eventName isEqualToString:kRouterEventDrugChat]){

    }
    else if ([eventName isEqualToString:kResendButtonTapEventName])
    {
        //重发
        self.dicNeedResend = userInfo;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"重发该消息?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = QWYSXPalertResendIdentifier;
        [alertView show];
    }else if ([eventName isEqualToString:kDeleteBtnTapEventName])
    {
        //删除
        self.dicNeedDelete = userInfo;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"你确定要删除吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = QWYSXPalertDeleteIdentifier;
        [alertView show];
    }else if ([eventName isEqualToString:kRouterEventOfVoice]) {
        
    } else if ([eventName isEqualToString:kHeadImageClickEventName]) {
        // 头像点击
        MessageModel *model=[userInfo objectForKey:KMESSAGEKEY];
        if(model.messageDeliveryType == MessageTypeReceiving) {
            
            IntroduceQwysViewController *introduceQwysViewController = [[IntroduceQwysViewController alloc] initWithNibName:@"IntroduceQwysViewController" bundle:nil];
            [self.navigationController pushViewController:introduceQwysViewController animated:YES];
//            CustomerDetailInfoModelR *modelInfoR = [CustomerDetailInfoModelR new];
//            modelInfoR.token = QWGLOBALMANAGER.configure.userToken;
//            
//            modelInfoR.customer = self.consultingModel.customerPassport;
//            
//            HttpClientMgr.progressEnabled = NO;
//            [Customer QueryCustomerInfoWithParams:modelInfoR success:^(id obj) {
//                MyCustomerInfoModel *modelInfo = (MyCustomerInfoModel *)obj;
//                if ([modelInfo.apiStatus integerValue] == 0) {
//                    ClientInfoViewController *info = [[UIStoryboard storyboardWithName:@"ClientInfo" bundle:nil] instantiateViewControllerWithIdentifier:@"ClientInfoViewController"];
//                    info.dic = @{@"passportId":self.consultingModel.customerPassport};
//                    [self.navigationController pushViewController:info animated:YES];
//                }else
//                {
//                    
//                }
//                
//            } failue:^(HttpException *e) {
//                
//            }];
        }
    }
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

- (void)setCountDownLabelText:(NSString *)text
{
    _countDownLabel.text = text;
    if(self.showType == MessageShowTypeAnswer) {
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


- (void)racingQuestion:(id)sender
{
    ConsultReplyFirstgModelR *consultReplyFirstModelR = [ConsultReplyFirstgModelR new];
    consultReplyFirstModelR.token = QWGLOBALMANAGER.configure.userToken;
    consultReplyFirstModelR.consultId = self.messageSender;
    [Consult consultReplyFirstWithParams:consultReplyFirstModelR success:^(BaseAPIModel *model) {
        if([model.apiStatus integerValue] == 0)
        {
//            self.mustAnswer = YES;
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


- (void)layoutDifferentMessageType
{
    CGFloat inputViewHeight = 45.0f;
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

    }else if(self.showType == MessageShowTypeClose){

    }else{

    }
    if(bottomView) {
        bottomView.tag = 1445;
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
    inputView.allowsSendVoice = NO;
    inputView.allowsSendMultiMedia = NO;
    inputView.delegate = self;
    return inputView;
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


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == QWYSXPalertResendIdentifier) {
        if (buttonIndex == 0) {
            
        } else if (buttonIndex == 1) {
            // 重发
            if (self.dicNeedResend) {
                MessageModel *model=[self.dicNeedResend objectForKey:@"kShouldResendModel"];

                model.sended = Sending;
                model.timestamp = [NSDate date];
                
                OfficialMessages *officialMsg = [OfficialMessages getObjFromDBWithKey:model.UUID];
                double timeDouble = [model.timestamp timeIntervalSince1970] * 1000;
                officialMsg.timestamp = [NSString stringWithFormat:@"%f",timeDouble / 1000.0f];
                officialMsg.issend = [NSString stringWithFormat:@"%d",model.sended];
                [OfficialMessages updateObjToDB:officialMsg WithKey:officialMsg.UUID];
                
                
                HistoryMessages *historyMsg = [HistoryMessages getObjFromDBWithKey:self.messageSender];
                if(!historyMsg)
                    historyMsg = [[HistoryMessages alloc] init];
                historyMsg.relatedid = self.messageSender;
                historyMsg.timestamp = officialMsg.timestamp;
                historyMsg.body = officialMsg.body;
                historyMsg.direction = [NSString stringWithFormat:@"%ld",(long)MessageTypeSending];
                historyMsg.messagetype = [NSString stringWithFormat:@"%lu",(unsigned long)XHBubbleMessageMediaTypeLocation];
                historyMsg.UUID = officialMsg.UUID;
                [HistoryMessages updateObjToDB:historyMsg WithKey:historyMsg.relatedid];
                
                
                [self sendTextMessageWithHTTP:model];
                [self.messages removeObject:model];
                
                [self.messages addObject:model];
                
                [self.tableMain reloadData];
                [self scrollToBottomAnimated:NO];
                
                
               
            }
        }
    } else if (alertView.tag == QWYSXPalertDeleteIdentifier) {
        if (buttonIndex == 1) {
            // 删除
            if (self.dicNeedDelete) {
                
            }
        }
    }else if(alertView.tag == 1114) {
        if(buttonIndex == 1) {
            ConsultReplyFirstgModelR *consultModelR = [ConsultReplyFirstgModelR new];
            consultModelR.consultId = self.messageSender;
            [Consult consultConsultingGiveUpParams:consultModelR success:^(BaseAPIModel *model) {
                if([model.apiStatus integerValue] == 0) {
                    [QWGLOBALMANAGER postNotif:NotiRefreshAllConsult data:nil object:nil];
                }else{
                    [SVProgressHUD showErrorWithStatus:model.apiMessage duration:0.8f];
                }
                [self.navigationController popViewControllerAnimated:YES];
            } failure:NULL];
        }
    }
    
    
}

- (void)sendTextMessageWithHTTP:(MessageModel *)textMessage
{
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"endpoint"] = @"2";
    setting[@"content"] = textMessage.text;
    setting[@"token"] = QWGLOBALMANAGER.configure.userToken;
    double timeDouble = [textMessage.timestamp timeIntervalSince1970] * 1000;
    setting[@"time"] = [NSString stringWithFormat:@"%.0f",timeDouble];
    setting[@"uid"] = textMessage.UUID;
    setting[@"UUID"] = textMessage.UUID;
    [IMApi addQwIMWithParams:setting
                     success:^(id resultObj){
                         if ([resultObj[@"apiStatus"] integerValue] == 0) {
                             [self messageDidSendSuccess:textMessage.UUID withResult:resultObj];
                        
                         }else {
                             [SVProgressHUD showErrorWithStatus:resultObj[@"apiMessage"] duration:0.8f];
                            [self messageDidSendFailure:textMessage.UUID];
                         }
                     }
                     failure:^(HttpException *e){
                         [self messageDidSendFailure:e.UUID];
                     }];


}

- (void)messageDidSendSuccess:(NSString *)UUID withResult:(NSDictionary *)result
{
    MessageModel *filterMessage = [self getMessageWithUUID:UUID];
    if(filterMessage)
    {
        filterMessage.sended = Sended;
        NSInteger index = [self.messages indexOfObject:filterMessage];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        
        [self.tableMain reloadData];
        
        OfficialMessages *officialMsg = [OfficialMessages getObjFromDBWithKey:UUID];
        double timeDouble = [filterMessage.timestamp timeIntervalSince1970] * 1000;
        officialMsg.timestamp = [NSString stringWithFormat:@"%f",timeDouble / 1000.0f];
        officialMsg.issend = [NSString stringWithFormat:@"%d",filterMessage.sended];
        [OfficialMessages updateObjToDB:officialMsg WithKey:officialMsg.UUID];
        
        
        SendConsultMap *consultMap = [SendConsultMap getObjFromDBWithKey:self.messageSender];
        if(!consultMap) {
            consultMap = [SendConsultMap new];
            consultMap.consultId = self.messageSender;
        }
        consultMap.sendStatus = [NSString stringWithFormat:@"%d",Sended];
        [SendConsultMap updateObjToDB:consultMap WithKey:self.messageSender];
        HistoryMessages *history = [HistoryMessages getObjFromDBWithKey:self.messageSender];
        
        
        history.issend = [NSString stringWithFormat:@"%d",Sended];
        [HistoryMessages updateObjToDB:history WithKey:self.messageSender];
        [GLOBALMANAGER postNotif:NotimessageBoxUpdate data:nil object:nil];
    }
}


//发送消息失败
- (void)messageDidSendFailure:(NSString *)UUID
{

    MessageModel *filterMessage = [self getMessageWithUUID:UUID];
    if(filterMessage) {
        filterMessage.sended = SendFailure;
        //更新本地数据库
        
        NSInteger index = [self.messages indexOfObject:filterMessage];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tableMain reloadData];
        
        OfficialMessages *officialMsg = [OfficialMessages getObjFromDBWithKey:UUID];
        officialMsg.issend = [NSString stringWithFormat:@"%d",SendFailure];
        [OfficialMessages updateObjToDB:officialMsg WithKey:UUID];
        
        HistoryMessages *history = [HistoryMessages getObjFromDBWithKey:self.messageSender];
        history.issend = [NSString stringWithFormat:@"%d",SendFailure];
        [HistoryMessages updateObjToDB:history WithKey:UUID];
        
        
        
        
        SendConsultMap *consultMap = [SendConsultMap getObjFromDBWithKey:self.messageSender];
        if(!consultMap) {
            consultMap = [SendConsultMap new];
            consultMap.consultId = self.messageSender;
        }
        consultMap.sendStatus = [NSString stringWithFormat:@"%d",SendFailure];
        [SendConsultMap updateObjToDB:consultMap WithKey:self.messageSender];
        
    }
    [GLOBALMANAGER postNotif:NotimessageBoxUpdate data:nil object:nil];
    [SVProgressHUD showErrorWithStatus:@"网络连接不可用，请稍后重试" duration:0.8f];
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
//                    weakSelf.shareMenuView.alpha = 0.0;
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
        
        
        if (hide) {
            switch (self.textViewInputViewType) {
                case XHInputViewTypeEmotion: {
                    EmotionManagerViewAnimation(hide);
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
//                    ShareMenuViewAnimation(!hide);
                    // 2、再显示和自己相关的View
                    EmotionManagerViewAnimation(hide);
                    break;
                }
                case XHInputViewTypeShareMenu: {
                    // 1、先隐藏和自己无关的View
                    EmotionManagerViewAnimation(!hide);
                    // 2、再显示和自己相关的View
//                    ShareMenuViewAnimation(hide);
                    break;
                }
                case XHInputViewTypeVoice:{
//                    ShareMenuViewAnimation(!hide);
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
    //    if (!self.previousTextViewContentHeight)
    //        self.previousTextViewContentHeight = [self getTextViewContentH:messageInputTextView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
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
- (IBAction)popVCAction:(id)sender{
    
    [super popVCAction:sender];
    [msgCenter deleteMessagesByType:MessageMediaTypeMedicineShowOnce];
    [msgCenter deleteMessagesByType:MessageMediaTypeMedicineSpecialOffersShowOnce];
    [QWGLOBALMANAGER postNotif:NotiRefreshAllConsult data:nil object:nil];
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

@end
