//
//  AliPayCheckPhoneViewController.h
//  wenYao-store
//
//  Created by YYX on 15/7/7.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseVC.h"

@interface AliPayCheckPhoneViewController : QWBaseVC

// 上个界面 传入的值  已加星号处理的值
@property (strong, nonatomic) NSString *content;

// 上个界面 传入的真实的值
@property (strong, nonatomic) NSString *trueStr;

// 上个界面 传入的真实的值(判断账号的新值与原有值是否一致)
@property (strong, nonatomic) NSString *trueString;

@property (strong, nonatomic) NSString *phoneNumber;

@end
