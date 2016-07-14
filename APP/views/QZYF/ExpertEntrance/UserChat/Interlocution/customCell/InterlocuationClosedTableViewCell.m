//
//  InterlocuationClosedTableViewCell.m
//  wenYao-store
//
//  Created by 李坚 on 16/3/9.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "InterlocuationClosedTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation InterlocuationClosedTableViewCell

+ (CGFloat)getCellHeight:(id)sender{
    
    return 95.0f;
}

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.imgUrl.layer.masksToBounds = YES;
    self.imgUrl.layer.cornerRadius = 16.5f;
    self.imgUrl.image = [UIImage imageNamed:@"药店默认头像"];
}

- (void)setCell:(QAListVO *)model{
    
    [self.imgUrl setImageWithURL:[NSURL URLWithString:model.headImgUrl] placeholderImage:[UIImage imageNamed:@""]];
    self.userNameLabel.text = model.name;
    self.timeLabel.text = model.responseLast;
    self.chatContentLabel.text = model.responseLastContent;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
