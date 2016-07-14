//
//  ToStorePickCell.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/5/6.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ToStorePickCell.h"
#import "BranchModel.h"

@implementation ToStorePickCell

+ (CGFloat)getCellHeight:(id)data
{
    return 100;
}

- (void)UIGlobal
{
    [super UIGlobal];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.separatorLine.hidden = YES;
}

- (void)setCell:(id)data
{
    [super setCell:data];
    
    ShippingMethodModel *model = (ShippingMethodModel *)data;
    
    //营业时间
    self.timeLabel.text = [NSString stringWithFormat:@"%@—%@",model.openBegin,model.openEnd];
}

- (IBAction)editToStorePickAction:(id)sender
{
    QWButton *btn = (QWButton *)sender;
    NSIndexPath * row = (NSIndexPath *)btn.obj;
    
    if (self.toStorePickCellDelegate && [self.toStorePickCellDelegate respondsToSelector:@selector(editToStorePickAction:)]) {
        [self.toStorePickCellDelegate editToStorePickAction:row];
    }
}
@end
