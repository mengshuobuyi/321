//
//  PrivateMessageListViewController.h
//  wenYao-store
//  
//  Created by 李坚 on 16/3/4.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QWBaseVC.h"

@interface PrivateMessageListViewController : QWBaseVC

@property (strong, nonatomic) UINavigationController *navController;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *mainTableView;

@end
