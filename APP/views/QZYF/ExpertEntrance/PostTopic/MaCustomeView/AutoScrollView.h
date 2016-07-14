//
//  AtuoScrollView.h
//  AutoScrollViewDemo
//
//  Created by 李坚 on 15/8/20.
//  Copyright (c) 2015年 李坚. All rights reserved.
//
#import "BaseAPIModel.h"
#import <UIKit/UIKit.h>

@protocol AutoScrollViewDelegate <NSObject>

- (void)didSelectedButtonAtIndex:(NSInteger)index;

@end

@interface AutoScrollView : UIView{
    
    NSTimer *myTime;
    UIButton *btn;
    int Acout;
}

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) id<AutoScrollViewDelegate>delegate;
@property (nonatomic, strong) UIColor *ButtonColor;
- (void)setupView;
- (void)setupNewView;

@end

/**
 *  药房跑马灯Model
 *  V3.0
 */
@interface BranchActivityNoticeVo : BaseAPIModel
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *title;
@end