//
//  MAButtonWithTouchBlock.h
//  APP
//
//  Created by Martin.Liu on 15/12/7.
//  Copyright © 2015年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAButtonWithTouchBlock : UIButton
@property (nonatomic, copy) void (^touchUpInsideBlock)();
@property (nonatomic, copy) void (^longTouchUpInsideBlock)();
@end
