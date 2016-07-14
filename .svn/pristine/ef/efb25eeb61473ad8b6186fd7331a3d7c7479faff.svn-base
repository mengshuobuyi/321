//
//  MarketingActivityTableViewCell.m
//  wenyao-store
//
//  Created by xiezhenghong on 14-10-22.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "MarketingActivityTableViewCell.h"
#import "Activity.h"

@implementation MarketingActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    UIView *selectedView = [[UIView alloc]initWithFrame:self.frame];
    selectedView.backgroundColor =RGBHex(qwColor11);
    self.selectedBackgroundView = selectedView;
    self.separatorLine.backgroundColor=RGBHex(qwColor10);
}
+ (CGFloat)getCellHeight:(id)data{
    return 104;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
