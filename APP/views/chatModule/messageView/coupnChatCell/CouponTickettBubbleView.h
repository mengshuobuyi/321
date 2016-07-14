//
//  CouponTickettBubbleView.h
//  wenYao-store
//
//  Created by Yan Qingyang on 15/8/28.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseChatBubbleView.h"
#define kCouponTickettBubbleView @"kCouponTickettBubbleView"
@interface CouponTickettBubbleView : BaseChatBubbleView
{
    IBOutlet UILabel *lblPrix,*lblPrix2,*lblCond,*lblAddress,*lblTime;
    IBOutlet UIImageView *imgMark,*imgGif,*imgPhoto,*imgTop;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftCon;
@property (weak, nonatomic) IBOutlet UILabel *scopeLabel;;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offsetCondition;

@end
