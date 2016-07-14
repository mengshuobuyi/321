//
//  OrganInfoEditCell.m
//  wenYao-store
//
//  Created by YYX on 15/8/19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "OrganInfoEditCell.h"

@implementation OrganInfoEditCell

- (void)UIGlobal
{
    [super UIGlobal];
    self.separatorLine.backgroundColor = RGBHex(0xdbdbdb);
}

// 点击定位
- (IBAction)clickLocation:(id)sender
{
    if (self.organInfoEditCellDelegaet && [self.organInfoEditCellDelegaet respondsToSelector:@selector(locationAction)]) {
        [self.organInfoEditCellDelegaet locationAction];
    }
}
@end
