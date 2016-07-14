//
//  PhotoPreView.h
//  AppFramework
//
//  Created by Yan Qingyang on 15/5/6.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//

#import "PhotoViewer.h"

typedef void (^PhotoPreViewSelectBlock)(NSInteger oid);

@interface PhotoPreView : PhotoViewer
@property (assign) BOOL dontSave;
@property (assign) BOOL toSelection;
@property (nonatomic, copy, readwrite)  PhotoPreViewSelectBlock blockSelect;
@end
