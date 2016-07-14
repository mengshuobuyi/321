//
//  HomePageTableViewCell.m
//  wenyao
//
//  Created by Pan@QW on 14-9-25.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "HomePageTableViewCell.h"

@implementation HomePageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = [self.titleLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:15.0f]];
    CGRect rect = self.titleLabel.frame;
    rect.size = size;
    rect.size.width += 10;
    self.titleLabel.frame = rect;
    rect = self.nameIcon.frame;
    rect.origin.x = self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width-4 ;
    rect.size = self.nameIcon.image.size;
    self.nameIcon.frame = rect;
    self.lineView.frame=CGRectMake(self.lineView.frame.origin.x, self.lineView.frame.origin.y, self.lineView.frame.size.width, 0.5);
}

@end
