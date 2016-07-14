//
//  ManageTableViewCell.h
//  wenyao-store
//
//  Created by chenpeng on 15/1/19.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QWBaseTableCell.h"
@interface TipProductTableViewCell : QWBaseTableCell

@property (weak, nonatomic) IBOutlet QWImageView *imgUrl;
@property (weak, nonatomic) IBOutlet QWLabel *name;

@property (weak, nonatomic) IBOutlet QWLabel *spec;
@property (weak, nonatomic) IBOutlet QWLabel *factory;
@property (weak, nonatomic) IBOutlet QWLabel *quantity;


@end
