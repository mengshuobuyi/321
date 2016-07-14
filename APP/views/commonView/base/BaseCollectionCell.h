//
//  BaseCollectionCell.h
//  AppFramework
//
//  Created by Yan Qingyang on 15/6/3.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCollectionCell : UICollectionViewCell
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) id delegatePopVC;

+ (CGSize)getCellSize:(id)data;
- (void)setCell:(id)data;
- (void)UIGlobal;
@end
