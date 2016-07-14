//
//  MyRecommendationTableCell.m
//  wenYao-store
//
//  Created by Martin.Liu on 16/5/9.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "MyRecommendationTableCell.h"
#import "StoreModel.h"
@interface MyRecommendationTableCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel1;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel2;
@property (weak, nonatomic) IBOutlet UILabel *creditLabel;

@end

@implementation MyRecommendationTableCell

- (void)awakeFromNib {
    self.nameLabel.font = [UIFont systemFontOfSize:kFontS1];
    self.nameLabel.textColor = RGBHex(qwColor6);
    
    self.phoneLabel.font = [UIFont systemFontOfSize:kFontS1];
    self.phoneLabel.textColor = RGBHex(qwColor8);
    
    self.timeLabel1.font = self.timeLabel2.font = [UIFont systemFontOfSize:kFontS5];
    self.timeLabel1.textColor = self.timeLabel2.textColor = RGBHex(qwColor8);
    
    self.creditLabel.font = [UIFont systemFontOfSize:kFontS1];
    self.creditLabel.textColor = RGBHex(qwColor3);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCell:(id)obj
{
    if ([obj isKindOfClass:[MyRecommendModel class]]) {
        MyRecommendModel* myRecommend = obj;
        self.nameLabel.text = !StrIsEmpty(myRecommend.nick) ? myRecommend.nick : myRecommend.userName;
        self.phoneLabel.text = myRecommend.mobile;
        if (myRecommend.socre > 0) {
            self.creditLabel.text = [NSString stringWithFormat:@"积分+%ld", (long)myRecommend.socre];
        }
        else
        {
            self.creditLabel.text = nil;
        }
        self.timeLabel1.text = myRecommend.inviteTime;
        self.timeLabel2.text = nil;
    }
}

@end
