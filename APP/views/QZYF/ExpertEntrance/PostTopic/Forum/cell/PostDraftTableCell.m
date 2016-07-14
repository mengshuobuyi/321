//
//  PostDraftTableCell.m
//  APP
//
//  Created by Martin.Liu on 16/1/18.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "PostDraftTableCell.h"
#import "ForumModel.h"
#import "UIImageView+WebCache.h"
#import "QWGlobalManager.h"
#import "UILabel+MAAttributeString.h"
#import "Forum.h"
@interface PostDraftTableCell()
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userRemarkLabel;
@property (strong, nonatomic) IBOutlet UILabel *levelLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userPositionImageView;
@property (strong, nonatomic) IBOutlet UILabel *userPositionLabel;

@property (strong, nonatomic) IBOutlet UILabel *resentLabel;

@property (strong, nonatomic) IBOutlet UILabel *postTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *postContentLabel;
@property (strong, nonatomic) IBOutlet UIView *imagesContianerView;
@property (strong, nonatomic) IBOutlet UIImageView *firstImageView;
@property (strong, nonatomic) IBOutlet UIImageView *secondImageView;
@property (strong, nonatomic) IBOutlet UIImageView *thirdImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_imagesContainerViewTop;  // 15
@end
@implementation PostDraftTableCell

- (void)awakeFromNib {

    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.cornerRadius = CGRectGetHeight(self.userImageView.frame)/2;
    self.userNameLabel.font = [UIFont systemFontOfSize:kFontS4];
    self.userNameLabel.textColor = RGBHex(qwColor8);
    // 药师 营养师标签
    self.userPositionLabel.font = [UIFont systemFontOfSize:kFontS5];
    self.userPositionLabel.textColor = RGBHex(qwColor3);
    self.userPositionLabel.text = nil;
    self.levelLabel.layer.masksToBounds = YES;
    self.levelLabel.layer.cornerRadius = 4;
    self.levelLabel.hidden = YES;
    self.userPositionImageView.hidden = YES;
    
    self.userRemarkLabel.font = [UIFont systemFontOfSize:kFontS5];
    self.userRemarkLabel.textColor = RGBHex(qwColor9);

    self.resentLabel.layer.masksToBounds = YES;
    self.resentLabel.layer.cornerRadius = 4;

    self.constraint_imagesContainerViewTop.constant = -1000;
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
//        [self.userImageView setImageWithURL:[NSURL URLWithString:QWGLOBALMANAGER.configure.expertAvatarUrl] placeholderImage:ForumDefaultImage];
        [self.userImageView setImageWithURL:[NSURL URLWithString:QWGLOBALMANAGER.configure.avatarUrl] placeholderImage:ForumDefaultImage];
        NSString* userName = nil;
        if (!StrIsEmpty(QWGLOBALMANAGER.configure.expertNickName)) {
            userName = QWGLOBALMANAGER.configure.expertNickName;
        }
        else if (!StrIsEmpty(QWGLOBALMANAGER.configure.expertMobile))
        {
            userName = QWGLOBALMANAGER.configure.expertMobile;
        }
        else
            userName = QWGLOBALMANAGER.configure.expertUserName;
        self.userNameLabel.text = userName;
        
        self.levelLabel.hidden = YES;
        self.userPositionImageView.hidden = YES;
        self.userPositionLabel.hidden = YES;
        switch (QWGLOBALMANAGER.configure.expertType) {
            case PosterType_Nomal:
            case PosterType_MaJia:
                break;
            case PosterType_YaoShi:
//                [self.userPositionImageView setImage:[UIImage imageNamed:@"pharmacist"]];
                self.userPositionLabel.hidden = NO;
                self.userPositionLabel.text = @"药师";
                break;
            case PosterType_YingYangShi:
//                [self.userPositionImageView setImage:[UIImage imageNamed:@"ic_expert"]];
                self.userPositionLabel.hidden = NO;
                self.userPositionLabel.text = @"营养师";
                break;
        }
        
        self.userRemarkLabel.text = [QWGLOBALMANAGER timeStrSinceNowWithPastDateStr:postDetail.postDate withFormatter:@"yyyy.MM.dd hh:mm"];
        self.userRemarkLabel.text = postDetail.postDate;
        [self.postTitleLabel ma_setAttributeText:postDetail.postTitle];
        NSMutableString* contentString = [NSMutableString string];
        for (QWPostContentInfo* postContent in postDetail.postContentList) {
            if (postContent.postContentType == 1) {
                if (!StrIsEmpty(postContent.postContent)) {
                    [contentString appendFormat:@"%@", postContent.postContent];
                    break;
                }
            }
        }
        [self.postContentLabel ma_setAttributeText:contentString];
        
        
        self.resentLabel.hidden = self.reSendBtn.hidden = !(postDraft.postStatus == PostStatusType_WaitForPost);
        __weak __typeof(self)weakSelf = self;
        self.reSendBtn.touchUpInsideBlock = ^{
            [Forum sendPostWithPostDetail:postDraft.postDetail isEditing:(postDetail.postStatus == PostStatusType_Editing) reminderExperts:[weakSelf expertIdsParamValue:postDraft.reminderExperts]];
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
