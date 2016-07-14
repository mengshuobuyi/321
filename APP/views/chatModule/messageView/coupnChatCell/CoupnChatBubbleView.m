//
//  CoupnChatBubbleView.m
//  APP
//
//  Created by caojing on 15/6/25.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "CoupnChatBubbleView.h"
#import "UIImageView+WebCache.h"
#import "QWGlobalManager.h"

@implementation CoupnChatBubbleView
NSString *const kRouterEventCoupnChat = @"kRouterEventCoupnChat";
- (void)awakeFromNib {
    self.autoresizingMask = UIViewAutoresizingNone;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleViewPressed:)];
    [self addGestureRecognizer:tap];
    self.backgroundColor = [UIColor clearColor];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
}

#pragma mark - setter
-(void)setMessageModel:(MessageModel *)messageModel
{
    [super setMessageModel:messageModel];
    [self.coupnImage setImageWithURL:[NSURL URLWithString:messageModel.activityUrl] placeholderImage:[UIImage imageNamed:@"药品默认图片"] completed:nil];
    self.coupnTitle.text = messageModel.title;
    self.coupnContent.text = messageModel.text;
    if (messageModel.messageDeliveryType == MessageTypeSending) {
        
    } else {
        self.rightCon.constant = 17;
        self.leftCon.constant = 20;
    }
}

#pragma mark - public
+ (CGSize)sizeForBubbleWithObject:(MessageModel *)model
{
    CGFloat wid = [self configBubbleSize].width;
    CGSize bubbleSize = CGSizeMake(wid, 65);
    CGSize constrainedSize = CGSizeMake(wid-29, ActivityTitleHeight);;
    CGSize size = [[model title] sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:constrainedSize];
    bubbleSize.height += size.height+17;
    bubbleSize.width += kBubblePaddingRight * 2 + kXHArrowMarginWidth;
    return bubbleSize;
}

- (void)bubbleViewPressed:(id)sender
{
    [self routerEventWithName:kRouterEventCoupnChat userInfo:@{KMESSAGEKEY:self.messageModel}];
}

@end
