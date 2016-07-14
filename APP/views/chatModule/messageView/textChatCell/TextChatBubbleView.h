//
//  TextChatBubbleView.h
//  APP
//
//  Created by caojing on 15/5/22.
//  Copyright (c) 2015年 carret. All rights reserved.
//

//TextChatBubbleView 的xib文件是发出去的，TextChatGetBubbleView是获取的
#import <UIKit/UIKit.h>
#import "BaseChatBubbleView.h"
#import "MLEmojiLabel.h"

extern NSString *const kRouterEventTextChat;
#define kTextPaddingTop 8.0f
#define kTextPaddingRight 12.0f
#define kTextArrowMarginWidth 8.0f
@interface TextChatBubbleView : BaseChatBubbleView<MLEmojiLabelDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftCon;
@property (weak, nonatomic) IBOutlet MLEmojiLabel *contentLable;
@end
