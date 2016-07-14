//
//  XPMessageCenter.m
//  APP
//
//  Created by Yan Qingyang on 15/6/30.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "XPMessageCenter.h"
#import "ConsultModel.h"

@implementation XPMessageCenter
- (void)sendPhotosMessage:(MessageModel* )model success:(IMSuccessBlock)success failure:(IMFailureBlock)failure  uploadProgressBlock:(void (^)(MessageModel* target, float progress ))uploadProgressBlock
{
    NSData *data=nil;
    
    if (model.messageMediaType==MessageMediaTypePhoto) {
        UIImage *img=model.photo;
        if (img) {
            data=UIImageJPEGRepresentation(img, 1.0);
        }
        
    }
    
    
    if (!data ) {
        if (failure) {
            failure(nil);
        }
        return;
    }
    
    //转QWmodel保存DB
//    model.sended=MessageDeliveryState_Delivering;//待发送
    QWMessage* msg=[self buildQWMessageFromMessage:model];
//    msg.issend=StrFromInt(model.sended);
//    [self createMessage:msg];
//    
//    //加入数据队列
//    [self messagesQueue:model reset:NO];
    
    //刷新界面
    [self showCurrentMessages:IMListAdd successData:nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
    
    if (model.messageMediaType==MessageMediaTypePhoto) {
        params[@"type"] = @(4);
        
        
        
        [self uploadImage:data params:params success:^(id responseObj) {
            id res=responseObj[@"body"];
            if (res==nil) {
                res=responseObj;
            }
            uploadFile *obj = [uploadFile parse:res];
            if([obj.apiStatus intValue] == 0){
                model.richBody=obj.url;
                NSString *uuid=model.UUID;
                DebugLog(@"图片发送1:%@",model.UUID);
                [self sendAMessage:model success:^(id successObj) {
                    if (model.messageMediaType == MessageMediaTypePhoto  && [successObj isKindOfClass:[NSString class]]) {
                        DebugLog(@"图片发送2:%@ UUID:%@",successObj,model.UUID);
                        UIImage *imagedata =  [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:uuid] ;
                        [[SDImageCache sharedImageCache] storeImage:imagedata forKey:successObj];
                        
                        if (success) {
                            success(successObj);
                        }
                    }
                    
                } failure:failure];
            }else  {
                [self sendAMessageDidFailure:model.UUID QWMessage:msg MessageModel:model];
                if (failure)
                    failure(nil);
            }
        } failure:^(HttpException *e) {
            [self sendAMessageDidFailure:model.UUID QWMessage:msg MessageModel:model];
            if (failure) {
                failure(e);
            }
        } uploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            double pre=(double)totalBytesWritten/(double)totalBytesExpectedToWrite;
            //            DebugLog(@"上传图片:%f",pre);
            if (uploadProgressBlock) {
                uploadProgressBlock(model,pre);
            }
        }];
    }
    
    
}

#pragma mark - API
- (void)pollMessages
{
    if (self.type==IMTypeXPClient) {
        [ChatAPI XPClientPollMessagesWithID:self.oID success:^(CustomerConsultDetailList *model) {
            //        DebugLog(@"API new:%@",model.details);
            if ([self isClose]) {
                return ;
            }
            if (model.serverTime && model.serverTime.integerValue>0) {
                self.serverTime=model.serverTime.doubleValue/1000.0;
            }
            
            [self checkNoDataTimes:model.details.count];
            [self checkMessagesFromAPI:model type:IMListPolling];
            if (model.details.count)
                [self showCurrentMessages:IMListPolling successData:model];
            
        } failure:^(HttpException *e) {
            //
        }];
    }
    else if(self.type==IMTypeXPStore){
        [ChatAPI XPStorePollMessagesWithID:self.oID success:^(PharConsultDetail *model) {
            if ([self isClose]) {
                return ;
            }
            if (model.serverTime && model.serverTime.integerValue>0) {
                self.serverTime=model.serverTime.doubleValue/1000.0;
            }
            
            [self checkNoDataTimes:model.details.count];
            [self checkMessagesFromAPI:model type:IMListPolling];
            if (model.details.count)
                [self showCurrentMessages:IMListPolling successData:model];
        } failure:^(HttpException *e) {
            //
        }];
    }
    
}

