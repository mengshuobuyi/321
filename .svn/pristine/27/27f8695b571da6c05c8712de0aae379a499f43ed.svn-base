//
//  LookMasterCell.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/7.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "LookMasterCell.h"
#import "NSString+WPAttributedMarkup.h"
#import "CircleModel.h"

@implementation LookMasterCell

- (void)UIGlobal
{
    [super UIGlobal];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.separatorLine.hidden = YES;
    
    self.headerIcon.layer.cornerRadius = 26.0;
    self.headerIcon.layer.masksToBounds = YES;
    
    self.attentionLabel.layer.cornerRadius = 3.0;
    self.attentionLabel.layer.masksToBounds = YES;
    
    self.cancelAttentionLabel.layer.cornerRadius = 3.0;
    self.cancelAttentionLabel.layer.masksToBounds = YES;
    
    self.expertBrandLabel.layer.cornerRadius = 4.0;
    self.expertBrandLabel.layer.masksToBounds = YES;
    
    self.expertBrandLabel.hidden = YES;
}

- (void)setCell:(id)data
{
    [super setCell:data];
    
    CircleMaserlistModel *model = (CircleMaserlistModel *)data;
    
    //头像
    [self.headerIcon setImageWithURL:[NSURL URLWithString:model.headImageUrl] placeholderImage:[UIImage imageNamed:@"expert_ic_people"]];
    
    //姓名 logo 地址
    NSString *name = model.nickName;
    if (model.userType == 3 || model.userType == 4)
    {
        //专家 显示专家logo
        self.lvlBgView.hidden = YES;
//        self.expertBrandLabel.hidden = NO;
        self.expertLogoLabel.hidden = NO;
                
        NSString *logoName;
        NSString *store;
        if (model.userType == 3)
        {
            //药师 标识显示药师logo及所属商家
            store = model.groupName;
            logoName = @"药师";
        }else if (model.userType == 4)
        {
            //营养师 标识显示营养师logo及“营养师”
            store = model.groupName;
            logoName = @"营养师";
        }
        
        CGSize nameSize = [name sizeWithFont:fontSystem(14) constrainedToSize:CGSizeMake(APP_W-85, CGFLOAT_MAX)];
        self.name_layout_width.constant = nameSize.width+6;
        CGSize brandSize = [store sizeWithFont:fontSystem(12) constrainedToSize:CGSizeMake(APP_W-85-nameSize.width-13, CGFLOAT_MAX)];
        
        self.expertBrand_layout_width.constant = brandSize.width+7;
        self.name.text = name;
        self.expertLogoLabel.text = logoName;
        
        if (StrIsEmpty(store)) {
//            self.expertBrandLabel.hidden = YES;
        }else{
//            self.expertBrandLabel.hidden = NO;
//            self.expertBrandLabel.text = store;
        }
    }else
    {
        //普通用户 标识显示用户当前等级
        self.name.text = name;
        CGSize size=[name sizeWithFont:fontSystem(15) constrainedToSize:CGSizeMake(APP_W-150, CGFLOAT_MAX)];
        self.name_layout_width.constant = size.width+2;
        self.lvlBgView.hidden = NO;
        self.lvlLabel.text = [NSString stringWithFormat:@"V%d",model.mbrLvl];
        
//        self.expertBrandLabel.hidden = YES;
        self.expertLogoLabel.hidden = YES;
    }

    
    //文章 帖子 数
    NSString *str = [NSString stringWithFormat:@"文章 %d   回帖 %d",model.postCount,model.replyCount];
    NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange range1 = [[AttributedStr1 string]rangeOfString:@"文章"];
    NSRange range2 = [[AttributedStr1 string]rangeOfString:@"回帖"];
    [AttributedStr1 addAttribute:NSFontAttributeName
                           value:fontSystem(kFontS5)
                           range:range1];
    [AttributedStr1 addAttribute:NSForegroundColorAttributeName
                           value:RGBHex(qwColor8)
                           range:range1];
    [AttributedStr1 addAttribute:NSFontAttributeName
                           value:fontSystem(kFontS5)
                           range:range2];
    [AttributedStr1 addAttribute:NSForegroundColorAttributeName
                           value:RGBHex(qwColor8)
                           range:range2];
    self.number.attributedText = AttributedStr1;
    
    
    //关注按钮
    if (model.userType == 3 || model.userType == 4)
    {
        if (model.isMaster)
        {
            //我是圈主
            self.attentionLabel.hidden = YES;
            self.cancelAttentionLabel.hidden = YES;
            self.masterLabel.hidden = NO;
            self.masterLabel.layer.cornerRadius = 4.0;
            self.masterLabel.layer.masksToBounds = YES;
            self.attentionButton.enabled = NO;
        }else
        {
            if (model.isAttnFlag)
            {
                //已经关注，显示取消关注
                self.cancelAttentionLabel.layer.cornerRadius = 4.0;
                self.cancelAttentionLabel.layer.masksToBounds = YES;
                self.cancelAttentionLabel.hidden = NO;
                self.attentionLabel.hidden = YES;
                self.masterLabel.hidden = YES;
            }else
            {
                //未关注，显示关注
                self.attentionLabel.layer.cornerRadius = 4.0;
                self.attentionLabel.layer.masksToBounds = YES;
                self.attentionLabel.hidden = NO;
                self.cancelAttentionLabel.hidden = YES;
                self.masterLabel.hidden = YES;
            }
        }
    }else
    {
        //普通用户
        
        if (model.isMaster)
        {
            //我是圈主
            self.attentionLabel.hidden = YES;
            self.cancelAttentionLabel.hidden = YES;
            self.masterLabel.hidden = NO;
            self.masterLabel.layer.cornerRadius = 4.0;
            self.masterLabel.layer.masksToBounds = YES;
            self.attentionButton.enabled = NO;
        }else
        {
            //所有按钮隐藏
            self.attentionLabel.hidden = YES;
            self.cancelAttentionLabel.hidden = YES;
            self.masterLabel.hidden = YES;
            self.attentionButton.hidden = YES;
            self.attentionButton.enabled = NO;
        }
    }
}


@end
