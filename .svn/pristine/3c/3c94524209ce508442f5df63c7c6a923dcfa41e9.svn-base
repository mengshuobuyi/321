//
//  Chat.m
//  APP
//
//  Created by carret on 15/5/21.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "ChatTableViewCell.h"
#import "BaseChatBubbleView.h"
#import "UIResponder+Router.h"
#import "MessageModel.h"
#import "ChatBubbleViewHeader.h"
#import "FileManager.h"

NSString *const kHeadImageClickEventName = @"kHeadImageClickEventName";
NSString *const kDeleteBtnTapEventName = @"kDeleteBtnTapEventName";
NSString *const kResendButtonTapEventName = @"kResendButtonTapEventName";

NSString *const kShouldResendCell = @"kShouldResendCell";
NSString *const kShouldResendModel = @"kShouldResendModel";
NSString *const kShouldDeleteModel = @"kShouldDeleteModel";
NSString *const kHeadImageClickModel = @"kHeadImageClickModel";


#define CURRENT_SYS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define XH_STRETCH_IMAGE(image, edgeInsets) (CURRENT_SYS_VERSION < 6.0 ? [image stretchableImageWithLeftCapWidth:edgeInsets.left topCapHeight:edgeInsets.top] : [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch])



@interface ChatTableViewCell()<MLEmojiLabelDelegate>

@property (nonatomic, strong)  NSArray       *subViewHorizontalConstraints;
@property (nonatomic, strong)  NSArray       *subViewVerticalConstraints;
@property (nonatomic, strong) UITapGestureRecognizer    *tapGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer    *tapDismissMenuRecognizer;
@property (nonatomic, strong) NSLayoutConstraint *constraintViewContainerWidth;
@property (nonatomic, strong) NSLayoutConstraint *cosstraintViewContainerHieght;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *constraintTimeLabelWidth;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *constraintTimeLabelHeight;


@property (nonatomic, strong) PhotoChatBubbleView *photoView_;
@property (nonatomic, strong) TextChatBubbleView *textView_;
@property (nonatomic, strong) CoupnChatBubbleView *couponView_;
@property (nonatomic, strong) LocationChatBubbleView *locationView_;
@property (nonatomic, strong) HaveImageActivityChatBubbleView *haveImageActivityView_;
@property (nonatomic, strong) NoImageActivityChatBubbleView *noImageActivityView_;
@property (nonatomic, strong) DrugChatBubbleView *drugView_;
@property (nonatomic, strong) VoiceChatBubbleView *voiceView_;

//yqy 220
@property (nonatomic, strong) CouponTickettBubbleView *couponTicketView_;
@property (nonatomic, strong) CouponMedicineBubbleView *couponMedicineView_;
@end


@implementation ChatTableViewCell
- (BOOL) canPerformAction:(SEL)action withSender:(id)sender
{
    if(![self.messageModel officialType])
    {
        if([self.messageModel messageMediaType] == MessageMediaTypeMedicineShowOnce || [self.messageModel messageMediaType] == MessageMediaTypeMedicineSpecialOffersShowOnce) {
            return NO;
        }
        if([self.messageModel messageMediaType] == MessageMediaTypeStarStore || [self.messageModel messageMediaType] == MessageMediaTypeStarClient || [self.messageModel messageMediaType] == MessageMediaTypeActivity || [self.messageModel messageMediaType] == MessageMediaTypeMedicine || [self.messageModel messageMediaType] == MessageMediaTypeStoreMedicine  || [self.messageModel messageMediaType] == MessageMediaTypeMedicineSpecialOffers || [self.messageModel messageMediaType] == MessageMediaTypeLocation || [self.messageModel messageMediaType] == MessageMediaTypeMedicineShowOnce || [self.messageModel messageMediaType] == MessageMediaTypeMedicineSpecialOffersShowOnce || [self.messageModel messageMediaType] == MessageMediaTypeHeader || [self.messageModel messageMediaType] == MessageMediaTypeLine || [self.messageModel messageMediaType] == MessageMediaTypeFooter || [self.messageModel messageMediaType] == MessageMediaTypePhone || [self.messageModel messageMediaType] == MessageMediaTypeVoice) {
            
            if (self.chatCellStyle == ChatCellStylePrivateChat) {
                return NO;
            }else{
                return action == @selector(deleted:);
            }
        }else {
            if (self.chatCellStyle == ChatCellStylePrivateChat) {
                return action == @selector(copyed:);
            }else{
                return (action == @selector(copyed:) || action == @selector(deleted:));
            }
        }
    }
    else
        return NO;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}
