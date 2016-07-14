//
//  MAVrLineWithOnePix.m
//  tcmerchant
//
//  Created by Martin.Liu on 15/7/5.
//  Copyright (c) 2015年 TC. All rights reserved.
//

#import "MAVrLineWithOnePix.h"
#import "ConstraintsUtility.h"
@implementation MAVrLineWithOnePix
- (void)awakeFromNib
{
    PREPCONSTRAINTS(self);
    MA_INSTALL_ONEPIXWIDTH_INTOVIEWS(@[self]);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
