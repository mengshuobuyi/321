//
//  PossibleDiseaseViewController.h
//  quanzhi
//
//  Created by Meng on 14-8-7.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "QWBaseVC.h"



@interface PossibleDiseaseViewController : QWBaseVC

//@property (nonatomic ,weak) UINavigationController * navigationController;
@property (nonatomic ,weak) NSString * spmCode;
@property (nonatomic, strong) UIViewController  *containerViewController;


- (void)viewDidCurrentView;
- (void)zoomInSubViews;
- (void)zoomOutSubViews;

@end
