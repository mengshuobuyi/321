//
//  SearchProductSalesViewController.h
//  wenYao-store
//
//  Created by Martin.Liu on 16/5/16.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseVC.h"

@interface SearchProductSalesViewController : QWBaseVC
@property (nonatomic, strong) NSArray* productArray;
@property (nonatomic, strong) NSString* startDate;
@property (nonatomic, strong) NSString* endDate;
@property (nonatomic, assign) NSInteger upOrDown;
@end
