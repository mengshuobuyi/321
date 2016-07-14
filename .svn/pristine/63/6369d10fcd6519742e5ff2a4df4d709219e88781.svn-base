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
    self.unreadLabel.font                   = fontSystem(kFontS5);
    self.unreadLabel.layer.masksToBounds    = YES;
    self.unreadLabel.layer.cornerRadius     = 4.0f;
    self.unreadLabel.text = @"";
    self.imgUrl.layer.masksToBounds         = YES;
    self.imgUrl.layer.cornerRadius          = 26.0f;
    self.imgUrl.image = [UIImage imageNamed:@"expert_ic_people"];

}

- (void)setCell:(IMChatPointVo *)model{
    
    [self.imgUrl setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:@"expert_ic_people"]];
    self.userNameLabel.text     = model.nickname;
    self.doctorImage.hidden     = YES;
    self.timeLabel.text         = model.displayDate;
    
    
    self.finalContentLabel.text = model.respond;
    
    if([model.readFlag boolValue]){
        self.unreadLabel.hidden = YES;
    }else{
        self.unreadLabel.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
