//
//  InterlocutionTableViewCell.m
//  wenYao-store
//
//  Created by 李坚 on 16/3/4.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "InterlocutionTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation InterlocutionTableViewCell

+ (CGFloat)getCellHeight:(id)sender{
    
    return 140.0f;
}

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.imgUrl.layer.masksToBounds = YES;
    self.imgUrl.layer.cornerRadius = 16.5f;
    self.imgUrl.image = [UIImage imageNamed:@"药店默认头像"];
    
    [self.ignoreBtn addTarget:self action:@selector(ignoreAction:) forControlEvents:UIControlEventTouchDown];
    [self.answerBtn addTarget:self action:@selector(answerAction:) forControlEvents:UIControlEventTouchDown];
}

- (void)setCell:(NSString *)model{
    
    [self.imgUrl setImageWithURL:[NSURL URLWithString:model] placeholderImage:[UIImage imageNamed:@""]];
    self.userNameLabel.text = model;
    self.timeLabel.text = model;
    self.chatContentLabel.text = model;
}

- (void)ignoreAction:(id)sender{
    if(self.btnDelegate){
        [self.btnDelegate ignoreMessageAtIndexPath:_path];
    }
}

- (void)answerAction:(id)sender{
    if(self.btnDelegate){
        [self.btnDelegate answerMessageAtIndexPath:_path];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
