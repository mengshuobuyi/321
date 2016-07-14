//
//  MADateTextField.m
//  tcmerchant
//
//  Created by Martin.Liu on 15/7/7.
//  Copyright (c) 2015年 TC. All rights reserved.
//

#import "MADateTextField.h"
#import "NSDate+TKCategory.h"
#ifndef kiPhone6Plus
#define kiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#endif
@implementation MADateTextField
{
    UIDatePicker* datePicker;
}
@synthesize dateFormatter;

- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup
{
    float toolBarHeight = 30;
    if (kiPhone6Plus) {
        toolBarHeight = 45;
    }
    
    self.tintColor = [UIColor clearColor]; // 出去光标
    
    UIToolbar* toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, APP_W, toolBarHeight)];
    toolBar.translucent = NO;
    toolBar.tintColor = [UIColor whiteColor];
    toolBar.barTintColor = RGBHex(qwColor1);
    UIBarButtonItem* cancelBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(resignTextField:)];
    UIBarButtonItem* spaceBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    //    UIBarButtonItem* spaceBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //    spaceBtn.width = 50;
    UIBarButtonItem* resignBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(doneChoose:)];
    [toolBar setItems:@[cancelBarBtn,spaceBtn,resignBtn]];
    
    NSDictionary *btnTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:AutoValue(12.f)], NSFontAttributeName, nil];
    [cancelBarBtn setTitleTextAttributes:btnTitleTextAttributes forState:UIControlStateNormal];
    [resignBtn setTitleTextAttributes:btnTitleTextAttributes forState:UIControlStateNormal];
    
    self.inputAccessoryView = toolBar;
 
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, APP_W, 216)];
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    //    datePicker.date = [NSDate new];
//    datePicker.minimumDate = [NSDate new];
//    datePicker.maximumDate = [NSDate new];
    
    self.inputView = datePicker;
    
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
}

- (void)setDate:(NSDate *)date
{
    [self setDate:date postNotiWhenChange:NO];
}

- (void)setDate:(NSDate *)date postNotiWhenChange:(BOOL)isPost
{
    _date = date;
    self.text = [dateFormatter stringFromDate:date];
    if (isPost && ![_date isSameDay:date]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:nil];
    }
}

- (void)setMinimumDate:(NSDate *)minimumDate
{
    _minimumDate = minimumDate;
    datePicker.minimumDate = _minimumDate;

}

- (void)setMaximumDate:(NSDate *)maximumDate
{
    _maximumDate = maximumDate;
    datePicker.maximumDate = _maximumDate;
}

- (void)setDateFormat:(NSString *)dateFormat
{
    _dateFormat = dateFormat;
    dateFormatter.dateFormat = dateFormat;
}

- (void)resignTextField:(id)sender
{
    [self resignFirstResponder];
}

- (void)doneChoose:(id)sender
{
    [self setDate:datePicker.date postNotiWhenChange:YES];
    [self resignFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    NSDate* date = [dateFormatter dateFromString:self.text];
    datePicker.date = date ? date : [NSDate new];
    return [super becomeFirstResponder];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
