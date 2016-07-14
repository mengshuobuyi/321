//
//  AnswerCell.h
//  wenyao-store
//
//  Created by Meng on 14-10-9.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QWMessage.h"
@interface AnswerCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *img_head;
@property (strong, nonatomic) IBOutlet UILabel *lbl_DefineName;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Answercontent;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Time;
@property (strong, nonatomic) IBOutlet UIImageView *img_Tab;

-(void)setUpAnswer:(QWMessage *)msg;
@end
