//
//  SystemCircleMasterCell.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/20.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "SystemCircleMasterCell.h"
#import "CircleModel.h"

@implementation SystemCircleMasterCell

+ (CGFloat)getCellHeight:(id)data
{
    TeamMessageModel *model = (TeamMessageModel *)data;
    //改变title视图
    CGSize size = [QWGLOBALMANAGER sizeText:model.msgContent font:fontSystem(14) limitWidth:APP_W-30];
    return 93+size.height;
}

- (void)setCell:(id)data
{
    [super setCell:data];
    
    TeamMessageModel *model = (TeamMessageModel *)data;
    
    NSString *titleStr = @"";
    if (model.msgType == 11) {
        titleStr = @"审核通过";
    }else if (model.msgType == 15){
        titleStr = @"圈子上线";
    }
    self.title.text = titleStr;
    self.circleName.text = [NSString stringWithFormat:@"圈子：%@",model.sourceTitle];
    self.time.text = model.createDate;
    
    CGSize size = [QWGLOBALMANAGER sizeText:model.msgContent font:fontSystem(14) limitWidth:APP_W-30];
    self.content_layout_height.constant = size.height+2;
    self.content.text = model.msgContent;
}

@end
