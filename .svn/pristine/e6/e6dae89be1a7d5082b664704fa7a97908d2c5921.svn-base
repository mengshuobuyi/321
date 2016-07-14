//
//  MemberMarketConfirmView.m
//  wenYao-store
//
//  Created by PerryChen on 5/10/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "MemberMarketConfirmView.h"

@implementation MemberMarketConfirmView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    self.viewContent.layer.cornerRadius = 4.0f;
    self.btnCancel.layer.cornerRadius = self.btnConfirm.layer.cornerRadius = 4.0f;
    self.viewContent.layer.masksToBounds = YES;
    self.btnCancel.layer.masksToBounds = self.btnConfirm.layer.masksToBounds = YES;
    self.btnCancel.layer.borderWidth = 1.0f;
    self.btnCancel.layer.borderColor = RGBHex(qwColor2).CGColor;
}

- (IBAction)cancelAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cancelSelect)]) {
        [self.delegate cancelSelect];
    }
    [self removeSelf:nil];
}

- (IBAction)confirmAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(confirmSelect)]) {
        [self.delegate confirmSelect];
    }
    [self removeSelf:nil];
}

- (void)removeSelf:(UIButton *)sender {
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
