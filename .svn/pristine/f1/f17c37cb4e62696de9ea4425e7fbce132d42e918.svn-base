//
//  MemberMarketConfirmView.h
//  wenYao-store
//
//  Created by PerryChen on 5/10/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MemberConfirmDelegate <NSObject>

- (void)cancelSelect;
- (void)confirmSelect;

@end

@interface MemberMarketConfirmView : UIView
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;
@property (weak, nonatomic) IBOutlet UIView *viewBg;
@property (weak, nonatomic) IBOutlet UILabel *lblMemberScore;

@property (weak, nonatomic) id<MemberConfirmDelegate> delegate;
- (IBAction)cancelAction:(id)sender;
- (IBAction)confirmAction:(id)sender;

@end
