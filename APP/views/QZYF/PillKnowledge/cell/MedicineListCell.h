//
//  MedicineListCell.h
//  wenyao
//
//  Created by Meng on 14-9-28.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QWBaseTableCell.h"
@interface MedicineListCell : QWBaseTableCell

@property (weak, nonatomic) IBOutlet QWImageView *headImageView;

@property (weak, nonatomic) IBOutlet QWLabel *proName;


@property (weak, nonatomic) IBOutlet QWLabel *spec;


@property (weak, nonatomic) IBOutlet QWLabel *factory;


@property (weak, nonatomic) IBOutlet QWLabel *tagLabel;

- (void)configureStoreData:(id)data;
- (void)configureExpertData:(id)data;

@end
