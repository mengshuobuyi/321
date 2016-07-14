//
//  QuickSearchDrugListViewController.h
//  wenYao-store
//
//  Created by YYX on 15/6/8.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseVC.h"

typedef void (^PassValueBlock)(id model);

@interface QuickSearchDrugListViewController : QWBaseVC

@property (nonatomic, copy) PassValueBlock block;
@property (nonatomic, strong) NSString *kwName;

@end
