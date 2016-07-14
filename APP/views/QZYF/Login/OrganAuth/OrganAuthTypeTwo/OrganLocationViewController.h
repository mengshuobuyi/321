//
//  OrganLocationViewController.h
//  wenYao-store
//
//  Created by YYX on 15/8/22.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseVC.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <AMapSearchKit/AMapCommonObj.h>

@protocol OrganLocationViewControllerDelegate <NSObject>

- (void)passLocationValue:(CGFloat)latitude longitude:(CGFloat)longitude otherInfo:(NSDictionary *)dic;

@end

@interface OrganLocationViewController : QWBaseVC

@property (assign, nonatomic) id <OrganLocationViewControllerDelegate> organLocationViewControllerDelegate;

@end
