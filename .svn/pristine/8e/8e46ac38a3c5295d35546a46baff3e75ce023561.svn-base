//
//  ProfessionTempletView.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/4/12.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfessionTempletView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *templetImageView;

@property (weak, nonatomic) IBOutlet UIButton *hiddenButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *templetImage_layout_height;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button_layout_top;


- (IBAction)hiddenAction:(id)sender;

+ (ProfessionTempletView *)sharedManagerWithIamge:(NSString *)imageName;

-(void)show;

-(void)hidden;

@end
