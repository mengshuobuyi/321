//
//  QWPageRedirectExt.h
//  APP
//
//  Created by PerryChen on 8/20/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import "QWJSExtension.h"


@class WebDirectViewController;
@interface QWPageRedirectExt : QWJSExtension
@property (nonatomic, copy) NSString *jsCallbackId_;
-(void)startSkipApp:(NSArray *)arguments withDict:(NSDictionary *)options;

@end
