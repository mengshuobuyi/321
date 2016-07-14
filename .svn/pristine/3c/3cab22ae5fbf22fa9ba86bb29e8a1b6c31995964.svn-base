//
//  NewPostDraftTableCell.m
//  APP
//
//  Created by Martin.Liu on 16/6/22.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "NewPostDraftTableCell.h"
#import "MAButtonWithTouchBlock.h"
#import "ForumModel.h"
#import "UIImageView+WebCache.h"
#import "QWGlobalManager.h"
#import "UILabel+MAAttributeString.h"
#import "Forum.h"
#import "cssex.h"
@interface NewPostDraftTableCell()
@property (strong, nonatomic) IBOutlet UIView *myContainerView;
@property (strong, nonatomic) IBOutlet UILabel *draftTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *draftContentLabel;
@property (strong, nonatomic) IBOutlet UILabel *draftTimeLabel;
@property (strong, nonatomic) IBOutlet UIView *resentBtnContainerView;
@property (strong, nonatomic) IBOutlet UIView *resentBtnUnderLine;
@property (strong, nonatomic) IBOutlet MAButtonWithTouchBlock *resentBtn;
@end

@implementation NewPostDraftTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    QWCSS(self.draftTitleLabel, 2, 6);
    QWCSS(self.draftContentLabel, 4, 7);
    QWCSS(self.resentBtn, 4, 5);
    QWCSS(self.draftTimeLabel, 5, 7);
    self.myContainerView.backgroundColor = RGBHex(qwColor11);
    self.backgroundColor = RGBHex(qwColor11);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCell:(id)obj
{
    if ([obj isKindOfClass:[QWPostDrafts class]]) {
        QWPostDrafts* postDraft = obj;
        QWPostDetailModel* postDetail = postDraft.postDetail;
        
        [self.draftTitleLabel ma_setAttributeText:postDetail.postTitle];
        [self.draftTimeLabel ma_setAttributeText:postDetail.postTitle];
        self.draftTimeLabel.text = [QWGLOBALMANAGER timeStrSinceNowWithPastDateStr:postDetail.postDate withFormatter:@"yyyy.MM.dd hh:mm"];
        
        NSMutableString* contentString = [NSMutableString string];
        for (QWPostContentInfo* postContent in postDetail.postContentList) {
            if (postContent.postContentType == 1) {
                if (!StrIsEmpty(postContent.postContent)) {
                    [contentString appendFormat:@"%@", postContent.postContent];
                    break;
                }
            }
        }
        [self.draftContentLabel ma_setAttributeText:contentString];
        
        
        self.resentBtnContainerView.hidden = !(postDraft.postStatus == PostStatusType_WaitForPost);
        __weak __typeof(self)weakSelf = self;
        __weak QWPostDrafts* weakPostDraft = postDraft;
        self.resentBtn.touchUpInsideBlock = ^{
            [Forum sendPostWithPostDetail:weakPostDraft.postDetail isEditing:(weakPostDraft.postStatus == PostStatusType_Editing) reminderExperts:[weakSelf expertIdsParamValue:weakPostDraft.reminderExperts]];
        };
    }
}

- (NSString*)expertIdsParamValue:(NSArray*)reminderExpertArray
{
    NSMutableString* expertIdsValue = [NSMutableString stringWithString:@""];
    for (QWExpertInfoModel* expert in reminderExpertArray) {
        if (expert == [reminderExpertArray firstObject]) {
            [expertIdsValue appendString:expert.id];
        }
        else
            [expertIdsValue appendFormat:@"%@%@", SeparateStr, expert.id];
    }
    return expertIdsValue;
}

@end
