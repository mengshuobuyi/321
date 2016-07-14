//
//  ScanDrugTableViewCell.h
//  quanzhi
//
//  Created by xiezhenghong on 14-6-17.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QWBaseTableCell.h"
@interface ScanDrugTableViewCell : QWBaseTableCell

@property (nonatomic, strong) IBOutlet QWImageView *avatar;
@property (nonatomic, strong) IBOutlet QWLabel *titleLabel;
@property (nonatomic, strong) IBOutlet QWLabel *sepcLabel;
@property (nonatomic, strong) IBOutlet QWLabel *factoryLabel;

@end