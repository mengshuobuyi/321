//
//  MARTextField.m
//  wenYao-store
//
//  Created by Martin.Liu on 16/5/13.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "MARTextField.h"

@implementation MARTextField

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
