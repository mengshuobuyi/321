//
//  testFrame.m
//  APP
//
//  Created by carret on 15/5/27.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "testFrame.h"

@implementation testFrame

- (void)awakeFromNib
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews
{
    NSLog(@"%f",self.frame.size.height);
}


@end
