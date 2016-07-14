//
//  MyReceiveAddressViewController.h
//  wenYao-store
//
//  Created by qw_imac on 16/5/9.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseVC.h"
typedef void(^SelectAddress)(NSString *addressStr); //选择地址将地址返回H5
//typedef void(^H5Refresh)();                         //未选择地址通知H5刷新
typedef NS_ENUM(NSInteger,PageComeFrom){
    PageComeFromMine = 0,       //我的等级进入
    PageComeFromH5,         //H5调原生收货地址
};
@interface MyReceiveAddressViewController : QWBaseVC
@property (nonatomic,assign) PageComeFrom pageFrom;
@property (nonatomic,copy)SelectAddress addressBlock;
@end
