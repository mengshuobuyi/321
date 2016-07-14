//
//  SVProgressHUD.m
//
//  Created by Sam Vermette on 27.03.11.
//  Copyright 2011 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVProgressHUD
//

#import "QWProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "ConstraintsUtility.h"
#import "Constant.h"
#import "AppDelegate.h"
@interface QWProgressHUD ()

@property (nonatomic, readwrite) QWProgressHUDMaskType maskType;
@property (nonatomic, strong, readonly) NSTimer *fadeOutTimer;

@property (nonatomic, strong, readonly) UIWindow *overlayWindow;
@property (nonatomic, strong, readonly) UIView *hudView;
@property (nonatomic, strong, readonly) UILabel *stringLabel;
@property (nonatomic, strong, readonly) UILabel *hintLabel;
@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *spinnerView;

@property (nonatomic, readonly) CGFloat visibleKeyboardHeight;

- (void)showWithStatus:(NSString*)string hintString:(NSString *)hintString maskType:(QWProgressHUDMaskType)hudMaskType networkIndicator:(BOOL)show;
- (void)setStatus:(NSString*)string hintString:(NSString *)hintString;
- (void)registerNotifications;
- (void)moveToPoint:(CGPoint)newCenter rotateAngle:(CGFloat)angle;
- (void)positionHUD:(NSNotification*)notification;

- (void)dismiss;
- (void)dismissWithStatus:(NSString*)string error:(BOOL)error;
- (void)dismissWithStatus:(NSString*)string error:(BOOL)error afterDelay:(NSTimeInterval)seconds;

@end


@implementation QWProgressHUD

@synthesize overlayWindow, hudView, maskType, fadeOutTimer, stringLabel, imageView, spinnerView, visibleKeyboardHeight,hintLabel;

