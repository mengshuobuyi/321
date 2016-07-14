//
//  PharmacyCommentTableViewCell.m
//  wenyao
//
//  Created by xiezhenghong on 14-9-17.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "PharmacyCommentTableViewCell.h"
#import "BranchModel.h"
#import "Appraise.h"

@implementation PharmacyCommentTableViewCell
@synthesize userName=userName;
@synthesize addDate=addDate;
@synthesize remark=remark;


+ (CGFloat)getCellHeight:(id)data{
    
    BranchAppraiseModel *model = (BranchAppraiseModel *)data;
    if (model.remark && ![model.remark isEqualToString:@""]) {
        CGSize size =[GLOBALMANAGER sizeText:model.remark font:fontSystem(kFontS4) limitWidth:APP_W-30];
        return 69-5+size.height;
    }else{
        return 60;
    }
}

+(float)getOldCellHeight:(id)data{
    
    QueryAppraiseModel *dict=(QueryAppraiseModel *)data;
    if (dict.remark && ![dict.remark isEqualToString:@""]) {
        CGSize size =[GLOBALMANAGER sizeText:dict.remark font:fontSystem(kFontS4) limitWidth:APP_W-30];
        return 69-5+size.height;
    }else
    {
        return 60;
    }
}


- (void)awakeFromNib
{
    [self.ratingView setImagesDeselected:@"star_none.png" partlySelected:@"star_half.png" fullSelected:@"star_full" andDelegate:nil];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setCell:(id)data{
    
    [super setCell:data];
    
    BranchAppraiseModel *model = (BranchAppraiseModel *)data;
    
    //昵称
    self.userName.text = model.nick;
    CGSize nameSize = [model.nick sizeWithFont:fontSystem(12) constrainedToSize:CGSizeMake(APP_W-130, CGFLOAT_MAX)];
    self.userName_layout_width.constant = nameSize.width+2;
    
    //性别
    if(model.sex){
        if(model.sex == 0) {
            self.sex.image = [UIImage imageNamed:@"ic_man"];
        } else if(model.sex == 1){
            self.sex.image = [UIImage imageNamed:@"ic_woman"];
        }
    }else {
        self.sex.image = nil;
    }
    
    //日期
    self.addDate.text = model.date;
    
    //评价内容
    self.remark.numberOfLines = 999;
    self.remark.text = model.remark;
    
    //星级
    self.ratingView.userInteractionEnabled = NO;
    int star = model.stars;
    star = star / 2;
    [self.ratingView displayRating:star];
}


- (void)setOldCell:(id)data{
    
    [super setCell:data];
    
    QueryAppraiseModel *dict=(QueryAppraiseModel *)data;
    
    NSString *strUserName = @"";
    if (![dict.sysNickname isEqualToString:@""]) {
        strUserName = dict.sysNickname;
    } else if (![dict.mark isEqualToString:@""]) {
        strUserName = dict.mark;
    } else if (![dict.nickname isEqualToString:@""]) {
        strUserName = dict.nickname;
    } else {
        strUserName = dict.mobile;
    }
    self.userName.text = strUserName;
    if(dict.sex){
        if([dict.sex integerValue] == 0) {
            self.sex.image = [UIImage imageNamed:@"ic_man"];
        } else if([dict.sex integerValue] == 1){
            self.sex.image = [UIImage imageNamed:@"ic_woman"];
        }
    }else {
        self.sex.image = nil;
    }
    self.addDate.text = dict.addDate;
    self.remark.numberOfLines = 999;
    self.remark.text = dict.remark;
    self.ratingView.userInteractionEnabled = NO;
    float star = [dict.star floatValue];
    star = star / 2;
    [self.ratingView displayRating:star];
}


@end
