//
//  AppDelegate.m
//  APP
//
//  Created by carret on 15/1/16.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "AppDelegate.h"
//#import "SystemMacro.h"
#import "HttpClient.h"
//#import "css.h"
//#import "QWcss.h"
//#import "QWGlobalManager.h"
//
#import "System.h"
////版本更新
//#import "VersionUpdate.h"
#import "LoginViewController.h"
#import "XMPPStream.h"
#import "NotificationModel.h"
#import "Consult.h"
#import "ConsultModel.h"

#import "CustomInfoAlertView.h"

#import "HomePageViewController.h"
#import "ConsultModelR.h"
#import "XHAudioPlayerHelper.h"
#import "SVProgressHUD.h"
#import "LaunchViewController.h"
#import "LaunchEntranceViewController.h"
#import "HealthQADetailViewController.h"
//#import "ExpertLoginViewController.h"
#import "ExpertLoginRootViewController.h"
#import "IndentDetailViewController.h"
#import "IndentDetailListViewController.h"
#import "Order.h"
#import "ExpertMessageCenter.h"
#import "ExpertInfoViewController.h"
#import "ExpertAuthViewController.h"
#import "ConsultationMainViewController.h"
#import "QWYSViewController.h"
#import "MsgBoxViewController.h"

@implementation AppDelegate
@synthesize window;
AppDelegate *app = nil;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //talking
    [QWCLICKEVENT qwTrackInit:appTalkingDataID withChannelId:@"appStore"];
    QWGLOBALMANAGER.isLoadH5=NO;
    [self addObserverGlobal];
    
    self.dicNotice = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    [QWUserDefault setNumber:[NSNumber numberWithLongLong:0] key:SERVER_TIME];
    [QWGLOBALMANAGER createHeartBeatTimer];
    
    
    
    //先设置定义  域名是否被封的测试
    //cj----cj
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *apiUrl = [def objectForKey:@"APIDOMAIN"];
    NSString *h5Url = [def objectForKey:@"H5DOMAIN"];
    if(apiUrl&&![apiUrl isEqualToString:@""]){
        [HttpClientMgr setBaseUrl:apiUrl];
    }else{
        [HttpClientMgr setBaseUrl:BASE_URL_V2];
    }
    //请求第一个域名
    [self queryOnceDomain];
    // 正式运行
    [self initforLaunch];
    [self initLogSetting];
    
   
    return YES;
}



- (void)initLogSetting
{
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat: @"Documents/Log/"]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path]){
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    QWGLOBALMANAGER.fileLogger = [[DDFileLogger alloc] initWithLogFileManager:[[DDLogFileManagerDefault alloc] initWithLogsDirectory:path]];
    QWGLOBALMANAGER.fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    QWGLOBALMANAGER.fileLogger.logFileManager.maximumNumberOfLogFiles = 1;
    
}

-(void)setStartApp{
    
    //重新默认
    //cj----cj
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *apiUrl = [def objectForKey:@"APIDOMAIN"];
    NSString *h5Url = [def objectForKey:@"H5DOMAIN"];
    if(apiUrl&&![apiUrl isEqualToString:@""]){
        [HttpClientMgr setBaseUrl:apiUrl];
    }else{
        [HttpClientMgr setBaseUrl:BASE_URL_V2];
    }
    
    
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:APP_LAST_SYSTEM_VERSION_V2];
    if(!lastVersion || ![lastVersion isEqualToString:APP_VERSION]) {
        //        [QWGLOBALMANAGER clearOldCache];
        [[NSUserDefaults standardUserDefaults] setObject:APP_VERSION forKey:APP_LAST_SYSTEM_VERSION_V2];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [QWGLOBALMANAGER saveOperateLog:@"3"];
    
    if (IS_EXPERT_ENTRANCE) {
        //专家入口
        [QWGLOBALMANAGER expertCheckTokenVaild:YES];
        
    }else{
        //门店入口
        [QWGLOBALMANAGER checkTokenVaild:YES];
    }
}


