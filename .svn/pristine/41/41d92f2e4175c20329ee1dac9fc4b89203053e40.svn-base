//
//  ContactServiceView.h
//  wenYao-store
//
//  Created by YYX on 15/8/19.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactServiceView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@property (weak, nonatomic) IBOutlet UIView *bg;

// 手机号
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

// qq 号
@property (weak, nonatomic) IBOutlet UILabel *qqLabel;

// 微信号
@property (weak, nonatomic) IBOutlet UILabel *wechatLabel;

// 取消按钮
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

// 点击拨号
- (IBAction)callAction:(id)sender;

// 点击复制qq
- (IBAction)copyQQAction:(id)sender;

// 点击复制微信
- (IBAction)copyWechatAction:(id)sender;

// 取消
- (IBAction)cancelAction:(id)sender;

+ (ContactServiceView *)sharedManager;

-(void)show;

-(void)hidden;

@end
