//
//  CustomInfoAlertView.h
//  APP
//
//  Created by PerryChen on 9/16/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import "QWBaseAlert.h"
#import "NotificationModel.h"
typedef void (^DirectBlock)(BOOL success);
typedef void (^CancelBlock)(BOOL success);
@class CustomInfoAlertView;

@protocol CustomInfoAlertDelegate <NSObject>

- (void)actionDirectWithAlert:(CustomInfoAlertView *)alert;
- (void)actionCancelWithAlert:(CustomInfoAlertView *)alert;

@end

@interface CustomInfoAlertView : QWBaseAlert
@property (weak, nonatomic) IBOutlet UILabel *alertTitle;
@property (nonatomic, strong) NotificationModel *model;
@property (nonatomic, weak) id<CustomInfoAlertDelegate> alertDelegate;
@property (nonatomic, strong) DirectBlock blockDirect;
@property (nonatomic, strong) CancelBlock blockCancel;
+ (id)instance;
@end
