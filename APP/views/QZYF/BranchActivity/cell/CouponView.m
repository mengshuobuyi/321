//
//  CouponView.m
//  APP
//
//  Created by 李坚 on 15/8/18.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "CouponView.h"

@implementation CouponView
- (IBAction)couponClick:(id)sender {
    
    if(self.delegate){
        [self.delegate didSelectedAtIndex:self.tag];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
