//
//  IMAlertCouponMedicine.h
//  wenYao-store
//
//  Created by Yan Qingyang on 15/8/31.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseAlert.h"

@interface IMAlertCouponMedicine : QWBaseAlert
{
    IBOutlet UILabel *lblTTL,*lblSold;
    IBOutlet UIImageView *imgPhoto;
}
+(id)instance;
@end
