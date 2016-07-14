//
//  ExpertCommentCell.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/12.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseTableCell.h"
#import "MGSwipeTableCell.h"
#import "QWView.h"
#import "QWButton.h"
#import "MLEmojiLabel.h"

@interface ExpertCommentCell : MGSwipeTableCell

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet MLEmojiLabel *commentContent;  //内容
@property (weak, nonatomic) IBOutlet UILabel *time;                 //时间
@property (weak, nonatomic) IBOutlet UILabel *applyLabel;
@property (weak, nonatomic) IBOutlet QWButton *applyButton;         //回复按钮
@property (weak, nonatomic) IBOutlet UILabel *topicTitle;           //帖子标题

@property (weak, nonatomic) IBOutlet QWView *topicBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topicBg_layout_height;

@end
