//
//  MarketingActivityTableViewCell.h
//  wenyao-store
//
//  Created by xiezhenghong on 14-10-22.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
@interface MarketingActivityTableViewCell : MGSwipeTableCell

@property (nonatomic, strong) IBOutlet  UILabel     *titleLabel;
@property (nonatomic, strong) IBOutlet  UIImageView *avatarImage;
@property (nonatomic, strong) IBOutlet  UILabel     *contentLabel;
@property (nonatomic, strong) IBOutlet  UILabel     *dateLabel;

@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UILabel *sourceLable;

@end
