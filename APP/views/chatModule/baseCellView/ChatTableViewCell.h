//
//  Chat.h
//  APP
//
//  Created by carret on 15/5/21.
//  Copyright (c) 2015年 carret. All rights reserved.
//

typedef NS_ENUM(NSInteger, ChatCellStyle) {
    ChatCellStyleNormal         = 0,
    ChatCellStylePrivateChat    = 1,
};


#import "BaseChatTableViewCell.h"
#import "BaseChatBubbleView.h"
#import "LKBadgeView.h"
#import "CustomTimeLabel.h"
#import "ChatViewController.h"
#define SEND_STATUS_SIZE 20 // 发送状态View的Size
#define ACTIVTIYVIEW_BUBBLE_PADDING 5 // 菊花和bubbleView之间的间距

extern NSString *const kResendButtonTapEventName;
extern NSString *const kHeadImageClickEventName;
extern NSString *const kShouldResendCell;
extern NSString *const kDeleteBtnTapEventName;
extern NSString *const kShouldResendModel;
extern NSString *const kShouldDeleteModel;
extern NSString *const kHeadImageClickModel;

typedef enum {
    VoiceDownloading,
    VoiceDownloadSuccess,
    VoiceDownloadFail
}VoiceDownloadStatus;
@interface ChatTableViewCell : BaseChatTableViewCell
{
 
}
@property (nonatomic, assign) ChatCellStyle chatCellStyle;
@property (weak, nonatomic) ChatViewController *superParentViewController;
@property (weak, nonatomic) IBOutlet CustomTimeLabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *viewTime;
@property (weak, nonatomic) IBOutlet UIButton *resendBtn;
@property (weak, nonatomic) IBOutlet UIButton *redownloadBtn;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (nonatomic, weak) IBOutlet UIImageView *headImageView;       //头像
@property (nonatomic, weak) IBOutlet LKBadgeView *timeBadgeView;
@property (nonatomic, weak) IBOutlet UIImageView *bubbleImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *constraintTimeHeight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *constraintHeadImageWidth;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *constraintWaitingTop;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *constraintSoundTimeTop;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *constraintTimeTop;
@property (nonatomic, weak) IBOutlet UILabel *lblSoundDuration;
@property (nonatomic, weak) IBOutlet UIView *viewVoice;
@property (nonatomic ,assign)BOOL displayTimestamp;
@property (nonatomic, strong) NSArray        *horizontalConstraints;
@property (nonatomic, strong) NSArray        *verticalConstraints;

- (void)stopVoicePlay;
- (IBAction)resendMessage:(id)sender;
- (IBAction)redownloadAudio:(id)sender;
- (void)updateBubbleViewConsTraint:(MessageModel *)model;
+ (CGSize)bubbleViewHeightForMessagModel:(MessageModel *)messagModel;
- (void)configureTimeStampLabel:(MessageModel *)model;
- (void)setupTheBubbleImageView:(MessageModel *)model;
-(BOOL)hideHeadImageView;
- (void)updateMenuControllerVisiable;
- (void)refreshCellChat:(VoiceDownloadStatus)status;
@end
