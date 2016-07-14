//
//  CustomTrainingListFilterView.h
//  wenYao-store
//
//  Created by PerryChen on 6/14/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTrainingListFilterView : UIView

@property (nonatomic, copy) void(^ blockConfirm)(NSInteger idx);
@property (nonatomic, copy) void(^ blockCancel)();


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblAll;
@property (weak, nonatomic) IBOutlet UILabel *lblCurMerchant;
@property (weak, nonatomic) IBOutlet UIImageView *imgTickAll;
@property (weak, nonatomic) IBOutlet UIImageView *imgTickCur;

@property (weak, nonatomic) IBOutlet UIButton *btnAll;
@property (weak, nonatomic) IBOutlet UIButton *btnCurMerchant;
@end
