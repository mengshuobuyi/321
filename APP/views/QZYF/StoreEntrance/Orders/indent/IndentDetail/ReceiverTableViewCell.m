//
//  ReceiverTableViewCell.m
//  APP
//
//  Created by qw_imac on 15/12/29.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "ReceiverTableViewCell.h"

@implementation ReceiverTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _memberBtn.layer.cornerRadius = 3.0;
    _memberBtn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
