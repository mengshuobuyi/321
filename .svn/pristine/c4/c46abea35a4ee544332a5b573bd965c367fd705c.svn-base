//
//  EmployeeModel.h
//  wenYao-store
//
//  Created by Meng on 15/4/7.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseAPIModel.h"

@interface EmployeeModel : BaseAPIModel

@end

@interface EmployeeQueryListModel : EmployeeModel

@property (nonatomic ,strong) NSArray *list;

@end

@interface EmployeeQueryModel : EmployeeModel

@property (nonatomic ,strong) NSString *employeeId;
@property (nonatomic ,strong) NSString *employeeMobile;
@property (nonatomic ,strong) NSString *employeeName;
@property (nonatomic ,strong) NSString *groupId;
@property (nonatomic ,strong) NSString *employeeValid;

@end

@interface EmployeeInfoModel : BaseAPIModel

@property (nonatomic ,strong) NSString      *id;            //店员 id
@property (nonatomic ,strong) NSString      *groupId;       //门店 id
@property (nonatomic ,strong) NSString      *name;          //店员名称
@property (nonatomic ,strong) NSString      *mobile;        //手机号
@property (nonatomic ,strong) NSString      *valid;         //账号是否有效
@property (nonatomic ,strong) NSString      *delete;        //Y 删除 N 未删除
@property (nonatomic ,strong) NSString      *alipay;        //支付宝账号
@property (nonatomic ,strong) NSString      *bankCard;      //银行账号
@property (nonatomic ,strong) NSString      *bankName;      //开户行
@property (nonatomic ,strong) NSString      *ic;            //身份证号
@property (nonatomic ,strong) NSString      *icImgF;        //身份证正面
@property (nonatomic ,strong) NSString      *icImgB;        //身份证背面
@property (nonatomic ,strong) NSString      *qq;            //QQ,
@property (nonatomic ,strong) NSString      *wx;            //微信,
@property (nonatomic ,strong) NSString      *headImg;       //头像

// 3.2.0 add by Martin  /h5/mbr/branch/queryEmployees
//@property (nonatomic ,strong) NSString      *id;            //店员 id
//@property (nonatomic ,strong) NSString      *name;          //店员名称
//@property (nonatomic ,strong) NSString      *mobile;        //手机号
//@property (nonatomic ,strong) NSString      *alipay;        //支付宝账号
//@property (nonatomic ,strong) NSString      *bankCard;      //银行账号
//@property (nonatomic ,strong) NSString      *bankName;      //开户行
//@property (nonatomic ,strong) NSString      *ic;            //身份证号
//@property (nonatomic ,strong) NSString      *icImgF;        //身份证正面
//@property (nonatomic ,strong) NSString      *icImgB;        //身份证背面
//@property (nonatomic ,strong) NSString      *qq;            //QQ,
//@property (nonatomic ,strong) NSString      *wx;            //微信,
//@property (nonatomic ,strong) NSString      *headImg;       //头像
@property (nonatomic, strong) NSString      *branchId;      //门店ID
@property (nonatomic, assign) NSInteger     lvl;            //员工等级
@property (nonatomic, assign) NSInteger     score;          //员工积分
@property (nonatomic, assign) NSInteger     totalScore;     //历史总积分
@property (nonatomic, assign) NSInteger     type;           //店员类型（1：店长2：店员）
@property (nonatomic, assign) BOOL          sign;           //今日是否签到
@property (nonatomic, assign) NSInteger     signDays;       //连续签到天数

@end

@interface EmpLvlInfoVo : BaseAPIModel
@property (nonatomic ,strong) NSString      *lvl;//当前等级,
@property (nonatomic ,strong) NSString      *name;//昵称
@property (nonatomic ,strong) NSString      *headImg;//头像,
@property (nonatomic ,strong) NSString      *growth;// 距离下一级成长值差值,
@property (nonatomic ,strong) NSString      *trade;//距离下一级完成订单数差值,
@property (nonatomic ,assign) BOOL          upgrade;//是否提醒用户升级,

@end
