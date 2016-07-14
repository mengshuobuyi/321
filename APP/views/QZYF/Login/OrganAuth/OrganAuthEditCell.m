//
//  OrganAuthEditCell.m
//  wenYao-store
//
//  Created by YYX on 15/8/19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "OrganAuthEditCell.h"

@implementation OrganAuthEditCell

- (void)awakeFromNib
{

}

- (void)UIGlobal
{
    [super UIGlobal];
    self.separatorLine.backgroundColor = RGBHex(qwColor10);
}

- (IBAction)provinceAndCityUp:(id)sender
{
    if (self.organAuthEditCellDelegate && [self.organAuthEditCellDelegate respondsToSelector:@selector(provinceAndCityUp)]) {
        [self.organAuthEditCellDelegate provinceAndCityUp];
    }
}
@end
