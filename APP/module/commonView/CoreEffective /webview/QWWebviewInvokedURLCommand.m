

#import "SBJson.h"
#import "URICode.h"


#import "QWWebviewInvokedURLCommand.h"


@implementation QWWebviewInvokedURLCommand

@synthesize arguments;
@synthesize options;
@synthesize command;
@synthesize serviceName;
@synthesize methodName;

+ (QWWebviewInvokedURLCommand *)newFromUrl:(NSURL*)url {
    /*
	 * Get Command and Options From URL
	 * We are looking for URLS that match yourscheme://<sessionKey>@<Class>.<command>/[<arguments>][?<dictionary>]
	 * We have to strip off the leading slash for the options.
	 *
	 * Note: We have to go through the following contortions because NSURL "helpfully" unescapes
	 * certain characters, such as "/" from their hex encoding for us. This normally wouldn't
	 * be a problem, unless your argument has a "/" in it, such as a file path.
	 */
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
