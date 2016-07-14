//
//  EditPostTextViewTableCell.m
//  APP
//
//  Created by Martin.Liu on 16/1/5.
//  Copyright © 2016年 carret. All rights reserved.
//
#define EditPostTextViewHeight 34
#import "EditPostTextViewTableCell.h"
#import "Forum.h"
@interface EditPostTextViewTableCell()<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_textViewHeight;

@property (strong, nonatomic) IBOutlet UIView *textViewContainerView;
@property (strong, nonatomic) QWPostContentInfo* cellModel;
@end

@implementation EditPostTextViewTableCell
{
    BOOL isDeleteKey;
}
- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.textViewContainerView.layer.masksToBounds = YES;
//    self.textViewContainerView.layer.cornerRadius = 4;
//    self.textViewContainerView.layer.borderColor = RGBHex(qwColor9).CGColor;
//    self.textViewContainerView.layer.borderWidth = 1/[UIScreen mainScreen].scale;
    self.textView.delegate = self;
    self.textView.font = [UIFont systemFontOfSize:kFontS11];
    self.textView.textColor = RGBHex(qwColor7);
    self.textView.placeholder = @"想说什么， 我这里都会记录~";
    self.textView.placeholderColor = RGBHex(qwColor9);
    isDeleteKey = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCell:(id)obj
{
    if([obj isKindOfClass:[QWPostContentInfo class]])
    {
        self.cellModel = obj;
        self.textView.text = self.cellModel.postContent;
        
        CGRect frame = self.textView.frame;
        if (kMarPostTextViewWidth > 0) {
            frame.size.width = kMarPostTextViewWidth;
        }
        self.textView.frame = frame;
        CGSize size = [self.textView sizeThatFits:CGSizeMake(CGRectGetWidth(self.textView.frame), MAXFLOAT)];
        self.constraint_textViewHeight.constant = MAX(EditPostTextViewHeight, size.height);
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
    self.cellModel.postContent = textView.text;
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
    CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
    CGRect frame = textView.frame;
    if (frame.size.height < size.height || (isDeleteKey && size.height > EditPostTextViewHeight && frame.size.height > size.height)) {
        if (self.changeHeightBlock) {
            self.changeHeightBlock();
        }
//        frame.size.height = size.height;
//        textView.frame = frame;
        
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
