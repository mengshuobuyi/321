//
//  CancelAlertView.m
//  APP
//
//  Created by qw_imac on 15/12/29.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "CancelAlertView.h"

@implementation CancelAlertView

+(CancelAlertView *)cancelAlertView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CancelAlertView" owner:nil options:nil];
    CancelAlertView *View = (CancelAlertView *)[nibView objectAtIndex:0];
    View.picker.showsSelectionIndicator = YES;
    View.scanBtn.layer.cornerRadius = 4.0;
    View.scanBtn.layer.masksToBounds = YES;
   View.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    return View;
}
- (IBAction)cancelAction:(UIButton *)sender {
    [self removeSelf];
}

-(void)removeSelf {
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
