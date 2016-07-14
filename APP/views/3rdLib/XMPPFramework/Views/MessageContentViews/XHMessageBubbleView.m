//
//  XHMessageBubbleView.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMessageBubbleView.h"
#import "TQRichTextURLRun.h"
#import "XHMessageBubbleHelper.h"
#import "XHMessageTableViewController.h"
#import "TQRichTextEmojiRun.h"
#import "MLEmojiLabel.h"
#import "UIImageView+WebCache.h"

#define kMarginTop 8.0f
#define kMarginBottom 5.0f
#define kPaddingTop 4.0f
#define kBubblePaddingRight 10.0f

#define kVoiceMargin 20.0f

#define kXHArrowMarginWidth 14
#import "SDImageCache.h"
@interface XHMessageBubbleView ()<UIActionSheetDelegate,MLEmojiLabelDelegate>

@property (nonatomic, weak, readwrite) MLEmojiLabel *displayTextView;

@property (nonatomic, weak, readwrite) UIImageView *bubbleImageView;

@property (nonatomic, weak, readwrite) UIImageView *animationVoiceImageView;

@property (nonatomic, weak, readwrite) XHBubblePhotoImageView *bubblePhotoImageView;

//@property (nonatomic ,strong) DPMeterView *dpMeterView;
@property (nonatomic, weak, readwrite) UIImageView *videoPlayImageView;

@property (nonatomic, weak, readwrite) UILabel *geolocationsLabel;

@property (nonatomic, strong, readwrite) id <XHMessageModel> message;

@end

@implementation XHMessageBubbleView

#pragma mark - Bubble view

+ (CGFloat)neededWidthForText:(NSString *)text {
    CGSize stringSize;
    stringSize = [text sizeWithFont:[[XHMessageBubbleView appearance] font]
                  constrainedToSize:CGSizeMake(MAXFLOAT, 19)];
    return roundf(stringSize.width);
}

+ (CGSize)neededSizeForText:(NSString *)text
{
    CGFloat maxWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]) * (kIsiPad ? 0.8 : 0.6);
    //    CGFloat dyWidth = [XHMessageBubbleView neededWidthForText:text];
    CGSize textSize = [MLEmojiLabel needSizeWithText:text WithConstrainSize:CGSizeMake(maxWidth, MAXFLOAT)];
    if(textSize.height == 25)
        textSize.height -= 5;
    return CGSizeMake(textSize.width + kBubblePaddingRight * 2 + kXHArrowMarginWidth, textSize.height);
}

+ (CGSize)neededSizeForText:(NSString *)text withFont:(UIFont *)font
{
    CGFloat maxWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]) * (kIsiPad ? 0.8 : 0.6);
    //    CGFloat dyWidth = [XHMessageBubbleView neededWidthForText:text];
    CGSize textSize = [MLEmojiLabel needSizeWithText:text WithConstrainSize:CGSizeMake(maxWidth, MAXFLOAT) WithFont:font];
    if(textSize.height == 25)
        textSize.height -= 5;
    return CGSizeMake(textSize.width + kBubblePaddingRight * 2 + kXHArrowMarginWidth, textSize.height);
}


+ (CGSize)neededSizeForText:(NSString *)text withDelta:(CGFloat)delta
{
    CGFloat maxWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]) * delta;
    //    CGFloat dyWidth = [XHMessageBubbleView neededWidthForText:text];
    CGSize textSize = [MLEmojiLabel needSizeWithText:text WithConstrainSize:CGSizeMake(maxWidth, MAXFLOAT)];
    if(textSize.height == 25)
        textSize.height -= 2;
    return CGSizeMake(textSize.width + kBubblePaddingRight * 2 + kXHArrowMarginWidth, textSize.height);
}


+ (CGSize)neededSizeForPhoto:(UIImage *)photo {
    // 这里需要缩放后的size
    CGSize photoSize = CGSizeMake(MAX_SIZE, MAX_SIZE);
    //    photo.size;
    return photoSize;
}

+ (CGSize)neededSizeForVoicePath:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration {
    // 这里的100只是暂时固定，到时候会根据一个函数来计算
    float gapDuration = (!voiceDuration || voiceDuration.length == 0 ? -1 : [voiceDuration floatValue] - 1.0f);
    CGSize voiceSize = CGSizeMake(100 + (gapDuration > 0 ? (120.0 / (60 - 1) * gapDuration) : 0),30);
    return voiceSize;
}

+ (CGFloat)calculateCellHeightWithMessage:(id <XHMessageModel>)message {
    CGSize size = [XHMessageBubbleView getBubbleFrameWithMessage:message];
    return size.height + kMarginTop + kMarginBottom;
}

