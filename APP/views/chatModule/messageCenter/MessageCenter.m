    //
//  MessageCenter.m
//  AppFramework
//
//  Created by Yan Qingyang on 15/5/25.
//  Copyright (c) 2015年 Yan Qingyang. All rights reserved.
//

#import "MessageCenter.h"

#import "TimerUtils.h"
#import "ChatManagerDefs.h"

#import "NSMutableArray+EX.h"
#import "SDImageCache.h"


static NSInteger kPageSize = 16;


static CGFloat kPollingMinInterval = 3.0;
static CGFloat kPollingMaxInterval = 30.0;


@interface MessageCenter()
{
    dispatch_source_t timerPolling;
    IMListBlock msgListBlock;
    IMSuccessBlock successStatusBlock;
    BOOL isAll;
    BOOL isClose;
    BOOL isStop;
    
    NSInteger curPage;
    
    NSInteger noDataTimes;
    
    
    
    
    MessageModel *modOffset;
}
@property (nonatomic,strong) NSMutableArray *arrMessages;


@property (nonatomic,assign) CGFloat      pollingInterval;


@end

@implementation MessageCenter
@synthesize delegate=_delegate;
@synthesize count=_count;
@synthesize oID=_oID;
@synthesize type=_type;
@synthesize serverTime=_serverTime;
#pragma mark - init
- (id)init
{
    if (self = [super init]) {
        self.sendingCount=0;
        self.count=0;
        self.pageSize = kPageSize;
        self.pollingInterval = kPollingMinInterval;
        self.serverTime = 0;
        
        isStop=NO;
        isAll=NO;
        isClose=YES;
        //        hadNew=false;
        
        noDataTimes=0;
        curPage=0;
        
        self.arrMessages = nil;
        self.arrMessages = [[NSMutableArray alloc]initWithCapacity:self.pageSize];
        
        [self addObserverGlobal];
        [self DBDataInit];
    }
    return self;
}

- (id)initWithID:(NSString*)oID type:(IMType)type
{
    if (self = [self init]) {
        self.oID = StrFromObj(oID);
        self.type = type;
        //        self.delegate=delegate;
    }
    return self;
}

- (void)setPageSize:(NSInteger)pageSize{
    if (pageSize <= 0) {
        _pageSize = kPageSize;
    }
    else _pageSize = pageSize;
}

- (void)setPollingInterval:(CGFloat)pollingInterval{
    if (pollingInterval <= 0) {
        _pollingInterval = kPollingMinInterval;
    }
    else _pollingInterval = pollingInterval;
}

//返回数据数量
- (NSInteger)count{
    return self.arrMessages.count;
}

//正在发送的线程数量
- (void)setSendingCount:(NSInteger)sendingCount{
    _sendingCount=sendingCount;
    [self checkSendingCount];
}

- (void)checkSendingCount{
    if (_sendingCount<=0) {
        //发送线程都结束,且消息中心在停止状态，发送通知
        //        DebugLog(@"发送线程都结束");
        if (isStop) {
            NSMutableDictionary *dd=[NSMutableDictionary dictionary];
            if (self.oID) {
                dd[@"oID"]=self.oID;
            }
            if (self.sessionID) {
                dd[@"sessionID"]=self.sessionID;
            }
            [QWGLOBALMANAGER postNotif:NotifIMCenterSended data:dd object:self];
        }
    }
}
#pragma mark - 外部方法

- (void)start{
    
    //
    //先在DB取老数据
    NSArray *tmp=[self getCurrentMessagesFromDB];
    if (tmp.count>0) {
        [self messagesQueue:tmp reset:NO];
        [self showCurrentMessages:IMListDB successData:nil];
    }
    [self setOffset:0];
    //    DebugLog(@"%d:%@",(int)tmp.count,[tmp.lastObject description]);
    //
    //API全量抓数据
    isAll=YES;
    [self getAllMessages];
    
    //调restart
    [self restart];
}

- (void)expertStart{
    
    //
    //先在DB取老数据
    NSArray *tmp=[self getCurrentMessagesFromDB];
    if (tmp.count>0) {
        [self messagesQueue:tmp reset:NO];
        [self showCurrentMessages:IMListDB successData:nil];
    }
    [self setOffset:0];
    //    DebugLog(@"%d:%@",(int)tmp.count,[tmp.lastObject description]);
    //
    //API全量抓数据
    isAll=YES;
    [self getAllMessages];
    
    //调restart
//    [self restart];
}

//重启轮询方法
- (void)restart{
    if (isStop==NO && isClose==NO) {
        return;
    }
    
    isStop=NO;
    isClose=NO;
    self.pollingInterval = kPollingMinInterval;
    [TIMER timerAfter:timerPolling timeDelay:self.pollingInterval blockAfter:^{
        isAll=false;
        [self beginPolling];
    }];
}


//停轮询
- (void)stop{
    isStop=YES;
    [self checkSendingCount];
    [self suspend];
}

//彻底关闭
- (void)close{
    [self removeObserverGlobal];
    [self suspend];
}

//判断是非关闭状态
- (BOOL)isClose{
    if (isClose || isStop) {
        return YES;
    }
    return NO;
}
#pragma mark 暂停/重启
- (void)suspend{
    if (isClose) {
        return;
    }
    
    isClose=YES;
    [TIMER timerClose:timerPolling];
}

