//
//  InternalProductFootCell.m
//  wenYao-store
//
//  Created by PerryChen on 3/10/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "InternalProductFootCell.h"

@implementation InternalProductFootCell
@dynamic delegate;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)UIGlobal
{
    self.generateCodeView.backgroundColor = RGBHex(qwMcolor2);
    self.generateCodeView.layer.cornerRadius = 4.0f;
//    self.switchOnView.backgroundColor = RGBHex(qwGcolor11);
    self.switchOnView.layer.cornerRadius = 4.0f;
    self.switchOnView.layer.borderWidth = 1.0f;
    
    
    self.generateCodeLabel.textColor = RGBHex(qwGcolor11);
    self.generateCodeLabel.font = self.switchOnLabel.font = fontSystem(kFontS3);
    
}

- (IBAction)generateCodeAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(generateAction)]) {
        [self.delegate generateAction];
    }
}

- (IBAction)swichtOnAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(switchAction)]) {
        [self.delegate switchAction];
    }
}
@end
