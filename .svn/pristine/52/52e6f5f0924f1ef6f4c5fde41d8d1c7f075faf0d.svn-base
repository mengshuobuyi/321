//
//  ExchangeProductCell.m
//  wenYao-store
//
//  Created by Yang Yuexia on 15/12/2.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "ExchangeProductCell.h"
#import "NSString+WPAttributedMarkup.h"
#import "OrderModel.h"

@implementation ExchangeProductCell

+ (CGFloat)getCellHeight:(id)data{
    return 85.0f;
}


-(void)UIGlobal
{
    [super UIGlobal];
    [self separatorHidden ];
   
    
}

- (void)setData:(id)data
{
    ExchangeProModel *model = (ExchangeProModel *)data;
    
    //商品图片
    [self.icon setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:nil];
    
    // 商品名称
    self.title.text = model.title;
    
    // 兑换积分
    NSString *tempStr = model.score;
    NSDictionary* style = @{@"thumb":[UIImage imageNamed:@"icon_integral"]};
    self.score.attributedText = [[NSString stringWithFormat:@"<thumb> </thumb> %@",tempStr ]attributedStringWithStyleBook:style];
    
    // 兑换时间
    self.time.text = model.exchangeDate;
    
    // 兑换状态
    self.exchangeState.text = @"兑换成功";
}


@end