- (void)resume{
    if (isStop) {
        return;
    }
    [self restart];
}

#pragma mark 显示tableview当前位置单数据
- (MessageModel*)getMessageByIndex:(NSInteger)index{
    if (index<self.arrMessages.count) {
        return self.arrMessages[index];
    }
    return nil;
}

-(NSInteger) getMessageIndex:(MessageModel*)messagemodel
{
    
    return  [self.arrMessages indexOfObject:messagemodel];
    
}
//- (void)getMessageByIndex:(NSInteger)index messageBlock:(void (^)(id message))messageBlock success:(IMSuccessBlock)success failure:(IMFailureBlock)failure{
//
//}
#pragma mark  显示当前数据列表
- (void)getMessages:(IMListBlock)list success:(IMSuccessBlock)success failure:(IMFailureBlock)failure{
    
    msgListBlock=nil;
    msgListBlock=list;
    
    successStatusBlock=nil;
    successStatusBlock=success;
    
    //判断轮询没开始，并且不在全量拉数据的时候启动
    if (timerPolling==nil && isAll==false) {
        [self beginPolling];
    }
    
    
    //获取窗口数据
    [self showCurrentMessages:IMListCurrent successData:nil];
}

#pragma mark 翻上页
- (void)getHistory:(IMHistoryBlock)block success:(IMSuccessBlock)success failure:(IMFailureBlock)failure{
    //获取历史数据
    [self setOffset:0];
    NSArray *arr1=[self getDataFromDB];
    
    if ((arr1.count<self.pageSize) && (self.type==IMTypePTPClient || self.type==IMTypePTPStore)) {
        //如果数据数小于每页条数
        if (self.type==IMTypePTPClient || self.type==IMTypePTPStore) {
            //PTP API拉历史数据
            [self getHistoryMessages:block success:success failure:failure];
        }
        else [self showHistoryMessages:block success:success];
    }
    else {
        [self showHistoryMessages:block success:success];
    }
    
    
    
}

#pragma mark 添加/重发对话
- (void)sendMessage:(MessageModel*)model success:(IMSuccessBlock)success failure:(IMFailureBlock)failure{
    //转QWmodel保存DB
    model.sended=MessageDeliveryState_Delivering;//待发送
    model.download=MessageFileState_Downloaded;
    QWMessage* qwmsg=[self buildQWMessageFromMessage:model];
    qwmsg.issend=StrFromInt(model.sended);
    qwmsg.download=StrFromInt(model.download);
    [self createMessage:qwmsg];
    
    //加入数据队列
    [self messagesQueue:model reset:NO];
    
    //刷新界面
    [self showCurrentMessages:IMListAdd successData:nil];
    
    //调接口
    [self sendAMessage:model success:success failure:failure];
}

- (void)resendMessage:(MessageModel*)model success:(IMSuccessBlock)success failure:(IMFailureBlock)failure{
    //DB删数据
    id msg=[self buildQWMessageFromMessage:model];
    [self deleteMessage:msg];
    
    //实时数据队列删数据
    [self.arrMessages removeObject:model];
    
    
    
    
    
    //重置页面节点
    [self setOffset:0];
    
    //刷新界面
    [self showCurrentMessages:IMListDelete successData:nil];
    
    //调发送
    [self sendMessage:model success:success failure:failure];
}

//添加DB数据
- (void)addMessage:(MessageModel*)model{
    
    //    model.sended=MessageDeliveryState_Delivering;//待发送
    model.download=MessageFileState_Downloaded;
    QWMessage* qwmsg=[self buildQWMessageFromMessage:model];
    qwmsg.issend=StrFromInt(model.sended);
    qwmsg.download=StrFromInt(model.download);
    [self createMessage:qwmsg];
    
    //加入数据队列
    [self messagesQueue:model reset:NO];
    
    //刷新界面
    [self showCurrentMessages:IMListAdd successData:nil];
}
#pragma mark 删除对话
- (void)removeMessage:(MessageModel*)model  success:(IMSuccessBlock)success failure:(IMFailureBlock)failure{
    //DB删数据
    id msg=[self buildQWMessageFromMessage:model];
    [self deleteMessage:msg];
    
    //实时数据队列删数据
    [self.arrMessages removeObject:model];
    //重置页面节点
    [self setOffset:0];
    
    //刷新界面
    [self showCurrentMessages:IMListDelete successData:nil];
    
    //接口删数据
    [self deleteAMessage:model success:success failure:failure];
}

#pragma mark 添加/重发大数据
- (void)resendFileMessage:(MessageModel* )model success:(IMSuccessBlock)success failure:(IMFailureBlock)failure  uploadProgressBlock:(void (^)(MessageModel* target, float progress ))uploadProgressBlock{
    //DB删数据
    id msg=[self buildQWMessageFromMessage:model];
    [self deleteMessage:msg];
    
    //实时数据队列删数据
    [self.arrMessages removeObject:model];
    
    //重置页面节点
    [self setOffset:0];
    
    //刷新界面
    [self showCurrentMessages:IMListDelete successData:nil];
    
    [self sendFileMessage:model success:success failure:failure uploadProgressBlock:uploadProgressBlock];
}

