//
//  PharmacyCommentTableViewCell.h
//  wenyao
//
//  Created by xiezhenghong on 14-9-17.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"
#import "QWBaseTableCell.h"

@interface PharmacyCommentTableViewCell : QWBaseTableCell

@property (nonatomic, strong) IBOutlet RatingView  *ratingView;
@property (nonatomic, strong) IBOutlet QWLabel     *userName;
@property (nonatomic, strong) IBOutlet QWLabel     *remark;
@property (nonatomic, strong) IBOutlet QWLabel     *addDate;
@property (nonatomic, strong) IBOutlet UIImageView *sex;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userName_layout_width;


- (void)setOldCell:(id)data;
+(float)getOldCellHeight:(id)data;

@end
