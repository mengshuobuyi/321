//
//  SystemAccountCell.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/20.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "SystemAccountCell.h"
#import "CircleModel.h"

@implementation SystemAccountCell

+ (CGFloat)getCellHeight:(id)data
{
    TeamMessageModel *model = (TeamMessageModel *)data;
    //改变title视图
    CGSize size = [QWGLOBALMANAGER sizeText:model.msgContent font:fontSystem(14) limitWidth:APP_W-99];
    
    return 67-14+size.height;
}

- (void)setCell:(id)data
{
    [super setCell:data];
    
    TeamMessageModel *model = (TeamMessageModel *)data;
    
    NSString *titleStr = @"";
    if (model.msgType == 9) {
        titleStr = @"帐号安全";
    }
    self.title.text = titleStr;
    self.content.text = model.msgContent;
    self.time.text = model.createDate;
}

@end
