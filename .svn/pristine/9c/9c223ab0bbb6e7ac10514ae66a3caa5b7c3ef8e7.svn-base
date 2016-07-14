//
//  PTPMessageCenter.m
//  APP
//
//  Created by Yan Qingyang on 15/6/29.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "PTPMessageCenter.h"
#import "ConsultPTPModel.h"

@interface PTPMessageCenter()
{
    
}

@end

@implementation PTPMessageCenter
- (id)initWithID:(NSString*)oID sessionID:(NSString*)sessionID type:(IMType)type
{
    if (self = [self initWithID:oID type:type]) {
        if (sessionID)
        self.sessionID = StrFromObj(sessionID);
    }
    return self;
}

#pragma mark - API
- (void)pollMessages
{
    //    DebugLog(@"pollMessages %@ %@",self.oID,self.sessionID);
    //用seesionID
    if (self.sessionID==nil) {
        return;
    }
    
    if (self.type==IMTypePTPClient){
        [ChatAPI PTPClientPollMessagesWithID:self.sessionID success:^(CustomerSessionDetailList *responModel) {
            if ([self isClose]) {
                return ;
            }
            if (responModel.serverTime && responModel.serverTime.integerValue>0) {
                self.serverTime=responModel.serverTime.doubleValue/1000.0;
            }
            [self checkNoDataTimes:responModel.details.count];
            BOOL new=[self checkMessagesFromAPI:responModel type:IMListPolling];
            if (new)
            [self showCurrentMessages:IMListPolling successData:responModel];
            
        } failure:^(HttpException *e) {
            
        }];
    }
    else if(self.type==IMTypePTPStore){
        [ChatAPI PTPStorePollMessagesWithID:self.sessionID success:^(PharSessionDetailList *responModel) {
            if ([self isClose]) {
                return ;
            }
            
            if (responModel.serverTime && responModel.serverTime.integerValue>0) {
                self.serverTime=responModel.serverTime.doubleValue/1000.0;
            }
            [self checkNoDataTimes:responModel.details.count];
            BOOL new=[self checkMessagesFromAPI:responModel type:IMListPolling];
            if (new)
            [self showCurrentMessages:IMListPolling successData:responModel];
        } failure:^(HttpException *e) {
            //
        }];
    }
    
}


- (void)getAllMessages
{
    int num = 500;
    NSString *point=@"0";
    
    //获取最新的时间戳
    MessageModel *last=[self getLastModel];
    if (last) {
        point = [NSString stringWithFormat:@"%.0f",[last.timestamp timeIntervalSince1970] * 1000.0f];
    }
    
    //用branchId获取seesionID
    if (self.type==IMTypePTPClient) {
        GetByPharModelR *mm = [GetByPharModelR new];
        mm.branchId = self.oID;
        mm.token = QWGLOBALMANAGER.configure.userToken;
        mm.point = point;
        mm.view = StrFromInt(num);//取最近的1页数据
        mm.viewType = @"1";
        
        
        [ChatAPI PTPClientAllMessagesWithParams:mm success:^(CustomerSessionDetailList *responModel) {
            DebugLog(@"AAAAAAAAAALLLLL x: %d",(int)responModel.details.count);
            if ([self isClose]) {
                return ;
            }
            
            if (responModel.serverTime && responModel.serverTime.integerValue>0) {
                self.serverTime=responModel.serverTime.doubleValue/1000.0;
            }
            
            if (responModel.sessionId) {
                self.sessionID=StrFromObj(responModel.sessionId);
            }
            
            [self checkMessagesFromAPI:responModel type:IMListAll];
            [self setOffset:0];
            [self showCurrentMessages:IMListAll successData:responModel];
            
        } failure:^(HttpException *e) {
            DebugLog(@"PTP failure: %@",e);
        }];
    }
    else if(self.type==IMTypePTPStore){
        GetByCustomerModelR *mm = [GetByCustomerModelR new];
        mm.customerPassport = self.oID;
        mm.token = QWGLOBALMANAGER.configure.userToken;
        mm.point = point;
        mm.view = StrFromInt(num);//取最近的1页数据
        mm.viewType = @"1";
        [ChatAPI PTPStoreAllMessagesWithParams:mm success:^(PharSessionDetailList *responModel) {
            DebugLog(@"AAAAAAAAAALLLLL x: %d",(int)responModel.details.count);
            if ([self isClose]) {
                return ;
            }
            
            if (responModel.serverTime && responModel.serverTime.integerValue>0) {
                self.serverTime=responModel.serverTime.doubleValue/1000.0;
            }
            
            if (responModel.sessionId) {
                self.sessionID=StrFromObj(responModel.sessionId);
            }
            
            [self checkMessagesFromAPI:responModel type:IMListAll];
            [self setOffset:0];
            [self showCurrentMessages:IMListAll successData:responModel];
        } failure:^(HttpException *e) {
            DebugLog(@"PTP failure: %@",e);
        }];
    }
}

