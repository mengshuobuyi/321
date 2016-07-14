//
//  LocationChatBubbleView.m
//  APP
//
//  Created by caojing on 15/5/22.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "LocationChatBubbleView.h"


NSString *const kRouterEventLocationChat = @"kRouterEventLocationChat";
#define LocationBubbleHeight       73

@implementation LocationChatBubbleView

- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
    self.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UITapGestureRecognizer *tapLocation = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleViewLocationPressed:)];
    [self addGestureRecognizer:tapLocation];
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - setter
-(void)setMessageModel:(MessageModel *)messageModel
{
    [super setMessageModel:messageModel];
    self.addressLable.text=messageModel.text;
    [self.mapImage setImage:[UIImage imageNamed:@"mapIcon.png"]];
    if (messageModel.messageDeliveryType == MessageTypeSending) {
        
    } else {
        self.rightCon.constant = 12;
        self.leftCon.constant = 18;
    }
}

#pragma mark - public

+ (CGSize)sizeForBubbleWithObject:(MessageModel *)object
{
     return CGSizeMake(220, LocationBubbleHeight);

}

- (void)bubbleViewPressed:(id)sender
{
    [self routerEventWithName:kRouterEventLocationChat userInfo:@{KMESSAGEKEY:self.messageModel}];
}


- (void)bubbleViewLocationPressed:(id)sender
{
    [self routerEventWithName:kRouterEventLocationChat userInfo:@{KMESSAGEKEY:self.messageModel}];
}

- (void)progress:(CGFloat)progress
{
    //    [_progressView setProgress:progress animated:YES];
}

@end
