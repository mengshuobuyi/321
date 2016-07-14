//
//  IMAlertCouponMedicine.m
//  wenYao-store
//
//  Created by Yan Qingyang on 15/8/31.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "IMAlertCouponMedicine.h"
#import "CoupnModel.h"
#import "UIImageView+WebCache.h"
@implementation IMAlertCouponMedicine

+(id)instance
{
    static id sharedInstance;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"IMAlertCouponMedicine" owner:nil options:nil];
        sharedInstance = [nibView objectAtIndex:0];
    });
    [sharedInstance UIInit];
    return sharedInstance;
}

- (void)UIInit{
    CGRect frm;
    frm=vBG.frame;
    frm.size.width=270;
    frm.size.height=142;
    vBG.frame=frm;
}

- (void)show:(id)obj block:(AlertSelectedBlock)block{
    [super show:nil block:block];
    
    DrugVo *mm=obj;
    lblSold.text=mm.label;
    lblTTL.text=mm.proName;
    
    [imgPhoto setImageWithURL:[NSURL URLWithString:mm.imgUrl] placeholderImage:[UIImage imageNamed:@"药品默认图片"] options:SDWebImageRetryFailed|SDWebImageContinueInBackground];
    
    lblSold.textColor=RGBHex(qwColor15);
    
}


@end
