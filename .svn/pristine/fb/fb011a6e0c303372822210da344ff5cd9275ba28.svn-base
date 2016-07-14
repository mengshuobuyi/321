//
//  TextChatBubbleView.m
//  APP
//
//  Created by caojing on 15/5/22.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "TextChatBubbleView.h"

NSString *const kRouterEventTextChat = @"kRouterEventTextChat";

@implementation TextChatBubbleView

- (void)awakeFromNib {
    self.autoresizingMask = UIViewAutoresizingNone;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.contentLable.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    self.contentLable.disableThreeCommon = YES;
    self.contentLable.numberOfLines=0;
    self.contentLable.customEmojiPlistName = @"expressionImage_custom.plist";
    self.contentLable.emojiDelegate = self;
    self.contentLable.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLable.isNeedAtAndPoundSign = YES;
    self.contentLable.font = [UIFont systemFontOfSize:14.0f];

}

-(void)layoutSubviews
{
    [super layoutSubviews];

}

#pragma mark - setter
-(void)setMessageModel:(MessageModel *)messageModel
{
    [super setMessageModel:messageModel];
    self.contentLable.emojiText = _messageModel.text;
    if (messageModel.messageDeliveryType == MessageTypeSending) {
        
    } else {
        self.rightCon.constant = 12;
        self.leftCon.constant = 20;
    }
}


#pragma mark - public
+ (CGSize)sizeForBubbleWithObject:(MessageModel *)model
{
    CGSize size=[self configBubbleSize];
    CGFloat maxWidth = size.width-32;
    CGSize textSize = [MLEmojiLabel needSizeWithText:model.text WithConstrainSize:CGSizeMake(maxWidth, MAXFLOAT)];
    return CGSizeMake(textSize.width+kTextPaddingRight * 2+kTextArrowMarginWidth , textSize.height+kTextPaddingTop*2);
    
}

- (void)bubbleViewPressed:(id)sender
{
    [self routerEventWithName:kRouterEventTextChat userInfo:@{KMESSAGEKEY:self.messageModel}];
}

@end
