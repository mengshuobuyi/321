//
//  MemberPointShortageView.m
//  wenYao-store
//
//  Created by PerryChen on 5/10/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "MemberPointShortageView.h"

@implementation MemberPointShortageView

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
    self.btnRechoose.layer.cornerRadius = 4.0f;
    self.viewContent.layer.masksToBounds = YES;
    self.btnRechoose.layer.masksToBounds = YES;
}

- (IBAction)actionRechoose:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(RechooseMember)]) {
        [self.delegate RechooseMember];
    }
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