-(void)returnSetStartApp{
    
    //保持不变
    [QWUserDefault removeObjectBy:@"APIDOMAIN"];
    [QWUserDefault removeObjectBy:@"H5DOMAIN"];
    
    
    [HttpClientMgr setBaseUrl:BASE_URL_V2];
    
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:APP_LAST_SYSTEM_VERSION_V2];
    if(!lastVersion || ![lastVersion isEqualToString:APP_VERSION]) {
        //        [QWGLOBALMANAGER clearOldCache];
        [[NSUserDefaults standardUserDefaults] setObject:APP_VERSION forKey:APP_LAST_SYSTEM_VERSION_V2];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [QWGLOBALMANAGER saveOperateLog:@"3"];
    if (IS_EXPERT_ENTRANCE) {
        //专家入口
        [QWGLOBALMANAGER expertCheckTokenVaild:YES];
        
    }else{
        //门店入口
        [QWGLOBALMANAGER checkTokenVaild:YES];
    }
    
}


-(void)queryOnceDomain{
    
    NSDictionary *setting=[NSDictionary dictionary];
    
    [System systemDomainIsParams:setting success:^(id obj) {
        DomianIsModel *model=[DomianIsModel parse:obj];
        //当检查出来域名是否被封, true: 正常， false：被封
        if([model.apiStatus intValue]==0){
            if(model.domainFlag){
                //结束了以后重新设置域名  冗错
                [self returnSetStartApp];
                return ;
            }else{
                //获取新的域名
                [System systemNewDomainParams:setting success:^(id resobj) {
                    DomianModel *resmodel=[DomianModel parse:resobj];
                    if([resmodel.apiStatus intValue]==0){
                        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                        [def setObject:[NSString stringWithFormat:@"%@/",resmodel.apiDomain] forKey:@"APIDOMAIN"];
                        [def setObject:[NSString stringWithFormat:@"%@/",resmodel.h5Domain] forKey:@"H5DOMAIN"];
                    }
                    //结束了以后重新设置域名  冗错
                    [self setStartApp];
                }failure:^(HttpException *e) {
                    //结束了以后重新设置域名  冗错
                    [self setStartApp];
                }];
                
            }
            
        }else{
            //请求第二个域名
            [self queryTwiceDomain];
        }
        
    }failure:^(HttpException *e) {
        //请求第二个域名
        [self queryTwiceDomain];
    }];
    
}


-(void)queryTwiceDomain{
    
    NSDictionary *setting=[NSDictionary dictionary];
    [System systemDomainIsTwiceParams:setting success:^(id obj) {
        DomianIsModel *model=[DomianIsModel parse:obj];
        //当检查出来域名是否被封, true: 正常， false：被封
        if([model.apiStatus intValue]==0){
            if(model.domainFlag){
                //不变
                [self returnSetStartApp];
                return ;
            }else{
                //获取新的域名
                [System systemNewDomainTwiceParams:setting success:^(id resobj) {
                    DomianModel *resmodel=[DomianModel parse:resobj];
                    if([resmodel.apiStatus intValue]==0){
                        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                        [def setObject:[NSString stringWithFormat:@"%@/",resmodel.apiDomain] forKey:@"APIDOMAIN"];
                        [def setObject:[NSString stringWithFormat:@"%@/",resmodel.h5Domain] forKey:@"H5DOMAIN"];
                    }
                    //结束了以后重新设置域名  冗错
                    [self setStartApp];
                }failure:^(HttpException *e) {
                    //结束了以后重新设置域名  冗错
                    [self setStartApp];
                }];
                
            }
        }else{
            //结束了以后重新设置域名  冗错
            [self setStartApp];
        }
    }failure:^(HttpException *e) {
        //结束了以后重新设置域名  冗错
        [self setStartApp];
    }];
    
}



