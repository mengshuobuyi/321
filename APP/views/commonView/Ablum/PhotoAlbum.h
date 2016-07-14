//
//  PhotoAlbum.h
//  AppFramework
//
//  Created by Yan Qingyang on 15/5/4.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//

#import "QWBaseVC.h"
#import "PhotoModel.h"

typedef void (^PhotoAlbumBlock)(NSMutableArray *list);

@interface PhotoAlbum : QWBaseVC

//选择图片
- (void)selectPhotos:(NSInteger)maxNum selected:(NSMutableArray*)list block:(PhotoAlbumBlock)block failure:(void(^)(NSError *error))failure;

//关闭相册
- (IBAction)closeAction:(id)sender;
@end
