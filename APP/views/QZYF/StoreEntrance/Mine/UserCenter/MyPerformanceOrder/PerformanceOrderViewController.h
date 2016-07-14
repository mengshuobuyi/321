//
//  PerformanceOrderViewController.h
//  wenYao-store
//
//  Created by qw_imac on 16/5/6.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseVC.h"

@interface PerformanceOrderViewController : QWBaseVC
@property (nonatomic,strong) UINavigationController *navi;
@property (nonatomic,assign) NSInteger              type;//1:线上分享转化，2:线下分享转化
@end
