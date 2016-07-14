//
//  LcenseListCell.m
//  wenYao-store
//
//  Created by qwfy0006 on 15/4/2.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "LcenseListCell.h"

@implementation LcenseListCell
@synthesize lbl_lcense = lbl_lcense;
@synthesize img_isfinish = img_isfinish;

+ (CGFloat)getCellHeight:(id)data{
    
    return 80;
}

- (void)UIGlobal{
    [super UIGlobal];
    self.separatorLine.hidden = YES;
    self.lbl_lcense.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f];
}

- (void)setCell:(id)data{
    [self UIGlobal];
    [super setCell:data];
   
}

@end
