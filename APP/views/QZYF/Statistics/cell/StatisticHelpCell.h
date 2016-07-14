//
//  StatisticHelpCell.h
//  wenYao-store
//
//  Created by qwfy0006 on 15/5/5.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseTableCell.h"

@interface StatisticHelpCell : QWBaseTableCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;

- (void)setUpStyle;

@end