- (void)dealloc {
	self.fadeOutTimer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


+ (QWProgressHUD*)sharedView {
    static dispatch_once_t once;
    static QWProgressHUD *sharedView;
    dispatch_once(&once, ^ { sharedView = [[QWProgressHUD alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; });
    return sharedView;
}


+ (void)setStatus:(NSString *)string hintString:(NSString *)hintString{
	[[QWProgressHUD sharedView] setStatus:string hintString:(NSString *)hintString];
}

#pragma mark - Show Methods

+ (void)show {
    [[QWProgressHUD sharedView] showWithStatus:nil hintString:nil maskType:QWProgressHUDMaskTypeNone networkIndicator:NO];
}

+ (void)showWithStatus:(NSString *)status hintString:(NSString *)hintString{
    [[QWProgressHUD sharedView] showWithStatus:status hintString:hintString maskType:QWProgressHUDMaskTypeNone networkIndicator:NO];
}

+ (void)showWithMaskType:(QWProgressHUDMaskType)maskType {
    [[QWProgressHUD sharedView] showWithStatus:nil hintString:nil maskType:maskType networkIndicator:NO];
}

+ (void)showWithStatus:(NSString*)status hintString:(NSString *)hintString maskType:(QWProgressHUDMaskType)maskType {
    [[QWProgressHUD sharedView] showWithStatus:status hintString:hintString maskType:maskType networkIndicator:NO];
}

+ (void)showSuccessWithStatus:(NSString *)string hintString:(NSString *)hintString{
    [QWProgressHUD showSuccessWithStatus:string hintString:hintString duration:1];
}

+ (void)showSuccessWithStatus:(NSString *)string hintString:(NSString *)hintString duration:(NSTimeInterval)duration {
    [QWProgressHUD show];
    [QWProgressHUD dismissWithSuccess:string hintString:hintString afterDelay:duration];
}

+ (void)showErrorWithStatus:(NSString *)string hintString:(NSString *)hintString{
    [QWProgressHUD showErrorWithStatus:string hintString:hintString duration:1];
}

+ (void)showErrorWithStatus:(NSString *)string hintString:(NSString *)hintString duration:(NSTimeInterval)duration {
    
    if (string==nil) {
        DebugLog(@"########  showErrorWithStatus:%@",string);
        return;
    }
    
    [QWProgressHUD show];
    [QWProgressHUD dismissWithError:string hintString:hintString afterDelay:duration];
}


#pragma mark - Dismiss Methods

+ (void)dismiss {
	[[QWProgressHUD sharedView] dismiss];
}

+ (void)dismissWithSuccess:(NSString*)successString hintString:(NSString *)hintString{
	[[QWProgressHUD sharedView] dismissWithStatus:successString hintString:hintString error:NO];
}

+ (void)dismissWithSuccess:(NSString *)successString hintString:(NSString *)hintString afterDelay:(NSTimeInterval)seconds {
    [[QWProgressHUD sharedView] dismissWithStatus:successString hintString:hintString error:NO afterDelay:seconds];
}

+ (void)dismissWithError:(NSString*)errorString hintString:(NSString *)hintString{
	[[QWProgressHUD sharedView] dismissWithStatus:errorString hintString:hintString error:YES];
}

+ (void)dismissWithError:(NSString *)errorString hintString:(NSString *)hintString afterDelay:(NSTimeInterval)seconds {
    [[QWProgressHUD sharedView] dismissWithStatus:errorString hintString:hintString error:YES afterDelay:seconds];
}


#pragma mark - Instance Methods

- (id)initWithFrame:(CGRect)frame {
	
    if ((self = [super initWithFrame:frame])) {
		self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
		self.alpha = 0;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
	
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    switch (self.maskType) {
            
        case QWProgressHUDMaskTypeBlack: {
            [[UIColor colorWithWhite:0 alpha:0.5] set];
            CGContextFillRect(context, self.bounds);
            break;
        }
            
        case QWProgressHUDMaskTypeGradient: {
            
            size_t locationsCount = 2;
            CGFloat locations[2] = {0.0f, 1.0f};
            CGFloat colors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f}; 
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
            CGColorSpaceRelease(colorSpace);
            
            CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
            float radius = MIN(self.bounds.size.width , self.bounds.size.height) ;
            CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
            CGGradientRelease(gradient);
            
            break;
        }
    }
}

- (void)setStatus:(NSString *)string hintString:(NSString *)hintString{
	
    CGFloat hudWidth = 100;
    CGFloat hudHeight = 100;
    CGFloat stringWidth = 0;
    CGFloat stringHeight = 0;
    CGRect labelRect = CGRectZero;
    CGRect hintRect = CGRectZero;
    if(string) {
        CGSize stringSize =[GLOBALMANAGER sizeText:string font:self.stringLabel.font constrainedToSize:CGSizeMake(200, 300)];
        CGSize hintSize =[GLOBALMANAGER sizeText:hintString font:self.hintLabel.font constrainedToSize:CGSizeMake(200, 300)];
        stringWidth = stringSize.width;
        stringHeight = stringSize.height;
        hudHeight = 80+stringHeight + hintSize.height;
        
        if(stringWidth > hudWidth)
            hudWidth = ceil(stringWidth/2)*2;
        
        if(hudHeight > 100) {
            labelRect = CGRectMake(12, 20, hudWidth, stringHeight);
            hudWidth+=24;
            hintRect = CGRectMake(12, hudHeight - hintSize.height - 15, hudWidth - 12 * 2, hintSize.height);
        } else {
            hudWidth+=24;  
            labelRect = CGRectMake(0, 20, hudWidth, stringHeight);
            hintRect = CGRectMake(12,  hudHeight - hintSize.height - 1, hudWidth -12 *2, hintSize.height);
        }
    }
	
	self.hudView.bounds = CGRectMake(0, 0, hudWidth, hudHeight);

    self.imageView.center = CGPointMake(CGRectGetWidth(self.hudView.bounds)/2, labelRect.origin.y + labelRect.size.height + 25);

	self.stringLabel.hidden = NO;
	self.stringLabel.text = string;
	self.stringLabel.frame = labelRect;
	
    self.hintLabel.hidden = NO;
    self.hintLabel.text = hintString;
    self.hintLabel.frame = hintRect;

    self.spinnerView.center = CGPointMake(ceil(CGRectGetWidth(self.hudView.bounds)/2)+0.5, 40.5);
}

- (void)setFadeOutTimer:(NSTimer *)newTimer {
    
    if(fadeOutTimer)
        [fadeOutTimer invalidate], fadeOutTimer = nil;
    
    if(newTimer)
        fadeOutTimer = newTimer;
}


- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(positionHUD:) 
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification 
                                               object:nil];  
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(positionHUD:) 
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(positionHUD:) 
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(positionHUD:) 
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(positionHUD:) 
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
}


- (void)positionHUD:(NSNotification*)notification {
    
    CGFloat keyboardHeight;
    double animationDuration = 0.0;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(notification) {
        NSDictionary* keyboardInfo = [notification userInfo];
        CGRect keyboardFrame = [[keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        animationDuration = [[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        if(notification.name == UIKeyboardWillShowNotification || notification.name == UIKeyboardDidShowNotification) {
            if(UIInterfaceOrientationIsPortrait(orientation))
                keyboardHeight = keyboardFrame.size.height;
            else
                keyboardHeight = keyboardFrame.size.width;
        } else
            keyboardHeight = 0;
    } else {
        keyboardHeight = self.visibleKeyboardHeight;
    }
    
    CGRect orientationFrame = [UIScreen mainScreen].bounds;
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    
    if(UIInterfaceOrientationIsLandscape(orientation)) {
        float temp = orientationFrame.size.width;
        orientationFrame.size.width = orientationFrame.size.height;
        orientationFrame.size.height = temp;
        
        temp = statusBarFrame.size.width;
        statusBarFrame.size.width = statusBarFrame.size.height;
        statusBarFrame.size.height = temp;
    }
    
    CGFloat activeHeight = orientationFrame.size.height;
    
    if(keyboardHeight > 0)
        activeHeight += statusBarFrame.size.height*2;
    
    activeHeight -= keyboardHeight;
    CGFloat posY = floor(activeHeight*0.45);
    CGFloat posX = orientationFrame.size.width/2;
    
    CGPoint newCenter;
    CGFloat rotateAngle;
    
    switch (orientation) { 
        case UIInterfaceOrientationPortraitUpsideDown:
            rotateAngle = M_PI; 
            newCenter = CGPointMake(posX, orientationFrame.size.height-posY);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            rotateAngle = -M_PI/2.0f;
            newCenter = CGPointMake(posY, posX);
            break;
        case UIInterfaceOrientationLandscapeRight:
            rotateAngle = M_PI/2.0f;
            newCenter = CGPointMake(orientationFrame.size.height-posY, posX);
            break;
        default: // as UIInterfaceOrientationPortrait
            rotateAngle = 0.0;
            newCenter = CGPointMake(posX, posY);
            break;
    } 
    
    if(notification) {
        [UIView animateWithDuration:animationDuration 
                              delay:0 
                            options:UIViewAnimationOptionAllowUserInteraction 
                         animations:^{
                             [self moveToPoint:newCenter rotateAngle:rotateAngle];
                         } completion:NULL];
    } 
    
    else {
        [self moveToPoint:newCenter rotateAngle:rotateAngle];
    }
    
}

- (void)moveToPoint:(CGPoint)newCenter rotateAngle:(CGFloat)angle {
    self.hudView.transform = CGAffineTransformMakeRotation(angle); 
    self.hudView.center = newCenter;
}

#pragma mark - Master show/dismiss methods

- (void)showWithStatus:(NSString*)string hintString:(NSString *)hintString maskType:(QWProgressHUDMaskType)hudMaskType networkIndicator:(BOOL)show {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(!self.superview)
            [self.overlayWindow addSubview:self];
        
        self.fadeOutTimer = nil;
        self.imageView.hidden = YES;
        self.maskType = hudMaskType;
        
        [self setStatus:string hintString:hintString];
        [self.spinnerView startAnimating];
        
        if(self.maskType != QWProgressHUDMaskTypeNone) {
            self.overlayWindow.userInteractionEnabled = YES;
        } else {
            self.overlayWindow.userInteractionEnabled = NO;
        }
        
        [self.overlayWindow makeKeyAndVisible];
        [self positionHUD:nil];
        
        if(self.alpha != 1) {
            [self registerNotifications];
            self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1.3, 1.3);
            
            [UIView animateWithDuration:0.15
                                  delay:0
                                options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                             animations:^{	
                                 self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1/1.3, 1/1.3);
                                 self.alpha = 1;
                             }
                             completion:NULL];
        }
        [self setNeedsDisplay];
    });
}


- (void)dismissWithStatus:(NSString*)string hintString:(NSString *)hintString error:(BOOL)error {
	[self dismissWithStatus:string error:error afterDelay:0.9];
}


- (void)dismissWithStatus:(NSString *)string hintString:(NSString *)hintString error:(BOOL)error afterDelay:(NSTimeInterval)seconds {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.alpha != 1)
            return;
        
        if(error)
            self.imageView.image = [UIImage imageNamed:@"提示Logo"];
        else
            self.imageView.image = [UIImage imageNamed:@"提示Logo"];
        
        self.imageView.hidden = NO;
        [self setStatus:string hintString:hintString];
        [self.spinnerView stopAnimating];
        
        self.fadeOutTimer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
    });
}

