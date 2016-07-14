//
//  GoodFieldViewController.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/7.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseVC.h"

@protocol GoodFieldViewControllerDelegate <NSObject>

- (void)changeGoodField:(NSArray *)array;

@end

@interface GoodFieldViewController : QWBaseVC

@property (assign, nonatomic) id <GoodFieldViewControllerDelegate> goodFieldViewControllerDelegate;

@end
