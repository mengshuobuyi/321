//
//  CirclerTableCell.m
//  APP
//
//  Created by Martin.Liu on 16/1/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "CirclerTableCell.h"
#import "Forum.h"
#import "UIImageView+WebCache.h"
@interface CirclerTableCell()
@property (strong, nonatomic) IBOutlet UIImageView *circlerImageView;
@property (strong, nonatomic) IBOutlet UILabel *circlerNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *circlerPositionImageView;
@property (strong, nonatomic) IBOutlet UILabel *circlerRemarkLabel;
@property (strong, nonatomic) IBOutlet UILabel *postCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *replyCountLabel;

@end

@implementation CirclerTableCell

- (void)awakeFromNib {
    self.circlerImageView.layer.masksToBounds = YES;
    self.circlerImageView.layer.cornerRadius = CGRectGetHeight(self.circlerImageView.frame)/2;
    [self p_setType:CircleTableCellType_None];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCell:(id)obj
{
    if ([obj isKindOfClass:[QWCirclerModel class]]) {
        QWCirclerModel* circlerModel = obj;
        [self.circlerImageView setImageWithURL:[NSURL URLWithString:circlerModel.headImageUrl] placeholderImage:ForumDefaultImage];
        self.circlerNameLabel.text = circlerModel.nickName;
//        self.circlerRemarkLabel.text = ;
        self.postCountLabel.text = [NSString stringWithFormat:@"%ld", (long)circlerModel.postCount];
        self.replyCountLabel.text = [NSString stringWithFormat:@"%ld", (long)circlerModel.replyCount];
    }
}

- (void)p_setType:(CircleTableCellType)cellType
{
    switch (cellType) {
        case CircleTableCellType_None:
            self.careBtn.hidden = YES;
            break;
        case CircleTableCellType_Care:
            self.careBtn.hidden = NO;
            self.careBtn.enabled = YES;
            [self.careBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.careBtn.titleLabel.font = [UIFont systemFontOfSize:kFontS5];
            self.careBtn.backgroundColor = RGBHex(qwColor1);
            [self.careBtn setTitle:@"关注" forState:UIControlStateNormal];
            break;
        case CircleTableCellType_CancelCare:
            self.careBtn.hidden = NO;
            self.careBtn.enabled = YES;
            [self.careBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.careBtn.titleLabel.font = [UIFont systemFontOfSize:kFontS5];
            self.careBtn.backgroundColor = RGBHex(qwColor9);
            [self.careBtn setTitle:@"取消关注" forState:UIControlStateNormal];
            break;
        case CircleTableCellType_IAMCircler:
            self.careBtn.hidden = NO;
            self.careBtn.enabled = NO;
            [self.careBtn setTitleColor:RGBHex(qwColor8) forState:UIControlStateNormal];
            self.careBtn.titleLabel.font = [UIFont systemFontOfSize:kFontS5];
            self.careBtn.backgroundColor = [UIColor clearColor];
            [self.careBtn setTitle:@"我是圈主" forState:UIControlStateNormal];
            break;
    }
}


@end
