#import <Foundation/Foundation.h>
#import "QWError.h"
#import "uploadFile.h"

#define  HttpClientMgr [HttpClient sharedInstance]

typedef void (^SuccessBlock)(id resultObj);
typedef void (^FailureBlock)(NSError *error);
typedef void (^SuccessBlockIndex)(id resultObj,NSUInteger index);
typedef void (^FailureBlockIndex)(NSError *error,NSUInteger index);
@interface HttpException : QWError
@property (nonatomic, strong) NSString *UUID;

@end
@class AFHTTPSessionManager;
@interface HttpClient : NSObject
@property (assign) BOOL progressEnabled;
@property (nonatomic ,strong) NSString *requestType;

@property (readwrite, nonatomic, strong) AFHTTPSessionManager *client;
+ (instancetype)sharedInstance;

- (NSDictionary *)secretBuild:(NSDictionary *)dataSource;
- (NSDictionary *)secretBuild:(NSDictionary *)dataSource withVersion:(NSString *)version;

- (void)setBaseUrl:(NSString *)baseUrl;

- (void)setCookie:(NSString *)cookie;
- (void)CutomGet:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure;

- (void)CutomTwiceGet:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure;
- (void)get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure;
- (void)post:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure;

///* 不显示菊花 */
- (void)getWithoutProgress:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure;
- (void)postWithoutProgress:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure;

- (void)getRaw:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure;
- (void)getRawWithoutProgress:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure;

-(void)uploaderImg:(NSMutableArray *)imageDataArr  params:(NSDictionary *)params withUrl:(NSString *)imagUrl success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure  uploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))uploadProgressBlock;

-(void)upRawFile:(NSMutableArray *)imageDataArr  params:(NSDictionary *)params withUrl:(NSString *)uploadUrl success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure  uploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))uploadProgressBlock;

//上传错误日志文件,支持数组形式上传,MIME-type可能需要再处理一下
-(void)upLogFile:(NSMutableArray *)logDataArr filePaths:(NSMutableArray *)filePaths params:(NSDictionary *)params withUrl:(NSString *)uploadUrl success:(void(^)(NSString *path))success failure:(void(^)(HttpException * e))failure  uploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))uploadProgressBlock;

/**
 * 下载文件
 *
 * @param string aUrl 请求文件地址
 * @param string aSavePath 保存地址
 * @param string aFileName 文件名
 * @param String UUID标识
 */
- (void)downloadFileURL:(NSString *)aUrl
               savePath:(NSString *)aSavePath
               fileName:(NSString *)aFileName
                   UUID:(NSString *)UUID
                success:(void(^)(NSString *aSavePath))success
                failure:(void(^)(HttpException * e))failure
  downLoadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))downLoadProgressBlock;


- (void)put:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure;
- (void)putWithoutProgress:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure;

- (void)deleteR:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure;
- (void)deleteRWithoutProgress:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure;


-(void)patch:(NSString *)URLString parameters:(id)parameters   success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure;

/** 一次上传多张图片
 * add by Martin
 */
-(void)ma_uploaderImg:(NSMutableArray *)imageDataArr  params:(NSDictionary *)params withUrl:(NSString *)imagUrl success:(void(^)(NSMutableArray* uploadFileArray))success failure:(void(^)(HttpException * e))failure  uploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))uploadProgressBlock;

-(void)cancleLastRequest;
-(void)cancleAllRequest;
@end
