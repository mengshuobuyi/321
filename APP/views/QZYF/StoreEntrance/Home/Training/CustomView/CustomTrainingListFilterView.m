//
//  CustomTrainingListFilterView.m
//  wenYao-store
//
//  Created by PerryChen on 6/14/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "CustomTrainingListFilterView.h"

@implementation CustomTrainingListFilterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)actionCancel:(id)sender {
    self.blockCancel();
    [self removeFromSuperview];
}

- (IBAction)actionConfirm:(UIButton *)sender {
    self.lblAll.textColor = RGBHex(qwColor7);
    self.lblCurMerchant.textColor = RGBHex(qwColor7);
    self.imgTickAll.hidden = YES;
    self.imgTickCur.hidden = YES;
    if (sender == self.btnAll) {
        self.lblAll.textColor = RGBHex(qwColor1);
        self.imgTickAll.hidden = NO;
        self.blockConfirm(0);   // 全部
    } else {
        self.lblCurMerchant.textColor = RGBHex(qwColor1);
        self.imgTickCur.hidden = NO;
        self.blockConfirm(1);   // 本商家
    }
    [self removeFromSuperview];
}
@end
