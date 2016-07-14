//
//  LoginViewController.h
//  APP
//
//  Created by qwfy0006 on 15/3/17.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseVC.h"

typedef enum  Enum_Login_Items {
    Enum_Login_Items_WaitingAudit             = 1,             //账户审核中
    Enum_Login_Items_NoAudit                  = 2,             //账户审核不通过
    Enum_Login_Items_Freeze                   = 5,             //账号已冻结，无法使用
    Enum_Login_Items_QuickRegister            = 6,             //快捷注册未完成
    Enum_Login_Items_AccountOrPsdError        = 7,             //账号或密码错误，请重新输入
    Enum_Login_Items_AddNew                   = 9,             //新增
    Enum_Login_Items_AccountNotOpen           = 10,            //店员账号未开启
    Enum_Login_Items_StoreStatuError          = 11,            //药店签约状态异常
}Login_Items;

typedef enum  Enum_OrganAuth_Statu_Items {
    Enum_OrganAuth_Statu_Items_Waiting         = 1,             //待审核  资料已提交页面
    Enum_OrganAuth_Statu_Items_NOPass          = 2,             //审核不通过  带入老数据的认证流程
    Enum_OrganAuth_Statu_Items_Pass            = 3,             //审核通过    功能正常
    Enum_OrganAuth_Statu_Items_NoCommit        = 4,             //未提交审核  认证流程
}OrganAuth_Statu_Items;


@protocol FinishLogindelegate <NSObject>

-(void)FinishLoginAction;

@end

@interface LoginViewController : QWBaseVC

@property (nonatomic, weak)   id<FinishLogindelegate> FinishLogindelegate;

@end
