//
//  XMPPManager.m
//  iPhoneXMPP
//
//  Created by xiezhenghong on 14-3-9.
//
//

#import "XMPPManager.h"
#import "GCDAsyncSocket.h"
#import "XMPP.h"
#import "XMPPReconnect.h"
#import "XMPPCapabilitiesCoreDataStorage.h"

#import "XMPPRoomCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"

#import "DDLog.h"
#import "DDTTYLogger.h"

#import "NSData+XMPP.h"
#include "Constant.h"
#import "XMPPMessage+XEP0045.h"

#import "XHMessage.h"
#import "NSString+MD5HexDigest.h"
#import "XHAudioPlayerHelper.h"
#import "SBJson.h"

#import "css.h"
#import "QWGlobalManager.h"
#import "Mbr.h"
#import "Constant.h"
#import "QWMessage.h"

#import "QWGlobalManager.h"
#import "IMApi.h"

#if DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

@interface XMPPManager()

@end


@implementation XMPPManager
@synthesize xmppStream;
@synthesize xmppReconnect;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppvCardTempModule;
@synthesize xmppvCardAvatarModule;
@synthesize xmppCapabilities;
@synthesize xmppCapabilitiesStorage;

@synthesize rooms;

static XMPPManager      *shareXMPPManager = nil;

+ (XMPPManager*)sharedInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        shareXMPPManager = [[XMPPManager alloc] init];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
    });
    return shareXMPPManager;
}

-(id)init
{
    self = [super init];
    if(self)
    {

    }
    return self;
}

