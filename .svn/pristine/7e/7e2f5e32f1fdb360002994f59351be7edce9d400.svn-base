//
//  XMPPIQ+XMPPIQ_Message.m
//  wenyao-store
//
//  Created by xiezhenghong on 14-10-8.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "XMPPIQ+XMPPMessage.h"
#import "NSXMLElement+XMPP.h"
#import "XHMessage.h"
#import "Appdelegate.h"
#import "Constant.h"


@implementation XMPPIQ (Message)

+ (XMPPIQ *)messageTypeWithText:(NSString *)plainText
                         withTo:(NSString *)toJid
                      avatarUrl:(NSString *)avatarUrl
                           from:(NSString *)fromName
                      timestamp:(double)timestamp
                           UUID:(NSString *)UUID
{
    XMPPIQ *iq = [XMPPIQ iqWithType:@"set"];
    [iq addAttributeWithName:@"id" stringValue:UUID];
    NSXMLElement *notification = [NSXMLElement elementWithName:@"notification" xmlns:@"androidpn:iq:notification"];
    
    [notification addChild:[NSXMLElement elementWithName:@"id" stringValue:UUID]];
    [notification addChild:[NSXMLElement elementWithName:@"apiKey" stringValue:@"1234567890"]];
    [notification addChild:[NSXMLElement elementWithName:@"title" stringValue:@""]];
    [notification addChild:[NSXMLElement elementWithName:@"message" stringValue:plainText]];
    [notification addChild:[NSXMLElement elementWithName:@"uri" stringValue:avatarUrl]];
    [notification addChild:[NSXMLElement elementWithName:@"fromUser" stringValue:[NSString stringWithFormat:@"%@",fromName]]];
    [notification addChild:[NSXMLElement elementWithName:@"msType" numberValue:[NSNumber numberWithInt:XHBubbleMessageMediaTypeText]]];
    [notification addChild:[NSXMLElement elementWithName:@"timestamp" stringValue:[NSString stringWithFormat:@"%f",timestamp]]];
    [notification addChild:[NSXMLElement elementWithName:@"to" stringValue:toJid]];
    [notification addChild:[NSXMLElement elementWithName:@"token" stringValue:QWGLOBALMANAGER.configure.userToken]];
    [iq addChild:notification];
    
    return iq;
}

+ (XMPPIQ *)messageTypeWithLocation:(NSString *)plainText
                           latitude:(NSString *)latitude
                          longitude:(NSString *)longitude
                             withTo:(NSString *)toJid
                          avatarUrl:(NSString *)avatarUrl
                               from:(NSString *)fromName
                          timestamp:(double)timestamp
                               UUID:(NSString *)UUID
{
    XMPPIQ *iq = [XMPPIQ iqWithType:@"set"];
    [iq addAttributeWithName:@"id" stringValue:UUID];
    NSXMLElement *notification = [NSXMLElement elementWithName:@"notification" xmlns:@"androidpn:iq:notification"];
    
    [notification addChild:[NSXMLElement elementWithName:@"id" stringValue:UUID]];
    [notification addChild:[NSXMLElement elementWithName:@"apiKey" stringValue:@"1234567890"]];
    [notification addChild:[NSXMLElement elementWithName:@"title" stringValue:[NSString stringWithFormat:@"%@,%@",latitude,longitude]]];
    [notification addChild:[NSXMLElement elementWithName:@"message" stringValue:plainText]];
    [notification addChild:[NSXMLElement elementWithName:@"uri" stringValue:avatarUrl]];
    [notification addChild:[NSXMLElement elementWithName:@"fromUser" stringValue:[NSString stringWithFormat:@"%@",fromName]]];
    [notification addChild:[NSXMLElement elementWithName:@"msType" numberValue:[NSNumber numberWithInt:XHBubbleMessageMediaTypeLocation]]];
    [notification addChild:[NSXMLElement elementWithName:@"timestamp" stringValue:[NSString stringWithFormat:@"%f",timestamp]]];
    [notification addChild:[NSXMLElement elementWithName:@"to" stringValue:toJid]];
    [notification addChild:[NSXMLElement elementWithName:@"token" stringValue:QWGLOBALMANAGER.configure.userToken]];
    [iq addChild:notification];
    
    return iq;
}


