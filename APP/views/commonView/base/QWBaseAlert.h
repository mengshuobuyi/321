//
//  QWBaseAlert.h
//  APP
//
//  Created by Yan Qingyang on 15/8/25.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAlertDur 0.35

typedef void (^AlertSelectedBlock)(int tag, id obj);

@interface QWBaseAlert : UIView
{
    IBOutlet UIView *vBG,*vBtns;
    IBOutlet UIButton *btn0,*btn1;
}
@property (nonatomic,copy,readwrite) AlertSelectedBlock selectedBlock;
@property (nonatomic, assign) UIView *mainView;
//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color;
- (void)addToWindow;
- (void)UIGlobal;
- (void)removeAlert;
- (void)close:(int)tag;
- (void)show;
- (void)show:(id)obj block:(AlertSelectedBlock)block;
- (void)showNormal:(id)obj block:(AlertSelectedBlock)block;
- (void)UIInit;
- (IBAction)clickAction:(id)sender;
@end
