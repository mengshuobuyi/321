//
//  ButtonsView.h
//  APP
//
//  Created by 李坚 on 15/8/25.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ButtonsViewDelegate <NSObject>

- (void)buttonDidSelected:(NSInteger)index;
- (void)buttonsViewHasRemoved;

@end

@interface ButtonsView : UIView{
    UIScrollView *btnView;
}

@property (nonatomic, assign) id<ButtonsViewDelegate>delegate;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) NSInteger selectIndex;

- (void)setButtons;

- (void)removeView;
@end
