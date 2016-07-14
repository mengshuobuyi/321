//
//  secondCustomAlertView.m
//  wenyao
//
//  Created by 李坚 on 14/12/22.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "secondCustomAlertView.h"
#import "Constant.h"

@implementation secondCustomAlertView

- (void)awakeFromNib{
    
    
    self.textFieldName.layer.masksToBounds = YES;
    self.textFieldName.layer.borderWidth = 0.5;
    self.textFieldName.layer.borderColor = RGBHex(qwColor10).CGColor;
    self.textFieldName.layer.cornerRadius = 3.0f;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
    self.textFieldName.leftView = paddingView;
    self.textFieldName.leftViewMode = UITextFieldViewModeAlways;
    
    self.specField.layer.masksToBounds = YES;
    self.specField.layer.borderWidth = 0.5;
    self.specField.layer.borderColor = RGBHex(qwColor10).CGColor;
    self.specField.layer.cornerRadius = 3.0f;
    UIView *paddingViewa = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
    self.specField.leftView = paddingViewa;
    self.specField.leftViewMode = UITextFieldViewModeAlways;
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 120);
    }
    else{
        self.backgroundColor=[UIColor whiteColor];
        self.textFieldName.backgroundColor=[UIColor whiteColor];
        self.textFieldName.frame = CGRectMake(self.textFieldName.frame.origin.x, 28, self.textFieldName.frame.size.width, 36);
        self.specField.backgroundColor=[UIColor whiteColor];
        self.specField.frame = CGRectMake(self.specField.frame.origin.x,83, self.specField.frame.size.width, 36);
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 120);
    }
}


@end
