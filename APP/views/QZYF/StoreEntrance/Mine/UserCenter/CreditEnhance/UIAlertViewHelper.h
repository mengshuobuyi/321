//
//  UIAlertViewHelper.h
//  wenYao-store
//
//  Created by  ChenTaiyu on 16/5/16.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSString *kNotiUIAlertViewAllDismissed;

@interface UIAlertViewHelper : NSObject

+ (instancetype)helper;
/// 目前存在的所有UIAlertView
@property(nonatomic, copy, readonly) NSArray *availableAlertViews;
@property (nonatomic, assign) BOOL hasVisibleAlert;


- (void)dismissAllAlertViews;

@end
