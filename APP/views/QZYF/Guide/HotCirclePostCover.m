//
//  HotCirclePostCover.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/16.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "HotCirclePostCover.h"
#import "Constant.h"
#import "AppDelegate.h"

@interface HotCirclePostCover ()

@property (strong, nonatomic) UIImageView *imageOne;
@property (strong, nonatomic) UIImageView *imageTwo;

@end

@implementation HotCirclePostCover

- (id)init
{
    CGRect frame = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 1.0;
        self.imageOne = [[UIImageView alloc] init];
        self.imageOne.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        
        if (IS_IPHONE_4_OR_LESS) {
            self.imageOne.image = [UIImage imageNamed:@"hot_circle_post_4s"];
        }else if (IS_IPHONE_5){
            self.imageOne.image = [UIImage imageNamed:@"hot_circle_post_6p"];
        }else if (IS_IPHONE_6){
            self.imageOne.image = [UIImage imageNamed:@"hot_circle_post_6"];
        }else if (IS_IPHONE_6P){
            self.imageOne.image = [UIImage imageNamed:@"hot_circle_post_6p"];
        }
        
        self.imageOne.hidden = NO;
        [self addSubview:self.imageOne];
        
        self.imageOne.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOneAction:)];
        [self.imageOne addGestureRecognizer:tap1];
        
        
        self.imageTwo = [[UIImageView alloc] init];
        self.imageTwo.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        
        if (IS_IPHONE_4_OR_LESS) {
            self.imageTwo.image = [UIImage imageNamed:@"hot_circle_all_4s"];
        }else if (IS_IPHONE_5){
            self.imageTwo.image = [UIImage imageNamed:@"hot_circle_all_6p"];
        }else if (IS_IPHONE_6){
            self.imageTwo.image = [UIImage imageNamed:@"hot_circle_all_6"];
        }else if (IS_IPHONE_6P){
            self.imageTwo.image = [UIImage imageNamed:@"hot_circle_all_6p"];
        }
        
        self.imageTwo.hidden = YES;
        [self addSubview:self.imageTwo];
        
        self.imageTwo.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTwoAction:)];
        [self.imageTwo addGestureRecognizer:tap2];
        
    }
    return self;
}

- (void)tapOneAction:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.2 animations:^{
        self.imageOne.hidden = YES;
        self.imageTwo.hidden = NO;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)tapTwoAction:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:[NSNumber numberWithBool:YES] forKey:@"showHotCirclePostCover"];
    }];
}

@end

void ShowHotCirclePostCover()
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([[userDefault objectForKey:@"showHotCirclePostCover"] boolValue]){
        return;
    }
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    HotCirclePostCover* cover = [[HotCirclePostCover alloc] init];
    [[UIApplication sharedApplication].keyWindow addSubview:cover];
}


