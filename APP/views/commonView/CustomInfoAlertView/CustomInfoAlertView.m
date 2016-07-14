//
//  CustomInfoAlertView.m
//  APP
//
//  Created by PerryChen on 9/16/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import "CustomInfoAlertView.h"
#import "QWGlobalManager.h"
static CGFloat kDur= .25;
@interface CustomInfoAlertView()
{
    IBOutlet UIButton *btnCancel;
    IBOutlet UIButton *btnDirect;
    IBOutlet UIView *vShow;
}
@end

@implementation CustomInfoAlertView
+(id)instance
{
    static id sharedInstance;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CustomInfoAlertView" owner:nil options:nil];
        sharedInstance = [nibView objectAtIndex:0];
    });
    
    return sharedInstance;
}

//添加自己的view层
- (void)addToWindow{
    [super addToWindow];
    //    UIWindow *win=[UIApplication sharedApplication].keyWindow;
    //    CGRect frm=win.bounds;
    //    self.frame=frm;
    //    [win addSubview:self];
    //    [win bringSubviewToFront:self];
    
    
    vShow.layer.cornerRadius=4;
    
    
    btnCancel.layer.cornerRadius = 3;
    btnCancel.layer.borderWidth = 1;
    btnCancel.layer.borderColor=RGBHex(qwColor2).CGColor;
    
    btnDirect.layer.cornerRadius = 3;
    btnDirect.layer.borderWidth = 1;
    btnDirect.layer.borderColor=RGBHex(qwColor2).CGColor;
    
    //    [btnOK setTitleColor:RGBHex(qwColor4) forState:UIControlStateNormal];
    //    [btnOK setTitleColor:RGBHex(qwColor2) forState:UIControlStateHighlighted];
    [btnDirect setBackgroundImage:[self imageWithColor:RGBHex(qwColor2)] forState:UIControlStateNormal];
    [btnDirect setBackgroundImage:[self imageWithColor:RGBHex(qwColor4)] forState:UIControlStateHighlighted];
    btnCancel.clipsToBounds   = YES;
    
    //    [btnNO setTitleColor:RGBHex(qwColor2) forState:UIControlStateNormal];
    //    [btnNO setTitleColor:RGBHex(qwColor4) forState:UIControlStateHighlighted];
    [btnCancel setBackgroundImage:[self imageWithColor:RGBHex(qwColor4)] forState:UIControlStateNormal];
    [btnCancel setBackgroundImage:[self imageWithColor:RGBHex(qwColor2)] forState:UIControlStateHighlighted];
    btnDirect.clipsToBounds   = YES;
}

- (void)close{
    [UIView animateWithDuration:kDur animations:^{
        //        self.backgroundColor=RGBAHex(kColor1, 0);
        self.alpha=0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (IBAction)actionCancel:(id)sender {
    [self removeAlert];
//    if ([self.alertDelegate respondsToSelector:@selector(actionCancelWithAlert:)]) {
//        [self.alertDelegate actionCancelWithAlert:self];
//    }
    if (self.blockCancel != nil) {
        self.blockCancel(YES);
    }
    [self close];
}

- (IBAction)actionDirect:(id)sender {
    [self removeAlert];
    
//    if ([self.alertDelegate respondsToSelector:@selector(actionDirectWithAlert:)]) {
//        [self.alertDelegate actionDirectWithAlert:self];
//    }
    if (self.blockDirect != nil) {
        self.blockDirect(YES);
    }
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
