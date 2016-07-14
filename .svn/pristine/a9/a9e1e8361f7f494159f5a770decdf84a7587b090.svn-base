//
//  InterLocutionWaitingCell.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/4/1.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "InterLocutionWaitingCell.h"
#import "QWGlobalManager.h"
#import "UserChatModel.h"

@implementation InterLocutionWaitingCell

- (void)UIGlobal
{
    [super UIGlobal];
    self.separatorLine.hidden = YES;
    self.contentView.backgroundColor=RGBAHex(qwColor2, 0);
    
    self.customerAvatarUrl.layer.masksToBounds = YES;
    self.customerAvatarUrl.layer.cornerRadius = 17.0;
    
    self.ignoreButton.layer.cornerRadius = 4;
    self.answerButton.layer.cornerRadius = 4;
    self.ignoreButton.layer.borderWidth = 0.5;
    self.answerButton.layer.borderWidth = 0.5;
    self.ignoreButton.layer.masksToBounds = YES;
    self.answerButton.layer.masksToBounds = YES;
    
    self.ignoreButton.layer.borderColor = RGBHex(qwColor1).CGColor;
    self.answerButton.layer.borderColor = RGBHex(qwColor1).CGColor;
    
    [self.ignoreButton setTitleColor:RGBHex(qwColor1) forState:UIControlStateNormal];
    [self.ignoreButton setTitleColor:RGBHex(qwColor14) forState:UIControlStateHighlighted];
    
    [self.answerButton setTitleColor:RGBHex(qwColor4) forState:UIControlStateNormal];
    
    self.phoneNum.textColor = RGBHex(qwColor6);
    self.phoneNum.font = fontSystem(kFontS4);
    
    self.consultCreateTime.textColor = RGBHex(qwColor8);
    self.consultCreateTime.font = fontSystem(kFontS5);
}

- (void)setCell:(id)data
{
    InterlocutionListModel *model = (InterlocutionListModel *)data;
    
    //头像
    [self.customerAvatarUrl setImageWithURL:[NSURL URLWithString:model.headImgUrl] placeholderImage:[UIImage imageNamed:@"expert_ic_people"]];
    
    //姓名
    self.phoneNum.text = model.name;
    
    //时间
    self.consultCreateTime.text = model.responseLast;
    
    //聊天内容
    self.consultTitle.text = model.consultTitle;    
}

@end