- (void)sendMessageWithoutMessageQueue:(MessageModel*)model success:(IMSuccessBlock)success failure:(IMFailureBlock)failure{
    //转QWmodel保存DB
    model.sended=MessageDeliveryState_Delivering;//待发送
    model.download=MessageFileState_Downloaded;
    QWMessage* qwmsg=[self buildQWMessageFromMessage:model];
    qwmsg.issend=StrFromInt(model.sended);
    qwmsg.download=StrFromInt(model.download);
    [self createMessage:qwmsg];
    
    //刷新界面
    [self showCurrentMessages:IMListAdd successData:nil];
    
    //调接口
    [self sendAMessage:model success:success failure:failure];
}

//发送文件类消息
- (void)sendFileMessage:(MessageModel* )model success:(IMSuccessBlock)success failure:(IMFailureBlock)failure  uploadProgressBlock:(void (^)(MessageModel* target, float progress ))uploadProgressBlock
{
    NSData *data=nil;
    
    if (model.messageMediaType==MessageMediaTypePhoto) {
        UIImage *img=[self getImageByMessage:model];
        if (img) {
            data=UIImageJPEGRepresentation(img, 1.0);
        }
        
    }
    else if (model.messageMediaType==MessageMediaTypeVoice) {
        //获取语音文件
        data=[NSData dataWithContentsOfFile:model.voicePath];
    }
    
    if (!data ) {
        if (failure) {
            failure(nil);
        }
        return;
    }
    
    //转QWmodel保存DB
    model.sended=MessageDeliveryState_Delivering;//待发送
    model.download=MessageFileState_Downloaded;
    QWMessage* qwmsg=[self buildQWMessageFromMessage:model];
    qwmsg.issend=StrFromInt(model.sended);
    qwmsg.download=StrFromInt(model.download);
    [self createMessage:qwmsg];
    
    //加入数据队列
    [self messagesQueue:model reset:NO];
    
    //刷新界面
    [self showCurrentMessages:IMListAdd successData:nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if(IS_EXPERT_ENTRANCE){
        params[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    }else{
        params[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
    }
    
    
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
                    if (model.messageMediaType == MessageMediaTypePhoto) {
                        NSString *ImgUUID = [NSString stringWithFormat:@"%@",successObj];
                        DebugLog(@"图片发送2:%@ UUID:%@",successObj,model.UUID);
                        UIImage *imagedata =  [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:uuid] ;
                        [[SDImageCache sharedImageCache] storeImage:imagedata forKey:ImgUUID];
                        
                        if (success) {
                            success(ImgUUID);
                        }
                    }
                    
                } failure:failure];
            }else  {
                [self sendAMessageDidFailure:model.UUID QWMessage:qwmsg MessageModel:model];
                if (failure)
                failure(nil);
            }
        } failure:^(HttpException *e) {
            [self sendAMessageDidFailure:model.UUID QWMessage:qwmsg MessageModel:model];
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
    else if (model.messageMediaType==MessageMediaTypeVoice) {
        
        [self uploadFile:data params:params success:^(id responseObj) {
            
            uploadFile *file = [uploadFile parse:responseObj];
            if([file.apiStatus intValue] == 0 && file.url){
                model.voiceUrl=file.url;
                [self sendAMessage:model success:^(id successObj) {
                    
                    if (model.messageMediaType == MessageMediaTypeVoice) {
                        
                        //model.voiceUrl=file.url;
                        NSString *UUID = [NSString stringWithFormat:@"%@",successObj];
                        
                        NSString *path=[FileManager rename:UUID oldPath:model.voicePath];
                        DebugLog(@"文件发送2:%@ path:%@",successObj,path);
                        model.voicePath=path;
                        
                        [self updateMessage:[self buildQWMessageFromMessage:model]];
                        
                        if (success) {
                            success(successObj);
                        }
                    }
                    
                } failure:failure];
                
            }else{
                [self sendAMessageDidFailure:model.UUID QWMessage:qwmsg MessageModel:model];
                if (failure)
                failure(nil);
            }
        } failure:^(HttpException *e) {
            [self sendAMessageDidFailure:model.UUID QWMessage:qwmsg MessageModel:model];
            if (failure) {
                failure(e);
            }
        } uploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            double pre=(double)totalBytesWritten/(double)totalBytesExpectedToWrite;
            DebugLog(@"上传文件:%f",pre);
            if (uploadProgressBlock) {
                uploadProgressBlock(model,pre);
            }
        }];
    }
    
}
//上传图片
- (void)uploadImage:(NSData*)file params:(NSDictionary*)params success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure  uploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))uploadProgressBlock{
    HttpClient *httpClent = [HttpClient new];
    //cj----cj
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *apiUrl = [def objectForKey:@"APIDOMAIN"];
    NSString *h5Url = [def objectForKey:@"H5DOMAIN"];
    if(apiUrl&&![apiUrl isEqualToString:@""]){
        [httpClent setBaseUrl:apiUrl];
    }else{
        [httpClent setBaseUrl:BASE_URL_V2];
    }    httpClent.progressEnabled = NO;
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:file];
    
    [httpClent uploaderImg:array params:params withUrl:NW_uploadFile success:success failure:failure uploadProgressBlock:uploadProgressBlock];
    
}

