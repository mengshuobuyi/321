//
//  RefusePayReasonView.m
//  wenYao-store
//
//  Created by qw_imac on 16/1/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "RefusePayReasonView.h"

@implementation RefusePayReasonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(RefusePayReasonView *)refuseView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"RefusePayReasonView" owner:nil options:nil];
    RefusePayReasonView *View = (RefusePayReasonView *)[nibView objectAtIndex:0];
    View.picker.showsSelectionIndicator = YES;

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
