

#import "QWJSExtension.h"
#import <AVFoundation/AVAudioPlayer.h>

@interface QWJSAudioExt : QWJSExtension
{
    NSString                    *jsCallbackId_;
    
    NSMutableDictionary*        soundCache;
}
@property (nonatomic, copy) NSString *jsCallbackId_;

- (void)load:(NSArray *)arguments withDict:(NSDictionary *)options;
- (void)dispose:(NSArray *)arguments withDict:(NSDictionary *)options;
- (void)play:(NSArray *)arguments withDict:(NSDictionary *)options;
- (void)stop:(NSArray *)arguments withDict:(NSDictionary *)options;
- (void)pause:(NSArray *)arguments withDict:(NSDictionary *)options;
- (void)resume:(NSArray *)arguments withDict:(NSDictionary *)options;
- (void)getMaxVolume:(NSArray *)arguments withDict:(NSDictionary *)options;
- (void)getMinVolume:(NSArray *)arguments withDict:(NSDictionary *)options;
- (void)getVolume:(NSArray *)arguments withDict:(NSDictionary *)options;
- (void)setVolume:(NSArray *)arguments withDict:(NSDictionary *)options;
@end