#pragma mark - 文件上传
- (void)uploadFile:(NSData*)file params:(NSDictionary*)params success:(void(^)(id responseObj))success failure:(void(^)(HttpException * e))failure  uploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))uploadProgressBlock{
    HttpClient *httpClent = [HttpClient new];
    //cj----cj
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *apiUrl = [def objectForKey:@"APIDOMAIN"];
    NSString *h5Url = [def objectForKey:@"H5DOMAIN"];
    if(apiUrl&&![apiUrl isEqualToString:@""]){
        [httpClent setBaseUrl:apiUrl];
    }else{
        [httpClent setBaseUrl:BASE_URL_V2];
    }
    httpClent.progressEnabled = NO;
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:file];
    
    [httpClent upRawFile:array params:params withUrl:NW_uploadSpe success:success failure:failure uploadProgressBlock:uploadProgressBlock];
}

#pragma mark 获取图片UUID数组
- (NSArray*)getImages{
    return nil;
}
#pragma mark - 内部方法
//设置偏移量，用于翻页
- (void)setOffset:(NSInteger)index{
    curPage=0;
    modOffset=nil;
    if (index>=0 && index<self.arrMessages.count) {
        modOffset=self.arrMessages[index];
    }
}
//排序
- (void)sortMessages
{
    NSSortDescriptor*sorter=[[NSSortDescriptor alloc]initWithKey:@"timestamp" ascending:YES];
    NSMutableArray *sortDescriptors=[[NSMutableArray alloc]initWithObjects:&sorter count:1];
    NSArray *sortArray=[self.arrMessages sortedArrayUsingDescriptors:sortDescriptors];
    self.arrMessages = [[NSMutableArray alloc]initWithArray:sortArray];
}

//反序
- (NSArray*)reverseArray:(NSArray*)arr{
    NSMutableArray *array = [NSMutableArray arrayWithArray:arr];
    NSArray* reversedArray = [[array reverseObjectEnumerator] allObjects];
    return reversedArray;
}

//获取原图
- (UIImage*)getImageByMessage:(MessageModel*)mode{
    if (mode.photo!=nil)
    return mode.photo;
    
    if (mode.messageMediaType==MessageMediaTypePhoto) {
        UIImage *photo = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:mode.UUID];
        return photo;
        //        return UIImageJPEGRepresentation(photo, 1.0);
    }
    return nil;
}
#pragma mark - DB
//db数据重置，比如所有发送中状态改发送失败
- (void)DBDataInit{
    
}

- (NSArray *)getCurrentMessagesFromDB{
    [self setOffset:-1];
    NSArray *arr1=[self getDataFromDB];
    NSArray *arr2=[self messagesListFromQWMessagesList:arr1];
    return arr2;
}

//需要偏移量计算开始页,offset偏移量
//- (NSArray *)getDataFromDBByPage:(NSInteger)page{
- (NSArray *)getDataFromDB{
    return nil;
}

- (MessageModel *)getOffsetModel{
    //    return [self.arrMessages firstObject];
    return modOffset;
}
- (MessageModel *)getLastModel{
    //    return [self.arrMessages firstObject];
    return [self.arrMessages lastObject];
}

//更新DB数据
- (BOOL)updateMessage:(QWMessage*)model{
    return NO;
}

//删除db数据
- (BOOL)deleteMessage:(QWMessage*)model{
    return NO;
}

//db删除某类型数据
- (BOOL)deleteMessagesByType:(MessageBodyType)type{
    NSMutableArray *tmp=[NSMutableArray array];
    for (MessageModel *mm in self.arrMessages) {
        if (mm.messageMediaType==type ) {
            [tmp addObject:mm];
        }
    }
    if (tmp.count) {
        [self.arrMessages removeObjectsInArray:tmp];
        [self showCurrentMessages:IMListDB successData:nil];
    }
    //    for(int i=0; i < [self.arrMessages count]; i++){
    //        MessageModel *mm = [self.arrMessages objectAtIndex:i];
    //        if(mm.messageMediaType==type ){
    //            [self.arrMessages removeObject:mm];
    //            i--;
    //        }
    //    }
    return NO;
}

- (BOOL)updateMessage:(QWMessage*)model where:(NSString*)where{
    return NO;
}
- (BOOL)createMessage:(QWMessage*)model{
    return NO;
}

//更新对象数据，用于外部列表呈现
+ (QWMessage*)checkMessageState:(QWMessage*)msg{
    QWMessage *model=[[QWMessage alloc]initWithMessage:msg];
    switch (model.messagetype.intValue) {
        case MessageMediaTypeText:
            //            model.body = model.text;
            break;
        case MessageMediaTypePhoto:
            model.body = @"[图片]";
            break;
        case MessageMediaTypeLocation:
            model.body = @"[位置]";
            break;
        case MessageMediaTypeActivity:
            model.body = @"[活动]";
            break;
        case MessageMediaTypeMedicineCoupon:
        case MessageMediaTypeMedicine:
            model.body = @"[药品]";
            break;
        case MessageMediaTypeStoreMedicine:
            model.body = @"[药品]";
            break;
        case MessageMediaTypeMedicineSpecialOffers:
            model.body = @"[活动]";
            break;
        case MessageMediaTypeVoice:
            model.body = @"[语音]";
            break;
        case MessageMediaTypeCoupon:
            model.body = @"[优惠]";
            break;
        default:
            break;
    }
    return model;
}


