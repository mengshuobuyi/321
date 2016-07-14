//
//  IndentDetailViewController.h
//  APP
//
//  Created by qw_imac on 15/12/29.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "QWBaseVC.h"
typedef NS_ENUM(NSInteger,AllOrdersTipsStatus) {
    OrdersTipsAll = 0,
    OrdersTipsHavePost,
    OrdersTipsNotPost,
};
@interface IndentDetailViewController : QWBaseVC
@property (nonatomic,strong) UINavigationController *navi;
@property (nonatomic,strong) NSString               * status;
@property (nonatomic,assign) AllOrdersTipsStatus    tipsStatus;//上传小票状态
@end
