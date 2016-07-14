//
//  ButtonsView.m
//  APP
//
//  Created by 李坚 on 15/8/25.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "ButtonsView.h"

@implementation ButtonsView


- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        UIView *bKView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_W, APP_H)];
        bKView.backgroundColor = [UIColor blackColor];
        bKView.alpha = 0.5;
        [self addSubview:bKView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView)];
        [bKView addGestureRecognizer:tap];
        
    }
    return self;
}



- (void)setButtons{
    
    
    [btnView removeFromSuperview];
    btnView = nil;
    
    btnView = [[UIScrollView alloc]init];
    btnView.backgroundColor = [UIColor whiteColor];
    
    int count = 1;
    float btnX = 11;
    float btnY = 16;
    
    for (NSString *str in self.dataArray) {
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(btnX, btnY, (APP_W - 40) / 4, 39)];
        button.titleLabel.font = fontSystem(kFontS5);
        button.titleLabel.numberOfLines = 0;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:str forState:UIControlStateNormal];
        [button setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = 0.5f;
        button.layer.borderColor = RGBHex(qwColor10).CGColor;
        button.layer.cornerRadius = 3.0f;
        button.tag = count;
        if(count - 1 == self.selectIndex){
            [button setBackgroundColor:RGBHex(qwColor1)];
            [button setTitleColor:RGBHex(qwColor4) forState:UIControlStateNormal];
        }else{
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
        }
        
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:button];
        
        btnX += 6 + (APP_W - 40) / 4;
        
        if(count % 4 == 0){
            btnY += 48;
            btnX = 11;
        }
        
        count ++;
    }
    
    btnY += 47;
    if(btnY + 47 > 163){
        btnView.frame = CGRectMake(0, 0, APP_W, 163);
    }else{
        btnView.frame = CGRectMake(0, 0, APP_W, btnY + 8);
    }
    btnView.contentSize = CGSizeMake(APP_W, btnY + 8);
    
    [self addSubview:btnView];
    
}

- (void)btnClick:(UIButton *)btn{
    
    [self removeView];
    if(self.delegate){
        [self.delegate buttonDidSelected:(btn.tag - 1)];
    }
}

- (void)removeView{
    
    if(self.alpha == 1){
        [UIView animateWithDuration:0.4 animations:^{
            self.alpha = 0;
        }completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
    if(self.delegate){
        [self.delegate buttonsViewHasRemoved];
    }
    
}

@end
