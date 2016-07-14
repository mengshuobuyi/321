//
//  CircleDetailNextViewController.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/8.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "QWBaseVC.h"

@class CircleDetailNextViewController;
@protocol CircleDetailNextViewControllerDelegaet <NSObject>

- (void)didScrollToTop:(CircleDetailNextViewController *)vc;

@end

@interface CircleDetailNextViewController : QWBaseVC

@property (nonatomic, assign) id<CircleDetailNextViewControllerDelegaet> delegate;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) NSString *requestType; //1 看帖 2 热门 3 专家 4 咨询
@property (strong, nonatomic) NSString *sliderTabIndex; //1 全部 2 专家帖 3 热门帖 4 用户帖
@property (strong, nonatomic) NSString *jumpType;    //跳转类型  1:圈子详情  2:药师专栏
@property (strong, nonatomic) NSString *teamId;      //圈子id
@property (strong, nonatomic) NSString *expertId;    //专家id
@property (assign, nonatomic) BOOL flagGroup;        //是否是商家圈

//刷新列表
- (void)currentViewSelected:(void (^)(CGFloat height))finishLoading;

//分页加载
- (void)footerRereshing:(void (^)(CGFloat height))finishRefresh :(void(^)(BOOL canLoadMore))canLoadMore :(void(^)())failure;

@end
