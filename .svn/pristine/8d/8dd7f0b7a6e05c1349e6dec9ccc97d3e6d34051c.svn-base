//
//  SoftwareDetailViewController.h
//  wenYao-store
//
//  Created by YYX on 15/7/6.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseVC.h"
#import "EmployeeModel.h"

typedef enum  Enum_SoftwareUser_Type {
    
    Enum_SoftwareUser_Type_PayAccount         = 0,          //支付宝账号
    Enum_SoftwareUser_Type_BankAccount        = 1,          //银行账号
    Enum_SoftwareUser_Type_OpenBank           = 2,          //开户行
    Enum_SoftwareUser_Type_IDCard             = 3,          //身份证号
    
}SoftwareUser_Type;

@interface SoftwareDetailViewController : QWBaseVC

// 编辑类型
@property (assign, nonatomic) int type;

// 上个界面 传入的值  已加星号处理的值
@property (strong, nonatomic) NSString *content;

// 上个界面 传入的真实的值
@property (strong, nonatomic) NSString *trueStr;

// 上个界面 传入的真实的值(判断账号的新值与原有值是否一致)
@property (strong, nonatomic) NSString *trueString;

@property (strong, nonatomic) EmployeeInfoModel *infoModel;

@end
