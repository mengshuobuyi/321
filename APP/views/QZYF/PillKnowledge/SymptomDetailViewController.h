//
//  SymptomDetailViewController.h
//  quanzhi
//
//  Created by Meng on 14-8-6.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "QWBaseVC.h"
#import "QCSlideSwitchView.h"

@interface SymptomDetailViewController : QWBaseVC<QCSlideSwitchViewDelegate>

@property (nonatomic ,strong) QCSlideSwitchView * slideSwitchView;
@property (nonatomic ,strong) NSString * spmCode;
@property (nonatomic, strong) UIViewController  *containerViewController;


@end
