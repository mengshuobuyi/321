//
//  JGCell.h
//  wenyao-store
//
//  Created by Meng on 14-10-23.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *gouView;
@property (weak, nonatomic) IBOutlet UIView *waitStatus;
@property (weak, nonatomic) IBOutlet UIView *timeOverStatus;
@property (weak, nonatomic) IBOutlet UIView *noPassStatus;
@property (weak, nonatomic) IBOutlet UILabel *notPerfectLabel;


@end
