//
//  MAUILabel.m
//  APP
//
//  Created by Martin.Liu on 16/4/18.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "MAUILabel.h"

@implementation MAUILabel

@synthesize edgeInsets;

- (id)initWithFrame:(CGRect)frame

{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        
    }
    
    return self;
    
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
    edgeInsets = edgeInsetsV;
    [self setNeedsDisplay];
}

@end