//更新mod
- (BOOL)updateAMessage:(MessageModel*)mode{
    return [self updateMessage:[self buildQWMessageFromMessage:mode]];
}

#pragma mark - API
//增量
- (void)pollMessages {
    //
}
//全量
- (void)getAllMessages {
    //
}
//历史
- (void)getHistoryMessages:(IMHistoryBlock)block success:(IMSuccessBlock)success failure:(IMFailureBlock)failure{
    //
}
//已读
- (void)readMessages:(NSArray*)arrItems containSystem:(NSInteger)containSystem {
    //
}
//发送
- (void)sendAMessage:(MessageModel*)model success:(IMSuccessBlock)success failure:(IMFailureBlock)failure{
    
}
//删除
- (void)deleteAMessage:(MessageModel*)model success:(IMSuccessBlock)success failure:(IMFailureBlock)failure{
    
}

////检查DB数据状态
//+ (id)checkMessageStateByID:(NSString*)oid{
//    return nil;
//}

#pragma mark  发送成功/失败
//发送成功后调用
- (void)sendAMessageDidSuccess:(NSString *)UUID QWMessage:(id)qwmsg MessageModel:(MessageModel*)msg{
    //更新db
}

//发送失败后调用
- (void)sendAMessageDidFailure:(NSString *)UUID QWMessage:(id)qwmsg MessageModel:(MessageModel*)msg{
    //message比对上一条数据时间，小于时间，以上一条时间＋1
    //如果大于，并小于轮询时间戳+max间隔，以message时间为准
    //超过轮询时间戳+max间隔，以轮询时间戳+max间隔为准
    
    //保存db
}
#pragma mark  已读数组string
- (NSString*)getReadIDs:(NSArray*)arrItems {
    NSString *strItems = [arrItems componentsJoinedByString:SeparateStr];
    return strItems;
}

#pragma mark - 轮询拉数据
- (void)beginPolling{
    if (isClose) {
        return;
    }
    
    timerPolling=[TIMER timerLoop:timerPolling timeInterval:self.pollingInterval blockLoop:^{
        [self pollMessages];
    } blockStop:^{
        //
    }];
}


//弹性轮询, 轮询收到消息或者发送消息后需重新设置
- (void)checkNoDataTimes:(NSInteger)num{
    //    return;
    
    //一分钟按最小间隔拉n次
    NSInteger minTimes = 60/kPollingMinInterval;
    
    //MinInterval内一直有数据来
    if (self.pollingInterval == kPollingMinInterval && num > 0) {
        return;
    }
    
    //MaxInterval内一直无数据
    if (self.pollingInterval == kPollingMaxInterval && num == 0) {
        return;
    }
    
    if (num == 0) {
        noDataTimes++;
    }
    else noDataTimes = 0;
    
    if (noDataTimes <= minTimes) {
        self.pollingInterval=kPollingMinInterval;
    }
    else {
        self.pollingInterval=kPollingMinInterval+(noDataTimes-minTimes)*2;
    }
    
    if (self.pollingInterval > kPollingMaxInterval) {
        self.pollingInterval=kPollingMaxInterval;
    }
    
    [TIMER timerAfter:timerPolling timeDelay:self.pollingInterval blockAfter:^{
        [self beginPolling];
    }];
}

