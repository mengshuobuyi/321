//
//  QWClickEvent.h
//  APP
//
//  Created by caojing on 15/7/29.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalkingData.h"
#import "StatisticsModel.h"
#define  QWCLICKEVENT [QWClickEvent sharedInstance]
@interface QWClickEvent : NSObject

+ (QWClickEvent *)sharedInstance;


/**
 *	@method	sessionStarted:withChannelId:
 *  初始化统计实例，请在application:didFinishLaunchingWithOptions:方法里调用
 *	@param 	appKey 	应用的唯一标识，统计后台注册得到
 @param 	channelId(可选) 	渠道名，如“app store”
 */
- (void)qwTrackInit:(NSString *)appKey withChannelId:(NSString *)channelId;

/**
 *	@method	trackPageBegin
 *  开始跟踪某一页面（可选），记录页面打开时间
 建议在viewWillAppear或者viewDidAppear方法里调用
 *	@param 	pageName 	页面名称（自定义）
 支持64个字符以内的英文、数字、下划线的混合名称。请一定注意不要加入空格或其他开发中的转义字符。
 */
- (void)qwTrackPageBegin:(NSString *)pageName;


/**
 *	@method	trackPageEnd
 *  结束某一页面的跟踪（可选），记录页面的关闭时间
 此方法与trackPageBegin方法结对使用，
 在iOS应用中建议在viewWillDisappear或者viewDidDisappear方法里调用
 在Watch应用中建议在DidDeactivate方法里调用
 *	@param 	pageName 	页面名称，请跟trackPageBegin方法的页面名称保持一致
 支持64个字符以内的英文、数字、下划线的混合名称。请一定注意不要加入空格或其他开发中的转义字符。
 */
- (void)qwTrackPageEnd:(NSString *)pageName;


/**
 *	@method	trackEvent
 *  统计自定义事件（可选），如购买动作
 *	@param 	eventId 	事件名称（自定义）
 32个字符以内的中文、英文、数字、下划线，注意eventId中不要加空格或其他的转义字符。
 */
- (void)qwTrackEvent:(NSString *)eventId;



/**
 *	@method	trackEvent:label:
	统计带标签的自定义事件（可选），可用标签来区别同一个事件的不同应用场景
 如购买某一特定的商品
 *
 *	@param 	eventId 	事件名称（自定义）
 *	@param 	eventLabel 	事件标签（自定义）
 32个字符以内的中文、英文、数字、下划线，注意eventId中不要加空格或其他的转义字符。
 */
- (void)qwTrackEvent:(NSString *)eventId label:(NSString *)eventLabel;



/**
 *	@method	trackPageBegin
 *  开始跟踪某一页面（可选），记录页面打开时间
 建议在viewWillAppear或者viewDidAppear方法里调用
 *	@param 	model
 */
- (void)qwTrackPageBeginModel:(StatisticsModel *)model;


/**
 *	@method	trackPageEnd
 *  结束某一页面的跟踪（可选），记录页面的关闭时间
 此方法与trackPageBegin方法结对使用，
 在iOS应用中建议在viewWillDisappear或者viewDidDisappear方法里调用
 在Watch应用中建议在DidDeactivate方法里调用
 *	@param 	model
 */
- (void)qwTrackPageEndModel:(StatisticsModel *)model;


/**
 *	@method	trackEvent
 *  统计自定义事件（可选），如购买动作
 *	@param 	model
 */
- (void)qwTrackEventModel:(StatisticsModel *)model;



/**
 *	@method	trackEvent:label:
	统计带标签的自定义事件（可选），可用标签来区别同一个事件的不同应用场景
 如购买某一特定的商品
 *
 *	@param 	model
 */
- (void)qwTrackEventWithLabelModel:(StatisticsModel *)model;

/**
 *	@method	trackEvent:label:parameters
 统计带二级参数的自定义事件，单次调用的参数数量不能超过10个
 *
 *	@param 	eventId 	事件名称（自定义）
 *	@param 	eventLabel 	事件标签（自定义）
 *	@param 	parameters 	事件参数 (key只支持NSString, value支持NSString和NSNumber)
 */
- (void)qwTrackEventWithAllModel:(StatisticsModel *)model;



@end
