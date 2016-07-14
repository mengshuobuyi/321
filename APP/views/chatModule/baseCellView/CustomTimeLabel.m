//
//  CustomTimeLabel.m
//  APP
//
//  Created by PerryChen on 7/3/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import "CustomTimeLabel.h"

@implementation CustomTimeLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = {10, 2, 10, 2};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
