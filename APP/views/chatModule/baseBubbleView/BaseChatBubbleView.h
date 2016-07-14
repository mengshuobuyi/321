//
//  BaseChatBubbleView.h
//  APP
//
//  Created by carret on 15/5/21.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIResponder+Router.h"
//#import "MessageModelProtocol.h"
#import "MessageModel.h"
#define kBubblePaddingRight 10.0f
#define kVoiceMargin 20.0f
#define kXHArrowMarginWidth 5

#define kMarginTop 8.0f
#define kMarginBottom 5.0f
#define kPaddingTop 4.0f
#define kBubblePaddingRight 10.0f

#define kVoiceMargin 20.0f

#define KTitleTop 9
#define KdesTop 41
#define KtextFrame 70
#define KpandingLeft 29
#define Kpandingright 43

#define ActivityTitleHeight             45

#define BUBBLE_LEFT_IMAGE_NAME @"chat_receiver_bg" // bubbleView 的背景图片
#define BUBBLE_RIGHT_IMAGE_NAME @"chat_sender_bg"
#define BUBBLE_ARROW_WIDTH 5 // bubbleView中，箭头的宽度
#define BUBBLE_VIEW_PADDING 8 // bubbleView 与 在其中的控件内边距

#define BUBBLE_RIGHT_LEFT_CAP_WIDTH 5 // 文字在右侧时,bubble用于拉伸点的X坐标
#define BUBBLE_RIGHT_TOP_CAP_HEIGHT 35 // 文字在右侧时,bubble用于拉伸点的Y坐标

#define BUBBLE_LEFT_LEFT_CAP_WIDTH 35 // 文字在左侧时,bubble用于拉伸点的X坐标
#define BUBBLE_LEFT_TOP_CAP_HEIGHT 35 // 文字在左侧时,bubble用于拉伸点的Y坐标

#define BUBBLE_PROGRESSVIEW_HEIGHT 10 // progressView 高度

#define KMESSAGEKEY @"message"

extern NSString *const kRouterEventChatCellBubbleTapEventName;

@interface BaseChatBubbleView : UIView
{
 
    MessageModel *_messageModel;
}

@property (nonatomic, strong) MessageModel *messageModel;

@property (nonatomic, strong) UIImageView *backImageView;

- (void)bubbleViewPressed:(id)sender;

+ (CGSize)sizeForBubbleWithObject:(MessageModel *)object;
+(CGSize )configBubbleSize;
@end