- (void)getAllMessages
{
    if (self.type==IMTypeXPClient) {
        [ChatAPI XPClientAllMessagesWithID:self.oID success:^(CustomerConsultDetailList *model) {
            if ([self isClose]) {
                return ;
            }
            if (model.serverTime && model.serverTime.integerValue>0) {
                self.serverTime=model.serverTime.doubleValue/1000.0;
            }
            
            [self checkMessagesFromAPI:model type:IMListAll];
            [self setOffset:0];
            [self showCurrentMessages:IMListAll successData:model];
            
            
        } failure:^(HttpException *e) {
            
        }];
    }
    else if(self.type==IMTypeXPStore){
        [ChatAPI XPStoreAllMessagesWithID:self.oID success:^(PharConsultDetail *model) {
            if ([self isClose]) {
                return ;
            }
            if (model.serverTime && model.serverTime.integerValue>0) {
                self.serverTime=model.serverTime.doubleValue/1000.0;
            }
            
            [self checkMessagesFromAPI:model type:IMListAll];
            [self setOffset:0];
            [self showCurrentMessages:IMListAll successData:model];
        } failure:^(HttpException *e) {
            //
        }];
    }
    
}



- (void)getHistoryMessages:(IMHistoryBlock)block success:(IMSuccessBlock)success failure:(IMFailureBlock)failure{
    //    MessageModel *modOffset=[self getOffsetModel];
    //
    //    GetByPharModelR *mm = [GetByPharModelR new];
    //    mm.branchId = self.oID;
    //    mm.token = QWGLOBALMANAGER.configure.userToken;
    //    mm.point = @"0";
    //    mm.view = StrFromInt(self.pageSize);
    //    mm.viewType = @"-1";
    //
    //    if (modOffset != nil) {
    //        mm.point = [NSString stringWithFormat:@"%.0f",[modOffset.timestamp timeIntervalSince1970] * 1000.0f];
    //        //        DebugLog(@"%@",modOffset.title);
    //    }
    //
    //    [ChatAPI ClientAllMessagesWithParams:mm success:^(CustomerSessionDetailList *responModel) {
    //        DebugLog(@"拉历史 x: %d",(int)responModel.details.count);
    //        if ([self isClose]) {
    //            return ;
    //        }
    //        if (responModel.sessionId) {
    //            self.sessionID=StrFromObj(responModel.sessionId);
    //        }
    //
    //        BOOL hadNew = [self checkMessagesFromAPI:responModel type:IMListHistory];
    //        [self setOffset:0];
    //        if (block) {
    //            if (hadNew) {
    //                block(YES);
    //                if (success) {
    //                    success(nil);
    //                }
    //            }
    //            else if(responModel.details.count>0){
    //                [self showHistoryMessages:block success:success];
    //            }
    //            else {
    //                block(NO);
    //                if (success) {
    //                    success(nil);
    //                }
    //            }
    //        }
    //
    //    } failure:^(HttpException *e) {
    //        if (failure) {
    //            failure(e);
    //        }
    //
    //    }];
}

