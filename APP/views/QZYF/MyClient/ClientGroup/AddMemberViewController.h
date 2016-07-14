//
//  AddMemberViewController.h
//  wenYao-store
//
//  Created by YYX on 15/6/2.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseVC.h"

typedef enum  Enum_DataType_Items {
    
    Enum_DataType_ByAll_Items             = 1,             //全部的客户列表
    Enum_DataType_BySearch_Items          = 2,             //搜索的客户列表
    
}DataType_Items;

@interface AddMemberViewController : QWBaseVC

// 客户所在分组的 id
@property (strong, nonatomic) NSString *customerGroupId;

// 分组内的已有客户
@property (strong, nonatomic) NSArray *tempArray;

@end
