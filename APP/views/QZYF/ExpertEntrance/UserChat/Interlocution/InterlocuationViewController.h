//
//  InterlocuationViewController.h
//  wenYao-store
//
//  Created by 李坚 on 16/3/4.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QWBaseVC.h"

@interface InterlocuationViewController : QWBaseVC

@property (strong, nonatomic) UINavigationController *navController;

@property (assign, nonatomic) NSInteger selectedIndex;
@property (assign, nonatomic) NSInteger selectedNum;     //当前被选中的view

@property (strong, nonatomic) UIImageView *redPointOne;  //待抢答的小红点
@property (strong, nonatomic) UIImageView *redPointTwo;  //解答中的小红点

@end
