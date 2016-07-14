//
//  InternalProductFootCell.h
//  wenYao-store
//
//  Created by PerryChen on 3/10/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "QWBaseCell.h"

@protocol InternalProductFootDelegate <NSObject>

- (void)generateAction;
- (void)switchAction;

@end

@interface InternalProductFootCell : QWBaseCell
@property (weak, nonatomic) IBOutlet UIView *generateCodeView;
@property (weak, nonatomic) IBOutlet UILabel *generateCodeLabel;
@property (weak, nonatomic) IBOutlet UIView *switchOnView;
@property (weak, nonatomic) IBOutlet UILabel *switchOnLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnSwitchOn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintSwitchViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintSwitchViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintSwitchViewBottom;


@property (weak, nonatomic) id<InternalProductFootDelegate> delegate;

- (IBAction)generateCodeAction:(UIButton *)sender;
- (IBAction)swichtOnAction:(UIButton *)sender;

@end
