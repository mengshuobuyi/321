//
//  Version.h
//  APP
//  版本更新相关属性
//  Created by qw on 15/2/22.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseAPIModel.h"

@interface Version : BaseAPIModel
@property (nonatomic,strong) NSString*         downloadUrl;
//@property (nonatomic,strong) NSString*         id;
@property (nonatomic,strong) NSString*         size;
//@property (nonatomic,strong) NSString*         status;
//@property (nonatomic,strong) NSString*         type;
//@property (nonatomic,strong) NSString*         updateInstall;
//@property (nonatomic,strong) NSString*         updateLog;
//@property (nonatomic,strong) NSString*         updateTime;
//@property (nonatomic,strong) NSString*         versionName;
//@property (nonatomic,strong) NSString*         versionNo;
//@property (nonatomic,strong) NSString*         versionType;

@property (nonatomic, strong) NSString *        version;
@property (nonatomic, strong) NSString *        note;
@property (nonatomic, strong) NSString *        compel;
@end
