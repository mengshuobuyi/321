//
//  MATextField.m
//  hengyoumi
//
//  Created by Martin.Liu on 15/4/24.
//  Copyright (c) 2015年 Movitech. All rights reserved.
//

#import "MATextField.h"

@implementation MATextField

- (instancetype)init
{
    if ([super init]) {
        self.hasMenu = YES;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (self.hasMenu) {
        return [super canPerformAction:action withSender:sender];
    }
    return NO;
}

@end
