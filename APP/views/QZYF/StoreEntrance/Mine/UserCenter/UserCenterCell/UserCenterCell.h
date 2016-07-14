//
//  UserCenterCell.h
//  APP
//
//  Created by qwfy0006 on 15/3/17.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseTableCell.h"

@interface UserCenterCell : QWBaseTableCell

@property (weak, nonatomic) IBOutlet QWLabel *title;
@property (weak, nonatomic) IBOutlet QWImageView *icon;
@property (weak, nonatomic) IBOutlet QWImageView *budge;

@end
