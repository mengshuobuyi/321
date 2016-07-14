//
//  MARDateTextField.m
//  wenYao-store
//
//  Created by Martin.Liu on 16/5/13.
//  Copyright © 2016年 carret. All rights reserved.
//
#import "MARDateTextField.h"
#import "NSDate+TKCategory.h"

@implementation MARDateTextField
{
    UIDatePicker* datePicker;
    BOOL hasSetup;
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
    self.hasMenu = NO;
    if (hasSetup) {
        return;
    }
    hasSetup = YES;
    float toolBarHeight = 30;
    if (IS_IPHONE_6P) {
        toolBarHeight = 45;
    }
    
    self.tintColor = [UIColor clearColor]; // 出去光标
    
//    UIToolbar* toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, APP_W, toolBarHeight)];
//    toolBar.translucent = NO;
//    toolBar.tintColor = [UIColor whiteColor];
//    toolBar.barTintColor = RGBHex(qwColor1);
//    UIBarButtonItem* cancelBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(resignTextField:)];
//    UIBarButtonItem* spaceBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//        UIBarButtonItem* spaceBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        spaceBtn.width = 50;
//    UIBarButtonItem* resignBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(doneChoose:)];
//    [toolBar setItems:@[cancelBarBtn,spaceBtn,resignBtn]];
//    
//    NSDictionary *btnTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:AutoValue(12.f)], NSFontAttributeName, nil];
//    [cancelBarBtn setTitleTextAttributes:btnTitleTextAttributes forState:UIControlStateNormal];
//    [resignBtn setTitleTextAttributes:btnTitleTextAttributes forState:UIControlStateNormal];
//    self.inputAccessoryView = toolBar;
    
    CGFloat datePickheight = 162;
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, APP_W, datePickheight)];
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.datePickerMode = UIDatePickerModeDate;
//    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
//    self.inputView = datePicker;
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, datePickheight + 60)];
    view.backgroundColor = [UIColor whiteColor];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = RGBHex(qwColor2);
    btn.frame = CGRectMake(30, datePickheight, APP_W - 60, 40);
    [view addSubview:datePicker];
    [view addSubview:btn];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 4;
    [btn addTarget:self action:@selector(doneChoose:) forControlEvents:UIControlEventTouchUpInside];
    self.inputView = view;
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

@end
