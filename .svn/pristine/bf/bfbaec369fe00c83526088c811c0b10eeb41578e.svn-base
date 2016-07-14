//
//  InterlocutionListViewController.h
//  wenYao-store
//  问答三个列表（待抢答、解答中、已关闭）
//  Created by 李坚 on 16/3/4.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QWBaseVC.h"

typedef enum  ListSt {
    Enum_Waiting       = 0,            //待抢答
    Enum_Answering     = 1,            //解答中
    Enum_Closed        = 2,            //已关闭
}ListStatus;

@interface InterlocutionListViewController : QWBaseVC

@property (strong, nonatomic) UINavigationController *navController;
@property (assign, nonatomic) ListStatus VCStatus;
@property (assign, nonatomic) int currentPage;  //分页加载当前页

@end
