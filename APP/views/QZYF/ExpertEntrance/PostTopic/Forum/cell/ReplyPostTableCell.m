//
//  ReplyPostTableCell.m
//  APP
//
//  Created by Martin.Liu on 16/1/12.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ReplyPostTableCell.h"
#import "Forum.h"
#import "UIImageView+WebCache.h"
#import "UILabel+MAAttributeString.h"
@interface ReplyPostTableCell()
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *postTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *userLevelLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) IBOutlet UILabel *postTitlelabel;


@end

@implementation ReplyPostTableCell

- (void)awakeFromNib {
    self.userLevelLabel.layer.masksToBounds = YES;
    self.userLevelLabel.layer.cornerRadius = 4;
    
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.cornerRadius = CGRectGetHeight(self.userImageView.frame)/2;
}

- (void)setCell:(id)obj
{
    if ([obj isKindOfClass:[QWPostReply class]]) {
        QWPostReply* postReply = obj;
        [self.userImageView setImageWithURL:[NSURL URLWithString:postReply.headUrl] placeholderImage:ForumDefaultImage];
        self.userNameLabel.text = postReply.nickName;
        self.postTimeLabel.text = postReply.createDate;
        self.userLevelLabel.text = [NSString stringWithFormat:@"V%ld", postReply.mbrLvl];
        [self.commentLabel ma_setAttributeText:postReply.content];
        self.postTitlelabel.text = [NSString stringWithFormat:@"帖子：%@", postReply.postTitle];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
