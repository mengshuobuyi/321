//
//  ExpertPageCell.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/15.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ExpertPageCell.h"
#import "CircleModel.h"
#import "NSString+WPAttributedMarkup.h"

@implementation ExpertPageCell

+ (CGFloat)getCellHeight:(id)data
{
    CircleMaserlistModel *model = (CircleMaserlistModel *)data;

    if (model.userType == 3 || model.userType == 4)
    {
        NSString *store;
        if (model.userType == 3)
        {
            //药师 标识显示药师所属商家
            if (model.groupName && ![model.groupName isEqualToString:@""]) {
                store = model.groupName;
            }else{
                store = @"";
            }
            
        }else if (model.userType == 4)
        {
            store = @"";
        }
        
        if (StrIsEmpty(store))
        {
            return 240-16-20;
        }else
        {
            return 240;
        }
    }
    return 240;
}

- (void)UIGlobal
{
    [super UIGlobal];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.separatorLine.hidden = YES;
    
    self.headerIcon.layer.cornerRadius = 28;
    self.headerIcon.layer.masksToBounds = YES;
    
    self.attentionLabel.layer.cornerRadius = 4.0;
    self.attentionLabel.layer.masksToBounds = YES;
    
    self.cancelAttentionLabel.layer.cornerRadius = 4.0;
    self.cancelAttentionLabel.layer.masksToBounds = YES;
    
    self.expertBrandLabel.layer.cornerRadius = 4.0;
    self.expertBrandLabel.layer.masksToBounds = YES;
}

- (void)setCell:(id)data
{
    [super setCell:data];
    
    CircleMaserlistModel *model = (CircleMaserlistModel *)data;
    
    //头像
    [self.headerIcon setImageWithURL:[NSURL URLWithString:model.headImageUrl] placeholderImage:[UIImage imageNamed:@"home_img_head"]];
    
    //姓名
    NSString *name = model.nickName;
    NSString *logoName = @"";
    if (model.userType == 3) { //药师
        logoName = @"药师";
    }else if (model.userType == 4){ //营养师
        logoName = @"营养师";
    }
    NSString *str = [NSString stringWithFormat:@"%@ %@",name,logoName];
    NSMutableAttributedString *nameAttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange range = [[nameAttributedStr string]rangeOfString:logoName];
    [nameAttributedStr addAttribute:NSFontAttributeName
                              value:fontSystem(kFontS4)
                              range:range];
    [nameAttributedStr addAttribute:NSForegroundColorAttributeName
                              value:RGBHex(qwColor3)
                              range:range];
    self.expertName.attributedText = nameAttributedStr;
    
    //药房品牌
    if (model.userType == 3 || model.userType == 4)
    {
        NSString *store;
        if (model.userType == 3)
        {
            //药师 标识显示药师所属商家
            if (model.groupName && ![model.groupName isEqualToString:@""]) {
                store = model.groupName;
            }else{
                store = @"";
            }
            
        }else if (model.userType == 4)
        {
            store = @"";
        }
        
        if (StrIsEmpty(store))
        {
            self.expertBrandLabel.hidden = YES;
        }else
        {
            self.expertBrandLabel.hidden = NO;
            self.expertBrandLabel.layer.cornerRadius = 4.0;
            self.expertBrandLabel.layer.masksToBounds = YES;
            self.expertBrandLabel.text = store;
            CGSize brandSize = [store sizeWithFont:fontSystem(12) constrainedToSize:CGSizeMake(APP_W-20, CGFLOAT_MAX)];
            self.expertBrand_layout_width.constant = brandSize.width+7;
        }
    }
    
    //粉丝
    NSString *str1 = [NSString stringWithFormat:@"粉丝 %d",model.attnCount];
    NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc]initWithString:str1];
    NSRange range1 = [[AttributedStr1 string]rangeOfString:@"粉丝"];
    [AttributedStr1 addAttribute:NSFontAttributeName
                           value:fontSystem(kFontS4)
                           range:range1];
    [AttributedStr1 addAttribute:NSForegroundColorAttributeName
                           value:RGBHex(qwColor8)
                           range:range1];
    self.funsLabel.attributedText = AttributedStr1;
    
    //鲜花
    NSString *str2 = [NSString stringWithFormat:@"鲜花 %d",model.upVoteCount];
    NSMutableAttributedString *AttributedStr2 = [[NSMutableAttributedString alloc]initWithString:str2];
    NSRange range2 = [[AttributedStr2 string]rangeOfString:@"鲜花"];
    [AttributedStr2 addAttribute:NSFontAttributeName
                           value:fontSystem(kFontS4)
                           range:range2];
    [AttributedStr2 addAttribute:NSForegroundColorAttributeName
                           value:RGBHex(qwColor8)
                           range:range2];
    self.flowerLabel.attributedText = AttributedStr2;
    
    //擅长领域
    
    NSString *goodFieldStr = @"";
    if (model.expertise && ![model.expertise isEqualToString:@""])
    {
        NSArray *arr = [model.expertise componentsSeparatedByString:SeparateStr];
        if (arr.count == 0)
        {
            goodFieldStr = @"";

        }else if (arr.count == 1)
        {
            goodFieldStr = [NSString stringWithFormat:@"%@",arr[0]];

        }else if (arr.count == 2)
        {
            goodFieldStr = [NSString stringWithFormat:@"%@/%@",arr[0],arr[1]];

        }else if (arr.count >= 3)
        {
            goodFieldStr = [NSString stringWithFormat:@"%@/%@/%@",arr[0],arr[1],arr[2]];
        }
    }else
    {
        goodFieldStr = @"";
    }
    
    self.goodFieldLabel.text = [NSString stringWithFormat:@"擅长 : %@",goodFieldStr];
    
    //关注
    if (model.isAttnFlag)
    {
        //关注 显示取消关注
        self.attentionLabel.hidden = YES;
        self.cancelAttentionLabel.hidden = NO;
    }else
    {
        //未关注 显示关注
        self.attentionLabel.hidden = NO;
        self.cancelAttentionLabel.hidden = YES;
    }
}

@end
