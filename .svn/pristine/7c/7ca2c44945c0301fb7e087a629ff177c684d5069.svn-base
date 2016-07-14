#import "SystemMacro.h"
#import "Login.h"
#import "HttpClient.h"
#import "SystemMacro.h"
#import "BodyModel.h"
#import "DemoModel.h"
#import "Constant.h"
#import "mbr.h"

@interface Login()
@end

@implementation Login


+ (void)loginwithPhoneNumber:(NSString *)phoneNum andPassword:(NSString *)password success:(void (^)(id))success failure:(void (^)(HttpException *))failure
{
    mbrLogin *parm=[mbrLogin new];
    parm.account=phoneNum;
    parm.password=password;
    parm.deviceCode=@"12345";
    parm.device=@"2";
    
//    NSDictionary *dd=@{@"account":phoneNum,
//                       @"password":password,
//                       @"deviceCode":@"12345",
//                       @"device":@"2"};
    
    [[HttpClient sharedInstance] post:NW_login params:[parm dictionaryModel] success:^(id responseObj) {
        
        DebugLog(@"responseObj===>%@",responseObj);
        //modify by qingyang
//        GLOBALMANAGER.body =[BodyModel parse:responseObj ];
        mbrUser *body=[mbrUser parse:responseObj ];
//                                                            BodyModel *body =[BodyModel parse:responseObj ];
        


        if (success) {
            success(body);
//            success(GLOBALMANAGER.body);
            //modify end
        }
    } failure:^(HttpException *e) {
        DebugLog(@"%@",e);
        if (failure) {
            failure(e);
        }
    }];
 
}

@end
