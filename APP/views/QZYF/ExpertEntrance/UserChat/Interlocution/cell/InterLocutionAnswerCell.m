//
//  InterLocutionAnswerCell.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/4/1.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "InterLocutionAnswerCell.h"
#import "QWGlobalManager.h"
#import "ConsultPTPModel.h"
#import "UserChatModel.h"
#import "XHMessage.h"

@implementation InterLocutionAnswerCell

- (void)UIGlobal
{
    [super UIGlobal];
    self.separatorLine.hidden = YES;
    self.contentView.backgroundColor=RGBAHex(qwColor2, 0);
    
    self.customerAvatarUrl.layer.masksToBounds = YES;
    self.customerAvatarUrl.layer.cornerRadius = 17.0;
    
    self.phoneNum.textColor = RGBHex(qwColor6);
    self.phoneNum.font = fontSystem(kFontS4);
    
    self.consultCreateTime.textColor = RGBHex(qwColor8);
    self.consultCreateTime.font = fontSystem(kFontS5);
    
    self.consultTitle.textColor = RGBHex(qwColor6);
    self.consultTitle.font = fontSystem(kFontS1);
}

- (void)setCell:(id)data type:(int)type
{
    self.failureStatus.hidden = YES;
    if ([data isKindOfClass:[InterlocutionListModel class]])
    {
        InterlocutionListModel *model = (InterlocutionListModel *)data;
        
        //头像
        [self.customerAvatarUrl setImageWithURL:[NSURL URLWithString:model.headImgUrl] placeholderImage:[UIImage imageNamed:@"expert_ic_people"]];
    
        //姓名
        self.phoneNum.text = model.name;
        
        //问答最后一条内容
        NSString *contentStr = @"";
        if ([model.respondLastType isEqualToString:@"MPRO"])
        {
            contentStr = @"[药品]";
        }else if ([model.respondLastType isEqualToString:@"IMG"])
        {
            contentStr = @"[图片]";
        }else if ([model.respondLastType isEqualToString:@"TXT"])
        {
            contentStr = model.responseLastContent;
        }
    
        self.consultTitle.text = contentStr;
        
        //时间
        self.consultCreateTime.text = model.responseLast;
        
        if (type == 1)
        {
            //解答中
            self.closeStatus.hidden = YES;
            //未读表示
            if (model.unRead) {
                self.unReadStatus.hidden = NO;
            }else{
                self.unReadStatus.hidden = YES;
            }
            
        }else if (type == 2)
        {
            //已关闭
            self.closeStatus.text = @"已关闭";
            self.unReadStatus.hidden = YES;
        }
    }
}

- (void)setCell:(id)data status:(int)status body:(NSString*)body
{
    self.failureStatus.hidden = YES;
    //失败标识
    if(status == SendFailure) {//3
        self.failureStatus.hidden = NO;
    }else{
        self.failureStatus.hidden = YES;
    }
}

@end
