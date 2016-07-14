//
//  Address.h
//  wenYao-store
//
//  Created by qw_imac on 16/5/16.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecieveAddressModelR.h"
#import "RecieveAddressModel.h"
#import "HttpClient.h"
@interface Address : NSObject

//3.2查询收货地址列表
+(void)getAddressList:(RecieveAddressModelR *)params
              success:(void(^)(EmpAddressListVo *responseModel))success
              failure:(void(^)(HttpException *e))failure;


//3.2编辑收货地址列表
+(void)editAddress:(RecieveAddressEditR *)params
           success:(void(^)(EmpAddressVo *responseModel))success
           failure:(void(^)(HttpException *e))failure;


//3.2删除收货地址
+(void)removeAddress:(RemoveRecieveAddressR *)params
             success:(void(^)(RemoveAddressVo *responseModel))success
             failure:(void(^)(HttpException *e))failure;

@end
