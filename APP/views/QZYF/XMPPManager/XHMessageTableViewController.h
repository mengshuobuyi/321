//
//  XHMessageTableViewController.h
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QWBaseVC.h"
// Model
#import "XHMessage.h"
#import "XHStoreManager.h"

// Views
#import "XHMessageTableView.h"
#import "XHMessageTableViewCell.h"
#import "XHMessageInputView.h"
#import "XHShareMenuView.h"
#import "XHEmotionManagerView.h"
#import "XHVoiceRecordHUD.h"

// Factory
#import "XHMessageBubbleFactory.h"
#import "XHMessageVideoConverPhotoFactory.h"

// Helper
#import "XHPhotographyHelper.h"
#import "XHLocationHelper.h"
#import "XHVoiceRecordHelper.h"

// Categorys
#import "UIScrollView+XHkeyboardControl.h"

//RichText
#import "Constant.h"
#import "TQRichTextView.h"
#import "ConsultPTPModel.h"
#import "ExpandAnimateButton.h"

@protocol XHMessageTableViewControllerDelegate <NSObject>

@optional
/**
 *  发送文本消息的回调方法
 *
 *  @param text   目标文本字符串
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date;

- (void)didSendLocation:(NSString *)text
               latitude:(NSString *)latitude
              longitude:(NSString *)longitude
             fromSender:(NSString *)sender
                 onDate:(NSDate *)date;


//发送评价的代理
- (void)didSendEvaluateText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date;

- (void)didSendMedicine:(NSString *)text productId:(NSString *)productId imageUrl:(NSString *)imageUrl fromSender:(NSString *)sender onDate:(NSDate *)date;

//发送营销活动的代理
- (void)didSendActivityTitle:(NSString *)title
                    imageUrl:(NSString *)imageUrl
                     content:(NSString *)content
                     comment:(NSString *)comment
                    richBody:(NSString *)richbody
                  fromSender:(NSString *)sender
                      onDate:(NSDate *)date;

/**
 *  发送优惠活动回调方法
 *
 *  @param text         优惠活动标题
 *  @param content      优惠活动内容
 *  @param activityUrl  优惠活动图片
 *  @param activityId   优惠活动id
 *  @param sender       发送者的名字
 *  @param date         发送时间
 */
- (void)didSendPTMActivity:(NSString *)text content:(NSString *)content comment:(NSString *)comment activityUrl:(NSString *)activityUrl activityId:(NSString *)activityId fromSender:(NSString *)sender onDate:(NSDate *)date;

- (void)layoutOtherMenuViewHiden:(BOOL)hide;
/**
 *  发送图片消息的回调方法
 *
 *  @param photo  目标图片对象，后续有可能会换
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendPhoto:(UIImage *)photo fromSender:(NSString *)sender onDate:(NSDate *)date image:(NSString *)url uuid:(NSString *)uuid;;

/**
 *  是否显示时间轴Label的回调方法
 *
 *  @param indexPath 目标消息的位置IndexPath
 *
 *  @return 根据indexPath获取消息的Model的对象，从而判断返回YES or NO来控制是否显示时间轴Label
 */
- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  配置Cell的样式或者字体
 *
 *  @param cell      目标Cell
 *  @param indexPath 目标Cell所在位置IndexPath
 */
