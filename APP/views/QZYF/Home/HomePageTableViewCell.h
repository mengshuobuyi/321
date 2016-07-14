//
//  HomePageTableViewCell.h
//  wenyao
//
//  Created by Pan@QW on 14-9-25.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@interface HomePageTableViewCell : MGSwipeTableCell
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, strong) IBOutlet  UILabel         *titleLabel;
@property (nonatomic, strong) IBOutlet  UIImageView     *nameIcon;
@property (nonatomic, strong) IBOutlet  UIImageView     *avatarImage;
@property (nonatomic, strong) IBOutlet  UILabel         *contentLabel;
@property (nonatomic, strong) IBOutlet  UILabel         *dateLabel;
@property (nonatomic, strong) IBOutlet  UIImageView     *sendImageIndicator;
@end
