//
//  BranchAppraiseCell.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseTableCell.h"
#import "RatingView.h"

@interface BranchAppraiseCell : QWBaseTableCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet RatingView *serviceStar;
@property (weak, nonatomic) IBOutlet RatingView *sendStar;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end
