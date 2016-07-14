//
//  ExpertMessageCenter.m
//  wenYao-store
//
//  Created by 李坚 on 16/3/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ExpertMessageCenter.h"

#import "SVProgressHUD.h"

@implementation ExpertMessageCenter{
    
    dispatch_source_t   pullCircleMessageTimer;
}

- (instancetype)init{
    if(self == [super init]){
        self.pageSize = 15;
        self.senderId = nil;
        self.recipientId = nil;
    }
    return self;
}

#pragma mark - 私聊列表 功能
//循环拉取砖家私聊列表GlobarManager调用
+ (void)pullAllExpertData{
    //拉取私聊数据
    [ExpertMessageCenter pollPrivateMessageExpertList];
}
/**
 *  私聊列表增量拉取
 *  V3.1 专家咨询列表私聊
 */
+ (void)pollPrivateMessageExpertList{
    
    ChatPointModelR *modelR = [ChatPointModelR new];
    modelR.token = QWGLOBALMANAGER.configure.expertToken;
    
    [ExpertAPI PMChatListPoll:modelR success:^(ChatPointList *responModel) {
        
        [IMChatPointVo saveObjToDBWithArray:responModel.sessions];
        [QWGLOBALMANAGER postNotif:NotiRefreshPrivateExpert data:responModel.sessions object:nil];

    } failure:^(HttpException *e) {
        
    }];
}

/**
 *  私聊列表全量拉取
 *  V3.1 专家咨询列表私聊
 */
