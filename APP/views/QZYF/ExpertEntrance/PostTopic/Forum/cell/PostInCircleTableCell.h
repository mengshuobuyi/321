//
//  PostInCircleTableCell.h
//  APP
//
//  Created by Martin.Liu on 16/1/8.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Forum.h"
#import "MGSwipeTableCell.h"
#import "MAButtonWithTouchBlock.h"
@interface PostInCircleTableCell : MGSwipeTableCell

@property (strong, nonatomic) IBOutlet MAButtonWithTouchBlock *userInfoBtn;
@property (nonatomic, assign) PostCellType postCellType;
- (void)setCell:(id)obj;
@end
