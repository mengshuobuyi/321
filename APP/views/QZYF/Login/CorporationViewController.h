//
//  CorporationViewController.h
//  wenYao-store
//
//  Created by qwfy0006 on 15/4/2.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseVC.h"

@protocol finishcorporationInfoDelegate <NSObject>

-(void)finishcorporationInfo:(BOOL)finish;

@end

@interface CorporationViewController : QWBaseVC

@property (weak, nonatomic) id<finishcorporationInfoDelegate> finishcorporationInfoDelegate;

@end
