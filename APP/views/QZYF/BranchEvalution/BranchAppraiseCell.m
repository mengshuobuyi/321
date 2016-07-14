//
//  BranchAppraiseCell.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "BranchAppraiseCell.h"
#import "BranchModel.h"

@implementation BranchAppraiseCell

+ (CGFloat)getCellHeight:(id)data
{
    BranchAppraiseModel *model = (BranchAppraiseModel *)data;
    NSString *content = model.remark;
    CGSize contentSize = [QWGLOBALMANAGER sizeText:content font:fontSystem(kFontS5) limitWidth:APP_W-30];
    return 142 - 12 + contentSize.height;
}

- (void)UIGlobal
{
    [super UIGlobal];
    self.contentView.backgroundColor = RGBHex(qwColor11);
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.separatorLine.hidden = YES;
    
    [self.serviceStar setImagesDeselected:@"star_none.png" partlySelected:@"star_half.png" fullSelected:@"star_full" andDelegate:nil];
    [self.sendStar setImagesDeselected:@"star_none.png" partlySelected:@"star_half.png" fullSelected:@"star_full" andDelegate:nil];
}

- (void)setCell:(id)data
{
    [super setCell:data];
    
    BranchAppraiseModel *model = (BranchAppraiseModel *)data;
    
    //订单编号
    self.orderNum.text = [NSString stringWithFormat:@"订单编号  %@",model.orderCode];
    
    //姓名
    self.name.text = model.nick;
    
    //时间
    self.time.text = model.date;
    
    //服务态度
    self.serviceStar.userInteractionEnabled = NO;
    self.serviceStar.hidden = NO;
    float star1 = model.serviceStars;
    star1 = star1 / 2;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.serviceStar displayRating:star1];
    });
    
    //配送态度  如果零颗星，隐藏
    float star2 = model.deliveryStars;
    if (star2 == 0) {
        self.sendStar.userInteractionEnabled = NO;
        self.sendStar.hidden = NO;
        star2 = star2 / 2;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.sendStar displayRating:star2];
        });
        
    }else{
        self.sendStar.userInteractionEnabled = NO;
        self.sendStar.hidden = NO;
        star2 = star2 / 2;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.sendStar displayRating:star2];
        });
        
    }
    
    //评价内容
    self.content.text = model.remark;
}

@end
