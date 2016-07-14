//
//  SVProgressHUD.h
//
//  Created by Sam Vermette on 27.03.11.
//  Copyright 2011 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVProgressHUD
//

#import <UIKit/UIKit.h>
#import <AvailabilityMacros.h>

enum {
    QWProgressHUDMaskTypeNone = 1, // allow user interactions while HUD is displayed
    QWProgressHUDMaskTypeClear, // don't allow
    QWProgressHUDMaskTypeBlack, // don't allow and dim the UI in the back of the HUD
    QWProgressHUDMaskTypeGradient // don't allow and dim the UI with a a-la-alert-view bg gradient
};

typedef NSUInteger QWProgressHUDMaskType;

@interface QWProgressHUD : UIView

+ (void)show;
+ (void)showWithStatus:(NSString*)status hintString:(NSString *)hintString;
+ (void)showWithStatus:(NSString*)status hintString:(NSString *)hintString maskType:(QWProgressHUDMaskType)maskType;
+ (void)showWithMaskType:(QWProgressHUDMaskType)maskType;

+ (void)showSuccessWithStatus:(NSString*)string hintString:(NSString *)hintString;
+ (void)showSuccessWithStatus:(NSString *)string hintString:(NSString *)hintString duration:(NSTimeInterval)duration;
+ (void)showErrorWithStatus:(NSString *)string hintString:(NSString *)hintString;
+ (void)showErrorWithStatus:(NSString *)string hintString:(NSString *)hintString duration:(NSTimeInterval)duration;

+ (void)setStatus:(NSString*)string hintString:(NSString *)hintString; // change the HUD loading status while it's showing

+ (void)dismiss; // simply dismiss the HUD with a fade+scale out animation
+ (void)dismissWithSuccess:(NSString*)successString hintString:(NSString *)hintString; // also displays the success icon image
+ (void)dismissWithSuccess:(NSString*)successString hintString:(NSString *)hintString afterDelay:(NSTimeInterval)seconds;
+ (void)dismissWithError:(NSString*)errorString hintString:(NSString *)hintString; // also displays the error icon image
+ (void)dismissWithError:(NSString*)errorString hintString:(NSString *)hintString afterDelay:(NSTimeInterval)seconds;

+ (BOOL)isVisible;

/**
 *  3.1.0 新增新人专享礼包提示需求 by martin
 */
+ (void)showGiftBagView;

@end