- (void)applicationWillResignActive:(UIApplication *)application {
    QWGLOBALMANAGER.boolLoadFromFirstIn = NO;
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


#pragma mark -
#pragma mark devicetoken

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *devStr = [NSString stringWithFormat:@"%@",deviceToken];
    NSArray *array = [devStr componentsSeparatedByString:@" "];
    self.deviceToken = [array componentsJoinedByString:@""];
    self.deviceToken = [self.deviceToken substringWithRange:NSMakeRange(1, self.deviceToken.length - 2)];
    QWGLOBALMANAGER.deviceToken = self.deviceToken;
    if(QWGLOBALMANAGER.loginStatus) {
        UpdateDeviceByTokenModelR *updateDeviceToken = [UpdateDeviceByTokenModelR new];
        updateDeviceToken.token = QWGLOBALMANAGER.configure.userToken;
        updateDeviceToken.deviceCode = self.deviceToken;
        [System updateDeviceByToken:[updateDeviceToken dictionaryModel] success:NULL failure:NULL];
    }
}

//读取上次保存的日期,并且计算与当前日期的时间间隔
- (BOOL)compareDateInterval:(NSInteger)times
{
    //历史时间
    NSDate *presentDate = [QWUserDefault getObjectBy:kApplicationLastAliveDate];
    DebugLog(@"开始进入后台 = %@",presentDate);
    
    //当前时间
    NSDate *nowDate = [NSDate date];
    DebugLog(@"开始进入前台 = %@",nowDate);
    
    NSTimeInterval timeInterval = [nowDate timeIntervalSinceDate:presentDate];
    
    
    DebugLog(@"在后台时间 = %f",timeInterval);
    
    if (timeInterval >= (60*60 *times)) {
        return YES;
    }
    return NO;
    
}

- (void)saveNowDateToLocal
{
    NSDate *nowDate = [NSDate date];
    [QWUserDefault setObject:nowDate key:kApplicationLastAliveDate];
}

