//
//  EditInformationCell.m
//  wenyao-store
//
//  Created by qwfy0006 on 15/4/30.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import "EditInformationCell.h"

@implementation EditInformationCell


- (void)UIGlobal
{
    [super UIGlobal];
    
    self.separatorLine.backgroundColor = RGBHex(qwColor10);
    self.label.userInteractionEnabled = NO;
    
    //添加图片
    self.addTapBg.userInteractionEnabled = YES;
    UITapGestureRecognizer *addTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImage:)];
    [self.addTapBg addGestureRecognizer:addTap];
    
    //删除图片
    self.deleteTapBg.userInteractionEnabled = YES;
    UITapGestureRecognizer *deleteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteTap:)];
    [self.deleteTapBg addGestureRecognizer:deleteTap];
    
}

- (void)addImage:(UITapGestureRecognizer *)tap
{
    self.addTapBg = (UIImageView *)tap.view;
    if (self.delegate && [self.delegate respondsToSelector:@selector(addImageAction:)]) {
        [self.delegate addImageAction:self.addTapBg.tag];
    }
}

- (void)deleteTap:(UITapGestureRecognizer *)tap
{
    self.deleteTapBg = (UIImageView *)tap.view;
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteImageAction:)]) {
        [self.delegate deleteImageAction:self.deleteTapBg.tag];
    }
}

- (IBAction)pushToNext:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushToNextDelegate:)])
    {
        [self.delegate pushToNextDelegate:sender];
    }
}
@end
