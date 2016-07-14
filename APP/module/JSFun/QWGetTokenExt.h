//
//  QWGetTokenExt.h
//  APP
//
//  Created by PerryChen on 9/21/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import "QWJSExtension.h"

@interface QWGetTokenExt : QWJSExtension

@property (nonatomic, copy) NSString *jsCallbackId_;

-(void)getTokenInfo:(NSArray *)arguments withDict:(NSDictionary *)options;

@end
