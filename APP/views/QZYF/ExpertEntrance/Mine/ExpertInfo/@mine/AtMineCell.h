//
//  AtMineCell.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/8.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseTableCell.h"
#import "MGSwipeTableCell.h"
#import "QWView.h"

@interface AtMineCell : MGSwipeTableCell

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *circleTitle;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *circleTitle_layout_top;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *text_layout_top;

@property (weak, nonatomic) IBOutlet QWView *topicBgView;


@end
