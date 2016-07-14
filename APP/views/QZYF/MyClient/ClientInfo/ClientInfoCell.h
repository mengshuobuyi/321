//
//  ClientInfoCell.h
//  wenYao-store
//
//  Created by qwfy0006 on 15/5/4.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseTableCell.h"

@interface ClientInfoCell : QWBaseTableCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewRightArrow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintContentTrail;

@end
