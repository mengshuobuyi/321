//
//  ScoreTaskAssistManager.m
//  wenYao-store
//  管理积分任务
//  Created by PerryChen on 6/15/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "ScoreTaskAssistManager.h"
#import "CustomScoreTaskView.h"
#import "TaskScore.h"
#import "QWBaseVC.h"
#import "UserCenterViewController.h"
#import "InternalProductListViewController.h"
#import "TrainingListViewController.h"
#import "BusinessSenseViewController.h"
#import "MyIndentViewController.h"
#import "StoreHomeViewController.h"
@interface ScoreTaskAssistManager()
{
    
}
@property (nonatomic, strong) CustomScoreTaskView *viewTask;
@end
@implementation ScoreTaskAssistManager

- (instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkIfOverOneHour) name:[NSString stringWithFormat:@"%ld",NotiTaskViewDismissed] object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NSString stringWithFormat:@"%ld",NotiTaskViewDismissed] object:nil];
}

- (void)updateTimeInteval
{
    UserTaskScoreModel *modelTask = [UserTaskScoreModel getObjFromDBWithKey:QWGLOBALMANAGER.configure.passportId];
    NSTimeInterval intevalNow = [[NSDate date] timeIntervalSince1970];
    modelTask.intevalLastLeave = intevalNow;
    [modelTask saveToDB];
}

//检查是否超过一小时
- (void)checkIfOverOneHour
{
    if (QWGLOBALMANAGER.loginStatus == NO) {
        return;
    }
    if (!OrganAuthPass) {
        return;
    }
    // 获取缓存的Model
    UserTaskScoreModel *modelTask = [UserTaskScoreModel getObjFromDBWithKey:QWGLOBALMANAGER.configure.passportId];
    NSTimeInterval intevalNow = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval intevalModel = modelTask.intevalLastLeave;
    if (modelTask != nil) {
        // 以前存储过
    } else {
        // 新登录
        // 需要存储时间
        modelTask = [[UserTaskScoreModel alloc] init];
        modelTask.passPort = QWGLOBALMANAGER.configure.passportId;
        modelTask.curTaskStep = taskNone;
        modelTask.intevalLastLeave = intevalNow;
    }
    
    NSTimeInterval intevalDiff = intevalNow - intevalModel;
    DDLogVerbose(@"$$$$ interval is %f",intevalDiff);
    if (intevalDiff >= 60 * 60) {
        // 大于一小时，请求接口
        modelTask.intevalLastLeave = intevalNow;
        [modelTask saveToDB];
        __block typeof (self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf getTaskScoreList];
//            [weakSelf performSelector:@selector(createScoreTaskView) withObject:nil afterDelay:1.0f];
        });
        
        DDLogVerbose(@"$$$$ large than one hour");
    } else {
        // 小于一小时，不管
        DDLogVerbose(@"$$$$ less than one hour");
    }
}

