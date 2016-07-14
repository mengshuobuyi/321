//
//  EnterExpertCell.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/6/16.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "EnterExpertCell.h"
#import "ExpertModel.h"

@implementation EnterExpertCell

- (void)UIGlobal
{
    [super UIGlobal];
    self.separatorLine.hidden = YES;
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.headerIcon.layer.cornerRadius = 28.0;
    self.headerIcon.layer.masksToBounds = YES;
    
    self.expertBrand.layer.cornerRadius = 4.0;
    self.expertBrand.layer.masksToBounds = YES;
    
    self.attentionLabel.layer.cornerRadius = 3;
    self.attentionLabel.layer.masksToBounds = YES;
}

- (void)configureData:(id)data withType:(int)type flageGroup:(BOOL)flagGroup;
{
    [super setCell:data];
    
    EnterExpertListModel *model = (EnterExpertListModel *)data;
        
    //头像
    [self.headerIcon setImageWithURL:[NSURL URLWithString:model.headImageUrl] placeholderImage:[UIImage imageNamed:@"expert_ic_people"]];
    
    //姓名
    NSString *name = model.nickName;
    if (model.expertType == 1 || model.expertType == 2)
    {
        //专家 显示专家logo
        self.expertBrand.hidden = NO;
        self.expertBrand.hidden = NO;
        
        NSString *logoName;
        NSString *store;
        float maxWidth;
        if (model.expertType == 1)
        {
            //药师 标识显示药师logo及所属商家
            store = model.groupName;
            logoName = @"药师";
            self.expertBrand_layout_left.constant = -6;
        }else if (model.expertType == 2)
        {
            //营养师 标识显示营养师logo及“营养师”
            store = model.groupName;
            logoName = @"营养师";
            self.expertBrand_layout_left.constant = 4;
        }
        
        CGSize nameSize = [name sizeWithFont:fontSystem(15) constrainedToSize:CGSizeMake(APP_W-159, CGFLOAT_MAX)];
        self.expertName_layout_width.constant = nameSize.width+2;
        
        if (model.expertType == 1) {
            maxWidth = APP_W-194-nameSize.width-13;
        }else if (model.expertType == 2){
            maxWidth = APP_W-194-nameSize.width-13-10;
        }
        
        CGSize brandSize = [store sizeWithFont:fontSystem(12) constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX)];
        
        self.expertBrand_layout_width.constant = brandSize.width+10;
        self.expertName.text = name;
        self.expertLogo.text = logoName;
        
        if (flagGroup)
        {
            //商家圈隐藏品牌
            self.expertBrand.hidden = YES;
        }else
        {
            //普通圈显示品牌
            if (StrIsEmpty(store)) {
                self.expertBrand.hidden = YES;
            }else{
                self.expertBrand.hidden = NO;
                self.expertBrand.text = store;
            }
        }
    }

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
    self.goodFieldLabel.text = [NSString stringWithFormat:@"擅长：%@",goodFieldStr];
    
    //关注按钮
    if (type == 1)
    {
        self.attentionLabel.hidden = YES;
        self.attentionButton.hidden = YES;
        self.attentionButton.enabled = NO;
    }else
    {
        self.attentionLabel.hidden = NO;
        self.attentionButton.hidden = NO;
        self.attentionButton.enabled = YES;
    }
}


@end
