//
//  RYTWebviewInvokedURLCommand.h
//  RYTong
//
//  Created by Bing Zheng.
//  Copyright 2012 RYTong. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
    url解析
 */
@interface QWWebviewInvokedURLCommand : NSObject {
	NSString* command;
	NSString* serviceName;
	NSString* methodName;
	NSMutableArray* arguments;
	id options;
}

@property(retain) NSMutableArray* arguments;
@property(retain) id options;
@property(copy) NSString* command;
@property(copy) NSString* serviceName;
@property(copy) NSString* methodName;

/**
 * Get Command and Options From URL
 * We are looking for URLS that match yourscheme://<sessionKey>@<Class>.<command>/[<arguments>][?<dictionary>]
 * We have to strip off the leading slash for the options.
 *
 * Note: We have to go through the following contortions because NSURL "helpfully" unescapes
 * certain characters, such as "/" from their hex encoding for us. This normally wouldn't
 * be a problem, unless your argument has a "/" in it, such as a file path.

 */
+ (QWWebviewInvokedURLCommand *)newFromUrl:(NSURL*)url;


@end
