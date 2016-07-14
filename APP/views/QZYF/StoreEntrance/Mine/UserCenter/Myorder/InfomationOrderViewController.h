//
//  InfomationOrderViewController.h
//  wenyao-store
//
//  Created by chenpeng on 15/1/20.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QWBaseVC.h"
#import "OrderModel.h"
@interface InfomationOrderViewController : QWBaseVC

@property (strong,nonatomic)OrderclassBranch *orderBranchclass;
@property (strong,nonatomic)NSDictionary *infodic;
//1代表Manager  2代表扫码进入优惠详情  3代表主页扫码
@property (assign,nonatomic) NSUInteger modeType;
//优惠描述


//小票的提示
@property (weak, nonatomic) IBOutlet UILabel *tips;
@end
