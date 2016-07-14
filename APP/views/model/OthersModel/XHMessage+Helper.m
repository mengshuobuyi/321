//
//  XHmessage+Helper.m
//  APP
//
//  Created by garfield on 15/4/3.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "XHMessage+Helper.h"
#import "QWGlobalManager.h"
#import "QWMessage.h"
#import "SBJson.h"

@implementation XHMessage (Helper)

+ (void)refreshingRecentMessage:(NSArray *)array
                  messageSender:(NSString *)messageSender
                     official:(BOOL)official
{
//    if(official) {
        for(NSDictionary *dict in array)
        {
            NSDictionary *info = dict[@"info"];
            NSString *content = info[@"content"];
            NSString *fromId = info[@"fromId"];
            NSString *toId = info[@"toId"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            double timeStamp = [[formatter dateFromString:info[@"time"]] timeIntervalSince1970];
            NSDate *date = [formatter dateFromString:info[@"time"]];
            NSString *UUID = info[@"id"];
            NSUInteger fromTag = [info[@"fromTag"] integerValue];
            NSUInteger toTag = [info[@"toTag"] integerValue];
            NSUInteger msgType = [info[@"source"] integerValue];
               NSString *fromName = info[@"fromName"];
            if(msgType == 0)
                msgType = 1;
            NSString *where = [NSString stringWithFormat:@"UUID = '%@'",UUID];
            NSArray *tagList = [TagWithMessage getArrayFromDBWithWhere:where];
            XHBubbleMessageType direction;
            if([QWGLOBALMANAGER.configure.passportId isEqualToString:fromId])
            {
                direction = XHBubbleMessageTypeSending;
            }else{
                direction = XHBubbleMessageTypeReceiving;
            }
            
            for(NSDictionary *tag in info[@"tags"])
            {
                TagWithMessage* tagTemp = [[TagWithMessage alloc] init];
                
                tagTemp.length = tag[@"length"];
                tagTemp.start = tag[@"start"];
                tagTemp.tagType = tag[@"tag"];
                tagTemp.tagId = tag[@"tagId"];
                tagTemp.title = tag[@"title"];
                tagTemp.UUID = UUID;
                [TagWithMessage updateObjToDB:tagTemp WithKey:UUID];
            }
            
            OfficialMessages * omsg = [OfficialMessages getObjFromDBWithKey:UUID];
            if (omsg) {
                return;
            }
            
                TagWithMessage * tag = nil;
                if (tagList.count>0) {
                    tag = tagList[0];
                }
                OfficialMessages * msg =  [[OfficialMessages alloc] init];
                msg.fromId = fromId;
                msg.toId = toId;
                msg.timestamp = [NSString stringWithFormat:@"%f",timeStamp];
                msg.body = content;
                msg.direction = [NSString stringWithFormat:@"%.0ld",(long)XHBubbleMessageTypeReceiving];
                msg.messagetype = [NSString stringWithFormat:@"%lu",(unsigned long)msgType];
                msg.UUID = UUID;
                msg.issend = @"1";
                msg.fromTag = fromTag ;
                msg.title = fromName;
                msg.relatedid = fromId;///此处是不是有问题
                msg.subTitle = tag.title;
                [OfficialMessages saveObjToDB:msg];
            }
//        }
//    }else{
//        NSArray *historys = array;
//        NSInteger count = historys.count - 1;
//        for(; count >= 0 ; --count)
//        {
//            NSDictionary *dict = historys[count];
//            NSString *content = dict[@"content"];
//            NSXMLDocument *document = [[NSXMLDocument alloc] initWithXMLString:content options:0 error:nil];
//            XMPPIQ *iq = (XMPPIQ *)[document rootElement];
//            NSXMLElement *notification = [iq elementForName:@"notification"];
//            
//            NSDictionary *testDict = [[[notification elementForName:@"message"] stringValue] JSONValue][@"info"];
//            if(!testDict) {
//                if(notification && [[notification xmlns] isEqualToString:@"androidpn:iq:notification"])
//                {
//                    //接受消息成功
//                    NSString *UUID = [[notification elementForName:@"id"] stringValue];
//                    NSString *text = [[notification elementForName:@"message"] stringValue];
//                    NSString *from = [[notification elementForName:@"fromUser"] stringValue];
//                    double timeStamp = [[notification elementForName:@"timestamp"] stringValueAsDouble] / 1000;
//                    NSString *avatorUrl = [[notification elementForName:@"uri"] stringValue];
//                    NSString *sendName = [[notification elementForName:@"to"] stringValue];
//                    NSUInteger messageType = [[notification elementForName:@"msType"] stringValueAsInt32];
//                    NSString *title = [[notification elementForName:@"title"] stringValue];
//                    NSString *richBody = [[notification elementForName:@"richBody"] stringValue];
//                    
//                    //NSArray *tagList = dict[@"tags"];
//                    if(messageType == 6)
//                    {
//                        double star = [title doubleValue] / 2.0;
//                        title = [NSString stringWithFormat:@"%.1f",star];
//                    }
//                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
//                    NSString *fromId = dict[@"fromId"];
//                    XHBubbleMessageType bubbleMessageType;
//            
//                    if([fromId isEqualToString:messageSender]){
//                        bubbleMessageType = XHBubbleMessageTypeReceiving;
//                    }else{
//                        bubbleMessageType = XHBubbleMessageTypeSending;
//                    }
//                    QWMessage* msg = [QWMessage getObjFromDBWithKey:UUID];
//                    if (!msg) {
//                        msg = [[QWMessage alloc] init];
//                        msg.direction = [NSString stringWithFormat:@"%.0ld",(long)bubbleMessageType];
//                        msg.timestamp = [NSString stringWithFormat:@"%.0f",timeStamp];
//                        msg.UUID = UUID;
//                        msg.star = title;
//                        msg.avatorUrl = avatorUrl;
//                        msg.sendname = from;
//                        msg.recvname = sendName;
//                        msg.issend = [NSString stringWithFormat:@"%d",Sended];
//                        msg.messagetype = [NSString stringWithFormat:@"%lu",(unsigned long)messageType];
//                        msg.isRead = @"1";
//                        msg.richbody = richBody;
//                        msg.body = text;
//                        [QWMessage saveObjToDB:msg];
//                    }
//                    NSString *historyTitle = @"";
//                    if(messageType == 5){
//                        historyTitle = title;
//                    }else{
//                        historyTitle = text;
//                    }
//                    if(count == (historys.count - 1))
//                    {
//                        HistoryMessages * hmsg = [[HistoryMessages alloc] init];
//                        hmsg.timestamp = [NSString stringWithFormat:@"%.0f",timeStamp];
//                        hmsg.body = historyTitle;
//                        hmsg.direction = msg.direction;
//                        hmsg.messagetype = msg.messagetype;
//                        hmsg.UUID = msg.UUID;
//                        hmsg.issend = msg.issend;
//                        hmsg.avatarurl = @"";
//                        hmsg.relatedid = messageSender;
//                        [HistoryMessages updateObjToDB:hmsg WithKey:msg.sendname];
//                    }
//                }
//            }else{
//                if(notification && [[notification xmlns] isEqualToString:@"androidpn:iq:notification"])
//                {
//                    NSString *UUID = [[notification elementForName:@"id"] stringValue];
//                    NSDictionary *dict = [[[notification elementForName:@"message"] stringValue] JSONValue][@"info"];
//                    
//                    NSString *text = dict[@"content"];
//                    NSString *from = dict[@"fromId"];
//                    NSString *sendName = dict[@"toId"];
//                    NSArray *tagList = dict[@"tags"];
//                    NSString *title = @"";
//                    NSUInteger source = 0;
//                    NSString *avatorUrl = [[notification elementForName:@"uri"] stringValue];
//                    if(dict) {
//                        source = [dict[@"source"] integerValue];
//                    }else{
//                        source = [[notification elementForName:@"msType"] stringValueAsInt];
//                    }
//                    if(tagList.count)
//                    {
//                        title = tagList[0][@"title"];
//                    }
//                    else
//                    {
//                        if([[notification elementForName:@"title"] stringValue])
//                            title = [[notification elementForName:@"title"] stringValue];
//                    }
//                    double timeStamp = [[notification elementForName:@"timestamp"] stringValueAsDouble] / 1000;
//                    NSString *richBody = [[notification elementForName:@"richBody"] stringValue];
//
//                    XHBubbleMessageType direction;
//                    if([from isEqualToString:QWGLOBALMANAGER.configure.passportId]) {
//                        direction = XHBubbleMessageTypeSending;
//                    }else{
//                        direction = XHBubbleMessageTypeReceiving;
//                    }
//                    if(!text)
//                        continue;
//                    
//                    QWMessage* msg = [[QWMessage alloc] init];
//                    msg.direction = [NSString stringWithFormat:@"%.0ld",(long)direction];
//                    msg.timestamp = [NSString stringWithFormat:@"%.0f",timeStamp];
//                    msg.UUID = UUID;
//                    msg.star = title;
//                    msg.avatorUrl = @"";
//                    msg.sendname = from;
//                    msg.recvname = sendName;
//                    msg.issend = [NSString stringWithFormat:@"%d",Sended];
//                    msg.messagetype = [NSString stringWithFormat:@"%lu",(unsigned long)source];
//                    msg.isRead = @"1";
//                    msg.richbody = richBody;
//                    msg.body = text;
//                    [QWMessage updateObjToDB:msg WithKey:msg.UUID];
//                    NSString *historyTitle = @"";
//                    if(source == 5){
//                        historyTitle = title;
//                    }else{
//                        historyTitle = text;
//                    }
//                    if(count == (historys.count - 1))
//                    {
//                        HistoryMessages * hmsg = [[HistoryMessages alloc] init];
//                        hmsg.timestamp = [NSString stringWithFormat:@"%.0f",timeStamp];
//                        hmsg.body = historyTitle;
//                        hmsg.direction = msg.direction;
//                        hmsg.messagetype = msg.messagetype;
//                        hmsg.UUID = msg.UUID;
//                        hmsg.issend = msg.issend;
//                        hmsg.avatarurl = @"";
//                        hmsg.relatedid = messageSender;
//                        [HistoryMessages updateObjToDB:hmsg WithKey:msg.sendname];
//                    }
//                    
//                    for(NSDictionary *tag in tagList)
//                    {
//                        TagWithMessage* tagTemp = [[TagWithMessage alloc] init];
//                        
//                        tagTemp.length = tag[@"length"];
//                        tagTemp.start = tag[@"start"];
//                        tagTemp.tagType = tag[@"tag"];
//                        tagTemp.tagId = tag[@"tagId"];
//                        tagTemp.title = tag[@"title"];
//                        tagTemp.UUID = UUID;
//                        [TagWithMessage updateObjToDB:tagTemp WithKey:tagTemp.UUID];
//                    }
//                }
//            }
//        }
//    }
}

+ (void)headerRefreshingMessage:(NSArray *)array
                  messageSender:(NSString *)messageSender
                       infoDict:(NSDictionary *)infoDict
                       messages:(NSMutableArray *)messages
                     official:(BOOL)official
{
    if(official) {
        for(NSDictionary *dict in array)
        {
            NSDictionary *info = dict[@"info"];
            NSString *content = info[@"content"];
            NSString *fromId = info[@"fromId"];
            NSString *toId = info[@"toId"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            double timeStamp = [[formatter dateFromString:info[@"time"]] timeIntervalSince1970];
            NSDate *date = [formatter dateFromString:info[@"time"]];
            NSString *UUID = info[@"id"];
            NSUInteger fromTag = [info[@"fromTag"] integerValue];
            NSUInteger toTag = [info[@"toTag"] integerValue];
            NSUInteger msgType = [info[@"source"] integerValue];
            if(msgType == 0)
                msgType = 1;
                 NSString *fromName = info[@"fromName"];
            XHBubbleMessageType direction;
            if(fromTag==2)
            {
                direction = XHBubbleMessageTypeSending;
            }else{
                direction = XHBubbleMessageTypeReceiving;
            }
            
            for(NSDictionary *tag in info[@"tags"])
            {
                TagWithMessage* tagTemp = [[TagWithMessage alloc] init];
                
                tagTemp.length = tag[@"length"];
                tagTemp.start = tag[@"start"];
                tagTemp.tagType = tag[@"tag"];
                tagTemp.tagId = tag[@"tagId"];
                tagTemp.title = tag[@"title"];
                tagTemp.UUID = UUID;
                [TagWithMessage updateObjToDB:tagTemp WithKey:UUID];
            }
            
            NSString *where = [NSString stringWithFormat:@"UUID = '%@'",UUID];
            NSArray *tagList = [TagWithMessage getArrayFromDBWithWhere:where];
            OfficialMessages * omsg = [OfficialMessages getObjFromDBWithKey:UUID];
            if (omsg) {
                return;
            }
                TagWithMessage * tag = nil;
                if (tagList.count>0) {
                    tag = tagList[0];
                }
                
                OfficialMessages * msg =  [[OfficialMessages alloc] init];
                msg.fromId = fromId;
                msg.toId = toId;
                msg.timestamp = [NSString stringWithFormat:@"%f",timeStamp];
                msg.body = content;
                msg.direction = [NSString stringWithFormat:@"%.0ld",(long)direction];
                msg.messagetype = [NSString stringWithFormat:@"%lu",(unsigned long)msgType];
                msg.UUID = UUID;
                msg.issend = @"1";
                msg.fromTag = fromTag ;
                msg.title = fromName;
                msg.relatedid = fromId;///此处是不是有问题
                msg.subTitle = tag.title;
                [OfficialMessages saveObjToDB:msg];
//            }
            XHMessage *message = nil;
            switch (msgType)
            {
                case XHBubbleMessageMediaTypeText:
                {
                    
                    message = [[XHMessage alloc] initWithOfficalText:content sender:fromId timestamp:date UUID:UUID fromTag:fromTag];
                    break;
                }
                case XHBubbleMessageMediaTypeAutoSubscription:
                {
                    
                    message = [[XHMessage alloc] initWithAutoSubscription:content sender:fromId timestamp:date UUID:UUID tagList:tagList];
                    
                    break;
                }
                case XHBubbleMessageMediaTypeDrugGuide:
                { TagWithMessage * tag = tagList[0];
                    
                    message = [[XHMessage alloc] initWithDrugGuide:content title:fromName sender:fromId timestamp:date UUID:UUID tagList:tagList subTitle:tag.title fromTag:fromTag];
                    break;
                }
                case XHBubbleMessageMediaTypePurchaseMedicine:
                {
                    
                    TagWithMessage * tag = tagList[0];
                    
                    message = [[XHMessage alloc]initWithPurchaseMedicine:content sender:fromId timestamp:date UUID:UUID tagList:tagList title:fromName subTitle:tag.title fromTag:fromTag];
                    break;
                }
                    
                default:
                    
                    break;
            }
            if (! direction ==1 ) {
                message.avator = [UIImage imageNamed:@"药店默认头像"];
                message.avatorUrl = QWGLOBALMANAGER.configure.avatarUrl;
            }else
            {
                message.avator = [UIImage imageNamed:@"全维药事icon.png"];
                
            }
            message.bubbleMessageType = direction;
            message.officialType = YES;
            if(message)
                [messages addObject:message];
        }
    }
//    else{
//        NSArray *historys = array;
//        NSInteger count = historys.count - 1;
//        for(; count >= 0 ; --count)
//        {
//            XHMessage *message = nil;
//            NSDictionary *dict = historys[count];
//            NSString *content = dict[@"content"];
//            NSXMLDocument *document = [[NSXMLDocument alloc] initWithXMLString:content options:0 error:nil];
//            XMPPIQ *iq = (XMPPIQ *)[document rootElement];
//            NSXMLElement *notification = [iq elementForName:@"notification"];
//            
//            NSDictionary *testDict = [[[notification elementForName:@"message"] stringValue] JSONValue][@"info"];
//            if(!testDict) {
//                if(notification && [[notification xmlns] isEqualToString:@"androidpn:iq:notification"])
//                {
//                    //接受消息成功
//                    NSString *UUID = [[notification elementForName:@"id"] stringValue];
//                    NSString *text = [[notification elementForName:@"message"] stringValue];
//                    NSString *from = [[notification elementForName:@"fromUser"] stringValue];
//                    double timeStamp = [[notification elementForName:@"timestamp"] stringValueAsDouble] / 1000;
//                     NSString *fromName = [[notification elementForName:@"fromName"] stringValue];
//                    NSString *avatorUrl = [[notification elementForName:@"uri"] stringValue];
//                    NSString *sendName = [[notification elementForName:@"to"] stringValue];
//                    NSUInteger messageType = [[notification elementForName:@"msType"] stringValueAsInt32];
//                    NSString *title = [[notification elementForName:@"title"] stringValue];
//                    NSString *richBody = [[notification elementForName:@"richBody"] stringValue];
//                     NSUInteger fromTag = [[[notification elementForName:@"fromTag" ] stringValue] integerValue];
//                    NSArray *tagList = dict[@"tags"];
//                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
//                    
//                    NSString *fromId = dict[@"fromId"];
//                    
//                    switch (messageType)
//                    {
//                        case XHBubbleMessageMediaTypeText:
//                        {
//                            message = [[XHMessage alloc] initWithText:text sender:sendName timestamp:date UUID:UUID];
//                            break;
//                        }
//                        case XHBubbleMessageMediaTypeLocation:
//                        {
//                            NSString *latitude = [title componentsSeparatedByString:@","][0];
//                            NSString *longitude = [title componentsSeparatedByString:@","][1];
//                            
//                            message = [[XHMessage alloc] initWithLocation:text latitude:latitude longitude:longitude sender:sendName timestamp:date UUID:UUID];
//                            break;
//                        }
//                        case XHBubbleMessageMediaTypeStarStore:
//                        {
//                            message = [[XHMessage alloc] initInviteEvaluate:text sender:sendName timestamp:date UUID:UUID];
//                            break;
//                        }
//                        case XHBubbleMessageMediaTypeStarClient:
//                        {
//                            message = [[XHMessage alloc] initEvaluate:[title floatValue] text:[NSString stringWithFormat:@"评价内容:%@",text] sender:sendName timestamp:date UUID:UUID];
//                            break;
//                        }
//                        case XHBubbleMessageMediaTypeActivity:
//                        {
//                            NSString *imageUrl = avatorUrl;
//                            if(imageUrl == nil)
//                                imageUrl = @"";
//                            message = [[XHMessage alloc] initMarketActivity:title sender:sendName imageUrl:imageUrl content:text comment:@"" richBody:richBody timestamp:date UUID:UUID];
//                            break;
//                        }
//                        case XHBubbleMessageMediaTypePurchaseMedicine:
//                        {
//                            TagWithMessage * tag = tagList[0];
//                            
//                            message = [[XHMessage alloc]initWithPurchaseMedicine:content sender:fromId timestamp:date UUID:UUID tagList:tagList title:fromName subTitle:tag.title fromTag:fromTag];
//                        }
//                        case XHBubbleMessageMediaTypeDrugGuide:
//                        {
//                            TagWithMessage * tag = tagList[0];
//                            
//                            message = [[XHMessage alloc] initWithDrugGuide:content title:fromName sender:fromId timestamp:date UUID:UUID tagList:tagList subTitle:tag.title fromTag:fromTag];
//                            break;
//                        }
//                        case XHBubbleMessageMediaTypePhoto:
//                        {
//                            message  = [[XHMessage alloc]initWithPhoto:nil thumbnailUrl:richBody originPhotoUrl:richBody sender:sendName timestamp:date UUID:UUID richBody:richBody];;
//                            break;
//                        }
//                        default:
//                            break;
//                    }
//                    
//                    if([fromId isEqualToString:messageSender]){
//                        message.bubbleMessageType = XHBubbleMessageTypeReceiving;
//                    }else{
//                        message.bubbleMessageType = XHBubbleMessageTypeSending;
//                    }
//                    if(message.bubbleMessageType == XHBubbleMessageTypeSending) {
//                        message.avatorUrl = QWGLOBALMANAGER.configure.avatarUrl;
//                    }else{
//                        message.avatorUrl = infoDict[@"avatarurl"];
//                    }
//                    
//                    if(message){
//                        QWMessage* msg = [QWMessage getObjFromDBWithKey:UUID];
//                           if (messageType == XHBubbleMessageMediaTypePhoto) {
//                        if (!msg) {
//                            
//                            msg = [[QWMessage alloc] init];
//                            msg.direction = [NSString stringWithFormat:@"%.0ld",(long)message.bubbleMessageType];
//                            msg.timestamp = [NSString stringWithFormat:@"%.0f",timeStamp];
//                            msg.UUID = UUID;
//                            msg.star = title;
//                            msg.avatorUrl = avatorUrl;
//                            msg.sendname = from;
//                            msg.recvname = sendName;
//                            msg.issend = [NSString stringWithFormat:@"%d",Sended];
//                            msg.messagetype = [NSString stringWithFormat:@"%lu",(unsigned long)messageType];
//                            msg.isRead = @"1";
//                            msg.richbody = avatorUrl;
//                            msg.body = @"[图片]";
//                            [QWMessage saveObjToDB:msg];
//                            [messages insertObject:message atIndex:0];
//                        }
//                           }
//                        else
//                        {
//                            msg = [[QWMessage alloc] init];
//                            msg.direction = [NSString stringWithFormat:@"%.0ld",(long)message.bubbleMessageType];
//                            msg.timestamp = [NSString stringWithFormat:@"%.0f",timeStamp];
//                            msg.UUID = UUID;
//                            msg.star = title;
//                            msg.avatorUrl = avatorUrl;
//                            msg.sendname = from;
//                            msg.recvname = sendName;
//                            msg.issend = [NSString stringWithFormat:@"%d",Sended];
//                            msg.messagetype = [NSString stringWithFormat:@"%lu",(unsigned long)messageType];
//                            msg.isRead = @"1";
//                            msg.richbody = avatorUrl;
//                            msg.body = text;
//                            [QWMessage saveObjToDB:msg];
//                            [messages insertObject:message atIndex:0];
//                        }
//                    }
//                    
//                }
//            }else{
//                if(notification && [[notification xmlns] isEqualToString:@"androidpn:iq:notification"])
//                {
//                    NSString *UUID = [[notification elementForName:@"id"] stringValue];
//                    NSDictionary *dict = [[[notification elementForName:@"message"] stringValue] JSONValue][@"info"];
//                    
//                    NSString *text = dict[@"content"];
//                    NSString *from = dict[@"fromId"];
//                    NSString *sendName = dict[@"toId"];
//                    NSArray *tagList = dict[@"tags"];
//                    NSString *title = @"";
//                    NSUInteger source = [dict[@"source"] integerValue];
//                    if(tagList.count)
//                    {
//                        title = tagList[0][@"title"];
//                    }
//                    else
//                    {
//                        if([[notification elementForName:@"title"] stringValue])
//                            title = [[notification elementForName:@"title"] stringValue];
//                    }
//                    NSString *avatorUrl = [[notification elementForName:@"uri"] stringValue];
//                    double timeStamp = [[notification elementForName:@"timestamp"] stringValueAsDouble] / 1000;
//                    NSString *richBody = [[notification elementForName:@"richBody"] stringValue];
//                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
//                    
//                    XHBubbleMessageType direction;
//                    if([from isEqualToString:QWGLOBALMANAGER.configure.passportId]) {
//                        direction = XHBubbleMessageTypeSending;
//                    }else{
//                        direction = XHBubbleMessageTypeReceiving;
//                    }
//                    
//                    QWMessage* msg = [[QWMessage alloc] init];
//                    msg.direction = [NSString stringWithFormat:@"%.0ld",(long)direction];
//                    msg.timestamp = [NSString stringWithFormat:@"%.0f",timeStamp];
//                    msg.UUID = UUID;
//                    msg.star = title;
//                    msg.avatorUrl = @"";
//                    msg.sendname = from;
//                    msg.recvname = sendName;
//                    msg.issend = [NSString stringWithFormat:@"%d",Sended];
//                    msg.messagetype = [NSString stringWithFormat:@"%lu",(unsigned long)source];
//                    msg.isRead = @"1";
//                    msg.richbody = @"";
//                    msg.body = text;
//                    [QWMessage updateObjToDB:msg WithKey:msg.UUID];
//                    
//                    for(NSDictionary *tag in tagList)
//                    {
//                        TagWithMessage* tagTemp = [[TagWithMessage alloc] init];
//                        
//                        tagTemp.length = tag[@"length"];
//                        tagTemp.start = tag[@"start"];
//                        tagTemp.tagType = tag[@"tag"];
//                        tagTemp.tagId = tag[@"tagId"];
//                        tagTemp.title = tag[@"title"];
//                        tagTemp.UUID = UUID;
//                        [TagWithMessage updateObjToDB:tagTemp WithKey:tagTemp.UUID];
//                    }
//                    
//                    NSString *where = [NSString stringWithFormat:@"UUID = '%@'",UUID];
//                    tagList = [TagWithMessage getArrayFromDBWithWhere:where];
//                    switch (source)
//                    {
//                        case XHBubbleMessageMediaTypeDrugGuide:
//                        {
//                            TagWithMessage* tag = tagList[0];
//                            NSString *title = tag.title;
//                            message = [[XHMessage alloc] initWithDrugGuide:text title:title sender:sendName timestamp:date UUID:UUID tagList:tagList];
//                            break;
//                        }
//                        case XHBubbleMessageMediaTypePurchaseMedicine:
//                        {
//                            message = [[XHMessage alloc] initWithPurchaseMedicine:text sender:sendName timestamp:date UUID:UUID tagList:tagList];
//                            break;
//                        }
//                        case XHBubbleMessageMediaTypeText:
//                        {
//                            message = [[XHMessage alloc] initWithText:text sender:sendName timestamp:date UUID:UUID];
//                            break;
//                        }
//                        case XHBubbleMessageMediaTypeLocation:
//                        {
//                            NSString *latitude = [title componentsSeparatedByString:@","][0];
//                            NSString *longitude = [title componentsSeparatedByString:@","][1];
//                            
//                            message = [[XHMessage alloc] initWithLocation:text latitude:latitude longitude:longitude sender:sendName timestamp:date UUID:UUID];
//                            break;
//                        }
//                        case XHBubbleMessageMediaTypeStarStore:
//                        {
//                            message = [[XHMessage alloc] initInviteEvaluate:text sender:sendName timestamp:date UUID:UUID];
//                            break;
//                        }
//                        case XHBubbleMessageMediaTypeStarClient:
//                        {
//                            message = [[XHMessage alloc] initEvaluate:[title floatValue] text:[NSString stringWithFormat:@"评价内容:%@",text] sender:sendName timestamp:date UUID:UUID];
//                            break;
//                        }
//                        case XHBubbleMessageMediaTypeActivity:
//                        {
//                            NSString *imageUrl = avatorUrl;
//                            if(imageUrl == nil)
//                                imageUrl = @"";
//                            message = [[XHMessage alloc] initMarketActivity:[QWGLOBALMANAGER replaceSpecialStringWith:title] sender:sendName imageUrl:imageUrl content:[QWGLOBALMANAGER replaceSpecialStringWith:text] comment:@"" richBody:richBody timestamp:date UUID:UUID];
//                            break;
//                        }
//                        case XHBubbleMessageMediaTypePhoto:
//                        {
//                            break;
//                        }
//                        default:
//                            break;
//                    }
//                    message.bubbleMessageType = direction;
//                    if(message.bubbleMessageType == XHBubbleMessageTypeSending) {
//                        message.avatorUrl = QWGLOBALMANAGER.configure.avatarUrl;
//                    }else{
//                        message.avatorUrl = infoDict[@"avatarurl"];
//                    }
//                    if(message)
//                    {
//                        [messages insertObject:message atIndex:0];
//                    }
//                }
//            }
//        }
//    }
}

+ (XHMessage *)getMessages:(NSMutableArray *)messages
                  withUUID:(NSString *)uuid
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"UUID == %@",uuid];
    NSArray *array = [messages filteredArrayUsingPredicate:predicate];
    if([array count] > 0) {
        return array[0];
    }else{
        return nil;
    }
}


@end
