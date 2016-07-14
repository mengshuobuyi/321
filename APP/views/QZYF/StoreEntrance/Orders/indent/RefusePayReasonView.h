//
//  RefusePayReasonView.h
//  wenYao-store
//
//  Created by qw_imac on 16/1/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefusePayReasonView : UIView
@property (weak, nonatomic) IBOutlet UIView *bkView;
@property (weak, nonatomic) IBOutlet UIView *reasonView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *confireBtn;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UILabel *title;
+(RefusePayReasonView *)refuseView;
-(void)removeSelf;
@end