+ (CGSize)getBubbleFrameWithMessage:(id <XHMessageModel>)message {
    CGSize bubbleSize;
    switch (message.messageMediaType) {
        case XHBubbleMessageMediaTypeText:
        case XHBubbleMessageMediaTypePurchaseMedicine:
        {
            bubbleSize = [XHMessageBubbleView neededSizeForText:message.text ];
            break;
        }
        case XHBubbleMessageMediaTypeStarStore:{
            bubbleSize = [XHMessageBubbleView neededSizeForText:message.text ];
            break;
        }
        case XHBubbleMessageMediaTypeDrugGuide:
        {
            bubbleSize = [self neededSizeForText:message.text];
            bubbleSize.height += 60;
            break;
        }
        case XHBubbleMessageMediaTypeStarClient:
        {
            bubbleSize = [XHMessageBubbleView neededSizeForText:message.text ];
            if(bubbleSize.height == 25)
                bubbleSize.height -= 5;
            bubbleSize.height += 25.0f;
            CGFloat maxWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]) * (kIsiPad ? 0.8 : 0.6);
            bubbleSize.width = maxWidth + kBubblePaddingRight * 2 + kXHArrowMarginWidth;
            break;
        }
        case XHBubbleMessageMediaTypeLocation:
        {
            bubbleSize = CGSizeMake(APP_W * 0.6, 25);
            //CGSize size = [[message text] sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:CGSizeMake(190, 45)];
            bubbleSize.height += 40;
            CGFloat maxWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]) * (kIsiPad ? 0.8 : 0.6);
            bubbleSize.width = maxWidth + kBubblePaddingRight * 2 + kXHArrowMarginWidth;
            break;
        }
        case XHBubbleMessageMediaTypeActivity:
        {
            if(message.activityUrl == nil || [message.activityUrl isEqual:[NSNull null]] || [message.activityUrl isEqualToString:@""])
            {
                NSString *content = message.text;
                CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:CGSizeMake(0.6 * APP_W, 65)];
                
                CGFloat maxWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]) * (kIsiPad ? 0.8 : 0.6);
                bubbleSize.width = maxWidth + kBubblePaddingRight * 2 + kXHArrowMarginWidth;
                CGSize titleSize = [[message title] sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:CGSizeMake(190, 45)];
                bubbleSize.height = size.height + titleSize.height + 8.0f;
                
            }else{
                bubbleSize = CGSizeMake(APP_W * 0.6, 65);
                CGSize size = [[message title] sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:CGSizeMake(190, 45)];
                bubbleSize.height += size.height;
                CGFloat maxWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]) * (kIsiPad ? 0.8 : 0.6);
                bubbleSize.width = maxWidth + kBubblePaddingRight * 2 + kXHArrowMarginWidth;
            }
            break;
        }
        case XHBubbleMessageMediaTypeMedicineSpecialOffers:
        {
            CGSize constrainedSize = CGSizeZero;
            constrainedSize = CGSizeMake(190, 45);
            if(message.activityUrl == nil || [message.activityUrl isEqualToString:@""])
            {
                NSString *content = message.text;
                
                CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:CGSizeMake(0.6 * APP_W, 65)];
                
                CGFloat maxWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]) * (kIsiPad ? 0.8 : 0.6);
                bubbleSize.width = maxWidth + kBubblePaddingRight * 2 + kXHArrowMarginWidth;
                CGSize titleSize = [[message title] sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:constrainedSize];
                bubbleSize.height += titleSize.height + 8 + size.height;
                
            }else{
                bubbleSize = CGSizeMake(APP_W * 0.6, 65);
                CGSize size = [[message title] sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:constrainedSize];
                bubbleSize.height += size.height;
                CGFloat maxWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]) * (kIsiPad ? 0.8 : 0.6);
                bubbleSize.width = maxWidth + kBubblePaddingRight * 2 + kXHArrowMarginWidth;
            }
            break;
        }
        case XHBubbleMessageMediaTypeMedicine:
        {
            bubbleSize = CGSizeMake(APP_W * 0.6, 25);
            bubbleSize.height += 55;
            CGFloat maxWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]) * (kIsiPad ? 0.8 : 0.6);
            bubbleSize.width = maxWidth + kBubblePaddingRight * 2 + kXHArrowMarginWidth;
            break;
        }
        case XHBubbleMessageMediaTypePhoto: {
            
            SDImageCache *imageCache = [SDImageCache sharedImageCache];
            if ([imageCache diskImageExistsWithKey:message.UUID]) {
                
                UIImage *img2 =[[SDImageCache sharedImageCache] imageFromDiskCacheForKey: message.UUID];
                bubbleSize = img2.size;
                if (bubbleSize.width == 0 || bubbleSize.height == 0) {
                    bubbleSize.width = MAX_SIZE;
                    bubbleSize.height = MAX_SIZE;
                }
                else if (bubbleSize.width > bubbleSize.height) {
                    CGFloat height =  MAX_SIZE / bubbleSize.width  *  bubbleSize.height;
                    bubbleSize.height = height;
                    bubbleSize.width = MAX_SIZE;
                }
                else{
                    CGFloat width = MAX_SIZE / bubbleSize.height * bubbleSize.width;
                    bubbleSize.width = width;
                    bubbleSize.height = MAX_SIZE;
                }
            }
            else{
                if (message.photo) {
                    bubbleSize = message.photo.size;
                    if (bubbleSize.width == 0 || bubbleSize.height == 0) {
                        bubbleSize.width = MAX_SIZE;
                        bubbleSize.height = MAX_SIZE;
                    }
                    else if (bubbleSize.width > bubbleSize.height) {
                        
                        CGFloat height =  MAX_SIZE / bubbleSize.width  *  bubbleSize.height;
                        bubbleSize.height = height;
                        bubbleSize.width = MAX_SIZE;
                    }
                    else{
                        CGFloat width = MAX_SIZE / bubbleSize.height * bubbleSize.width;
                        bubbleSize.width = width;
                        bubbleSize.height = MAX_SIZE;
                    }
                    
                    
                    
                }else
                {
                    bubbleSize = [XHMessageBubbleView neededSizeForPhoto:message.photo];
                }
                
                
            }
            //
            break;
        }
            
        case XHBubbleMessageMediaTypeVoice: {
            // 这里的宽度是不定的，高度是固定的，根据需要根据语音长短来定制啦
            bubbleSize = [XHMessageBubbleView neededSizeForVoicePath:message.voicePath voiceDuration:message.voiceDuration];
            break;
        }
        case XHBubbleMessageMediaTypeEmotion:
            // 是否固定大小呢？
            bubbleSize = CGSizeMake(100, 100);
            break;
        case XHBubbleMessageMediaTypeLocalPosition:
            // 固定大小，必须的
            bubbleSize = CGSizeMake(119, 119);
            break;
        default:
            break;
    }
    return bubbleSize;
}

#pragma mark - UIAppearance Getters

- (UIFont *)font {
    if (_font == nil) {
        _font = [[[self class] appearance] font];
    }
    
    if (_font != nil) {
        return _font;
    }
    
    return [UIFont systemFontOfSize:16.0f];
}

#pragma mark - Getters


- (CGRect)bubbleFrame
{
   
    CGSize bubbleSize = [XHMessageBubbleView getBubbleFrameWithMessage:self.message];

    return CGRectIntegral(CGRectMake((self.message.bubbleMessageType == XHBubbleMessageTypeSending ? CGRectGetWidth(self.bounds) - bubbleSize.width : 0.0f),
                                     kMarginTop,
                                     bubbleSize.width,
                                     bubbleSize.height + kMarginTop + kMarginBottom));
}

#pragma mark -
#pragma mark TQRichTextViewDelegate

#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.superParentViewController.shouldPreventAutoScrolling = YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.superParentViewController.shouldPreventAutoScrolling = NO;
}
#pragma mark - Life cycle

- (void)configureCellWithMessage:(id <XHMessageModel>)message {
    _message = message;
    
    [self configureBubbleImageView:message];
    
    [self configureMessageDisplayMediaWithMessage:message];
    
}

