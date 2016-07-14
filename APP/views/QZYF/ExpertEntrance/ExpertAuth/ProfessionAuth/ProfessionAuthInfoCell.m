//
//  ProfessionAuthInfoCell.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/5.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ProfessionAuthInfoCell.h"
#import "CircleModel.h"

@implementation ProfessionAuthInfoCell

+ (CGFloat)getCellHeight:(id)data
{
    NSArray *arr = (NSArray *)data;
    return 32 + 10 + (arr.count/4+1)*40;
}

- (void)UIGlobal
{
    [super UIGlobal];
    self.separatorLine.hidden = YES;
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    self.bgView.layer.borderColor = RGBHex(qwColor10).CGColor;
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.cornerRadius = 3.0;
    self.bgView.layer.masksToBounds = YES;
}

//设置标签
- (void)setUpTagsWithAllList:(NSArray *)allList selectedList:(NSArray *)selectedList;
{
    for (UIView *subView in self.bgView.subviews) {
        [subView removeFromSuperview];
    }
    
    for (int i = 0; i < allList.count; i ++)
    {
        GoodFieldModel *model = allList[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        [btn setTitle:[NSString stringWithFormat:@"%@",model.dicValue] forState:UIControlStateNormal];
        [btn setTitleColor:RGBHex(qwColor8) forState:UIControlStateNormal];
        btn.titleLabel.font = fontSystem(14);
        btn.layer.cornerRadius = 3.0;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = RGBHex(qwColor9).CGColor;
        btn.layer.borderWidth = 0.5;
        btn.frame = CGRectMake(12 + i%4 * (64 + (APP_W-310)/3) ,10+i/4*(30 + 10)  , 64, 30);
        [btn addTarget:self action:@selector(clickTags:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100 + i;
        [self.bgView addSubview:btn];
        
        if ([selectedList containsObject:model])
        {
            [btn setTitleColor:RGBHex(qwColor4) forState:UIControlStateNormal];
            btn.backgroundColor = RGBHex(qwColor2);
            btn.layer.borderColor = [UIColor clearColor].CGColor;
        }else
        {
            [btn setTitleColor:RGBHex(qwColor8) forState:UIControlStateNormal];
            btn.backgroundColor = RGBHex(qwColor4);
            btn.layer.borderColor = RGBHex(qwColor9).CGColor;
        }
    }
    self.bgView_layout_height.constant = 10 + (allList.count/4+1)*40;
}

#pragma mark ---- 选择擅长领域 ----
- (void)clickTags:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (self.professionAuthInfoCellDelegate && [self.professionAuthInfoCellDelegate respondsToSelector:@selector(selectedTagAction:)]) {
        [self.professionAuthInfoCellDelegate selectedTagAction:btn];
    }
}

- (void)setCell:(id)data
{
    [super setCell:data];
}

@end
