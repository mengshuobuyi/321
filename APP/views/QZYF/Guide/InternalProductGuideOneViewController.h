//
//  InternalProductGuideOneViewController.h
//  wenYao-store
//
//  Created by PerryChen on 5/24/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InternalProductGuideDelegate <NSObject>

- (void)showStepTwo;

@end

@interface InternalProductGuideOneViewController : UIView

@property (nonatomic, weak) id<InternalProductGuideDelegate> guideDelegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintStepTwoBottom;

- (void)showGuide;
- (IBAction)actionDismissGuide:(id)sender;
@end
