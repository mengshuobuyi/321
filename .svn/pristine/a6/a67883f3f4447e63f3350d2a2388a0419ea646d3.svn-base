//
//  CouponTickettBubbleView.m
//  wenYao-store
//
//  Created by Yan Qingyang on 15/8/28.
//  Copyright (c) 2015年 carret. All rights reserved.
//
#import "GlobalManager.h"
#import "CouponTickettBubbleView.h"
#import "UIImageView+WebCache.h"

static CGFloat kWidth = 220;
static CGFloat kHeight = 100;
//NSString *const kCouponTickettBubbleView = @"kCouponTickettBubbleView";


@implementation CouponTickettBubbleView

- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleViewPressed:)];
    [self addGestureRecognizer:tap];
    self.backgroundColor = [UIColor clearColor];
    
    lblCond.layer.cornerRadius=5;
    lblCond.clipsToBounds=YES;
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
    
    if (model.messageDeliveryType == MessageTypeSending) {
        
    } else {
        self.rightCon.constant = 12;
        self.leftCon.constant = 0;
    }
    
//    DebugLog(@"%@",model);
    lblAddress.text=model.subTitle;
    lblCond.text=[NSString stringWithFormat:@" %@ ",model.text];
    lblPrix.text=[NSString stringWithFormat:@"%@元",model.richBody];
    lblTime.text=[NSString stringWithFormat:@"%@-%@",model.arrList.firstObject,model.arrList.lastObject];
    
    imgPhoto.hidden = YES;
    
    //1.通用代金券，2.慢病专享代金券，4.礼品券
    if (model.style.intValue==1) {
        //通用代金券
        lblPrix2.hidden = YES;
        lblPrix.hidden = NO;
        _offsetCondition.constant = 0;
        self.scopeLabel.text = @"";
    }else if (model.style.intValue==2) {
        //慢病
        lblPrix2.hidden = YES;
        lblPrix.hidden = NO;
        self.scopeLabel.text = @"慢病";
        _offsetCondition.constant = 0;
    }else if (model.style.intValue==4) {
        //礼品券
        lblPrix2.hidden = NO;
        lblPrix.hidden = YES;
        self.scopeLabel.text = @"礼品";
        imgPhoto.hidden = NO;
        [imgPhoto setImageWithURL:[NSURL URLWithString:model.thumbnailUrl] placeholderImage:[UIImage imageNamed:@"img_gift_default"] options:SDWebImageRetryFailed|SDWebImageContinueInBackground];
        _offsetCondition.constant = 55;
        lblPrix2.text=[NSString stringWithFormat:@"价值%@元",model.richBody];
    }else if(model.style.intValue==5){
        self.scopeLabel.text = @"商品";
        lblPrix2.hidden = YES;
        lblPrix.hidden = NO;
        _offsetCondition.constant = 0;
    }else{
        lblPrix2.hidden = YES;
        lblPrix.hidden = NO;
        self.scopeLabel.text = @"";
        _offsetCondition.constant = 0;
    }
    
}

- (void)bubbleViewPressed:(id)sender
{
    [self routerEventWithName:kCouponTickettBubbleView userInfo:@{KMESSAGEKEY:self.messageModel}];
}
@end
