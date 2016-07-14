//
//  
//  wenyao-store
//
//  Created by xiezhenghong on 14-10-22.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QWBaseTableCell.h"
@interface DoingActivityTableViewCell : QWBaseTableCell
@property (weak, nonatomic) IBOutlet QWLabel *desc;

@property (weak, nonatomic) IBOutlet QWLabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *imageUrl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftTextCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftTitleCon;

@end
