//
//  IMAlertCoupon.m
//  wenYao-store
//
//  Created by Yan Qingyang on 15/8/31.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "IMAlertCoupon.h"
#import "CoupnModel.h"
#import "UIImageView+WebCache.h"
//static CGFloat kDur= .25;
@implementation IMAlertCoupon
+(id)instance
{
    static id sharedInstance;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"IMAlertCoupon" owner:nil options:nil];
        sharedInstance = [nibView objectAtIndex:0];
    });
    
    [sharedInstance UIInit];
    
    return sharedInstance;
}

- (void)UIInit{
    CGRect frm;
    frm=vBG.frame;
    frm.size.width=270;
    frm.size.height=195;
    vBG.frame=frm;
}



- (void)show:(id)obj block:(AlertSelectedBlock)block{
    [super show:nil block:block];
    
    lblPrix.textColor=RGBHex(qwColor13);
    
    
    BranchCouponVo *mm=obj;
    lblAddress.text=mm.groupName;
    lblCond.text=[NSString stringWithFormat:@" %@ ",mm.couponTag];
    lblPrix.text=mm.couponValue;
    lblTime.text=[NSString stringWithFormat:@"%@-%@",mm.begin,mm.end];

    
    CGSize sz;
    CGRect frm;
    
    lblTime.translatesAutoresizingMaskIntoConstraints = YES;
    lblTime.font=fontSystem(kFontS6);//fontSystem(AutoValue(kFontS6));
//    frm=lblTime.frame;
//    frm.size.height=18;//AutoValue(18);
//    frm.origin.x=28;//AutoValue(28);
//    frm.origin.y=CGRectGetMaxY(imgBG.frame)-frm.size.height;
//    lblTime.frame=frm;
    
    lblAddress.translatesAutoresizingMaskIntoConstraints = YES;
    lblAddress.font=fontSystem(kFontS5);//fontSystem(AutoValue(kFontS5));
//    frm=lblAddress.frame;
//    frm.size.height=16;//AutoValue(16);
//    frm.origin.x=28;//AutoValue(28);
//    frm.origin.y=CGRectGetMinY(lblTime.frame)-frm.size.height-10;//AutoValue(10);
//    lblAddress.frame=frm;
    
    lblPrix.translatesAutoresizingMaskIntoConstraints = YES;
    lblPrix.font=fontSystem(kFontS57);
    frm=lblPrix.frame;
    frm.size.height=44;//AutoValue(44);
    sz=[GLOBALMANAGER sizeText:lblPrix.text font:lblPrix.font limitHeight:frm.size.height];
    frm.size.width=sz.width;
    frm.origin.x=48;//AutoValue(48);
//    frm.origin.y=CGRectGetMinY(lblAddress.frame)-frm.size.height-12;//AutoValue(12);
    lblPrix.frame=frm;
    
    lblCond.translatesAutoresizingMaskIntoConstraints = YES;
    lblCond.font=fontSystem(kFontS6);
    frm=lblCond.frame;
    frm.size.height=13;//AutoValue(13);
    sz=[GLOBALMANAGER sizeText:lblCond.text font:lblCond.font limitHeight:lblCond.bounds.size.height];
    frm.size.width=sz.width;
    frm.origin.x = CGRectGetMaxX(lblPrix.frame)+9;//AutoValue(9);
//    frm.origin.y=CGRectGetMaxY(lblPrix.frame)-frm.size.height;
    lblCond.frame=frm;
    
    lblCond.layer.cornerRadius=frm.size.height/2;
    lblCond.clipsToBounds=YES;
    
    imgMark.hidden=YES;
    imgGif.hidden=YES;
    lblPrix.hidden=NO;
    imgPhoto.hidden=YES;
    unitLabel.hidden = NO;
    //1.通用代金券，2.慢病专享代金券，4.礼品券
    if (mm.scope.intValue==1) {
        
    }
    else if (mm.scope.intValue==2) {
        imgMark.hidden=NO;
    }
    else if (mm.scope.intValue==4) {
        unitLabel.hidden = YES;
        imgGif.hidden=NO;
        lblPrix.hidden=YES;
        imgPhoto.hidden=NO;
        [imgPhoto setImageWithURL:[NSURL URLWithString:mm.giftImgUrl] placeholderImage:[UIImage imageNamed:@"img_gift_default"] options:SDWebImageRetryFailed|SDWebImageContinueInBackground];
        
        lblPrix2.hidden=!lblPrix.hidden;
        lblPrix2.text=[NSString stringWithFormat:@"价值%@元",mm.couponValue];
        
        lblPrix2.translatesAutoresizingMaskIntoConstraints = YES;
        frm=lblPrix2.frame;
        frm.origin.x = CGRectGetMaxX(imgPhoto.frame)+9;
        lblPrix2.frame=frm;
        
        lblCond.translatesAutoresizingMaskIntoConstraints = YES;
        frm=lblCond.frame;
        frm.origin.x = CGRectGetMaxX(imgPhoto.frame)+9;
        lblCond.frame=frm;
    }
    
    lblPrix2.hidden=!lblPrix.hidden;
    
    imgTop.hidden=mm.top.intValue?NO:YES;
}





@end
