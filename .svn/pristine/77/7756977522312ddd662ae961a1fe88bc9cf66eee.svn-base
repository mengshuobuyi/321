//
//  DisplayPostImageTextTableCell.m
//  APP
//
//  Created by Martin.Liu on 16/1/19.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "DisplayPostImageTextTableCell.h"
#import "FOrum.h"
#import "UIImageView+WebCache.h"
#import "UILabel+MAAttributeString.h"
@interface DisplayPostImageTextTableCell()
@property (strong, nonatomic) IBOutlet UIImageView *postImageView;
@property (strong, nonatomic) IBOutlet UILabel *postImageDescriptionLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_postImageViewHeight;  // default is 175
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_postImageDescriptionLBTop; // default is 11;

@end

@implementation DisplayPostImageTextTableCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.constraint_postImageDescriptionLBTop.constant = -15;
    self.postImageDescriptionLabel.font = [UIFont systemFontOfSize:kFontS5];
    self.postImageDescriptionLabel.textColor = RGBHex(qwColor7);
}

- (void)setCell:(id)obj
{
    if ([obj isKindOfClass:[QWPostContentInfo class]]) {
        QWPostContentInfo* postContentInfo = obj;
        NSString* urlString = postContentInfo.postContent;
        if ([NSURL URLWithString:urlString] == nil) {
            self.postImageView.image = ForumDefaultImage;
        }
        else
        {
            if ([[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:urlString]) {
                UIImage* image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:urlString];
                if (image.size.width > 0) {
                    self.constraint_postImageViewHeight.constant = (APP_W - 30) * image.size.height / image.size.width;
                }
                else
                {
                    self.constraint_postImageViewHeight.constant = 175;
                }
                self.postImageView.image = image;
            }
            else if ([[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlString])
            {
                 UIImage* image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlString];
                if (image.size.width > 0) {
                    self.constraint_postImageViewHeight.constant = (APP_W - 30) * image.size.height / image.size.width;
                }
                else
                {
                    self.constraint_postImageViewHeight.constant = 175;
                }
                self.postImageView.image = image;
            }
            else
            {
                __weak __typeof(self)weakSelf = self;
                [self.postImageView setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:ForumDefaultImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                    // tableview reload
                    if (!error && image && image.size.width > 0) {
                        if ([weakSelf.superview isKindOfClass:[UITableView class]]) {
                            [((UITableView*)weakSelf.superview) reloadData];
                        }
                        else if ([weakSelf.superview.superview isKindOfClass:[UITableView class]])
                        {
                            [((UITableView*)weakSelf.superview.superview) reloadData];
                        }
                    }
                }];
            }
        }
        // cell 重用的情况下出现的问题，原因找不到，只能这样解决一下。 文字会出现....
        if (StrIsEmpty(postContentInfo.postContentDesc)) {
            self.constraint_postImageDescriptionLBTop.constant = -15;
            [self.postImageDescriptionLabel ma_setAttributeText:@" "];
        }
        else
        {
            self.constraint_postImageDescriptionLBTop.constant = 11;
            [self.postImageDescriptionLabel ma_setAttributeText:postContentInfo.postContentDesc];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
