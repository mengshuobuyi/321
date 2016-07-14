//
//  QWTabBar.h
//  APP
//
//  Created by Yan Qingyang on 15/2/28.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QWBaseTabBar.h"
/** 商户版
 tab标签
 1、主页
 2、会员
 3、我的
 */
/** 专家版
 tab标签
 1、圈子
 2、咨询
 3、我的
 */
enum  Enum_TabBar_Items {
    Enum_TabBar_Items_HomePage   = 0,
    Enum_TabBar_Items_MyOrders = 1,
    Enum_TabBar_Items_Product = 2,
    Enum_TabBar_Items_Statistics = 3,
    Enum_TabBar_Items_UserCenter = 4,
    
    Enum_TabBar_Items_ExpertIndex = 5,
    Enum_TabBar_Items_ExpertChat = 6,
    Enum_TabBar_Items_ExpertMine = 7,
};

@interface QWTabBar : QWBaseTabBar

/**
 *  初始化
 *
 *  @param dlg 托管delegate
 *
 *  @return 返回self
 */
- (id)initWithDelegate:(id)dlg;


@end
