//
//  MyBrandViewController.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/7.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseVC.h"

@protocol MyBrandViewControllerDelegate <NSObject>

- (void)changeMyBrand;

@end

@interface MyBrandViewController : QWBaseVC

@property (assign, nonatomic) id <MyBrandViewControllerDelegate> myBrandViewControllerDelegate;

@property (strong, nonatomic) NSString *expertType; //1 药师 2 营养师

@property (strong, nonatomic) NSString *registerUrl;//注册证／挂靠证明

@end
