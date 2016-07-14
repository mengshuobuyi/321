//
//  EmployInfoCell.m
//  wenyao-store
//
//  Created by Meng on 15/3/13.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import "EmployInfoCell.h"

@implementation EmployInfoCell

- (void)awakeFromNib {
    // Initialization code
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, APP_W, 0.5)];
    line.backgroundColor = RGBHex(qwColor10);
    [self.contentView addSubview:line];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
