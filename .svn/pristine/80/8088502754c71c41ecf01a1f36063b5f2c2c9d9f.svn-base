

#import "QWJSSMSExt.h"

#define SUCCESS 0
#define UNKNOWN_ERROR 1
#define OPEN_SMS_FAIL_ERROR 2


@implementation QWJSSMSExt
@synthesize jsCallbackId_;
//sms:send(phoneNum, content, callback)
- (void)send:(NSArray *)arguments withDict:(NSDictionary *)options
{
    NSString* callbackId = [arguments objectAtIndex:0];
    self.jsCallbackId_ = callbackId;
    NSString *_recipient = [arguments objectAtIndex:1];
    NSArray *_recipients = [NSArray arrayWithObject:_recipient];
    NSString *_body = [arguments objectAtIndex:2];

    NSString *urlStr = [NSString stringWithFormat:@"sms:%@",_recipient];
    NSURL *url = [NSURL URLWithString:urlStr];
    BOOL canOpenUrl = [[UIApplication sharedApplication] canOpenURL:url];
    if (canOpenUrl) {
        [[UIApplication sharedApplication] openURL:url];
        [self writeScript:self.jsCallbackId_ messageString:@"open sms successful" state:SUCCESS keepCallback:NO];
    }else {
        [self writeScript:self.jsCallbackId_ messageString:@"open sms fail" state:OPEN_SMS_FAIL_ERROR keepCallback:NO];
    }
}
 
#pragma mark ==== MFMessageComposeViewControllerDelegate ====
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [messageController_ dismissModalViewControllerAnimated:YES];
    [self writeScript:self.jsCallbackId_ message:@"null" state:0 keepCallback:NO];
}
@end
