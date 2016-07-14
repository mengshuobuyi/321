//
//  NutritionTempletView.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/4/12.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NutritionTempletView : UIView


@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *templetImageView;

@property (weak, nonatomic) IBOutlet UIButton *hiddenButton;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *templet_layout_height;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button_layout_top;




- (IBAction)hiddenAction:(id)sender;

+ (NutritionTempletView *)sharedManagerWithImage:(NSString *)imageName type:(int)type;

-(void)show;

-(void)hidden;


@end
