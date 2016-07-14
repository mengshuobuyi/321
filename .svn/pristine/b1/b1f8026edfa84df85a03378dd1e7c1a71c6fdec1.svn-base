//
//  PostCommentTableCell.h
//  APP
//
//  Created by Martin.Liu on 16/1/4.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAButtonWithTouchBlock.h"
#import "MGSwipeTableCell.h"
@interface PostCommentTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet MAButtonWithTouchBlock *userInfoBtn;
@property (strong, nonatomic) IBOutlet MAButtonWithTouchBlock *commentBtn;
@property (strong, nonatomic) IBOutlet MAButtonWithTouchBlock *deleteBtn;
@property (strong, nonatomic) IBOutlet MAButtonWithTouchBlock *expandCommentBtn;
@property (strong, nonatomic) IBOutlet MAButtonWithTouchBlock *expandReplyBtn;

@property (strong, nonatomic) IBOutlet UILabel *posterLabel;

@property (strong, nonatomic) IBOutlet UIImageView *praiseCountImageView;

// 4.0增加
@property (strong, nonatomic) IBOutlet UIView *expertActionView;
@property (strong, nonatomic) IBOutlet MAButtonWithTouchBlock *expertCommentBtn;
@property (strong, nonatomic) IBOutlet MAButtonWithTouchBlock *praiseBtn;
@property (strong, nonatomic) IBOutlet UILabel *praiseCountLabel;
- (void)setCell:(id)obj;
- (void)showExpertActionView:(BOOL)show animate:(BOOL)animated;
@end
