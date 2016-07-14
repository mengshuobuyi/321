//
//  QWJSQuitExt.h
//  APP
//
//  Created by YYX on 15/8/10.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWJSExtension.h"

@interface QWJSQuitExt : QWJSExtension

{
    
    NSString                    *jsCallbackId_;
}
@property (nonatomic, retain) NSString *jsCallbackId_;


/*
 调登陆界面
 */

- (void)calloutQuitVC:(NSArray *)arguments withDict:(NSDictionary *)options;



@end
