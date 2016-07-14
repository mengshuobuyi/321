//
//  PostCommentTableCell.m
//  APP
//
//  Created by Martin.Liu on 16/1/4.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "PostCommentTableCell.h"
#import "UILabel+MAAttributeString.h"
#import "Forum.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Tint.h"
#import "QWGlobalManager.h"
#import "MAUILabel.h"

#define kAssistantStr @" \n \n \n "
#define kPostCommentLabelWidth (APP_W==320 ? 245 : (IS_IPHONE_6? 303 : (IS_IPHONE_6P ? 344 : 0)))
#define kPostReplyLabelWidth (APP_W==320 ? 230 : (IS_IPHONE_6? 285 : (IS_IPHONE_6P ? 324 : 0)))


@interface PostCommentTableCell()

@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userPositionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userPositionImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_userPositionImgLeading;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_userPositionImgTrailing;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_expandCommentBtnTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contraint_expandReplyBtnTop;

@property (strong, nonatomic) IBOutlet UILabel *userLevelLabel;
@property (strong, nonatomic) IBOutlet MAUILabel *userRemarkLabel;

@property (strong, nonatomic) IBOutlet UIView *pharmacistContainerView;


@property (strong, nonatomic) IBOutlet UILabel *floorLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentContextLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentTimeLabel;

@property (strong, nonatomic) IBOutlet UIView *replyContainerView;
@property (strong, nonatomic) IBOutlet UILabel *replyUserNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *replyContextLabel;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_replyViewTop; // default is 9
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_replyViewBottom;  // default is 16


@property (strong, nonatomic) IBOutlet UIView *expandCommentBtnView;
@property (strong, nonatomic) IBOutlet UIView *expandReplyBtnView;

@property (nonatomic, strong) NSDictionary* commentLabelAttribute;
@property (nonatomic, strong) NSDictionary* replyLabelAttribute;

// 4.0增加
@property (strong, nonatomic) IBOutlet UIView *expertActionAsistantView;
@property (strong, nonatomic) IBOutlet MAButtonWithTouchBlock *showExpertActionViewBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_expertActionAsistantViewLeading;

@end

