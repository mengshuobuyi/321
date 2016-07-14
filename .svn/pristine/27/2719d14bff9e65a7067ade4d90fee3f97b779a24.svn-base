//
//  MyDatePicker.h
//  wenYao-store
//
//  Created by YYX on 15/8/25.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyDatePickerDelegate <NSObject>

- (void)makeSureDateActionWithDate:(NSDate *)date indexPath:(NSIndexPath *)indexPath;

@end

@interface MyDatePicker : UIView

@property (assign, nonatomic) id <MyDatePickerDelegate> delegate;

@property (strong, nonatomic) UIDatePicker *datePicker;

@property (strong, nonatomic) UIButton *sureButton;

@property (strong, nonatomic) UIView *pickerBg;

@property (strong, nonatomic) UIView *alphaBg;

@property (strong, nonatomic) NSIndexPath *indexPath;

- (id)initWithDate:(NSDate *)date IndexPath:(NSIndexPath *)indexPath;

-(void)show;

@end
