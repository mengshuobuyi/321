//
//  InternalProductSubtitleCell.m
//  wenYao-store
//
//  Created by PerryChen on 3/10/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "InternalProductSubtitleCell.h"

@implementation InternalProductSubtitleCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)UIGlobal
{
    self.titleLabel.font = fontSystem(kFontS4);
    self.contentLabel.font = fontSystem(kFontS4);
    
    self.titleLabel.textColor = RGBHex(qwGcolor7);
    self.contentLabel.textColor = RGBHex(qwGcolor6);
}

@end