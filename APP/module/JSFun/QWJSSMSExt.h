

#import "QWJSExtension.h"
#import <MessageUI/MFMessageComposeViewController.h>

/**
    JS 的 短信接口
 */

@interface QWJSSMSExt : QWJSExtension <MFMessageComposeViewControllerDelegate>
{
    NSString                    *jsCallbackId_;
    MFMessageComposeViewController *messageController_;
}
@property (nonatomic, copy) NSString *jsCallbackId_;

/**
    调用发送短信功能，并显示短信页面
 */
- (void)send:(NSArray *)arguments withDict:(NSDictionary *)options;

@end
