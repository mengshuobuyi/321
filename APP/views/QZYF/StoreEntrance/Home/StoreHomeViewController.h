//
//  StoreHomeViewController.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/5/4.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseVC.h"

@interface StoreHomeViewController : QWBaseVC

@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UICollectionView *manySectionView;
@property (strong, nonatomic) IBOutlet UIView *factorySectionView;
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UIScrollView *factroyScroll;
@property (weak, nonatomic) IBOutlet UIButton *inputCode;
@property (weak, nonatomic) IBOutlet UIButton *scan;
@property (strong, nonatomic) IBOutlet UIView *headNoView;
@property (weak, nonatomic) IBOutlet UIButton *buttonRegister;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (strong,nonatomic)NSString *noticeContent;
@property (strong,nonatomic)NoticeModel *noticeModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerHeight;
@property (strong,nonatomic)NSMutableArray  *activityArray;
@end
