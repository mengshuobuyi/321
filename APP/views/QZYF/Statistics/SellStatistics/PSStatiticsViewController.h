//
//  ConsultPharmacyViewController.h
//  wenyao
//
//  Created by caojing on 14-9-17.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "QWBaseVC.h"

@interface PSStatiticsViewController : QWBaseVC

@property (nonatomic, strong) NSString   *proId;  // 优惠商品id
@property (weak, nonatomic) IBOutlet UITableView *PStableView;

@end
