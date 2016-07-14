//
//  MemberMarketSelectOrderNumView.m
//  wenYao-store
//
//  Created by PerryChen on 5/10/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "MemberMarketSelectOrderNumView.h"

@implementation MemberMarketSelectOrderNumView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
//    [self setViewSelectStyle];
}

- (void)setViewSelectStyle
{
    self.lblOrderOne.textColor = self.lblOrderTwo.textColor = self.lblOrderThree.textColor = self.lblOrderInfinite.textColor = RGBHex(qwColor6);
    self.imgViewOrderOne.hidden = self.imgViewOrderTwo.hidden = self.imgVIewOrderThree.hidden = self.imgViewOrderInfinite.hidden = YES;
    if (self.selectOrderNo == 0) {
        self.lblOrderInfinite.textColor = RGBHex(qwColor1);
        self.imgViewOrderInfinite.hidden = NO;
    } else if (self.selectOrderNo == 1) {
        self.lblOrderOne.textColor = RGBHex(qwColor1);
        self.imgViewOrderOne.hidden = NO;
    } else if (self.selectOrderNo == 2) {
        self.lblOrderTwo.textColor = RGBHex(qwColor1);
        self.imgViewOrderTwo.hidden = NO;
    } else if (self.selectOrderNo == 3) {
        self.lblOrderThree.textColor = RGBHex(qwColor1);
        self.imgVIewOrderThree.hidden = NO;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
    
}

- (void)tap
{
    [self dismissSelf];
}

- (IBAction)actionInfinite:(id)sender {
    self.selectOrderNo = 0;
    [self setViewSelectStyle];
    [self dismissSelf];
}
- (IBAction)actionOne:(id)sender {
    self.selectOrderNo = 1;
    [self setViewSelectStyle];
    [self dismissSelf];
}
- (IBAction)actionTwo:(id)sender {
    self.selectOrderNo = 2;
    [self setViewSelectStyle];
    [self dismissSelf];
}
- (IBAction)actionThree:(id)sender {
    self.selectOrderNo = 3;
    [self setViewSelectStyle];
    [self dismissSelf];
}

- (void)dismissSelf
{
    if ([self.delegate respondsToSelector:@selector(chooseOrderNum:)]) {
        [self.delegate chooseOrderNum:self.selectOrderNo];
    }
    [UIView animateWithDuration:0.4 animations:^{
        self.viewContent.alpha = 0;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    } completion:^(BOOL finished) {
        self.delegate = nil;
        [self removeFromSuperview];
    }];
}

@end
