//
//  IndentDetailViewController.h
//  APP
//
//  Created by qw_imac on 15/12/29.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "QWBaseVC.h"
#import "IndentOders.h"

@interface IndentDetailListViewController : QWBaseVC
@property (nonatomic,strong) NSString *orderId;

@property (nonatomic,strong)ShopOrderDetailVO *modelShop;//首页传来的model
@property (nonatomic,assign)BOOL isComeFromScan;//从扫码页面进来的字段
@property (nonatomic,copy) void(^refreshBlock)();//qcSlide刷新有问题，用block刷
@end
