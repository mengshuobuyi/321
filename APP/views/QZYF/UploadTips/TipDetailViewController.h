//
//  TipDetailViewController.h
//  wenYao-store
//
//  Created by caojing on 15/8/20.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseVC.h"
#import "AllTipsViewController.h"

@protocol changeDelegate <NSObject>

-(void)changeToCurrent:(NSString *)typeCell;

@end

@interface TipDetailViewController : QWBaseVC<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign)id<changeDelegate> changedele;
@property (weak, nonatomic) IBOutlet UITableView *tableRoot;

@property (nonatomic) NSNumber *type;  // 1 是优惠商品 2 优惠券
@property (nonatomic) NSString *orderId;

@property (strong, nonatomic) NSString *typeCell;
@property (strong, nonatomic) NSString *scope;  // 订单 id
@end
