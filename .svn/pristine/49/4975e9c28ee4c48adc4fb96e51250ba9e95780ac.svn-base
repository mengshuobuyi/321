//
//  PostInCircleTableCell.m
//  APP
//
//  Created by Martin.Liu on 16/1/8.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "PostInCircleTableCell.h"
#import "UIImageView+WebCache.h"
#import "UILabel+MAAttributeString.h"
@interface PostInCircleTableCell()

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_hrLineHeight;

@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userRemarkLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userPositionImageView;
@property (strong, nonatomic) IBOutlet UILabel *userLevelLabel;
@property (strong, nonatomic) IBOutlet UILabel *viewCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *postTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *postTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *postContentLabel;
@property (strong, nonatomic) IBOutlet UIView *imagesContianerView;
@property (strong, nonatomic) IBOutlet UIImageView *firstImageView;
@property (strong, nonatomic) IBOutlet UIImageView *secondImageView;
@property (strong, nonatomic) IBOutlet UIImageView *thirdImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_imagesContainerViewTop;  // 15



@end

@implementation PostInCircleTableCell

- (void)awakeFromNib {
    self.constraint_hrLineHeight.constant = 1.f/[[UIScreen mainScreen] scale];
    
    self.userLevelLabel.layer.masksToBounds = YES;
    self.userLevelLabel.layer.cornerRadius = 4;
    self.userLevelLabel.hidden = YES;
    self.userPositionImageView.hidden = YES;
    
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.cornerRadius = CGRectGetHeight(self.userImageView.frame)/2;
    self.userNameLabel.font = [UIFont systemFontOfSize:kFontS4];
    self.userNameLabel.textColor = RGBHex(qwColor8);
    
    self.userRemarkLabel.font = [UIFont systemFontOfSize:kFontS5];
    self.userRemarkLabel.textColor = RGBHex(qwColor9);
    
    self.postTypeLabel.layer.masksToBounds = YES;
    self.postTypeLabel.layer.cornerRadius = 3;
}

