//
//  Countdown.m
//  APP
//
//  Created by Yan Qingyang on 15/9/16.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "Countdown.h"
@interface Countdown()
{
    dispatch_source_t timerCD;
    CDBlock aBlock;
    int num;
    NSDate *stopTime;
}
@property (assign) int CD;
@end

@implementation Countdown
- (id)init{
    if (self = [super init]) {
        [self addObserverGlobal];
        num = 0;
    }
    return self;
}

- (void)setCD:(int)CD block:(CDBlock)block{
    _CD=CD;
    if (block)
        aBlock=block;
    
    [self begin];
}
- (void)begin{
    if (timerCD)
        timerCD=[TIMER timerClose:timerCD];
    
    timerCD=[TIMER timerLoop:timerCD timeInterval:1.0 blockLoop:^{
        num++;
//
        int ii=self.CD-num;
        if (num>=self.CD) {
            DebugLog(@"关闭循环");
            if (timerCD)
                timerCD=[TIMER timerClose:timerCD];
            [self removeObserverGlobal];
            ii=0;
        }
        
        if (aBlock) {
            aBlock(ii);
        }
    } blockStop:^{
        //
    }];
}

- (void)stop{
    
    stopTime=[NSDate date];
}

- (void)start{
    NSTimeInterval tt=[stopTime timeIntervalSinceNow];
    DebugLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> %f",tt);
    int nn=(int)tt*-1;
    num+=nn;
    [self begin];
}
#pragma mark 接收通知
- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    if (type == NotifAppDidEnterBackground){
        //进后台
        DebugLog(@"cd 轮询暂停");
        [self stop];
    }
    else if (type == NotifAppWillEnterForeground){
        //back
        DebugLog(@"cd 轮询继续");
        [self start];
    }
}



#pragma mark 全局通知
- (void)addObserverGlobal{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotif:) name:kQWGlobalNotification object:nil];
}

- (void)removeObserverGlobal{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kQWGlobalNotification object:nil];
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
@end
