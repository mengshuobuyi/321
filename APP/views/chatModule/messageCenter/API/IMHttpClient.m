//
//  IMHttpClient.m
//  APP
//
//  Created by Yan Qingyang on 15/5/25.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "IMHttpClient.h"

@interface IMHttpClient()
{

}
@end

@implementation IMHttpClient

#pragma mark - init
+ (instancetype)instance {
    static IMHttpClient *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[IMHttpClient alloc]init];
    });
    
    
    return _sharedInstance;
}

-(id)init
{
    if (self == [super init]) {
        self.request=[[HttpClient alloc]init];
        //cj----cj
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        NSString *apiUrl = [def objectForKey:@"APIDOMAIN"];
        NSString *h5Url = [def objectForKey:@"H5DOMAIN"];
        if(apiUrl&&![apiUrl isEqualToString:@""]){
            [self.request setBaseUrl:apiUrl];
        }else{
            [self.request setBaseUrl:BASE_URL_V2];
        }
        return self;
    }
    return nil;
}

#pragma mark -

@end
