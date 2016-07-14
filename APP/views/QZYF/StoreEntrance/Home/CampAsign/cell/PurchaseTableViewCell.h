//
//  ManageTableViewCell.h
//  wenyao-store
//
//  Created by chenpeng on 15/1/19.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QWBaseTableCell.h"
@interface PurchaseTableViewCell : QWBaseTableCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
