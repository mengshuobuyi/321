//
//  ExpertMessageModel.m
//  wenYao-store
//
//  Created by 李坚 on 16/3/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ExpertMessageModel.h"


@implementation IMChatDetailSended

@end
@implementation ExpertMessageModel
@synthesize duration;
@synthesize UUID;
@synthesize fileUrl;
@synthesize timestamp;
@synthesize isRead;
@synthesize sendname;
@synthesize recvname;
@synthesize issend;
@synthesize download;
@synthesize direction;
@synthesize avatorUrl;
@synthesize body;
@synthesize messagetype;
@synthesize richbody;
@synthesize detailId;
@synthesize recipientId;//接收人Id
@synthesize passportId;
@synthesize sessionId;
@synthesize latestTime;
@synthesize content;
@synthesize userType;
@synthesize posterId;
@synthesize spec;
@synthesize branchProId;
@synthesize branchId;
@synthesize imgUrl;
@end

@implementation ExpertXPMessageModel
@synthesize UUID;
@synthesize timestamp;
@synthesize isRead;
@synthesize sendname;
@synthesize recvname;
@synthesize issend;
@synthesize download;
@synthesize direction;
@synthesize avatorUrl;
@synthesize body;
@synthesize messagetype;
@synthesize richbody;
@synthesize detailId;
@synthesize consultId;
@synthesize latestTime;
@synthesize content;

@end

@implementation ChatDetailList

@end
@implementation IMChatDetailVo
+ (NSString *)getPrimaryKey{
    
    return @"detailId";
}
@end
@implementation ChatPointList

@end
@implementation IMChatPointVo
+ (NSString *)getPrimaryKey{
    
    return @"recipientId";
}

+ (BOOL)checkPMUnread{
    
    NSArray *Array = [IMChatPointVo getArrayFromDBWithWhere:@""];
    
    for(IMChatPointVo *VO in Array){
        if(![VO.readFlag boolValue]){
            return YES;
        }
    }
    return NO;
}
@end

@implementation NewsList

@end
@implementation NewsVO

@end
@implementation QADetailListVO

@end
@implementation QADetailVO

@end
@implementation QAList

@end
@implementation QAListVO
+ (NSString *)getPrimaryKey{
    
    return @"consultId";
}
@end
@implementation XPChatDetailSended

@end

