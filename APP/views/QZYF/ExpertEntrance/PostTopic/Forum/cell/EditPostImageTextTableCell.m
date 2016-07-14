//
//  EditPostImageTextTableCell.m
//  APP
//
//  Created by Martin.Liu on 16/1/6.
//  Copyright © 2016年 carret. All rights reserved.
//

#define EditPostImageTextViewHeight 62

#import "EditPostImageTextTableCell.h"
#import "SendPostViewController.h"
#import "Forum.h"
//FIXME: 这是代码审查有问题的地方
@interface EditPostImageTextTableCell()<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIImageView *postImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_textViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_imageViewHeight;

@property (nonatomic, strong) QWPostContentInfoWithImage* cellModel;
@end

@implementation EditPostImageTextTableCell
{
    BOOL isDeleteKey;
}
- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.containerView.layer.masksToBounds = YES;
//    self.containerView.layer.cornerRadius = 4;
//    self.containerView.layer.borderColor = RGBHex(qwColor9).CGColor;
//    self.containerView.layer.borderWidth = 1/[UIScreen mainScreen].scale;
    self.textView.delegate = self;
    self.textView.font = [UIFont systemFontOfSize:kFontS4];
    self.textView.textColor = RGBHex(qwColor8);
    self.textView.placeholder = @"想说什么， 我这里都会记录~";
    isDeleteKey = NO;
    UIImage* defaultImage = ForumDefaultImage;
    self.postImageView.image = defaultImage;
    if (defaultImage && defaultImage.size.width > 0) {
        self.constraint_imageViewHeight.constant = CGRectGetWidth(self.postImageView.frame) * defaultImage.size.height / defaultImage.size.width;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCell:(id)obj
{
    if ([obj isKindOfClass:[QWPostContentInfo class]]) {
        self.cellModel = obj;
        self.textView.text = self.cellModel.postContentDesc;
        
        NSString* urlString = self.cellModel.postContent;
        if ([NSURL URLWithString:urlString] == nil) {
            self.postImageView.image = ForumDefaultImage;
        }
        else
        {
            if ([[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:urlString]) {
                UIImage* image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:urlString];
                if (image.size.width > 0) {
                    self.constraint_imageViewHeight.constant = CGRectGetWidth(self.postImageView.frame) * image.size.height / image.size.width;
                }
                else
                {
                    self.constraint_imageViewHeight.constant = 175;
                }
                self.postImageView.image = image;
            }
            else if ([[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlString])
            {
                UIImage* image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlString];
                if (image.size.width > 0) {
                    self.constraint_imageViewHeight.constant = CGRectGetWidth(self.postImageView.frame) * image.size.height / image.size.width;
                }
                else
                {
                    self.constraint_imageViewHeight.constant = 175;
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

        CGRect frame = self.textView.frame;
        if (kMarPostImageTextViewWidth > 0) {
            frame.size.width = kMarPostImageTextViewWidth;
        }
        self.textView.frame = frame;
        CGSize size = [self.textView sizeThatFits:CGSizeMake(CGRectGetWidth(self.textView.frame), MAXFLOAT)];
        //        CGSize size = [self getStringRectInTextView:self.textView.text InTextView:self.textView];
        self.constraint_textViewHeight.constant = MAX(EditPostImageTextViewHeight, size.height);

    }
}

#pragma UITextView Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    isDeleteKey = text.length == 0;
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    self.cellModel.postContentDesc = textView.text;
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    [self refreshTextViewSize:textView];
}

- (CGSize)getStringRectInTextView:(NSString *)string InTextView:(UITextView *)textView;
{
    //
    //    NSLog(@"行高  ＝ %f container = %@,xxx = %f",self.textview.font.lineHeight,self.textview.textContainer,self.textview.textContainer.lineFragmentPadding);
    //
    //实际textView显示时我们设定的宽
    CGFloat contentWidth = CGRectGetWidth(textView.frame);
    //但事实上内容需要除去显示的边框值
    CGFloat broadWith    = (textView.contentInset.left + textView.contentInset.right
                            + textView.textContainerInset.left
                            + textView.textContainerInset.right
                            + textView.textContainer.lineFragmentPadding/*左边距*/
                            + textView.textContainer.lineFragmentPadding/*右边距*/);
    
    CGFloat broadHeight  = (textView.contentInset.top
                            + textView.contentInset.bottom
                            + textView.textContainerInset.top
                            + textView.textContainerInset.bottom);//+self.textview.textContainer.lineFragmentPadding/*top*//*+theTextView.textContainer.lineFragmentPadding*//*there is no bottom padding*/);
    
    //由于求的是普通字符串产生的Rect来适应textView的宽
    contentWidth -= broadWith;
    
    CGSize InSize = CGSizeMake(contentWidth, MAXFLOAT);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = textView.textContainer.lineBreakMode;
    NSDictionary *dic = @{NSFontAttributeName:textView.font, NSParagraphStyleAttributeName:[paragraphStyle copy]};
    
    CGSize calculatedSize =  [string boundingRectWithSize:InSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    
    CGSize adjustedSize = CGSizeMake(ceilf(calculatedSize.width),calculatedSize.height + broadHeight);//ceilf(calculatedSize.height)
    return adjustedSize;
}


- (void)refreshTextViewSize:(UITextView *)textView
{
//    CGSize size = [self getStringRectInTextView:textView.text InTextView:textView];
    CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
    CGRect frame = textView.frame;
    if (frame.size.height < size.height || (isDeleteKey && size.height > EditPostImageTextViewHeight && frame.size.height > size.height)) {
        if (self.changeHeightBlock) {
            self.changeHeightBlock();
        }
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [QWGLOBALMANAGER postNotif:NotiEditPostTextViewBeginEdit data:nil object:@{@"indexPath":self.indexPath,@"textView":self.textView}];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [QWGLOBALMANAGER postNotif:NotiEditPostTextViewDidEndEdit data:nil object:self.indexPath];
}

@end