#pragma mark  数据整理 model转化
//api model整理成MessageModel
- (BOOL)checkMessagesFromAPI:(id)mode type:(IMListType)lType{
    return NO;
}
//APIModel->QWMessage
- (QWMessage *)buildQWMessageFromAPIModel:(id)mode detail:(id)detail {
    return nil;
}
//MessageModel->QWMessage
- (QWMessage *)buildQWMessageFromMessage:(MessageModel *)model{
    
    QWMessage * qwmsg = [[QWMessage alloc] init];
    qwmsg.direction = [NSString stringWithFormat:@"%ld",(long)model.messageDeliveryType];
    qwmsg.timestamp = [NSString stringWithFormat:@"%.0f",[model.timestamp timeIntervalSince1970]*1000.f];
    qwmsg.UUID = model.UUID;
    qwmsg.avatorUrl = model.avatorUrl;
    qwmsg.sendname = (self.sessionID)?self.sessionID:self.oID; //QWGLOBALMANAGER.configure.passPort;
    qwmsg.recvname = self.oID;
    qwmsg.download = [NSString stringWithFormat:@"%ld",(long)model.download];
    qwmsg.issend = [NSString stringWithFormat:@"%ld",(long)model.sended];
    qwmsg.isRead = @"1";
    qwmsg.richbody = @"";
    qwmsg.messagetype = [NSString stringWithFormat:@"%lu",(unsigned long)model.messageMediaType];
    
    switch (model.messageMediaType ){
        case MessageMediaTypeText: {
            
            qwmsg.star = [NSString stringWithFormat:@"%f",model.starMark];
            qwmsg.body = model.text;
            
            break;
        }
        case MessageMediaTypePhoto: {
            qwmsg.star = [NSString stringWithFormat:@"%f",model.starMark];
            qwmsg.richbody = model.richBody;
            qwmsg.body = @"[图片]";
            break;
        }
        case MessageMediaTypeLocation: {
            
            qwmsg.star = [NSString stringWithFormat:@"%@,%@",model.latitude,model.longitude ];
            qwmsg.body = model.text;
            break;
        }
        case MessageMediaTypeActivity: {
//            qwmsg.star = [NSString stringWithFormat:@"%f",model.starMark];
            qwmsg.richbody = model.richBody;
            qwmsg.star = model.title;
            qwmsg.imgUrl = model.activityUrl;
            
            qwmsg.body = model.text;
            break;
        }
        
        case MessageMediaTypeStarStore:
        {
//            qwmsg.star = [NSString stringWithFormat:@"%f",model.starMark];
            qwmsg.richbody = model.richBody;
            qwmsg.star = model.title;
            qwmsg.imgUrl = model.activityUrl;
            qwmsg.body = model.text;
            break;
        }
        
        
        case MessageMediaTypePhone:
        {
            
            qwmsg.star = [NSString stringWithFormat:@"%f",model.starMark];
            qwmsg.body = @"[图片]";
            break;
        }
        
        case MessageMediaTypeMedicineShowOnce:
        {
            
            qwmsg.star = model.title;
            qwmsg.richbody = model.richBody;
            qwmsg.body = model.text;
            break;
        }
        case MessageMediaTypeMedicineSpecialOffersShowOnce:
        {
            qwmsg.star = model.title;
            qwmsg.richbody = model.richBody;
            qwmsg.body = model.text;
            break;
        }
        // add  end
       
        case MessageMediaTypeVoice:
        {
            qwmsg.duration = model.voiceDuration;
            qwmsg.richbody = model.voicePath;
            qwmsg.fileUrl = model.voiceUrl;
            break;
        }
            // add  by  shen
        case MessageMediaTypeMedicine:
        {
            //            qwmsg.star = [NSString stringWithFormat:@"%f",model.starMark];
            qwmsg.richbody = model.richBody;
            qwmsg.body = model.text;
            qwmsg.star = model.title;
            qwmsg.imgUrl = model.activityUrl;//药品图片
            
            break;
        }
        case MessageMediaTypeStoreMedicine:
        {
            //            qwmsg.star = [NSString stringWithFormat:@"%f",model.starMark];
            qwmsg.richbody = model.richBody;
            qwmsg.body = model.text;
            qwmsg.star = model.title;
            qwmsg.imgUrl = model.activityUrl;//药品图片
            qwmsg.spec = model.spec;
            qwmsg.branchProId = model.branchProId;
            qwmsg.branchId = model.branchId;
            
            break;
        }
            //yqy 优惠
        case MessageMediaTypeCoupon:
        {
            qwmsg.title = model.title;
            qwmsg.body = model.subTitle;
            qwmsg.star = model.text;
            qwmsg.richbody = model.richBody;
            qwmsg.fileUrl = model.otherID;
            qwmsg.fromTag = model.style.intValue;
            qwmsg.list = [NSString stringWithFormat:@"%@;%@",model.arrList.firstObject,model.arrList.lastObject];
            qwmsg.imgUrl=model.thumbnailUrl;
            qwmsg.tags=model.isMarked?1:0;
            break;
        }
        case MessageMediaTypeMedicineCoupon:
        {
            qwmsg.richbody = model.richBody;
            qwmsg.body = model.text;
            qwmsg.star = model.title;
            qwmsg.imgUrl = model.activityUrl;
            
            qwmsg.title = model.subTitle;
            qwmsg.fileUrl = model.otherID;
            break;
        }
            //优惠活动
        case MessageMediaTypeMedicineSpecialOffers:
        {
            
            qwmsg.richbody = model.richBody;
            qwmsg.body = model.text;
            qwmsg.star = model.title;
            qwmsg.imgUrl = model.activityUrl;
            qwmsg.title = model.otherID ;
            qwmsg.fileUrl = model.thumbnailUrl;
            break;
        }
        default:
        break;
    }
    return qwmsg;
}
//QWMessage->MessageModel
- (MessageModel *)buildMessageFromQWMessage:(QWMessage *)qwmsg
{
    NSString *tt=(qwmsg.timestamp.length>10)?[qwmsg.timestamp  substringToIndex:10]:qwmsg.timestamp;
    NSDate *dt=[NSDate dateWithTimeIntervalSince1970:[tt doubleValue]];
    //    DebugLog(@"%@ %@",tt,qwmsg.timestamp);
    MessageModel *msg = nil;
    switch ([qwmsg.messagetype integerValue]){
        case MessageMediaTypeText: {
            msg = [[MessageModel alloc] initWithText:qwmsg.body sender:self.oID timestamp:dt UUID:qwmsg.UUID];
            break;
        }
        case MessageMediaTypePhoto: {
            msg = [[MessageModel alloc] initWithPhoto:nil thumbnailUrl:qwmsg.richbody originPhotoUrl:qwmsg.richbody sender:self.oID timestamp:dt UUID:qwmsg.UUID richBody:msg.richBody];
            break;
        }
        case MessageMediaTypeLocation: {
            NSString *latitude = [qwmsg.star componentsSeparatedByString:@","][0];
            NSString *longitude = [qwmsg.star componentsSeparatedByString:@","][1];
            msg = [[MessageModel alloc] initWithLocation:qwmsg.body latitude:latitude longitude:longitude sender:self.oID timestamp:dt UUID:qwmsg.UUID];
            break;
        }
        case MessageMediaTypeActivity: {
            msg = [[MessageModel alloc] initMarketActivity:qwmsg.star sender:self.oID imageUrl:qwmsg.imgUrl content:qwmsg.body comment:@"" richBody:qwmsg.richbody timestamp:dt UUID:qwmsg.UUID];
            break;
        }
        
        
        // add  by  shen
        case MessageMediaTypeStarStore:
        {
            msg = [[MessageModel alloc] initInviteEvaluate:qwmsg.body sender:qwmsg.sendname timestamp:dt  UUID:qwmsg.UUID];
            msg.starMark = [qwmsg.star integerValue];
            if(msg.starMark > 0) {
                msg.isMarked = NO;
            }else{
                msg.isMarked = YES;
            }
            break;
        }
        
        
        case MessageMediaTypePhone:
        {
            msg = [[MessageModel alloc]initWithPhone:qwmsg.body timestamp:dt UUID:qwmsg.UUID];
            break;
        }
        case MessageMediaTypeHeader:
        {
            msg = [[MessageModel alloc]initWithHeader:qwmsg.body timestamp:dt UUID:qwmsg.UUID];
            break;
        }
        case MessageMediaTypeFooter:
        {
            msg = [[MessageModel alloc]initWithFooter:qwmsg.body timestamp:dt UUID:qwmsg.UUID];;
            break;
        }
        case MessageMediaTypeLine:
        {
            msg = [[MessageModel alloc]initWithLine:qwmsg.body timestamp:dt UUID:qwmsg.UUID];;
            break;
        }
        case MessageMediaTypeMedicineShowOnce:
        {
            msg = [[MessageModel alloc] initWithMedicineShowOnce:qwmsg.body productId:qwmsg.richbody imageUrl:qwmsg.imgUrl sender:@"" timestamp:dt UUID:qwmsg.UUID];
            break;
        }
        case MessageMediaTypeMedicineSpecialOffersShowOnce:
        {
            NSString *imageUrl = qwmsg.imgUrl;
            if(imageUrl == nil)
            imageUrl = @"";
            NSString *star = qwmsg.star;
            if(star == nil || [star isEqual:[NSNull null]])
            star = @"";
            msg = [[MessageModel alloc] initWithSpecialOffersShowOnce:star content:qwmsg.body activityUrl:imageUrl activityId:qwmsg.richbody sender:@"" timestamp:dt UUID:qwmsg.UUID];
            break;
        }
        // add  end
        // add yqy
        case MessageMediaTypeVoice:{
            msg = [[MessageModel alloc] initWithVoicePath:qwmsg.richbody voiceUrl:qwmsg.fileUrl voiceDuration:qwmsg.duration sender:self.oID timestamp:dt UUID:qwmsg.UUID];
            break;
        }
        case MessageMediaTypeMedicine:
        {
            msg = [[MessageModel alloc] initWithMedicine:qwmsg.body productId:qwmsg.richbody imageUrl:qwmsg.imgUrl sender:self.oID timestamp:dt UUID:qwmsg.UUID];
            break;
        }
        case MessageMediaTypeStoreMedicine:
        {
            msg = [[MessageModel alloc] initWithStoreMedicine:qwmsg.body productId:qwmsg.richbody imageUrl:qwmsg.imgUrl spec:qwmsg.spec branchId:qwmsg.branchId branchProId:qwmsg.branchProId sender:self.oID timestamp:dt UUID:qwmsg.UUID];
            break;
        }
            //优惠活动
        case MessageMediaTypeMedicineSpecialOffers:
        {
            msg = [[MessageModel alloc] initWithSpecialOffers:qwmsg.star content:qwmsg.body activityUrl:qwmsg.imgUrl activityId:qwmsg.richbody groupId:qwmsg.title branchLogo:qwmsg.fileUrl sender:self.oID timestamp:dt UUID:qwmsg.UUID];
            break;
        }
            //优惠商品
        case MessageMediaTypeMedicineCoupon:{
            msg = [[MessageModel alloc] initWithMedicineCoupon:qwmsg.body productId:qwmsg.richbody imageUrl:qwmsg.imgUrl pmtLable:qwmsg.title pmtID:qwmsg.fileUrl sender:self.oID timestamp:dt UUID:qwmsg.UUID];
            break;
        }
            //优惠券
        case MessageMediaTypeCoupon:{
            NSArray *atmp=[qwmsg.list componentsSeparatedByString:@";"];
            msg = [[MessageModel alloc] initWithCoupon:qwmsg.title couponName:qwmsg.body couponValue:qwmsg.richbody couponTag:qwmsg.star couponId:qwmsg.fileUrl begin:atmp.firstObject end:atmp.lastObject scope:StrFromInt(qwmsg.fromTag) top:qwmsg.tags imgUrl:qwmsg.imgUrl sender:self.oID timestamp:dt UUID:qwmsg.UUID];
            break;
        }
        default:
        break;
    }
    if([qwmsg.direction integerValue] == MessageTypeReceiving) {
        msg.messageDeliveryType = MessageTypeReceiving;
        msg.avatorUrl = qwmsg.avatorUrl;
    }else{
        msg.messageDeliveryType = MessageTypeSending;
        msg.avatorUrl = QWGLOBALMANAGER.configure.avatarUrl;
    }
    msg.sended = [qwmsg.issend integerValue];
    msg.download = [qwmsg.download integerValue];
    
    return msg;
}

