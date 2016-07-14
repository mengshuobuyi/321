//
//  MyFunsCell.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/7.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "MyFunsCell.h"
#import "CircleModel.h"

@implementation MyFunsCell

- (void)UIGlobal
{
    [super UIGlobal];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.separatorLine.hidden = YES;
    
    self.headerIcon.layer.cornerRadius = 26;
    self.headerIcon.layer.masksToBounds = YES;
}

- (void)setCell:(id)data
{
    [super setCell:data];
    
    CircleMaserlistModel *model = (CircleMaserlistModel *)data;
    
    //头像
    [self.headerIcon setImageWithURL:[NSURL URLWithString:model.headImageUrl] placeholderImage:[UIImage imageNamed:@"expert_ic_people"]];
    
    //名字
    self.funsName.text = model.nickName;
    
    //文章 帖子 数
    NSString *str = [NSString stringWithFormat:@"文章 %d   回帖 %d   关注专家 %d",model.postCount,model.replyCount,model.attnCount];
    NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange range1 = [[AttributedStr1 string]rangeOfString:@"文章"];
    NSRange range2 = [[AttributedStr1 string]rangeOfString:@"回帖"];
    NSRange range3 = [[AttributedStr1 string]rangeOfString:@"关注专家"];
    [AttributedStr1 addAttribute:NSFontAttributeName
                           value:fontSystem(kFontS5)
                           range:range1];
    [AttributedStr1 addAttribute:NSForegroundColorAttributeName
                           value:RGBHex(qwColor8)
                           range:range1];
    [AttributedStr1 addAttribute:NSFontAttributeName
                           value:fontSystem(kFontS5)
                           range:range2];
    [AttributedStr1 addAttribute:NSForegroundColorAttributeName
                           value:RGBHex(qwColor8)
                           range:range2];
    [AttributedStr1 addAttribute:NSFontAttributeName
                           value:fontSystem(kFontS5)
                           range:range3];
    [AttributedStr1 addAttribute:NSForegroundColorAttributeName
                           value:RGBHex(qwColor8)
                           range:range3];
    self.funsNumber.attributedText = AttributedStr1;

}

@end