//初始化xmpp流
- (void)setupStream
{
	NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
	xmppStream = [[XMPPStream alloc] init];
	
#if !TARGET_IPHONE_SIMULATOR
	{
		// Want xmpp to run in the background?
		//
		// P.S. - The simulator doesn't support backgrounding yet.
		//        When you try to set the associated property on the simulator, it simply fails.
		//        And when you background an app on the simulator,
		//        it just queues network traffic til the app is foregrounded again.
		//        We are patiently waiting for a fix from Apple.
		//        If you do enableBackgroundingOnSocket on the simulator,
		//        you will simply see an error message from the xmpp stack when it fails to set the property.
		
		xmppStream.enableBackgroundingOnSocket = YES;
	}
#endif
	
	// Setup reconnect
	//
	// The XMPPReconnect module monitors for "accidental disconnections" and
	// automatically reconnects the stream for you.
	// There's a bunch more information in the XMPPReconnect header file.
	
	xmppReconnect = [[XMPPReconnect alloc] init];
	
	//xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    //	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] initWithInMemoryStore];
	
	//xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
	
	//xmppRoster.autoFetchRoster = YES;
	//xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
	
	// Setup vCard support
	//
	// The vCard Avatar module works in conjuction with the standard vCard Temp module to download user avatars.
	// The XMPPRoster will automatically integrate with XMPPvCardAvatarModule to cache roster photos in the roster.
	
	//xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
	//xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
	
	//xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
    //xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    //xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];
    
    //xmppCapabilities.autoFetchHashedCapabilities = YES;
    //xmppCapabilities.autoFetchNonHashedCapabilities = NO;

	// Activate xmpp modules
    
//	[xmppReconnect         activate:xmppStream];
//	[xmppRoster            activate:xmppStream];
//	[xmppvCardTempModule   activate:xmppStream];
//	[xmppvCardAvatarModule activate:xmppStream];
//	[xmppCapabilities      activate:xmppStream];
    
	// Add ourself as a delegate to anything we may be interested in
    
	[xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
//	[xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
//    [xmppvCardAvatarModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    rooms = [NSMutableArray arrayWithCapacity:15];
    _UUIDList = [NSMutableArray arrayWithCapacity:15];
    _taskLock = [[NSCondition alloc] init];
	// You may need to alter these settings depending on the server you're connecting to
	allowSelfSignedCertificates = NO;
	allowSSLHostNameMismatch = NO;
}



//关闭xmpp流
- (void)teardownStream
{
	[xmppStream removeDelegate:self];
	[xmppRoster removeDelegate:self];
	
	[xmppReconnect         deactivate];
	[xmppRoster            deactivate];
	[xmppvCardTempModule   deactivate];
	[xmppvCardAvatarModule deactivate];
	[xmppCapabilities      deactivate];
	
	[xmppStream disconnect];
	
	xmppStream = nil;
	xmppReconnect = nil;
    xmppRoster = nil;
	xmppRosterStorage = nil;
	xmppvCardStorage = nil;
    xmppvCardTempModule = nil;
	xmppvCardAvatarModule = nil;
	xmppCapabilities = nil;
	xmppCapabilitiesStorage = nil;
}

- (NSManagedObjectContext *)managedObjectContext_roster
{
	return [xmppRosterStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_capabilities
{
	return [xmppCapabilitiesStorage mainThreadManagedObjectContext];
}

//上线
- (void)goOnline
{
	XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
    
    NSString *domain = [xmppStream.myJID domain];
    
    //Google set their presence priority to 24, so we do the same to be compatible.
    
    if([domain isEqualToString:@"gmail.com"]
       || [domain isEqualToString:@"gtalk.com"]
       || [domain isEqualToString:@"talk.google.com"])
    {
        NSXMLElement *priority = [NSXMLElement elementWithName:@"priority" stringValue:@"24"];
        [presence addChild:priority];
    }
	
	[[self xmppStream] sendElement:presence];
}

//下线
- (void)goOffline
{
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	
	[[self xmppStream] sendElement:presence];
}

//利用用户名以及密码登陆,用户名需要携带@domain,示例 ceshi1@221.224.87.98
- (BOOL)connectWithUserName:(NSString *)myJID Password:(NSString *)myPassword
{
	if (![xmppStream isDisconnected]) {
		return YES;
	}

	if (myJID == nil || myPassword == nil) {
		return NO;
	}
    
	[xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
	password = myPassword;
    
	NSError *error = nil;
	if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
		                                                    message:@"See console for error details."
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Ok"
		                                          otherButtonTitles:nil];
		[alertView show];
		DDLogError(@"Error connecting: %@", error);
		return NO;
	}
    
	return YES;
}

//退出登陆
- (void)disconnect
{
	[self goOffline];
	[xmppStream disconnect];
}

- (void)dealloc
{
	[self teardownStream];
}

#pragma mark - XMPPStream Delegate
//xmpp流 连上服务器
- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (allowSelfSignedCertificates)
	{
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	if (allowSSLHostNameMismatch)
	{
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	}
	else
	{
		NSString *expectedCertName = [xmppStream.myJID domain];
        
		if (expectedCertName)
		{
			[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
		}
	}
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (NSString *)encryptPassword:(NSString *)passwd
{
    NSString *encryPasswd = [NSString stringWithFormat:@"quanwei%@quanwei",passwd];
    return [encryPasswd md5HexDigest];
}

//连接成功后,开始注册账号
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = QWGLOBALMANAGER.configure.userToken;
    
    //向服务器验证
    [Mbr tokenValidWithParams:param
                      success:^(BaseAPIModel *resultObj){
                          if([resultObj.apiStatus intValue] == 0){
                              NSString *passportId = QWGLOBALMANAGER.configure.passportId;
                              passportId = [self encryptPassword:passportId];
                              [xmppStream registerWithPassword:passportId error:nil];
                          }
                      }
                      failure:^(HttpException *e){
                      
                      }];
}

//注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
//    //使用注册的jid登录
    NSString *passportId = QWGLOBALMANAGER.configure.passportId;
    passportId = [self encryptPassword:passportId];
    [xmppStream authenticateWithPassword:passportId error:nil];
}

//用户名密码验证成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	[self goOnline];
}

//用户名密码验证不成功
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    //收到消息,插入数据库
    NSXMLElement *notification = [iq elementForName:@"notification"];
    if(notification && [[notification xmlns] isEqualToString:@"androidpn:iq:notification"])
    {
        //接受消息成功
        //播放声音
        QWMessage *msg = [[QWMessage alloc] init];
        
        msg.UUID = [[notification elementForName:@"id"] stringValue];
        msg.body = [[notification elementForName:@"message"] stringValue];
        msg.sendname = [[notification elementForName:@"fromUser"] stringValue];
        double timeStamp = [[notification elementForName:@"timestamp"] stringValueAsDouble] / 1000;
        msg.timestamp = [NSString stringWithFormat:@"%.0f",timeStamp];
        msg.avatorUrl = [[notification elementForName:@"uri"] stringValue];
        msg.star = [[notification elementForName:@"title"] stringValue];
        msg.richbody = [[notification elementForName:@"richBody"] stringValue];
        msg.isRead = @"0";
        msg.direction = [NSString stringWithFormat:@"%d",XHBubbleMessageTypeReceiving];
//        NSString *text = [[notification elementForName:@"message"] stringValue];

        if(!msg.richbody) {
            msg.richbody = @"";
        }
        NSUInteger messageType = [[notification elementForName:@"msType"] stringValueAsInt32];
        if(messageType == XHBubbleMessageMediaTypeQuitout)
        {
            [xmppReconnect deactivate];
            //自动退出账户
            [[NSNotificationCenter defaultCenter] postNotificationName:KICK_OFF object:nil];
            return YES;
        }

        XMPPJID *sendJid = [iq to];
        NSString *recvname = [sendJid user];
        
        NSString *UUID = [[notification elementForName:@"id"] stringValue];
        NSDictionary *UUIDDict = @{@"id":UUID,@"to":recvname};
        if(!msg.sendname || [msg.sendname isEqualToString:@""])
            return YES;
                if(messageType == XHBubbleMessageMediaTypeStarStore) {
            msg.star = @"5";
        }
        if (messageType == XHBubbleMessageMediaTypePhoto) {
            msg.richbody = [[notification elementForName:@"richBody"] stringValue];
            msg.body= @"[图片]";
        }
        if(messageType == XHBubbleMessageMediaTypeStarClient) {
            CGFloat starMark = [msg.star floatValue] / 2.0f;
            msg.star = [NSString stringWithFormat:@"%.1f",starMark];
        }
        msg.messagetype = [[notification elementForName:@"msType"] stringValue];
        msg.issend = [NSString stringWithFormat:@"%d",Sended];
        //保存到聊天列表
        msg.recvname = recvname;
        
        if(messageType == XHBubbleMessageMediaTypeActivity)
        {
             msg.body = msg.star;
        }
        
        [QWMessage saveObjToDB:msg];
        
        HistoryMessages *historymsg = [[HistoryMessages alloc] init];
        historymsg.relatedid = msg.sendname;
        historymsg.timestamp = msg.timestamp;
        historymsg.body = msg.body;
        historymsg.direction = msg.direction;
        historymsg.messagetype = msg.messagetype;
        historymsg.UUID = msg.UUID;
        historymsg.issend = msg.issend;
        historymsg.avatarurl = @"";
        //保存到历史列表
        HistoryMessages *originalMsg = [HistoryMessages getObjFromDBWithKey:msg.sendname];
        historymsg.nickname = originalMsg.nickname;
        historymsg.groupType = originalMsg.groupType;
        historymsg.groupId = originalMsg.groupId;
        historymsg.avatarurl = originalMsg.avatarurl;
        
        [HistoryMessages updateObjToDB:historymsg WithKey:historymsg.relatedid];
        
        [_taskLock lock];
        [self.UUIDList addObject:UUIDDict];
        [_taskLock unlock];
        
        [self performSelector:@selector(setIMReceived) withObject:nil afterDelay:2.0f];
    }else{
        double timeStamp = [[[iq attributeForName:@"time"] stringValue] doubleValue] / 1000;
        NSString *UUID = [[iq attributeForName:@"id"] stringValue];
        //更新Message的状态 先查再更新
        
        QWMessage* msg = [QWMessage getObjFromDBWithKey:UUID];
        msg.issend = [NSString stringWithFormat:@"%d",Sended];
        msg.timestamp = [NSString stringWithFormat:@"%.0f",timeStamp];
        [QWMessage updateObjToDB:msg WithKey:UUID];
    }
    return YES;
}