#pragma mark -

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [QWGLOBALMANAGER applicationDidEnterBackground ];
    [QWGLOBALMANAGER enablePushNotification:YES];
    [self saveNowDateToLocal];
    [QWGLOBALMANAGER postNotif:NotifAppDidEnterBackground data:nil object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [QWGLOBALMANAGER postNotif:NotifAppWillEnterForeground data:nil object:nil];
    BOOL post = [self compareDateInterval:0.167];
    if(post) {
        [QWGLOBALMANAGER upLoadLogFile];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [QWGLOBALMANAGER postNotif:NotifAppDidBecomeActive data:nil object:nil];
    [QWGLOBALMANAGER applicationDidBecomeActive];
    [QWGLOBALMANAGER enablePushNotification:NO];
    [QWUserDefault setNumber:[NSNumber numberWithLongLong:0] key:SERVER_TIME];
    [QWGLOBALMANAGER createHeartBeatTimer];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [QWGLOBALMANAGER enablePushNotification:NO];
    [QWUserDefault setBool:NO key:isHiddenRacingRedPoint];
}

#pragma mark - 收到通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // chagne  by shen
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // change  end
    
//    BOOL canJump = FALSE;
    if (application.applicationState==UIApplicationStateInactive || application.applicationState==UIApplicationStateBackground)
    {

    }
    else if(UIApplicationStateActive == application.applicationState)
    {

    }
    
    BOOL canJump = FALSE;
    if (application.applicationState==UIApplicationStateInactive || application.applicationState==UIApplicationStateBackground)
    {
        NSLog(@"。。。。。。。。。。后台收到的通知");
        canJump = TRUE;
    }
    else if(UIApplicationStateActive == application.applicationState)
    {
        NSLog(@"。。。。。。。。。前台收到的通知");
        canJump = FALSE;
    }
    
    if(userInfo[@"message"])
    {
//        NSLog(@"收到推送,内容为 %@",userInfo);
        
        NSData *jsonData = [userInfo[@"message"] dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        
//
        NotificationModel *model = [NotificationModel parse:dic];
        // add by perry

        if (model) {
          
            if ([[NSString stringWithFormat:@"%@",model.type] isEqualToString:@"6"]) {//待抢答
//                NSLog(@"~~~~~ 收到待抢答通知 0");
//                if(canJump)
//                    [QWGLOBALMANAGER jumpControlWithType:0];
                //拉取数据 保存数据 刷新UI
                [QWGLOBALMANAGER getWaitingConsultList];
                [XHAudioPlayerHelper playMsgSound];

            }
            else if ([[NSString stringWithFormat:@"%@",model.type] isEqualToString:@"4"])//待抢答问题已过期
            {//这个逻辑应该走不到
//                NSLog(@"~~~~~ 收到问题已过期通知 0");
                //拉取数据 保存数据 刷新UI
//                if(canJump)
//                    [QWGLOBALMANAGER jumpControlWithType:0];
                [QWGLOBALMANAGER getWaitingConsultList];
            }
            else  if([[NSString stringWithFormat:@"%@",model.type] isEqualToString:@"7"])//解答中
            {
//                NSLog(@"~~~~~ 收到解答中的通知 1");
//                if(canJump)
//                    [QWGLOBALMANAGER jumpControlWithType:1];
                [QWGLOBALMANAGER getConsultingnewDetail];

            }
            else if ([[NSString stringWithFormat:@"%@",model.type] isEqualToString:@"3"])//问题已关闭
            {
//                if(canJump)
//                    [QWGLOBALMANAGER jumpControlWithType:2];
                [QWGLOBALMANAGER getClosedConsultList:@"0"];
            }
            else if ([[NSString stringWithFormat:@"%@",model.type] isEqualToString:@"2"])//全维药师有新消息
            {
//                NSLog(@"~~~~~ 全维药师有新消息通知");
//                if(canJump)
//                    [QWGLOBALMANAGER jumpToOffical];
                [self jumpToQWYS];
                [QWGLOBALMANAGER pullOfficialMessage];
            }
            else if ([[NSString stringWithFormat:@"%@",model.type] isEqualToString:@"10"])//点对点聊天
            {
//                NSLog(@"~~~~~ 本店咨询有新消息通知");
//                if(canJump)
//                    [QWGLOBALMANAGER jumpToOffical];
//                [QWGLOBALMANAGER pollMyConsultingConsultList];

            }
            else if ([[NSString stringWithFormat:@"%@",model.type] isEqualToString:@"18"])//订单推送
            {
               
                if (canJump) {
                    [self jumpToOrderNotiListWithOrderId:model.orderId];
                } else {
                    NSDictionary *aps = [userInfo valueForKey:@"aps"];
                    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
                    CustomInfoAlertView *alert=[CustomInfoAlertView instance];
                    alert.alertTitle.text = content;
                    alert.blockDirect = ^(BOOL success) {
                        [self jumpToOrderNotiListWithOrderId:model.orderId];
                    };
                    alert.blockCancel = ^(BOOL cancel) {
                    };
                    [alert show];
                }
                if (QWGLOBALMANAGER.configure.userToken.length > 0) {
                    [Order setOrderNotiReadWithMessageId:model.nd];
                }
            }else if ([[NSString stringWithFormat:@"%@",model.type] isEqualToString:@"19"]) //圈子消息
            {
                if (canJump) {
                    [self jumpToCircleInfoWith:model];
                }else{
                    //前台不做通知 显示小红点
                    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
                    dd[@"messageType"] = [NSString stringWithFormat:@"%d",model.msgClass];
                    [QWGLOBALMANAGER postNotif:NotifCircleMessage data:dd object:self];
                    [QWGLOBALMANAGER.tabBar showBadgePoint:YES itemTag:Enum_TabBar_Items_ExpertMine];
                    if (model.msgClass == 1) {
                        QWGLOBALMANAGER.configure.expertCommentRed = YES;
                    }else if (model.msgClass == 2){
                        QWGLOBALMANAGER.configure.expertFlowerRed = YES;
                    }else if (model.msgClass == 3){
                        QWGLOBALMANAGER.configure.expertAtMineRed = YES;
                    }else if (model.msgClass == 99){
                        QWGLOBALMANAGER.configure.expertSystemInfoRed = YES;
                        if (model.msgType == 16 || model.msgType == 18) {
                            QWGLOBALMANAGER.configure.silencedFlag = YES;
                        }else if (model.msgType == 17 || model.msgType == 19){
                            QWGLOBALMANAGER.configure.silencedFlag = NO;
                        }
                    }
                    [QWGLOBALMANAGER saveAppConfigure];
                }
            }else if ([[NSString stringWithFormat:@"%@",model.type] isEqualToString:@"26"]) //专家待抢答
            {
                if (canJump) {
                    [self jumpToInterlocution:model];
                    [QWGLOBALMANAGER pollWaitingConsultData];
                }else{
                    [QWGLOBALMANAGER getAllWaitingConsultData];
                    [QWGLOBALMANAGER pollWaitingConsultData];
                }
            }else if ([[NSString stringWithFormat:@"%@",model.type] isEqualToString:@"27"]) //专家解答中
            {
                if (canJump) {
                    [self jumpToInterlocution:model];
                }
                [QWGLOBALMANAGER getAllAnsweringConsultData];
            }else if ([[NSString stringWithFormat:@"%@",model.type] isEqualToString:@"25"]) //私聊
            {
                if(canJump){
                    [self jumpToPrivateMessage:model];
                }
                [ExpertMessageCenter pullAllExpertData];
            }else if ([@[@20, @21, @31, @32, @33] containsObject:@(model.type.intValue)]) {
                // 消息中心列表20,21,31,32 // 积分消息 33
                if (canJump) {
                    [self jumpToMsgBox];
                }
            }
        }
    }
}

#pragma mark ---- 专家问答 ----
- (void)jumpToInterlocution:(id)data
{
    NotificationModel *model = (NotificationModel *)data;
    
    if ([[NSString stringWithFormat:@"%@",model.type] isEqualToString:@"26"]){
        QWGLOBALMANAGER.expertChatPushType = @"1";
    }else if ([[NSString stringWithFormat:@"%@",model.type] isEqualToString:@"27"]){
        QWGLOBALMANAGER.expertChatPushType = @"2";
    }
    
    
    if (QWGLOBALMANAGER.configure.expertToken.length > 0) {
        UITabBarController *vcTab = (UITabBarController *)self.window.rootViewController;
        if ([vcTab isKindOfClass:[QWTabBar class]]) {
            UINavigationController *vcNavi1 = (UINavigationController *)vcTab.viewControllers[0];
            [vcNavi1 popToRootViewControllerAnimated:NO];
            UINavigationController *vcNavi2 = (UINavigationController *)vcTab.viewControllers[1];
            [vcNavi2 popToRootViewControllerAnimated:NO];
            UINavigationController *vcNavi3 = (UINavigationController *)vcTab.viewControllers[2];
            [vcNavi3 popToRootViewControllerAnimated:NO];
            
            UINavigationController *nav = (UINavigationController *)vcTab.selectedViewController;
            UIViewController *vcLastObj = [nav.viewControllers lastObject];
            
            if ([vcLastObj isKindOfClass:[ConsultationMainViewController class]]) {
                
                ConsultationMainViewController *vc = (ConsultationMainViewController *)vcLastObj;
                [vc pushChangeInterlocutionTab];
            }else{
                [vcTab setSelectedIndex:1];
            }
        }
    }else
    {
        [self showLoginViewController];
    }
}

#pragma mark ---- 专家私聊 ----
- (void)jumpToPrivateMessage:(id)data
{
    if (QWGLOBALMANAGER.configure.userToken.length > 0) {
        UITabBarController *vcTab = (UITabBarController *)APPDelegate.window.rootViewController;
        if ([vcTab isKindOfClass:[QWTabBar class]]) {
            UINavigationController *vcNavi2 = (UINavigationController *)vcTab.viewControllers[1];
            UIViewController *vcLastObj = [vcNavi2.viewControllers lastObject];
            [vcNavi2 popToRootViewControllerAnimated:NO];
            
            if ([vcLastObj isKindOfClass:[ConsultationMainViewController class]]) {
                
                [vcTab setSelectedIndex:1];
                ConsultationMainViewController *vc = (ConsultationMainViewController *)vcLastObj;
                [vc pushChangePrivateMessageTab];
            }else{
                [vcTab setSelectedIndex:1];
            }
        }
    } else {
        [self showLoginViewController];
    }
}

#pragma mark ---- 订单通知 ----
- (void)jumpToOrderNotiListWithOrderId:(NSString *)orderId
{
    if (QWGLOBALMANAGER.configure.userToken.length > 0) {
        
        UITabBarController *vcTab = (UITabBarController *)self.window.rootViewController;
        if ([vcTab isKindOfClass:[QWTabBar class]]) {
            UINavigationController *vcNavi = (UINavigationController *)vcTab.selectedViewController;
            IndentDetailListViewController *vcIndent = [IndentDetailListViewController new];
            vcIndent.orderId = orderId;
            vcIndent.hidesBottomBarWhenPushed = YES;
            [vcNavi pushViewController:vcIndent animated:YES];
        }
        
    } else {
        [self showLoginViewController];
    }
}

- (void)jumpToCircleInfoWith:(id)data
{
    self.isLaunchByNotification = YES;
    
    NotificationModel *model = (NotificationModel *)data;
    
    if (model.msgClass == 99) {//系统消息
        
        if (model.msgType == 21) {//认证审核失败
            
        }else{
            
            if (model.msgType == 10){//认证审核成功
                
            }else if (model.msgType == 16 || model.msgType == 18) {
                QWGLOBALMANAGER.configure.silencedFlag = YES;
            }else if (model.msgType == 17 || model.msgType == 19){
                QWGLOBALMANAGER.configure.silencedFlag = NO;
            }
            
            if ([QWUserDefault getBoolBy:APP_LOGIN_STATUS])
            {
                [self afterDelay:0.1 block:^{
                    if (QWGLOBALMANAGER.tabBar) {
                        [self jumpToExpertInfo:99];
                    }
                }];
            }
            else {
                [self showLoginViewController];
            }
        }
    }else {
        
        if ([QWUserDefault getBoolBy:APP_LOGIN_STATUS]) {
            if (QWGLOBALMANAGER.tabBar) {
                int tab;
                if (model.msgClass == 1) {//评论
                    tab = 1;
                }else if (model.msgClass == 2){//鲜花
                    tab = 2;
                }else if (model.msgClass == 3){//@我的
                    tab = 3;
                }
                
                [self jumpToExpertInfo:tab];
            }
        } else {
            [self showLoginViewController];
            
        }
    }
}

- (void)jumpToExpertInfo:(int)tab
{
    UITabBarController *vcTab = (UITabBarController *)self.window.rootViewController;
    if ([vcTab isKindOfClass:[QWTabBar class]]) {
        UINavigationController *vcNavi1 = (UINavigationController *)vcTab.viewControllers[0];
        [vcNavi1 popToRootViewControllerAnimated:NO];
        UINavigationController *vcNavi2 = (UINavigationController *)vcTab.viewControllers[1];
        [vcNavi2 popToRootViewControllerAnimated:NO];
        UINavigationController *vcNavi3 = (UINavigationController *)vcTab.viewControllers[2];
        [vcNavi3 popToRootViewControllerAnimated:NO];
        [vcTab setSelectedIndex:0];
        ExpertInfoViewController *vc = [[ExpertInfoViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.selectedTab = tab;
        [vcNavi1 pushViewController:vc animated:YES];
    }
}

- (void)jumpToQWYS
{
    UITabBarController *vcTab = (UITabBarController *)self.window.rootViewController;
    if ([vcTab isKindOfClass:[QWTabBar class]]) {
        vcTab.selectedIndex = 0;
        UINavigationController *vcNavi = (UINavigationController *)vcTab.selectedViewController;
        if ([vcNavi isMemberOfClass:[UINavigationController class]]) {
            [vcNavi popToRootViewControllerAnimated:NO];
            QWYSViewController *qwysViewController = [[UIStoryboard storyboardWithName:@"QWYSViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"QWYSViewController"];
            qwysViewController.hidesBottomBarWhenPushed = YES;
            qwysViewController.showType = MessageShowTypeAnswer;
            [vcNavi pushViewController:qwysViewController animated:YES];
        }
    }
}

- (void)jumpToMsgBox
{
    UITabBarController *vcTab = (UITabBarController *)self.window.rootViewController;
    if ([vcTab isKindOfClass:[QWTabBar class]]) {
        vcTab.selectedIndex = 0;
        UINavigationController *vcNavi = (UINavigationController *)vcTab.selectedViewController;
        if ([vcNavi isKindOfClass:[UINavigationController class]]) {
            [vcNavi popToRootViewControllerAnimated:NO];
            MsgBoxViewController *msgBoxViewController = [[MsgBoxViewController alloc] init];
            msgBoxViewController.hidesBottomBarWhenPushed = YES;
            [vcNavi pushViewController:msgBoxViewController animated:YES];
        }
    }
}

-(void)afterDelay:(NSTimeInterval )timerInterval block:(void (^)())block{
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timerInterval*NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        block();
    });
}

#pragma mark -
#pragma mark  整体界面的初始化

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (void)initforLaunch
{
    [self setupUserDefault];
    [self registerRemoteNotification];
    [self registerLocalNotification];
    //初始化界面
    [self initNavigationBarStyle];
    app = self;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    self.deviceToken = [XMPPStream generateUUID];
    QWGLOBALMANAGER.fadeCover = [[AppFadeCover alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self showLoginViewController];
    [QWGLOBALMANAGER initsocailShare:nil];
}

- (void)showLoginViewController
{
    NSString *userName = QWGLOBALMANAGER.configure.userName;
    NSString *password = QWGLOBALMANAGER.configure.passWord;
    
    if ((userName && ![userName isEqualToString:@""]) || (password && ![password isEqualToString:@""]) || (QWGLOBALMANAGER.configure.expertPassportId && ![QWGLOBALMANAGER.configure.expertPassportId isEqualToString:@""]))
    {
        [QWGLOBALMANAGER postNotif:NotifAppCheckVersion data:nil object:nil];
        LaunchEntranceViewController *vc = [[UIStoryboard storyboardWithName:@"Launch" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchEntranceViewController"];
        UINavigationController *nav = [[QWBaseNavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nav;
        
        // 判断进门店还是商家
        if (IS_EXPERT_ENTRANCE) {
            ExpertLoginRootViewController *vc = [[UIStoryboard storyboardWithName:@"ExpertLogin" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertLoginRootViewController"];
            [nav pushViewController:vc animated:NO];
            
        }else{
            LoginViewController *login = [[LoginViewController alloc] init];
            [nav pushViewController:login animated:NO];
        }
        
    }else
    {
        LaunchViewController *vc = [[UIStoryboard storyboardWithName:@"Launch" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchViewController"];
        UINavigationController *nav = [[QWBaseNavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nav;
    }

//    [QWGLOBALMANAGER pullCircleMessage];
}

#pragma mark 测试代码
- (void)testCode{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
 
//    UIViewController* vc = [board instantiateViewControllerWithIdentifier:@"menu"];
  
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [storyboard instantiateInitialViewController];;
}

#pragma mark -
#pragma mark 初始化
/**
 *  初始化导航栏样式
 */
- (void)initNavigationBarStyle
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBarTintColor:RGBHex(qwColor1)];//导航栏颜色
    [[UINavigationBar appearance] setTintColor:RGBHex(qwColor4)];
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName:RGBHex(qwColor4)}];
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[RGBHex(qwColor1) CGColor]);//导航栏颜色
    CGContextFillRect(context, rect);
    UIImage * imge = [[UIImage alloc] init];
    imge = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [[UINavigationBar appearance] setBackgroundImage:imge forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
}

/**
 *  初始化tab标签样式
 */
- (void)initTabBar
{
    QWGLOBALMANAGER.tabBar = [[QWTabBar alloc] initWithDelegate:self];
    self.window.rootViewController = QWGLOBALMANAGER.tabBar;
}

- (void)registerLocalNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quitAccount) name:KICK_OFF object:nil];
}

#pragma mark ---- 账号被抢登 ----

- (void)quitAccount
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:Kwarning220N81 delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        
    }else{
        [QWGLOBALMANAGER postNotif:NotifQuitOut data:nil object:nil];
        QWGLOBALMANAGER.configure.passWord = @"";
        [QWGLOBALMANAGER saveAppConfigure];
        [QWGLOBALMANAGER clearAccountInformation];
        [QWUserDefault setBool:NO key:APP_LOGIN_STATUS];
    }
}


#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif


#pragma mark -
#pragma mark 推送相关接口
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
 
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    //处理相应的业务逻辑
    [application cancelLocalNotification:notification];
}

#pragma mark -
#pragma mark  注册推送通知
/**
 *  注册推送通知
 */
- (void)registerRemoteNotification
{
#ifdef __IPHONE_8_0
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
        
    }  else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
#else
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
#endif
}

#pragma mark -
#pragma mark 新消息设置提醒
- (void)setupUserDefault
{
    if ([QWUserDefault getBoolBy:APP_VOICE_NOTIFICATION] == NO)
    {
        [QWUserDefault setBool:YES key:APP_VOICE_NOTIFICATION];
        [QWUserDefault setBool:YES key:APP_VIBRATION_NOTIFICATION];
        [QWUserDefault setBool:YES key:APP_RECEIVE_INBACKGROUND];
        [QWUserDefault setBool:YES key:ALARM_VOICE_NOTIFICATION];
        [QWUserDefault setBool:YES key:ALARM_VIBRATION_NOTIFICATION];
    }
    
}

#pragma mark 全局通知
- (void)addObserverGlobal{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotif:) name:kQWGlobalNotification object:nil];
}

- (void)getNotif:(NSNotification *)sender{
    
    NSDictionary *dd=sender.userInfo;
    NSInteger ty=-1;
    id data;
    id obj;
    
    if ([GLOBALMANAGER object:[dd objectForKey:@"type"] isClass:[NSNumber class]]) {
        ty=[[dd objectForKey:@"type"]integerValue];
    }
    data=[dd objectForKey:@"data"];
    obj=[dd objectForKey:@"object"];
    
    [self getNotifType:ty data:data target:obj];
}

#pragma mark 全局通知
- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj{
    if (type == NotifAppCheckVersion) {
        [QWGLOBALMANAGER checkVersion];
    }
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
    if ([userActivity.activityType isEqualToString:APP_SEARCH_ACTIVITY_KEY]) {
        NSLog(@"the activity user info is %@",userActivity.userInfo);
        if ([userActivity.userInfo[@"type"] isEqualToString:APP_SEARCH_ACTIVITY_HEALTHQA]) {
            // 跳转健康问答库
            if (QWGLOBALMANAGER.loginStatus) {  // 用户已经登录
                NSString *strUserID = userActivity.userInfo[@"id"]; // 获取健康问答详情id
                UITabBarController *vcTab = (UITabBarController *)self.window.rootViewController;
                UINavigationController *vcNavi = (UINavigationController *)vcTab.selectedViewController;
                HealthQADetailViewController *viewControllerDetail = (HealthQADetailViewController *)[[UIStoryboard storyboardWithName:@"HealthQALibrary" bundle:nil] instantiateViewControllerWithIdentifier:@"HealthQADetailViewController"];
                viewControllerDetail.questionID = strUserID;
                viewControllerDetail.questionTitle = userActivity.title;
                [vcNavi pushViewController:viewControllerDetail animated:YES];
            }
        }
    }
    
    return true;
}
//禁用三方键盘
- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier
{
    if ([extensionPointIdentifier isEqualToString:@"com.apple.keyboard-service"]) {
        return NO;
    }
    return YES;
}


@end
