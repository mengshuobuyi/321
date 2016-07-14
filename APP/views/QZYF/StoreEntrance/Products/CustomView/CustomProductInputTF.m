//
//  CustomProductInputTF.m
//  wenYao-store
//
//  Created by PerryChen on 6/13/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "CustomProductInputTF.h"
IB_DESIGNABLE
@implementation CustomProductInputTF

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 - (CGRect)textRectForBounds:(CGRect)bounds {
 return CGRectInset(bounds, 10, 10);
 }
 
 // text position
 - (CGRect)editingRectForBounds:(CGRect)bounds {
 return CGRectInset(bounds, 10, 10);
 }

@end
