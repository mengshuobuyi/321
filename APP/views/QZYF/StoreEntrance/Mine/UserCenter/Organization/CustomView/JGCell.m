//
//  JGCell.m
//  wenyao-store
//
//  Created by Meng on 14-10-23.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "JGCell.h"
#import "Constant.h"

@implementation JGCell

- (void)awakeFromNib
{
    // Initialization code
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, APP_W, 0.5)];
    line.backgroundColor = RGBHex(qwColor10);
    [self.contentView addSubview:line];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
