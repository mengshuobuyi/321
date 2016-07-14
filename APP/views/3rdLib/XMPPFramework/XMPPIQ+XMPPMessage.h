//
//  XMPPIQ+XMPPIQ_Message.h
//  wenyao-store
//
//  Created by xiezhenghong on 14-10-8.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPIQ.h"

@interface XMPPIQ (Message)

+ (XMPPIQ *)messageTypeWithText:(NSString *)plainText
                         withTo:(NSString *)toJid
                      avatarUrl:(NSString *)avatarUrl
                           from:(NSString *)fromName
                      timestamp:(double)timestamp
                           UUID:(NSString *)UUID;

+ (XMPPIQ *)messageTypeWithTextInviteEvaluate:(NSString *)plainText
                                       withTo:(NSString *)toJid
                                    avatarUrl:(NSString *)avatarUrl
                                         from:(NSString *)fromName
                                    timestamp:(double)timestamp
                                         UUID:(NSString *)UUID;

+ (XMPPIQ *)messageTypeWithLocation:(NSString *)plainText
                           latitude:(NSString *)latitude
                          longitude:(NSString *)longitude
                             withTo:(NSString *)toJid
                          avatarUrl:(NSString *)avatarUrl
                               from:(NSString *)fromName
                          timestamp:(double)timestamp
                               UUID:(NSString *)UUID;

+ (XMPPIQ *)messageTypeWithEvaluate:(NSString *)plainText
                             withTo:(NSString *)toJid
                               star:(CGFloat)star
                          avatarUrl:(NSString *)avatarUrl
                               from:(NSString *)fromName
                          timestamp:(double)timestamp
                               UUID:(NSString *)UUID;

+ (XMPPIQ *)messageTypeWithMarketActivity:(NSString *)title
                                   withTo:(NSString *)toJid
                                     from:(NSString *)fromName
                                 imageUrl:(NSString *)imageUrl
                                  content:(NSString *)content
                                timestamp:(double)timestamp
                                 richBody:(NSString *)richBody
                                     UUID:(NSString *)UUID;

+ (XMPPIQ *)messageTypeWithPhoto:(NSString *)title
                          withTo:(NSString *)toJid
                            from:(NSString *)fromName

                         content:(NSString *)content
                       timestamp:(double)timestamp
                        richBody:(NSString *)richBody
                            UUID:(NSString *)UUID;
@end
