 

#import "QWJSExtension.h"

/**
 
    JS 的 视频接口
 */

@interface QWJSVideoExt : QWJSExtension
{
    NSString                    *jsCallbackId_;
    
    NSMutableDictionary*        soundCache;

}
@property (nonatomic, copy) NSString *jsCallbackId_;

///------------------------------------------------------------------
/// @name Initialization & disposal
///------------------------------------------------------------------
/**
    加载视频
 */
- (void)load:(NSArray *)arguments withDict:(NSDictionary *)options;

/**
    释放视频对象
 */
- (void)dispose:(NSArray *)arguments withDict:(NSDictionary *)options;

///------------------------------------------------------------------
/// @name control
///------------------------------------------------------------------

/**
    播放视频
 */
- (void)play:(NSArray *)arguments withDict:(NSDictionary *)options;

/**
    停止
 */
- (void)stop:(NSArray *)arguments withDict:(NSDictionary *)options;

/**
    暂停
 */
- (void)pause:(NSArray *)arguments withDict:(NSDictionary *)options;

/**
    继续播放
 */
- (void)resume:(NSArray *)arguments withDict:(NSDictionary *)options;

@end
