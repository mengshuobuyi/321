//
//  DrugChatBubbleView.m
//  APP
//
//  Created by caojing on 15/6/25.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "DrugChatBubbleView.h"
#import "UIImageView+WebCache.h"
#import "QWGlobalManager.h"
NSString *const kRouterEventDrugChat = @"kRouterEventDrugChat";
static CGFloat kWidth = 220;
static CGFloat kHeight = 80;
@implementation DrugChatBubbleView

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

- (IBAction)didDrugDetail:(id)sender { 
     [self bubbleViewPressed:sender];
}

+ (CGSize)sizeForBubbleWithObject:(MessageModel *)object
{
    //    return CGSizeMake(AutoValue(kWidth), AutoValue(kHeight));
    return CGSizeMake(kWidth, kHeight);
}

#pragma mark - setter
-(void)setMessageModel:(MessageModel *)messageModel
{
    [super setMessageModel:messageModel];
    [self.drugImage setImageWithURL:[NSURL URLWithString:messageModel.activityUrl] placeholderImage:[UIImage imageNamed:@"药品默认图片"] completed:nil];
    self.drugTitle.text = messageModel.text;
    self.drugSpec.text = messageModel.spec;
    
    if (messageModel.messageDeliveryType == MessageTypeSending) {
        
    } else {
        self.rightCon.constant = 12;
        self.leftCon.constant = 20;
    }
    
    [_drugDetail setTitleColor:RGBHex(qwColor2) forState:UIControlStateNormal];
    
    _drugTitle.font=fontSystem(kFontS4);
    _drugDetail.titleLabel.font=fontSystem(kFontS6);
}

#pragma mark - public
//+ (CGSize)sizeForBubbleWithObject:(MessageModel *)model
//{
//    CGSize size=[self configBubbleSize];
//    size.height=80;
//    CGFloat maxWidth = size.width;
//    size.width = maxWidth + kBubblePaddingRight * 2 + kXHArrowMarginWidth;
//    return size;
//}

- (void)bubbleViewPressed:(id)sender
{
    [self routerEventWithName:kRouterEventDrugChat userInfo:@{KMESSAGEKEY:self.messageModel}];
}

@end
