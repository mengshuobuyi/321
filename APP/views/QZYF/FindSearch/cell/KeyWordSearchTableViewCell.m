//
//  KeyWordSearchTableViewCell.m
//  APP
//
//  Created by 李坚 on 15/9/15.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "KeyWordSearchTableViewCell.h"

@implementation KeyWordSearchTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.VoucherImage.layer.masksToBounds = YES;
    self.VoucherImage.layer.cornerRadius = 2.5f;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
