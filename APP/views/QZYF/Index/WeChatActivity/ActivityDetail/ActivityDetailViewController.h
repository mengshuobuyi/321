//
//  ActivityDetailViewController.h
//  wenYao-store
//
//  Created by qw_imac on 16/3/8.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseVC.h"
@interface SetHeadModel:NSObject
@property (nonatomic,strong) NSString *actId;
@property (nonatomic,strong) NSString *actType;//类型1.优惠活动 2.抢购 3.套餐 4.换购,
@property (nonatomic,strong) NSString *title ;//标题,
@property (nonatomic,strong) NSString *desc;//描述,
@property (nonatomic,strong) NSString *source;//来源,
@property (nonatomic,strong) NSString *date;//时间,
@property (nonatomic,strong) NSString *status ;//状态,
@property (nonatomic,strong) NSString *activityType;// 活动类型:1:买赠, 2:折扣, 3:立减, 4:特价,
@property (nonatomic,strong) NSString *promotionStock ;//优惠库存,
@property (nonatomic,strong) NSString *useQuantity;//使用量,
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSArray *proList;
@end
@interface ActivityDetailViewController : QWBaseVC
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,strong) NSString *activityId;
@end
