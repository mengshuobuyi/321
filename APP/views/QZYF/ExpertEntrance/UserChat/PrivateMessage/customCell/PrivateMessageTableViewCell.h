//
//  PrivateMessageTableViewCell.h
//  wenYao-store
//
//  Created by 李坚 on 16/3/4.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpertMessageModel.h"

@interface PrivateMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgUrl;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *doctorImage;
@property (weak, nonatomic) IBOutlet UILabel *finalContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *unreadLabel;

+ (CGFloat)getCellHeight:(id)sender;

- (void)setCell:(IMChatPointVo *)model;

@end