- (id)initWithMessageModel:(MessageModel *)model reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithMessageModel:model reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)stopVoicePlay
{
    [self.voiceView_ stopVoice];
}

//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    CGRect bubbleFrame = _bubbleView.frame;
//    bubbleFrame.origin.y = self.headImageView.frame.origin.y;
//    
//    if (self.messageModel.messageDeliveryType) {
//        bubbleFrame.origin.y = self.headImageView.frame.origin.y;
//        // 菊花状态 （因不确定菊花具体位置，要在子类中实现位置的修改）
//      
//        switch (self.messageModel.sended) {
//            case MessageDeliveryState_Delivering:
//            {
//    
//                [_resendBtn setHidden:YES];
//                [_activityIndicator setHidden:NO];
//                [_activityIndicator startAnimating];
//            }
//                break;
//            case MessageDeliveryState_Delivered:
//            {
//                [_activityIndicator stopAnimating];
//                [_resendBtn setHidden:YES];
//            
//            }
//                break;
////            case MessageDeliveryState_Pending:
//            case MessageDeliveryState_Failure:
//            {
//        
//                [_activityIndicator stopAnimating];
//                [_activityIndicator setHidden:YES];
//                [_resendBtn setHidden:NO];
//            }
//                break;
//            default:
//                break;
//        }
//        
//        bubbleFrame.origin.x = self.headImageView.frame.origin.x - bubbleFrame.size.width - HEAD_PADDING;
//        _bubbleView.frame = bubbleFrame;
//
//    }
//    else{
//        bubbleFrame.origin.x = HEAD_PADDING * 2 + HEAD_SIZE;
//        _bubbleView.frame = bubbleFrame;
//    }
//}

-(void)setMessageModel:(MessageModel *)messageModel
{
    [super setMessageModel:messageModel];
    self.separatorHidden = YES;


    if (_bubbleView) {
        _bubbleView.messageModel = self.messageModel;
        if (self.messageModel.messageMediaType == MessageMediaTypeVoice) {
            self.lblSoundDuration.text = [NSString stringWithFormat:@"%.0f''",floor([self.messageModel.voiceDuration floatValue])];
        }
        
    }
}

- (void)UIGlobal
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)prepareForReuse
{
//    [_voiceView_ stopVoice];
//    [_viewContainer removeConstraints:_viewContainer.constraints];
}

#pragma mark - private
- (void)headImageClick
{
    [self routerEventWithName:kHeadImageClickEventName userInfo:@{KMESSAGEKEY:self.messageModel}];
}

