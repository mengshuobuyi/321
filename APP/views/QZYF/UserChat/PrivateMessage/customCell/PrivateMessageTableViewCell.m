//
//  PrivateMessageTableViewCell.m
//  wenYao-store
//
//  Created by 李坚 on 16/3/4.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "PrivateMessageTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation PrivateMessageTableViewCell

+ (CGFloat)getCellHeight:(id)sender{
    
    return 84.0f;
}

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.unreadLabel.layer.masksToBounds    = YES;
    self.unreadLabel.layer.cornerRadius     = 10.0f;
    
    self.imgUrl.layer.masksToBounds         = YES;
    self.imgUrl.layer.cornerRadius          = 26.0f;
    self.imgUrl.image = [UIImage imageNamed:@"药店默认头像"];

//    self.userNameLabel.text     = @"";
//    self.timeLabel.text         = @"";
//    self.finalContentLabel.text = @"";
//    [self.imgUrl setImage:[UIImage imageNamed:@""]];
}

- (void)setCell:(NSString *)model{
    
    [self.imgUrl setImageWithURL:[NSURL URLWithString:model] placeholderImage:[UIImage imageNamed:@""]];
    self.userNameLabel.text     = model;
    self.timeLabel.text         = model;
    self.finalContentLabel.text = model;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
