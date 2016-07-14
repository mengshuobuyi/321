//
//  MyRecommendMedicineTableViewCell.m
//  wenYao-store
//
//  Created by Martin.Liu on 16/6/3.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "MyRecommendMedicineTableViewCell.h"
#import "StoreModel.h"
@interface MyRecommendMedicineTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *goodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation MyRecommendMedicineTableViewCell

- (void)awakeFromNib {
    [self.goodNameLabel setFont:[UIFont systemFontOfSize:kFontS1]];
    self.goodNameLabel.textColor = RGBHex(qwColor6);
    
    [self.goodNameLabel setFont:[UIFont systemFontOfSize:kFontS4]];
    self.goodNameLabel.textColor = RGBHex(qwColor7);
    
    [self.phoneLabel setFont:[UIFont systemFontOfSize:kFontS4]];
    self.phoneLabel.textColor = RGBHex(qwColor7);
    
    [self.timeLabel setFont:[UIFont systemFontOfSize:kFontS5]];
    self.timeLabel.textColor = RGBHex(qwColor8);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCell:(id)obj
{
    if ([obj isKindOfClass:[BookProductModel class]]) {
        BookProductModel* bookProduct = obj;
        self.goodNameLabel.text = bookProduct.actTitle;
        self.userNameLabel.text = [NSString stringWithFormat:@"预订人：%@", StrDFString(bookProduct.name, @"")];
        self.phoneLabel.text = bookProduct.mobile;
        self.timeLabel.text = bookProduct.bookTime;
    }
}

@end
