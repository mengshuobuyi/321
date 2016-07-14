//
//  DateView.m
//  wenyao-store
//
//  Created by Meng on 15/4/2.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import "DateView.h"
#import "Constant.h"
@implementation DateView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 216)];
        [self.datePicker setBackgroundColor:[UIColor whiteColor]];
        [self.datePicker addTarget:self action:@selector(datePickerValueChange:) forControlEvents:UIControlEventValueChanged];
        self.datePicker.datePickerMode = UIDatePickerModeTime;
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"NL"];
        [self.datePicker setLocale:locale];
        [self datePickerValueChange:self.datePicker];
        
        [self addSubview:self.datePicker];
        
        
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [sureButton setFrame:CGRectMake(10, 216 + 5, APP_W-20, 40)];
        [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sureButton setBackgroundImage:[UIImage imageNamed:@"登录按钮_背景"] forState:UIControlStateNormal];
        [sureButton addTarget:self action:@selector(sureButtonClcik) forControlEvents:UIControlEventTouchUpInside];
        [sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [self addSubview:sureButton];
        
        
    }
    return self;
}

- (void)cancleButtonClick
{
    if ([self.delegate respondsToSelector:@selector(timeCancelButtonClick)]) {
        [self.delegate timeCancelButtonClick];
    }
}

- (void)sureButtonClcik
{
    if ([self.delegate respondsToSelector:@selector(timeSureButtonClick:)]) {
        [self.delegate timeSureButtonClick:timeStr];
    }
}

- (void)datePickerValueChange:(UIDatePicker *)picker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *datePickerStr = [dateFormatter stringFromDate:picker.date];
    timeStr = datePickerStr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