- (void)setCell:(id)obj
{
    if ([obj isKindOfClass:[QWPostModel class]]) {
        QWPostModel* postModel = obj;
        [self.userImageView setImageWithURL:[NSURL URLWithString:postModel.headUrl] placeholderImage:ForumDefaultImage];
        self.userNameLabel.text = postModel.nickname;
        self.userRemarkLabel.text = postModel.postStrDate;
        [self.postTitleLabel ma_setAttributeText:postModel.postTitle];
        self.viewCountLabel.text = [NSString stringWithFormat:@"%ld", (long)postModel.readCount];
        self.commentCountLabel.text = [NSString stringWithFormat:@"%ld", (long)postModel.replyCount];
        [self.postContentLabel ma_setAttributeText:postModel.postContent];
        
        // 用户等级
        self.userPositionImageView.hidden = YES;
        self.userLevelLabel.hidden = YES;
        switch (postModel.posterType) {
            case PosterType_Nomal: // 普通用户
            case PosterType_MaJia:
                self.userLevelLabel.hidden = NO;
                self.userLevelLabel.text = [NSString stringWithFormat:@"V%ld", (long)postModel.mbrLvl];
                break;
            case PosterType_YaoShi:  // 药师
                self.userPositionImageView.hidden = NO;
                self.userPositionImageView.image = [UIImage imageNamed:@"pharmacist"];
                break;
            case PosterType_YingYangShi:  // 营养师
                self.userPositionImageView.hidden = NO;
                self.userPositionImageView.image = [UIImage imageNamed:@"ic_expert"];
                break;
            default:
                break;
        }

        // 优先级  置顶 > 专栏 > 热门
        // 有置顶的页面  ： 热议 、 专栏（发帖），圈子详情的看帖
        NSString* whiteSpaceString = @"       ";
        if (postModel.flagTopHot && (self.postCellType == PostCellType_HotDiscuss || self.postCellType == PostCellType_SpecailColumn || self.postCellType == PostCellType_LookPost)) {
            self.postTypeLabel.hidden = NO;
            self.postTypeLabel.backgroundColor = RGBHex(qwColor2);
            self.postTypeLabel.text = @"置顶";
            [self.postTitleLabel ma_setAttributeText:[whiteSpaceString stringByAppendingString:postModel.postTitle]];
        }
        // 有专栏的页面  :  热议 、 圈子详情的看帖 、 收藏的帖子
        else if ((postModel.posterType == 3 || postModel.posterType == 4) && (self.postCellType == PostCellType_HotDiscuss || self.postCellType == PostCellType_LookPost || self.postCellType == PostCellType_CollectionPost))
        {
            self.postTypeLabel.hidden = NO;
            self.postTypeLabel.backgroundColor = RGBHex(qwColor13);
            self.postTypeLabel.text = @"专栏";
            [self.postTitleLabel ma_setAttributeText:[whiteSpaceString stringByAppendingString:postModel.postTitle]];
        }
        // 有热门的页面 ： 专栏（发帖） 、 圈子详情的看帖 、 圈子详情的专家 、 Ta的发帖 、 我的发帖 、 收藏的帖子
        else if (postModel.isHot && (self.postCellType == PostCellType_SpecailColumn || self.postCellType == PostCellType_LookPost || self.postCellType == PostCellType_Expert || self.postCellType == PostCellType_HisSendPost || self.postCellType == PostCellType_MineSendPost || self.postCellType == PostCellType_CollectionPost))
        {
            self.postTypeLabel.hidden = NO;
            self.postTypeLabel.backgroundColor = RGBHex(qwColor3);
            self.postTypeLabel.text = @"热门";
            [self.postTitleLabel ma_setAttributeText:[whiteSpaceString stringByAppendingString:postModel.postTitle]];
        }
        else
        {
            self.postTypeLabel.hidden = YES;
            [self.postTitleLabel ma_setAttributeText:postModel.postTitle];
        }
        
        if ([postModel.postImgList isKindOfClass:[NSArray class]] && postModel.postImgList.count > 0) {
            self.constraint_imagesContainerViewTop.constant = 15;
            switch (MIN(postModel.postImgList.count, 3)) {
                case 1:
                    self.firstImageView.hidden = NO;
                    self.secondImageView.hidden = YES;
                    self.thirdImageView.hidden = YES;
                    [self.firstImageView setImageWithURL:[NSURL URLWithString:postModel.postImgList[0]] placeholderImage:ForumDefaultImage];
                    break;
                case 2:
                    self.firstImageView.hidden = NO;
                    self.secondImageView.hidden = NO;
                    self.thirdImageView.hidden = YES;
                    [self.firstImageView setImageWithURL:[NSURL URLWithString:postModel.postImgList[0]] placeholderImage:ForumDefaultImage];
                    [self.secondImageView setImageWithURL:[NSURL URLWithString:postModel.postImgList[1]] placeholderImage:ForumDefaultImage];
                    break;
                case 3:
                    self.firstImageView.hidden = NO;
                    self.secondImageView.hidden = NO;
                    self.thirdImageView.hidden = NO;
                    [self.firstImageView setImageWithURL:[NSURL URLWithString:postModel.postImgList[0]] placeholderImage:ForumDefaultImage];
                    [self.secondImageView setImageWithURL:[NSURL URLWithString:postModel.postImgList[1]] placeholderImage:ForumDefaultImage];
                    [self.thirdImageView setImageWithURL:[NSURL URLWithString:postModel.postImgList[2]] placeholderImage:ForumDefaultImage];
                    break;
            }
        }
        else
        {
            self.constraint_imagesContainerViewTop.constant = -1000;
        }
    }
    else if ([obj isKindOfClass:[QWPostModel class]])
    {
        QWPostModel* postModel = obj;
        [self.userImageView setImageWithURL:[NSURL URLWithString:postModel.headUrl] placeholderImage:ForumDefaultImage];
        self.userNameLabel.text = postModel.nickname;
        self.userRemarkLabel.text = postModel.postStrDate;
        [self.postTitleLabel ma_setAttributeText:postModel.postTitle];
        self.viewCountLabel.text = [NSString stringWithFormat:@"%ld", (long)postModel.readCount];
        self.commentCountLabel.text = [NSString stringWithFormat:@"%ld", (long)postModel.replyCount];
        [self.postContentLabel ma_setAttributeText:postModel.postContent];
        
        // 用户等级
        self.userPositionImageView.hidden = YES;
        self.userLevelLabel.hidden = YES;
        switch (postModel.posterType) {
            case PosterType_Nomal: // 普通用户
            case PosterType_MaJia:
                self.userLevelLabel.hidden = NO;
                self.userLevelLabel.text = [NSString stringWithFormat:@"V%ld", postModel.mbrLvl];
                break;
            case PosterType_YaoShi:  // 药师
                self.userPositionImageView.hidden = NO;
                self.userPositionImageView.image = [UIImage imageNamed:@"pharmacist"];
                break;
            case PosterType_YingYangShi:  // 营养师
                self.userPositionImageView.hidden = NO;
                self.userPositionImageView.image = [UIImage imageNamed:@"ic_expert"];
                break;
            default:
                break;
        }

        
        // 优先级  置顶 > 专栏 > 热门
        // 有置顶的页面  ： 热议 、 专栏（发帖），圈子详情的看帖
        NSString* whiteSpaceString = @"       ";
        if (postModel.flagTopHot && (self.postCellType == PostCellType_HotDiscuss || self.postCellType == PostCellType_SpecailColumn || self.postCellType == PostCellType_LookPost)) {
            self.postTypeLabel.hidden = NO;
            self.postTypeLabel.backgroundColor = RGBHex(qwColor2);
            self.postTypeLabel.text = @"置顶";
            [self.postTitleLabel ma_setAttributeText:[whiteSpaceString stringByAppendingString:postModel.postTitle]];
        }
        // 有专栏的页面  :  热议 、 圈子详情的看帖 、 收藏的帖子
        else if ((postModel.posterType == 3 || postModel.posterType == 4) && (self.postCellType == PostCellType_HotDiscuss || self.postCellType == PostCellType_LookPost || self.postCellType == PostCellType_CollectionPost))
        {
            self.postTypeLabel.hidden = NO;
            self.postTypeLabel.backgroundColor = RGBHex(qwColor13);
            self.postTypeLabel.text = @"专栏";
            [self.postTitleLabel ma_setAttributeText:[whiteSpaceString stringByAppendingString:postModel.postTitle]];
        }
        // 有热门的页面 ： 专栏（发帖） 、 圈子详情的看帖 、 圈子详情的专家 、 Ta的发帖 、 我的发帖 、 收藏的帖子
        else if (postModel.isHot && (self.postCellType == PostCellType_SpecailColumn || self.postCellType == PostCellType_LookPost || self.postCellType == PostCellType_Expert || self.postCellType == PostCellType_HisSendPost || self.postCellType == PostCellType_MineSendPost || self.postCellType == PostCellType_CollectionPost))
        {
            self.postTypeLabel.hidden = NO;
            self.postTypeLabel.backgroundColor = RGBHex(qwColor3);
            self.postTypeLabel.text = @"热门";
            [self.postTitleLabel ma_setAttributeText:[whiteSpaceString stringByAppendingString:postModel.postTitle]];
        }
        else
        {
            self.postTypeLabel.hidden = YES;
            [self.postTitleLabel ma_setAttributeText:postModel.postTitle];
        }

        
        if ([postModel.postImgList isKindOfClass:[NSArray class]] && postModel.postImgList.count > 0) {
            self.constraint_imagesContainerViewTop.constant = 15;
            switch (MIN(postModel.postImgList.count, 3)) {
                case 1:
                    self.firstImageView.hidden = NO;
                    self.secondImageView.hidden = YES;
                    self.thirdImageView.hidden = YES;
                    [self.firstImageView setImageWithURL:[NSURL URLWithString:postModel.postImgList[0]] placeholderImage:ForumDefaultImage];
                    break;
                case 2:
                    self.firstImageView.hidden = NO;
                    self.secondImageView.hidden = NO;
                    self.thirdImageView.hidden = YES;
                    [self.firstImageView setImageWithURL:[NSURL URLWithString:postModel.postImgList[0]] placeholderImage:ForumDefaultImage];
                    [self.secondImageView setImageWithURL:[NSURL URLWithString:postModel.postImgList[1]] placeholderImage:ForumDefaultImage];
                    break;
                case 3:
                    self.firstImageView.hidden = NO;
                    self.secondImageView.hidden = NO;
                    self.thirdImageView.hidden = NO;
                    [self.firstImageView setImageWithURL:[NSURL URLWithString:postModel.postImgList[0]] placeholderImage:ForumDefaultImage];
                    [self.secondImageView setImageWithURL:[NSURL URLWithString:postModel.postImgList[1]] placeholderImage:ForumDefaultImage];
                    [self.thirdImageView setImageWithURL:[NSURL URLWithString:postModel.postImgList[2]] placeholderImage:ForumDefaultImage];
                    break;
            }
        }
        else
        {
            self.constraint_imagesContainerViewTop.constant = -1000;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
