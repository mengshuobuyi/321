//
//  AllTipsViewController.h
//  wenYao-store
//
//  Created by caojing on 15/8/22.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseVC.h"

@interface TipProdctViewController : QWBaseVC

@property (weak, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (nonatomic) NSNumber *totalPricePro;    // 总价
@property(nonatomic,strong)NSArray *productList;  // 商品列表

@end
