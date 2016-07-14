//
//  QuickScanDrugListViewController.h
//  wenYao-store
//
//  Created by YYX on 15/6/9.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QWBaseVC.h"
#import "Promotion.h"
#import "DrugModel.h"

typedef void (^PassValueBlock)(id model);

@interface QuickScanDrugListViewController : QWBaseVC<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) ExpertSearchMedicineListModel *product;
@property (weak, nonatomic) IBOutlet UITableView *drugTableView;
@property (nonatomic, copy) PassValueBlock block;

@property (assign, nonatomic) BOOL sendMedicineByStore;

@end
