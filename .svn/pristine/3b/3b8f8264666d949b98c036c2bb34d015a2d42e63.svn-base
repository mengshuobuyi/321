//
//  CommonTableViewCell.m
//  wenYao-store
//
//  Created by caojing on 15/8/24.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "CommonTableViewCell.h"

@implementation CommonTableViewCell


+ (CGFloat)getCellHeight:(id)data{
    
    return 58.0f;
}

- (void)awakeFromNib {

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.bgView.backgroundColor = RGBHex(qwColor10);
    }else{
        self.bgView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
