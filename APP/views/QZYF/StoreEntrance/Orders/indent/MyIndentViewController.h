//
//  MyIndentViewController.h
//  APP
//
//  Created by qw_imac on 15/12/29.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "QWBaseVC.h"
typedef NS_ENUM(NSInteger,OrdersIndex){
    OrdersIndexUnJump = - 1,//不跳
    OrdersIndexAll = 0,     //全部
    OrdersIndexPending,     //待接单
    OrdersIndexOnChange,    //待配送
    OrdersIndexOnPost,      //配送中
    OrdersIndexUnget,       //待取货
};
@interface MyIndentViewController : QWBaseVC
@property (nonatomic,assign) OrdersIndex index;//跳转状态索引

- (void)jumpToIndexPage:(OrdersIndex)index;

@end
