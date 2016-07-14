//
//  AskingMedicineTableViewCell.m
//  wenYao-store
//
//  Created by garfield on 15/5/4.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "AskingMedicineTableViewCell.h"
#import "ConsultModel.h"
#import "QWGlobalManager.h"

@implementation AskingMedicineTableViewCell
- (void)UIGlobal{
    [super UIGlobal];
    self.contentView.backgroundColor=RGBAHex(qwColor2, 0);
    self.customerAvatarUrl.layer.masksToBounds = YES;
    self.customerAvatarUrl.layer.cornerRadius = 5.0;
    
    self.ignoreButton.layer.cornerRadius = 4;
    self.answerButton.layer.cornerRadius = 4;
    self.ignoreButton.layer.borderWidth = 0.5;
    self.answerButton.layer.borderWidth = 0.5;
    
    self.ignoreButton.layer.borderColor = RGBHex(qwColor1).CGColor;
    self.answerButton.layer.borderColor = RGBHex(qwColor1).CGColor;
    
    [self.ignoreButton setTitleColor:RGBHex(qwColor1) forState:UIControlStateNormal];
    [self.ignoreButton setTitleColor:RGBHex(qwColor14) forState:UIControlStateHighlighted];
    
    [self.answerButton setTitleColor:RGBHex(qwColor4) forState:UIControlStateNormal];
//    [self.answerButton setba
    
    self.phoneNum.textColor = RGBHex(qwColor6);
    self.phoneNum.font = fontSystem(kFontS4);
    
    self.consultCreateTime.textColor = RGBHex(qwColor8);
    self.consultCreateTime.font = fontSystem(kFontS5);
    
    self.customerDistance.textColor = RGBHex(qwColor8);
    self.customerDistance.font = fontSystem(kFontS5);
    
}

- (void)setCell:(id)data
{
    [super setCell:data];
    ConsultConsultingModel *model = (ConsultConsultingModel *)data;
    self.phoneNum.text = model.customerIndex;

    self.consultCreateTime.text = model.consultFormatShowTime;
    
//    if (model.customerAvatarUrl)
//        [self.customerAvatarUrl setImageWithURL:[NSURL URLWithString:model.customerAvatarUrl] placeholderImage:[UIImage imageNamed:@"answer-head"]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
@end
