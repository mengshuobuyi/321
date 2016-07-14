//
//  OrganLocationCell.m
//  wenYao-store
//
//  Created by YYX on 15/8/22.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "OrganLocationCell.h"
#import "PoisModel.h"

@implementation OrganLocationCell

- (void)configureData:(id)data
{
    PoisModel *mod = (PoisModel *)data;
    self.addressTitle.text = mod.name;
    self.addressDetail.text = mod.address;
}

- (void)UIGlobal
{
    [super UIGlobal];
    self.separatorLine.backgroundColor = RGBHex(0xdbdbdb);
    [self setSeparatorMargin:15 edge:EdgeLeft];
}

@end
