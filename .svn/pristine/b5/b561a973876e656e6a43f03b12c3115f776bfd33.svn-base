//
//  WenyaoActivityTableCell.m
//  wenYao-store
//
//  Created by Martin.Liu on 16/5/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "WenyaoActivityTableCell.h"
#import "StoreModel.h"
@interface WenyaoActivityTableCell()
@property (weak, nonatomic) IBOutlet UILabel *myTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end

@implementation WenyaoActivityTableCell

- (void)awakeFromNib {
    self.myTitleLabel.font = [UIFont systemFontOfSize:kFontS4];
    self.myTitleLabel.textColor = RGBHex(qwColor6);
    self.statusLabel.font = [UIFont systemFontOfSize:kFontS5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCell:(id)obj
{
    if ([obj isKindOfClass:[ActNoticeModel class]]) {
        ActNoticeModel* actNoticeModel = obj;
        self.myTitleLabel.text = actNoticeModel.title;
        switch (actNoticeModel.actStatus) {
            case 1:
                self.statusLabel.textColor = RGBHex(qwColor1);
                self.statusLabel.text = @"报名中";
                break;
            case 2:
                self.statusLabel.textColor = RGBHex(qwColor8);
                self.statusLabel.text = @"已截止";
                break;
            case 3:
                self.statusLabel.textColor = RGBHex(qwColor1);
                self.statusLabel.text = @"进行中";
                break;
            case 4:
                self.statusLabel.textColor = RGBHex(qwColor8);
                self.statusLabel.text = @"已结束";
                break;
                
            default:
                self.statusLabel.text = nil;
                break;
        }
    }
}

@end
