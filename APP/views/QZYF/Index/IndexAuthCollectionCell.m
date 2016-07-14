//
//  IndexAuthCollectionCell.m
//  wenYao-store
//
//  Created by YYX on 15/8/21.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "IndexAuthCollectionCell.h"

@implementation IndexAuthCollectionCell

- (void)awakeFromNib
{
    self.authButton.layer.cornerRadius = 4.0;
    self.authButton.layer.masksToBounds = YES;
}

// 立即认证

- (IBAction)authAction:(id)sender
{
    if (self.indexAuthCollectionCellDelegate && [self.indexAuthCollectionCellDelegate respondsToSelector:@selector(goToAuthAction)]) {
        [self.indexAuthCollectionCellDelegate goToAuthAction];
    }
}

@end
