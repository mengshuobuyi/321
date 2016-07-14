//
//  ConfigureModel.m
//  APP
//
//  Created by qw on 15/3/4.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

@synthesize userToken;
@synthesize passportId;
@synthesize userName;
@synthesize passWord;
@synthesize nickName;
@synthesize avatarUrl;
@synthesize groupId;
@synthesize type;
@synthesize shortName;
@synthesize approveStatus;
@synthesize expertToken;
@synthesize expertPassportId;
@synthesize expertNickName;
@synthesize expertUserName;
@synthesize expertAvatarUrl;
@synthesize expertMobile;
@synthesize expertType;
@synthesize expertAuthStatus;
@synthesize lastTimestamp;

- (id)init
{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    self.userToken = @"";
    self.passportId = @"";
    self.userName = @"";
    self.passWord = @"";
    self.nickName = @"";
    self.avatarUrl = @"";
    self.groupId = @"";
    
    return self;
}

@end


@implementation UserInfoModelPrivate

@synthesize userToken;
@synthesize passPort;
@synthesize userName;
@synthesize passWord;
@synthesize nickName;
@synthesize avatarUrl;

- (id)init
{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    self.userToken = @"";
    self.passPort = @"";
    self.userName = @"";
    self.passWord = @"";
    self.nickName = @"";
    self.avatarUrl = @"";
    
    return self;
}

@end



@implementation RegisterAreaInfoModel

@synthesize city;
@synthesize country;
@synthesize province;

@end


@implementation UserTaskScoreModel
+ (NSString *)getPrimaryKey
{
    return @"passPort";
}
@end
