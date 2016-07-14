//
//  viewCustomAnimate.m
//  APP
//
//  Created by chenzhipeng on 4/21/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import "viewCustomAnimate.h"

@implementation viewCustomAnimate

- (void)didMoveToSuperview
{
    
}

- (void)awakeFromNib
{
    NSMutableArray *arrImgs = [@[] mutableCopy];
    for (int i = 0; i < 24; i++) {
        [arrImgs addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading_%d",i+1]]];
    }
    __weak viewCustomAnimate *weakSelf = self;
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^(void) {
        weakSelf.imgViewAnimate.animationImages = arrImgs;
        weakSelf.imgViewAnimate.animationDuration = 1.0;
        weakSelf.imgViewAnimate.animationRepeatCount = INT_MAX;
        [weakSelf.imgViewAnimate startAnimating];
    });
}

- (void)removeFromSuperview
{
    [self.imgViewAnimate stopAnimating];
}

/*
 

 
 
 
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