- (void)setIMReceived
{
    [_taskLock lock];
    if (self.UUIDList.count == 0)
    {
        [_taskLock unlock];
        return;
    }
    NSMutableArray *idArrays = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *toArrays = [NSMutableArray arrayWithCapacity:10];
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    for(NSDictionary *enumerate in self.UUIDList) {
        [idArrays addObject:enumerate[@"id"]];
        [toArrays addObject:enumerate[@"to"]];
    }
    
    setting[@"to"] = [toArrays componentsJoinedByString:SeparateStr];
    setting[@"id"] = [idArrays componentsJoinedByString:SeparateStr];
//    [QWGLOBALMANAGER updateUnreadCountBadge:0];

    [self.UUIDList removeAllObjects];
    [_taskLock unlock];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate date];
    localNotification.alertBody = @"你收到一条会话信息";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    [IMApi setReceivedWithParams:setting
                         success:^(id resultObj){
                         }
                         failure:^(HttpException *e){
                         }];
    [self.UUIDList removeAllObjects];
}



- (void)xmppStream:(XMPPStream *)sender didSendIQ:(XMPPIQ *)iq
{
    NSXMLElement *notification = [iq elementForName:@"notification"];
    if(notification && [[notification xmlns] isEqualToString:@"androidpn:iq:notification"])
    {
        //发送消息成功
        NSString *UUID = [[notification elementForName:@"id"] stringValue];
        //更新本地数据库
        double timeStamp = [[notification elementForName:@"timestamp"] stringValueAsDouble] / 1000;

        //更新消息状态
        QWMessage* msg = [QWMessage getObjFromDBWithKey:UUID];
        msg.issend = [NSString stringWithFormat:@"%d",Sended];
        msg.timestamp = [NSString stringWithFormat:@"%.0f",timeStamp];
        [QWMessage updateObjToDB:msg WithKey:UUID];
        
        HistoryMessages *historymsg = [[HistoryMessages alloc] init];
        historymsg.relatedid = msg.sendname;
        historymsg.timestamp = msg.timestamp;
        historymsg.body = msg.body;
        historymsg.direction = [NSString stringWithFormat:@"%ld",(long)XHBubbleMessageTypeSending];;
        historymsg.messagetype = msg.messagetype;
        historymsg.UUID = msg.UUID;
        historymsg.issend = msg.issend;
        historymsg.avatarurl = @"";
        
        HistoryMessages *originalMsg = [HistoryMessages getObjFromDBWithKey:msg.sendname];
        historymsg.nickname = originalMsg.nickname;
        historymsg.groupType = originalMsg.groupType;
        historymsg.groupId = originalMsg.groupId;
        historymsg.avatarurl = originalMsg.avatarurl;
        
        //保存到历史列表
        [HistoryMessages updateObjToDB:msg WithKey:historymsg.relatedid];
        
        [XHAudioPlayerHelper playMessageSentSound];
        
    }
}

