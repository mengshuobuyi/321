//
//  AppealUtil.h
//  APP
//
//  Created by Martin.Liu on 16/7/12.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppealUtil : NSObject

+ (instancetype)sharedInstance;

/**
 *  从服务器重新拉取禁言状态，同步禁言以及申诉的状态
 */
- (void)synchronizeSilenceStatus;

/**
 *  在禁言的地方检验
 *
 *  @param vc 当前的viewController。
 *
 *  @return 如果当前用户没有登录或者没有被禁言则返回YES，否则NO并且弹出相应的申诉提示框。
 */
- (BOOL)checkSilenceStatusWithVC:(UIViewController*)vc;

@end
