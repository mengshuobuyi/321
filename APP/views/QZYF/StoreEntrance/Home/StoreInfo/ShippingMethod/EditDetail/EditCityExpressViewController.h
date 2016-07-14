//
//  EditCityExpressViewController.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/7/13.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseVC.h"

@interface EditCityExpressViewController : QWBaseVC

@property (strong, nonatomic) NSString *deliverTimeText;

@property (strong, nonatomic) NSString *quickPriceText;

@property (strong, nonatomic) NSString *freePriceText;

@property (strong, nonatomic) NSArray *postTips; //配送方式

@end