- (void)dismiss {
    dispatch_async(dispatch_get_main_queue(), ^{

        [UIView animateWithDuration:0.15
                              delay:0
                            options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                         animations:^{	
                             self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 0.8, 0.8);
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished){ 
                             if(self.alpha == 0) {
                                 [[NSNotificationCenter defaultCenter] removeObserver:self];
                                 [hudView removeFromSuperview];
                                 hudView = nil;
                                 
                                 // Make sure to remove the overlay window from the list of windows
                                 // before trying to find the key window in that same list
                                 NSMutableArray *windows = [[NSMutableArray alloc] initWithArray:[UIApplication sharedApplication].windows];
                                 [windows removeObject:overlayWindow];
                                 overlayWindow = nil;
                                 
                                 [windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
                                   if([window isKindOfClass:[UIWindow class]] && window.windowLevel == UIWindowLevelNormal) {
                                     [window makeKeyWindow];
                                     *stop = YES;
                                   }
                                 }];
                             }
                         }];
    });
}

#pragma mark - Utilities

+ (BOOL)isVisible {
    return ([QWProgressHUD sharedView].alpha == 1);
}

+ (void)showGiftBagView
{
    NSInteger giftBagViewTag = 1234321;
    UIView* keyWindow = ((AppDelegate *)([UIApplication sharedApplication].delegate)).window;
    UIView* backView = [[UIView alloc] init];
    backView.backgroundColor = RGBAHex(0x000000, 0.7);
    backView.tag = giftBagViewTag;
    
    [keyWindow addSubview:backView];
    
    UIView* giftBagView = [[UIView alloc] init];
    giftBagView.backgroundColor = [UIColor whiteColor];
    giftBagView.layer.masksToBounds = YES;
    giftBagView.layer.cornerRadius = 8;
    [backView addSubview:giftBagView];
    
    UIImageView* imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"img_gift"];
    
    
    UILabel* tipLabel1 = [[UILabel alloc] init];
    tipLabel1.font = [UIFont boldSystemFontOfSize:kFontS1];
    tipLabel1.textColor = RGBHex(qwColor3);
    tipLabel1.text = @"恭喜您获得新人专享大礼包!";
    
    UILabel* tipLabel2 = [[UILabel alloc] init];
    tipLabel2.font = [UIFont systemFontOfSize:kFontS5];
    tipLabel2.textColor = RGBHex(qwColor7);
    tipLabel2.text = @"可前往 “我的优惠券” 查看";
    
    UIButton* okBtn = [[UIButton alloc] init];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:kFontS3];
    [okBtn setTitleColor:RGBHex(qwColor4) forState:UIControlStateNormal];
    okBtn.backgroundColor = RGBHex(qwColor2);
    okBtn.layer.masksToBounds = YES;
    okBtn.layer.cornerRadius = 4;
    [okBtn setTitle:@"我知道了" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [giftBagView addSubview:imageView];
    [giftBagView addSubview:tipLabel1];
    [giftBagView addSubview:tipLabel2];
    [giftBagView addSubview:okBtn];
    
    if (backView.superview) {
        PREPCONSTRAINTS(backView);
        PREPCONSTRAINTS(giftBagView);
        PREPCONSTRAINTS(imageView);
        PREPCONSTRAINTS(tipLabel1);
        PREPCONSTRAINTS(tipLabel2);
        PREPCONSTRAINTS(okBtn);
        
        ALIGN_TOPLEFT(backView, 0);
        ALIGN_BOTTOMRIGHT(backView, 0);
        
        CONSTRAIN_SIZE(giftBagView, 270, 255);
        CENTER(giftBagView);
        
        ALIGN_TOP(imageView, 2);
        CENTER_H(imageView);
        
        CENTER_H(tipLabel1);
        LAYOUT_V_WITHOUTCENTER(tipLabel1, 6, tipLabel2);
        
        CENTER_H(tipLabel2);
        LAYOUT_V_WITHOUTCENTER(tipLabel2, 23, okBtn);
        
        CENTER_H(okBtn);
        CONSTRAIN_SIZE(okBtn, 210, 40);
        ALIGN_BOTTOM(okBtn, 18);
    }
    
    backView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        backView.alpha = 1;
    }];
}