- (void)setupSubviewsForMessageModel:(MessageModel *)messageModel
{
    if (messageModel.messageDeliveryType) {
        // 发送进度显示view
        // 重发按钮
         self.activityIndicator.backgroundColor = [UIColor clearColor];
    }
    self.headImageView.clipsToBounds = YES;
    self.headImageView.layer.cornerRadius = 5.0;

    if (_bubbleView) {
        [_bubbleView removeFromSuperview];
    }
    _bubbleView = [self bubbleViewForMessageModel:messageModel];
    if (_bubbleView) {
        [self.contentView addSubview:_bubbleView];
        [self.resendBtn addTarget:self
                           action:@selector(resendMessage:) forControlEvents:UIControlEventTouchUpInside];
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizerHandle:)];
        [recognizer setMinimumPressDuration:0.4f];
        [self addGestureRecognizer:recognizer];
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerHandle:)];
        self.tapDismissMenuRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDismissGestureRecognizerHandle:)];
        [self addGestureRecognizer:self.tapGestureRecognizer];
        if (messageModel.messageMediaType == MessageMediaTypeVoice) {
            NSLog(@"the message model is %@",messageModel.voiceUrl);
            VoiceChatBubbleView *bubbleVoice = (VoiceChatBubbleView *)_bubbleView;
            //检查本地文件是否已存在
            NSString *privateName;
            if(IS_EXPERT_ENTRANCE){
                privateName = QWGLOBALMANAGER.configure.expertMobile;
            }else{
                privateName = QWGLOBALMANAGER.configure.userName;
            }
            
            NSString *audioPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat: @"Documents/%@/Voice/",privateName]];
            NSString *fileName = [NSString stringWithFormat:@"%@/%@.amr", audioPath, messageModel.UUID];
            
            //检查附件是否存在
            if ([FileManager checkFileExist:fileName]) {
                 messageModel.download = MessageFileState_Downloaded;
            }else{
                if (messageModel.hadDownloaded == YES) {
                    messageModel.hadDownloaded = NO;
                    [bubbleVoice downLoadVoiceFile];
                }
                
            }
            //            [self performSelector:@selector(downloadFile) withObject:nil afterDelay:5.0];
//            [self.activityIndicator startAnimating];
        }
    }

}

- (void)downloadFile
{
    VoiceChatBubbleView *bubbleVoice = (VoiceChatBubbleView *)_bubbleView;
    [bubbleVoice downLoadVoiceFile];
}

- (void)updateBubbleViewConsTraint:(MessageModel *)model
{
    //TODO: need update
//    self.displayTimestamp = YES;
    CGSize bubbleSize = [ChatTableViewCell bubbleViewHeightForMessagModel:model];
//    [_viewContainer removeConstraints:_viewContainer.constraints];
    
//     NSLog(@"##### bubble size is %@",NSStringFromCGSize(bubbleSize));
    
    
    if (IS_IPHONE_6P) {
        self.constraintTimeTop.constant = 5.0;
    } else {
        self.constraintTimeTop.constant = 2.0;
    }
    
    [_viewContainer removeConstraint:self.constraintViewContainerWidth];
    [_viewContainer removeConstraint:self.cosstraintViewContainerHieght];
    
    self.constraintViewContainerWidth = [NSLayoutConstraint constraintWithItem:_viewContainer attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:bubbleSize.width];
    self.cosstraintViewContainerHieght = [NSLayoutConstraint constraintWithItem:_viewContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:bubbleSize.height];
    
    [_viewContainer addConstraint:self.constraintViewContainerWidth];
    [_viewContainer addConstraint:self.cosstraintViewContainerHieght];
    //MARK: 是否显示时间戳
    if (self.displayTimestamp) {
        self.constraintTimeHeight.constant = TIMEVIEW_TOP_PADDING;
        self.timeLabel.hidden = NO;
    } else {
        self.constraintTimeHeight.constant = 0;
        self.timeLabel.hidden = YES;
    }
    if ([self hideHeadImageView]) {
        // 显示头像
        self.headImageView.hidden = NO;
        self.constraintHeadImageWidth.constant = HEAD_SIZE;
    } else {
        self.headImageView.hidden = YES;
        self.constraintHeadImageWidth.constant = -16.0f;
        
    }
    
    [self.activityIndicator stopAnimating];
    self.resendBtn.hidden = YES;
    self.viewVoice.hidden = YES;
    self.redownloadBtn.hidden = YES;
    switch (model.sended) {
        case MessageDeliveryState_Pending:
        case MessageDeliveryState_Delivered:
        {
            if (model.messageMediaType == MessageMediaTypeVoice) {
                if (model.download == MessageFileState_Downloaded) {
                    self.viewVoice.hidden = NO;
                } else if ((model.download == MessageFileState_Downloading)||(model.download == MessageFileState_Pending)) {
                    [self.activityIndicator startAnimating];
                } else if (model.download == MessageFileState_Failure) {
//                    self.viewVoice.hidden = NO;
                } else {
                    
                }
                
            } else {
                [self.activityIndicator stopAnimating];
            }
        }
            break;
        case MessageDeliveryState_Delivering:
        {
            [self.activityIndicator startAnimating];
            if (model.messageMediaType == MessageMediaTypeVoice) {
            
                self.viewVoice.hidden = YES;
                
            } else {
                
            }
        }
            break;
        case MessageDeliveryState_Failure:
        {
            
            if (model.messageMediaType == MessageMediaTypeVoice) {
                if (model.messageDeliveryType == MessageTypeReceiving) {
                } else {
                    self.resendBtn.hidden = NO;
                }
            } else {
                self.resendBtn.hidden = NO;
            }
            
        }
            break;
        default:
            break;
    }

    
    self.constraintWaitingTop.constant = bubbleSize.height/2-2;
    self.constraintSoundTimeTop.constant = bubbleSize.height/2-10;

    
}
- (void)configureTimeStampLabel:(MessageModel *)model
{
    
    self.timeLabel.backgroundColor = RGBHex(qwColor9);
    self.timeLabel.textColor = RGBHex(qwColor4);
    self.timeLabel.font = fontSystem(kFontS5);
    self.timeLabel.text = [QWGLOBALMANAGER updateDisplayTime:model.timestamp];
    CGSize size=[self.timeLabel.text sizeWithFont:fontSystem(kFontS5) constrainedToSize:CGSizeMake(CGFLOAT_MAX, 21)];
    self.constraintTimeLabelWidth.constant = size.width + 20.0f;
    [self.timeLabel setNeedsLayout];
    [self.timeLabel layoutIfNeeded];
    self.timeLabel.layer.cornerRadius = 4.0f;
    self.timeLabel.layer.masksToBounds = YES;
}

