//
//  OrderHistoryDetailViewController.m
//  wenYao-store
//
//  Created by YYX on 15/10/29.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "OrderHistoryDetailViewController.h"
#import "Order.h"
#import "OrderModel.h"

@interface OrderHistoryDetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *viewOne;

@property (weak, nonatomic) IBOutlet UIView *viewTwo;

@property (weak, nonatomic) IBOutlet UILabel *groupName;  // 优惠商家

@property (weak, nonatomic) IBOutlet UILabel *orderType;  // 优惠类型

@property (weak, nonatomic) IBOutlet UILabel *condition;  // 优惠细则

@property (weak, nonatomic) IBOutlet UILabel *userName;   // 购买用户

@property (weak, nonatomic) IBOutlet UILabel *orderTime;  // 订单时间

@end

@implementation OrderHistoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单详情";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWaring12 image:@"img_network"];
        return;
    }else{
        [self queryDetailInfo];
    }
}

#pragma mark ---- 获取订单详情信息 ----

- (void)queryDetailInfo
{
    [self removeInfoView];
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
    setting[@"orderId"] = StrFromObj(self.orderId);
    
    [Order orderGetOrderDetailWithParams:setting success:^(id obj) {
        
        HistoryOrderDetail *detailModel = (HistoryOrderDetail *)obj;
        
        if ([detailModel.apiStatus integerValue] == 0) {
            
             //赋值
            self.groupName.text = detailModel.groupName;
            if ([detailModel.type isEqualToString:@"Q"]) {
                self.orderType.text = @"优惠券";
            }else if ([detailModel.type isEqualToString:@"P"]){
                self.orderType.text = @"优惠商品";
            }
            self.condition.text = detailModel.condition;
            self.userName.text = detailModel.customerName;
            self.orderTime.text = detailModel.orderTime;
            
        }else{
            [SVProgressHUD showErrorWithStatus:detailModel.apiMessage];
        }
        
    } failure:^(HttpException *e) {
        if(e.errorCode!=-999){
            if(e.errorCode == -1001){
                [self showInfoView:kWarning215N54 image:@"image_no_content"];
            }else{
                [self showInfoView:kWarning215N0 image:@"image_no_content"];
            }
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
