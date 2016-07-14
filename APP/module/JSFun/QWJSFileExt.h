

#import "QWJSExtension.h"
/**
    JS 文件操作接口
 */
@interface QWJSFileExt : QWJSExtension{

    NSString                    *jsCallbackId_;
}
@property (nonatomic, retain) NSString *jsCallbackId_;

/**
    写入文件，该文件存储在 write-resources 文件目录中
 */
- (void)write:(NSArray *)arguments withDict:(NSDictionary *)options;

/**
    读取文件
 */
- (void)read:(NSArray *)arguments withDict:(NSDictionary *)options;

/**
    删除文件
 */
- (void)remove:(NSArray *)arguments withDict:(NSDictionary *)options;

/**
    检测文件是否存在
 */
- (void)isExist:(NSArray *)arguments withDict:(NSDictionary *)options;
@end