- (void)configureBubbleImageView:(id <XHMessageModel>)message {
    XHBubbleMessageMediaType currentType = message.messageMediaType;
    
    _voiceDurationLabel.hidden = YES;
    switch (currentType) {
        case XHBubbleMessageMediaTypeVoice: {
            self.dpMeterView.hidden = YES;
            _voiceDurationLabel.hidden = NO;
            _dpMeterView.hidden = YES;
            _checkImmediately.hidden = YES;
        }
        case XHBubbleMessageMediaTypeText:
        case XHBubbleMessageMediaTypePurchaseMedicine:
        case XHBubbleMessageMediaTypeStarStore:
        case XHBubbleMessageMediaTypeStarClient:
        case XHBubbleMessageMediaTypeEmotion:
        {  self.dpMeterView.hidden = YES;
            _bubbleImageView.image = [XHMessageBubbleFactory bubbleImageViewForType:message.bubbleMessageType style:XHBubbleImageViewStyleWeChat meidaType:message.messageMediaType];
            // 只要是文本、语音、第三方表情，背景的气泡都不能隐藏
            _bubbleImageView.hidden = NO;
            _checkButton.hidden = YES;
            self.activityContent.hidden = YES;
            self.activityImage.hidden = YES;
            self.activityTitle.hidden = YES;
            _footGuide.hidden = YES;
            _dpMeterView.hidden = YES;
            // 只要是文本、语音、第三方表情，都需要把显示尖嘴图片的控件隐藏了
            _bubblePhotoImageView.hidden = YES;
            _dpMeterView.hidden = YES;
            
            if (currentType == XHBubbleMessageMediaTypeText || currentType == XHBubbleMessageMediaTypeStarStore ||
                currentType == XHBubbleMessageMediaTypeStarClient || currentType == XHBubbleMessageMediaTypePurchaseMedicine) {
                // 如果是文本消息，那文本消息的控件需要显示
                _displayTextView.hidden = NO;
                // 那语言的gif动画imageView就需要隐藏了
                _animationVoiceImageView.hidden = YES;
            } else {
                // 那如果不文本消息，必须把文本消息的控件隐藏了啊
                _displayTextView.hidden = YES;
                
                // 对语音消息的进行特殊处理，第三方表情可以直接利用背景气泡的ImageView控件
                if (currentType == XHBubbleMessageMediaTypeVoice) {
                    [_animationVoiceImageView removeFromSuperview];
                    _animationVoiceImageView = nil;
                    
                    UIImageView *animationVoiceImageView = [XHMessageVoiceFactory messageVoiceAnimationImageViewWithBubbleMessageType:message.bubbleMessageType];
                    [self addSubview:animationVoiceImageView];
                    _animationVoiceImageView = animationVoiceImageView;
                    _animationVoiceImageView.hidden = NO;
                } else {
                    _animationVoiceImageView.hidden = YES;
                }
            }
            _checkImmediately.hidden = YES;
            break;
        }
        case XHBubbleMessageMediaTypeLocation:
        {  self.dpMeterView.hidden = YES;
            _checkButton.hidden = YES;
            _footGuide.hidden = YES;
            _bubbleImageView.image = [XHMessageBubbleFactory bubbleImageViewForType:message.bubbleMessageType style:XHBubbleImageViewStyleWeChat meidaType:message.messageMediaType];
            // 只要是文本、语音、第三方表情，背景的气泡都不能隐藏
            _bubbleImageView.hidden = NO;
            _bubblePhotoImageView.hidden = YES;
            _displayTextView.hidden = YES;
            
            self.activityContent.hidden = NO;
            self.activityImage.hidden = NO;
            self.activityTitle.hidden = YES;
            _dpMeterView.hidden = YES;
            self.ratingView.hidden = YES;
            self.serviceLabel.hidden = YES;
            _checkImmediately.hidden = YES;
            break;
        }
        case XHBubbleMessageMediaTypeActivity:
        {  self.dpMeterView.hidden = YES;
            _checkButton.hidden = YES;
            _footGuide.hidden = YES;
            _bubbleImageView.image = [XHMessageBubbleFactory bubbleImageViewForType:message.bubbleMessageType style:XHBubbleImageViewStyleWeChat meidaType:message.messageMediaType];
            // 只要是文本、语音、第三方表情，背景的气泡都不能隐藏
            _bubbleImageView.hidden = NO;
            _bubblePhotoImageView.hidden = YES;
            _displayTextView.hidden = YES;
            self.activityContent.hidden = NO;
            self.activityImage.hidden = NO;
            self.activityTitle.hidden = NO;
            self.ratingView.hidden = YES;
            self.serviceLabel.hidden = YES;
            _dpMeterView.hidden = YES;
            _checkImmediately.hidden = YES;
            break;
        }
        case XHBubbleMessageMediaTypeAutoSubscription:
        case XHBubbleMessageMediaTypeDrugGuide:
        {
            self.dpMeterView.hidden = YES;
            _dpMeterView.hidden = YES;            // 只要是文本、语音、第三方表情，背景的气泡都不能隐藏
            _bubbleImageView.hidden = NO;
            // 只要是文本、语音、第三方表情，都需要把显示尖嘴图片的控件隐藏了
            _bubblePhotoImageView.hidden = YES;
            self.activityContent.hidden = YES;
            self.activityImage.hidden = YES;
            self.activityTitle.hidden = YES;
            self.ratingView.hidden = YES;
            self.serviceLabel.hidden = YES;
            _bubbleImageView.image = [XHMessageBubbleFactory bubbleImageViewForType:message.bubbleMessageType style:XHBubbleImageViewStyleWeChat meidaType:message.messageMediaType];
            if(currentType == XHBubbleMessageMediaTypeDrugGuide) {
                self.activityTitle.hidden = NO;
                _checkButton.hidden = YES;
                _footGuide.hidden = NO;
            }else{
                self.activityTitle.hidden = YES;
                _checkButton.hidden = NO;
                _footGuide.hidden = YES;
            }
            _checkImmediately.hidden = YES;
            break;
        }
        case XHBubbleMessageMediaTypePhoto:
        {
            _bubbleImageView.image = [XHMessageBubbleFactory bubbleImageViewForType:message.bubbleMessageType style:XHBubbleImageViewStyleWeChat meidaType:message.messageMediaType];
            _checkButton.hidden = YES;
            _videoPlayImageView .hidden = YES;
            _bubblePhotoImageView.hidden = NO;
            self.activityContent.hidden = YES;
            self.activityImage.hidden = YES;
            self.activityTitle.hidden = YES;
            _displayTextView.hidden = YES;
            _checkButton.hidden = YES;
            _footGuide.hidden = YES;
            //            [self.activityView stopAnimating];
            //            self.activityView.hidden = YES;
            _checkButton.hidden = YES;
            if (message.sended ==Sending) {
                self.dpMeterView.hidden = NO;
                self.resendButton.hidden = YES;
            }else if(message.sended == Sended)
            {
                
            }
            else{
                self.dpMeterView.hidden = YES;
            }
            if (self.sendType == Sending) {
                self.dpMeterView.hidden = NO;
                self.resendButton.hidden = YES;
            } else{
                self.dpMeterView.hidden = YES;
            }
            _bubbleImageView.hidden = NO;
            self.activityTitle.hidden = YES;
            self.ratingView.hidden = YES;
            self.serviceLabel.hidden = YES;
            _checkImmediately.hidden = YES;
            break;
        }
        case XHBubbleMessageMediaTypeMedicineSpecialOffers:
        {
            _footGuide.hidden = YES;
            _checkButton.hidden = YES;
            _bubbleImageView.image = [XHMessageBubbleFactory bubbleImageViewForType:message.bubbleMessageType style:XHBubbleImageViewStyleWeChat meidaType:message.messageMediaType];
            // 只要是文本、语音、第三方表情，背景的气泡都不能隐藏
            _bubbleImageView.hidden = NO;
            _bubblePhotoImageView.hidden = YES;
            _displayTextView.hidden = YES;
            self.activityContent.hidden = NO;
            self.activityImage.hidden = NO;
            self.activityTitle.hidden = NO;
            self.ratingView.hidden = YES;
            self.serviceLabel.hidden = YES;
            self.dpMeterView.hidden = YES;
            _checkImmediately.hidden = YES;
            break;
        }
        case XHBubbleMessageMediaTypeMedicine:
        {
            _footGuide.hidden = YES;
            _checkButton.hidden = YES;
            _checkImmediately.hidden = NO;
            _bubbleImageView.image = [XHMessageBubbleFactory bubbleImageViewForType:message.bubbleMessageType style:XHBubbleImageViewStyleWeChat meidaType:message.messageMediaType];
            
            // 只要是文本、语音、第三方表情，背景的气泡都不能隐藏
            _bubbleImageView.hidden = NO;
            _bubblePhotoImageView.hidden = YES;
            _displayTextView.hidden = YES;
            self.activityContent.hidden = NO;
            self.activityImage.hidden = NO;
            self.activityTitle.hidden = YES;
            self.ratingView.hidden = YES;
            self.serviceLabel.hidden = YES;
            self.dpMeterView.hidden = YES;
            
            break;
        }
        case XHBubbleMessageMediaTypeLocalPosition: {
            // 只要是图片和视频消息，必须把尖嘴显示控件显示出来
            _bubblePhotoImageView.hidden = NO;//  修改by 沈
            _footGuide.hidden = YES;
            _dpMeterView.hidden = YES;
            _geolocationsLabel.hidden = (currentType != XHBubbleMessageMediaTypeLocalPosition);
            self.dpMeterView.hidden = YES;
            // 那其他的控件都必须隐藏
            _displayTextView.hidden = YES;
            _bubbleImageView.hidden = YES;
            _animationVoiceImageView.hidden = YES;
            _checkImmediately.hidden = YES;
            break;
        }
        default:
            break;
    }
}

