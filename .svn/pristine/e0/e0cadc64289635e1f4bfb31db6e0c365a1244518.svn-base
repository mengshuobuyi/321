//
//  ExpertTableCell.m
//  APP
//
//  Created by Martin.Liu on 16/1/14.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ExpertTableCell.h"
#import "Forum.h"
#import "UIImageView+WebCache.h"
@interface ExpertTableCell()

@property (strong, nonatomic) IBOutlet UIImageView *expertImageView;
@property (strong, nonatomic) IBOutlet UILabel *expertNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *expertPositionImageView;
@property (strong, nonatomic) IBOutlet UILabel *expertRemarkLabel;
@property (strong, nonatomic) IBOutlet UILabel *postCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *replyCountLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_infoViewTrailing; // default is 15 ,  aother is 60;

@end

@implementation ExpertTableCell

- (void)awakeFromNib {
    self.expertImageView.image = ForumDefaultImage;
    self.chooseBtn.userInteractionEnabled = NO;
    self.expertImageView.layer.masksToBounds = YES;
    self.expertImageView.layer.cornerRadius = CGRectGetHeight(self.expertImageView.frame)/2;
    [self showChooseBtn:NO];
}

- (void)showChooseBtn:(BOOL)show
{
    if (show) {
        self.chooseBtn.hidden = NO;
        self.constraint_infoViewTrailing.constant = 60;
    }
    else
    {
        self.chooseBtn.hidden = YES;
        self.constraint_infoViewTrailing.constant = 15;
    }
}

- (void)setCell:(id)obj
{
    if ([obj isKindOfClass:[QWExpertInfoModel class]]) {
        QWExpertInfoModel* expert = obj;
        [self.expertImageView setImageWithURL:[NSURL URLWithString:expert.headImageUrl] placeholderImage:ForumDefaultImage];
        self.expertNameLabel.text = expert.nickName;
        if (expert.userType == PosterType_YingYangShi) {
            self.expertPositionImageView.image = [UIImage imageNamed:@"ic_expert"];
            self.expertRemarkLabel.text = @"营养师";
        }
        else
        {
            self.expertRemarkLabel.text = expert.groupName;
            self.expertPositionImageView.image = [UIImage imageNamed:@"pharmacist"];
        }
        self.postCountLabel.text = [NSString stringWithFormat:@"%ld", expert.postCount];
        self.replyCountLabel.text = [NSString stringWithFormat:@"%ld", expert.replyCount];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
