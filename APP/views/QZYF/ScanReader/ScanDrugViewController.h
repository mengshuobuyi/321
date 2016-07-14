//
//  ScanDrugViewController.h
//  wenYao-store
//
//  Created by 李坚 on 15/3/26.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseVC.h"
#import "Promotion.h"
@interface ScanDrugViewController : QWBaseVC<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) ProductModel *product;
@property (weak, nonatomic) IBOutlet UITableView *drugTableView;

@end
