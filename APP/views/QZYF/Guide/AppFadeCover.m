//
//  AppFadeCover.m
//  APP
//
//  Created by garfield on 15/7/10.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "AppFadeCover.h"

@implementation AppFadeCover

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [imageView setBackgroundColor:[UIColor yellowColor]];
        if(APP_H > 480.f) {
            [imageView setImage:[UIImage imageNamed:@"启动页1136"]];
        }else{
            [imageView setImage:[UIImage imageNamed:@"启动页960"]];
        }
        [self addSubview:imageView];
    }
    return self;
}

- (void)fadeOut
{
    [UIView animateWithDuration:2.0f delay:0.0f usingSpringWithDamping:0.6 initialSpringVelocity:0.2 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        self.alpha = 0.0;
        self.layer.transform = CATransform3DMakeScale(1.8, 1.8, 1.0);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}


@end
