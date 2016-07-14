//
//  MemberPointShortageView.h
//  wenYao-store
//
//  Created by PerryChen on 5/10/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MmeberPointShortageDelegate <NSObject>
- (void)RechooseMember;
@end

@interface MemberPointShortageView : UIView
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIButton *btnRechoose;
@property (weak, nonatomic) IBOutlet UIView *viewBg;
@property (weak, nonatomic) id<MmeberPointShortageDelegate> delegate;
- (IBAction)actionRechoose:(UIButton *)sender;

@end
