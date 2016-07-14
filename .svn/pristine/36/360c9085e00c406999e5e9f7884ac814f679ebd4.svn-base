//
//  UserCenterCell.m
//  APP
//
//  Created by qwfy0006 on 15/3/17.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "UserCenterCell.h"

@implementation UserCenterCell

@synthesize title = title;
@synthesize icon = icon;
@synthesize budge = budge;

+ (CGFloat)getCellHeight:(id)data{
    return 46;
}
- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)UIGlobal{
    [super UIGlobal];
    
    self.budge.layer.cornerRadius = 4.0f;
    self.budge.layer.masksToBounds = YES;

    self.separatorLine.backgroundColor = RGBHex(qwColor10);
    [self setSeparatorMargin:15 edge:EdgeLeft];
}

@end
