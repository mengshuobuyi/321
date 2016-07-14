//
//  SetLabelViewController.h
//  wenyao-store
//
//  Created by Meng on 14-10-25.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QWBaseVC.h"
#import "MyCustomerBaseModel.h"
@protocol changeLabeldelegate <NSObject>

-(void)changeLabeldelegate;

@end

@interface SetLabelViewController : QWBaseVC

@property (strong, nonatomic) IBOutlet UIImageView *img_write;
@property (strong, nonatomic) MyCustomerInfoModel *modelUserInfo;
@property (assign, nonatomic) id <changeLabeldelegate> delegate;

@end
