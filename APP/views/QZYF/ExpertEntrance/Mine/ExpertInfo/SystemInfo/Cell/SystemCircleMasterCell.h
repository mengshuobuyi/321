//
//  SystemCircleMasterCell.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/20.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseTableCell.h"
#import "MGSwipeTableCell.h"
#import "QWLabel.h"

@interface SystemCircleMasterCell : MGSwipeTableCell

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *content;

@property (weak, nonatomic) IBOutlet QWLabel *circleName;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *content_layout_height;

@end
