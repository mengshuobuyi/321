//
//  PhotoViewer.h
//  AppFramework
//
//  Created by Yan Qingyang on 15/6/2.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//
#import "BaseCollectionCell.h"
#import "QWBaseVC.h"
#import "PhotoModel.h"
#import "PhotoAlbum.h"
#import "UIImageView+WebCache.h"
@protocol PhotoViewerDelegate;
@interface PhotoViewer : QWBaseVC

@property (nonatomic,assign) NSArray *arrPhotos;
@property (nonatomic,assign) NSMutableArray *arrSelected;
@property (nonatomic,assign) NSInteger maxPhotos;
@property (nonatomic,assign) NSInteger indexSelected;
@property (nonatomic,assign) PhotoAlbumBlock photosBlock;
@property (nonatomic,assign) BOOL barHide;
- (IBAction)closeAction:(id)sender;
#pragma mark init
- (void)dataInit;
- (void)show:(NSInteger)index;
#pragma mark 单击屏幕
- (void)oneTap;
- (void)saveImage:(UIImage*)photo;
- (void)checkSelected:(NSInteger)row;
- (void)loadPhotoForCell:(NSIndexPath *)indexPath;

- (void)barStatus;
- (NSUInteger)getCurIndex;
@end

@interface PhotoViewerCell : BaseCollectionCell

@property (nonatomic,retain) IBOutlet UIImageView *imgPhoto;

@end;

@protocol PhotoViewerDelegate <NSObject>
@optional
- (void)PhotoViewerDelegate:(PhotoViewerCell*)cell;
- (void)PhotoViewerSaveImage:(UIImage*)photo;
@end