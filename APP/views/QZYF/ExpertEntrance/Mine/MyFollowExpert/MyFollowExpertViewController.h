//
//  MyFollowExpertViewController.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/7.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseVC.h"

@interface MyFollowExpertViewController : QWBaseVC

@property (assign, nonatomic) int jumpType; //1 我关注的圈子  2 Ta关注的圈子
@property (strong, nonatomic) NSString *userId;

@end
