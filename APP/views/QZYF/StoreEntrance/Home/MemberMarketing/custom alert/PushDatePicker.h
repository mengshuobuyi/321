//
//  CustomDatePicker.h
//  wenYao-store
//
//  Created by chenpeng on 15/5/18.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PushDatePickerDelegate <NSObject>

- (void)makeSureDateActionWithDate:(NSDate *)date type:(int)buttontype;

@end

@interface PushDatePicker : UIView

@property (assign, nonatomic) id <PushDatePickerDelegate> delegate;
@property (assign, nonatomic) int buttontype;

@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIButton *sureButton;
@property (strong, nonatomic) UIView *pickerBg;
@property (strong, nonatomic) UIView *alphaBg;


//@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
//@property (weak, nonatomic) IBOutlet UIButton *sureButton;
//@property (weak, nonatomic) IBOutlet UIView *bg;
//@property (weak, nonatomic) IBOutlet UIView *alphaBgView;

//- (IBAction)buttonAction:(id)sender;
- (id)initWithButtonType:(int)buttontype;
- (void)setCurDate:(NSDate *)curDate;
-(void)show;

@end
