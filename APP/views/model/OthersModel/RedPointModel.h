//
//  RedPointModel.h
//  wenYao-store
//
//  Created by Yan Qingyang on 15/6/10.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BasePrivateModel.h"

@interface RedPointModel : BasePrivateModel
@property (nonatomic, assign) BOOL hadMyConsult;
@property (nonatomic, assign) BOOL hadOtherConsult;
@property (nonatomic, assign) BOOL hadWaiting;
@property (nonatomic, assign) BOOL hadMessage;
@property (nonatomic, assign) BOOL hadNotice;

@property (nonatomic, assign) NSInteger numMyConsult;
@property (nonatomic, assign) NSInteger numOtherConsult;
@property (nonatomic, assign) NSInteger numWaiting;
@property (nonatomic, assign) NSInteger numMessage;
@property (nonatomic, assign) NSInteger numNotice;

@property (nonatomic, strong) NSString *UUID;
@end
