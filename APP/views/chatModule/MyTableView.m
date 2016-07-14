//
//  MyTableView.m
//  APP
//
//  Created by PerryChen on 7/23/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import "MyTableView.h"

@implementation MyTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setContentSize:(CGSize)contentSize {
    // I don't want move the table view during its initial loading of content.
    if (!CGSizeEqualToSize(self.contentSize, CGSizeZero)) {
        if (contentSize.height > self.contentSize.height) {
            CGPoint offset = self.contentOffset;
            offset.y += (contentSize.height - self.contentSize.height);
            self.contentOffset = offset;
        }
    }
    [super setContentSize:contentSize];
}


@end
