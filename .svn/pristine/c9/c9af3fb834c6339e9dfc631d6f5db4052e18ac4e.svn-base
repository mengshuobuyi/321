//
//  PhotoAlbumCell.m
//  AppFramework
//
//  Created by Yan Qingyang on 15/5/6.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//

#import "PhotoAlbumCell.h"

@implementation PhotoAlbumCell
- (void)UIGlobal{
    self.btnSelect.backgroundColor=[UIColor clearColor];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self UIGlobal];
}

- (IBAction)selectAction:(id)sender{

//    [UIView animateWithDuration:0.25 animations:^{
//        self.btnSelect.transform = CGAffineTransformMakeScale(1.15, 1.15);
//    } completion:^(BOOL finished) {
//        self.btnSelect.transform = CGAffineTransformMakeScale(1.0, 1.0);
//    }];
    
    if ([self.delegate respondsToSelector:@selector(PhotoAlbumCellDelegate:)]) {
        [self.delegate PhotoAlbumCellDelegate:self];
    }
}

@end
