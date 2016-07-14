//
//  InputScanView.m
//  wenYao-store
//
//  Created by qw_imac on 16/1/6.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "InputScanView.h"

@implementation InputScanView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(InputScanView *)inputScanView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"InputScanView" owner:nil options:nil];
    InputScanView *View = (InputScanView *)[nibView objectAtIndex:0];
    View.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    View.height.constant = 0.0;
    return View;
}

-(void)removeSelf {
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