- (void)getHistoryMessages:(IMHistoryBlock)block success:(IMSuccessBlock)success failure:(IMFailureBlock)failure{
    MessageModel *modOffset=[self getOffsetModel];
    
    
    if (self.type==IMTypePTPClient) {
        GetByPharModelR *mm = [GetByPharModelR new];
        mm.branchId = self.oID;
        mm.token = QWGLOBALMANAGER.configure.userToken;
        mm.point = @"0";
        mm.view = StrFromInt(self.pageSize);
        mm.viewType = @"-1";
        
        if (modOffset != nil) {
            mm.point = [NSString stringWithFormat:@"%.0f",[modOffset.timestamp timeIntervalSince1970] * 1000.0f];
        }
        
        [ChatAPI PTPClientAllMessagesWithParams:mm success:^(CustomerSessionDetailList *responModel) {
            DebugLog(@"拉历史 x: %d",(int)responModel.details.count);
            if ([self isClose]) {
                return ;
            }
            if (responModel.sessionId) {
                self.sessionID=StrFromObj(responModel.sessionId);
            }
            
            BOOL hadNew = [self checkMessagesFromAPI:responModel type:IMListHistory];
            [self setOffset:0];
            if (block) {
                if (hadNew) {
                    block(YES);
                    if (success) {
                        success(nil);
                    }
                }
                else if(responModel.details.count>0){
                    [self showHistoryMessages:block success:success];
                }
                else {
                    block(NO);
                    if (success) {
                        success(nil);
                    }
                }
            }
            
        } failure:^(HttpException *e) {
            if (failure) {
                failure(e);
            }
            DebugLog(@"PTP failure: %@",e);
        }];
    }
    else if(self.type==IMTypePTPStore){
        GetByCustomerModelR *mm = [GetByCustomerModelR new];
        mm.customerPassport = self.oID;
        mm.token = QWGLOBALMANAGER.configure.userToken;
        mm.point = @"0";
        mm.view = StrFromInt(self.pageSize);
        mm.viewType = @"-1";
        
        if (modOffset != nil) {
            mm.point = [NSString stringWithFormat:@"%.0f",[modOffset.timestamp timeIntervalSince1970] * 1000.0f];
        }
        
        [ChatAPI PTPStoreAllMessagesWithParams:mm success:^(PharSessionDetailList *responModel) {
            DebugLog(@"拉历史 x: %d",(int)responModel.details.count);
            if ([self isClose]) {
                return ;
            }
            if (responModel.sessionId) {
                self.sessionID=StrFromObj(responModel.sessionId);
            }
            
            BOOL hadNew = [self checkMessagesFromAPI:responModel type:IMListHistory];
            [self setOffset:0];
            if (block) {
                if (hadNew) {
                    block(YES);
                    if (success) {
                        success(nil);
                    }
                }
                else if(responModel.details.count>0){
                    [self showHistoryMessages:block success:success];
                }
                else {
                    block(NO);
                    if (success) {
                        success(nil);
                    }
                }
            }
            
        } failure:^(HttpException *e) {
            if (failure) {
                failure(e);
            }
            DebugLog(@"PTP failure: %@",e);
        }];
    }
    
}