+ (void)okBtnAction:(UIButton*)button
{
    NSInteger giftBagViewTag = 1234321;
    UIView* keyWindow = ((AppDelegate *)([UIApplication sharedApplication].delegate)).window;
    __block UIView* backView = [keyWindow viewWithTag:giftBagViewTag];
    
    [UIView animateWithDuration:0.25 animations:^{
        backView.alpha = 0;
    } completion:^(BOOL finished) {
        [backView removeFromSuperview];
        backView = nil;
    }];
}

#pragma mark - Getters

- (UIWindow *)overlayWindow {
    if(!overlayWindow) {
        overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayWindow.backgroundColor = [UIColor clearColor];
        overlayWindow.userInteractionEnabled = NO;
    }
    return overlayWindow;
}

- (UIView *)hudView {
    if(!hudView) {
        hudView = [[UIView alloc] initWithFrame:CGRectZero];
        hudView.layer.cornerRadius = 10;
		hudView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        hudView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin |
                                    UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin);
        
        [self addSubview:hudView];
    }
    return hudView;
}

- (UILabel *)stringLabel {
    if (stringLabel == nil) {
        stringLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		stringLabel.textColor = [UIColor whiteColor];
		stringLabel.backgroundColor = [UIColor clearColor];
		stringLabel.adjustsFontSizeToFitWidth = YES;
		stringLabel.textAlignment = NSTextAlignmentCenter;
		stringLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		stringLabel.font = [UIFont boldSystemFontOfSize:16];
		stringLabel.shadowColor = [UIColor blackColor];
		stringLabel.shadowOffset = CGSizeMake(0, -1);
        stringLabel.numberOfLines = 0;
    }
    
    if(!stringLabel.superview)
        [self.hudView addSubview:stringLabel];
    
    return stringLabel;
}

