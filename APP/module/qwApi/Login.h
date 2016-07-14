#import "HttpClient.h"
#import "DemoModel.h"

typedef enum OperationType{
    GetCodeTypeRegister = 1,
    GetCodeTypeBind = 2,
    GetCodeTypeForgetPassword = 3,
}GetCodeType;

@interface Login : NSObject
 

 


//4.4.6 手机号码登陆
+ (void)loginwithPhoneNumber:(NSString *)phoneNum
                 andPassword:(NSString *)password
                     success:(void(^)(id DFUserModel))success
                     failure:(void(^)(HttpException * e))failure;

@end

