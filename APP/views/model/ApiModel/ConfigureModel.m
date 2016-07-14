//
//  ConfigureModel.m
//  APP
//
//  Created by qw on 15/3/4.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "ConfigureModel.h"

@implementation ConfigureModel

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