//
//  PharmacistInfoCell.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/5/6.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseTableCell.h"

@interface PharmacistInfoCell : QWBaseTableCell

@property (weak, nonatomic) IBOutlet UIImageView *headerIcon;   //头像
@property (weak, nonatomic) IBOutlet UILabel *statuLabel;       //在线状态
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;        //姓名
@property (weak, nonatomic) IBOutlet UILabel *branchLabel;      //品牌
@property (weak, nonatomic) IBOutlet UILabel *goodFieldLabel;   //擅长领域

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *name_layout_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *branch_layout_width;

@end
