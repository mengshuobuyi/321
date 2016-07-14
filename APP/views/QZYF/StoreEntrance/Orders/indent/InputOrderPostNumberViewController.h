//
//  InputOrderPostNumberViewController.h
//  wenYao-store
//
//  Created by qw_imac on 16/3/10.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseVC.h"
#import "OrderListModel.h"
@interface InputOrderPostNumberViewController : QWBaseVC
@property (nonatomic,strong) ExpressCompanyVO *company;
@property (nonatomic,strong) NSString *orderId;
@property (nonatomic,copy) void(^refresh)(BOOL);
@end
