//
//  PhotoModel.h
//  AppFramework
//
//  Created by Yan Qingyang on 15/5/4.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//

#import "BaseModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface PhotoModel : BaseModel

@property (assign) NSInteger photoMinSize;
@property (assign) BOOL fullEnabled;
@property (nonatomic,retain) NSString *url;//图片唯一id
@property (nonatomic,retain) UIImage *thumbnail;
@property (nonatomic,retain) UIImage *fullImage;
@property (nonatomic,retain) ALAsset *asset;
@property (assign) NSInteger sort;

// add by martin   发帖的时候用的，选择之后就上传到服务器，在block中赋值
@property (nonatomic,retain) NSString *imgURL;// 上传图片的url地址
@end
