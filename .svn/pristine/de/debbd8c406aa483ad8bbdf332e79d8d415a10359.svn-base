//
//  InterlocutionListViewController.h
//  wenYao-store
//
//  Created by 李坚 on 16/3/4.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QWBaseVC.h"

typedef enum  ListSt {
    Enum_Waiting    = 0,//待抢答
    Enum_Answering  = 1,//解答中
    Enum_Closed     = 2,//已关闭
}ListStatus;

@interface InterlocutionListViewController : QWBaseVC

@property (strong, nonatomic) UINavigationController *navController;
@property (assign, nonatomic) ListStatus VCStatus;

@end
