//
//  RYTWebviewInvokedURLCommand.m
//  RYTong
//
//  Created by Bing Zheng.
//  Copyright 2012 RYTong. All rights reserved.
//

 #import "URICode.h"

#import "QWWebviewInvokedURLCommand.h"

#import "SBJson.h"
@implementation QWWebviewInvokedURLCommand

@synthesize arguments;
@synthesize options;
@synthesize command;
@synthesize serviceName;
@synthesize methodName;

+ (QWWebviewInvokedURLCommand *)newFromUrl:(NSURL*)url {

	QWWebviewInvokedURLCommand* iuc = [[QWWebviewInvokedURLCommand alloc] init];
	
    iuc.command = [url host];
	
	NSString * fullUrl = [url description];
//    fullUrl = [URICode unescapeURIComponent:fullUrl];
    NSString *prefix = [NSString stringWithFormat:@"%@://%@@%@/", [url scheme], [url user], [iuc command]];
	NSInteger prefixLength = [prefix length]; //sessionKey is encoded in user credentials
//    NSString *qs = [URICode unescapeURIComponent:[url query]];
    NSString *qs = [url query];
	NSInteger qsLength = [qs length];
	NSInteger pathLength = [fullUrl length] - prefixLength;

	// remove query string length
    if (qsLength > 0) {
		pathLength = pathLength - qsLength - 1; // 1 is the "?" char
    }
	// remove leading forward slash length
	else if ([fullUrl hasSuffix:@"/"] && pathLength > 0) {
		pathLength -= 1; // 1 is the "/" char
    }
	
    NSString* path = @"";
	if (pathLength > 0) {
		path = [fullUrl substringWithRange:NSMakeRange(prefixLength, pathLength)];
	}
	
	// Array of arguments
	NSMutableArray* arguments = [NSMutableArray arrayWithArray:[path componentsSeparatedByString:@"/"]];
	NSInteger i, arguments_count = [arguments count];
	for (i = 0; i < arguments_count; i++) {
		[arguments replaceObjectAtIndex:i withObject:[(NSString *)[arguments objectAtIndex:i]
													  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	}
	iuc.arguments = arguments;

	// Dictionary of options
	NSString* objectString = [qs stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 
    iuc.options = [objectString JSONValue];
	NSMutableArray* components = [NSMutableArray arrayWithArray:[iuc.command componentsSeparatedByString:@"."]];
	if (components.count >= 2) {
		iuc.methodName = [components lastObject];
		[components removeLastObject];
		iuc.serviceName = [components componentsJoinedByString:@"."];
	}
	
	return iuc;
}
 
@end
