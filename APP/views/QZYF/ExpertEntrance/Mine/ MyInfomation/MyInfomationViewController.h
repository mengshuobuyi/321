//
//  MyInfomationViewController.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/6.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseVC.h"

@interface MyInfomationViewController : QWBaseVC

@property (strong, nonatomic) NSString *expertType;//1 药师 2 营养师

@property (strong, nonatomic) NSString *headerUrl; //头像

@property (strong, nonatomic) NSString *nickName;  //姓名

@property (strong, nonatomic) NSString *goodField; //擅长领域

@property (strong, nonatomic) NSString *groupName; //品牌

@property (strong, nonatomic) NSString *groupStatu;//品牌状态

@property (strong, nonatomic) NSString *registerUrl;//注册证／挂靠证明

@end