- (void)setupTheBubbleImageView:(MessageModel *)model
{
    NSString *messageTypeString = @"weChatBubble";
    if (model.messageDeliveryType == MessageTypeSending) {
        messageTypeString = [messageTypeString stringByAppendingString:@"_Sending"];
    }else
    {
        messageTypeString = [messageTypeString stringByAppendingString:@"_Receiving"];
    }

    switch (model.messageMediaType)
    {
        case MessageMediaTypePhoto:
            break;
//            messageTypeString = [messageTypeString stringByAppendingString:@"_Solid"];
            
        case MessageMediaTypeText:
        case MessageMediaTypeStarStore:
        case MessageMediaTypeStarClient:
        case MessageMediaTypeVoice:
        
            
        case MessageMediaTypeAutoSubscription:
        case MessageMediaTypeSpreadHint:
        case MessageMediaTypeDrugGuide:
        case MessageMediaTypePurchaseMedicine:
            //带泡泡尖
            messageTypeString = [messageTypeString stringByAppendingString:@"_Solid"];
            break;
        case MessageMediaTypeActivity:
        case MessageMediaTypeLocation:
        case MessageMediaTypeMedicineSpecialOffers:
        case MessageMediaTypeMedicine:
        case MessageMediaTypeStoreMedicine:
        
        case MessageMediaTypeMedicineCoupon:
        {
            if(model.messageDeliveryType == MessageTypeSending) {
                messageTypeString = @"weChatBubble_Sending_Solid_Activity";
            }else{
                messageTypeString = @"weChatBubble_Receiving_Solid_Activity";
            }
            break;
        }
        case MessageMediaTypeHeader:
        case MessageMediaTypeFooter:
        case MessageMediaTypeLine:
        case MessageMediaTypePhone:
        case MessageMediaTypeMedicineShowOnce:
        case MessageMediaTypeMedicineSpecialOffersShowOnce:
        case MessageMediaTypeCoupon:
            break;
        default:
            break;
    }
    UIImage *bublleImage = [UIImage imageNamed:messageTypeString];
    UIEdgeInsets bubbleImageEdgeInsets = [self bubbleImageEdgeInsetsWithStyle:XHBubbleImageViewStyleWeChat];
    self.bubbleImageView.image = XH_STRETCH_IMAGE(bublleImage, bubbleImageEdgeInsets);
}

