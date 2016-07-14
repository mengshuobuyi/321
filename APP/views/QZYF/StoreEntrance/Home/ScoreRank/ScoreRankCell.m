//
//  ScoreRankCell.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/5/5.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ScoreRankCell.h"
#import "ScoreModel.h"

@implementation ScoreRankCell

+ (CGFloat)getCellHeight:(id)data
{
    ScoreRankListModel *model = (ScoreRankListModel *)data;
    if (model.isDog) {
        return 70;
    }else{
        return 65;
    }
}

- (void)UIGlobal
{
    [super UIGlobal];
    
    self.contentView.backgroundColor = RGBHex(qwColor11);
    self.backgroundColor = RGBHex(qwColor11);
    
    self.numberLabel.layer.cornerRadius = 18;
    self.numberLabel.layer.masksToBounds = YES;
    
    self.statuLabel.layer.cornerRadius = 9;
    self.statuLabel.layer.masksToBounds = YES;
    
    self.numble_layout_left.constant = 87*APP_W/320;;
    self.statu_layout_left.constant = 85*APP_W/320;;
    self.totalScore_layout_right.constant = 79*APP_W/320;
}

- (void)setCell:(id)data
{
    [super setCell:data];
    
    ScoreRankListModel *model = (ScoreRankListModel *)data;
    
    if (model.isDog)
    {
        //如果是本店店员
        self.numberLabel.hidden = YES;
        self.isMeNumberLabel.hidden = NO;
        self.isMeNumberLabel.text = [NSString stringWithFormat:@"%d",model.rank];
    }else
    {
        self.numberLabel.hidden = NO;
        self.isMeNumberLabel.hidden = YES;
        
        //排名
        self.numberLabel.text = [NSString stringWithFormat:@"%d",model.rank];
        
        //修改排名font
        if (self.numberLabel.text.length == 3)
        {
            self.numberLabel.font = fontSystem(kFontS2);
        }
        else if (self.numberLabel.text.length == 4)
        {
            self.numberLabel.font = [UIFont systemFontOfSize:13];
        }
        else{
            self.numberLabel.font = fontSystem(kFontS10);
        }
        
        //修改排名color
        if (model.rank == 0 || model.rank == 1 || model.rank == 2 || model.rank == 3 || model.rank == 4 || model.rank == 5 || model.rank == 6 || model.rank == 7 || model.rank == 8 || model.rank == 9 || model.rank == 10) {
            self.numberLabel.backgroundColor = RGBHex(qwColor3);
        }else
        {
            self.numberLabel.backgroundColor = RGBHex(qwColor8);
        }

    }
    
    //姓名
    self.nameLabel.text = model.empName;
    
    //销售等级
    if (model.lvl == 0)
    {
        //普通会员
        self.statuLabel.backgroundColor = RGBHex(qwColor14);
        self.statuLabel.text = @"销售新手";
        
    }else if (model.lvl == 1)
    {
        //销售能手
        self.statuLabel.backgroundColor = RGBHex(qwColor13);
        self.statuLabel.text = @"销售能手";
        
    }else if (model.lvl == 2)
    {
        //销售骨干
        self.statuLabel.backgroundColor = RGBHex(qwColor15);
        self.statuLabel.text = @"销售骨干";
        
    }else if (model.lvl == 3)
    {
        //销售达人
        self.statuLabel.backgroundColor = RGBHex(qwColor2);
        self.statuLabel.text = @"销售达人";
        
    }else if (model.lvl == 4)
    {
        //销售专家
        self.statuLabel.backgroundColor = RGBHex(qwColor12);
        self.statuLabel.text = @"销售专家";
        
    }else if (model.lvl == 5)
    {
        //销售大师
        self.statuLabel.backgroundColor = RGBHex(qwColor3);
        self.statuLabel.text = @"销售大师";
    }

    //累计积分
    self.totalScoreLabel.text = [NSString stringWithFormat:@"%d",model.totalScore];
    
    //当前积分
    self.cuttentScoreLabel.text = [NSString stringWithFormat:@"%d",model.score];
    
}

@end
