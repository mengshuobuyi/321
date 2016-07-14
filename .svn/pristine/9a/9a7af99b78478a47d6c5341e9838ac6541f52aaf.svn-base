//
//  TreatMedicineViewController.h
//  APP
//
//  Created by Meng on 15/6/10.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWBaseVC.h"

@interface DiseaseTreatRuleMedicineViewController : QWBaseVC

@property (nonatomic ,strong) UINavigationController *navigationController;

@property (nonatomic ,strong) NSString *diseaseId;

@property (nonatomic ,strong) NSString *requestType;

- (void)currentViewSelected:(void (^)(CGFloat height))finishLoading;

- (void)footerRereshing:(void (^)(CGFloat height))finishRefresh :(void(^)(BOOL canLoadMore))canLoadMore :(void(^)())failure;
- (void)setUpTableFrame:(CGRect)rect;
@end
