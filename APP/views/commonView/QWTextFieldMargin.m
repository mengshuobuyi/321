//
//  QWTextFieldMargin.m
//  wenYao-store
//
//  Created by Yan Qingyang on 15/9/7.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWTextFieldMargin.h"

@implementation QWTextFieldMargin

//控制文本所在的的位置，左右缩 15
- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 15, 0);
}

//控制编辑文本时所在的位置，左右缩 15
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 15, 0);
}

@end
