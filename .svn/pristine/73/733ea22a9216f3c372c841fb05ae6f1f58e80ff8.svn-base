//
//  PharmacistInfoCell.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/5/6.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "PharmacistInfoCell.h"
#import "ExpertModel.h"

@implementation PharmacistInfoCell

- (void)UIGlobal
{
    [super UIGlobal];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.headerIcon.layer.cornerRadius = 28;
    self.headerIcon.layer.masksToBounds = YES;
    
    self.statuLabel.layer.cornerRadius = 7.0;
    self.statuLabel.layer.masksToBounds = YES;
    
    self.branchLabel.layer.cornerRadius = 4.0;
    self.branchLabel.layer.masksToBounds = YES;
}

- (void)setCell:(id)data
{
    [super setCell:data];
    
    PharmacistInfoListModel *model = (PharmacistInfoListModel *)data;
    
    //头像
    [self.headerIcon setImageWithURL:[NSURL URLWithString:model.headImageUrl] placeholderImage:[UIImage imageNamed:@"expert_ic_people"]];
    
    //在线状态
    if (model.onlineFlag)
    {
        self.statuLabel.text = @"在线";
        self.statuLabel.backgroundColor = RGBHex(qwColor1);
    }else
    {
        self.statuLabel.text = @"离线";
        self.statuLabel.backgroundColor = RGBHex(qwColor9);
    }
    
    //姓名
    self.nameLabel.text = model.nickName;
    CGSize nameSize = [self.nameLabel.text sizeWithFont:fontSystem(15) constrainedToSize:CGSizeMake(APP_W-100, CGFLOAT_MAX)];
    self.name_layout_width.constant = nameSize.width+2;
    
    //品牌
    self.branchLabel.text = model.groupName;
    CGSize brandSize = [self.branchLabel.text sizeWithFont:fontSystem(12) constrainedToSize:CGSizeMake(APP_W-110-nameSize.width, CGFLOAT_MAX)];
    self.branch_layout_width.constant = brandSize.width+7;

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
}

@end
