//
//  CouponMedicineBubbleView.m
//  wenYao-store
//
//  Created by Yan Qingyang on 15/8/28.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "CouponMedicineBubbleView.h"
#import "UIImageView+WebCache.h"
static CGFloat kWidth = 220;
static CGFloat kHeight = 100;


@implementation CouponMedicineBubbleView

- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleViewPressed:)];
    [self addGestureRecognizer:tap];
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - public
+ (CGSize)sizeForBubbleWithObject:(MessageModel *)object
{
//    return CGSizeMake(AutoValue(kWidth), AutoValue(kHeight));
    return CGSizeMake(kWidth, kHeight);
}

-(void)setMessageModel:(MessageModel *)model
{
    [super setMessageModel:model];
//    DebugLog(@"%@",model);
    if (model.messageDeliveryType == MessageTypeSending) {
        
    } else {
        self.rightCon.constant = 12;
        self.leftCon.constant = 20;
    }
    
    lblSold.text=model.subTitle;
    lblTitle.text=model.text;
   
    [imgPhoto setImageWithURL:[NSURL URLWithString:model.activityUrl] placeholderImage:[UIImage imageNamed:@"药品默认图片"] options:SDWebImageRetryFailed|SDWebImageContinueInBackground];
    
    lblSold.textColor=RGBHex(qwColor2);
    [btnClick setTitleColor:RGBHex(qwColor2) forState:UIControlStateNormal];
    
    lblTitle.font=fontSystem(kFontS4);
    lblSold.font=fontSystem(kFontS2);
    btnClick.titleLabel.font=fontSystem(kFontS6);
}

- (void)bubbleViewPressed:(id)sender
{
    [self routerEventWithName:kCouponMedicineBubbleView userInfo:@{KMESSAGEKEY:self.messageModel}];
}
@end
