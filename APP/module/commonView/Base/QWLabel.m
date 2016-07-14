//
//  QWLabel.m
//  APP
//
//  Created by carret on 15/3/5.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWLabel.h"

@interface QWLabel ()
/**
 *  add by Martin
 *  缓存边距
 */
@property (nonatomic, assign) UIEdgeInsets tmpEdgeInsets;
@end

@implementation QWLabel
@synthesize edgeInsets;

- (void)setLabelValue:(NSString*)value{
    //    NSLog(@"%@ %@",obj,value);
    if (self == nil) {
        return;
    }

    self.text= [NSString stringWithFormat:@"%@" ,value];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    // 如果内容为空的情况下，边距设置为0
    if (StrIsEmpty(text)) {
        if (!UIEdgeInsetsEqualToEdgeInsets(self.edgeInsets, UIEdgeInsetsZero)) {
            self.edgeInsets = UIEdgeInsetsZero;
        }
    }
    else
    {
        if (!UIEdgeInsetsEqualToEdgeInsets(self.edgeInsets, self.tmpEdgeInsets)) {
            self.edgeInsets = self.tmpEdgeInsets;
        }
    }
}

- (void)drawRect:(CGRect)rect

{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
    
}

- (CGSize)intrinsicContentSize

{
    
    CGSize size = [super intrinsicContentSize];
    
    size.width += self.edgeInsets.left + self.edgeInsets.right;
    
    size.height += self.edgeInsets.top + self.edgeInsets.bottom;
    
    return size;
    
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsetsV
{
    self.tmpEdgeInsets = edgeInsetsV;
    edgeInsets = edgeInsetsV;
    [self setNeedsDisplay];
}

@end