- (void)configureMessageDisplayMediaWithMessage:(id <XHMessageModel>)message {
    switch (message.messageMediaType) {
        case XHBubbleMessageMediaTypeText:
        case XHBubbleMessageMediaTypeStarStore:
        case XHBubbleMessageMediaTypeStarClient:
        case XHBubbleMessageMediaTypePurchaseMedicine:{
            [_displayTextView setEmojiText:[message text]];
            NSArray *tagList = [message tagList];
            if(tagList)
                [_displayTextView addLinkTags:tagList];
            break;
        }
        case XHBubbleMessageMediaTypeAutoSubscription:
        case XHBubbleMessageMediaTypeDrugGuide:
        {
            [_displayTextView setEmojiText:[message text]];
            
            NSArray *tagList = [message tagList];
            [_displayTextView addLinkTags:tagList];
            [self.activityTitle setTitle:[message title] forState:UIControlStateNormal];
            [self.activityTitle setTitleColor:RGB(69, 192, 26) forState:UIControlStateNormal];
            self.activityTitle.userInteractionEnabled = YES;
            self.footGuide.emojiText = [NSString stringWithFormat:@"根据您的用药为您推送"];
            if([message title])
            {
                NSDictionary *tag = [message tagList][0];
                NSDictionary *tagDict = @{@"start":@"6",
                                          @"length":[NSNumber numberWithInteger:self.footGuide.emojiText.length - 10],
                                          @"tagId":tag[@"tagId"],
                                          @"tagType":@"1"
                                          };
                [self.footGuide addLinkTags:@[tagDict]];
            }
            
            
            break;
        }
            
            
        case XHBubbleMessageMediaTypePhoto:
            
            [_bubblePhotoImageView configureMessagePhoto:message.photo thumbnailUrl:message.thumbnailUrl originPhotoUrl:message.originPhotoUrl onBubbleMessageType:self.message.bubbleMessageType uuid: message.UUID];

            break;
            
        case XHBubbleMessageMediaTypeVoice:
            break;
        case XHBubbleMessageMediaTypeEmotion:
            // 直接设置GIF
            if (message.emotionPath) {
                _bubbleImageView.image = [UIImage animatedImageWithAnimatedGIFURL:[NSURL fileURLWithPath:message.emotionPath]];
            }
            break;
        case XHBubbleMessageMediaTypeLocalPosition:
            [_bubblePhotoImageView configureMessagePhoto:message.localPositionPhoto thumbnailUrl:nil originPhotoUrl:nil onBubbleMessageType:self.message.bubbleMessageType uuid:@""];
            
            _geolocationsLabel.text = message.geolocations;
            break;
        case XHBubbleMessageMediaTypeActivity:
        case XHBubbleMessageMediaTypeLocation:
        case XHBubbleMessageMediaTypeMedicineSpecialOffers:
        case XHBubbleMessageMediaTypeMedicine:
        {
            [self.activityTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.activityTitle.userInteractionEnabled = NO;
            if(message.messageMediaType == XHBubbleMessageMediaTypeActivity || message.messageMediaType == XHBubbleMessageMediaTypeMedicineSpecialOffers)
                [self.activityTitle setTitle:message.title forState:UIControlStateNormal];
            else
                [self.activityTitle setTitle:@"" forState:UIControlStateNormal];
            
            self.activityContent.text =[self replaceSpecialStringWith:message.text];
            self.activityImage.image = nil;
            if(message.messageMediaType == XHBubbleMessageMediaTypeActivity || message.messageMediaType == XHBubbleMessageMediaTypeMedicineSpecialOffers) {
                self.activityContent.numberOfLines = 4;
                if(message.activityUrl == nil || [message.activityUrl isEqual:[NSNull null]] || [message.activityUrl isEqualToString:@""]){
                    self.activityImage.hidden = YES;
                }else{
                    self.activityImage.hidden = NO;
                    [self.activityImage setImageWithURL:[NSURL URLWithString:message.activityUrl] placeholderImage:[UIImage imageNamed:@"药品默认图片.png"]];
                }
            }else if(message.messageMediaType == XHBubbleMessageMediaTypeLocation){
                self.activityContent.numberOfLines = 2;
                self.activityImage.hidden = NO;
                [self.activityImage setImage:[UIImage imageNamed:@"mapIcon.png"]];
            }else if (message.messageMediaType == XHBubbleMessageMediaTypeMedicine) {
                self.activityContent.numberOfLines = 2;
                self.activityImage.hidden = NO;
                [self.activityImage setImageWithURL:[NSURL URLWithString:message.activityUrl] placeholderImage:[UIImage imageNamed:@"药品默认图片.png"]];
            }
            
            break;
        }
        default:
            break;
    }
    
    [self setNeedsLayout];
}
- (NSString *)replaceSpecialStringWith:(NSString *)string{
    string = [string stringByReplacingOccurrencesOfString:@"    &nbsp;&nbsp;&nbsp;&nbsp;" withString:@"    "];
    string = [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\r\n"];
    string = [string stringByReplacingOccurrencesOfString:@"<br>" withString:@"\r\n"];
    string = [string stringByReplacingOccurrencesOfString:@"<p/>" withString:@"\r\n"];
    return string;
}
- (void)setSendType:(SendType)sendType
{
    _sendType = sendType;
    CGRect rect = self.bubbleImageView.frame;
    
    switch (sendType) {
        case Sending:
        {
            if([[self message] bubbleMessageType] == XHBubbleMessageTypeReceiving){
                rect.origin.x += rect.size.width + 10;
            }else{
                rect.origin.x -= 25;
            }
            rect.origin.y += rect.size.height / 2 - 7.5;
            rect.size.width = 15;
            rect.size.height = 15;
            
            
            self.resendButton.hidden = YES;
            [self.activityView startAnimating];
            //            }
            [self bringSubviewToFront:self.activityView];
            self.activityView.frame = rect;
            break;
        }
        case SendFailure:
        {
            rect.origin.x -= 40;
            rect.origin.y += rect.size.height / 2 - 20;
            rect.size.width = 40;
            rect.size.height = 40;
            
            [self.activityView stopAnimating];
            self.resendButton.hidden = NO;
            [self bringSubviewToFront:self.resendButton];
            self.resendButton.frame = rect;
            break;
        }
        case Sended:
        default:{
            [self.activityView stopAnimating];
            self.resendButton.hidden = YES;
            break;
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame
                      message:(id <XHMessageModel>)message {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _message = message;
        
        // 1、初始化气泡的背景
        if (!_bubbleImageView) {
            //bubble image
            UIImageView *bubbleImageView = [[UIImageView alloc] init];
            bubbleImageView.frame = self.bounds;
            bubbleImageView.userInteractionEnabled = YES;
            [self addSubview:bubbleImageView];
            _bubbleImageView = bubbleImageView;
        }
        
        // 2、初始化显示文本消息的TextView
        if (!_displayTextView) {
            MLEmojiLabel *displayTextView = [[MLEmojiLabel alloc] init];
            displayTextView.numberOfLines = 0;
            displayTextView.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
            displayTextView.customEmojiPlistName = @"expressionImage_custom.plist";
            displayTextView.disableThreeCommon = YES;
            displayTextView.font = [UIFont systemFontOfSize:15.0f];
            displayTextView.emojiDelegate = self;
            
            displayTextView.backgroundColor = [UIColor clearColor];
            displayTextView.lineBreakMode = NSLineBreakByWordWrapping;
            displayTextView.isNeedAtAndPoundSign = YES;
            [self addSubview:displayTextView];
            _displayTextView = displayTextView;
        }
        
        // 3、初始化显示图片的控件
        if (!_bubblePhotoImageView) {
            XHBubblePhotoImageView *bubblePhotoImageView = [[XHBubblePhotoImageView alloc] initWithFrame:CGRectZero];
            bubblePhotoImageView.messagePhoto = [UIImage imageNamed:@"image_waiting2"];
            [self addSubview:bubblePhotoImageView];
            _bubblePhotoImageView = bubblePhotoImageView;
            
            if (!_videoPlayImageView) {
                UIImageView *videoPlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MessageVideoPlay"]];
                [bubblePhotoImageView addSubview:videoPlayImageView];
                _videoPlayImageView = videoPlayImageView;
            }
            
            if (!_geolocationsLabel) {
                UILabel *geolocationsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                geolocationsLabel.numberOfLines = 0;
                geolocationsLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                geolocationsLabel.textColor = [UIColor whiteColor];
                geolocationsLabel.backgroundColor = [UIColor clearColor];
                geolocationsLabel.font = [UIFont systemFontOfSize:12];
                [bubblePhotoImageView addSubview:geolocationsLabel];
                _geolocationsLabel = geolocationsLabel;
            }
            if (!_dpMeterView) {
                //                progressView *dpMeterView =[[progressView alloc]initWithFrame:CGRectZero];
                NSBundle * bundle = [NSBundle mainBundle];
                NSArray * progressViews = [bundle loadNibNamed:@"progressView" owner:self options:nil];
                
                progressView *dpMeterViews =[progressViews objectAtIndex:0];
                dpMeterViews.progressLabel.text = @"0%";
                //                [dpMeterView setMeterType:DPMeterTypeLinearHorizontal];
                //                [dpMeterView add:0.6];
                [self addSubview:dpMeterViews];
                _dpMeterView =dpMeterViews;
            }
        }
        
        //4、初始化显示语音时长的label
        if (!_voiceDurationLabel) {
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 30, 30)];
            lbl.textColor = [UIColor lightGrayColor];
            lbl.backgroundColor = [UIColor clearColor];
            lbl.font = [UIFont systemFontOfSize:13.f];
            lbl.textAlignment = NSTextAlignmentRight;
            lbl.hidden = YES;
            [self addSubview:lbl];
            self.voiceDurationLabel = lbl;
        }
        
        if(!_ratingView) {
            self.ratingView = [[RatingView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
            [self.ratingView setBackgroundColor:[UIColor clearColor]];
            [self.ratingView setImagesDeselected:@"star_none_medium.png" partlySelected:@"star_half_medium.png" fullSelected:@"star_full_medium.png" andDelegate:nil];
            self.ratingView.userInteractionEnabled = NO;
        }
        self.ratingView.hidden = YES;
        self.resendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.resendButton.frame = CGRectMake(0, 0, 40, 40);
        [self.resendButton setImage:[UIImage imageNamed:@"发送失败图标"] forState:UIControlStateNormal];
        self.resendButton.hidden = YES;
        [self addSubview:self.resendButton];
        self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        self.activityView.color = [UIColor grayColor];
        self.activityView.hidesWhenStopped = YES;
        [self addSubview:self.activityView];
        [self addSubview:self.ratingView];
        
        self.serviceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
        self.serviceLabel.font = [UIFont systemFontOfSize:15.0];
        self.serviceLabel.text = @"服务打分:";
        self.serviceLabel.backgroundColor = [UIColor clearColor];
        self.serviceLabel.hidden = YES;
        [self addSubview:self.serviceLabel];
        
        
        self.activityTitle = [UIButton buttonWithType:UIButtonTypeSystem];
        self.activityTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.activityTitle.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        self.activityTitle.frame = CGRectMake(0, 0, 190, 45);
        self.activityTitle.titleLabel.font = [UIFont systemFontOfSize:16.0];
        self.activityTitle.titleLabel.numberOfLines = 2;
        [self.activityTitle setTitleColor:RGB(69, 192, 26) forState:UIControlStateNormal];
        self.activityTitle.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.activityTitle];
        
        self.activityTitle.hidden = YES;
        
        self.activityContent = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 125, 65)];
        self.activityContent.font = [UIFont systemFontOfSize:13.0];
        self.activityContent.numberOfLines = 4;
        self.activityContent.backgroundColor = [UIColor clearColor];
        [self addSubview:self.activityContent];
        self.activityContent.hidden = YES;
        
        self.activityImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
        [self addSubview:self.activityImage];
        self.activityImage.hidden = YES;
        
        //慢病订阅立即查看按钮
        self.checkButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.checkButton setTitle:@"立即去查看" forState:UIControlStateNormal];
        self.checkButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        self.checkButton.titleLabel.textColor = [UIColor blueColor];
        self.checkButton.backgroundColor = [UIColor clearColor];
        self.checkButton.frame = CGRectMake(160, 0, 80, 20);
        [self addSubview:self.checkButton];
        self.checkButton.userInteractionEnabled = NO;
        self.checkImmediately = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.checkImmediately setTitle:@"查看详情>" forState:UIControlStateNormal];
        self.checkImmediately.titleLabel.font = [UIFont systemFontOfSize:15.0];
        self.checkImmediately.titleLabel.textColor = [UIColor blueColor];
        self.checkImmediately.backgroundColor = [UIColor clearColor];
        self.checkImmediately.frame = CGRectMake(160, 0, 100, 20);
        [self addSubview:self.checkImmediately];
        self.checkImmediately.hidden = YES;
        self.checkImmediately.userInteractionEnabled = NO;
        
        //用药指导注标
        self.footGuide = [[MLEmojiLabel alloc] initWithFrame:CGRectMake(-25, 0, APP_W * 0.6, 20)];
        self.footGuide.emojiDelegate = self;
        
        self.footGuide.textColor = RGB(153, 153, 153);
        self.footGuide.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:self.footGuide];
        
        
        //        [self.bubblePhotoImageView addSubview:self.dpMeterView];
    }
    return self;
}

