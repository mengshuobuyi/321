//
//  AcceptSuccessAlertView.m
//  wenYao-store
//
//  Created by qw_imac on 16/5/4.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "AcceptSuccessAlertView.h"
//#import "QWGlobalManager.h"
@implementation AcceptSuccessAlertView

- (void)awakeFromNib {
    _alertView.layer.cornerRadius = 5.0;
    _eventBtn.layer.cornerRadius = 3.0;
    _alertView.layer.masksToBounds = YES;
    _eventBtn.layer.masksToBounds = YES;
}
- (IBAction)chooseSwitch:(UISwitch *)sender {
//    DebugLog(@"switch value is %ld",sender.isOn);
    
}

- (IBAction)removeSelf:(UIButton *)sender {
    [QWUserDefault setBool:_mySwitch.isOn key:@"switchKeyPath"];
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