- (UIEdgeInsets)bubbleImageEdgeInsetsWithStyle:(XHBubbleImageViewStyle)style {
    UIEdgeInsets edgeInsets;
    switch (style) {
        case XHBubbleImageViewStyleWeChat:
            // 类似微信的
            edgeInsets = UIEdgeInsetsMake(30, 28, 85, 28);
//            edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            break;
        default:
            break;
    }
    return edgeInsets;
}



- (BaseChatBubbleView *)bubbleViewForMessageModel:(MessageModel *)messagModel
{
    switch (messagModel.messageMediaType) {
        case MessageMediaTypeText:
        {           // 纯文本
            if (!self.textView_) {
                TextChatBubbleView *textView = nil;
                NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"TextChatBubbleView" owner:self options:nil];
                textView.contentLable.emojiDelegate = self;
                textView= [nibViews objectAtIndex: 0];
                textView.autoresizingMask = UIViewAutoresizingNone;
                self.textView_ = textView;
            }
            
            return self.textView_;
        }
        case MessageMediaTypeLocation:
        {       // 地理位置
            
            if (!self.locationView_) {
                LocationChatBubbleView *locationView = nil;
                NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"LocationChatBubbleView" owner:self options:nil];
                locationView= [nibViews objectAtIndex: 0];
                locationView.autoresizingMask = UIViewAutoresizingNone;
                self.locationView_ = locationView;
            }
            
            return self.locationView_;
        }
            break;
        case MessageMediaTypeActivity:
        {           // 营销活动
            
            if (messagModel.activityUrl && ![messagModel.activityUrl isEqualToString:@""]) {
                
                if (!self.haveImageActivityView_) {
                    HaveImageActivityChatBubbleView *activityView = nil;
                    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"HaveImageActivityChatBubbleView" owner:self options:nil];
                    activityView= [nibViews objectAtIndex: 0];
                    activityView.autoresizingMask = UIViewAutoresizingNone;
                    self.haveImageActivityView_ = activityView;
                }
                
                return self.haveImageActivityView_;
            }else
            {
                if (!self.noImageActivityView_) {
                    NoImageActivityChatBubbleView *activityView = nil;
                    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"NoImageActivityChatBubbleView" owner:self options:nil];
                    activityView= [nibViews objectAtIndex: 0];
                    activityView.autoresizingMask = UIViewAutoresizingNone;
                    self.noImageActivityView_ = activityView;
                }
                
                return self.noImageActivityView_;
            }
        }
            break;
        case MessageMediaTypePhoto:
        {
            if (!self.photoView_) {
                PhotoChatBubbleView *photoView = nil;
                NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"PhotoChatBubbleView" owner:self options:nil];
                photoView= [nibViews objectAtIndex: 0];
                photoView.autoresizingMask = UIViewAutoresizingNone;
             
                self.photoView_ = photoView;
            }
//            [self.photoView_ setFrame:CGRectZero];
//            [self.photoView_.bubblePhotoImageView setFrame:CGRectZero];
            self.photoView_.bubblePhotoImageView.bubbleMessageType = messagModel.messageDeliveryType;
            self.photoView_.bubblePhotoImageView.messagePhoto = messagModel.photo;
            self.photoView_.bubblePhotoImageView.messageModel = messagModel;
            
            [self.photoView_.bubblePhotoImageView updatePhoto];
            
            [self.photoView_ setNeedsDisplay];
            
//            photoView.bubblePhotoImageView.bubbleMessageType = messagModel.messageDeliveryType;
//            photoView.bubblePhotoImageView.messagePhoto = messagModel.photo;
//            photoView.bubblePhotoImageView.messageModel = messagModel;
//            
//            [photoView.bubblePhotoImageView updatePhoto];
//            [self.photoView_ setNeedsDisplay];
//
            return self.photoView_;
            
