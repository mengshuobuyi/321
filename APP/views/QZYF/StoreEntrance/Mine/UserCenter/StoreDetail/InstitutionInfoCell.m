//
//  InstitutionInfoCell.m
//  wenYao-store
//
//  Created by qwfy0006 on 15/3/30.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "InstitutionInfoCell.h"

@implementation InstitutionInfoCell

@synthesize title = title;
@synthesize content = content;

- (void)UIGlobal
{
    [super UIGlobal];
    self.content.textColor = RGBHex(qwColor6);
    self.separatorLine.backgroundColor = RGBHex(qwColor10);
    self.contentView.backgroundColor = RGBHex(qwColor4);
    [self setSeparatorMargin:15 edge:EdgeLeft];
}

@end
