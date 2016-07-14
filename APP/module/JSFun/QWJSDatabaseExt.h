

#import "QWJSExtension.h"
#import <sqlite3.h>
/**
    JS 数据库接口
 */
@interface QWJSDatabaseExt : QWJSExtension
{
    NSString *jsCallbackId_;
    NSMutableDictionary *dbObjects;
}
@property (nonatomic, retain) NSString *jsCallbackId_;
///----------------------------------------------------------------------
/// 数据库操作
///----------------------------------------------------------------------

/**
    加入数据，可以插入和更新
 */
- (void)addData:(NSArray *)arguments withDict:(NSDictionary *)options;

/**
    获取数据
 */
- (void)getData:(NSArray *)arguments withDict:(NSDictionary *)options;

/**
    删除数据
 */
- (void)deleteData:(NSArray *)arguments withDict:(NSDictionary *)options;

/**
    更新数据
 */
- (void)updateData:(NSArray *)arguments withDict:(NSDictionary *)options;

///----------------------------------------------------------------------
/// 自定义数据库
///----------------------------------------------------------------------

/**
    创建数据库，并打开
 */
// 下面三个方法用来执行与自定义数据库相关的操作
- (void)open:(NSArray *)arguments withDict:(NSDictionary *)options;

/**
    关闭数据库
 */
- (void)close:(NSArray *)arguments withDict:(NSDictionary *)options;

/**
    执行SQL语句
 */
- (void)exec:(NSArray *)arguments withDict:(NSDictionary *)options;

@end
