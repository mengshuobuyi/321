//
//  ExpertFlowerCell.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/8.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ExpertFlowerCell.h"
#import "CircleModel.h"

@implementation ExpertFlowerCell

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
    
    self.lookLabel.layer.cornerRadius = 4.0;
    self.lookLabel.layer.masksToBounds = YES;
}

- (void)setCell:(id)data
{
    [super setCell:data];
    
    TeamMessageModel *model = (TeamMessageModel *)data;
    
    //鲜花数
    self.flowerNum.text = model.msgContent;
    
    //时间
    self.time.text = model.createDate;
    
    //帖子标题
    self.topicTitle.text = model.sourceTitle;
}

- (IBAction)lookAction:(id)sender
{
    QWButton *btn = (QWButton *)sender;
    NSIndexPath *indexPath = (NSIndexPath *)btn.obj;
    if (self.expertFlowerCellDelegate && [self.expertFlowerCellDelegate respondsToSelector:@selector(lookFlowerInfo:)]) {
        [self.expertFlowerCellDelegate lookFlowerInfo:indexPath];
    }
}
@end
