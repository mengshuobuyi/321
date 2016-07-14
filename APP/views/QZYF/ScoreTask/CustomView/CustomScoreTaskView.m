//
//  CustomScoreTaskView.m
//  wenYao-store
//
//  Created by PerryChen on 6/15/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "CustomScoreTaskView.h"
#import "TaskScoreHeader.h"
@implementation CustomScoreTaskView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

// 点击取消
- (IBAction)actionDismiss:(id)sender {
    self.blockCancel();
    [self removeFromSuperview];
}

// 点击展示
- (IBAction)actionShow:(id)sender {
    self.blockConfirm(_modelScore.key);
    [self removeFromSuperview];
}

// 设置view 的内容
- (void)setViewContent
{
    if (_modelScore.score.intValue > 0) {
        // 展示加积分
        self.lblScore.hidden = NO;
        
    } else {
        self.lblScore.hidden = YES;
        self.lblScore.text = @"";
    }
//    if ((_modelScore.curStep == taskOne)||(_modelScore.curStep == taskThree)) {
//        // 展示加积分
//        self.lblScore.hidden = NO;
//    } else {
//        self.lblScore.hidden = YES;
//    }
    self.lblContent.text = _modelScore.desc;
    self.lblScore.text = [NSString stringWithFormat:@"+%@",_modelScore.score];
    [self layoutIfNeeded];
    [self setNeedsLayout];
}

// 设置model
- (void)setModelScore:(TaskScoreModel *)modelScore
{
    _modelScore = modelScore;
    [self setViewContent];
}

@end
