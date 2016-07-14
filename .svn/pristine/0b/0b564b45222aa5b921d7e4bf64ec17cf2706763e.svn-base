//
//  LevelUpAlertView.m
//  wenYao-store
//
//  Created by qw_imac on 16/5/18.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "LevelUpAlertView.h"

@implementation LevelUpAlertView
-(void)awakeFromNib {
    _bottomView.layer.cornerRadius = 10.0;
    _bottomView.layer.masksToBounds = YES;    
}

-(void)setAlertView:(NSString *)nick With:(NSString *)lvlName And:(NSInteger)lvl {
    _nick.text = [NSString stringWithFormat:@"亲爱的%@:",nick];
    if (lvl != 6) {
        _info.text = [NSString stringWithFormat:@"您已成为%@！\n想达到顶级，要一直保持哦~",lvlName];
        _message.text = [NSString stringWithFormat:@"再接再厉，\n升级享更多特权哦！"];
    }else {
        _info.text = [NSString stringWithFormat:@"您已成为%@!",lvlName];
        _message.text = [NSString stringWithFormat:@"会当凌绝顶  一览众山小，\n你是最棒的！"];
    }
    NSString *imgName;
    switch (lvl) {
        case 1:
            imgName = @"my_img_level_one";
            break;
        case 2:
            imgName = @"my_img_level_two";
            break;
        case 3:
            imgName = @"my_img_level_three";
            break;
        case 4:
            imgName = @"my_img_level_four";
            break;
        case 5:
            imgName = @"my_img_level_five";
            break;
        case 6:
            imgName = @"my_img_level_six";
            break;
    }
    _lvlImg.image = [UIImage imageNamed:imgName];
}

- (IBAction)removeAction:(UIButton *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        _bgView.alpha = 0.0;
        _contentView.hidden = YES;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
