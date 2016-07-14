//
//  ExpertCommentCell.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/12.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ExpertCommentCell.h"
#import "CircleModel.h"
#import "NSString+WPAttributedMarkup.h"

@implementation ExpertCommentCell

+ (CGFloat)getCellHeight:(id)data
{
    TeamMessageModel *model = (TeamMessageModel *)data;
    
    NSString *title = model.sourceTitle;
    CGSize titleSize = [QWGLOBALMANAGER sizeText:title font:fontSystem(14) limitWidth:APP_W-86];
    if (titleSize.height > 35) {
        titleSize.height = 35;
    }
    
    int width;
    width = APP_W-30;
    CGSize contentSize = [MLEmojiLabel expertInfoCommentNeedSizeWithText:model.msgContent WithConstrainSize:CGSizeMake(width, MAXFLOAT)];
    return 112-10+titleSize.height+contentSize.height-20;
}

- (void)UIGlobal
{
    [super UIGlobal];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.separatorLine.hidden = YES;
    
    self.applyLabel.layer.cornerRadius = 4.0;
    self.applyLabel.layer.masksToBounds = YES;
    
    self.commentContent.numberOfLines = 0;
    self.commentContent.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    self.commentContent.customEmojiPlistName = @"expressionImage_custom_backup.plist";
    self.commentContent.disableThreeCommon = YES;
}

- (void)setCell:(id)data
{
    [super setCell:data];
    
    TeamMessageModel *model = (TeamMessageModel *)data;
    
    self.applyLabel.hidden = NO;
    self.applyButton.hidden = NO;
    self.applyButton.enabled = YES;
    
    //时间
    self.time.text = model.createDate;
    
    
    //评论内容
    [self.commentContent setEmojiText:model.msgContent];
    
    //帖子标题
    self.topicTitle.text = model.sourceTitle;
    NSString *title = model.sourceTitle;
    CGSize titleSize = [QWGLOBALMANAGER sizeText:title font:fontSystem(14) limitWidth:APP_W-86];
    if (titleSize.height > 35) {
        titleSize.height = 35;
    }
    self.topicBg_layout_height.constant = 43-14+titleSize.height;
}

@end
