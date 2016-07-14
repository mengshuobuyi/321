//
//  CompanyViewController.h
//  wenYao-store
//
//  Created by qwfy0006 on 15/4/1.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseVC.h"

@protocol finishcompanyInfoDelegate <NSObject>

-(void)finishcompanyInfoDelegate:(BOOL)finish;

@end

@interface CompanyViewController : QWBaseVC

@property (assign, nonatomic) BOOL     Listchose;
@property (assign, nonatomic) BOOL     choseaddress;
@property (strong, nonatomic) NSString *account;
@property (strong, nonatomic) NSString *token;
@property (weak  , nonatomic) id <finishcompanyInfoDelegate> finishcompanyInfoDelegate;

@end
