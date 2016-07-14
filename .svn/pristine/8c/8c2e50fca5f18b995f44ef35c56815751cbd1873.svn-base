//
//  AtMineCell.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/8.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "AtMineCell.h"
#import "CircleModel.h"

@implementation AtMineCell

+ (CGFloat)getCellHeight:(id)data
{
    TeamMessageModel *model = (TeamMessageModel *)data;
    NSString *title = model.sourceTitle;
    CGSize titleSize = [QWGLOBALMANAGER sizeText:title font:fontSystem(14) limitWidth:APP_W-86];
    if (titleSize.height > 33) {
        titleSize.height = 33;
    }
    return 112-14+titleSize.height;
}

- (void)UIGlobal
{
    [super UIGlobal];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.separatorLine.hidden = YES;
}

- (void)setCell:(id)data
{
    [super setCell:data];
    
    TeamMessageModel *model = (TeamMessageModel *)data;
    
    //姓名
    self.name.text = model.sourceOwner;
    
    //时间
    self.time.text = model.createDate;
    
    //帖子标题
    self.circleTitle.text = [NSString stringWithFormat:@"%@",model.sourceTitle];
    self.text_layout_top.constant = self.circleTitle_layout_top.constant;
}

@end