@implementation PostCommentTableCell
{
    BOOL noHiddenThisTime;
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // 用户头像
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.cornerRadius = CGRectGetHeight(self.userImageView.frame)/2;
    // 用户昵称
    self.userNameLabel.font = [UIFont systemFontOfSize:kFontS4];
    self.userNameLabel.textColor = RGBHex(qwColor8);
    // 用户等级
    self.userLevelLabel.layer.masksToBounds = YES;
    self.userLevelLabel.layer.cornerRadius = 4;
    self.userLevelLabel.font = [UIFont systemFontOfSize:kFontS5];
    self.userLevelLabel.textColor = RGBHex(qwColor3);
    self.pharmacistContainerView.hidden = YES;
    // 药师 营养师标签
    self.userPositionLabel.font = [UIFont systemFontOfSize:kFontS5];
    self.userPositionLabel.textColor = RGBHex(qwColor3);

    // 药师所属药房
    self.userRemarkLabel.font = [UIFont systemFontOfSize:kFontS5];
    self.userRemarkLabel.textColor = RGBHex(qwColor4);
    self.userRemarkLabel.backgroundColor = RGBAHex(qwColor3, 0.6);
    self.userRemarkLabel.layer.masksToBounds = YES;
    self.userRemarkLabel.layer.cornerRadius = 4;
    [self setuserRemarkLabelText:nil];
    self.commentTimeLabel.font = [UIFont systemFontOfSize:kFontS5];
    self.commentTimeLabel.textColor = RGBHex(qwColor9);
    self.replyUserNameLabel.font = [UIFont systemFontOfSize:kFontS4];
    self.replyUserNameLabel.textColor = RGBHex(qwColor6);
    
//    self.posterLabel.hidden = YES;
//    self.posterLabel.layer.masksToBounds = YES;
//    self.posterLabel.layer.cornerRadius = 4;
//    self.posterLabel.layer.borderColor = RGBHex(qwColor10).CGColor;
//    self.posterLabel.layer.borderWidth = 1.f;
    
    [self.expandCommentBtn setTitleColor:RGBHex(qwColor1) forState:UIControlStateNormal];
    self.expandCommentBtn.titleLabel.font = [UIFont systemFontOfSize:kFontS5];
    [self.expandReplyBtn setTitleColor:RGBHex(qwColor1) forState:UIControlStateNormal];
    self.expandReplyBtn.titleLabel.font = [UIFont systemFontOfSize:kFontS5];
    
    [self showExpandCommentBtn:NO];
    [self showExpandReplyBtn:NO];
    
    self.expertActionView.hidden = YES;
    self.expertActionAsistantView.layer.cornerRadius = CGRectGetHeight(self.expertActionAsistantView.frame)/2;
    self.expertActionAsistantView.backgroundColor = RGBAHex(0x000000, 0.3);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCell:(id)obj
{
    noHiddenThisTime = NO;
    [self showExpertActionView:NO animate:NO];
    if ([obj isKindOfClass:[QWPostReply class]]) {
        QWPostReply* postReply = obj;
        [self.userImageView setImageWithURL:[NSURL URLWithString:postReply.headUrl] placeholderImage:ForumDefaultImage];
        self.userNameLabel.text = postReply.nickName;
        
//        self.userRemarkLabel.text = nil;
        [self setuserRemarkLabelText:nil];
        self.pharmacistContainerView.hidden = YES;
        self.userPositionImageView.hidden = YES;
        self.userPositionLabel.hidden = YES;
        self.userPositionLabel.text = nil;
        self.constraint_userPositionImgLeading.constant = self.constraint_userPositionImgTrailing.constant = 15;
        self.userLevelLabel.hidden = YES;
        self.floorLabel.hidden = NO;   // 楼层概念不对专家显示
        self.commentBtn.hidden = NO;
        self.showExpertActionViewBtn.hidden = NO;
        switch (postReply.replierType) {
            case PosterType_Nomal: // 普通用户
            case PosterType_MaJia:
                self.userLevelLabel.hidden = NO;
                self.userLevelLabel.text = [NSString stringWithFormat:@"V%ld", postReply.mbrLvl];
//                self.userRemarkLabel.text = nil;
                break;
            case PosterType_YaoShi:  {// 药师
                self.commentBtn.hidden = YES;  // 不能对药师评论
                self.floorLabel.hidden = YES; // 楼层概念不对专家显示
                self.pharmacistContainerView.hidden = NO;
                self.userPositionImageView.hidden = NO;
                self.userPositionLabel.hidden = NO;
                self.userPositionLabel.text = @"药师";
                self.constraint_userPositionImgLeading.constant = 4;
                self.constraint_userPositionImgTrailing.constant = 6;
                self.userPositionImageView.image = [UIImage imageNamed:@"pharmacist"];
//                self.userRemarkLabel.text = postReply.brandName;
                [self setuserRemarkLabelText:postReply.brandName];
                // 根据是否有回复内容来判断是给帖子回复还是给评论回复。
                BOOL hasReplyContent = !StrIsEmpty(postReply.replyUserName) || !StrIsEmpty(postReply.replyContent);
                //  对帖子进行的回复的评论
                if (hasReplyContent) {
                    self.pharmacistContainerView.hidden = YES;
                    self.commentBtn.hidden = NO;
                }
            }
                break;
            case PosterType_YingYangShi:  {// 营养师
                self.commentBtn.hidden = YES;  // 不能对药师专家
                self.floorLabel.hidden = YES; // 楼层概念不对专家显示
                self.pharmacistContainerView.hidden = NO;
                self.userPositionImageView.hidden = NO;
                self.userPositionLabel.hidden = NO;
                self.userPositionLabel.text = @"营养师";
                self.constraint_userPositionImgLeading.constant = 4;
                self.constraint_userPositionImgTrailing.constant = 6;
                self.userPositionImageView.image = [UIImage imageNamed:@"ic_expert"];
                [self setuserRemarkLabelText:postReply.brandName];
                BOOL hasReplyContent = !StrIsEmpty(postReply.replyUserName) || !StrIsEmpty(postReply.replyContent);
                //  对帖子进行的回复的评论
                if (hasReplyContent) {
                    self.pharmacistContainerView.hidden = YES;
                    self.commentBtn.hidden = NO;
                }
            }
                break;
            default:
                break;
        }
         // 楼主不显示
//        if (postReply.flagPoster) {
//            self.posterLabel.hidden = NO;
//        }
//        else
//        {
//            self.posterLabel.hidden = YES;
//        }
        self.praiseCountLabel.text = [NSString stringWithFormat:@"%ld", postReply.upVoteCount];
        self.floorLabel.text = [NSString stringWithFormat:@"%ld楼", postReply.floor];
        NSString* commentString = nil;
        if (postReply.silencedFlag) {
            commentString = @"该用户已被禁言";
            // 被禁言不可评论
            self.commentBtn.hidden = YES;
            // 被禁言的专家也是不可以评论点赞的
            self.showExpertActionViewBtn.hidden = YES;
        }
        else if (postReply.status == 2) {
            commentString = @"该评论已删除";
            // 评论被删除不可评论
            self.commentBtn.hidden = YES;
            // 被禁言的专家也是不可以评论点赞的
            self.showExpertActionViewBtn.hidden = YES;
        }
        else
            commentString = postReply.content;
        
        self.commentContextLabel.attributedText = [[NSAttributedString alloc] initWithString:commentString attributes:self.commentLabelAttribute];
        
        [self showExpandCommentBtn:YES];
        if (postReply.isExpandComment) {
            [self showExpandCommentBtn:NO];
        }
        else
        {
            // 字数是否多余四行
            BOOL showCommentExpBtn = [commentString boundingRectWithSize:CGSizeMake(kPostCommentLabelWidth, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.commentLabelAttribute context:nil].size.height > [kAssistantStr boundingRectWithSize:CGSizeMake(kPostCommentLabelWidth, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.commentLabelAttribute context:nil].size.height;
            [self showExpandCommentBtn:showCommentExpBtn];
        }
        
        self.commentTimeLabel.text = postReply.createDate;
        
        BOOL hiddenReplyView = StrIsEmpty(postReply.replyUserName) && StrIsEmpty(postReply.replyContent);
        [self hiddenReplyView:hiddenReplyView];
        
        self.replyUserNameLabel.text = StrIsEmpty(postReply.replyUserName) ? postReply.replyUserName : [postReply.replyUserName stringByAppendingString:@":"];

        NSString* replyContextString = nil;
        if (postReply.replySilencedFlag) {
            replyContextString = @"该用户已被禁言";
        }
        else
            replyContextString = postReply.replyContent;
        
        self.replyContextLabel.attributedText = [[NSAttributedString alloc] initWithString:replyContextString attributes:self.replyLabelAttribute];
        
        [self showExpandReplyBtn:NO];
        if (!hiddenReplyView) {
            if (postReply.isExpandReply) {
                [self showExpandReplyBtn:NO];
            }
            else
            {
                // 字数是否多余四行
                BOOL showReplyExpBtn = [replyContextString boundingRectWithSize:CGSizeMake(kPostReplyLabelWidth, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.commentLabelAttribute context:nil].size.height > [kAssistantStr boundingRectWithSize:CGSizeMake(kPostReplyLabelWidth, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.commentLabelAttribute context:nil].size.height;
                [self showExpandReplyBtn:showReplyExpBtn];
            }
        }

        if (postReply.flagZan) {
            self.praiseCountImageView.image = [UIImage imageNamed:@"ic_xiangqingpinglun_flowerpressed"];
        }
        else
        {
            self.praiseCountImageView.image = [UIImage imageNamed:@"ic_xiangqingpinglun_flower"];
        }
        
        // 自己不能评论自己的评论
        if ([postReply.replier isEqual:QWGLOBALMANAGER.configure.expertPassportId]) {
            self.commentBtn.hidden = YES;
//            // 不可以给自己点赞
//            self.showExpertActionViewBtn.hidden = YES;

        }
    }
}

- (void)setPharmacistView:(BOOL)isPharmacitst
{
    self.pharmacistContainerView.hidden = !isPharmacitst;
    [self hiddenReplyView:isPharmacitst];
    self.userPositionImageView.hidden = isPharmacitst;
    self.commentBtn.hidden = isPharmacitst;
}

- (void)hiddenReplyView:(BOOL)hidden
{
    // 针对药师和专家对评论的回复 ， 不隐藏楼层
    if (!hidden) {
        self.floorLabel.hidden = NO;
    }
    self.replyContainerView.hidden = hidden;
    if (hidden) {
        self.constraint_replyViewTop.constant = - 1000;
        self.replyUserNameLabel.text = nil;
        [self.replyContextLabel ma_setAttributeText:nil];
    }
    else
    {
        // 如果是药师或者专家回复评论则不给点赞
        self.pharmacistContainerView.hidden = YES;
        
        self.constraint_replyViewTop.constant = 9;
    }
}

- (void)showExpandCommentBtn:(BOOL)show
{
    // 特殊情况没有展开按钮，全部显示
    if (kPostCommentLabelWidth == 0) {
        self.constraint_expandCommentBtnTop.constant = -1000;
        self.commentContextLabel.numberOfLines = 0;
        self.expandCommentBtnView.hidden = YES;
        return;
    }
    if (show) {
        self.constraint_expandCommentBtnTop.constant = 2;
        self.commentContextLabel.numberOfLines = 4;
        self.expandCommentBtnView.hidden = NO;
    }
    else
    {
        self.constraint_expandCommentBtnTop.constant = -1000;
        self.commentContextLabel.numberOfLines = 0;
        self.expandCommentBtnView.hidden = YES;
    }
}

- (void)showExpandReplyBtn:(BOOL)show
{
    // 特殊情况没有展开按钮，全部显示
    if (kPostReplyLabelWidth == 0) {
        self.contraint_expandReplyBtnTop.constant = - 1000;
        self.replyContextLabel.numberOfLines = 0;
        self.expandReplyBtnView.hidden = YES;
        return;
    }
    if (show) {
        self.contraint_expandReplyBtnTop.constant = 0;
        self.replyContextLabel.numberOfLines = 4;
        self.expandReplyBtnView.hidden = NO;
    }
    else
    {
        self.contraint_expandReplyBtnTop.constant = - 1000;
        self.replyContextLabel.numberOfLines = 0;
        self.expandReplyBtnView.hidden = YES;
    }
}

- (NSDictionary *)commentLabelAttribute
{
    if (!_commentLabelAttribute) {
        NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 2;
        style.lineBreakMode = NSLineBreakByWordWrapping;
        _commentLabelAttribute = @{NSForegroundColorAttributeName:RGBHex(qwColor6),NSFontAttributeName:[UIFont systemFontOfSize:kFontS1],NSParagraphStyleAttributeName:style};
    }
    return _commentLabelAttribute;
}

- (NSDictionary *)replyLabelAttribute
{
    if (!_replyLabelAttribute) {
        NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 2;
        style.lineBreakMode = NSLineBreakByWordWrapping;
        _replyLabelAttribute = @{NSForegroundColorAttributeName:RGBHex(qwColor8),NSFontAttributeName:[UIFont systemFontOfSize:kFontS4],NSParagraphStyleAttributeName:style};
    }
    return _replyLabelAttribute;
}

- (void)setuserRemarkLabelText:(NSString*)userRemarkText
{
    // 隐藏
//    userRemarkText = nil;
    self.userRemarkLabel.text = userRemarkText;
    self.userRemarkLabel.edgeInsets = StrIsEmpty(userRemarkText) ? UIEdgeInsetsZero : UIEdgeInsetsMake(3, 3, 3, 3);
}

- (IBAction)clickShowExpertActionViewAction:(id)sender {
    if (self.expertActionView.hidden == YES) {
        noHiddenThisTime = YES;
        [QWGLOBALMANAGER postNotif:NotifHiddenPostdetailExpertActionView data:nil object:nil];
    }
    [self showExpertActionView:self.expertActionView.hidden animate:YES];
}

- (void)showExpertActionView:(BOOL)show animate:(BOOL)animated
{
    if (noHiddenThisTime == YES) {
        noHiddenThisTime = NO;
        return;
    }
    if (!animated) {
        if (show) {
            self.expertActionView.hidden = NO;
            self.constraint_expertActionAsistantViewLeading.constant = 0;
            [self layoutIfNeeded];
        }
        else
        {
            self.expertActionView.hidden = YES;
        }
    }
    else
    {
        __weak __typeof(self) weakSelf = self;
        if (show) {
            self.expertActionView.hidden = NO;
            self.constraint_expertActionAsistantViewLeading.constant = CGRectGetWidth(self.expertActionView.frame);
            [self layoutIfNeeded];
            [UIView animateWithDuration:0.15 animations:^{
                weakSelf.constraint_expertActionAsistantViewLeading.constant = 0;
                [weakSelf layoutIfNeeded];
            } completion:nil];
        }
        else
        {
            [UIView animateWithDuration:0.15 animations:^{
                weakSelf.constraint_expertActionAsistantViewLeading.constant = CGRectGetWidth(weakSelf.expertActionView.frame);
                [weakSelf layoutIfNeeded];
            } completion:^(BOOL finished) {
                weakSelf.expertActionView.hidden = YES;
            }];
        }
    }
}



@end
