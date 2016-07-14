//
//  IndentDetailTopTableViewCell.h
//  APP
//
//  Created by qw_imac on 15/12/29.
//  Copyright © 2015年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndentDetailTopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIView *seprateLine;
@property (weak, nonatomic) IBOutlet UIImageView *refundImg;
@property (weak, nonatomic) IBOutlet UILabel *payStatusLabel;

@end
