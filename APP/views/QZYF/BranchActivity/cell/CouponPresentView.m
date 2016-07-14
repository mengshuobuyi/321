//
//  CouponView.m
//  APP
//
//  Created by 李坚 on 15/8/18.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "CouponPresentView.h"

@implementation CouponPresentView
- (IBAction)couponClick:(id)sender {
    
    if(self.delegate){
        [self.delegate didSelectedAtIndex:self.tag];
    }
}



@end
