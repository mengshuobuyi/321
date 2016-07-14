//
//  UIAlertViewHelper.m
//  wenYao-store
//
//  Created by  ChenTaiyu on 16/5/16.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "UIAlertViewHelper.h"

NSString *kNotiUIAlertViewAllDismissed = @"kNotiUIAlertViewAllDismissed";

@interface UIAlertView (STApplicationContext)

@end

@implementation UIAlertView (STApplicationContext)


/*
static void InstallAddSubviewListener(void (^listener)(id _self, UIView* subview))
{
    if ( listener == NULL )
    {
        NSLog(@"listener cannot be NULL.");
        return;
    }
    
    Method addSubviewMethod = class_getInstanceMethod([UIView class], @selector(didAddSubview:));
    IMP originalImp = method_getImplementation(addSubviewMethod);
    
    void (^block)(id, UIView*) = ^(id _self, UIView* subview) {
        originalImp(_self, @selector(didAddSubview:), subview);
        listener(_self, subview);
    };
    
    IMP newImp = imp_implementationWithBlock((__bridge id)((__bridge void*)block));
    method_setImplementation(addSubviewMethod, newImp);
}
 */


+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(show)), class_getInstanceMethod(self, @selector(st_show)));

}

- (void)st_show {
    UIAlertViewHelper *context = [UIAlertViewHelper helper];
    NSHashTable *hashTable = [context valueForKey:@"_alertViewHashTable"];
    if ([hashTable isKindOfClass:[NSHashTable class]]) {
        [hashTable addObject:self];
    }
    [self st_show];
}


@end

@interface UIAlertViewHelper ()

@end

@implementation UIAlertViewHelper {
    NSHashTable *_alertViewHashTable;
}

static UIAlertViewHelper *_helper;
+ (UIAlertViewHelper *)helper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _helper = [[UIAlertViewHelper alloc] init];
    });
    return _helper;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _alertViewHashTable = [NSHashTable weakObjectsHashTable];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(aWindowBecameHidden:)
                                                     name:UIWindowDidBecomeHiddenNotification
                                                   object:nil];
    }
    return self;
}

- (NSArray *)availableAlertViews {
    return [[_alertViewHashTable allObjects] copy];
}

- (BOOL)hasVisibleAlert
{
    BOOL flag = NO;
    for (UIAlertView *alert in _alertViewHashTable.allObjects) {
        if (alert.visible) {
            flag = YES;
            break;
        }
    }
    return flag;
}

- (void)dismissAllAlertViews {
    if (self.availableAlertViews.count > 0) {
        [self.availableAlertViews enumerateObjectsUsingBlock:^(UIAlertView *obj, NSUInteger idx, BOOL *stop) {
            [obj dismissWithClickedButtonIndex:obj.cancelButtonIndex animated:NO];
        }];
    }
}

- (void)aWindowBecameHidden:(NSNotification *)notify
{
    if (!self.hasVisibleAlert)
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotiUIAlertViewAllDismissed object:self];
}


@end