- (UILabel *)hintLabel {
    if (hintLabel == nil) {
        hintLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        hintLabel.textColor = [UIColor whiteColor];
        hintLabel.backgroundColor = [UIColor clearColor];
        hintLabel.adjustsFontSizeToFitWidth = YES;
        hintLabel.textAlignment = NSTextAlignmentCenter;
        hintLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        hintLabel.font = [UIFont boldSystemFontOfSize:20];
        hintLabel.shadowColor = [UIColor blackColor];
        hintLabel.shadowOffset = CGSizeMake(0, -1);
        hintLabel.numberOfLines = 0;
    }
    
    if(!hintLabel.superview)
        [self.hudView addSubview:hintLabel];
    
    return hintLabel;
    
    
}


- (UIImageView *)imageView {
    if (imageView == nil)
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 69, 21)];
    
    if(!imageView.superview)
        [self.hudView addSubview:imageView];
    
    return imageView;
}

- (UIActivityIndicatorView *)spinnerView {
    if (spinnerView == nil) {
        spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		spinnerView.hidesWhenStopped = YES;
		spinnerView.bounds = CGRectMake(0, 0, 37, 37);
    }
    
    if(!spinnerView.superview)
        [self.hudView addSubview:spinnerView];
    
    return spinnerView;
}

- (CGFloat)visibleKeyboardHeight {
        
    UIWindow *keyboardWindow = nil;
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
        if(![[testWindow class] isEqual:[UIWindow class]]) {
            keyboardWindow = testWindow;
            break;
        }
    }

    // Locate UIKeyboard.  
    UIView *foundKeyboard = nil;
    for (__strong UIView *possibleKeyboard in [keyboardWindow subviews]) {
        
        // iOS 4 sticks the UIKeyboard inside a UIPeripheralHostView.
        if ([[possibleKeyboard description] hasPrefix:@"<UIPeripheralHostView"]) {
            possibleKeyboard = [[possibleKeyboard subviews] objectAtIndex:0];
        }                                                                                
        
        if ([[possibleKeyboard description] hasPrefix:@"<UIKeyboard"]) {
            foundKeyboard = possibleKeyboard;
            break;
        }
    }
        
    if(foundKeyboard && foundKeyboard.bounds.size.height > 100)
        return foundKeyboard.bounds.size.height;
    
    return 0;
}



@end
