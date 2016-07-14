//
//  SystemDelCommentCell.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/20.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "SystemDelCommentCell.h"
#import "CircleModel.h"

@implementation SystemDelCommentCell

+ (CGFloat)getCellHeight:(id)data
{
    TeamMessageModel *model = (TeamMessageModel *)data;
    
    CGSize contentSize = [QWGLOBALMANAGER sizeText:model.msgContent font:fontSystem(14) limitWidth:APP_W-30];
    
    NSString *postTitle = [NSString stringWithFormat:@"帖子：%@",model.sourceTitle];
    CGSize CircleSize = [QWGLOBALMANAGER sizeText:postTitle font:fontSystem(14) limitWidth:APP_W-46];
    
    
    if (CircleSize.height > 32) {
        CircleSize.height = 32;
    }
    
    return 110-28+contentSize.height+CircleSize.height+5;
}

- (void)setCell:(id)data
{
    [super setCell:data];
    
    TeamMessageModel *model = (TeamMessageModel *)data;
    
    NSString *titleStr = @"";
    if (model.msgType == 7) {
        titleStr = @"删除评论";
    }else if (model.msgType == 8){
        titleStr = @"举报";
    }else if (model.msgType == 20){
        titleStr = @"帖子恢复";
    }
    self.title.text = titleStr;
    self.content.text = model.msgContent;
    self.time.text = model.createDate;
    
    
    NSString *postTitle = [NSString stringWithFormat:@"帖子：%@",model.sourceTitle];
    self.circleTitle.text = postTitle;
    CGSize CircleSize = [QWGLOBALMANAGER sizeText:postTitle font:fontSystem(14) limitWidth:APP_W-46];
    if (CircleSize.height > 34) {
        CircleSize.height = 34;
    }
    self.topicBg_layout_height.constant = 44-14+CircleSize.height;
}

@end
