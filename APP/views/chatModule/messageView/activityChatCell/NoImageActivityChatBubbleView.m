//
//  NoImageActivityChatBubbleView.m
//  APP
//
//  Created by YYX on 15/5/22.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "NoImageActivityChatBubbleView.h"

NSString *const kRouterEventNoImageActivityBubbleTapEventName = @"kRouterEventNoImageActivityBubbleTapEventName";



@implementation NoImageActivityChatBubbleView

- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleViewPressed:)];
    [self addGestureRecognizer:tap];
    self.backgroundColor = [UIColor clearColor];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        NSArray *array = [[NSBundle mainBundle ] loadNibNamed:@"NoImageActivityChatBubbleView" owner:self options:nil];
        self = array[0];
        self.activityTitle.numberOfLines = 2;
        self.activityContent.numberOfLines = 4;
    }
    return self;
}

#pragma mark - setter
-(void)setMessageModel:(MessageModel *)messageModel
{
    [super setMessageModel:messageModel];
    
    self.activityTitle.text = messageModel.title;
    self.activityContent.text = messageModel.text;
    
    if (messageModel.messageDeliveryType == MessageTypeSending) {
        
    }else{
        CGFloat left = self.bgLeftConstraint.constant;
        CGFloat right = self.bgRightConstraint.constant;
        self.bgLeftConstraint.constant = 15+5;
        self.bgRightConstraint.constant = 10+3;
    }
}



#pragma mark - public

-(void)bubbleViewPressed:(id)sender
{
    [self routerEventWithName:kRouterEventNoImageActivityBubbleTapEventName userInfo:@{KMESSAGEKEY:self.messageModel}];
}

+(CGSize)sizeForBubbleWithObject:(MessageModel *)model
{
    CGFloat wid = [self configBubbleSize].width - 20;
    
    NSString *content = model.text;
    CGSize constrainedSize = CGSizeMake(wid, ActivityTitleHeight);;
    CGSize bubbleSize = CGSizeZero;
    
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:CGSizeMake(wid, 65)];
    CGFloat maxWidth = wid;
    bubbleSize.width = maxWidth + kBubblePaddingRight * 2 + kXHArrowMarginWidth;
    
    CGSize titleSize = [[model title] sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:constrainedSize];
    
    bubbleSize.height += titleSize.height + kMarginTop + size.height+10;
    return bubbleSize;
}


@end
