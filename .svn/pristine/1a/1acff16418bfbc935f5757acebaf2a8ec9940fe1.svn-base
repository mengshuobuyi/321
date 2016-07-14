//
//  GUITabLabel.m
//  GUITabPagerViewController
//
//  Created by  ChenTaiyu on 16/6/7.
//  Copyright © 2016年 Guilherme Araújo. All rights reserved.
//

#import "GUITabLabel.h"

@implementation GUITabLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIFont *font = fontSystem(kFontS4);
        UIColor *color = RGBHex(qwColor7);
        [self setTextAlignment:NSTextAlignmentCenter];
        [self setFont:font];
        [self setTextColor:color];
        self.normalColor = RGBHex(qwColor7);
        self.selectedColor = RGBHex(qwColor3);
    }
    return self;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self sizeToFit];
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    self.textColor = selected ? self.selectedColor : self.normalColor;
}

@end
