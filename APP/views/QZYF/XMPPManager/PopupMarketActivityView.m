//
//  PopupMarketActivityView.m
//  wenyao-store
//
//  Created by xiezhenghong on 14-10-23.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "PopupMarketActivityView.h"
#import "UIImageView+WebCache.h"
#import "Constant.h"
static float kDur= .25f;
@implementation PopupMarketActivityView

//- (void)textFieldTextDidChange
//{
//    if(self.replyTextField.text.length > 50) {
//        self.replyTextField.text = [self.replyTextField.text substringToIndex:50];
//    }
//}

- (void)awakeFromNib
{
    self.replyTextField.delegate = self;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    [self.activityView addTarget:self action:@selector(hiddenKeyboard) forControlEvents:UIControlEventTouchDown];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.text.length >= 50 && ![string isEqualToString:@""]){
        return NO;
    }
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)setContent:(NSString *)content avatarUrl:(NSString *)avatarUrl
{
    self.contentLabel.text = content;
    CGRect rect = self.contentLabel.frame;
    if(avatarUrl) {
        [self.imageView setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"药品默认图片.png"]];
        self.imageView.hidden = NO;
        self.contentLabel.frame = CGRectMake(88, 22, 174, 70);
    }else{
        self.imageView.hidden = YES;
        self.contentLabel.frame = CGRectMake(8, 22, 254, 70);
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.hintTextFieldImage setImage:[UIImage imageNamed:@"输入框-输入.png"]];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    [self addSubview:self.activityView];
    
    CGFloat y = 0;
    if(HIGH_RESOLUTION) {
        y = 70;
    }else{
        y = 50;
    }
    
    CGFloat x = (50 * APP_W)/375;
    
    
    [self.activityView setFrame:CGRectMake(x, y, APP_W - x * 2, self.activityView.frame.size.height)];
    //    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    //    popAnimation.duration = 0.35;
    //    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
    //                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5f, 0.5f, 1.0f)],
    //                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2f, 1.2f, 1.0f)],
    //                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95f, 0.95f, 1.0f)],
    //                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
    //                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    //    popAnimation.keyTimes = @[@0.2f, @0.4f,@0.5f, @0.7f, @0.9f,@1.0f];
    //    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
    //                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
    //                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    //    [self.activityView.layer addAnimation:popAnimation forKey:nil];
    
    ///////////////////////
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    // 动画选项设定
    animation.duration = kDur; // 动画持续时间
    animation.repeatCount = 1; // 重复次数
    animation.autoreverses = NO; // 动画结束时执行逆动画
    
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:0.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:1.0]; // 结束时的倍率
    
    // 添加动画
    [self.activityView.layer addAnimation:animation forKey:@"scale-layer"];
}

- (void)dismissView
{
//    CAKeyframeAnimation *hideAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    hideAnimation.duration = 0.35;
//    hideAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
//                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3f, 1.3f, 1.0f)],
//                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
//                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5f, 0.5f, 1.0f)],
//                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.00f, 0.00f, 0.00f)]];
//    hideAnimation.keyTimes = @[@0.2f, @0.4f,@0.6f, @0.8f, @1.0f];
//    hideAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
//                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
//                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
//                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    hideAnimation.delegate = self;
//    hideAnimation.autoreverses = NO;
//    [self.activityView.layer addAnimation:hideAnimation forKey:nil];
    
    ///////////////////////
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    // 动画选项设定
    animation.duration = kDur; // 动画持续时间
    animation.repeatCount = 1; // 重复次数
    animation.autoreverses = NO; // 动画结束时执行逆动画
    
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:0.0]; // 结束时的倍率
    animation.delegate=self;
    
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    // 添加动画
    [self.activityView.layer addAnimation:animation forKey:@"scale-layer"];
    
//    [UIView animateWithDuration:kDur animations:^{
// 
//    } completion:^(BOOL finished) {
//        [self.activityView removeFromSuperview];
//        [self removeFromSuperview];
    //    }];
    self.replyTextField.text = @"";
}

- (void)hiddenKeyboard
{
    [self.replyTextField resignFirstResponder];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.activityView removeFromSuperview];
    [self removeFromSuperview];
}

#pragma mark - TouchTouchTouch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hiddenKeyboard];
}

- (IBAction)cancelActivity:(id)sender
{
    [self dismissView];
}

- (IBAction)sendActivity:(id)sender
{
    [self hiddenKeyboard];
    if([self.delegate respondsToSelector:@selector(didSendMarketActivityWithDict:)])
    {
        if(self.replyTextField.text.length > 0)
            self.infoDict[@"replyText"] = self.replyTextField.text;
        else
            [self.infoDict removeObjectForKey:@"replyText"];
        
        [self.delegate didSendMarketActivityWithDict:self.infoDict];
    }
    [self dismissView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