- (void)sendAMessage:(MessageModel*)model success:(IMSuccessBlock)success failure:(IMFailureBlock)failure{
    QWXPMessage* qwmsg=(QWXPMessage*)[self buildQWMessageFromMessage:model];
    XPCreate *mm = [self buildXPCreateFromMessage:model];
    
    
    ++self.sendingCount;
    [ChatAPI XPSendAMessageWithParams:mm success:^(ConsultDetailCreateModel *responModel) {
        self.sendingCount=self.sendingCount-1;
        if([responModel.apiStatus integerValue] == 0) {
            
            //DebugLog(@"responModel %@",responModel);
            qwmsg.UUID=StrFromObj(responModel.detailId);
            qwmsg.timestamp=[NSString stringWithFormat:@"%.0f",[responModel.createTime doubleValue]];
            
            [self sendAMessageDidSuccess:mm.UUID QWMessage:qwmsg MessageModel:model];
            if (success) {
                success(qwmsg.UUID);
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

- (void)readMessages:(NSArray*)arrItems containSystem:(NSInteger)containSystem{
    if (arrItems==nil || arrItems.count==0) {
        return;
    }
    
    NSString *strItems = [self getReadIDs:arrItems];
    
    XPRead *modelR = [XPRead new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.consultId = self.oID;
    modelR.detailIds = strItems;
    
    [ChatAPI XPReadMessagesWithParams:modelR success:^(ConsultModel *responModel) {
        //
    } failure:^(HttpException *e) {
        //
    }];
}

- (void)deleteAMessage:(MessageModel*)model success:(IMSuccessBlock)success failure:(IMFailureBlock)failure{
    
    XPRemove *mode = [XPRemove new];
    mode.consultId = self.oID;
    mode.detailId = model.UUID;//detailId
    mode.token = QWGLOBALMANAGER.configure.userToken;
    
    [ChatAPI XPDeleteAMessageWithParams:mode success:^(id obj) {
        
    } failure:^(HttpException *e) {
        //
    }];
}
#pragma mark  发送成功/失败
- (void)sendAMessageDidSuccess:(NSString *)UUID QWMessage:(QWXPMessage*)qwmsg MessageModel:(MessageModel*)msg{
    msg.UUID=StrFromObj(qwmsg.UUID);
    
    //修改状态
    msg.sended=MessageDeliveryState_Delivered;
    qwmsg.issend = StrFromInt(msg.sended);//发送, 成功
    //更新db
    NSString *where=[NSString stringWithFormat:@"UUID = '%@'",UUID];
    [self updateMessage:qwmsg where:where];
}

- (void)sendAMessageDidFailure:(NSString *)UUID QWMessage:(QWXPMessage*)qwmsg MessageModel:(MessageModel*)msg{
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
    //    qwmsg=(QWXPMessage*)[self buildQWMessageFromMessage:msg];
    
    //更新db
    NSString *where=[NSString stringWithFormat:@"UUID = '%@'",UUID];
    [self updateMessage:qwmsg where:where];
}

#pragma mark MessageModel->XPCreate
- (XPCreate*)buildXPCreateFromMessage:(MessageModel *)model {
    XPCreate *mm = [XPCreate new];
    mm.token = QWGLOBALMANAGER.configure.userToken;
    mm.consultId = self.oID;
    mm.UUID = model.UUID;
    
    ContentJson *contentJson = [ContentJson new];
    
    PharMsgModel *pharMsgModel = [PharMsgModel getObjFromDBWithKey:self.oID];
    if(!pharMsgModel)
        pharMsgModel = [[PharMsgModel alloc] init];
    switch (model.messageMediaType) {
        case MessageMediaTypeText:
        {
            mm.contentType = @"TXT";
            contentJson.content = model.text;
            pharMsgModel.content = model.text;
            break;
        }
        case MessageMediaTypePhoto:
        {
            mm.contentType = @"IMG";
            contentJson.imgUrl = model.richBody;
            pharMsgModel.content = @"[图片]";
            break;
        }
        case MessageMediaTypeLocation:
        {
            mm.contentType = @"POS";
            contentJson.desc = model.text;
            contentJson.lon = [NSString stringWithFormat:@"%f",model.location.coordinate.longitude];
            contentJson.lat = [NSString stringWithFormat:@"%f",model.location.coordinate.latitude];;
            pharMsgModel.content = @"[位置]";
            break;
        }
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
            //            contentJson.imgUrl = model.richBody;
            contentJson.name = model.text;
            contentJson.id = model.richBody;
            contentJson.imgUrl = model.activityUrl;
            pharMsgModel.content = @"[药品]";
            contentJson.spec = model.spec;
            contentJson.branchProId = model.branchProId;
            contentJson.branchId = model.branchId;
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
    pharMsgModel.formatShowTime = [QWGLOBALMANAGER updateFirstPageTimeDisplayer:[NSDate dateWithTimeIntervalSince1970:[pharMsgModel.timestamp doubleValue]]];
    [PharMsgModel updateObjToDB:pharMsgModel WithKey:pharMsgModel.branchId];
    mm.contentJson = [self toJSONStr:[contentJson dictionaryModel]];
    return mm;
}
#pragma mark 获取图片UUID数组
- (NSArray*)getImages{
    NSString    *sID,*uID;
    sID=self.oID;
    uID=self.oID;
    NSString* where = [NSString stringWithFormat:@"messagetype = '%d' AND sendname = '%@' AND recvname = '%@'",(int)MessageMediaTypePhoto,sID,uID];
    
    NSArray *array = [QWXPMessage getArrayFromDBWithWhere:where WithorderBy:@"timestamp asc"];
    
    NSMutableArray *tmp=[[NSMutableArray alloc]initWithCapacity:array.count];
    for (QWXPMessage *mm in array) {
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
    [QWXPMessage updateSetToDB:set WithWhere:where];
    
    where = [NSString stringWithFormat:@"isReceiv = '%d' ",(int)MessageFileState_Downloading];
    set = [NSString stringWithFormat:@"isReceiv = '%d'",(int)MessageFileState_Failure];
    [QWXPMessage updateSetToDB:set WithWhere:where];
}

- (NSArray *)getDataFromDB{
    MessageModel *modOffset=[self getOffsetModel];
    NSString    *timestamp;
    
    NSString* where = [NSString stringWithFormat:@"sendname = '%@' AND recvname = '%@'",self.oID,self.oID];
    
    //如果有设置偏移量，获取偏移量的id和时间戳
    if (modOffset != nil && modOffset.UUID) {
  
        timestamp = [NSString stringWithFormat:@"%.0f",[modOffset.timestamp timeIntervalSince1970]*1000.f];
        where = [NSString stringWithFormat:@"timestamp < '%@' AND (sendname = '%@' AND recvname = '%@')",timestamp,self.oID,self.oID];
    }
    
    NSArray *array = [QWXPMessage getArrayFromDBWithWhere:where WithorderBy:@"timestamp desc" offset:0 count:self.pageSize];
    return [self reverseArray:array];
}
- (BOOL)createMessage:(QWMessage*)model{
    QWXPMessage *msg=[[QWXPMessage alloc]initWithMessage:model];
    NSError *error=nil;
    error = [QWXPMessage saveObjToDB:msg];
    if (error) {
        return NO;
    }
    return YES;
}

- (BOOL)updateMessage:(QWMessage*)model{
    QWXPMessage *msg=[[QWXPMessage alloc]initWithMessage:model];
    return [msg updateToDB];
}

- (BOOL)updateMessage:(QWMessage*)model where:(NSString*)where{
    QWXPMessage *msg=[[QWXPMessage alloc]initWithMessage:model];
    return [QWXPMessage updateToDB:msg where:where];
}

- (BOOL)deleteMessage:(QWMessage*)model{
    QWXPMessage *msg=[[QWXPMessage alloc]initWithMessage:model];
    return [msg deleteToDB];
}

- (BOOL)deleteMessagesByType:(MessageBodyType)type{
    [super deleteMessagesByType:type];
    NSString *where;
    
    where = [NSString stringWithFormat:@"messagetype = '%d'",type];
    NSError *err=[QWXPMessage deleteObjFromDBWithWhere:where];
    if (err==nil) {
        return YES;
    }
    return NO;
}

+ (QWMessage*)checkMessageStateByID:(NSString*)cid{
    NSString *order=@"timestamp desc ";
    NSString* where = nil;
    id obj=nil;
    where=[NSString stringWithFormat:@"sendname = '%@' ", cid];

    obj=[QWXPMessage getObjFromDBWithWhere:where WithorderBy:order];
    return [MessageCenter checkMessageState:obj];
}

//从DB删除所有该id
+ (BOOL)deleteMessagesByID:(NSString*)cid{
    NSString* where = nil;
    where=[NSString stringWithFormat:@"sendname = '%@' ", cid];
    return [QWXPMessage deleteObjFromDBWithWhere:where];
}

- (void)addMessagePre:(MessageModel*)model{
    //    model.sended=MessageDeliveryState_Pending;//待发送
    QWMessage* msg=[self buildQWMessageFromMessage:model];
    msg.issend=StrFromInt(model.sended);
    [self createMessage:msg];
    
    //加入数据队列
    [self messagesQueue:model reset:NO];
    
    //刷新界面
    [self showCurrentMessages:IMListAdd successData:nil];
    
    if (_arrPrepare==nil) {
        _arrPrepare=[[NSMutableArray alloc]initWithCapacity:4];
    }
    
    [_arrPrepare addObject:model];
}
#pragma mark  数据整理
//api model转message model
- (BOOL)checkMessagesFromAPI:(id)mode type:(IMListType)lType{
    NSArray *arrDetails=nil;
    NSInteger num=0;
    
    if([mode isKindOfClass:[CustomerConsultDetailList class]]){
        CustomerConsultDetailList *model=mode;
        arrDetails=model.details;
        num=model.details.count;
    }
    else if([mode isKindOfClass:[PharConsultDetail class]]){
        PharConsultDetail *model=mode;
        arrDetails=model.details;
        num=model.details.count;
    }
    else return NO;
    
    if (self.pharConsultBlock!=nil) {
        self.pharConsultBlock(mode);
    }
    
    NSMutableArray *arrItems = [[NSMutableArray alloc]initWithCapacity:num];
    
    BOOL hadNewMsg=NO;
    for(ConsultDetail *detail in arrDetails)
    {
        //        QWXPMessage *msg = [[QWXPMessage alloc] init];
        //        msg.UUID = [NSString stringWithFormat:@"%@",detail.detailId];
        QWXPMessage *msg = (QWXPMessage*)[self buildQWMessageFromAPIModel:mode detail:detail];
        //检查db里是否有该数据
        if(msg==nil) {
            continue;
        }
        else hadNewMsg=YES;
        
        BOOL OK = NO;
        OK = [self createMessage:msg];
        
        MessageModel *message = [self buildMessageFromQWMessage:msg];
        if (OK && message) {
            if (lType==IMListPolling) {
                [self messagesQueue:message reset:NO];
            }
        }
        
        
        
        if ([detail.readStatus isEqualToString:@"Y"]) {
            continue;
        }
        
        // change  en d
        [arrItems addObject:detail.detailId];
    }
    
    
    //消息设置已读
    [self readMessages:arrItems containSystem:0];
    
    
    //全局拉的数据有新内容，重置数据
    //全局拉的数据有新内容，重置数据
    if (lType==IMListAll){
        if (hadNewMsg || ![self hadMessages]) {
            NSArray *tmp=[self getCurrentMessagesFromDB];
            [self messagesQueue:tmp reset:YES];
        }
    }
    
    //添加尾巴
    
    
    return hadNewMsg;
}

//APIModel->QWXPMessage
- (QWXPMessage *)buildQWMessageFromAPIModel:(id)mode detail:(ConsultDetail*)detail{
    
    QWXPMessage *qwmsg = [[QWXPMessage alloc] init];
    qwmsg.UUID = [NSString stringWithFormat:@"%@",detail.detailId];
    
    //检查db里是否有该数据
    if([QWXPMessage getObjFromDBWithKey:qwmsg.UUID]) {
        return nil;
    }
    
    qwmsg.timestamp = [NSString stringWithFormat:@"%.0f",[detail.createTime doubleValue]];
    qwmsg.isRead = @"1";
    qwmsg.sendname = self.oID;
    qwmsg.recvname = self.oID;
    qwmsg.issend = StrFromInt(MessageDeliveryState_Delivered);
    qwmsg.download = StrFromInt(MessageFileState_Pending);
    
    if (self.type==IMTypeXPClient) {
        CustomerConsultDetailList* model=mode;
        if([detail.type isEqualToString:@"BC"]) {
            qwmsg.direction = StrFromInt(MessageTypeReceiving);
            qwmsg.avatorUrl = model.pharAvatarUrl;
            
        }else{
            qwmsg.direction = StrFromInt(MessageTypeSending);
            qwmsg.avatorUrl = QWGLOBALMANAGER.configure.avatarUrl;
        }
    }
    else if(self.type==IMTypeXPStore) {
        PharConsultDetail *model=mode;
        if([detail.type isEqualToString:@"BC"]) {
            qwmsg.direction = StrFromInt(MessageTypeSending);
            qwmsg.avatorUrl = QWGLOBALMANAGER.configure.avatarUrl;
        }else{
            qwmsg.direction = StrFromInt(MessageTypeReceiving);
            qwmsg.avatorUrl = StrFromObj(model.pharAvatarUrl);

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
    //add  by yqy
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
        qwmsg.tags = contentJson.top.integerValue;
        qwmsg.list = [NSString stringWithFormat:@"%@;%@",contentJson.begin,contentJson.end];
    }
    //优惠活动
    else if ([detail.contentType isEqualToString:@"PMT"]) {
        qwmsg.messagetype = [NSString stringWithFormat:@"%lu",(unsigned long)MessageMediaTypeMedicineSpecialOffers];
        qwmsg.star = contentJson.title;
        qwmsg.imgUrl = contentJson.imgUrl;
        qwmsg.richbody = contentJson.id;
        qwmsg.body = contentJson.content;
        qwmsg.fileUrl = contentJson.branchLogo;
        qwmsg.title = contentJson.groupId;
    }
    //end
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
    
    return qwmsg;
}
@end
