//
//  PhotoAlbumList.h
//  AppFramework
//
//  Created by Yan Qingyang on 15/5/4.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//

#import "QWBaseVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
typedef void (^PhotoAlbumListSelectedBlock)(ALAssetsGroup *grp);

@interface PhotoAlbumList : QWBaseVC

//相册
@property (nonatomic, retain) NSArray *arrGroups;

- (void)showList:(NSArray*)list block:(PhotoAlbumListSelectedBlock)block;
@end
