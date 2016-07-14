//
//  InternalProductGuideOneViewController.m
//  wenYao-store
//
//  Created by PerryChen on 5/24/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "InternalProductGuideOneViewController.h"
#import "QWGlobalManager.h"
@interface InternalProductGuideOneViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewStepTwo;
@property (weak, nonatomic) IBOutlet UIView *viewStepOne;
@property (nonatomic, assign) NSInteger intStepNum;
@end

@implementation InternalProductGuideOneViewController

- (void)awakeFromNib
{
    self.intStepNum = 1;
}

- (void)showGuide
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)actionDismissGuide:(id)sender {
    if (self.intStepNum == 1) {
        self.intStepNum ++;
        if ([self.guideDelegate respondsToSelector:@selector(showStepTwo)]) {
            [self.guideDelegate showStepTwo];
        }
        self.viewStepOne.hidden = YES;
        self.viewStepTwo.hidden = NO;
        
    } else if (self.intStepNum == 2) {
        [self removeFromSuperview];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:[NSNumber numberWithBool:YES] forKey:QWGLOBALMANAGER.configure.passportId];
        self.intStepNum = 1;
    }
    
}

@end