- (void)readMessages:(NSArray*)arrItems containSystem:(NSInteger)containSystem{
    if (arrItems==nil || arrItems.count==0) {
        return;
    }
    
    NSString *strItems = [self getReadIDs:arrItems];
    
    PTPRead *modelR = [PTPRead new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.sessionId =self.sessionID;
    
    
    
    modelR.detailIds = strItems;
    modelR.containSystem = [NSString stringWithFormat:@"%ld",(long)containSystem]; //系统消息条数不用设已读
    [ChatAPI PTPReadMessagesWithParams:modelR success:^(ApiBody *responModel) {
        DebugLog(@"******* 已读 %@",strItems);
    } failure:^(HttpException *e) {
        
    }];
}

- (void)sendAMessage:(MessageModel*)model success:(IMSuccessBlock)success failure:(IMFailureBlock)failure{
    QWPTPMessage* qwmsg=(QWPTPMessage*)[self buildQWMessageFromMessage:model];
    PTPCreate *mm = [self buildPTPCreateFromMessage:model];
    
    ++self.sendingCount;
    [ChatAPI PTPSendAMessageWithParams:mm success:^(DetailCreateResult *responModel) {
        self.sendingCount=self.sendingCount-1;
        if([responModel.apiStatus integerValue] == 0) {
            
            //            DebugLog(@"responModel %@",responModel);
            qwmsg.UUID=StrFromObj(responModel.detailId);
            qwmsg.timestamp=[NSString stringWithFormat:@"%.0f",[responModel.createTime doubleValue]];
            //            DebugLog(@"/////////// 返回的时间戳 \n%@\n%@",responModel.createTime,qwmsg.timestamp);
            [self sendAMessageDidSuccess:mm.UUID QWMessage:qwmsg MessageModel:model];
            if (success) {
                success(model.UUID);
            }
        }else{
            [self sendAMessageDidFailure:mm.UUID QWMessage:qwmsg MessageModel:model];
            if (failure) {
                failure(nil);
            }
        }
        
    } failure:^(HttpException *e) {
        self.sendingCount=self.sendingCount-1;
        [self sendAMessageDidFailure:mm.UUID QWMessage:qwmsg MessageModel:model];
        if (failure) {
            failure(e);
        }
    }];
}

- (void)deleteAMessage:(MessageModel*)model success:(IMSuccessBlock)success failure:(IMFailureBlock)failure{
    PTPRemove *mm = [PTPRemove new];
    mm.sessionId = self.sessionID;
    mm.detailId = model.UUID;
    mm.token = QWGLOBALMANAGER.configure.userToken;
    
    [ChatAPI PTPDeleteAMessageWithParams:mm success:^(ApiBody *responModel) {
        //
    } failure:^(HttpException *e) {
        //
    }];
    
}

#pragma mark  发送成功/失败
- (void)sendAMessageDidSuccess:(NSString *)UUID QWMessage:(QWPTPMessage*)qwmsg MessageModel:(MessageModel*)msg{
    msg.UUID=StrFromObj(qwmsg.UUID);
    
    //修改状态
    msg.sended=MessageDeliveryState_Delivered;
    qwmsg.issend = StrFromInt(msg.sended);//发送, 成功
    //更新db
    NSString *where=[NSString stringWithFormat:@"UUID = '%@'",UUID];
    [self updateMessage:qwmsg where:where];
}

- (void)sendAMessageDidFailure:(NSString *)UUID QWMessage:(QWPTPMessage*)qwmsg MessageModel:(MessageModel*)msg{
    /*
     // message比对上一条数据时间，小于时间，以上一条时间＋1
     // 如果大于，并小于轮询时间戳+max间隔，以message时间为准
     // 超过轮询时间戳+max间隔，以轮询时间戳+max间隔为准
     */
    
    //最后一条数据,要判断是不是提示信息，过滤掉
    MessageModel *last=[self getLastModel];
    
    //轮询时间戳
    NSDate *dt=nil;
    dt=[self getServerMaxInterval];
    
    DebugLog(@"sendAMessageDidFailure A:%@ B:%@ C:%@",msg.timestamp,last.timestamp,dt);
    if ([msg.timestamp compare:last.timestamp] <= 0) {
        msg.timestamp=[self dateAddOneSecond:last.timestamp];
    }
    else if(dt && [msg.timestamp compare:dt] > 0){
        msg.timestamp=dt;
    }
    
    //修改状态
    msg.sended=MessageDeliveryState_Failure;//发送, 失败
    qwmsg.issend = StrFromInt(msg.sended);
    qwmsg.timestamp = [NSString stringWithFormat:@"%.0f",[msg.timestamp timeIntervalSince1970]*1000.f];
    //    qwmsg=(QWPTPMessage*)[self buildQWMessageFromMessage:msg];
    
    //更新db
    NSString *where=[NSString stringWithFormat:@"UUID = '%@'",UUID];
    [self updateMessage:qwmsg where:where];
}

#pragma mark MessageModel->PTPCreate
- (PTPCreate *)buildPTPCreateFromMessage:(MessageModel *)model {
    PTPCreate *mm = [PTPCreate new];
    mm.token = QWGLOBALMANAGER.configure.userToken;
    mm.sessionId = self.sessionID;
    mm.UUID = model.UUID;
    
    ContentJson *contentJson = [ContentJson new];
    
    PharMsgModel *pharMsgModel = [PharMsgModel getObjFromDBWithKey:self.oID];
    if(!pharMsgModel)
    pharMsgModel = [[PharMsgModel alloc] init];
    switch (model.messageMediaType) {
        case MessageMediaTypeText:
        mm.contentType = @"TXT";
        contentJson.content = model.text;
        pharMsgModel.content = model.text;
        break;
        case MessageMediaTypePhoto:
        mm.contentType = @"IMG";
        contentJson.imgUrl = model.richBody;
        pharMsgModel.content = @"[图片]";
        break;
        /////
        case MessageMediaTypeLocation:
        mm.contentType = @"POS";
        contentJson.desc = model.text;
        contentJson.lon = [NSString stringWithFormat:@"%f",model.location.coordinate.longitude];
        contentJson.lat = [NSString stringWithFormat:@"%f",model.location.coordinate.latitude];;
        pharMsgModel.content = @"[位置]";
        break;
        case MessageMediaTypeActivity:
        {
            mm.contentType = @"ACT";
            //            contentJson.imgUrl = model.richBody;
            contentJson.actId = model.richBody;
            contentJson.actImgUrl = model.activityUrl;
            contentJson.actTitle = model.title;
            contentJson.actContent = model.text;
            pharMsgModel.content = @"[活动]";
            
            break;
        }
        
        case MessageMediaTypeMedicine:
        {
            mm.contentType = @"PRO";
            //            contentJson.imgUrl = model.richBody;
            contentJson.name = model.text;
            contentJson.id = model.richBody;
            contentJson.imgUrl = model.activityUrl;
            
            pharMsgModel.content = @"[药品]";
            break;
        }
        case MessageMediaTypeStoreMedicine:
        {
            mm.contentType = @"MPRO";
            contentJson.name = model.text;
            contentJson.id = model.richBody;
            contentJson.imgUrl = model.activityUrl;
            contentJson.spec = model.spec;
            contentJson.branchId = model.branchId;
            contentJson.branchProId = model.branchProId;
            pharMsgModel.content = @"[药品]";
            break;
        }
        case MessageMediaTypeMedicineCoupon:
        {
            mm.contentType = @"PRO";
       
            contentJson.name = model.text;
            contentJson.id = model.richBody;
            contentJson.imgUrl = model.activityUrl;
            
            if (model.subTitle.length) {
                contentJson.pmtLabe=model.subTitle;
                contentJson.pmtId=model.otherID;
            }
            
            pharMsgModel.content = @"[药品]";
            break;
        }
        case MessageMediaTypeMedicineSpecialOffers:
        {
            mm.contentType = @"PMT";
            //            contentJson.imgUrl = model.richBody;
            contentJson.content = model.text;
            contentJson.title = model.title;
            contentJson.id = model.richBody;
            contentJson.imgUrl = model.activityUrl;
            contentJson.branchLogo = model.thumbnailUrl;
            contentJson.groupId = model.otherID;
            pharMsgModel.content = @"[活动]";
            break;
        }
        case MessageMediaTypeCoupon:
        {
            mm.contentType = @"COU";
            contentJson.groupId=model.title;
            contentJson.groupName=model.subTitle;
            contentJson.couponTag=model.text;
            contentJson.couponValue=model.richBody;
            contentJson.couponId=model.otherID;
            contentJson.scope=model.style;
            contentJson.begin=model.arrList.firstObject;
            contentJson.end=model.arrList.lastObject;
            contentJson.imgUrl=model.thumbnailUrl;
            contentJson.top=model.isMarked?@"1":@"0";
            pharMsgModel.content = @"[优惠]";
            break;
        }
        case MessageMediaTypeVoice:
        {
            mm.contentType = @"SPE";
            contentJson.duration = model.voiceDuration;
            contentJson.speUrl = model.voiceUrl;
            contentJson.platform = @"IOS";
            contentJson.speText=@"[语音]";
            break;
        }
        
     
        default:
            break;
    }
    pharMsgModel.branchId = self.oID;
    pharMsgModel.latestTime =[NSString stringWithFormat:@"%@",model.timestamp] ;
    pharMsgModel.title = self.shopName;
    pharMsgModel.timestamp =[NSString stringWithFormat:@"%.0f",[ model.timestamp timeIntervalSince1970]];;
    pharMsgModel.issend = [NSString stringWithFormat:@"%ld",(long)MessageDeliveryState_Delivering];
    pharMsgModel.UUID = model.UUID;
    pharMsgModel.type = @"3";
    pharMsgModel.formatShowTime = [QWGLOBALMANAGER updateFirstPageTimeDisplayer:[NSDate dateWithTimeIntervalSince1970:[pharMsgModel.timestamp doubleValue]]];
    [PharMsgModel updateObjToDB:pharMsgModel WithKey:pharMsgModel.branchId];
    mm.contentJson = [self toJSONStr:[contentJson dictionaryModel]];
    return mm;
}
#pragma mark 获取图片UUID数组
- (NSArray*)getImages{
    NSString    *sID,*uID;
    sID=self.sessionID;
    uID=self.oID;
    NSString* where = [NSString stringWithFormat:@"messagetype = '%d' AND sendname = '%@' AND recvname = '%@'",(int)MessageMediaTypePhoto,sID,uID];
    
    NSArray *array = [QWPTPMessage getArrayFromDBWithWhere:where WithorderBy:@"timestamp ASC"];
    
    NSMutableArray *tmp=[[NSMutableArray alloc]initWithCapacity:array.count];
    for (QWPTPMessage *mm in array) {
        if( [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:mm.UUID]) {
            [tmp addObject:mm.UUID];
        }
    }
    
    return tmp;
}
#pragma mark DB
//db数据重置，比如所有发送中状态改发送失败
- (void)DBDataInit{
    NSString *where = [NSString stringWithFormat:@"issend = '%d'",(int)MessageDeliveryState_Delivering];
    NSString *set = [NSString stringWithFormat:@"issend = '%d'",(int)MessageDeliveryState_Failure];
    [QWPTPMessage updateSetToDB:set WithWhere:where];
    
    where = [NSString stringWithFormat:@"isReceiv = '%d' ",(int)MessageFileState_Downloading];
    set = [NSString stringWithFormat:@"isReceiv = '%d'",(int)MessageFileState_Failure];
    [QWPTPMessage updateSetToDB:set WithWhere:where];
}
- (NSArray *)getDataFromDB{
    MessageModel *modOffset=[self getOffsetModel];
    NSString    *timestamp;
    NSString    *sID,*uID;
    sID=self.sessionID;
    uID=self.oID;
    
    NSString* where = [NSString stringWithFormat:@"sendname = '%@' AND recvname = '%@'",sID,uID];
    
    //如果有设置偏移量，获取偏移量的id和时间戳
    if (modOffset != nil && modOffset.UUID) {
        timestamp = [NSString stringWithFormat:@"%.0f",[modOffset.timestamp timeIntervalSince1970]*1000.f];
        where = [NSString stringWithFormat:@"timestamp < '%@' and (sendname = '%@' AND recvname = '%@')",timestamp,sID,uID];
    }
    
    DebugLog(@"节点：%@ | where:%@ ",modOffset.text,where);
    NSArray *array = [QWPTPMessage getArrayFromDBWithWhere:where WithorderBy:@"timestamp DESC" offset:0 count:self.pageSize];
    return [self reverseArray:array];
}

- (BOOL)createMessage:(QWMessage*)model{
    QWPTPMessage *msg=[[QWPTPMessage alloc]initWithMessage:model];
    NSError *error=nil;
    error = [QWPTPMessage saveObjToDB:msg];
    if (error) {
        return NO;
    }
    return YES;
}

- (BOOL)updateMessage:(QWMessage*)model{
    QWPTPMessage *msg=[[QWPTPMessage alloc]initWithMessage:model];
    return [msg updateToDB];
}

- (BOOL)updateMessage:(QWMessage*)model where:(NSString*)where{
    QWPTPMessage *msg=[[QWPTPMessage alloc]initWithMessage:model];
    
    BOOL aa = [QWPTPMessage updateToDB:msg where:where];
    
    return aa;
}

- (BOOL)deleteMessage:(QWMessage*)model{
    QWPTPMessage *msg=[[QWPTPMessage alloc]initWithMessage:model];
    return [msg deleteToDB];
}

- (BOOL)deleteMessagesByType:(MessageBodyType)type{
    [super deleteMessagesByType:type];
    NSString *where;
    
    where = [NSString stringWithFormat:@"messagetype = '%d'",type];
    NSError *err=[QWPTPMessage deleteObjFromDBWithWhere:where];
    if (err==nil) {
        return YES;
    }
    return NO;
}

+ (QWMessage*)checkMessageStateByID:(NSString*)sid{
    NSString *order=@"timestamp desc ";//LIMIT 1
    NSString* where = nil;
    QWPTPMessage* model=nil;
    where=[NSString stringWithFormat:@"sendname = '%@' ", sid];
    //    DebugLog(@"\nwhere:%@",where);
    model=[QWPTPMessage getObjFromDBWithWhere:where WithorderBy:order];
    
    return [MessageCenter checkMessageState:model];
    
}

//从DB删除所有该id
+ (BOOL)deleteMessagesByID:(NSString*)sid{
    NSString* where = nil;
    where=[NSString stringWithFormat:@"sendname = '%@' ", sid];
    return [QWPTPMessage deleteObjFromDBWithWhere:where];
}

#pragma mark  数据整理
//api model转message model
- (BOOL)checkMessagesFromAPI:(id)mode type:(IMListType)lType{
    //    DebugLog(@"VVVVVVVVVVVVVVVVVVVVVVVVVV 准备处理数据");
    //  需要区分两端数据格式
    NSArray *arrDetails=nil;
    NSInteger num=0;
    if([mode isKindOfClass:[CustomerSessionDetailList class]]){
        CustomerSessionDetailList *model=mode;
        arrDetails=model.details;
        num=model.details.count;
    }
    else if([mode isKindOfClass:[PharSessionDetailList class]]){
        PharSessionDetailList *model=mode;
        arrDetails=model.details;
        num=model.details.count;
    }
    
    NSMutableArray *arrItems = [[NSMutableArray alloc]initWithCapacity:num];
    NSMutableArray *arrHistory = [[NSMutableArray alloc]initWithCapacity:num];
    
    
    NSInteger SYSMessageCount = 0;
    
    BOOL hadNewMsg=NO;
    for(SessionDetailVo *detail in arrDetails)
    {
        //API数据转DB格式，并判断是否DB重复数据，不是返回db数据格式
        QWPTPMessage *msg = (QWPTPMessage*)[self buildQWMessageFromAPIModel:mode detail:detail];
        if (msg==nil)
        continue ;
        else
        hadNewMsg=YES;
        
        //系统消息
        if (msg.messagetype.integerValue==MessageMediaTypeFooter) {
            SYSMessageCount++;
        }
        
        //新数据存DB
        BOOL OK = NO;
        OK = [self createMessage:msg];
        
        //db数据格式转呈现格式
        MessageModel *message = [self buildMessageFromQWMessage:msg];
        
        if (OK && message) {
            if (lType==IMListPolling) { //轮询数据加队列尾部
                [self messagesQueue:message reset:NO];
            }
            else if (lType==IMListHistory){//历史数据放历史数组
                [arrHistory addObject:message];
            }
        }
        
        if ([detail.readStatus isEqualToString:@"Y"]) {
            continue;
        }
        
        // change  en d
        [arrItems addObject:detail.detailId];
    }
    
    
    //消息设置已读
    [self readMessages:arrItems containSystem:SYSMessageCount];
    
    
    //全局拉的数据有新内容，重置数据
    if (lType==IMListAll){
        if (hadNewMsg || ![self hadMessages]) {
            NSArray *tmp=[self getCurrentMessagesFromDB];
            [self messagesQueue:tmp reset:YES];
        }
    }
    else if (lType==IMListHistory) { //历史数据加入消息队列
        if (arrHistory.count>0) {
            [self messagesHistory:arrHistory];
        }
        else if(num>0){
            //
        }
    }
    
    //    DebugLog(@"AAAAAAAAAAAAAAAAAAAAAAAAAA 结束处理数据");
    
    return hadNewMsg;
}

//APIModel->QWPTPMessage
- (QWPTPMessage *)buildQWMessageFromAPIModel:(id)mode detail:(SessionDetailVo*)detail{
    
    
    QWPTPMessage *qwmsg = [[QWPTPMessage alloc] init];
    qwmsg.UUID = [NSString stringWithFormat:@"%@",detail.detailId];
    
    //检查db里是否有该数据
    if([QWPTPMessage getObjFromDBWithKey:qwmsg.UUID]) {
        return nil;
    }
    
    qwmsg.timestamp = [NSString stringWithFormat:@"%.0f",[detail.createTime doubleValue]];
    qwmsg.isRead = @"1";
    qwmsg.sendname = self.sessionID;
    qwmsg.recvname = self.oID;
    qwmsg.issend = StrFromInt(MessageDeliveryState_Delivered);
    qwmsg.download = StrFromInt(MessageFileState_Pending);
    
    if (self.type==IMTypePTPClient) {
        CustomerSessionDetailList* model=mode;
        if([detail.type isEqualToString:@"BC"]) {
            qwmsg.direction = StrFromInt(MessageTypeReceiving);
            qwmsg.avatorUrl = model.pharAvatarUrl;
            
        }else{
            qwmsg.direction = StrFromInt(MessageTypeSending);
            qwmsg.avatorUrl = QWGLOBALMANAGER.configure.avatarUrl;
        }
    }
    else if(self.type==IMTypePTPStore) {
        PharSessionDetailList *model=mode;
        if([detail.type isEqualToString:@"BC"]) {
            qwmsg.direction = StrFromInt(MessageTypeSending);
            qwmsg.avatorUrl = QWGLOBALMANAGER.configure.avatarUrl;
            
        }else{
            qwmsg.direction = StrFromInt(MessageTypeReceiving);
            qwmsg.avatorUrl = model.customerAvatarUrl;
        }
    }
    
    
    
    ContentJson *contentJson = [ContentJson parse:[detail.contentJson jsonStringToDict]];
    if([detail.contentType isEqualToString:@"TXT"]) {
        qwmsg.messagetype = [NSString stringWithFormat:@"%lu",(unsigned long)MessageMediaTypeText];
        qwmsg.body = contentJson.content;
    }
    else if([detail.contentType isEqualToString:@"IMG"]) {
        qwmsg.messagetype = [NSString stringWithFormat:@"%lu",(unsigned long)MessageMediaTypePhoto];
        qwmsg.richbody = contentJson.imgUrl;
    }
    else if ([detail.contentType isEqualToString:@"POS"]){
        qwmsg.messagetype = [NSString stringWithFormat:@"%lu",(unsigned long)MessageMediaTypeLocation];
        qwmsg.star = [NSString stringWithFormat:@"%@,%@",contentJson.lat,contentJson.lon];
        qwmsg.body = contentJson.desc;
    }
    else if ([detail.contentType isEqualToString:@"ACT"]) {
        qwmsg.messagetype = [NSString stringWithFormat:@"%lu",(unsigned long)MessageMediaTypeActivity];
        qwmsg.star = contentJson.actTitle;
        qwmsg.body = contentJson.actContent;
        qwmsg.imgUrl = contentJson.actImgUrl;
        qwmsg.richbody = contentJson.actId;
        if(!contentJson.actId) {
            qwmsg.richbody = contentJson.imgUrl;
        }
    }
    //药品／优惠商品 yqy
    else if ([detail.contentType isEqualToString:@"PRO"]) {
        qwmsg.messagetype = [NSString stringWithFormat:@"%lu",(unsigned long)MessageMediaTypeMedicine];
        qwmsg.body = contentJson.name;
        qwmsg.imgUrl = contentJson.imgUrl;
        qwmsg.richbody = contentJson.id;
        
        if (contentJson.pmtLabe.length) {
            qwmsg.messagetype = [NSString stringWithFormat:@"%lu",(unsigned long)MessageMediaTypeMedicineCoupon];
            qwmsg.title = contentJson.pmtLabe;
            qwmsg.fileUrl = contentJson.pmtId;
        }
    }
    else if ([detail.contentType isEqualToString:@"MPRO"]) {
        qwmsg.messagetype = [NSString stringWithFormat:@"%lu",(unsigned long)MessageMediaTypeStoreMedicine];
        qwmsg.body = contentJson.name;
        qwmsg.imgUrl = contentJson.imgUrl;
        qwmsg.richbody = contentJson.id;
        qwmsg.spec = contentJson.spec;
        qwmsg.branchId = contentJson.branchId;
        qwmsg.branchProId = contentJson.branchProId;
        
        if (contentJson.pmtLabe.length) {
            qwmsg.messagetype = [NSString stringWithFormat:@"%lu",(unsigned long)MessageMediaTypeMedicineCoupon];
            qwmsg.title = contentJson.pmtLabe;
            qwmsg.fileUrl = contentJson.pmtId;
        }
    }
    //优惠券
    else if ([detail.contentType isEqualToString:@"COU"]) {
        qwmsg.messagetype = [NSString stringWithFormat:@"%lu",(unsigned long)MessageMediaTypeCoupon];
        qwmsg.title = contentJson.groupId;
        qwmsg.body = contentJson.groupName;
        qwmsg.star = contentJson.couponTag;
        qwmsg.richbody = contentJson.couponValue;
        qwmsg.fileUrl = contentJson.couponId;
        qwmsg.fromTag = contentJson.scope.intValue;
        qwmsg.imgUrl = contentJson.imgUrl;
        qwmsg.list = [NSString stringWithFormat:@"%@;%@",contentJson.begin,contentJson.end];
        qwmsg.tags = contentJson.top.integerValue;
    }
    //优惠活动
    else if ([detail.contentType isEqualToString:@"PMT"]) {
        qwmsg.messagetype = [NSString stringWithFormat:@"%lu",(unsigned long)MessageMediaTypeMedicineSpecialOffers];
        qwmsg.star = contentJson.title;
        qwmsg.imgUrl = contentJson.imgUrl;
        qwmsg.richbody = contentJson.id;
        qwmsg.body = contentJson.content;
    }
    else if ([detail.contentType isEqualToString:@"SYS"])
    {
        //             msg.direction = [NSString stringWithFormat:@"%ld",(long)XHBubbleMessageTypeReceiving];
        if([contentJson.type integerValue] == 1) {
            qwmsg.messagetype = [NSString stringWithFormat:@"%lu",(unsigned long)MessageMediaTypeHeader];
            
            qwmsg.body = contentJson.content;
            
        }else if([contentJson.type integerValue] == 2) {
            qwmsg.messagetype = [NSString stringWithFormat:@"%lu",(unsigned long)MessageMediaTypeLine];
            
            qwmsg.body = contentJson.content;
            
        }else if ([contentJson.type integerValue] == 3) {
            qwmsg.messagetype = [NSString stringWithFormat:@"%lu",(unsigned long)MessageMediaTypePhone];
            
            qwmsg.body = contentJson.content;
        }else if ([contentJson.type integerValue] == 4) {
            
            //            SYSMessageCount ++;
            qwmsg.messagetype = [NSString stringWithFormat:@"%lu",(unsigned long)MessageMediaTypeFooter];
            
            qwmsg.body = contentJson.content;
        }
    }
   
    else if([detail.contentType isEqualToString:@"SPE"]){
        DebugLog(@"***************  收到语音 *************** %@",detail);
        qwmsg.messagetype = StrFromInt(MessageMediaTypeVoice);
        qwmsg.duration = contentJson.duration;
        qwmsg.richbody = nil;
        qwmsg.fileUrl = contentJson.speUrl;
        //        qwmsg.
    }
    //end
    
    return qwmsg;
}
@end