- (void)dealloc {
    _message = nil;
    
    _displayTextView = nil;
    
    _bubbleImageView = nil;
    
    _bubblePhotoImageView = nil;
    _dpMeterView = nil;
    _animationVoiceImageView = nil;
    
    _voiceDurationLabel = nil;
    
    _videoPlayImageView = nil;
    
    _geolocationsLabel = nil;
    
    _font = nil;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.activityContent.textColor = RGBHex(qwColor8);
    [self.activityTitle setTitleColor:RGBHex(qwColor6) forState:UIControlStateNormal];
    
    XHBubbleMessageMediaType currentType = self.message.messageMediaType;
    CGRect bubbleFrame = [self bubbleFrame];
    
    switch (currentType) {
        case XHBubbleMessageMediaTypeText:
        case XHBubbleMessageMediaTypeStarStore:
        case XHBubbleMessageMediaTypeStarClient:
        case XHBubbleMessageMediaTypeVoice:
        case XHBubbleMessageMediaTypeEmotion:
        case XHBubbleMessageMediaTypePurchaseMedicine:
        {
            CGRect bubbleFrameCopy = bubbleFrame;
            bubbleFrameCopy.size.height = MAX(35, bubbleFrameCopy.size.height);
            self.bubbleImageView.frame = bubbleFrameCopy;
            CGFloat textX = CGRectGetMinX(bubbleFrame) + kBubblePaddingRight;
            
            if (self.message.bubbleMessageType == XHBubbleMessageTypeReceiving) {
                textX += kXHArrowMarginWidth  - 5;
            }
            CGRect textFrame = CGRectMake(textX,
                                          CGRectGetMinY(bubbleFrame) + kPaddingTop + 2,
                                          CGRectGetWidth(bubbleFrame) - kBubblePaddingRight * 2 - kXHArrowMarginWidth,
                                          bubbleFrame.size.height - kMarginTop - kMarginBottom);
            if(textFrame.size.height <= 30) {
                textFrame.origin.y += 3;
            }
            self.displayTextView.frame = CGRectIntegral(textFrame);
            
            [self.displayTextView sizeToFit];
            
            CGRect animationVoiceImageViewFrame = self.animationVoiceImageView.frame;
            animationVoiceImageViewFrame.origin = CGPointMake((self.message.bubbleMessageType == XHBubbleMessageTypeReceiving ? (bubbleFrame.origin.x + kVoiceMargin) : (bubbleFrame.origin.x + CGRectGetWidth(bubbleFrame) - kVoiceMargin - CGRectGetWidth(animationVoiceImageViewFrame))), 17);
            self.animationVoiceImageView.frame = animationVoiceImageViewFrame;
            [self resetVoiceDurationLabelFrameWithBubbleFrame:bubbleFrame];
            if (currentType == XHBubbleMessageMediaTypeStarStore)
            {
                self.ratingView.hidden = NO;
                self.serviceLabel.hidden = YES;
                CGRect rect = self.ratingView.frame;
                if (self.message.bubbleMessageType == XHBubbleMessageTypeReceiving) {
                    rect.origin.x = 50;
                }else{
                    rect.origin.x = 70;
                }
                rect.origin.y = 36.5;
                
                self.ratingView.frame = rect;
                [self.ratingView displayRating:0.0];
                
            }else if (currentType == XHBubbleMessageMediaTypeStarClient) {
                self.ratingView.hidden = NO;
                
                self.serviceLabel.hidden = NO;
                CGRect rect = self.serviceLabel.frame;
                rect.origin.x = 21;
                rect.origin.y = 12;
                self.serviceLabel.frame = rect;
                
                rect = self.ratingView.frame;
                rect.origin.x = 105;
                rect.origin.y  = 16;
                self.ratingView.frame = rect;
                [self.ratingView displayRating:self.message.starMark];
                rect = self.displayTextView.frame;
                //[self.displayTextView setBackgroundColor:[UIColor yellowColor]];
                rect.origin.x = 21;
                rect.origin.y = 40;
                self.displayTextView.frame = rect;
                
            }else{
                self.serviceLabel.hidden = YES;
                self.ratingView.hidden = YES;
            }
            break;
        }
        case XHBubbleMessageMediaTypePhoto:
        {
            //            CGRect bubbleFrameCopy = bubbleFrame;
            //            bubbleFrameCopy.size.height = MAX(35, bubbleFrameCopy.size.height);
            //            self.bubbleImageView.frame = bubbleFrameCopy;
            
            
            
            CGSize  bubbleSize = CGSizeZero;
            SDImageCache *imageCache = [SDImageCache sharedImageCache];
            if ([imageCache diskImageExistsWithKey:self.message.UUID]) {
                
                UIImage *img2 =[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.message.UUID];
                bubbleSize = img2.size;
                if (bubbleSize.width == 0 || bubbleSize.height == 0) {
                    bubbleSize.width = MAX_SIZE;
                    bubbleSize.height = MAX_SIZE;
                }
                else if (bubbleSize.width > bubbleSize.height) {
                    CGFloat height =  MAX_SIZE / bubbleSize.width  *  bubbleSize.height;
                    bubbleSize.height = height;
                    bubbleSize.width = MAX_SIZE;
                }
                else{
                    CGFloat width = MAX_SIZE / bubbleSize.height * bubbleSize.width;
                    bubbleSize.width = width;
                    bubbleSize.height = MAX_SIZE;
                }
            }
            else{
                if (self.message.photo) {
                    bubbleSize = self.message.photo.size;
                    if (bubbleSize.width == 0 || bubbleSize.height == 0) {
                        bubbleSize.width = MAX_SIZE;
                        bubbleSize.height = MAX_SIZE;
                    }
                    else if (bubbleSize.width > bubbleSize.height) {
                        
                        CGFloat height =  MAX_SIZE / bubbleSize.width  *  bubbleSize.height;
                        bubbleSize.height = height;
                        bubbleSize.width = MAX_SIZE;
                    }
                    else{
                        CGFloat width = MAX_SIZE / bubbleSize.height * bubbleSize.width;
                        bubbleSize.width = width;
                        bubbleSize.height = MAX_SIZE;
                    }
                    
                    
                    
                }else
                {
                    bubbleSize = [XHMessageBubbleView neededSizeForPhoto:self.message.photo];
                }
                

            }
            CGRect photoImageViewFrame = CGRectMake(bubbleFrame.origin.x , 0, bubbleSize.width, bubbleSize.height);
            _bubblePhotoImageView.frame = photoImageViewFrame;
            
            
            if (self.message.bubbleMessageType == XHBubbleMessageTypeReceiving) {
                self.bubbleImageView.frame = CGRectMake(_bubblePhotoImageView.frame.origin.x-4 , _bubblePhotoImageView.frame.origin.y +5, _bubblePhotoImageView.frame.size.width+4 , _bubblePhotoImageView.frame.size.height -9);
            }else{
                self.bubbleImageView.frame = CGRectMake(_bubblePhotoImageView.frame.origin.x+2 , _bubblePhotoImageView.frame.origin.y +5, _bubblePhotoImageView.frame.size.width+4 , _bubblePhotoImageView.frame.size.height -9);
                
            }
            
            if (self.message.sended == Sending) {
                self.dpMeterView.hidden = NO;
                //                [self.dpMeterView.activeShow startAnimating];
            }else
            {
                self.dpMeterView.hidden = YES;
                //                [self.dpMeterView.activeShow stopAnimating];
            }
            
            [self.dpMeterView setFrame:self.bubblePhotoImageView.frame];
            [self.dpMeterView setNeedsDisplay];
            self.videoPlayImageView.hidden = YES;
            self.ratingView.hidden = YES;
            
            break;
        }
        case XHBubbleMessageMediaTypeLocalPosition: {
            self.ratingView.hidden = YES;
            CGRect photoImageViewFrame = CGRectMake(bubbleFrame.origin.x - 2, 0, bubbleFrame.size.width, bubbleFrame.size.height);
            self.bubblePhotoImageView.frame = photoImageViewFrame;
            
            self.videoPlayImageView.center = CGPointMake(CGRectGetWidth(photoImageViewFrame) / 2.0, CGRectGetHeight(photoImageViewFrame) / 2.0);
            
            CGRect geolocationsLabelFrame = CGRectMake(11, CGRectGetHeight(photoImageViewFrame) - 47, CGRectGetWidth(photoImageViewFrame) - 20, 40);
            self.geolocationsLabel.frame = geolocationsLabelFrame;
            
            break;
        }
        case XHBubbleMessageMediaTypeMedicineSpecialOffers:
        {
            CGRect bubbleFrameCopy = bubbleFrame;
            bubbleFrameCopy.size.height = MAX(35, bubbleFrameCopy.size.height);
            self.bubbleImageView.frame = bubbleFrameCopy;
            CGFloat textX = CGRectGetMinX(bubbleFrame) + kBubblePaddingRight;
            
            if (self.message.bubbleMessageType == XHBubbleMessageTypeReceiving) {
                textX += kXHArrowMarginWidth  - 5;
            }
            CGRect textFrame = CGRectMake(textX,
                                          CGRectGetMinY(bubbleFrame) + kPaddingTop + 2,
                                          CGRectGetWidth(bubbleFrame) - kBubblePaddingRight * 2 - kXHArrowMarginWidth,
                                          bubbleFrame.size.height - kMarginTop - kMarginBottom);
            if(textFrame.size.height <= 30) {
                textFrame.origin.y += 3;
            }
            
            if(self.message.bubbleMessageType == XHBubbleMessageTypeReceiving) {
            
                CGRect rect = self.activityTitle.frame;
                rect.origin.x = 21;
                rect.origin.y = 14;
                self.activityTitle.frame = rect;

                CGSize constrainedSize = CGSizeZero;
                if([self.message messageMediaType] == XHBubbleMessageMediaTypeDrugGuide) {
                    constrainedSize = CGSizeMake(260, 45);
                }else{
                    constrainedSize = CGSizeMake(190, 45);
                }
                
                CGSize size = [[_message title] sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:constrainedSize];
                rect = self.activityTitle.frame;
                rect.origin.x = 19;
                rect.size.height = ceilf(size.height);
                self.activityTitle.frame = rect;
                rect = self.activityImage.frame;
                rect.origin.x = 21 ;
                rect.origin.y = self.activityTitle.frame.origin.y + size.height + 8;
                self.activityImage.frame = rect;
                
                rect = self.activityContent.frame;
                rect.origin.x = 90;
                rect.origin.y = self.activityTitle.frame.origin.y + size.height + 4;
                rect.size.width = 125;
                rect.size.height = 65;
                self.activityContent.frame = rect;
            }else{
                
                CGRect rect = self.activityTitle.frame;
                rect.origin.x = 21 + 35;
                rect.origin.y = 14;
                self.activityTitle.frame = rect;
                
                CGSize constrainedSize = CGSizeZero;
                if([self.message messageMediaType] == XHBubbleMessageMediaTypeDrugGuide) {
                    constrainedSize = CGSizeMake(260, 45);
                }else{
                    constrainedSize = CGSizeMake(190, 45);
                }
                
                CGSize size = [[_message title] sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:constrainedSize];
                rect = self.activityTitle.frame;
                rect.origin.x = 19 + 35;
                rect.size.height = ceilf(size.height);
                self.activityTitle.frame = rect;
                rect = self.activityImage.frame;
                rect.origin.x = 21 + 35;
                rect.origin.y = self.activityTitle.frame.origin.y + size.height + 8;
                self.activityImage.frame = rect;
                
                rect = self.activityContent.frame;
                rect.origin.x = 90 + 35;
                rect.origin.y = self.activityTitle.frame.origin.y + size.height + 4;
                rect.size.width = 125;
                rect.size.height = 65;
                self.activityContent.frame = rect;
            }
            
            break;
        }
        case XHBubbleMessageMediaTypeMedicine:
        {
            CGRect bubbleFrameCopy = bubbleFrame;
            bubbleFrameCopy.size.height = MAX(35, bubbleFrameCopy.size.height);
            self.bubbleImageView.frame = bubbleFrameCopy;
            CGFloat textX = CGRectGetMinX(bubbleFrame) + kBubblePaddingRight + 30;
            
            CGRect textFrame = CGRectMake(textX,
                                          CGRectGetMinY(bubbleFrame) + kPaddingTop + 2,
                                          CGRectGetWidth(bubbleFrame) - kBubblePaddingRight * 2 - kXHArrowMarginWidth,
                                          bubbleFrame.size.height - kMarginTop - kMarginBottom);
            if(textFrame.size.height <= 30) {
                textFrame.origin.y += 3;
            }
            self.activityContent.textColor = RGBHex(qwColor6);
            if([self.message bubbleMessageType] == XHBubbleMessageTypeReceiving) {
                CGRect rect = CGRectZero;
                rect = self.activityImage.frame;
                rect.origin.x = 20;
                rect.origin.y = 19.5;
                self.activityImage.frame = rect;
                
                rect = self.activityContent.frame;
                rect.origin.x = 85;
                rect.origin.y = 12.5;
                rect.size.width = 125;
                rect.size.height = 65;
                self.activityContent.frame = rect;
                
                rect = self.checkImmediately.frame;
                rect.origin.x = 130;
                rect.origin.y = 70;
                self.checkImmediately.frame = rect;
            }else{
                CGRect rect = CGRectZero;
                rect = self.activityImage.frame;
                rect.origin.x = 21 + 30;
                rect.origin.y = 19.5;
                self.activityImage.frame = rect;
                
                rect = self.activityContent.frame;
                rect.origin.x = 90 + 30;
                rect.origin.y = 12.5;
                rect.size.width = 125;
                rect.size.height = 65;
                self.activityContent.frame = rect;
                
                rect = self.checkImmediately.frame;
                rect.origin.x = 120 + 30;
                rect.origin.y = 70;
                self.checkImmediately.frame = rect;
            }
            [self.activityTitle setTitleColor:RGBHex(qwColor6) forState:UIControlStateNormal];
            break;
        }
        case XHBubbleMessageMediaTypeLocation:
        {
            CGRect bubbleFrameCopy = bubbleFrame;
            bubbleFrameCopy.size.height = MAX(35, bubbleFrameCopy.size.height);
            self.bubbleImageView.frame = bubbleFrameCopy;
            CGFloat textX = CGRectGetMinX(bubbleFrame) + kBubblePaddingRight;
            
            if (self.message.bubbleMessageType == XHBubbleMessageTypeReceiving) {
                textX += kXHArrowMarginWidth  - 5;
            }
            CGRect textFrame = CGRectMake(textX,
                                          CGRectGetMinY(bubbleFrame) + kPaddingTop + 2,
                                          CGRectGetWidth(bubbleFrame) - kBubblePaddingRight * 2 - kXHArrowMarginWidth,
                                          bubbleFrame.size.height - kMarginTop - kMarginBottom);
            if(textFrame.size.height <= 30) {
                textFrame.origin.y += 3;
            }
            CGRect rect = CGRectZero;
            
            rect = self.activityImage.frame;
            rect.origin.x = 52;
            rect.origin.y = 19;
            self.activityImage.frame = rect;
            rect.origin.x = 120;
            rect.origin.y =  12.5;
            rect.size.width = 125;
            rect.size.height = 65;
            self.activityContent.frame = rect;
            
            
            break;
        }
        case XHBubbleMessageMediaTypeActivity:
        {
            CGRect bubbleFrameCopy = bubbleFrame;
            bubbleFrameCopy.size.height = MAX(35, bubbleFrameCopy.size.height);
            self.bubbleImageView.frame = bubbleFrameCopy;
            CGFloat textX = CGRectGetMinX(bubbleFrame) + kBubblePaddingRight;
            
            if (self.message.bubbleMessageType == XHBubbleMessageTypeReceiving) {
                textX += kXHArrowMarginWidth  - 5;
            }
            CGRect textFrame = CGRectMake(textX,
                                          CGRectGetMinY(bubbleFrame) + kPaddingTop + 2,
                                          CGRectGetWidth(bubbleFrame) - kBubblePaddingRight * 2 - kXHArrowMarginWidth,
                                          bubbleFrame.size.height - kMarginTop - kMarginBottom);
            if(textFrame.size.height <= 30) {
                textFrame.origin.y += 3;
            }
            CGRect rect = self.activityTitle.frame;
            rect.origin.x = 52;
            rect.origin.y = 14;
            self.activityTitle.frame = rect;
            CGSize size = [[_message title] sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:CGSizeMake(190, 45)];
            if(self.message.activityUrl == nil || [self.message.activityUrl isEqual:[NSNull null]] ||[self.message.activityUrl isEqualToString:@""])
            {
                rect = self.activityContent.frame;
                
                rect.origin.x = 52;
                rect.origin.y = self.activityTitle.frame.origin.y  + 2 + + size.height;
                rect.size.width = 190;
                rect.size.height = size.height;
                self.activityContent.frame = rect;
                
            }else{
                
                rect = self.activityImage.frame;
                rect.origin.x = 52;
                rect.origin.y = self.activityTitle.frame.origin.y + size.height + 8;
                self.activityImage.frame = rect;
                rect = self.activityContent.frame;
                rect.origin.x = 120;
                rect.origin.y = self.activityTitle.frame.origin.y + size.height + 4;
                rect.size.width = 125;
                rect.size.height = 65;
                self.activityContent.frame = rect;
            }
            
            break;
        }
        case XHBubbleMessageMediaTypeDrugGuide:
        {
            CGRect bubbleFrameCopy = bubbleFrame;
            bubbleFrameCopy.size.height = MAX(35, bubbleFrameCopy.size.height);
            self.bubbleImageView.frame = bubbleFrameCopy;
            CGFloat textX = CGRectGetMinX(bubbleFrame) + kBubblePaddingRight;
            
            if (self.message.bubbleMessageType == XHBubbleMessageTypeReceiving) {
                textX += kXHArrowMarginWidth  - 5;
            }
            
            CGRect titleFrame = self.activityTitle.frame;
            titleFrame.origin.x = 49;
            titleFrame.origin.y = 8;
            titleFrame.size = CGSizeMake(190, 45);
            self.activityTitle.frame = titleFrame;
            
            CGRect footFrame = self.footGuide.frame;
            footFrame.origin.y = bubbleFrameCopy.origin.y + bubbleFrameCopy.size.height - 26.5;
            footFrame.origin.x = 49;
            self.footGuide.frame = footFrame;
            
            CGRect textFrame = CGRectMake(textX,
                                          CGRectGetMinY(bubbleFrame) + kPaddingTop + 30,
                                          CGRectGetWidth(bubbleFrame) - kBubblePaddingRight * 2 - kXHArrowMarginWidth,
                                          bubbleFrame.size.height - kMarginTop - kMarginBottom);
            if(textFrame.size.height <= 30) {
                textFrame.origin.y += 3;
            }
            self.displayTextView.frame = CGRectIntegral(textFrame);
            [self.displayTextView sizeToFit];
            
            break;
        }
            
        default:
            break;
    }
    [self setSendType:self.sendType];
}

