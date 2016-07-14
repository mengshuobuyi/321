

#import "QWJSExtension.h"

@interface QWJSLoginExt : QWJSExtension{
    
    NSString                    *jsCallbackId_;
}
@property (nonatomic, retain) NSString *jsCallbackId_;


/*
 调登陆界面
*/

- (void)calloutLoginVC:(NSArray *)arguments withDict:(NSDictionary *)options;

- (void)calloutLijianTest:(NSArray *)arguments withDict:(NSDictionary *)options;


@end