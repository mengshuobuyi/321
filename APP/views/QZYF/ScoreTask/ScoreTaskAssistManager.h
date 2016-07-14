//
//  ScoreTaskAssistManager.h
//  wenYao-store
//
//  Created by PerryChen on 6/15/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QWGlobalManager.h"
#import "UserInfoModel.h"
@interface ScoreTaskAssistManager : NSObject
@property (nonatomic, assign) NSInteger curStep;

- (void)checkIfOverOneHour;

/**
 *  清除用户的积分任务时间戳
 */
- (void)clearCurTask;

/**
 *  用户登陆后立即判断任务
 */
- (void)showViewAfterLogin;

/**
 *  创建积分任务的页面
 */
- (void)createScoreTaskView;
@end
