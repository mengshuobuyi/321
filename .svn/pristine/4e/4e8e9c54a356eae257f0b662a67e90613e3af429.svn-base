//
//  QWProgressLoading.h
//  APP
//
//  Created by Yan Qingyang on 15/4/23.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>

#define  QWLOADING [QWLoading instance]

@protocol QWLoadingDelegate;

@interface QWLoading : UIView
@property (assign) id delegate;
@property (assign) float minShowTime;

+ (instancetype)instance;
+ (instancetype)instanceWithDelegate:(id)delegate;

- (void)showLoading;
- (void)removeLoading;

//立刻去掉loading，无延时
- (void)closeLoading;
@end

@protocol QWLoadingDelegate <NSObject>

@optional
- (void)hudStopByTouch:(id)hud;
@end