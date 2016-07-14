//
//  LevelCollectionViewCell.h
//  wenYao-store
//
//  Created by qw_imac on 16/5/5.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LevelCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *nickImg;
@property (weak, nonatomic) IBOutlet UILabel *memberLevel;
@property (weak, nonatomic) IBOutlet UIImageView *showImg;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;

@end
