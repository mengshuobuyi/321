//
//  CircleTableCell.h
//  APP
//
//  Created by Martin.Liu on 15/12/30.
//  Copyright © 2015年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAButtonWithTouchBlock.h"
#import "ForumModel.h"
@interface CircleTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet MAButtonWithTouchBlock *careBtn;
@property (strong, nonatomic) IBOutlet MAButtonWithTouchBlock *chooseBtn;

@property (nonatomic, assign) CircleCellType circleType;
//@property (nonatomic, assign) BOOL hiddenCareBtn;
- (void)setCell:(id)obj;
@end