- (void)configureCell:(XHMessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

/**
 *  协议回掉是否支持用户手动滚动
 *
 *  @return 返回YES or NO
 */
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling;

/**
 *  判断是否支持下拉加载更多消息
 *
 *  @return 返回BOOL值，判定是否拥有这个功能
 */
- (BOOL)shouldLoadMoreMessagesScrollToTop;

/**
 *  下拉加载更多消息，只有在支持下拉加载更多消息的情况下才会调用。
 */
- (void)loadMoreMessagesScrollTotop;

@end

@protocol XHMessageTableViewControllerDataSource <NSObject>

@required

- (id<XHMessageModel>)messageForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

typedef enum AccountType
{
    NormalType = 0,
    OfficialType = 1
}AccountType;


@interface XHMessageTableViewController : QWBaseVC <UITableViewDataSource, UITableViewDelegate, XHMessageTableViewControllerDelegate, XHMessageTableViewControllerDataSource, XHMessageInputViewDelegate, XHMessageTableViewCellDelegate, XHShareMenuViewDelegate, XHEmotionManagerViewDelegate, XHEmotionManagerViewDataSource>

@property (nonatomic, weak) id <XHMessageTableViewControllerDelegate> delegate;

@property (nonatomic, strong) UIView                      *headerHintView;
@property (nonatomic, weak, readwrite) XHMessageTableView *messageTableView;
@property (nonatomic, weak) id <XHMessageTableViewControllerDataSource> dataSource;
@property (nonatomic, assign) AccountType   accountType;
//营销活动列表
@property (nonatomic, strong) NSMutableArray        *marketList;
@property (nonatomic, assign) BOOL isUserScrolling;
@property (nonatomic, assign) BOOL shouldPreventAutoScrolling;
@property (nonatomic, assign) BOOL mustAnswer;
@property (nonatomic, assign) MessageShowType  showType;
@property (nonatomic, strong) UILabel          *countDownLabel;
@property (nonatomic, strong) UIImageView      *alarmLogo;

@property (nonatomic ,strong) PharSessionVo *customerSessionVo;
/**
 *  数据源，显示多少消息
 */
@property (nonatomic, strong) NSMutableArray *messages;

/**
 *  第三方接入的功能，也包括系统自身的功能，比如拍照、发送地理位置
 */
@property (nonatomic, strong) NSArray *shareMenuItems;

/**
 *  消息的主体，默认为nil
 */
@property (nonatomic, strong) NSString *messageSender;
@property (nonatomic, strong) NSMutableArray *CommonWords;
/**
 *  用于显示消息的TableView
 */


/**
 *  用于显示发送消息类型控制的工具条，在底部
 */
@property (nonatomic, strong, readonly) XHMessageInputView *messageInputView;

/**
 *  替换键盘的位置的第三方功能控件
 */
@property (nonatomic, weak, readonly) XHShareMenuView *shareMenuView;


/**
 *  管理第三方gif表情的控件
 */
@property (nonatomic, weak, readonly) XHEmotionManagerView *emotionManagerView;

/**
 *  是否正在加载更多旧的消息数据
 */
@property (nonatomic, assign) BOOL loadingMoreMessage;

#pragma mark - Message View Controller Default stup
/**
 *  是否允许手势关闭键盘，默认是允许
 */
@property (nonatomic, assign) BOOL allowsPanToDismissKeyboard; // default is YES

/**
 *  是否允许发送语音
 */
@property (nonatomic, assign) BOOL allowsSendVoice; // default is YES

/**
 *  是否允许发送多媒体
 */
@property (nonatomic, assign) BOOL allowsSendMultiMedia; // default is YES

/**
 *  是否支持发送表情
 */
@property (nonatomic, assign) BOOL allowsSendFace; // default is YES

/**
 *  输入框的样式，默认为扁平化
 */
@property (nonatomic, assign) XHMessageInputViewStyle inputViewStyle;
@property (nonatomic, strong) ExpandAnimateButton         *animateButton;

@property (nonatomic,strong)NSMutableDictionary *photoDic;
@property (nonatomic,strong)NSMutableDictionary *photoDicRs;

#pragma mark - DataSource Change
/**
 *  添加一条新的消息
 *
 *  @param addedMessage 添加的目标消息对象
 */
/**
 *  更新标题栏数据
 */
- (void)setCountDownLabelText:(NSString *)text;

- (void)addCacheMessage:(NSMutableArray *)messageList;
- (void)addMessages:(NSArray *)addedMessages;
- (void)addMessage:(XHMessage *)addedMessage;

/**
 *  删除一条已存在的消息
 *
 *  @param reomvedMessage 删除的目标消息对象
 */
- (void)removeMessageAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  插入旧消息数据到头部，仿微信的做法
 *
 *  @param oldMessages 目标的旧消息数据
 */
- (void)insertOldMessages:(NSArray *)oldMessages;

#pragma mark - Messages view controller
/**
 *  完成发送消息的函数
 */
- (void)finishSendMessageWithBubbleMessageType:(XHBubbleMessageMediaType)mediaType;

/**
 *  设置View、tableView的背景颜色
 *
 *  @param color 背景颜色
 */
- (void)setBackgroundColor:(UIColor *)color;

/**
 *  设置消息列表的背景图片
 *
 *  @param backgroundImage 目标背景图片
 */
- (void)setBackgroundImage:(UIImage *)backgroundImage;

/**
 *  是否滚动到底部
 *
 *  @param animated YES Or NO
 */
- (void)scrollToBottomAnimated:(BOOL)animated;

/**
 *  滚动到哪一行
 *
 *  @param indexPath 目标行数变量
 *  @param position  UITableViewScrollPosition 整形常亮
 *  @param animated  是否滚动动画，YES or NO
 */
- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath
			  atScrollPosition:(UITableViewScrollPosition)position
					  animated:(BOOL)animated;

-(void)resendPhotoWihtUuid:(NSString *)red;
- (void)addPhotoMessage:(XHMessage *)addedMessage;

- (void)layoutOtherMenuViewHide:(BOOL)hide fromInputView:(BOOL)from;

-(void)sendXmppPhototimestamp:(NSDate *)timestamp
                     richBody:(NSString *)richBody
                         UUID:(NSString *)UUID;
- (XHMessage *)getMessageWithUUID:(NSString *)uuid;
-(void)doSendPhoto:(NSString*)str;
@end
