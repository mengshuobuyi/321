//
//  IMAlertCoupon.h
//  wenYao-store
//
//  Created by Yan Qingyang on 15/8/31.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseAlert.h"

@interface IMAlertCoupon : QWBaseAlert
{
    IBOutlet UILabel *lblPrix,*lblPrix2,*lblCond,*lblAddress,*lblTime,*unitLabel;
    IBOutlet UIImageView *imgMark,*imgBG,*imgGif,*imgPhoto,*imgTop;
}
+(id)instance;
@end
