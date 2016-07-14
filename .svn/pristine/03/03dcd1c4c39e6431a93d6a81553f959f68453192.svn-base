//
//  PhotoAlbumCell.h
//  AppFramework
//
//  Created by Yan Qingyang on 15/5/6.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PhotoAlbumCellDelegate;

@interface PhotoAlbumCell : UICollectionViewCell

@property (nonatomic, assign) id delegate;
@property (nonatomic,retain) IBOutlet UIImageView *imgPhoto;
@property (nonatomic,retain) IBOutlet UIButton *btnSelect;
@property (nonatomic,retain) NSString *url;
@property (assign) NSInteger index;
@end


@protocol PhotoAlbumCellDelegate <NSObject>
@optional
- (void)PhotoAlbumCellDelegate:(PhotoAlbumCell*)cell;
@end