//            return photoView;
        }
            break;
            
        case MessageMediaTypeMedicineSpecialOffers://优惠活动
        {
            if (!self.couponView_) {
                CoupnChatBubbleView *coupnView = nil;
                NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"CoupnChatBubbleView" owner:self options:nil];
                coupnView= [nibViews objectAtIndex: 0];
                coupnView.autoresizingMask = UIViewAutoresizingNone;
                self.couponView_ = coupnView;
            }
            return self.couponView_;
        }
            break;
        case MessageMediaTypeMedicine:
        {
            if (!self.drugView_) {
                DrugChatBubbleView *drugView = nil;
                NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"DrugChatBubbleView" owner:self options:nil];
                drugView= [nibViews objectAtIndex: 0];
                drugView.autoresizingMask = UIViewAutoresizingNone;
                self.drugView_ = drugView;
            }
            
            return self.drugView_;
        }
            break;
        case MessageMediaTypeStoreMedicine:
        {
            if (!self.drugView_) {
                DrugChatBubbleView *drugView = nil;
                NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"DrugChatBubbleView" owner:self options:nil];
                drugView= [nibViews objectAtIndex: 0];
                drugView.autoresizingMask = UIViewAutoresizingNone;
                self.drugView_ = drugView;
            }
            
            return self.drugView_;
        }
            break;
        case MessageMediaTypeVoice:
        {
            if(!self.voiceView_) {
                VoiceChatBubbleView *voiceView = nil;
                NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"VoiceChatBubbleView" owner:self options:nil];
                voiceView= [nibViews objectAtIndex: 0];
                voiceView.autoresizingMask = UIViewAutoresizingNone;
                voiceView.messageModel = messagModel;
                voiceView.delegateMsgCenter = self.delegate;
                self.voiceView_ = voiceView;
                self.voiceView_.cellChat = self;
            }
            return self.voiceView_;
        }
            //yqy 220
        case MessageMediaTypeCoupon:
        {
            if(!self.couponTicketView_) {
                CouponTickettBubbleView *vv = nil;
                NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"CouponTickettBubbleView" owner:self options:nil];
                vv= [nibViews objectAtIndex: 0];
                vv.autoresizingMask = UIViewAutoresizingNone;
                vv.messageModel = messagModel;
           
                self.couponTicketView_ = vv;
                
            }
            return self.couponTicketView_;
        }
        case MessageMediaTypeMedicineCoupon:
        {
            if(!self.couponMedicineView_ ) {
                CouponMedicineBubbleView *vv = nil;
                NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"CouponMedicineBubbleView" owner:self options:nil];
                vv= [nibViews objectAtIndex: 0];
                vv.autoresizingMask = UIViewAutoresizingNone;
                vv.messageModel = messagModel;
             
                self.couponMedicineView_ = vv;
                
            }
            return self.couponMedicineView_;
        }
        default:
            break;
    }
    
    return nil;
}

+ (CGSize)bubbleViewHeightForMessagModel:(MessageModel *)messagModel
{
    switch (messagModel.messageMediaType) {
        case MessageMediaTypeText:
        {
           return [TextChatBubbleView sizeForBubbleWithObject:messagModel];
        }
        case MessageMediaTypeLocation:
        {
            return [LocationChatBubbleView sizeForBubbleWithObject:messagModel];
        }
        case MessageMediaTypeActivity:
        {
            if (messagModel.activityUrl && ![messagModel.activityUrl isEqualToString:@""]) {
                return [HaveImageActivityChatBubbleView sizeForBubbleWithObject:messagModel];
            }else
            {
                return [NoImageActivityChatBubbleView sizeForBubbleWithObject:messagModel];
            }
        }
        case MessageMediaTypePhoto:
        {
            return [PhotoChatBubbleView sizeForBubbleWithObject:messagModel];
        }

        case MessageMediaTypeMedicine:
        {
            return [DrugChatBubbleView sizeForBubbleWithObject:messagModel];
        }
        case MessageMediaTypeStoreMedicine:
        {
            return [DrugChatBubbleView sizeForBubbleWithObject:messagModel];
        }
        case MessageMediaTypeMedicineSpecialOffers:
        {
            return [CoupnChatBubbleView sizeForBubbleWithObject:messagModel];
        }
        case MessageMediaTypeVoice:
        {
            return [VoiceChatBubbleView sizeForBubbleWithObject:messagModel];
        }
            //yqy 220
        case MessageMediaTypeCoupon:
        {
            return [CouponTickettBubbleView sizeForBubbleWithObject:messagModel];
        }
        case MessageMediaTypeMedicineCoupon:
        {
            return [CouponMedicineBubbleView sizeForBubbleWithObject:messagModel];
        }
        default:
            break;
    }
    return CGSizeZero;
}

