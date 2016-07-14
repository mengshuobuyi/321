//
//  CustomDatePicker.m
//  wenYao-store
//
//  Created by chenpeng on 15/5/18.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "CustomDatePicker.h"
#import "AppDelegate.h"

@implementation CustomDatePicker

{
    UIWindow *window;
}


- (id)initWithButtonType:(int)buttontype
{
    CGRect frame = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.alphaBg = [[UIView alloc] initWithFrame:self.frame];
        self.alphaBg.backgroundColor = [UIColor blackColor];
        self.alphaBg.alpha = 0.4;
        [self addSubview:self.alphaBg];
        
        self.pickerBg = [[UIView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-245, APP_W, 245)];
        self.pickerBg.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.pickerBg];
        
        self.datePicker = [[UIDatePicker alloc] init];
        self.datePicker.frame = CGRectMake(0, 0, APP_W, 162);
        NSDate *currentTime  = [self setYesterday];
        [self.datePicker setDate:currentTime animated:YES];
        [self.datePicker setMaximumDate:currentTime];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *minDate = [formatter dateFromString:@"2015-01-01"];
        [self.datePicker setMinimumDate:minDate];

        [self.datePicker setDatePickerMode:UIDatePickerModeDate];
        [self.pickerBg addSubview:self.datePicker];
        
        self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sureButton.frame = CGRectMake((APP_W-300)/2, 194, 300, 36);
        [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
        self.sureButton.backgroundColor=RGBHex(qwColor2);
        self.sureButton.titleLabel.font=fontSystem(kFontS2);
        self.sureButton.layer.cornerRadius=4;
        [self.sureButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.pickerBg addSubview:self.sureButton];
        
        self.buttontype = buttontype;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)buttonClick:(id)sender
{
    NSDate *selected = [self.datePicker date];
    if (self.delegate && [self.delegate respondsToSelector:@selector(makeSureDateActionWithDate:type:)]) {
        [self.delegate makeSureDateActionWithDate:selected type:self.buttontype];
    }
    [self hidden];
}

- (NSDate *)setYesterday
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate date];
    NSDate *yesterday =[NSDate dateWithTimeInterval:-60*60*24 sinceDate:date];
    return yesterday;
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [self hidden];
}

-(void)show
{
    self.pickerBg.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, self.frame.size.width, self.pickerBg.frame.size.height);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    __weak CustomDatePicker *weakSelf = self;
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
        weakSelf.alphaBg.alpha = 0.4;
        weakSelf.pickerBg.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - self.pickerBg.frame.size.height, self.frame.size.width, self.pickerBg.frame.size.height);
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hidden
{
    __weak CustomDatePicker *weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.alphaBg.alpha = 0;
        weakSelf.pickerBg.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.pickerBg.frame.size.height);
    } completion:^(BOOL finished) {
        
        [weakSelf removeFromSuperview];
    }];

}

@end
