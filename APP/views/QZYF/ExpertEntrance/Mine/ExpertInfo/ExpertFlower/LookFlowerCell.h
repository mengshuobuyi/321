//
//  LookFlowerCell.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/24.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseTableCell.h"

@interface LookFlowerCell : QWBaseTableCell

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *headerIcon;       //头像
@property (weak, nonatomic) IBOutlet UILabel *name;                 //姓名
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *name_layout_width;
@property (weak, nonatomic) IBOutlet UIView *lvlBgView;             //普通用户等级
@property (weak, nonatomic) IBOutlet UILabel *lvlLabel;
@property (weak, nonatomic) IBOutlet UILabel *number;               //文章回帖数
@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;       //关注
@property (weak, nonatomic) IBOutlet UILabel *cancelAttentionLabel; //取消关注
@property (weak, nonatomic) IBOutlet UILabel *masterLabel;          //我是圈主
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;


@property (weak, nonatomic) IBOutlet UILabel *expertLogoLabel;
@property (weak, nonatomic) IBOutlet UILabel *expertBrandLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expertBrand_layout_width;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expertBrand_layout_left;

//查看鲜花
- (void)setUpData:(id)data;

@end