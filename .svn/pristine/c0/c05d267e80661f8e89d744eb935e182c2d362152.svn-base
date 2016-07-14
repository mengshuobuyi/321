//
//  SymBaseInfroCell.m
//  quanzhi
//
//  Created by Meng on 14-8-11.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "SymBaseInfroCell.h"
#import "Constant.h"
@implementation SymBaseInfroCell

- (void)awakeFromNib
{
    self.layer.borderWidth = 0.8f;
    self.layer.borderColor = RGBHex(qwColor11).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)expandContent:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickExpandEventWithIndexPath:)]) {
        //[self changeArrowWithUp:self.isExpand];
        [self.delegate clickExpandEventWithIndexPath:self];
    }
}
- (void)changeArrowWithUp:(BOOL)up{
    if (up) {
        self.arrowImageView.image = [UIImage imageNamed:@"arr_up"];
    }else
    {
        self.arrowImageView.image = [UIImage imageNamed:@"arr_down"];
    }
}
@end
