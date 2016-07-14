//
//  QWShareExt.h
//  APP
//
//  Created by PerryChen on 8/27/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import "QWJSExtension.h"
//#import "WebDirectViewController.h"

@interface QWShareExt : QWJSExtension
@property (nonatomic, copy) NSString *jsCallbackId_;
-(void):(NSArray *)arguments withDict:(NSDictionary *)options;
//-(void)runExtWithCallBackId:(NSString *)strCallbackID;
@end
