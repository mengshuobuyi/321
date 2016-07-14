//
//  MarketSelectBrochureViewController.h
//  wenYao-store
//
//  Created by PerryChen on 5/11/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "QWBaseVC.h"
#import "ActivityModel.h"
typedef void(^SelectBrochureBlock)(QueryActivityInfo *model);

@interface MarketSelectBrochureViewController : QWBaseVC
@property (nonatomic, strong) QueryActivityInfo *modelVo;
@property (nonatomic, strong) SelectBrochureBlock block;
@end
