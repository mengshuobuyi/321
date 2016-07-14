//
//  SoftwareUserInfoCell.m
//  wenYao-store
//
//  Created by YYX on 15/7/6.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "SoftwareUserInfoCell.h"

@implementation SoftwareUserInfoCell

- (void)UIGlobal
{
    [super UIGlobal];
    
    [self setSeparatorMargin:0 edge:EdgeLeft];
    self.separatorLine.backgroundColor = RGBHex(qwColor10);
    
    self.label.userInteractionEnabled = NO;
    
    self.addTapBg.userInteractionEnabled = YES;
    UITapGestureRecognizer *addTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImage:)];
    [self.addTapBg addGestureRecognizer:addTap];
    
    self.deleteTapBg.userInteractionEnabled = YES;
    UITapGestureRecognizer *deleteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteTap:)];
    [self.deleteTapBg addGestureRecognizer:deleteTap];
    
}

// 添加身份证 action

- (void)addImage:(UITapGestureRecognizer *)tap
{
    self.addTapBg = (UIImageView *)tap.view;
    if (self.softwareUserInfoCellDelegate && [self.softwareUserInfoCellDelegate respondsToSelector:@selector(addImageAction:)]) {
        [self.softwareUserInfoCellDelegate addImageAction:self.addTapBg.tag];
    }
}

//删除身份证 action

- (void)deleteTap:(UITapGestureRecognizer *)tap
{
    self.deleteTapBg = (UIImageView *)tap.view;
    if (self.softwareUserInfoCellDelegate && [self.softwareUserInfoCellDelegate respondsToSelector:@selector(deleteImageAction:)]) {
        [self.softwareUserInfoCellDelegate deleteImageAction:self.deleteTapBg.tag];
    }
}

// 跳转到下一页 action

- (IBAction)pushToNext:(id)sender {
    
    if (self.softwareUserInfoCellDelegate && [self.softwareUserInfoCellDelegate respondsToSelector:@selector(pushToNextDelegate:)]) {
        
        [self.softwareUserInfoCellDelegate pushToNextDelegate:sender];
    }
}


@end