#pragma mark - public

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withObject:(MessageModel *)model hasTimeStamp:(BOOL)hasTimeStamp
{
    CGSize  bubbleSize = [self bubbleViewHeightForMessagModel:model];
//    NSLog(@"##### bubble size is %@",NSStringFromCGSize(bubbleSize));
    NSInteger timeViewHeight = 0;
    //TODO: need update
//    hasTimeStamp = YES;
    if (hasTimeStamp) {
        timeViewHeight=TIMEVIEW_TOP_PADDING + TIMEVIEW_PADDING;
    } else {
        timeViewHeight = TIMEVIEW_PADDING;
    }
    if (IS_IPHONE_6P) {
        timeViewHeight += 3;
    } else {
        
    }
    NSInteger bubbleHeight = bubbleSize.height + HEAD_PADDING + timeViewHeight;
    NSInteger headHeight = HEAD_PADDING + HEAD_SIZE + timeViewHeight;
    return MAX(headHeight, bubbleHeight) + CELLPADDING;
}

#pragma mark - action
-(BOOL)hideHeadImageView
{

    switch (self.messageModel.messageMediaType) {

        case MessageMediaTypeHeader:  
        case MessageMediaTypeLine:
        case MessageMediaTypeMedicineShowOnce:
//        case MessageMediaTypeMedicineSpecialOffersShowOnce:
        case MessageMediaTypeFooter:
        case MessageMediaTypePhone:
        case MessageMediaTypeSpreadHint:
        case MessageMediaTypeDrugGuide:
        case MessageMediaTypePurchaseMedicine:
        {
           return  NO;
        }
        default:
            
            return YES;
    }
}
// 重发按钮事件
- (IBAction)resendMessage:(id)sender {
    
//    [self routerEventWithName:kResendButtonTapEventName
//                     userInfo:@{kShouldResendCell:self}];
    [self routerEventWithName:kResendButtonTapEventName
                     userInfo:@{kShouldResendModel:self.messageModel}];
    
}

- (void)refreshCellChat:(VoiceDownloadStatus)status
{
    if (status == VoiceDownloadSuccess) {
        self.redownloadBtn.hidden = YES;
        [self.activityIndicator stopAnimating];
        //        self.lblSoundDuration.hidden = NO;
        self.viewVoice.hidden = NO;
        
    } else if (status == VoiceDownloadFail) {
        //        self.redownloadBtn.hidden = NO;
        self.viewVoice.hidden = YES;
        [self.activityIndicator stopAnimating];
    }
}

- (void)redownloadAudio:(id)sender
{
    self.redownloadBtn.hidden = YES;
    [self.activityIndicator startAnimating];
    if (_bubbleView) {
        if (self.messageModel.messageMediaType == MessageMediaTypeVoice) {
            VoiceChatBubbleView *bubbleView = (VoiceChatBubbleView *)_bubbleView;
            [bubbleView downLoadVoiceFile];
        }
    }
}
- (void)setupNormalMenuController {
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
//        [self removeGestureRecognizer:self.tapGestureRecognizer];
        [self removeGestureRecognizer:self.tapDismissMenuRecognizer];
    }
    
}

- (void)tapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self.superParentViewController hiddenKeyboard];
    CGPoint pointReco = [tapGestureRecognizer locationInView:self.contentView];
    if (CGRectContainsPoint(self.headImageView.frame, pointReco)) {
        [self headImageClick];
    } else {
    }
    NSLog(@"the point is %@",NSStringFromCGPoint(pointReco));
}

