//
//  EditDetailViewController.h
//  wenYao-store
//
//  Created by Young on 15/5/2.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseVC.h"
#import "EmployeeModel.h"

typedef enum  Enum_Edit_Type {
    
    Enum_Edit_Type_Name               = 0,          //姓名
    Enum_Edit_Type_QQ                 = 1,          //QQ
    Enum_Edit_Type_WeChat             = 2,          //微信
    Enum_Edit_Type_PayAccount         = 3,          //支付宝账号
    Enum_Edit_Type_BankAccount        = 4,          //银行账号
    Enum_Edit_Type_OpenBank           = 5,          //开户行
    Enum_Edit_Type_IDCard             = 6,          //身份证号
  
}Edit_Type;

@interface EditDetailViewController : QWBaseVC

@property (assign, nonatomic) int type;  //编辑类型

@property (strong, nonatomic) NSString *content;

//上个界面传入的真实的值，新编辑的text赋值给trueStr
@property (strong, nonatomic) NSString *trueStr;

// 上个界面 传入的真实的值(判断账号的新值与原有值是否一致)
@property (strong, nonatomic) NSString *trueString;

@end
