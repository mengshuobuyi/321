//
//  BusinessSenseTableCell.m
//  wenYao-store
//
//  Created by Martin.Liu on 16/5/10.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "BusinessSenseTableCell.h"
#import "MAUILabel.h"
#import "StoreModel.h"
#import "UIImageView+WebCache.h"
@interface BusinessSenseTableCell()
@property (weak, nonatomic) IBOutlet MAUILabel *topLabel;
@property (weak, nonatomic) IBOutlet UIView *creditContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *creditBackImageView;
@property (weak, nonatomic) IBOutlet UILabel *creditTipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *myTitleLabel;
@property (weak, nonatomic) IBOutlet MAUILabel *sortLabel1;
@property (weak, nonatomic) IBOutlet MAUILabel *sortLabel2;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation BusinessSenseTableCell

- (void)awakeFromNib {
    self.topLabel.layer.masksToBounds = YES;
    self.topLabel.layer.cornerRadius = 2.0;
    self.topLabel.layer.borderWidth = 1.0f / [UIScreen mainScreen].scale;
    self.topLabel.layer.borderColor = RGBHex(qwColor9).CGColor;
    [self.topLabel setEdgeInsets:UIEdgeInsetsMake(1, 2, 1, 2)];
    
    self.myTitleLabel.font = [UIFont systemFontOfSize:kFontS2];
    self.myTitleLabel.textColor = RGBHex(qwColor6);
    
    self.timeLabel.font = [UIFont systemFontOfSize:kFontS5];
    self.timeLabel.textColor = RGBHex(qwColor9);
    
    self.sortLabel1.layer.masksToBounds = YES;
    self.sortLabel1.layer.cornerRadius = 4.0;
    self.sortLabel1.layer.borderWidth = 1.0f / [UIScreen mainScreen].scale;
    self.sortLabel1.layer.borderColor = RGBHex(qwColor9).CGColor;
    self.sortLabel1.font = [UIFont systemFontOfSize:kFontS5];
    self.sortLabel1.edgeInsets = UIEdgeInsetsMake(1, 2, 1, 2);
    
    self.sortLabel2.layer.masksToBounds = YES;
    self.sortLabel2.layer.cornerRadius = 4.0;
    self.sortLabel2.layer.borderWidth = 1.0f / [UIScreen mainScreen].scale;
    self.sortLabel2.layer.borderColor = RGBHex(qwColor9).CGColor;
    self.sortLabel2.font = [UIFont systemFontOfSize:kFontS5];
    self.sortLabel2.edgeInsets = UIEdgeInsetsMake(1, 2, 1, 2);
}

- (void)setSortLabel:(MAUILabel*)sortLabel labelText:(NSString*)text
{
    sortLabel.hidden = StrIsEmpty(text);
    sortLabel.text = text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCell:(id)obj
{
    if ([obj isKindOfClass:[TrainModel class]]) {
        TrainModel* train = obj;
        self.topLabel.hidden = !train.flagTop;
        self.creditContainerView.hidden = train.score <= 0;
        if (train.flagfinis) {
            self.creditBackImageView.image = [UIImage imageNamed:@"my_bg_label2"];
            self.creditTipLabel.text = [NSString stringWithFormat:@"已完成 积分+%ld", (long)train.score];
            
        }
        else
        {
            self.creditBackImageView.image = [UIImage imageNamed:@"my_bg_label"];
            self.creditTipLabel.text = [NSString stringWithFormat:@"阅读 积分+%ld", (long)train.score];
        }
        [self.myImageView setImageWithURL:[NSURL URLWithString:train.icon] placeholderImage:nil];
        self.myTitleLabel.text = train.title;
        self.timeLabel.text = train.publishDate;
        
        NSArray* tagArray = [train.tag componentsSeparatedByString:SeparateStr];
        switch (MIN(2, tagArray.count)) {
            case 1:
                [self setSortLabel:self.sortLabel1 labelText:tagArray[0]];
                [self setSortLabel:self.sortLabel2 labelText:nil];
                break;
            case 2:
                [self setSortLabel:self.sortLabel1 labelText:tagArray[0]];
                [self setSortLabel:self.sortLabel2 labelText:tagArray[1]];
                break;
            default:
                [self setSortLabel:self.sortLabel1 labelText:nil];
                [self setSortLabel:self.sortLabel2 labelText:nil];
                break;
        }
    }
//    [self setSortLabel:self.sortLabel1 labelText:@"疾患知识"];
//    [self setSortLabel:self.sortLabel2 labelText:@"实战应用"];
//    self.timeLabel.text = @"08-08";
}

@end
