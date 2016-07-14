//
//  ConsultHistoryCell.m
//  wenYao-store
//
//  Created by qwfy0006 on 15/5/6.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "ConsultHistoryCell.h"
#import "ConsultModel.h"
#import "UIImageView+WebCache.h"

@implementation ConsultHistoryCell

@synthesize consultTitle = consultTitle;
@synthesize consultCreateTime = consultCreateTime;
@synthesize customerAvatarUrl = customerAvatarUrl;
@synthesize customerIndex = customerIndex;
@synthesize customerDistance = customerDistance;
@synthesize status = status;

- (void)UIGlobal
{
    [super UIGlobal];
    
    self.separatorLine.hidden = YES;
    self.customerAvatarUrl.layer.cornerRadius = 5.0;
    self.customerAvatarUrl.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.bgView.backgroundColor = [UIColor whiteColor];

}

- (void)setCell:(id)data
{
    [self UIGlobal];
    [super setCell:data];
    
    ConsultHistoryModel *model = (ConsultHistoryModel *)data;
    [self.customerAvatarUrl setImageWithURL:[NSURL URLWithString:model.customerAvatarUrl] placeholderImage:[UIImage imageNamed:@"个人资料_头像"]];
    
    if ([model.consultStatus integerValue] == 2) {
        self.status.text = @"解答中";
        self.status.backgroundColor = RGBHex(qwColor15);
    }else if ([model.consultStatus integerValue] == 4){
        self.status.text = @"已关闭";
        self.status.backgroundColor = RGBHex(qwColor9);
    }
    
    NSDate *timeStamp = [NSDate dateWithTimeIntervalSince1970:[model.consultCreateTime doubleValue] / 1000];
    self.consultCreateTime.text = [QWGLOBALMANAGER updateDisplayTime:timeStamp];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.bgView.backgroundColor = RGBHex(0xeeeeee);
    }else
    {
        self.bgView.backgroundColor = [UIColor whiteColor];
    }
}

@end