- (void)resetVoiceDurationLabelFrameWithBubbleFrame:(CGRect)bubbleFrame {
    CGRect voiceFrame = _voiceDurationLabel.frame;
    voiceFrame.origin.x = (self.message.bubbleMessageType == XHBubbleMessageTypeSending ? bubbleFrame.origin.x - _voiceDurationLabel.frame.size.width : bubbleFrame.origin.x + bubbleFrame.size.width);
    _voiceDurationLabel.frame = voiceFrame;
    
    _voiceDurationLabel.textAlignment = (self.message.bubbleMessageType == XHBubbleMessageTypeSending ? NSTextAlignmentRight : NSTextAlignmentLeft);
}
-(CGSize)photoSize
{
    CGSize  bubbleSize = CGSizeZero;
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    if ([imageCache diskImageExistsWithKey:self.message.UUID]) {
        
        UIImage *img2 =[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.message.UUID];
        bubbleSize = img2.size;
    }
    else{
        bubbleSize = [XHMessageBubbleView neededSizeForPhoto:self.message.photo];
    }
    return bubbleSize;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL result = CGRectContainsPoint(self.bubbleImageView.frame,point);
    if (!result) {
        result = CGRectContainsPoint(self.resendButton.frame, point);
    }
    if(!result) {
        [self.superParentViewController layoutOtherMenuViewHide:YES fromInputView:NO];
    }
    return result;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.superParentViewController.messages indexOfObject:self.message] inSection:0];
    XHMessageTableViewCell *cell = (XHMessageTableViewCell *)[self.superParentViewController.messageTableView cellForRowAtIndexPath:indexPath];
    [self.superParentViewController multiMediaMessageDidSelectedOnMessage:self.message atIndexPath:indexPath onMessageTableViewCell:cell];
}

@end
