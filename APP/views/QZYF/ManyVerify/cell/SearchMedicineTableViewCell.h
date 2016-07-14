//
//  SearchMedicineTableViewCell.h
//  wenyao
//
//  Created by xiezhenghong on 14-10-8.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QWBaseTableCell.h"
@interface SearchMedicineTableViewCell : QWBaseTableCell

@property (nonatomic, strong) IBOutlet  QWImageView *backImg;
@property (nonatomic, strong) IBOutlet  QWLabel     *proName;
@property (nonatomic, strong) IBOutlet  QWLabel     *spec;
@property (nonatomic, strong) IBOutlet  QWLabel     *factory;

@end
