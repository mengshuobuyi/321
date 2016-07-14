//
//  BaseInfromationViewController.h
//  quanzhi
//
//  Created by Meng on 14-8-7.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "QWBaseVC.h"
#import "SymBaseInfroCell.h"
#import "OrderModel.h"

@interface BaseInfromationViewController : QWBaseVC<UITableViewDataSource,UITableViewDelegate,SymBaseInfroCellDelegate>

@property (nonatomic, strong) UITableView   *myTableView;
@property (nonatomic ,weak) UINavigationController * navigationController;
@property (nonatomic ,strong) spminfoDetail * dataSource;
@property (nonatomic ,strong) NSString * spmCode;


- (void)viewDidCurrentView;

@end
