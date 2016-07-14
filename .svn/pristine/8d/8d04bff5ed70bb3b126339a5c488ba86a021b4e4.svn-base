//
//  MADateView.m
//  MADateViewDemo
//
//  Created by Meng on 15/4/14.
//  Copyright (c) 2015年 Meng. All rights reserved.
//

#import "MADateView.h"

#define kDuration   0.3

@interface MADateView ()

{
    UIButton *_bgButton;
    
    UIDatePicker *_datePicker;
    
    NSString *timeStr;
    
    UIView *bgView;
    UILabel *timeLabel;
}
+ (instancetype)shared;

@property (nonatomic, copy) CallBack callBack ;//按钮点击事件的回调

@property (nonatomic ,assign) DateViewStyle dateViewStyle;

@end


@implementation MADateView


+ (instancetype)shared
{
    static dispatch_once_t once = 0;
    static MADateView *dateView;
    dispatch_once(&once, ^{
        dateView = [[MADateView alloc] init];
    });
    return dateView;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 1;
        self.hidden = NO;//不隐藏
        self.windowLevel = 100;
        
        self.frame = (CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size};
        
        _bgButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_bgButton setFrame:(CGRect){{0,0},[[UIScreen mainScreen] bounds].size}];
        [_bgButton setBackgroundColor:[UIColor blackColor]];
        _bgButton.alpha = 0.5;
        [_bgButton addTarget:self action:@selector(cancleButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bgButton];
    }
    
    return self;
}

+ (instancetype)showDateViewWithDate:(NSDate *)date Style:(DateViewStyle)dateViewStyle CallBack:(CallBack)callBack
{
    [[self shared] setCallBack:nil];//释放掉之前的block
    [[self shared] setCallBack:callBack];
    //定制dateView显示样式
    [[self shared] initDateViewWithDate:(NSDate *)date Style:dateViewStyle];
    //出现
    [[self shared] setBgViewFrame];
    [[self shared] setAlpha:1];
    return [self shared];
}



- (void)initDateViewWithDate:(NSDate *)date Style:(DateViewStyle)dateViewStyle
{
    _dateViewStyle = dateViewStyle;
    bgView = [[UIView alloc] init];
    [bgView setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 246)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    _datePicker = [[UIDatePicker alloc] init];
    if (date) {
        [_datePicker setDate:date animated:YES];
    }else{
        [_datePicker setDate:[NSDate date] animated:YES];
    }
    [_datePicker setBackgroundColor:[UIColor clearColor]];
    [_datePicker addTarget:self action:@selector(datePickerValueChange:) forControlEvents:UIControlEventValueChanged];
    switch (dateViewStyle) {
        case DateViewStyleTime:
                [self timeStyleInitWithDate:date];
            break;
            case DateViewStyleDate:
                [self dateStyleInitWithDate:date];
            break;
        default:
            break;
    }
    
    [bgView addSubview:_datePicker];
    [self addSubview:bgView];
}

//定义时间timeStyle界面
- (void)timeStyleInitWithDate:(NSDate *)date
{
    float bgWidth = bgView.frame.size.width;
    [_datePicker setFrame:CGRectMake(0, 0, bgWidth, 196)];
    _datePicker.datePickerMode = UIDatePickerModeTime;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"NL"];
    [_datePicker setLocale:locale];
    [self datePickerValueChange:_datePicker];
    
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setFrame:CGRectMake(10, 196 + 5, bgWidth-20, 40)];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureButton setBackgroundImage:[UIImage imageNamed:@"登录按钮_背景"] forState:UIControlStateNormal];
    [sureButton setBackgroundImage:[UIImage imageNamed:@"登录按钮_背景_选中"] forState:UIControlStateHighlighted];
    [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [bgView addSubview:sureButton];
}

//定义日期dateStyle界面
- (void)dateStyleInitWithDate:(NSDate *)date
{
    float bgWidth = bgView.frame.size.width;
    [_datePicker setFrame:CGRectMake(0, 30, bgWidth, 196)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"zh_Hans"];
    [_datePicker setLocale:locale];
    UIFont *labelFont = [UIFont systemFontOfSize:14.0f];
    
    UILabel *leftlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 110, 22)];
    leftlabel.text = @"您选择的日期是:";
    leftlabel.font = labelFont;
    [bgView addSubview:leftlabel];
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake((bgWidth-110)/2, 3, 110, 22)];
    timeLabel.font = labelFont;
    [self datePickerValueChange:_datePicker];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:timeLabel];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setFrame:CGRectMake(bgWidth-80, 0, 60, 29)];
    [sureButton setTitle:@"确定选择" forState:UIControlStateNormal];
    sureButton.titleLabel.font = labelFont;
    [sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:sureButton];
}

- (void)setBgViewFrame
{
    [_bgButton setHidden:NO];
    [UIView animateWithDuration:kDuration animations:^{
        [bgView setFrame:CGRectMake(0, self.frame.size.height - 246, self.frame.size.width, 246)];
    }];
}

- (void)dismissViewWithAnimated:(BOOL)animated
{
    [_bgButton setHidden:YES];
    if (animated) {
        [UIView animateWithDuration:kDuration animations:^{
            [bgView setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 246)];
        }];
        [UIView animateWithDuration:kDuration animations:^{
            [self setAlpha:0];
        }];
    }else{
        [self setAlpha:0];
        [bgView setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 246)];
    }
}
//确定选择
- (void)sureButtonClick
{
    [self setAlpha:0];
    [self dismissViewWithAnimated:YES];
    if (self.callBack) {
        self.callBack(MyWindowClickForOK,timeStr);
    }
}
//取消选择
- (void)cancleButtonClick
{
    [self setAlpha:0];
    [self dismissViewWithAnimated:YES];
    if (self.callBack) {
        self.callBack(MyWindowClickForCancel , @"");
    }
}

//滚动日期控件,调用ValueChange方法
- (void)datePickerValueChange:(UIDatePicker *)picker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    switch (_dateViewStyle) {
        case DateViewStyleTime:
        {
            [dateFormatter setDateFormat:@"HH:mm"];
            timeStr = [self analyzingDateWith:picker.date dateFormatter:dateFormatter];
        }
            break;
        case DateViewStyleDate:
        {
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            timeStr = [self analyzingDateWith:picker.date dateFormatter:dateFormatter];
            timeLabel.text = timeStr;
        }
            break;
        default:
            break;
    }
    
}

- (NSString *)analyzingDateWith:(NSDate *)date dateFormatter:(NSDateFormatter *)dateFormatter
{
    NSString *datePickerStr = [dateFormatter stringFromDate:date];
    NSMutableString *mutStr = [[NSMutableString alloc] initWithString:datePickerStr];
    NSString *dateStr = [mutStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    return dateStr;
}

@end
