//
//  AtuoScrollView.m
//  AutoScrollViewDemo
//
//  Created by 李坚 on 15/8/20.
//  Copyright (c) 2015年 李坚. All rights reserved.
//

#import "AutoScrollView.h"
#import "ActivityModel.h"
//#import "ConsultStoreModel.h"
@implementation AutoScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        self.clipsToBounds = YES;
        
        
    }
    return self;
}

- (void)setupView{
    [btn removeFromSuperview];
    btn = nil;
    [myTime invalidate];
    myTime = nil;
    if(self.dataArray == nil || self.dataArray.count == 0){
        return;
    }
    
    Acout = 0;
    BranchActivityVo *model = self.dataArray[Acout];
    
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(0, (self.frame.size.height - 21)/2, self.frame.size.width, 21);
    [btn addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = Acout;
    btn.backgroundColor = [UIColor clearColor];
    btn.titleLabel.font = fontSystem(kFontS4);

    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [btn setTitle:model.title forState:UIControlStateNormal];
    if(_ButtonColor){
        [btn setTitleColor:_ButtonColor forState:UIControlStateNormal];
    }else{
        [btn setTitleColor:RGBHex(qwColor2) forState:UIControlStateNormal];
    }
//    btn.backgroundColor = [UIColor greenColor];
    [self addSubview:btn];
    
    [self AutoScrollStart];
}

- (void)setupNewView{
    [btn removeFromSuperview];
    btn = nil;
    [myTime invalidate];
    myTime = nil;

    if(self.dataArray == nil || self.dataArray.count == 0){
        [btn removeFromSuperview];
        return;
    }
    
    Acout = 0;
    BranchActivityNoticeVo *model = self.dataArray[Acout];
    
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(0, (self.frame.size.height - 21)/2, self.frame.size.width, 21);
    [btn addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = Acout;
    btn.backgroundColor = [UIColor clearColor];
    btn.titleLabel.font = fontSystem(kFontS4);
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [btn setTitle:model.title forState:UIControlStateNormal];
    if(_ButtonColor){
        [btn setTitleColor:_ButtonColor forState:UIControlStateNormal];
    }else{
        [btn setTitleColor:RGBHex(qwColor2) forState:UIControlStateNormal];
    }
    //    btn.backgroundColor = [UIColor greenColor];
    [self addSubview:btn];
    
    [self AutoScrollStart];
}


- (void)AutoScrollStart{
    
    myTime = [NSTimer timerWithTimeInterval:3.0  target:self selector:@selector(loop) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop]addTimer:myTime forMode:NSDefaultRunLoopMode];
}

- (void)loop{
    
    
    [UIView animateWithDuration:0.5f animations:^{
        
        CGRect downRect = btn.frame;
        downRect.origin.y = 0 - btn.frame.size.height;
        btn.frame = downRect;
        
    } completion:^(BOOL finished) {
        
        if(++ Acout == self.dataArray.count){
            Acout = 0;
        }
        BranchActivityVo *model = self.dataArray[Acout];
        [btn setTitle:model.title forState:UIControlStateNormal];
        btn.tag = Acout;
        
        CGRect downRect = btn.frame;
        downRect.origin.y = self.frame.size.height;
        btn.frame = downRect;
        [UIView animateWithDuration:0.5f animations:^{
            
            CGRect downRect = btn.frame;
            downRect.origin.y = (self.frame.size.height - 21)/2;
            btn.frame = downRect;
            
        } completion:^(BOOL finished) {
            
        }];
    }];
    
    
}

- (void)didClickButton:(UIButton *)btn{
    
    if(self.delegate){
        [self.delegate didSelectedButtonAtIndex:btn.tag];
    }
    
}


- (void)removeFromSuperview{
    [super removeFromSuperview];
    
    [myTime invalidate];
    
}

@end
@implementation BranchActivityNoticeVo

@end