//发送消息失败
- (void)xmppStream:(XMPPStream *)sender didFailToSendIQ:(XMPPIQ *)iq error:(NSError *)error
{
    NSXMLElement *notification = [iq elementForName:@"notification"];
    if(notification && [[notification xmlns] isEqualToString:@"androidpn:iq:notification"])
    {
        //发送消息失败
        NSString *UUID = [[notification elementForName:@"id"] stringValue];
        //更新本地数据库
        double timeStamp = [[notification elementForName:@"timestamp"] stringValueAsDouble] / 1000;
        
        QWMessage* msg = [QWMessage getObjFromDBWithKey:UUID];
        msg.issend = [NSString stringWithFormat:@"%d",Sended];
        msg.timestamp = [NSString stringWithFormat:@"%.0f",timeStamp];
        [QWMessage updateObjToDB:msg WithKey:UUID];
    }
}

- (void)xmppStream:(XMPPStream *)sender didSendPresence:(XMPPPresence *)presence
{
    if([[presence type] isEqualToString:@"subscribed"])
    {
        [xmppRoster fetchRoster];
    }
}

//发送消息成功
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{

}

//发送消息失败
- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error
{

}

//收到消息处理
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    
}

//成功收到消息后,解析此消息,根据我们自定义的xmpp流消息进行解析,分为语音,地理位置,图片,文本信息
- (void)handleReceiveMessage:(XMPPMessage *)message isGroupChat:(BOOL)isGroupChat
{
    
}


//收到好友请求后,插入到好友请求列表
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{

}

- (XMPPPresence *)xmppStream:(XMPPStream *)sender willReceivePresence:(XMPPPresence *)presence
{

    return presence;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (!isXmppConnected)
	{
		DDLogError(@"Unable to connect to server. Check xmppStream.hostName");
	}
}

#pragma mark XMPPRosterDelegate
//获取联系人列表,并插入数据库中
- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(NSXMLElement *)item
{
    
    
}

- (XMPPIQ *)xmppStream:(XMPPStream *)sender willReceiveIQ:(XMPPIQ *)iq
{
    return iq;
}


@end