+ (XMPPIQ *)messageTypeWithTextInviteEvaluate:(NSString *)plainText
                                       withTo:(NSString *)toJid
                                    avatarUrl:(NSString *)avatarUrl
                                         from:(NSString *)fromName
                                    timestamp:(double)timestamp
                                         UUID:(NSString *)UUID
{
    XMPPIQ *iq = [XMPPIQ iqWithType:@"set"];
    [iq addAttributeWithName:@"id" stringValue:UUID];
    NSXMLElement *notification = [NSXMLElement elementWithName:@"notification" xmlns:@"androidpn:iq:notification"];
    
    [notification addChild:[NSXMLElement elementWithName:@"id" stringValue:UUID]];
    [notification addChild:[NSXMLElement elementWithName:@"apiKey" stringValue:@"1234567890"]];
    [notification addChild:[NSXMLElement elementWithName:@"title" stringValue:@""]];
    [notification addChild:[NSXMLElement elementWithName:@"message" stringValue:plainText]];
    [notification addChild:[NSXMLElement elementWithName:@"uri" stringValue:avatarUrl]];
    [notification addChild:[NSXMLElement elementWithName:@"fromUser" stringValue:[NSString stringWithFormat:@"%@",fromName]]];
    [notification addChild:[NSXMLElement elementWithName:@"msType" numberValue:[NSNumber numberWithInt:XHBubbleMessageMediaTypeStarStore]]];
    [notification addChild:[NSXMLElement elementWithName:@"timestamp" stringValue:[NSString stringWithFormat:@"%f",timestamp]]];
    [notification addChild:[NSXMLElement elementWithName:@"to" stringValue:toJid]];
    [notification addChild:[NSXMLElement elementWithName:@"token" stringValue:QWGLOBALMANAGER.configure.userToken]];
    [iq addChild:notification];
    
    return iq;
}

+ (XMPPIQ *)messageTypeWithMarketActivity:(NSString *)title
                                   withTo:(NSString *)toJid
                                     from:(NSString *)fromName
                                 imageUrl:(NSString *)imageUrl
                                  content:(NSString *)content
                                timestamp:(double)timestamp
                                 richBody:(NSString *)richBody
                                     UUID:(NSString *)UUID
{
    XMPPIQ *iq = [XMPPIQ iqWithType:@"set"];
    [iq addAttributeWithName:@"id" stringValue:UUID];
    NSXMLElement *notification = [NSXMLElement elementWithName:@"notification" xmlns:@"androidpn:iq:notification"];
    
    [notification addChild:[NSXMLElement elementWithName:@"id" stringValue:UUID]];
    [notification addChild:[NSXMLElement elementWithName:@"apiKey" stringValue:@"1234567890"]];
    [notification addChild:[NSXMLElement elementWithName:@"title" stringValue:title]];
    [notification addChild:[NSXMLElement elementWithName:@"message" stringValue:content]];
    [notification addChild:[NSXMLElement elementWithName:@"uri" stringValue:imageUrl]];
    [notification addChild:[NSXMLElement elementWithName:@"richBody" stringValue:richBody]];
    [notification addChild:[NSXMLElement elementWithName:@"fromUser" stringValue:[NSString stringWithFormat:@"%@",fromName]]];
    [notification addChild:[NSXMLElement elementWithName:@"msType" numberValue:[NSNumber numberWithInt:XHBubbleMessageMediaTypeActivity]]];
    [notification addChild:[NSXMLElement elementWithName:@"timestamp" stringValue:[NSString stringWithFormat:@"%f",timestamp]]];
    [notification addChild:[NSXMLElement elementWithName:@"to" stringValue:toJid]];
    [notification addChild:[NSXMLElement elementWithName:@"token" stringValue:QWGLOBALMANAGER.configure.userToken]];
    [iq addChild:notification];
    
    return iq;
}


+ (XMPPIQ *)messageTypeWithPhoto:(NSString *)title
                          withTo:(NSString *)toJid
                            from:(NSString *)fromName

                         content:(NSString *)content
                       timestamp:(double)timestamp
                        richBody:(NSString *)richBody
                            UUID:(NSString *)UUID
{
    XMPPIQ *iq = [XMPPIQ iqWithType:@"set"];
    [iq addAttributeWithName:@"id" stringValue:UUID];
    NSXMLElement *notification = [NSXMLElement elementWithName:@"notification" xmlns:@"androidpn:iq:notification"];
    
    [notification addChild:[NSXMLElement elementWithName:@"id" stringValue:UUID]];
    [notification addChild:[NSXMLElement elementWithName:@"apiKey" stringValue:@"1234567890"]];
    [notification addChild:[NSXMLElement elementWithName:@"title" stringValue:title]];
    [notification addChild:[NSXMLElement elementWithName:@"message" stringValue:content]];
    [notification addChild:[NSXMLElement elementWithName:@"uri" stringValue:@""]];
    [notification addChild:[NSXMLElement elementWithName:@"richBody" stringValue:richBody]];
    [notification addChild:[NSXMLElement elementWithName:@"fromUser" stringValue:[NSString stringWithFormat:@"%@",fromName]]];
    [notification addChild:[NSXMLElement elementWithName:@"msType" numberValue:[NSNumber numberWithInt:XHBubbleMessageMediaTypePhoto]]];
    [notification addChild:[NSXMLElement elementWithName:@"timestamp" stringValue:[NSString stringWithFormat:@"%f",timestamp]]];
    [notification addChild:[NSXMLElement elementWithName:@"to" stringValue:toJid]];
    [notification addChild:[NSXMLElement elementWithName:@"token" stringValue:QWGLOBALMANAGER.configure.userToken]];
    [iq addChild:notification];
    
    return iq;
}
@end