+ (void)getAllPivateMessageExpertList{
    
    ChatPointModelR *modelR = [ChatPointModelR new];
    modelR.token = QWGLOBALMANAGER.configure.expertToken;
    modelR.point = 0;
    modelR.view  = 999;
    modelR.viewType = -1;
    
    [IMChatPointVo deleteAllObjFromDB];
    
    [ExpertAPI PMChatListAll:modelR success:^(ChatPointList *responModel) {
        
        [IMChatPointVo saveObjToDBWithArray:responModel.sessions];
        [QWGLOBALMANAGER postNotif:NotiRefreshPrivateExpert data:responModel.sessions object:nil];
        
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark - 父类MessageCenter函数重写:

#pragma mark - 私聊全量拉取会话明细
- (void)getAllMessages{
    
    if(!self.recipientId){
        return;
    }
    
    if (StrIsEmpty(self.sessionID))
    {
        ChatDetailModelR *modelR = [ChatDetailModelR new];
        modelR.token = QWGLOBALMANAGER.configure.expertToken;
        modelR.recipientId = self.recipientId;
        modelR.point = 0;
        modelR.view  = self.pageSize;
        modelR.viewType = 1;
        
        [ExpertAPI PMChatDetail:modelR success:^(ChatDetailList *responModel) {
            if([responModel.apiStatus intValue] != 0){
                [self stop];
                return;
            }
            if(responModel.details.count){
                
                [self checkMessagesFromAPI:responModel type:IMListAll];
                [self setOffset:0];
                [self showCurrentMessages:IMListAll successData:responModel];
            }
        } failure:^(HttpException *e) {
            
        }];
    }else
    {
        
        ChatNewDetailModelR *modelR = [ChatNewDetailModelR new];
        modelR.token = QWGLOBALMANAGER.configure.expertToken;
        modelR.chatId = self.sessionID;
        modelR.point = 0;
        modelR.view  = self.pageSize;
        modelR.viewType = 1;
        
        [ExpertAPI PMNewChatDetail:modelR success:^(ChatDetailList *responModel) {
            if([responModel.apiStatus intValue] != 0){
                [self stop];
                return;
            }
            if(responModel.details.count){
                
                [self checkMessagesFromAPI:responModel type:IMListAll];
                [self setOffset:0];
                [self showCurrentMessages:IMListAll successData:responModel];
            }
        } failure:^(HttpException *e) {
            
        }];
    }
    
    
    
}

#pragma mark - 私聊增量拉取会话明细
- (void)pollMessages
{
    if(!self.recipientId){
        return;
    }
    ChatDetailModelR *modelR = [ChatDetailModelR new];
    modelR.token = QWGLOBALMANAGER.configure.expertToken;
    modelR.sessionId = self.sessionID;
    
    [ExpertAPI LoopPMChatDetail:modelR success:^(ChatDetailList *responModel) {
        if(responModel.details.count){
            
            DebugLog(@"轮循到数据了-------!---------");
            [self checkMessagesFromAPI:responModel type:IMListPolling];
            [self showCurrentMessages:IMListPolling successData:responModel];
        }
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark  历史
- (void)getHistoryMessages:(IMHistoryBlock)block success:(IMSuccessBlock)success failure:(IMFailureBlock)failure{
    
    MessageModel *modOffset=[self getOffsetModel];
    //获取历史数据
    ChatDetailModelR *modelR = [ChatDetailModelR new];
    modelR.token        = QWGLOBALMANAGER.configure.expertToken;
    modelR.recipientId  = self.recipientId;
    modelR.point        = 0;
    modelR.view         = self.pageSize;
    modelR.viewType     = -1;
    
    if (modOffset != nil) {
        modelR.point = [modOffset.timestamp timeIntervalSince1970] * 1000.0f;
    }
 
    [ExpertAPI PMChatDetail:modelR success:^(ChatDetailList *responModel) {
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
            }else {
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
    }];
}

//已读
- (void)readMessages:(NSArray*)arrItems containSystem:(NSInteger)containSystem {
    //
}

#pragma mark  发送
- (void)sendAMessage:(MessageModel*)model success:(IMSuccessBlock)success failure:(IMFailureBlock)failure{
    
    ExpertMessageModel* qwmsg=(ExpertMessageModel*)[self buildQWMessageFromMessage:model];
    ExpertCreateModelR *modelR = [self buildExpertPMCreateFromMessage:model];
    
    [ExpertAPI PMChatSendMessage:modelR success:^(IMChatDetailSended *responModel) {
        
        if([responModel.apiStatus integerValue] == 0) {
            
            qwmsg.UUID=StrFromObj(responModel.detailId);
            if(StrIsEmpty(responModel.createTime)){
                qwmsg.timestamp=[NSString stringWithFormat:@"%.0f",[[self currentTimestampWithLongLongFormat] floatValue]];
            }else{
                qwmsg.timestamp=[NSString stringWithFormat:@"%.0f",[responModel.createTime doubleValue]];
            }
            [self sendAMessageDidSuccess:model.UUID QWMessage:qwmsg MessageModel:model];
            
            if (success) {
                success(responModel.detailId);
            }
        }else{
            [self sendAMessageDidFailure:model.UUID QWMessage:qwmsg MessageModel:model];
            if (failure) {
                failure(responModel.apiMessage);
            }
        }
        
    } failure:^(HttpException *e) {
        [self sendAMessageDidFailure:model.UUID QWMessage:qwmsg MessageModel:model];
        if (failure) {
            failure(e);
        }
    }];
 
}



- (NSNumber *)currentTimestampWithLongLongFormat
{
    double timeStamp = ceil([[NSDate date] timeIntervalSince1970] * 1000);
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setGeneratesDecimalNumbers:false];
    NSNumber *timeNumber = [NSNumber numberWithDouble:timeStamp];
    NSString *timeString = [formatter stringFromNumber:timeNumber];
    
    // NSTimeInterval is defined as double
    return [NSNumber numberWithLongLong:[timeString longLongValue]];
}

//删除
- (void)deleteAMessage:(MessageModel*)model success:(IMSuccessBlock)success failure:(IMFailureBlock)failure{
    
}

#pragma mark  发送成功/失败
//发送成功后调用
- (void)sendAMessageDidSuccess:(NSString *)UUID QWMessage:(ExpertMessageModel *)qwmsg MessageModel:(MessageModel*)msg{
    //更新db
    qwmsg.UUID=StrFromObj(qwmsg.UUID);
    //修改状态
    msg.sended=MessageDeliveryState_Delivered;
    qwmsg.issend = StrFromInt(msg.sended);//发送, 成功
    //更新db
    NSString *where=[NSString stringWithFormat:@"UUID = '%@'",UUID];
    
   [self updateMessage:qwmsg where:where];
}

//发送失败后调用
- (void)sendAMessageDidFailure:(NSString *)UUID QWMessage:(ExpertMessageModel *)qwmsg MessageModel:(MessageModel*)msg{
    //最后一条数据,要判断是不是提示信息，过滤掉

    msg.sended=MessageDeliveryState_Failure;//发送, 失败
    qwmsg.issend = StrFromInt(msg.sended);
    qwmsg.timestamp = [NSString stringWithFormat:@"%.0f",[msg.timestamp timeIntervalSince1970]*1000.f];
    
    //更新db
    NSString *where=[NSString stringWithFormat:@"UUID = '%@'",UUID];
    [self updateMessage:qwmsg where:where];
}


#pragma mark  数据整理
//api model转message model
- (BOOL)checkMessagesFromAPI:(id)mode type:(IMListType)lType{
    //    DebugLog(@"VVVVVVVVVVVVVVVVVVVVVVVVVV 准备处理数据");
    //  需要区分两端数据格式
    NSArray *arrDetails=nil;
    NSInteger num=0;
    if([mode isKindOfClass:[ChatDetailList class]]){
        ChatDetailList *model=mode;
        arrDetails=model.details;
        num=model.details.count;
    }
    
    NSMutableArray *arrItems = [[NSMutableArray alloc]initWithCapacity:num];
    NSMutableArray *arrHistory = [[NSMutableArray alloc]initWithCapacity:num];
    
    
    NSInteger SYSMessageCount = 0;
    
    BOOL hadNewMsg=NO;
    for(IMChatDetailVo *detail in arrDetails)
    {
        //API数据转DB格式，并判断是否DB重复数据，不是返回db数据格式
        ExpertMessageModel *msg = (ExpertMessageModel*)[self buildQWMessageFromAPIModel:mode detail:detail];
        
        if (msg==nil)
            continue ;
        else
            hadNewMsg=YES;
        
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
            [self messagesHistory:[self reverseArray:arrHistory]];
        }
        else if(num>0){
            //
        }
    }
    
    //    DebugLog(@"AAAAAAAAAAAAAAAAAAAAAAAAAA 结束处理数据");
    
    return hadNewMsg;
}


#pragma mark - DB 
//db数据重置，比如所有发送中状态改发送失败
- (void)DBDataInit{
    NSString *where = [NSString stringWithFormat:@"issend = '%d'",(int)MessageDeliveryState_Delivering];
    NSString *set = [NSString stringWithFormat:@"issend = '%d'",(int)MessageDeliveryState_Failure];
    [ExpertMessageModel updateSetToDB:set WithWhere:where];
    
    where = [NSString stringWithFormat:@"isReceiv = '%d' ",(int)MessageFileState_Downloading];
    set = [NSString stringWithFormat:@"isReceiv = '%d'",(int)MessageFileState_Failure];
    [ExpertMessageModel updateSetToDB:set WithWhere:where];
}


- (NSArray *)getDataFromDB{

    NSString *timestamp;
    NSString *where = [NSString stringWithFormat:@"recipientId = '%@'",self.recipientId];
    MessageModel *modOffset=[self getOffsetModel];
    //如果有设置偏移量，获取偏移量的id和时间戳
    if (modOffset != nil && modOffset.UUID) {
        timestamp = [NSString stringWithFormat:@"%.0f",[modOffset.timestamp timeIntervalSince1970]*1000.f];
        where = [NSString stringWithFormat:@"timestamp < '%@' and (recipientId = '%@')",timestamp,self.recipientId];
    }
    
    NSArray *textArr = [ExpertMessageModel getArrayFromDBWithWhere:[NSString stringWithFormat:@"recipientId = '%@'",self.recipientId]];
    
    NSArray *array = [ExpertMessageModel getArrayFromDBWithWhere:where WithorderBy:@"timestamp DESC" offset:0 count:self.pageSize];

    return [self reverseArray:array];
}

- (BOOL)createMessage:(ExpertMessageModel *)model{
    
    NSError *error=nil;
    ExpertMessageModel *msg = [[ExpertMessageModel alloc]initWithMessage:model];
    msg.recipientId = [NSString stringWithFormat:@"%@",self.recipientId];
    
    error = [ExpertMessageModel saveObjToDB:model];
    if (error) {
        return NO;
    }
    return YES;
}

- (BOOL)updateMessage:(ExpertMessageModel *)model{
        
    ExpertMessageModel *msg=[[ExpertMessageModel alloc]initWithMessage:model];
    return [msg updateToDB];
}

//更新数据库
- (BOOL)updateMessage:(ExpertMessageModel *)model where:(NSString*)where{
    
    ExpertMessageModel *msg=[[ExpertMessageModel alloc]initWithMessage:model];
    msg.recipientId = [NSString stringWithFormat:@"%@",self.recipientId];
    
    BOOL flag = [ExpertMessageModel updateToDB:msg where:where];
    if(flag){
        DebugLog(@"<Li Jian插入成功>");
    }else{
        DebugLog(@"<Li Jian插入失败>");
    }
    
    return flag;
}
#pragma mark - 数据Model转换
//APIModel->ExpertMessageModel
- (ExpertMessageModel *)buildQWMessageFromAPIModel:(id)mode detail:(IMChatDetailVo *)detail{
    
    ExpertMessageModel *qwmsg = [[ExpertMessageModel alloc] init];
    qwmsg.UUID = [NSString stringWithFormat:@"%@",detail.detailId];
    qwmsg.recipientId = self.recipientId;
    qwmsg.sessionId = detail.sessionId;
    
    //专家、用户信息
    qwmsg.userType = detail.userType;
    qwmsg.posterId = detail.senderId;
    if(StrIsEmpty(self.senderId) && !StrIsEmpty(detail.senderId) && ![detail.myselfFlag boolValue]){
        self.senderId = detail.senderId;
    }
    
    //检查db里是否有该数据
    ExpertMessageModel *expertModel = [ExpertMessageModel getObjFromDBWithKey:detail.detailId];
    
    if(expertModel && [expertModel.recipientId isEqualToString:self.recipientId]) {
        return nil;
    }
    qwmsg.timestamp = [NSString stringWithFormat:@"%.0f",[detail.createTime doubleValue]];
    qwmsg.isRead = @"1";
    qwmsg.sendname = self.sessionID;
    qwmsg.recvname = self.oID;
    qwmsg.issend = StrFromInt(MessageDeliveryState_Delivered);
    qwmsg.download = StrFromInt(MessageFileState_Pending);
    
    if([detail.myselfFlag boolValue]) {
        qwmsg.direction = StrFromInt(MessageTypeSending);
        qwmsg.avatorUrl = QWGLOBALMANAGER.configure.expertAvatarUrl;
    }else{
        qwmsg.direction = StrFromInt(MessageTypeReceiving);
        qwmsg.avatorUrl = detail.headImg;
    }

    ContentJson *contentJson = [ContentJson parse:[detail.contentJson jsonStringToDict]];
    
    if([detail.contentType isEqualToString:@"TXT"]) {
        qwmsg.messagetype = [NSString stringWithFormat:@"%lu",(unsigned long)MessageMediaTypeText];
        qwmsg.body = contentJson.content;
    }else if([detail.contentType isEqualToString:@"IMG"]) {
        qwmsg.messagetype = [NSString stringWithFormat:@"%lu",(unsigned long)MessageMediaTypePhoto];
        qwmsg.richbody = contentJson.imgUrl;
    }else if([detail.contentType isEqualToString:@"SPE"]){
        qwmsg.messagetype = StrFromInt(MessageMediaTypeVoice);
        qwmsg.duration = contentJson.duration;
        qwmsg.richbody = nil;
        qwmsg.fileUrl = contentJson.speUrl;
        qwmsg.content = @"[语音]";
    }else if([detail.contentType isEqualToString:@"PRO"]) {
        qwmsg.messagetype = [NSString stringWithFormat:@"%lu",(unsigned long)MessageMediaTypeMedicine];
        qwmsg.body = contentJson.name;
        qwmsg.imgUrl = contentJson.imgUrl;
        qwmsg.richbody = contentJson.id;
        
        if (contentJson.pmtLabe.length) {
            qwmsg.messagetype = [NSString stringWithFormat:@"%lu",(unsigned long)MessageMediaTypeMedicineCoupon];
            qwmsg.title = contentJson.pmtLabe;
            qwmsg.fileUrl = contentJson.pmtId;
        }
    }else if([detail.contentType isEqualToString:@"MPRO"]) {
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
    
    return qwmsg;
}

//MessageModel->CreateModelR
- (ExpertCreateModelR *)buildExpertPMCreateFromMessage:(MessageModel*)model{
    
    ExpertCreateModelR *modelR = [ExpertCreateModelR new];
    modelR.token = QWGLOBALMANAGER.configure.expertToken;
    modelR.recipientId = self.recipientId;
    modelR.UUID = model.UUID;
    
    IMChatPointVo *pharMsgModel = [IMChatPointVo getObjFromDBWithKey:self.recipientId];
    
    ContentJson *contentJson = [ContentJson new];
    
    switch (model.messageMediaType) {
        case MessageMediaTypeText:
        {
            modelR.contentType = @"TXT";
            contentJson.content = model.text;
            pharMsgModel.respond = model.text;
            break;
        }
        case MessageMediaTypePhoto:
        {
            modelR.contentType = @"IMG";
            contentJson.imgUrl = model.richBody;
            pharMsgModel.respond = @"[图片]";
            break;
        }
        case MessageMediaTypeVoice:
        {
            modelR.contentType = @"SPE";
            contentJson.duration = model.voiceDuration;
            contentJson.speUrl = model.voiceUrl;
            contentJson.platform = @"IOS";
            contentJson.speText=@"[语音]";
            pharMsgModel.respond = @"[语音]";
            break;
        }
        case MessageMediaTypeMedicine:
        {
            modelR.contentType = @"PRO";
            //            contentJson.imgUrl = model.richBody;
            contentJson.name = model.text;
            contentJson.id = model.richBody;
            contentJson.imgUrl = model.activityUrl;
            
            pharMsgModel.respond = @"[药品]";
            break;
        }
        case MessageMediaTypeStoreMedicine:
        {
            modelR.contentType = @"MPRO";
            contentJson.name = model.text;
            contentJson.id = model.richBody;
            contentJson.imgUrl = model.activityUrl;
            contentJson.spec = model.spec;
            contentJson.branchId = model.branchId;
            contentJson.branchProId = model.branchProId;
            pharMsgModel.respond = @"[药品]";
            break;
        }
        case MessageMediaTypeMedicineCoupon:
        {
            modelR.contentType = @"PRO";
            contentJson.name = model.text;
            contentJson.id = model.richBody;
            contentJson.imgUrl = model.activityUrl;
            if (model.subTitle.length) {
                contentJson.pmtLabe=model.subTitle;
                contentJson.pmtId=model.otherID;
            }
            pharMsgModel.respond = @"[药品]";
            break;
        }
            
        default:
            break;
    }
    pharMsgModel.respondDate =[NSString stringWithFormat:@"%.0f",[model.timestamp timeIntervalSince1970]];;
    pharMsgModel.readFlag = @"0";
    [IMChatPointVo updateObjToDB:pharMsgModel WithKey:self.recipientId];
    
    modelR.contentJson = [self toJSONStr:[contentJson dictionaryModel]];
    
    UIDevice *device = [UIDevice currentDevice];
    modelR.device = [device uniqueDeviceIdentifier];
    
    return modelR;
}

#pragma mark 获取图片UUID数组
- (NSArray*)getImages{
    
    NSString* where = [NSString stringWithFormat:@"messagetype = '%@' AND recipientId = '%@'",@"2",self.recipientId];
    
    NSArray *array = [ExpertMessageModel getArrayFromDBWithWhere:where WithorderBy:@"timestamp ASC"];
    
    NSArray *tmparray = [ExpertMessageModel getArrayFromDBWithWhere:nil WithorderBy:@"timestamp ASC"];
    
    NSMutableArray *tmp=[[NSMutableArray alloc]initWithCapacity:array.count];
    for (ExpertMessageModel *mm in array) {
        if( [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:mm.UUID]) {
            [tmp addObject:mm.UUID];
        }
    }
    
    return tmp;
}

@end
