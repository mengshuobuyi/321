//
//  ExpertPageViewController.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/15.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseVC.h"
#import "GUITabPagerViewController.h"

@interface ExpertPageViewController : GUITabPagerViewController

@property (strong, nonatomic) NSString *posterId;  //专家id
@property (assign, nonatomic) int expertType;      //3 药师  4 营养师

@end
