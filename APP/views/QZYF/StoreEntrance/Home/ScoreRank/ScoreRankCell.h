//
//  ScoreRankCell.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/5/5.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseTableCell.h"

@interface ScoreRankCell : QWBaseTableCell

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;          //排名

@property (weak, nonatomic) IBOutlet UILabel *isMeNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;            //姓名
@property (weak, nonatomic) IBOutlet UILabel *statuLabel;           //销售等级
@property (weak, nonatomic) IBOutlet UILabel *totalScoreLabel;      //累计积分
@property (weak, nonatomic) IBOutlet UILabel *cuttentScoreLabel;    //当前积分

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numble_layout_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numble_layout_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statu_layout_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalScore_layout_right;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalScore_layout_width;

@end
