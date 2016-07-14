//
//  MyFollowExpertCell.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/7.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "MyFollowExpertCell.h"
#import "NSString+WPAttributedMarkup.h"
#import "CircleModel.h"

@implementation MyFollowExpertCell

- (void)UIGlobal
{
    [super UIGlobal];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.separatorLine.hidden = YES;
    
    self.headerIcon.layer.cornerRadius = 26.0;
    self.headerIcon.layer.masksToBounds = YES;
    
    self.expertBrandName.layer.cornerRadius = 4.0;
    self.expertBrandName.layer.masksToBounds = YES;
}

- (void)setCell:(id)data
{
    [super setCell:data];
    CircleMaserlistModel *model = (CircleMaserlistModel *)data;
    
    //头像
    [self.headerIcon setImageWithURL:[NSURL URLWithString:model.headImageUrl] placeholderImage:[UIImage imageNamed:@"expert_ic_people"]];
    
    //姓名 地址
    NSString *name = model.nickName;
    CGSize nameSize = [name sizeWithFont:fontSystem(15) constrainedToSize:CGSizeMake(APP_W-85, CGFLOAT_MAX)];
    self.expertName_layout_width.constant = nameSize.width+6;
    self.expertName.text = name;
    
    NSString *store;
    NSString *imageName;
    if (model.userType == 3) { //药师
        store = model.groupName;
        imageName = @"药师";
        self.expertBrand_layout_left.constant = -5;
    }else if (model.userType == 4){ //营养师
        store = model.groupName;
        imageName = @"营养师";
        self.expertBrand_layout_left.constant = 5;
    }
    self.expertLogoLabel.text = StrFromObj(imageName);
    
    float maxWidth;
    if (model.userType == 3) {
        maxWidth = APP_W-85-nameSize.width-13-47;
    }else if (model.userType == 4){
        maxWidth = APP_W-85-nameSize.width-13-58;
    }
    
    CGSize brandSize = [store sizeWithFont:fontSystem(12) constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX)];
    self.expertBrand_layout_width.constant = brandSize.width+7;
    if (StrIsEmpty(store)) {
        self.expertBrandName.hidden = YES;
    }else{
        self.expertBrandName.hidden = NO;
        self.expertBrandName.text = store;
    }

    
    //文章 帖子 数
    NSString *str = [NSString stringWithFormat:@"文章 %d   回帖 %d",model.postCount,model.replyCount];
    NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange range1 = [[AttributedStr1 string]rangeOfString:@"文章"];
    NSRange range2 = [[AttributedStr1 string]rangeOfString:@"回帖"];
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
    self.number.attributedText = AttributedStr1;
    
}

@end
