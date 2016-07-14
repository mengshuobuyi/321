//
//  BaseChatBubbleView.m
//  APP
//
//  Created by carret on 15/5/21.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseChatBubbleView.h"

NSString *const kRouterEventChatCellBubbleTapEventName = @"kRouterEventChatCellBubbleTapEventName";
@interface BaseChatBubbleView ()

@end
@implementation BaseChatBubbleView



- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.userInteractionEnabled = YES;
        _backImageView.multipleTouchEnabled = YES;
        _backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_backImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleViewPressed:)];
        [self addGestureRecognizer:tap];
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - setter
-(void)setMessageModel:(MessageModel *)messageModel
{
    _messageModel = messageModel;
    
    BOOL isReceiver = !_messageModel.sender;
    NSString *imageName = isReceiver ? BUBBLE_LEFT_IMAGE_NAME : BUBBLE_RIGHT_IMAGE_NAME;
    NSInteger leftCapWidth = isReceiver?BUBBLE_LEFT_LEFT_CAP_WIDTH:BUBBLE_RIGHT_LEFT_CAP_WIDTH;
    NSInteger topCapHeight =  isReceiver?BUBBLE_LEFT_TOP_CAP_HEIGHT:BUBBLE_RIGHT_TOP_CAP_HEIGHT;
    self.backImageView.image = [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
}


#pragma mark - public

+ (CGSize)sizeForBubbleWithObject:(MessageModel *)object
{
    CGSize size = CGSizeMake(APP_W, 30);
    return size;
}
+(CGSize )configBubbleSize
{
    CGSize size = CGSizeZero;
    size.width = APP_W*.65;
    return size;
}
- (void)bubbleViewPressed:(id)sender
{
    [self routerEventWithName:kRouterEventChatCellBubbleTapEventName userInfo:@{KMESSAGEKEY:self.messageModel}];
}

- (void)progress:(CGFloat)progress
{
//    [_progressView setProgress:progress animated:YES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
