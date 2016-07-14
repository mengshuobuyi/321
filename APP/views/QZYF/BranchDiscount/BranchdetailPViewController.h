//
//  BranchdetailCViewController.h
//  wenYao-store
//
//  Created by caojing on 15/8/26.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseVC.h"
#import "Coupn.h"

@interface BranchdetailPViewController : QWBaseVC

@property (weak, nonatomic) IBOutlet UITableView *coupnDetail;
@property (nonatomic ,strong) NSString *coupnId;

@end