- (void)tapDismissGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self updateMenuControllerVisiable];

}

- (void)updateMenuControllerVisiable {
    [self setupNormalMenuController];
}

- (void)longPressGestureRecognizerHandle:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    if (self.messageModel.messageMediaType == MessageMediaTypeLine ||self.messageModel.messageMediaType == MessageMediaTypeFooter ||self.messageModel.messageMediaType == MessageMediaTypeHeader ||self.messageModel.messageMediaType == MessageMediaTypePhone) {
        return;
    }
    CGPoint point = [longPressGestureRecognizer locationInView:self];
    CGRect convertRect = CGRectZero;
    
//    if(self.messageModel.messageDeliveryType == MessageTypeSending) {
    
//    }else{
//        convertRect = [self.bubbleView convertRect:self.bubbleView.frame toView:self];
//    }
    if (self.messageModel.messageMediaType == MessageMediaTypePhoto) {
        convertRect = [self.contentView convertRect:[_bubbleView frame]
                                                 fromView:_bubbleView];
        if(self.displayTimestamp) {
//            convertRect.origin.y += 21;
        }
        if(!CGRectContainsPoint(convertRect,point)) {
            return;
        }
    } else {
        convertRect = self.bubbleView.frame;
        if(self.displayTimestamp) {
//            convertRect.origin.y += 21;
        }
        if(!CGRectContainsPoint(convertRect,point)) {
            return;
        }
    }
   
    if (longPressGestureRecognizer.state != UIGestureRecognizerStateBegan || ![self becomeFirstResponder])
        return;
    UIMenuItem *copy = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyed:)];
    UIMenuItem *transpond = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleted:)];
    //    UIMenuItem *favorites = [[UIMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"favorites", @"MessageDisplayKitString", @"收藏") action:@selector(favorites:)];
    //    UIMenuItem *more = [[UIMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"more", @"MessageDisplayKitString", @"更多") action:@selector(more:)];
    
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    
    if (self.messageModel.messageMediaType == MessageMediaTypeText) {
        [menu setMenuItems:[NSArray arrayWithObjects:copy, transpond, nil]];
        [menu setTargetRect:CGRectInset(_bubbleView.frame, 0.0f, 4.0f) inView:_bubbleView.superview];
        
        
    }
    else {
        [menu setMenuItems:[NSArray arrayWithObjects: transpond, nil]];
        CGRect targetRect = [self.contentView convertRect:[_bubbleView frame]
                                                 fromView:_bubbleView];//  _bubbleView.frame
        [menu setTargetRect:CGRectInset(targetRect, 0.0f,10.0f) inView:_bubbleView.superview];
    }
//
//    CGRect targetRect = [self.contentView convertRect:[_bubbleView frame]
//                                             fromView:_bubbleView];//  _bubbleView.frame
//    [menu setTargetRect:CGRectInset(targetRect, 0.0f, 4.0f) inView:_bubbleView.superview];
    //    [menu setTargetRect:CGRectInset(targetRect, 0.0f, 4.0f) inView:self.contentView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillShowNotification:)
                                                 name:UIMenuControllerWillShowMenuNotification
                                               object:nil];
    [menu setMenuVisible:YES animated:YES];
    [self addGestureRecognizer:self.tapDismissMenuRecognizer];
}
- (void)copyed:(id)sender {
    [[UIPasteboard generalPasteboard] setString:self.messageModel.text];
    [self resignFirstResponder];
}

- (void)deleted:(id)sender
{
    [self routerEventWithName:kDeleteBtnTapEventName userInfo:@{kShouldDeleteModel:self.messageModel}];
    //    if([self.delegate respondsToSelector:@selector(deleteOneMessageAtIndexPath:)]){
    //        [self.delegate deleteOneMessageAtIndexPath:self.indexPath];
    //    }
}

#pragma mark - Notifications

- (void)handleMenuWillHideNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
}

- (void)handleMenuWillShowNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillHideNotification:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
}
@end