// 跳转的页面代码
- (void)jumpFunction:(NSString *)tapKey
{
    UITabBarController *vcTab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if ([vcTab isKindOfClass:[QWTabBar class]]) {
        UINavigationController *vcNavi = (UINavigationController *)vcTab.selectedViewController;
        QWBaseVC *vcLastObj = (QWBaseVC *)[vcNavi.viewControllers lastObject];
        // 根据后台的key，进行不同的跳转
        if ([tapKey isEqualToString:@"SIGN"]) {
            // 用户中心页面
            if (![vcLastObj isKindOfClass:[UserCenterViewController class]]) {
                [vcTab setSelectedIndex:4];
                UINavigationController *vcNewNavi = (UINavigationController *)vcTab.selectedViewController;
                [vcNewNavi popToRootViewControllerAnimated:YES];
            }
        } else if ([tapKey isEqualToString:@"ORDER_RECEIVE"]) {
            // 待接单页面
            if (![vcLastObj isKindOfClass:[MyIndentViewController class]]) {
                [vcTab setSelectedIndex:1];
                UINavigationController *vcNewNavi = (UINavigationController *)vcTab.selectedViewController;
                [vcNewNavi popToRootViewControllerAnimated:YES];
                MyIndentViewController *vc = (MyIndentViewController *)vcNewNavi.viewControllers.firstObject;
                vc.index = OrdersIndexPending;
            } else {
                [((MyIndentViewController *)vcLastObj) jumpToIndexPage:OrdersIndexPending];
            }
        } else if ([tapKey isEqualToString:@"SHARE"]) {
            // 跳转本店商品页面
            if (![vcLastObj isKindOfClass:[InternalProductListViewController class]]) {
                [vcTab setSelectedIndex:2];
                UINavigationController *vcNewNavi = (UINavigationController *)vcTab.selectedViewController;
                [vcNewNavi popToRootViewControllerAnimated:YES];
            }
        } else if ([tapKey isEqualToString:@"TRAIN"]) {
            // 跳转培训列表
            if (![vcLastObj isKindOfClass:[TrainingListViewController class]]) {
                // 如果当前页面不是培训列表，则跳转
                for (QWBaseVC *vcContains in vcNavi.viewControllers) {
                    // 当前堆栈有培训列表，直接pop
                    if ([vcContains isKindOfClass:[TrainingListViewController class]]) {
                        [vcNavi popToViewController:vcContains animated:YES];
                        return ;
                    }
                }
                TrainingListViewController *vc = [[UIStoryboard storyboardWithName:@"TrainingList" bundle:nil] instantiateViewControllerWithIdentifier:@"TrainingListViewController"];
                vc.hidesBottomBarWhenPushed = YES;
                [vcNavi pushViewController:vc animated:YES];
            }
        } else if ([tapKey isEqualToString:@"BUSINESS"]) {
            // 跳转生意经列表
            if (![vcLastObj isKindOfClass:[BusinessSenseViewController class]]) {
                // 如果当前页面不是生意经列表，则跳转
                for (QWBaseVC *vcContains in vcNavi.viewControllers) {
                    // 当前堆栈有生意经列表，直接pop
                    if ([vcContains isKindOfClass:[BusinessSenseViewController class]]) {
                        [vcNavi popToViewController:vcContains animated:YES];
                        return ;
                    }
                }
                BusinessSenseViewController *vc = [[BusinessSenseViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [vcNavi pushViewController:vc animated:YES];
            }
        }
    }
    DDLogVerbose(@"click confirm");
}

/**
 *  创建积分任务的页面
 */
- (void)createScoreTaskView
{
//    if (![[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UITabBarController class]]) {
//        return;
//    }
//    
//    for (UIView *subView in [UIApplication sharedApplication].keyWindow.subviews) {
//        NSLog(@"sub view is %@",subView);
//        if ([subView isKindOfClass:NSClassFromString(@"CreditEnhanceAlertHostView")]) {
//            [self.viewTask sendSubviewToBack:subView];
//            return;
//        }
//    }

    if (self.viewTask == nil) {
        self.viewTask = (CustomScoreTaskView *)[[NSBundle mainBundle] loadNibNamed:@"CustomScoreTaskView" owner:self options:nil][0];
        __block typeof(self) wself = self;
        self.viewTask.blockCancel = ^(){
            // 点击取消
            [wself updateTimeInteval];
            DDLogVerbose(@"click cancel");
        };
        
        self.viewTask.blockConfirm = ^(NSString *tapKey){
            // 点击跳转
            [wself updateTimeInteval];
            [wself jumpFunction:tapKey];
        };
    }
    UITabBarController *vcTab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if ([vcTab isKindOfClass:[QWTabBar class]]) {
        QWBaseNavigationController *vcNavi = (QWBaseNavigationController *)([vcTab viewControllers][0]);
        if ([vcNavi isMemberOfClass:[QWBaseNavigationController class]]) {
            QWBaseVC *vcController = [vcNavi viewControllers][0];
            if ([vcController isKindOfClass:[StoreHomeViewController class]]) {
                if (self.viewTask.superview == nil) {
                    // view 不存在，则添加
                    CGRect rectFrame = [[UIScreen mainScreen] bounds];
                    self.viewTask.frame = CGRectMake(0, 0, rectFrame.size.width, 40.0f);
                    
                    [vcController.view addSubview:self.viewTask];
                    [vcController.view bringSubviewToFront:self.viewTask];
                    self.viewTask.alpha = 0;
                    [UIView animateWithDuration:0.5f animations:^{
                        self.viewTask.alpha = 1;
                    } completion:^(BOOL finished) {
                        
                    }];
                } else {
                    // 如果view已经存在，则放到第一个
                    [vcController.view bringSubviewToFront:self.viewTask];
                }
            }
        }
    }

}

- (void)getTaskScoreList
{
    TaskScoreModelR *modelR = [TaskScoreModelR new];
    __block typeof(self) wself = self;
    [TaskScore getTaskScore:modelR success:^(TaskScoreListModel *responseModel) {
        [wself createScoreTaskView];
        [wself getNextTaskWithDataSource:responseModel.reminder];
    } failure:^(HttpException *e) {
        [wself.viewTask removeFromSuperview];
    }];
}

// 获取下一个Model
- (void)getNextTaskWithDataSource:(NSArray *)arrData
{
    UserTaskScoreModel *modelTask = [UserTaskScoreModel getObjFromDBWithKey:QWGLOBALMANAGER.configure.passportId];
    NSInteger curStep = modelTask.curTaskStep;
    TaskScoreModel *modelSelect = nil;
    for (int i = 0; i < 5; i++) {
        if (curStep == taskFive) {
            curStep = taskOne;
        } else {
            curStep ++;
        }
        TaskScoreModel *model = arrData[curStep];
        if (model.completed == YES) {
            // 如果任务完成，则循环下一个任务
            continue;
        } else {
            // 任务未完成，则找到。
            modelSelect = model;
            modelSelect.curStep = curStep;
            break;
        }
    }
    if (modelSelect == nil) {
        // 所有任务已经完成
        self.viewTask.hidden = YES;
    } else {
        //
        self.viewTask.hidden = NO;
        self.viewTask.modelScore = modelSelect;
        modelTask.curTaskStep = modelSelect.curStep;
        [modelTask saveToDB];
    }
}

- (void)clearCurTask
{
    UserTaskScoreModel *modelTask = [UserTaskScoreModel getObjFromDBWithKey:QWGLOBALMANAGER.configure.passportId];
//    modelTask.curTaskStep = taskOne;
//    modelTask.intevalLastLeave = 0;
//    [modelTask saveToDB];
    [UserTaskScoreModel deleteToDB:modelTask];
    [self.viewTask removeFromSuperview];
}

- (void)showViewAfterLogin
{
    UserTaskScoreModel *modelTask = [UserTaskScoreModel getObjFromDBWithKey:QWGLOBALMANAGER.configure.passportId];
    NSTimeInterval intevalNow = [[NSDate date] timeIntervalSince1970];
    if (modelTask != nil) {
        // 以前存储过
    } else {
        // 新登录
        modelTask = [[UserTaskScoreModel alloc] init];
        modelTask.passPort = QWGLOBALMANAGER.configure.passportId;
        modelTask.curTaskStep = taskOne;
    }
    modelTask.intevalLastLeave = intevalNow;
    [modelTask saveToDB];
//    [self createScoreTaskView];
    [self checkIfOverOneHour];
}


@end
