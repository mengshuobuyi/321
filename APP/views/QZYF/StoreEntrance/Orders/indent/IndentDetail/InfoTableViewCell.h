//
//  InfoTableViewCell.h
//  APP
//
//  Created by qw_imac on 15/12/29.
//  Copyright © 2015年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *indentNumber;
@property (weak, nonatomic) IBOutlet UILabel *postStyle;
@property (weak, nonatomic) IBOutlet UILabel *payStyle;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *message;

@end
