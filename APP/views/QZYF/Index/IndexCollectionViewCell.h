//
//  IndexCollectionViewCell.h
//  wenYao-store
//
//  Created by YYX on 15/8/17.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndexCollectionViewCell : UICollectionViewCell

// 文字
@property (weak, nonatomic) IBOutlet UILabel *titleText;

// 图片
@property (weak, nonatomic) IBOutlet UIImageView *contentImage;

// 小红点
@property (weak, nonatomic) IBOutlet UILabel *redNumLabel;

@property (weak, nonatomic) IBOutlet UIImageView *redDot;

@end
