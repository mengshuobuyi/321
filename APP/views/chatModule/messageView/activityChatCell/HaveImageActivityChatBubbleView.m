//
//  HaveImageActivityChatBubbleView.m
//  APP
//
//  Created by YYX on 15/5/22.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "HaveImageActivityChatBubbleView.h"
#import "UIImageView+WebCache.h"
#import "QWGlobalManager.h"
#import "BaseChatBubbleView.h"
NSString *const kRouterEventHaveImageActivityBubbleTapEventName = @"kRouterEventHaveImageActivityBubbleTapEventName";


@implementation HaveImageActivityChatBubbleView

- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
    self.translatesAutoresizingMaskIntoConstraints = NO;
        
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleViewPressed:)];
    [self addGestureRecognizer:tap];
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - setter
-(void)setMessageModel:(MessageModel *)messageModel
{
    [super setMessageModel:messageModel];
    [self.activityImage setImageWithURL:[NSURL URLWithString:messageModel.activityUrl] placeholderImage:[UIImage imageNamed:@"药品默认图片"] completed:nil];
    self.activityTitle.text = messageModel.title;
    self.activityContent.text = messageModel.text;
    
    if (messageModel.messageDeliveryType == MessageTypeSending) {
        
    }else{
//        CGFloat left = self.bgLeftConstraint.constant;
//        CGFloat right = self.bgRightConstraint.constant;
        self.bgLeftConstraint.constant = 15+5;
        self.bgRightConstraint.constant = 12+5;
    }
}


#pragma mark - public

-(void)bubbleViewPressed:(id)sender
{
    [self routerEventWithName:kRouterEventHaveImageActivityBubbleTapEventName userInfo:@{KMESSAGEKEY:self.messageModel}];
}

+(CGSize)sizeForBubbleWithObject:(MessageModel *)model
{
    CGFloat wid = [self configBubbleSize].width - 20;
    CGSize bubbleSize = CGSizeMake(wid, 65);
    CGSize constrainedSize = CGSizeMake(wid, ActivityTitleHeight);;
    CGSize size = [[model title] sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:constrainedSize];
    bubbleSize.height += size.height+16;
    bubbleSize.width += kBubblePaddingRight * 2 + kXHArrowMarginWidth;
    return bubbleSize;
}


@end
