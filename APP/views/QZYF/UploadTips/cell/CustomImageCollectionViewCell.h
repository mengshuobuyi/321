//
//  CustomImageCollectionViewCell.h
//  APP
//
//  Created by PerryChen on 8/18/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomImageCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgContent;
@property (weak, nonatomic) IBOutlet UIButton *btnDelPhoto;
@property (weak, nonatomic) IBOutlet UIButton *btnShowPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *deleimage;

@end