//db取出的QWMessage转MessageModel
- (NSMutableArray *)messagesListFromQWMessagesList:(NSArray*)array{
    NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:self.pageSize];
    for(QWMessage *qwmsg in array)
    {
        MessageModel *msg=[self buildMessageFromQWMessage:qwmsg];
        if(msg)
        [retArray addObject:msg];
    }
    
    return retArray;
}

//加入队列
- (void)messagesQueue:(id)obj reset:(BOOL)reset{
    if (obj==nil) {
        return;
    }
    
    if (reset) {
        self.arrMessages = nil;
    }
    
    if (self.arrMessages == nil) {
        self.arrMessages = [[NSMutableArray alloc]initWithCapacity:self.pageSize];
    }
    
    if ([obj isKindOfClass:[MessageModel class]]) {
        [self.arrMessages addObject:obj];
    }
    else if ([obj isKindOfClass:[NSArray class]]){
        [self.arrMessages addObjectsFromArray:obj];
    }
}

//翻页数据加入呈现队列
- (void)messagesHistory:(id)obj{
    if (obj==nil) {
        return;
    }
    
    if (self.arrMessages == nil) {
        self.arrMessages = [[NSMutableArray alloc]initWithCapacity:self.pageSize];
    }
    
    if ([obj isKindOfClass:[NSArray class]]){
        [self.arrMessages insertArray:obj atIndex:0];
    }
    //    else if ([obj isKindOfClass:[MessageModel class]]) {
    //        [self.arrMessages insertObject:obj atIndex:0];
    //    }
    
}

