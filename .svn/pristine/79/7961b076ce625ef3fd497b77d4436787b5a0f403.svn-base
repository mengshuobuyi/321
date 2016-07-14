//
//  QWClickEvent.m
//  APP
//
//  Created by caojing on 15/7/29.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWClickEvent.h"
#import "QWGlobalManager.h"

@implementation QWClickEvent


+ (QWClickEvent *)sharedInstance
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)qwTrackInit:(NSString *)appKey withChannelId:(NSString *)channelId{
    //是否捕捉程序崩溃记录
    [TalkingData setExceptionReportEnabled:YES];
    // 是否捕捉异常信号
    [TalkingData setSignalReportEnabled:YES];
    
    [TalkingData sessionStarted:appKey withChannelId:@"appstore"];
}


- (void)qwTrackPageBegin:(NSString *)pageName{
    [TalkingData trackPageBegin:pageName];
}

- (void)qwTrackPageEnd:(NSString *)pageName{
    [TalkingData trackPageEnd:pageName];
}

- (void)qwTrackEvent:(NSString *)eventId{
    [TalkingData trackEvent:eventId];
}

- (void)qwTrackEvent:(NSString *)eventId label:(NSString *)eventLabel{
    [TalkingData trackEvent:eventId label:eventLabel];
}

//model
- (void)qwTrackPageBeginModel:(StatisticsModel *)model{
    [TalkingData trackPageBegin:model.pageName];
}

- (void)qwTrackPageEndModel:(StatisticsModel *)model{
    [TalkingData trackPageEnd:model.pageName];
}

- (void)qwTrackEventModel:(StatisticsModel *)model{
    [TalkingData trackEvent:model.eventId];

    NSDictionary *tmpInfo = [QWGLOBALMANAGER.EventData objectForKey: model.eventId];
    if( [tmpInfo objectForKey: @"name"]){
        model.eventId = [NSString stringWithFormat:@"%@", [tmpInfo objectForKey: @"name"]];
    }
//    [[Zhuge sharedInstance] track:model.eventId];
//    UserInfoModel *mod=QWGLOBALMANAGER.configure;
//    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//    if(mod.userName){
//        userInfo[@"name"] = mod.userName;
//    }
//    if(mod.avatarUrl){
//        userInfo[@"avatar"] = mod.avatarUrl;
//    }
//    NSString *userId =@"";
//    if(mod.passportId){
//        userId = mod.passportId;
//    }
//    [[Zhuge sharedInstance] identify:userId properties:userInfo];

}

- (void)qwTrackEventWithLabelModel:(StatisticsModel *)model{
    [TalkingData trackEvent:model.eventId label:model.eventLabel];
}


- (void)qwTrackEventWithAllModel:(StatisticsModel *)model{
    
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:model.eventId delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//        [alert show];
    
    if([model.eventId isEqualToString:@""]){
        return;
    }else{
        if([model.eventLabel isEqualToString:@""]){
            if([model.params count]==0){
                [TalkingData trackEvent:model.eventId];
            }else{
                [TalkingData trackEvent:model.eventId label:@"未注释页面" parameters:model.params];
            }
        }else{
            if([model.params count]==0){
                [TalkingData trackEvent:model.eventId label:model.eventLabel];
            }else{
                [TalkingData trackEvent:model.eventId label:model.eventLabel parameters:model.params];
            }
            
        }
    }
}


@end
