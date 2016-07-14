//
//  Message.m
//  APP
//  消息数据结构
//  Created by qw on 15/2/22.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "Message.h"
#import "XMPPManager.h"

@implementation Message

//@synthesize UUID;
//@synthesize message;
//@synthesize fromUser;
//@synthesize timestamp;
//@synthesize uri;
//@synthesize msType;
//@synthesize title;

-(void)parse:(id)value
{
    //    if ([value isKindOfClass:[NSArray class]]) {
    //
    //        NSArray *historys = value;
    //
    //        //初始化列表
    //        NSMutableArray *UUIDLists = [NSMutableArray arrayWithCapacity:10];
    //
    //        for(NSDictionary *dict in historys)
    //        {
    //            NSString *content = dict[@"content"];
    //
    //            NSXMLDocument *document = [[NSXMLDocument alloc] initWithXMLString:content options:0 error:nil];
    //            XMPPIQ *iq = (XMPPIQ *)[document rootElement];
    //            NSXMLElement *notification = [iq elementForName:@"notification"];
    //
    //            //                if([dict[@"fromTag"] integerValue] == 1) {
    //            if(notification && [[notification xmlns] isEqualToString:@"androidpn:iq:notification"])
    //            {
    //                //接受消息成功
    //                //消息id
    //                NSString *UUID = [[notification elementForName:@"id"] stringValue];
    //
    //                //消息内容
    //                NSString *text = [[notification elementForName:@"message"] stringValue];
    //                //消息来源
    //                NSString *from = [[notification elementForName:@"fromUser"] stringValue];
    //                //消息发送时间
    //                double timeStamp = [[notification elementForName:@"timestamp"] stringValueAsDouble] / 1000;
    //
    //                //消息icon
    //                NSString *avatorUrl = [[notification elementForName:@"uri"] stringValue];
    //                //消息接收对象
    //                NSString *sendName = [[notification elementForName:@"to"] stringValue];
    //                //消息类型
    //                NSUInteger messageType = [[notification elementForName:@"msType"] stringValueAsInt32];
    //
    //                //消息标题
    //                NSString *title = [[notification elementForName:@"title"] stringValue];
    //
    //                NSDictionary *UUIDdict = @{@"id":UUID};
    //                [UUIDLists addObject:UUIDdict];
    //            }
    //        }
    //    }
}

+(NSString *)getPrimaryKey
{
    return @"UUID";
}
+(NSString *)getTableName
{
    return @"MessageModel";
}
+(int)getTableVersion
{
    return 1;
}
@end


@implementation OfficialMessages

@end

@implementation HistoryMessages

@end
