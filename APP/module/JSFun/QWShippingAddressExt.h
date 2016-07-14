//
//  QWShippingAddressExt.h
//  APP
//
//  Created by PerryChen on 1/15/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "QWJSExtension.h"

@interface QWShippingAddressExt : QWJSExtension
@property (nonatomic, copy) NSString *jsCallbackId_;
-(void)getAddressInfo:(NSArray *)arguments withDict:(NSDictionary *)options;
-(void)getNewAddress:(NSArray *)arguments withDict:(NSDictionary *)options;
@end
