//
//  QWShippingDiscoveryExt.h
//  wenYao-store
//
//  Created by PerryChen on 6/28/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "QWJSExtension.h"

@interface QWShippingDiscoveryExt : QWJSExtension
@property (nonatomic, copy) NSString *jsCallbackId_;
-(void)getDiscoveryInfo:(NSArray *)arguments withDict:(NSDictionary *)options;
@end
