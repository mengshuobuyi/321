//
//  EmployInfoCell.h
//  wenyao-store
//
//  Created by Meng on 15/3/13.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@interface EmployInfoCell : MGSwipeTableCell
@property (weak, nonatomic) IBOutlet UILabel *EmployName;
@property (weak, nonatomic) IBOutlet UILabel *EmployPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *statuLabel;

@end