//判断是非有呈现数据
- (BOOL)hadMessages{
    if (self.arrMessages && self.arrMessages.count>0) return YES;
    return NO;
}




#pragma mark  返回所需数据
//刷新UI呈现
- (void)showCurrentMessages:(IMListType)rType successData:(id)successData{
    if (msgListBlock) {
        msgListBlock(self.arrMessages, rType);
    }
    
    if (successStatusBlock) {
        successStatusBlock(successData);
    }
}

//历史/翻页数据要UI呈现
- (void)showHistoryMessages:(IMHistoryBlock)block success:(IMSuccessBlock)success{
    [self setOffset:0];
    NSArray *arr1=[self getDataFromDB];
    NSArray *arr2=[self messagesListFromQWMessagesList:arr1];
    [self messagesHistory:arr2];
    
    if (block) {
        if (arr2.count>0) {
            block(YES);
        }
        else block(NO);
    }
    
    if (success) {
        success(nil);
    }
}


#pragma mark - 方法
//根据uuid取数据model
- (MessageModel *)getMessageWithUUID:(NSString *)uuid
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"UUID == %@",uuid];
    NSArray *array = [self.arrMessages filteredArrayUsingPredicate:predicate];
    if([array count] > 0) {
        return array[0];
    }else{
        return nil;
    }
}

- (NSString *)toJSONStr:(id)theData{
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];;
        
    }else{
        return nil;
    }
}
//取得时间＋1秒
- (NSDate *)dateAddOneSecond:(NSDate*)date{
    //    NSDate *date = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.second = 1;
    NSDate *next = [gregorian dateByAddingComponents:components toDate:date options:0];
    return next;
}
//服务器时间＋轮询最大间隔。给断网数据用
- (NSDate *)getServerMaxInterval{
    if (self.serverTime<=0) {
        return nil;
    }
    DebugLog(@"%f %f",_serverTime,kPollingMaxInterval);
    double dd=((double)_serverTime + (double)kPollingMaxInterval) ;
    NSDate *dt=[NSDate dateWithTimeIntervalSince1970:dd];
    //    [NSString stringWithFormat:@"%.0f",(double)(self.serverTime+kPollingMaxInterval) ];
    return dt;
}

//- (void)parseHistoryMessage:(CustomerConsultDetailList *)model cache:(BOOL)cache
//{
//}


#pragma mark 接收通知
- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    if (type == NotifAppDidEnterBackground){
        //进后台
        DebugLog(@"轮询暂停");
        [self suspend];
    }
    else if (type == NotifAppDidBecomeActive){
        //back
        DebugLog(@"轮询继续");
        [self resume];
    }
}



#pragma mark 全局通知
- (void)addObserverGlobal{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotif:) name:kQWGlobalNotification object:nil];
}

- (void)removeObserverGlobal{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kQWGlobalNotification object:nil];
}

- (void)getNotif:(NSNotification *)sender{
    
    NSDictionary *dd=sender.userInfo;
    NSInteger ty=-1;
    id data;
    id obj;
    
    if ([GLOBALMANAGER object:[dd objectForKey:@"type"] isClass:[NSNumber class]]) {
        ty=[[dd objectForKey:@"type"]integerValue];
    }
    data=[dd objectForKey:@"data"];
    obj=[dd objectForKey:@"object"];
    
    [self getNotifType:ty data:data target:obj];
}



@end
