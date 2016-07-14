
//
//  QWGlobalManager.m
//  APP
//
//  Created by qw on 15/2/27.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QWGlobalManager.h"
#import "QWLocation.h"
//引导页
#import "AppGuide.h"
#import "QWUserDefault.h"
#import "AppraiseModel.h"
#import "Store.h"
#import "StoreModelR.h"
#import "Mbr.h"
#import "SVProgressHUD.h"
#import "LoginViewController.h"
#import "IMApi.h"
#import "QWMessage.h"
#import "XHMessageBubbleFactory.h"
#import "XHMessage.h"
#import "XHAudioPlayerHelper.h"
#import "SBJson.h"
#import "System.h"
#import "AppDelegate.h"
#import "Consult.h"
#import "ConsultPTP.h"
#import "IMApi.h"
#import "VersionUpdate.h"
#import "Version.h"
#import "RedPointModel.h"
#import "XMPPStream.h"
#import "HomePageViewController.h"
#import "Circle.h"
#import "CircleModel.h"
#import "LaunchEntranceViewController.h"
#import "ExpertLoginViewController.h"
#import "ExpertAuthViewController.h"
#import "ExpertAuthCommitViewController.h"
#import "NotificationModel.h"
#import "NSDate+Category.h"
#import "ChatManagerDefs.h"
#import "ExpertMessageCenter.h"
#import "UserChat.h"
#import "UserChatModel.h"
#import "InterlocuationViewController.h"
#import "ConsultationMainViewController.h"
#import "MessageSegmentControl.h"
#import "InterlocutionListViewController.h"
#import "CreditEnhanceAlertView.h"
#import "UIAlertViewHelper.h"
#import "StoreCreditViewController.h"
#import "MsgBox.h"
#import "Rpt.h"
#import "RptModelR.h"
#import "CustomScoreTaskView.h"
#import "ScoreTaskAssistManager.h"
#import "StoreDetailViewController.h"
#import "AppealUtil.h"
static NSString *kToken12345= @"12345";
@interface QWGlobalManager()
{
    BOOL _qwTabBarShown;
}
@property (nonatomic, strong) NSString *unreadOrderNum;
@property (nonatomic, strong) CustomScoreTaskView *viewTask;
@property (nonatomic, strong) ScoreTaskAssistManager *scoreManager;
@end

@implementation QWGlobalManager
@synthesize heartBeatTimer;


@synthesize deviceToken=_deviceToken;

+ (QWGlobalManager *)sharedInstance
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (id)init
{
    self = [super init];
    if (self) {
        self.deviceToken = [XMPPStream generateUUID];
        _currentNetWork = ReachableViaWWAN;
        // 全局配置信息
        [self loadAppConfigure];
        
        // 初始化网络监控
        self.reachabilityMonitor = [[ReachabilityMonitor alloc] initWithDelegate:self];
        [self.reachabilityMonitor startMonitoring];
        
        // 初始化高德地图,并定位自己当前点,会提示app要使用当前位置,方便后期直接调用
        [MAMapServices sharedServices].apiKey = AMAP_KEY;
        self.mapView = [[MAMapView alloc] init];
        self.mapView.showsUserLocation = YES;
        
        // IM会话请求
        self.imHttpClent = [HttpClient new];
        //cj----cj
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        NSString *apiUrl = [def objectForKey:@"APIDOMAIN"];
        NSString *h5Url = [def objectForKey:@"H5DOMAIN"];
        if(apiUrl&&![apiUrl isEqualToString:@""]){
            [self.imHttpClent setBaseUrl:apiUrl];
        }else{
            [self.imHttpClent setBaseUrl:BASE_URL_V2];
        }
        self.imHttpClent.progressEnabled = NO;
        
        // 未找到使用的地方，暂时不删
        self.bInMessageShowTypeAsking = YES;
        
        // 是否需要校验token
        self.isCheckToken = YES;
        self.scoreManager = [[ScoreTaskAssistManager alloc] init];
//
       // [MobClick startWithAppkey:UMENG_KEY];
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
       // [MobClick setAppVersion:version];
        [self addObserverGlobal];
        
    }
    return self;
}

#pragma mark 全局通知

- (void)addObserverGlobal{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotif:) name:kQWGlobalNotification object:nil];
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

- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj{
    if (type == NotifLoginSuccess) {
        [self saveCreditEnhanceWithModel:data];
    }
    if (type == NotiQWTabBarDidChangeAppear) {
        
        _qwTabBarShown = ![data[@"hidden"] boolValue];
        if (_qwTabBarShown) {
            if (!IS_EXPERT_ENTRANCE) {
                [self.scoreManager checkIfOverOneHour];
            }
            if ([CreditEnhanceInfoModel getFromNsuserDefault:QWDEFAULT_CURRENT_USER_ENHANCE_INFO]) {
                [self showAlertIfNeededAndDelayed:!_qwTabBarShown];
            }
        }
    }
    if (type == NotiMsgBoxRedPointNeedUpdate) {
        [self checkMsgBoxNotice];
    }
}

#pragma mark ---- devicetoken ----

- (void)setDeviceToken:(NSString *)deviceToken{
    _deviceToken=deviceToken;
}

- (NSString *)deviceToken{
    NSString *token=(_deviceToken)?_deviceToken:kToken12345;
    return token;
}

#pragma mark ---- 地图定位 ----

//读取地图信息
- (void)readLocationInformation:(ReadLocationBlock)block
{
    [[QWLocation sharedInstance] requetWithCache:LocationRoom timeout:10.0f block:^(CLLocation *currentLocation, AMapReGeocodeSearchResponse *response, LocationStatus status) {
        if(status == LocationRegeocodeSuccess)
        {
            block([self __buildMapInfoModelWith:currentLocation searchResponse:response]);
        }else{
            block(nil);
        }
    }];
}

//3.0最新的统计事件
- (void)statisticsEventId:(NSString *)eventId withLable:(NSString*)eventLable withParams:(NSMutableDictionary *)params
{
    StatisticsModel *model = [StatisticsModel new];
    if(!StrIsEmpty(eventId) ){
        model.eventId = eventId;
    }else{
        model.eventId = @"";
    }
    if(!StrIsEmpty(eventLable)){
        model.eventLabel=eventLable;
    }else{
        model.eventLabel=@"";
    }
    if(params&&([params isKindOfClass:[NSMutableDictionary class]])){
        model.params = params;
    }else{
        model.params=[NSMutableDictionary dictionary];
    }
    [QWCLICKEVENT qwTrackEventWithAllModel:model];
}


//重新定位
- (void)resetLocationInformation:(ReadLocationBlock)block
{
    if(![QWLocation locationServicesAvailable]) {
        block(nil);
    }
    [[QWLocation sharedInstance] requetWithReGoecode:LocationRoom timeout:10.0f block:^(CLLocation *currentLocation, AMapReGeocodeSearchResponse *response, LocationStatus status) {
        if(status == LocationRegeocodeSuccess)
        {
            block([self __buildMapInfoModelWith:currentLocation searchResponse:response]);
        }else{
            block(nil);
        }
    }];
}
//保存上一次地理位置信息
- (void)saveLastLocationInfo:(MapInfoModel *)mapinfo
{
    AMapReGeocode *regeoCode = [[AMapReGeocode alloc] init];
    regeoCode.formattedAddress = mapinfo.formattedAddress;
    regeoCode.addressComponent = [[AMapAddressComponent alloc] init];
    regeoCode.addressComponent.province = mapinfo.province;
    regeoCode.addressComponent.city = mapinfo.city;
    regeoCode.addressComponent.district = mapinfo.district;
    
    CLLocation *lastLocation = mapinfo.location;
    AMapReGeocodeSearchResponse *lastReGeocodeSearchResponse = [[AMapReGeocodeSearchResponse alloc] init];
    lastReGeocodeSearchResponse.regeocode = regeoCode;
    [[QWLocation sharedInstance] saveLastLoation:lastLocation lastResponse:lastReGeocodeSearchResponse];
}

- (MapInfoModel *)__buildMapInfoModelWith:(CLLocation *)location
                 searchResponse:(AMapReGeocodeSearchResponse *)response
{
    MapInfoModel *mapInfoModel = [[MapInfoModel alloc] init];
    mapInfoModel.city = [[[response regeocode] addressComponent] city];
    mapInfoModel.province = [[[response regeocode] addressComponent] province];
    mapInfoModel.district = [[[response regeocode] addressComponent] district];
    mapInfoModel.formattedAddress = [[response regeocode] formattedAddress];
    mapInfoModel.location = location;
    return mapInfoModel;
}

#pragma mark ---- 私有数据库名称 ----

- (NSString*)getPrivateDBName
{
    NSString* ret = @"";
    if (self.configure) {
        
        if(IS_EXPERT_ENTRANCE){
            ret = self.configure.expertMobile;
        }else{
            ret = self.configure.userName;

        }
    }
    return ret;
}

#pragma mark ---- 全局配置信息 ----

- (void)loadAppConfigure
{
    self.configure = [UserInfoModel getFromNsuserDefault:USER_PERSON_INFO];
    if (!self.configure) {
        self.configure = [[UserInfoModel alloc] init];
    }
}


//根据当前登陆的账号,保存配置信息
- (void)saveAppConfigure
{
    [self.configure saveToNsuserDefault:USER_PERSON_INFO];
}

- (void)saveCreditEnhanceWithModel:(id)model
{
    if ([model isKindOfClass:[StoreUserInfoModel class]] || [model isKindOfClass:[CheckTokenModel class]]) {
        CreditEnhanceInfoModel *infoModel = [CreditEnhanceInfoModel new];
        infoModel.currScore = [model valueForKey:NSStringFromSelector(@selector(currScore))];
        infoModel.yesterdayScore = [model valueForKey:NSStringFromSelector(@selector(yesterdayScore))];
        infoModel.rank = [model valueForKey:NSStringFromSelector(@selector(rank))];
        infoModel.firstLoginEver = [model valueForKey:NSStringFromSelector(@selector(firstLoginEver))];
        infoModel.firstLoginToday = [model valueForKey:NSStringFromSelector(@selector(firstLoginToday))];
        infoModel.lastUpdateDate = [NSDate date];
        if (infoModel.firstLoginEver.boolValue || infoModel.firstLoginToday.boolValue) {
            [infoModel saveToNsuserDefault:QWDEFAULT_CURRENT_USER_ENHANCE_INFO];
        }
    }
    [self showAlertIfNeededAndDelayed:!_qwTabBarShown];
}

-(RegisterModelR*) getRegisterModel:(NSString*)account
{
    RegisterModelR* modelr = [RegisterModelR getFromNsuserDefault:[NSString stringWithFormat:@"%@/quickRegist",account]];
    return modelr;
    
}

#pragma mark ---- 用户行为统计 ----
- (void)saveOperateLog:(NSString *)type
{
    RptModelR *modelR = [RptModelR new];
    modelR.channel = @"APP STORE";
    modelR.type = type;
    modelR.deviceType = @"2";
    modelR.deviceCode = DEVICE_IDD;
    
    if (IS_EXPERT_ENTRANCE) {
        //专家
        if (StrIsEmpty(QWGLOBALMANAGER.configure.expertToken)) {
            modelR.token = @"";
        }else{
            modelR.token = QWGLOBALMANAGER.configure.expertToken;
        }
    }else{
        //门店
        if (StrIsEmpty(QWGLOBALMANAGER.configure.userToken)) {
            modelR.token = @"";
        }else{
            modelR.token = QWGLOBALMANAGER.configure.userToken;
        }
    }
    
    if (IS_EXPERT_ENTRANCE) {
        if (StrIsEmpty(QWGLOBALMANAGER.configure.expertMobile)) {
            modelR.mobile = @"";
        }else{
            modelR.mobile = QWGLOBALMANAGER.configure.expertMobile;
        }
    }else{
        modelR.mobile = @"";
    }
    modelR.userType = @"2";
    
    if (StrIsEmpty(QWGLOBALMANAGER.configure.storeCity)) {
        modelR.city = @"";
    }else{
        modelR.city = QWGLOBALMANAGER.configure.storeCity;
    }
    
    [Rpt RptOperateSaveLogWithParams:modelR success:^(id obj) {
        
    } failure:^(HttpException *e) {
        
    }];
    
}


#pragma mark 发出全局通知
- (NSDictionary *)postNotif:(Enum_Notification_Type)type data:(id)data object:(id)obj{
    return [super postNotif:type data:data object:obj];
}

#pragma mark  社会分享
-(void)initsocailShare:(NSString *)urlString
{

    //5472f8adfd98c5eb22000bd4
    [UMSocialData setAppKey:UMENG_KEY];//ok,已是全维应用
    
    
    //设置手机腾讯AppKey   QQ2826456758
    [UMSocialQQHandler setQQWithAppId:@"1103608063"
                               appKey:@"MQHBgUoH3ge10Ur2"
                                  url:urlString];
    
    [UMSocialWechatHandler setWXAppId:@"wx428d7b043d6fa95b"
                            appSecret:@"bd5c51feeb1b73d52b82d0d23e185edc"
                                  url:urlString];
    
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"4090557109"
                                              secret:@"fa2ffccebe85f21eb37d27ed536744e4"
                                         RedirectURL:@""];
}

#pragma mark 计算文字大小
- (CGSize) getTextSizeWithContent:(NSString*)text WithUIFont:(UIFont*)font WithWidth:(CGFloat)width
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 5000)];
    label.font = font;
    label.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    label.numberOfLines = 0;
    label.text = text;
    [label sizeToFit];
    return label.frame.size;
}

/**
 *  根据控制返回对应药品属性
 *
 *  @param signcode 药品控制码
 *
 *  @return String类型
 */
- (NSString *)TypeOfDrugByCode:(NSString *)signcode{
    
    if([signcode isEqualToString:@"1a"]){           //处方药西药
        return @"处方药西药";
    }else if([signcode isEqualToString:@"1b"]){     //处方药中成药
        return @"处方药中成药";
    }else if([signcode isEqualToString:@"2a"]){     //甲类OTC非处方药西药
        return @"甲类OTC非处方药西药";
    }else if([signcode isEqualToString:@"2b"]){     //甲类OTC非处方药中成药
        return @"甲类OTC非处方药中成药";
    }else if ([signcode isEqualToString:@"3a"]){    //乙类OTC非处方药西药
        return @"乙类OTC非处方药西药";
    }else if([signcode isEqualToString:@"3b"]) {    //乙类OTC非处方药乙类OTC非处方药
        return @"乙类OTC非处方药乙类OTC非处方药";
    }else if([signcode isEqualToString:@"4c"]) {    //定型包装中药饮片
        return @"定型包装中药饮片";
    }else if([signcode isEqualToString:@"4d"]) {    //散装中药饮片
        return @"散装中药饮片";
    }else if([signcode isEqualToString:@"5"]) {     //保健食品
        return @"保健食品";
    }else if([signcode isEqualToString:@"6"]) {     //食品
        return @"食品";
    }else if([signcode isEqualToString:@"7"]) {     //械字号一类
        return @"械字号一类";
    }else if([signcode isEqualToString:@"8"]) {     //械字号二类
        return @"械字号二类";
    }else if([signcode isEqualToString:@"10"]) {    //消字号
        return @"消字号";
    }else if([signcode isEqualToString:@"11"]) {    //妆字号
        return @"妆字号";
    }else if([signcode isEqualToString:@"12"]) {    //无批准号
        return @"无批准号";
    }else if([signcode isEqualToString:@"13"]) {    //其他
        return @"其他";
    }else if([signcode isEqualToString:@"9"]) {     //械字号三类
        return @"械字号三类";
    }
    return @"";
}

/**
 *  根据控制返回对应药品显示用途
 *
 *  @param Signcode 药品控制码
 *
 *  @return String类型
 */
- (NSString *)UseOfDrugByCode:(NSString *)signcode{
    
    //1.适应症
    //西药(处方药西药1a,甲类OTC西药2a,乙类OTC西药3a)
    //2.主治功能
    //中成药(处方药中成药1b,甲类OTC中成药2b,乙类OTC中成药3b)、中药饮片(中药定型包装4c,散装中药饮片4d)
    //3.保健功能
    //保健食品(保健食品5，食品6)
    //4.适用范围
    //个人护理品(消字号10，妆字号11)
    //5.产品用途
    //医疗器械(械字号一类7,械字号二类8,械字号三类9)
    //6.不展示
    //其他
    
    //1.西药            展示适应症
    if([signcode isEqualToString:@"1a"]){
        return @"适应症";
    }
    if([signcode isEqualToString:@"2a"]){
        return @"适应症";
    }
    if([signcode isEqualToString:@"3a"]){
        return @"适应症";
    }
    //2.中成药、中药饮片   展示主治功能
    if([signcode isEqualToString:@"1b"]){
        return @"主治功能";
    }
    if([signcode isEqualToString:@"2b"]){
        return @"主治功能";
    }
    if([signcode isEqualToString:@"3b"]){
        return @"主治功能";
    }
    if([signcode isEqualToString:@"4c"]){
        return @"主治功能";
    }
    if([signcode isEqualToString:@"4d"]){
        return @"主治功能";
    }
    //3.保健功能          展示保健功能
    if([signcode isEqualToString:@"5"]){
        return @"保健功能";
    }
    if([signcode isEqualToString:@"6"]){
        return @"保健功能";
    }
    //4.个人护理品        展示适用范围
    if([signcode isEqualToString:@"10"]){
        return @"适用范围";
    }
    if([signcode isEqualToString:@"11"]){
        return @"适用范围";
    }
    //5.医疗器械         展示产品用途
    if([signcode isEqualToString:@"7"]){
        return @"产品用途";
    }
    if([signcode isEqualToString:@"8"]){
        return @"产品用途";
    }
    if([signcode isEqualToString:@"9"]){
        return @"产品用途";
    }
    
    return @"";
}

#pragma mark 特殊字符的替换
- (NSString *)replaceSpecialStringWith:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"    &nbsp;&nbsp;&nbsp;&nbsp;" withString:@"    "];
    string = [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\r\n"];
    string = [string stringByReplacingOccurrencesOfString:@"<br>" withString:@"\r\n"];
    string = [string stringByReplacingOccurrencesOfString:@"<p/>" withString:@"\r\n"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt:" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt:" withString:@">"];
    return string;
}


#pragma mark 符号字符的替换，用于关键词净化
- (NSString *)replaceSymbolStringWith:(NSString *)string
{
    if(!string)
        return @"";
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"，" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"_" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"/" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@":" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@";" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"$" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"@" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"。" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"?" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"!" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"！" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"？" withString:@""];
    return string;
}


- (NSString *)updateDisplayTime:(NSDate *)date
{
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:date];
    NSDateComponents *todayComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:today];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm "];
    NSString *staicString = [dateFormatter stringFromDate:date];
    NSString *dynamicString = nil;
    if (dateComponents.year == todayComponents.year && dateComponents.month == todayComponents.month && dateComponents.day == todayComponents.day)
    {
        dynamicString = @"";
    }else if ((dateComponents.year == todayComponents.year) && (dateComponents.month == todayComponents.month) && (dateComponents.day == todayComponents.day - 1)) {
        dynamicString = NSLocalizedString(@"昨天", nil);
    }else if ((dateComponents.year == todayComponents.year) && (dateComponents.weekOfYear == todayComponents.weekOfYear)) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"EEEE";
        dynamicString = [dateFormatter stringFromDate:date];
        dynamicString = NSLocalizedString(dynamicString, nil);
    }else if (dateComponents.year == todayComponents.year){
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM-dd";
        dynamicString = [dateFormatter stringFromDate:date];
    }else{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        dynamicString = [dateFormatter stringFromDate:date];
    }
    
    if (dynamicString && dynamicString.length) {
        return [NSString stringWithFormat:@"%@ %@",dynamicString,staicString];
    }
    return [NSString stringWithFormat:@"%@",staicString];
}

- (void)checkLogEnable
{
    if(!self.loginStatus) {
        return;
    }
    SystemModelR *modelR = [SystemModelR new];
    
    if (IS_EXPERT_ENTRANCE) {
        modelR.token = self.configure.expertToken;
    }else{
        modelR.token = self.configure.userToken;
    }
    [System systemAppLogFlagWithParams:modelR success:^(AppLogFlagModel *model) {
        self.DebugLogEnable = model.flag;
        if (self.DebugLogEnable) {
            [DDLog addLogger:QWGLOBALMANAGER.fileLogger];
            
        }else{
            [DDLog removeLogger:QWGLOBALMANAGER.fileLogger];
        }
    } failure:NULL];
}

- (void)upLoadLogFile
{
    if(!self.loginStatus) {
        return;
    }
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat: @"Documents/Log/"]];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *filesPath = [manager contentsOfDirectoryAtPath:path error:nil];
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *filePathArray = [NSMutableArray array];
    for(NSString *filePath in filesPath)
    {
        NSData *file = [NSData dataWithContentsOfFile:[path stringByAppendingFormat:@"/%@",filePath]];
        [array addObject:file];
        [filePathArray addObject:[path stringByAppendingFormat:@"/%@",filePath]];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = QWGLOBALMANAGER.configure.userToken;
    params[@"deviceType"] = @"2";
    [HttpClientMgr upLogFile:array filePaths:filePathArray params:params withUrl:AppUploadLog success:^(NSString *path) {
        NSFileManager *manager = [NSFileManager defaultManager];
        [manager removeItemAtPath:path error:nil];
    } failure:NULL uploadProgressBlock:NULL];
}



#pragma mark - 

-(NSString *)updatehomepageTime:(NSDate *)date{
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:date];
    NSDateComponents *todayComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:today];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *staicString = [dateFormatter stringFromDate:date];
    NSString *dynamicString = nil;
    if (dateComponents.year == todayComponents.year && dateComponents.month == todayComponents.month && dateComponents.day == todayComponents.day)
    {
        dynamicString = @"";
        
    }else if ((dateComponents.year == todayComponents.year) && (dateComponents.month == todayComponents.month) ) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM-dd";
        dynamicString = [dateFormatter stringFromDate:date];
        return dynamicString;
    }else if (dateComponents.year == todayComponents.year){
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM-dd";
        dynamicString = [dateFormatter stringFromDate:date];
        return dynamicString;
    }else{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        dynamicString = [dateFormatter stringFromDate:date];
        return dynamicString;
    }
    
    return [NSString stringWithFormat:@" %@ %@",dynamicString,staicString];
}

- (NSString *)updateFirstPageTimeDisplayer:(NSDate *)date{
    
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:date];
    NSDateComponents *todayComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:today];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm "];
    NSString *staicString = [dateFormatter stringFromDate:date];
    NSString *dynamicString = nil;
    if (dateComponents.year == todayComponents.year && dateComponents.month == todayComponents.month && dateComponents.day == todayComponents.day){
        dynamicString = @"";
    }else if ((dateComponents.year == todayComponents.year) && (dateComponents.month == todayComponents.month) ) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM-dd";
        dynamicString = [dateFormatter stringFromDate:date];
        return dynamicString;
    }else if (dateComponents.year == todayComponents.year){
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM-dd";
        dynamicString = [dateFormatter stringFromDate:date];
        return dynamicString;
    }else{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        dynamicString = [dateFormatter stringFromDate:date];
        return dynamicString;
    }
    return [NSString stringWithFormat:@" %@ %@",dynamicString,staicString];
}

#pragma mark ---- 修改软件使用人手机号 ----

- (void)startChangePhoneVerifyCode:(NSString *)phoneNum
{
    SendVerifyCodeModelR *sendCodeModelR = [[SendVerifyCodeModelR alloc] init];
    sendCodeModelR.mobile = phoneNum;
    sendCodeModelR.type = @"6";
    HttpClientMgr.progressEnabled = NO;
    [Mbr SendVerifyCodeWithParam:sendCodeModelR success:^(id responseObj) {
        BaseAPIModel *msg = [BaseAPIModel parse:responseObj];
        if ([msg.apiStatus intValue] == 0){
            [SVProgressHUD showSuccessWithStatus:@"获取验证码成功" duration:DURATION_LONG];
            Countdown *cd=[[Countdown alloc]init];
            [cd setCD:60 block:^(int cd) {
                DebugLog(@"--- %i",cd);
                self.getChangePhoneCd = cd;
                [self postNotif:NotiCountDonwChangePhone data:[NSNumber numberWithInteger:cd] object:nil];
            }];
        }
        else{
            [SVProgressHUD showErrorWithStatus:msg.apiMessage duration:DURATION_LONG];
        }
    } failure:^(HttpException *e) {

    }];
}

#pragma mark ---- 门店账号修改手机号 ----
- (void)startStoreEditPhoneVerifyCode:(NSString *)phoneNum
{
    SendVerifyCodeModelR *sendCodeModelR = [[SendVerifyCodeModelR alloc] init];
    sendCodeModelR.mobile = phoneNum;
    sendCodeModelR.type = @"6";
    HttpClientMgr.progressEnabled = NO;
    [Mbr SendVerifyCodeWithParam:sendCodeModelR success:^(id responseObj) {
        BaseAPIModel *msg = [BaseAPIModel parse:responseObj];
        if ([msg.apiStatus intValue] == 0){
            [SVProgressHUD showSuccessWithStatus:@"获取验证码成功" duration:DURATION_LONG];
            Countdown *cd=[[Countdown alloc]init];
            [cd setCD:60 block:^(int cd) {
                DebugLog(@"--- %i",cd);
                self.getStoreEditPhoneCd = cd;
                [self postNotif:NotiCountStoreEditPhone data:[NSNumber numberWithInteger:cd] object:nil];
            }];
        }
        else{
            [SVProgressHUD showErrorWithStatus:msg.apiMessage duration:DURATION_LONG];
        }
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ---- 快捷注册验证码 ----

- (void)startRgisterVerifyCode:(NSString *)phoneNum
{
    SendVerifyCodeModelR *model=[SendVerifyCodeModelR new];
    model.mobile = phoneNum;
    model.type=@"4";
    
    [Mbr SendVerifyCodeWithParam:model success:^(id obj) {
        BaseAPIModel *msg = [BaseAPIModel parse:obj];
        if ([msg.apiStatus intValue] == 0){
            Countdown *cd=[[Countdown alloc]init];
            [cd setCD:60 block:^(int cd) {
                DebugLog(@"--- %i",cd);
                self.getVerifyCd = cd;
                [self postNotif:NotiCountDonwRegister data:[NSNumber numberWithInteger:cd] object:nil];
            }];
            [SVProgressHUD showSuccessWithStatus:@"获取验证码成功" duration:DURATION_LONG];
        }
        else{
            [SVProgressHUD showErrorWithStatus:msg.apiMessage duration:DURATION_LONG];
        }
        
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ---- 忘记账号或密码 ----

- (void)startForgetPasswordVerifyCode:(NSString *)phoneNum
{
    SendVerifyCodeModelR *sendModelR = [[SendVerifyCodeModelR alloc] init];
    sendModelR.mobile = phoneNum;
    sendModelR.type = @"5";
    [Mbr SendVerifyCodeWithParam:sendModelR success:^(id obj) {
        BaseAPIModel *msg = [BaseAPIModel parse:obj];
        if ([msg.apiStatus intValue] == 0){
            [SVProgressHUD showSuccessWithStatus:@"获取验证码成功" duration:DURATION_LONG];
            Countdown *cd=[[Countdown alloc]init];
            [cd setCD:60 block:^(int cd) {
                DebugLog(@"--- %i",cd);
                self.getForgetPasswordCd = cd;
                [self postNotif:NotiCountDonwForgetPassword data:[NSNumber numberWithInteger:cd] object:nil];
            }];
        }
        else{
            [SVProgressHUD showErrorWithStatus:msg.apiMessage duration:DURATION_LONG];
        }
        
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ---- 支付宝验证 ----

- (void)startChangeAliPayAccountVerifyCode:(NSString *)phoneNum
{
    
    SendVerifyCodeModelR *model=[SendVerifyCodeModelR new];
    model.mobile = phoneNum;
    model.type=@"7";
    
    [Mbr SendVerifyCodeWithParam:model success:^(id obj) {
        BaseAPIModel *msg = [BaseAPIModel parse:obj];
        if ([msg.apiStatus intValue] == 0){
            Countdown *cd=[[Countdown alloc]init];
            [cd setCD:60 block:^(int cd) {
                DebugLog(@"--- %i",cd);
                self.getChangeAlipayCd = cd;
                [self postNotif:NotiCountDonwChangeAliPayAccount data:[NSNumber numberWithInteger:cd] object:nil];
            }];
            [SVProgressHUD showSuccessWithStatus:@"获取验证码成功" duration:DURATION_LONG];
        }
        else{
            [SVProgressHUD showErrorWithStatus:msg.apiMessage duration:DURATION_LONG];
        }
        
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ---- 普通注册 ----

- (void)startCommonRegisterVerifyCode:(NSString *)phoneNum
{
    SendVerifyCodeModelR *model=[SendVerifyCodeModelR new];
    model.mobile = phoneNum;
    model.type=@"4";
    
    [Mbr SendVerifyCodeWithParam:model success:^(id obj) {
        BaseAPIModel *msg = [BaseAPIModel parse:obj];
        if ([msg.apiStatus intValue] == 0){

            Countdown *cd=[[Countdown alloc]init];
            [cd setCD:60 block:^(int cd) {
                DebugLog(@"--- %i",cd);
                self.getCommonRegisterCd = cd;
                [self postNotif:NotiCountDownCommonRegister data:[NSNumber numberWithInteger:cd] object:nil];
            }];
            
            [SVProgressHUD showSuccessWithStatus:@"获取验证码成功" duration:DURATION_LONG];
        }
        else{
            [SVProgressHUD showErrorWithStatus:msg.apiMessage duration:DURATION_LONG];
        }
        
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ---- 专家登录 ----

- (void)startExpertLoginVerifyCode:(NSString *)phoneNum
{
    SendVerifyCodeModelR *model=[SendVerifyCodeModelR new];
    model.mobile = phoneNum;
    model.type=@"10";
    
    [Mbr SendVerifyCodeWithParam:model success:^(id obj) {
        BaseAPIModel *msg = [BaseAPIModel parse:obj];
        if ([msg.apiStatus intValue] == 0){
            
            Countdown *cd=[[Countdown alloc]init];
            [cd setCD:60 block:^(int cd) {
                DebugLog(@"--- %i",cd);
                self.getExpertLoginCd = cd;
                [self postNotif:NotiCountDownExpertLogin data:[NSNumber numberWithInteger:cd] object:nil];
            }];
            
            [SVProgressHUD showSuccessWithStatus:@"获取验证码成功" duration:DURATION_LONG];
        }
        else{
            [SVProgressHUD showErrorWithStatus:msg.apiMessage duration:DURATION_LONG];
        }
        
    } failure:^(HttpException *e) {
        
    }];
}


#pragma mark ---- 专家忘记密码 ----

- (void)startExpertForgetPwdVerifyCode:(NSString *)phoneNum
{
    SendVerifyCodeModelR *model=[SendVerifyCodeModelR new];
    model.mobile = phoneNum;
    model.type=@"14";
    
    [Mbr SendVerifyCodeWithParam:model success:^(id obj) {
        BaseAPIModel *msg = [BaseAPIModel parse:obj];
        if ([msg.apiStatus intValue] == 0){
            
            Countdown *cd=[[Countdown alloc]init];
            [cd setCD:60 block:^(int cd) {
                DebugLog(@"--- %i",cd);
                self.getExpertForgetPwdCd = cd;
                [self postNotif:NotiCountDownExpertForgetPwd data:[NSNumber numberWithInteger:cd] object:nil];
            }];
            
            [SVProgressHUD showSuccessWithStatus:@"获取验证码成功" duration:DURATION_LONG];
        }
        else{
            [SVProgressHUD showErrorWithStatus:msg.apiMessage duration:DURATION_LONG];
        }
        
    } failure:^(HttpException *e) {
        
    }];
}


#pragma mark -
#pragma mark ReachabilityDelegate  网络状态监控
-(void)networkDisconnectFrom:(NetworkStatus)netStatus
{
    QWGLOBALMANAGER.currentNetWork = NotReachable;
    [SVProgressHUD showErrorWithStatus:@"网络未连接，请重试" duration:0.8f];
    
    //掉线
    [self postNotif:NotifNetworkDisconnect data:nil object:self];
}

- (void)networKCannotStartupWhenFinishLaunching
{
    QWGLOBALMANAGER.currentNetWork = NotReachable;
}

- (void)networkStartAtApplicationDidFinishLaunching:(NetworkStatus)netStatus
{
    QWGLOBALMANAGER.currentNetWork = netStatus;
    //重新获取地址
    [self postNotif:NotifLocationNeedReload data:nil object:self];
}

- (void)networkRestartFrom:(NetworkStatus)oldStatus toStatus:(NetworkStatus)newStatus
{
    QWGLOBALMANAGER.currentNetWork = newStatus;
    if (QWGLOBALMANAGER.loginStatus && newStatus != kNotReachable)
    {
    }
    [self postNotif:NotifNetworkReconnect data:nil object:self];
}

#pragma mark -
#pragma mark  清除账户信息 退出登录
- (void)clearAccountInformation
{
    if(QWGLOBALMANAGER.loginStatus == NO)
        return;
    QWGLOBALMANAGER.loginStatus = NO;
    
    LogoutModelR *model = [LogoutModelR new];
    model.token = self.configure.userToken;
    [Store LogoutWithParams:model success:^(id obj) {
        
    } failure:^(HttpException *e) {
        
    }];
    
    [QWUserDefault setObject:@{} key:@"EmployInfoViewControllerDataSource"];
    [QWGLOBALMANAGER postNotif:NotifQuitOut data:nil object:self];
    
    // 清除积分任务
    [self.scoreManager clearCurTask];
    
    [self releaseMessageTimer];

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    UINavigationController *navgationController = QWGLOBALMANAGER.tabBar.viewControllers[0];
    navgationController.tabBarItem.badgeValue = nil;
    [navgationController popToRootViewControllerAnimated:NO];
    navgationController = QWGLOBALMANAGER.tabBar.viewControllers[1];
    [navgationController popToRootViewControllerAnimated:NO];
    navgationController = QWGLOBALMANAGER.tabBar.viewControllers[2];
    [navgationController popToRootViewControllerAnimated:NO];
    navgationController = QWGLOBALMANAGER.tabBar.viewControllers[3];
    [navgationController popToRootViewControllerAnimated:NO];
    navgationController = QWGLOBALMANAGER.tabBar.viewControllers[4];
    [navgationController popToRootViewControllerAnimated:NO];
    [QWUserDefault setBool:NO key:APP_LOGIN_STATUS];
    
    QWGLOBALMANAGER.configure.passportId = @"";
    QWGLOBALMANAGER.configure.userToken = @"";
    QWGLOBALMANAGER.configure.groupId = @"";
    QWGLOBALMANAGER.configure.storeCity = @"";
    [QWGLOBALMANAGER saveAppConfigure];
    [APPDelegate showLoginViewController];
    QWGLOBALMANAGER.tabBar = nil;
//    self.configure.intTaskStep = 0;
//    [self saveAppConfigure];
}


- (void)clearExpertAccountInformation
{
    QWGLOBALMANAGER.loginStatus = NO;
    [QWGLOBALMANAGER postNotif:NotifQuitOut data:nil object:self];
    
    //关闭定时器
    [self releaseMessageTimer];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    if (QWGLOBALMANAGER.tabBar) {
        UINavigationController *navgationController = QWGLOBALMANAGER.tabBar.viewControllers[0];
        navgationController.tabBarItem.badgeValue = nil;
        [navgationController popToRootViewControllerAnimated:NO];
        navgationController = QWGLOBALMANAGER.tabBar.viewControllers[1];
        [navgationController popToRootViewControllerAnimated:NO];
    }
    
    if (!StrIsEmpty(self.configure.expertToken)) {
        [Mbr logoutWithParams:@{@"token":self.configure.expertToken}
                      success:^(id obj){
                      }
                      failure:^(HttpException *e){
                          
                      }];
        [APPDelegate showLoginViewController];
    }
    
    [QWUserDefault setBool:NO key:APP_LOGIN_STATUS];
    QWGLOBALMANAGER.configure.expertToken = @"";
    [QWGLOBALMANAGER saveAppConfigure];
    
    QWGLOBALMANAGER.tabBar = nil;
}

- (void)closePushPull
{
    
}

- (void)openPushPull
{
    
}
//登录成功调用
- (void)loginSucess
{
//    CreditEnhanceInfoModel *model = [CreditEnhanceInfoModel new];
//    model.currScore = @1;
//    model.rank = @2;
//    model.firstLoginEver = @3;
//    model.firstLoginToday = @4;
//    [self creditAlertWithType:CreditEnhanceAlertViewTypeOnce infoModel:model delayed:NO];
    [self enablePushNotification:NO];
    [self checkStoreStatu];
    QWGLOBALMANAGER.tabBar.selectedIndex = 0;
    NSMutableArray *historyArr = (NSMutableArray *)[QueryAppraiseModel getArrayFromDBWithWhere:nil];
    QWGLOBALMANAGER.AppraiseRedShow = NO;
//    [QWGLOBALMANAGER.tabBar showBadgePointWithItemTag:2];
    for (QueryAppraiseModel *dic in historyArr) {
        if ([dic.read isEqualToString:@"0"]) {
            QWGLOBALMANAGER.AppraiseRedShow = YES;
//            [QWGLOBALMANAGER.tabBar showBadgePointWithItemTag:2];
            break;
        }
    }
    [QWGLOBALMANAGER postNotif:NotifNewOrderCount data:[NSString stringWithFormat:@"0"] object:nil];
    //检测机构的完善性
    if(OrganAuthPass && AUTHORITY_ROOT) {
        [Store StoreInfoCheckWithParams:@{@"token":QWGLOBALMANAGER.configure.userToken} success:^(id obj) {
//            if ([obj[@"apiStatus"] integerValue] == 0) {//已完善
//                QWGLOBALMANAGER.JGInfoCheckRedShow = NO;
//                [QWGLOBALMANAGER.tabBar showBadgePointWithItemTag:2];
// 
//            }else{//未完善
//                QWGLOBALMANAGER.JGInfoCheckRedShow = YES;
//                [QWGLOBALMANAGER.tabBar showBadgePointWithItemTag:2];
//               
//            }
        } failure:^(HttpException *e) {
//            [QWGLOBALMANAGER.tabBar showBadgePointWithItemTag:2];
        }];
    }
    NSArray *sendingMsgs = [QWMessage getArrayFromDBWithWhere:@"issend = 1"];
    [sendingMsgs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        QWMessage *msg = (QWMessage *)obj;
        msg.issend = @"3";
        [QWMessage updateObjToDB:msg WithKey:msg.UUID];
    }];
    if(AUTHORITY_ROOT) {
        [self getAllConsult];
    }
    QWGLOBALMANAGER.isKickOff = NO;
    [self createPrivateDir];
    //登陆成功后拉取消息
    if(AUTHORITY_ROOT) {
        [self createMessageTimer2];
        [self getAllOfficialMessage];
    }
    [self createMessageTimer];
    if (!IS_EXPERT_ENTRANCE) {
        [self createMessageTimerTaskScore];
    }
    
    [self createTimerForCheckToken];
    [self checkLogEnable];
//    [self createScoreTaskView];
}

- (void)getAllOfficialMessage
{
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"endpoint"] = @"2";
    setting[@"token"] = QWGLOBALMANAGER.configure.userToken;
    setting[@"viewType"] = @"-1";
    setting[@"view"] = @"15";
    setting[@"point"] = [NSString stringWithFormat:@"%0.f",[[NSDate date] timeIntervalSince1970] * 1000];
    setting[@"to"] = @"";
    setting[@"cl"] = @"3";
    [IMApi selectIMQwWithParams:setting
                        success:^(id obj){
                            if (obj) {
                                NSArray *array = obj[@"records"];
                                if([array isKindOfClass:[NSString class]])
                                {
                                    return;
                                }
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
                                    MessageDeliveryType direction;
                                    if(fromTag==2)
                                    {
                                        direction = MessageTypeSending;
                                    }else{
                                        direction = MessageTypeReceiving;
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
                                    msg.issend = @"2";
                                    msg.fromTag = fromTag ;
                                    msg.title = fromName;
                                    msg.relatedid = fromId;///此处是不是有问题
                                    msg.subTitle = tag.title;
                                    [OfficialMessages saveObjToDB:msg];
                                }
                            }
                        }
                        failure:^(HttpException *e){
                        }];
}

/**
 *  获取所有未处理订单的数量，用于轮询
 */
- (void)getAllNewOrderCount
{
    if(!self.loginStatus) {
        return;
    }
    OrderNewCountModelR *modelR = [OrderNewCountModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    [Order getAllNewOrderCount:modelR success:^(OrderNewCountModel *responModel) {
        DDLogInfo(@"the resd is %@",responModel);
        if(responModel.count.integerValue > 0){
            [QWGLOBALMANAGER.tabBar showBadgePoint:YES itemTag:1];
        }else {
            [QWGLOBALMANAGER.tabBar showBadgePoint:NO itemTag:1];
        }
        [QWGLOBALMANAGER postNotif:NotifNewOrderCount data:[NSString stringWithFormat:@"%@",responModel.count] object:nil];
    } failure:^(HttpException *e) {
        
    }];
}

- (void)getAllOrderNotiListCount
{
    OrderNotiListModelR *modelR = [OrderNotiListModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.view = @"100";
    [Order getAllOrderNotiList:modelR success:^(OrderMessageArrayVo *responModel) {
        OrderMessageArrayVo *listModel = (OrderMessageArrayVo *)responModel;
        if (listModel.messages.count > 0) {
            [self syncOrderDBtoLast:listModel];
        } else {
            QWGLOBALMANAGER.unreadOrderNum = @"0";
             [QWGLOBALMANAGER postNotif:NotifiIndexRedDotOrNumber data:nil object:self];
        }
    } failure:^(HttpException *e) {
    }];
}

- (BOOL)calculateUnreadNum
{
    if (!AUTHORITY_ROOT) {
        return NO;
    }
    NSArray *array =  [OfficialMessages getArrayFromDBWithWhere:nil WithorderBy:@"timestamp asc"];
    if (array && array.count>0) {
        OfficialMessages *message = [array lastObject];
        if (![message.issend isEqualToString:@"2"]) {
            return YES;
        }
    }
    if (QWGLOBALMANAGER.unreadOrderNum.intValue > 0) {  // 订单通知小红点
        return YES;
    } else {
        return NO;
    }
}

- (NSInteger)calculateMsgBoxUnreadFromDB
{
    __block NSInteger unreadCount = 0;
    [[MessageVo getUsingLKDBHelper] executeForTransaction:^BOOL(LKDBHelper *helper) {
        NSInteger notiUnreadCount = [helper rowCount:[MsgBoxNotiMessageVo class] where:@"read = 0"];
        NSInteger orderUnreadCount = [helper rowCount:[MsgBoxOrderMessageVo class] where:@"read = 0"];
        NSInteger creditUnreadCount = [helper rowCount:[MsgBoxCreditMessageVo class] where:@"read = 0"];
        unreadCount = notiUnreadCount + orderUnreadCount + creditUnreadCount;
        return YES;
    }];
    return unreadCount;
}



#pragma mark - 对数组进行操作
- (NSUInteger)valueExists:(NSString *)key withValue:(NSString *)value withArr:(NSMutableArray *)arrOri
{
    NSPredicate *predExists = [NSPredicate predicateWithFormat:
                               @"%K MATCHES[c] %@", key, value];
    NSUInteger index = [arrOri indexOfObjectPassingTest:
                        ^(id obj, NSUInteger idx, BOOL *stop) {
                            return [predExists evaluateWithObject:obj];
                        }];
    return index;
}

- (NSMutableArray *)sortArrWithKey:(NSString *)strKey isAscend:(BOOL)isAscend oriArray:(NSMutableArray *)oriArr
{
    NSMutableArray *arrSorted = [@[] mutableCopy];
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:strKey ascending:isAscend];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
    arrSorted = [[oriArr sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    return arrSorted;
}


- (void)syncOrderDBtoLast:(OrderMessageArrayVo *)listModel
{
    __weak typeof (self) weakSelf = self;
    NSMutableArray *arrLoaded = [NSMutableArray arrayWithArray:listModel.messages];
    NSMutableArray *arrCached = [NSMutableArray arrayWithArray:[OrderNotiModel getArrayFromDBWithWhere:nil]];
    NSMutableArray *arrNeedAdded = [@[] mutableCopy];
    NSMutableArray *arrNeedDeleted = [@[] mutableCopy];
    // 删除服务器上没有，本地有的缓存数据
    [arrCached enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        OrderNotiModel *modelHis = (OrderNotiModel *)obj;
        BOOL isExist = NO;
        for (OrderMessageVo *modelConsult in arrLoaded) {
            if ([modelConsult.messageId intValue] == [modelHis.messageId intValue]) {
                isExist = YES;
                break;
            }
        }
        if (!isExist) {
            [arrNeedDeleted addObject:modelHis];
        }
    }];
    for (OrderNotiModel *modelHis in arrNeedDeleted) {
        [OrderNotiModel deleteObjFromDBWithKey:[NSString stringWithFormat:@"%@",modelHis.messageId]];
    }
    // 更新数据问题
    arrCached = [NSMutableArray arrayWithArray:[OrderNotiModel getArrayFromDBWithWhere:nil WithorderBy:@" createTime desc"]];
    __block NSInteger count = 0;
    [arrLoaded enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        OrderMessageVo *modelOrder = (OrderMessageVo *)obj;
        NSUInteger indexFound = [weakSelf valueExists:@"messageId" withValue:[NSString stringWithFormat:@"%@",modelOrder.messageId] withArr:arrCached];
        if (indexFound != NSNotFound) {
            // 更新Model
            OrderNotiModel *modelL = [arrCached objectAtIndex:indexFound];
            [QWGLOBALMANAGER convertOrderModel:modelOrder withModelOrderLocal:&modelL];
        } else {
            OrderNotiModel *modelL = [QWGLOBALMANAGER createOrderNotiModel:modelOrder];
            [arrNeedAdded addObject:modelL];
        }
    }];
    [arrCached addObjectsFromArray:arrNeedAdded];
    for (int i = 0; i < arrCached.count; i++) {
        OrderNotiModel *model = (OrderNotiModel *)arrCached[i];
        if ([model.unreadCounts intValue]>0) {
            model.showRedPoint = @"1";
            count++;
        }
        [OrderNotiModel updateObjToDB:model WithKey:model.messageId];
    }
    if (count > 0) {
        QWGLOBALMANAGER.unreadOrderNum = [NSString stringWithFormat:@"%d",count];
    } else {
        QWGLOBALMANAGER.unreadOrderNum = @"0";
    }
    [QWGLOBALMANAGER postNotif:NotifiIndexRedDotOrNumber data:nil object:self];
}

- (void)getNewOrderListNoti
{
    if (!self.loginStatus) {
        return;
    }
    OrderNewNotiListModelR *modelR = [OrderNewNotiListModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.lastTimestamp = self.lastTimestampForOrderNoti;
    [Order getNewOrderNotiList:modelR success:^(OrderMessageArrayVo *responModel) {
        OrderMessageArrayVo *listModel = (OrderMessageArrayVo *)responModel;
        self.lastTimestampForOrderNoti = responModel.lastTimestamp;
        if (listModel.messages.count > 0) {
            for (OrderMessageVo *vo in listModel.messages) {
                OrderNotiModel *modelL = [self createOrderNotiModel:vo];
                [OrderNotiModel updateObjToDB:modelL WithKey:modelL.messageId];
            }
            
            QWGLOBALMANAGER.unreadOrderNum = [NSString stringWithFormat:@"%d",([QWGLOBALMANAGER.unreadOrderNum intValue]+listModel.messages.count)];
            [QWGLOBALMANAGER postNotif:NotifiIndexRedDotOrNumber data:nil object:self];
        } else {
            
        }
    } failure:^(HttpException *e) {
        
    }];
}

- (void)getNewMsgBoxNoticeList
{
    if (!self.loginStatus || !OrganAuthPass) {
        return;
    }
    MessageListPollModelR *modelR = [MessageListPollModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.lastTimestamp = self.lastTimestampForMsgBoxQuery ? self.lastTimestampForMsgBoxQuery : @"0";
    [MsgBox pollAllNoticeList:modelR success:^(MessageArrayVo *responseModel) {
        self.lastTimestampForMsgBoxQuery = responseModel.lastTimestamp;
        if (responseModel.messages.count > 0) {
            NSMutableArray *arrNoti = [NSMutableArray array];
            NSMutableArray *arrOrder = [NSMutableArray array];
            NSMutableArray *arrCredit = [NSMutableArray array];
            for (MessageVo *vo in responseModel.messages) {
                MsgBoxCellActionType type = vo.objType.integerValue;
                if (MsgBoxCellActionTypeOrder == type) {
                    [arrOrder addObject:[MsgBoxOrderMessageVo modelCopyFromModel:vo]];
                } else if (MsgBoxCellActionTypeCreditMsg == type) {
                    [arrCredit addObject:[MsgBoxCreditMessageVo modelCopyFromModel:vo]];
                } else {
                    [arrNoti addObject:[MsgBoxNotiMessageVo modelCopyFromModel:vo]];
                }
            }
            [MsgBoxOrderMessageVo batchUpdateToDBWithArray: [arrOrder copy] primaryKey:[MsgBoxOrderMessageVo getPrimaryKey] completion:nil];
            [MsgBoxCreditMessageVo batchUpdateToDBWithArray: [arrCredit copy] primaryKey:[MsgBoxCreditMessageVo getPrimaryKey] completion:nil];
            [MsgBoxNotiMessageVo batchUpdateToDBWithArray: [arrNoti copy] primaryKey:[MsgBoxNotiMessageVo getPrimaryKey] completion:nil];

            [QWGLOBALMANAGER postNotif:NotiMsgBoxNeedUpdate data:nil object:self];
        }
        [self checkMsgBoxNotice];
    } failure:^(HttpException *e) {
        DebugLog(@"[%@ %s] pollAllMsgBox request failed", NSStringFromClass(self.class), __func__);
    }];
}


//专家登录成功
- (void)expertLoginSuccess
{
    [self createPrivateDir];
    [ExpertMessageCenter getAllPivateMessageExpertList];
    [self createCircleMessageTimer];
    [self getAllExpertConsult];
    QWGLOBALMANAGER.isKickOff = NO;
}

#pragma mark ---- 检测药房状态 是否开通微商 ----
- (void)checkStoreStatu
{
//    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
//    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
//    [Circle InitByBranchWithParams:setting success:^(id obj) {
//        CheckStoreStatuModel *model = [CheckStoreStatuModel parse:obj];
//        if ([model.apiStatus integerValue] == 0) {
//            if (model.type) {
//                QWGLOBALMANAGER.configure.storeType = model.type;
//                [QWGLOBALMANAGER saveAppConfigure];
//            }
//        }
//    } failure:^(HttpException *e) {
//
//    }];
}


//登录成功后创建私有目录
- (void)createPrivateDir
{
    NSString *privateName;
    if(IS_EXPERT_ENTRANCE){
        privateName = self.configure.expertMobile;
    }else{
        privateName = self.configure.userName;
    }
    
    if(StrIsEmpty(privateName)){
        [SVProgressHUD showErrorWithStatus:@"私有目录无法创建，可能导致语音文件无法生成"];
    }
    
    NSString *homePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat: @"Documents/%@",privateName]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:homePath]){
        [fileManager createDirectoryAtPath:homePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    homePath = [homePath stringByAppendingString:@"/Voice"];
    if(![fileManager fileExistsAtPath:homePath]){
        [fileManager createDirectoryAtPath:homePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

#pragma mark - Home
- (HomePageViewController *)homePage{

    return self.vcConsult;
}
#pragma mark - 更新服务器未读数
- (void)updateUnreadCount
{
    if (QWGLOBALMANAGER.loginStatus == NO) {
        return;
    }
    
    [self checkMyConsult];
    [self checkOtherConsult];
    
    RedPointModel *mm=[self getRedPointModel];
    [Consult updateNotiNumberWithNum:mm.numMyConsult+mm.numOtherConsult token:self.configure.userToken success:^(id obj) {
        DebugLog(@"==========%d = %@",mm.numMyConsult+mm.numOtherConsult,obj);
    } failure:^(HttpException *e) {
    
    }];
//    NSArray *arr1 = [ConsultConsultingModel getArrayFromDBWithWhere:nil];
//    NSArray *arr2 = [PharSessionVo getArrayFromDBWithWhere:nil];
//    if (arr1.count <= 0 && arr2.count <= 0) {
//        return;
//    }
//    NSMutableArray *arrItems = [@[] mutableCopy];
//    for (ConsultConsultingModel *msgModel in arr1) {
//        
//        if([msgModel.unreadCounts integerValue]>0)
//        {
//            [arrItems addObject:[NSString stringWithFormat:@"%@",msgModel.consultId]];
//        }
//        
//    }
//    NSString *strItems = [arrItems componentsJoinedByString:SeparateStr];
//    
//    ConsultSetUnreadNumModelR *modelR = [ConsultSetUnreadNumModelR new];
//    modelR.token = QWGLOBALMANAGER.configure.userToken;
//    modelR.consultIds = strItems;
//    
//    [Consult updateNotiNumberWithParam:modelR success:^(id ResModel) {
//        ConsultModel *modelResponse = (ConsultModel *)ResModel;
//        if (modelResponse.apiStatus == 0) {
//            NSLog(@"update success");
//        }
//    } failure:^(HttpException *e) {
//        
//    }];
}

// 订单通知
- (OrderNotiModel *)createOrderNotiModel:(OrderMessageVo *)modelLoad
{
    OrderNotiModel *modelOrder = [OrderNotiModel new];
    modelOrder.orderId = [NSString stringWithFormat:@"%@",modelLoad.orderId];
    modelOrder.title = [NSString stringWithFormat:@"%@",modelLoad.title];
    modelOrder.createTime = [NSString stringWithFormat:@"%@",modelLoad.createTime];
    modelOrder.showTime = [NSString stringWithFormat:@"%@",modelLoad.showTime];
    modelOrder.unreadCounts = [NSString stringWithFormat:@"%@",modelLoad.unreadCounts];
    modelOrder.showRedPoint = @"0";
    modelOrder.messageId = [NSString stringWithFormat:@"%@",modelLoad.messageId];
    modelOrder.content = [NSString stringWithFormat:@"%@",modelLoad.content];
    modelOrder.objId = [NSString stringWithFormat:@"%@",modelLoad.objId];
    modelOrder.objType = [NSString stringWithFormat:@"%@",modelLoad.objType];
    return modelOrder;
}

- (void)convertOrderModel:(OrderMessageVo *)modelOrder withModelOrderLocal:(OrderNotiModel **)modelLocal
{
    (*modelLocal).orderId = modelOrder.orderId;
    (*modelLocal).title = modelOrder.title;
    (*modelLocal).createTime = modelOrder.createTime;
    (*modelLocal).showTime = modelOrder.showTime;
    (*modelLocal).unreadCounts = modelOrder.unreadCounts;
    (*modelLocal).messageId = [NSString stringWithFormat:@"%@",modelOrder.messageId];
    (*modelLocal).content = [NSString stringWithFormat:@"%@",modelOrder.content];
    (*modelLocal).objId = [NSString stringWithFormat:@"%@",modelOrder.objId];
    (*modelLocal).objType = [NSString stringWithFormat:@"%@",modelOrder.objType];
}

#pragma mark - tab bar菜单一红点＋数字
- (void)notifRedPoint:(int)rp{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"conslut"]=StrFromInt(rp);
    dd[@"hadMessage"]=[NSString stringWithFormat:@"%i", self.hadMessage];
    dd[@"hadNotice"]=[NSString stringWithFormat:@"%i", self.hadNotice];
    [QWGLOBALMANAGER postNotif:NotifiIndexRedDotOrNumber data:dd object:self];
}

- (void)refreshAllHint{
    int rp=-1;
    
    RedPointModel *mm=[self getRedPointModel];
    mm=[self checkRedPointModel:mm];
    
    self.unReadCount=mm.numMyConsult+mm.numOtherConsult;
    _hadMessage=mm.hadMessage;
    _hadNotice=mm.hadNotice;
    _hadWaiting=mm.hadWaiting;
    _hadOtherConsult=mm.hadOtherConsult;
    _hadMyConsult=mm.hadMyConsult;
    NSInteger num = 0;
    if (self.unReadCount>0) {
        //tab显示数字
        [QWGLOBALMANAGER.tabBar showBadgePoint:YES itemTag:0];
//        [QWGLOBALMANAGER.tabBar showBadgePoint:NO itemTag:0];
//        [QWGLOBALMANAGER.tabBar showBadgeNum:self.unReadCount itemTag:0];
      
        num=self.unReadCount;
        if(num > 99) {
            num = 99;
        }
        
        rp=num;
        //yyx
    }

    else if (self.hadWaiting || self.hadOtherConsult || self.hadMyConsult){
//        else if (self.hadMessage || self.hadWaiting || self.hadOtherConsult || self.hadMyConsult){
        //tab显示红点
        [QWGLOBALMANAGER.tabBar showBadgeNum:0 itemTag:0];
        [QWGLOBALMANAGER.tabBar showBadgePoint:YES itemTag:0];
        
        //yyx
        
        num=1;
      
        rp=0;
    }
    else if (self.hadMessage || self.hadNotice){
        //tab显示红点
        [QWGLOBALMANAGER.tabBar showBadgeNum:0 itemTag:0];
        [QWGLOBALMANAGER.tabBar showBadgePoint:YES itemTag:0];
        num=1;
    } else {
        //啥都没
        [QWGLOBALMANAGER.tabBar showBadgeNum:0 itemTag:0];
        [QWGLOBALMANAGER.tabBar showBadgePoint:NO itemTag:0];
        
        //yyx
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = num;
    
    HomePageViewController *vc = [self homePage];
//    [vc checkAllHint];
    
    [self notifRedPoint:rp];
}

- (RedPointModel*)checkRedPointModel:(RedPointModel*)mode{
    
    HomePageViewController *vc = [self homePage];
  
//    if (vc.segmentedControl.enabled) {
//        switch (vc.segmentedControl.selectedSegmentIndex) {
//            case 0:
//                mode.hadMyConsult=NO;
//                break;
//            case 1:
//                mode.hadWaiting=NO;
//                break;
//            case 2:
//                mode.hadOtherConsult=NO;
//                break;
//            default:
//                break;
//        }
//    }
    
    mode.hadMyConsult=NO;
    
//    if (![vc checkMaskHidden]) {
//        mode.hadMessage=NO;
//    }
    
    [RedPointModel deleteObjFromDBWithKey:self.configure.passportId];
    [RedPointModel saveObjToDB:mode];
    
    return mode;
}

- (void)setHadMessage:(BOOL)hadMessage{
//    _hadMessage=hadMessage;
    RedPointModel *mm=[self getRedPointModel];
    mm.hadMessage=hadMessage;
    
    [self checkBadge:mm];
}
#pragma mark - 红点角标管理
- (void)checkBadge:(RedPointModel*)mode{
    mode=[self checkRedPointModel:mode];
    [self refreshAllHint]; 
}

- (RedPointModel*)getRedPointModel{
    RedPointModel *mm=[RedPointModel getObjFromDBWithKey:self.configure.passportId];
    if (mm) {
        return mm;
    }
    else {
        RedPointModel *mm = [RedPointModel new];
        mm.UUID = self.configure.passportId;
        return mm;
    }
}

- (void)checkWaiting:(NSInteger)num{
    RedPointModel *mm=[self getRedPointModel];

    if (num==0) {
        mm.hadWaiting=NO;
    }
    else if (mm.numWaiting!=num) {
        mm.hadWaiting=YES;
    }
    mm.numWaiting=num;
    
    
    [self checkBadge:mm];
}

- (void)checkMessage{
    RedPointModel *mm=[self getRedPointModel];
    
    if (AUTHORITY_ROOT) {
        NSInteger num=0;
        //全维药师消息盒子未读
        num = [OfficialMessages getcountFromDBWithWhere:@"issend = '0'"];
        if (num==0) {
            mm.hadMessage=NO;
        }
        else if (num>mm.numMessage)
            mm.hadMessage=YES;
        if(num > 99) {
            num = 99;
        }
        mm.numMessage=num;
    }
    
    [self checkBadge:mm];
}

- (void)checkMsgBoxNotice
{
    RedPointModel *mm=[self getRedPointModel];
    
    if (OrganAuthPass) {
        NSInteger num = [self calculateMsgBoxUnreadFromDB];
        mm.hadNotice = (num != 0);
        num = num > 99 ? 99 : num;
        mm.numNotice=num;
    } else {
        mm.hadNotice = NO;
        mm.numNotice = 0;
    }
    [self checkBadge:mm];
}

- (void)checkMyConsult{
    RedPointModel *mm=[self getRedPointModel];
    
    if (AUTHORITY_ROOT) {
        
        NSInteger num=0;
        
        //列表有数据
        NSArray* listModel = [PharSessionVo getArrayFromDBWithWhere:nil];
        for (int i=0; i<listModel.count; i++) {
            PharSessionVo* model = [listModel objectAtIndex:i];
            if ([model.unreadCounts integerValue] > 0) {
                num+=model.unreadCounts.integerValue;
            }
        }
        if (num==0) {
            mm.hadMyConsult = NO;
        }
        else if (num>mm.numMyConsult) {
            mm.hadMyConsult = YES;
        }
        mm.numMyConsult=num;
    }
    
    [self checkBadge:mm];
}

- (void)checkOtherConsult{
    RedPointModel *mm=[self getRedPointModel];
    
    if (AUTHORITY_ROOT) {

        NSInteger num=0;
        
        //解答中列表有数据
        NSArray* listModel = [ConsultConsultingModel getArrayFromDBWithWhere:nil];
        for (int i=0; i<listModel.count; i++) {
            ConsultConsultingModel* model = [listModel objectAtIndex:i];
            if ([model.unreadCounts integerValue] > 0) {
                num+=model.unreadCounts.integerValue;
            }
        }
        if (num==0) {
            mm.hadOtherConsult = NO;
        }
        else if (num>mm.numOtherConsult) {
            mm.hadOtherConsult = YES;
        }
        mm.numOtherConsult=num;
    }
    
    [self checkBadge:mm];
}

#pragma mark - 强化积分

// API接口控制是否弹出，多设备同步 // 多用户切换
// 检查其他APP启动弹窗，冲突 // 优先级 : 升级Alert优先。先弹升级则不弹积分。后弹升级则自动关闭积分。
// TODO: 版本升级是否重置UserDefault的标志位
- (void)showAlertIfNeededAndDelayed:(BOOL)delayed
{
    if (self.isShowAlert) return;

    CreditEnhanceInfoModel *model = [CreditEnhanceInfoModel getFromNsuserDefault:QWDEFAULT_CURRENT_USER_ENHANCE_INFO];
    if (!model) return;
    if ([model.lastUpdateDate isToday]) {
        
        NSMutableDictionary *alertInfo = [[[NSUserDefaults standardUserDefaults] objectForKey:QWDEFAULT_CURRENT_USER_SETTINGS] mutableCopy];
        if (!alertInfo) alertInfo = [NSMutableDictionary dictionary];
        BOOL shouldAlertOnce = [alertInfo[QWDEFAULT_CREDIT_ONCE_ALERT_AVAILABLE] boolValue];
        NSTimeInterval onceAlertTimeStamp = [alertInfo[QWDEFAULT_CREDIT_ONCE_ALERT_LASTTIMESTAMP] doubleValue];
        
        // 首次登录
        if (!onceAlertTimeStamp) {
            if (model.firstLoginEver.intValue) {
                alertInfo[QWDEFAULT_CREDIT_ONCE_ALERT_AVAILABLE] = @(YES);
                [QWUserDefault setDict:alertInfo key:QWDEFAULT_CURRENT_USER_SETTINGS];
                [self askCreditAlertWithType:CreditEnhanceAlertViewTypeOnce infoModel:model delayed:delayed];
            } else {
                if (shouldAlertOnce) [self askCreditAlertWithType:CreditEnhanceAlertViewTypeOnce infoModel:model delayed:delayed];
            }
        }
        // refresh UserDefault
        NSMutableDictionary *alertInfoNew = [[[NSUserDefaults standardUserDefaults] objectForKey:QWDEFAULT_CURRENT_USER_SETTINGS] mutableCopy];
        if (!alertInfoNew) alertInfoNew = [NSMutableDictionary dictionary];
        NSTimeInterval onceAlertTimeStampNew = [alertInfoNew[QWDEFAULT_CREDIT_ONCE_ALERT_LASTTIMESTAMP] doubleValue];
        NSDate *onceAlertTimeNew = [NSDate dateWithTimeIntervalSince1970:onceAlertTimeStampNew];
        BOOL shouldAlertDaily = [alertInfoNew[QWDEFAULT_CREDIT_DAILY_ALERT_AVALIABLE] boolValue];
        NSTimeInterval dailyAlertTimeStamp = [alertInfoNew[QWDEFAULT_CREDIT_DAILY_ALERT_LASTTIMESTAMP] doubleValue];
        NSDate *dailyAlertTime = [NSDate dateWithTimeIntervalSince1970:dailyAlertTimeStamp];

        // 日常登录
        if(![dailyAlertTime isToday] && ![onceAlertTimeNew isToday] && !model.firstLoginEver.intValue) {
            CreditEnhanceAlertViewType type;
            if (model.yesterdayScore.integerValue > 20) {
                type = CreditEnhanceAlertViewTypeDailyHappy;
            }else {
                type = CreditEnhanceAlertViewTypeDailySad;
            }
            if (model.firstLoginToday.intValue) {
                alertInfoNew[QWDEFAULT_CREDIT_DAILY_ALERT_AVALIABLE] = @(YES);
                [QWUserDefault setDict:alertInfoNew key:QWDEFAULT_CURRENT_USER_SETTINGS];
                [self askCreditAlertWithType:type infoModel:model delayed:delayed];
            } else {
                if (shouldAlertDaily) [self askCreditAlertWithType:type infoModel:model delayed:delayed];
            }
        }
    }
}

- (void)autoDismissCustomAlert
{
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        if([view isKindOfClass:[CreditEnhanceAlertView class]]) {
            [(CreditEnhanceAlertView *)view dismiss];
        }
    }
}

- (void)askCreditAlertWithType:(CreditEnhanceAlertViewType)type infoModel:(CreditEnhanceInfoModel *)model delayed:(BOOL)delayed
{
    if (!OrganAuthPass || !self.loginStatus) {
        return;
    }
    if (!_qwTabBarShown) {
        return;
    }
    if (self.isShowCustomAlert) {
        return;
    }
//    BOOL hadTabBar = [UIApplication sharedApplication]
    if (![UIAlertViewHelper helper].hasVisibleAlert) {
        [self creditAlertWithType:type infoModel:model delayed:delayed];
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlertIfNeededAndDelayed:) name:(NSString *)kNotiUIAlertViewAllDismissed object:nil];
    }
}

- (void)creditAlertWithType:(CreditEnhanceAlertViewType)type infoModel:(CreditEnhanceInfoModel *)model delayed:(BOOL)delayed
{
    if (delayed) return;
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) return;
    CreditEnhanceAlertView *alert = [CreditEnhanceAlertView alertViewWithInfo:@{
                                                                                kCreditEnhanceInfoAlertType : @(type),
                                                                                kCreditEnhanceInfoName : self.configure.showName,
                                                                                kCreditEnhanceInfoCredits : model.currScore.stringValue,
                                                                                kCreditEnhanceInfoCreditInc : model.yesterdayScore.stringValue,
                                                                                kCreditEnhanceInfoRankNum : model.rank.stringValue
                                                                                }];
    __weak typeof(alert) weakAlert = alert;
    alert.dismissBlock = ^{
        self.isShowCustomAlert = NO;
    };
    if (type == CreditEnhanceAlertViewTypeOnce){
        alert.actionBtnClickBlock =  ^{
            [weakAlert performSelector:@selector(dismiss) withObject:nil];
            StoreCreditViewController* storeCreditVC = [[UIStoryboard storyboardWithName:@"StoreCreditViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"StoreCreditViewController"];
            storeCreditVC.hidesBottomBarWhenPushed = YES;
            QWTabBar *vc = (QWTabBar *)[UIApplication sharedApplication].keyWindow.rootViewController;
            if ([vc isKindOfClass:[QWTabBar class]]) {
                UINavigationController *nav = vc.selectedViewController;
                if (!vc.presentingViewController && ![nav.topViewController isKindOfClass:[StoreCreditViewController class]]) {
                    [nav pushViewController:storeCreditVC animated:YES];
                }
            }
        };
        alert.fillStoreInfoBlock = ^{
            [weakAlert performSelector:@selector(dismiss) withObject:nil];
            StoreDetailViewController *storeVc = [[UIStoryboard storyboardWithName:@"StoreDetail" bundle:nil] instantiateViewControllerWithIdentifier:@"StoreDetailViewController"];
            storeVc.hidesBottomBarWhenPushed = YES;
            QWTabBar *vc = (QWTabBar *)[UIApplication sharedApplication].keyWindow.rootViewController;
            if ([vc isKindOfClass:[QWTabBar class]]) {
                UINavigationController *nav = vc.selectedViewController;
                if (!vc.presentingViewController && ![nav.topViewController isKindOfClass:[StoreCreditViewController class]]) {
                    [nav pushViewController:storeVc animated:YES];
                }
            }

        };
    }
    if (type != CreditEnhanceAlertViewTypeOnce) {
        alert.actionBtnClickBlock =  ^{
            [weakAlert performSelector:@selector(dismiss) withObject:nil];
        };
    }
    
    [alert show];
    self.isShowCustomAlert = YES;
    NSMutableDictionary *alertInfo = [[[NSUserDefaults standardUserDefaults] objectForKey:QWDEFAULT_CURRENT_USER_SETTINGS] mutableCopy];
    if (type == CreditEnhanceAlertViewTypeOnce) {
        alertInfo[QWDEFAULT_CREDIT_ONCE_ALERT_AVAILABLE] = @(NO);
        alertInfo[QWDEFAULT_CREDIT_ONCE_ALERT_LASTTIMESTAMP] = @([[NSDate date] timeIntervalSince1970]);
    } else {
        alertInfo[QWDEFAULT_CREDIT_DAILY_ALERT_AVALIABLE] = @(NO);
        alertInfo[QWDEFAULT_CREDIT_DAILY_ALERT_LASTTIMESTAMP] = @([[NSDate date] timeIntervalSince1970]);
    }
    [QWUserDefault setDict:alertInfo key:QWDEFAULT_CURRENT_USER_SETTINGS];
}

#pragma mark - 全量拉所有Consult数据
- (void)getAllConsult{
    DebugLog(@"－－－AAA 全局拉");
    
    if (AUTHORITY_ROOT) {
        [self getWaitingConsultList];
        [self getClosedConsultList:@"0"];
        [self getConsultingConsultList];
        [self getAllMyConsultingConsultList];
    }
    
//    [self pollMyConsultingConsultList];
}

//#pragma mark 增量拉所有Consult数据
//- (void)getPollingConsult{
//    
//}

#pragma mark - 药店P2P
- (void)getAllMyConsultingConsultList{
//    return;
    
    if(!self.loginStatus)
        return;
    
    GetAllByPharModelR *mode=[GetAllByPharModelR new];
    mode.token=self.configure.userToken;
    mode.point=@"0";
    mode.viewType=@"-1";//－1:point点之前的数据; 1:point点之后的数据
    mode.view=@"999";

    DebugLog(@"－－－－－－－－－ 药店P2P");
    [ConsultPTP ptpPharGetAllWithParams:mode success:^(id obj) {
        DebugLog(@"＋＋＋＋＋＋＋＋＋success");
        PharSessionList *mode = [PharSessionList parse:obj Elements:[PharSessionVo class] forAttribute:@"sessions"];
        if (mode.lastTimestamp && mode.lastTimestamp.length)
            lastTimeStampMyConsulting=StrFromObj(mode.lastTimestamp);
//        else lastTimeStampMyConsulting=@"0";
        
        NSArray *list=mode.sessions;
//        DebugLog(@"QQQQQQQQQQQQQQ 准备删除");
        //删db数据
        [PharSessionVo deleteAllObjFromDB];
//        DebugLog(@"WWWWWWWWWWWWWW 准备插入");
        if (list.count > 0) {
//            [PharSessionVo saveObjToDBWithArray:list];
            [PharSessionVo insertToDBWithArray:list filter:^(id model, BOOL inserted, BOOL *rollback) {
                //
            }];
        }
        DebugLog(@"EEEEEEEEEEEEEE 插入完成");
        [self checkMyConsult];
        [self postNotif:NotiRefreshMyConsultingConsult data:list object:nil];
    } failure:^(HttpException *e) {

    }];
}

- (void)pollMyConsultingConsultList{
    if(!self.loginStatus || !AUTHORITY_ROOT)
        return;
    
    [ConsultPTP ptpPharPollWithLastTimestamp:lastTimeStampMyConsulting token:self.configure.userToken success:^(id obj) {
        BOOL canPlay=YES;
        HomePageViewController *vc = [self homePage];
       
        
        PharSessionList *mode = [PharSessionList parse:obj Elements:[PharSessionVo class] forAttribute:@"sessions"];
        if (mode.lastTimestamp && mode.lastTimestamp.length)
            lastTimeStampMyConsulting=StrFromObj(mode.lastTimestamp);
        
        NSArray *list=mode.sessions;
        int count = 0;
        for (int i=0; i<list.count; i++) {
            PharSessionVo* mm = [list objectAtIndex:i];
            if ([mm.unreadCounts integerValue] > 0) {
                
                
                
                NSString *where=[NSString stringWithFormat:@"sessionId = %@",mm.sessionId];
//                NSString *key=StrFromObj(mm.sessionId);
                
                PharSessionVo* tmp = [PharSessionVo getObjFromDBWithWhere:where];
                mm.unreadCounts = [NSString stringWithFormat:@"%d",[mm.unreadCounts integerValue]+[tmp.unreadCounts integerValue]];
                
                //判断是不是在当前唯一房间在刷
                if (list.count==1) {
                    if (vc.roomID && [vc.roomID isEqualToString:StrFromObj(mm.sessionId)]) {
                        canPlay=NO;
                    }
                }
                
                //当前房间未读数＝0
                if (vc.roomID && [vc.roomID isEqualToString:StrFromObj(mm.sessionId)]) {
                    mm.unreadCounts = @"0";
                }
                if(tmp)
                    [PharSessionVo updateToDB:mm where:where];
                else [PharSessionVo saveObjToDB:mm];
//                [PharSessionVo updateObjToDB:mm WithKey:key];
                
                count+=mm.unreadCounts.integerValue;
            }
        }
        
        //判断是不是在当前唯一房间在刷
//        if (list.count==1) {
//            PharSessionVo* mm = [list firstObject];
//            if (vc.roomID && [vc.roomID isEqualToString:StrFromObj(mm.sessionId)]) {
//                canPlay=NO;
//            }
//        }
        
        RedPointModel *mm=[self getRedPointModel];
        if (count>mm.numMyConsult && canPlay) {
            [XHAudioPlayerHelper playMessageReceivedSound];
            
            
            
        }
        NSArray *arrNew = [PharSessionVo getArrayFromDBWithWhere:nil];

        [self checkMyConsult];
        [self postNotif:NotiRefreshMyConsultingConsult data:arrNew object:nil];
        
    } failure:^(HttpException *e) {
//        DebugLog(@"p2p poll err");
    }];
}

- (void)deleteAPTP:(PharSessionVo*)ptpModel{
//    PTPRemoveByPharModelR *modelR = [PTPRemoveByPharModelR new];
//    modelR.sessionId = ptpModel.sessionId;
//    modelR.token = self.configure.userToken;
//    [ConsultPTP ptpRemoveByPharWithParams:modelR success:^(BaseAPIModel *model) {
//        if ([model.apiStatus integerValue] == 0) {
//            [self.myConsultingConsultList removeObjectAtIndex:indexPath.row];
//            [self.tableView reloadData];
//        }else{
//            [SVProgressHUD showErrorWithStatus:model.apiMessage duration:0.8];
//        }
//    } failure:^(HttpException *e) {
//        [SVProgressHUD showErrorWithStatus:kWaring33 duration:0.8f];
//    }];
}
#pragma mark - 全量获取解答列表
- (void)getConsultingConsultList
{
    if(!self.loginStatus)
        return;
    ConsultCloseModelR *colsedModelR = [ConsultCloseModelR new];
    colsedModelR.token = self.configure.userToken;
    [Consult consultConsultingWithParams:colsedModelR success:^(id obj) {
        
        NSArray *listModel = obj;
        [ConsultConsultingModel deleteAllObjFromDB];
        
        if (listModel.count >0) {
//            [ConsultConsultingModel saveObjToDBWithArray:listModel];
            [ConsultConsultingModel insertToDBWithArray:listModel filter:^(id model, BOOL inserted, BOOL *rollback) {
                //
            }];
        }
        

        [self checkOtherConsult];
        [self postNotif:NotiRefreshConsultingConsult data:obj object:nil];
        
    } failure:NULL];
}

//增量获取解答中列表
- (void)getConsultingnewDetail
{
    if(!self.loginStatus || !AUTHORITY_ROOT)
        return;
    
    //只有未关闭和未过期的问题才去拉数据
    NSArray *arrNeedUpdate = [ConsultConsultingModel getArrayFromDBWithWhere:nil];
    if (arrNeedUpdate.count <= 0) {
        return;
    }
    NSMutableArray *arrItems = [@[] mutableCopy];
    for (ConsultConsultingModel *msgModel in arrNeedUpdate) {
        [arrItems addObject:[NSString stringWithFormat:@"%@",msgModel.consultId]];
    }
    
    NSString *strItems = [arrItems componentsJoinedByString:SeparateStr];
    
    ConsultnNewDetailModelR *modelR = [ConsultnNewDetailModelR new];
    modelR.token = self.configure.userToken;
    modelR.lastTimestamp = self.lastTimestampfortimer;
    modelR.consultIds = strItems;
    [Consult consultConsultingnewDetailWithParams:modelR success:^(id responModel) {
        BOOL canPlay=YES;
        HomePageViewController *vc = [self homePage];
        
        ConsultConsultingModellist *listModel = (ConsultConsultingModellist *)responModel;
        self.lastTimestampfortimer = listModel.lastTimestamp;
        
        
        int count = 0;
        for (int i=0; i<listModel.consults.count; i++) {
            ConsultConsultingModel* mm = [listModel.consults objectAtIndex:i];
            if ([mm.unreadCounts integerValue] > 0) {
                NSString *where=[NSString stringWithFormat:@"consultId = %@",mm.consultId];
                NSString *key=StrFromObj(mm.consultId);
                
                ConsultConsultingModel* tmp = [ConsultConsultingModel getObjFromDBWithWhere:where];
                mm.unreadCounts = [NSString stringWithFormat:@"%d",[mm.unreadCounts integerValue]+[tmp.unreadCounts integerValue]];
                
                //判断是不是在当前唯一房间在刷
                if (listModel.consults.count==1) {
                    if (vc.roomID && [vc.roomID isEqualToString:StrFromObj(mm.consultId)]) {
                        canPlay=NO;
                    }
                }
                
                //当前房间未读数＝0
                if (vc.roomID && [vc.roomID isEqualToString:StrFromObj(mm.consultId)]) {
                    mm.unreadCounts = @"0";
                }
                
                [ConsultConsultingModel updateObjToDB:mm WithKey:key];
//                [ConsultConsultingModel updateSetToDB:mm WithWhere:where];
                count+=mm.unreadCounts.integerValue;
            }
        }
        
//        //判断是不是在当前唯一房间在刷
//        if (listModel.consults.count==1) {
//            ConsultConsultingModel* mm = [listModel.consults firstObject];
//            if (vc.roomID && [vc.roomID isEqualToString:StrFromObj(mm.consultId)]) {
//                canPlay=NO;
//            }
//        }
        
        RedPointModel *mm=[self getRedPointModel];
        if (count>mm.numOtherConsult && canPlay) {
            [XHAudioPlayerHelper playMessageReceivedSound];
        }
//        if(count > 0)
//
        

        
        NSArray *arrNeedUpdate = [ConsultConsultingModel getArrayFromDBWithWhere:nil];
        [self checkOtherConsult];
        [self postNotif:NotiRefreshConsultingConsult data:arrNeedUpdate object:nil];
    } failure:NULL];
}
#pragma mark - 待答
- (void)getWaitingConsultList
{
    ConsultCloseModelR *colsedModelR = [ConsultCloseModelR new];
    colsedModelR.token = self.configure.userToken;
    [Consult consultRacingWithParams:colsedModelR success:^(id obj) {
        NSArray *array = obj;
        [self checkWaiting:array.count];
        [self postNotif:NotiRefreshRacingConsult data:obj object:nil];
    } failure:NULL];
}

#pragma mark  全维药事

- (void)pullOfficialMessage
{
//    DebugLog(@"---------------------pullOfficialMessage-----------------------------");
    if(!QWGLOBALMANAGER.loginStatus || !AUTHORITY_ROOT)
        return;
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
   
    setting[@"token"] = self.configure.userToken;
    if (self.lastQWYSTime) {
        setting[@"lastTimestamp"] = self.lastQWYSTime;
    }else
    {
        
        setting[@"lastTimestamp"] = @"0";
        
    }
    
    [IMApi pollByPhar:setting success:^(id resultObj) {

        NSArray *array = resultObj[@"records"];
        
        self.lastQWYSTime  =resultObj[@"lastTimestamp"];
        if([array isKindOfClass:[NSString class]])
            return;
        
        NSUInteger filterCount = 0;
        for(NSDictionary *dict in array)
        {
            //                NSUInteger type = [dict[@"type"] integerValue];
            NSDictionary *info = dict[@"info"];
            NSString *content = info[@"content"];
            NSString *fromId = info[@"fromId"];
            NSString *toId = info[@"toId"];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *messageDate = [formatter dateFromString:info[@"time"]];
            double timeStamp = [messageDate timeIntervalSince1970];
            NSString *UUID = info[@"id"];
            NSUInteger fromTag = [info[@"fromTag"] integerValue];
            NSUInteger toTag = [info[@"toTag"] integerValue];
            //                NSArray *tags = info[@"tags"];
            NSUInteger msgType = [info[@"source"] integerValue];
            if(msgType == 0){
                msgType = 1;
            }
            NSString *fromName = info[@"fromName"];
            NSString *where = [NSString stringWithFormat:@"UUID = '%@'",UUID];
            NSArray *tagList = [TagWithMessage getArrayFromDBWithWhere:where];
            NSString *relatedId = @"";
            XHBubbleMessageType direction;

            
            if (!StrIsEmpty(fromId)) {
                if([fromId isEqualToString:self.configure.passportId]) {
                    direction = XHBubbleMessageTypeSending;
                    relatedId = toId;
                }else{
                    direction = XHBubbleMessageTypeReceiving;
                    relatedId = fromId;
                }
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
            msg.issend = @"0";
            msg.fromTag = fromTag ;
            msg.title = fromName;
            msg.relatedid = fromId;///此处是不是有问题
            msg.subTitle = tag.title;
            [OfficialMessages saveObjToDB:msg];
         
        }
        if (AUTHORITY_ROOT) {
            if(array.count > 0 && (array.count > filterCount))
            {
                [XHAudioPlayerHelper playMessageReceivedSound];
                [[NSNotificationCenter defaultCenter] postNotificationName:OFFICIAL_MESSAGE object:nil];
            }
            [self checkMessage];
            
        }
        
    } failure:NULL];
    
//    [self organAUTHCheckTokenVaild];
}

- (void)pullCircleMessage
{
    if(!QWGLOBALMANAGER.loginStatus)
        return;
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = QWGLOBALMANAGER.configure.expertToken;
    NSString *str = @"";
    if (QWGLOBALMANAGER.configure.lastTimestamp && ![QWGLOBALMANAGER.configure.lastTimestamp isEqualToString:@""]) {
        str = QWGLOBALMANAGER.configure.lastTimestamp;
    }

    setting[@"lastTimestamp"] = StrFromObj(str);
    [Circle TeamQueryUnReadMessageWithParams:setting success:^(id obj) {
        [self addCircleRedPoint];
        TeamMessagePageModel *page = [TeamMessagePageModel parse:obj Elements:[TeamMessageModel class] forAttribute:@"msglist"];
        if ([page.apiStatus integerValue] == 0) {
            QWGLOBALMANAGER.configure.lastTimestamp = page.lastTimestamp;
            [QWGLOBALMANAGER saveAppConfigure];
            if (page.msglist.count > 0) {
                for (TeamMessageModel *model in page.msglist) {
                    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
                    dd[@"messageType"] = [NSString stringWithFormat:@"%d",model.msgClass];
                    [QWGLOBALMANAGER postNotif:NotifCircleMessage data:dd object:self];
                    [QWGLOBALMANAGER.tabBar showBadgePoint:YES itemTag:Enum_TabBar_Items_ExpertMine];
                    
                    if (model.msgClass == 1) {
                        QWGLOBALMANAGER.configure.expertCommentRed = YES;
                    }else if (model.msgClass == 2){
                        QWGLOBALMANAGER.configure.expertFlowerRed = YES;
                    }else if (model.msgClass == 3){
                        QWGLOBALMANAGER.configure.expertAtMineRed = YES;
                    }else if (model.msgClass == 99){
                        QWGLOBALMANAGER.configure.expertSystemInfoRed = YES;
                    }
                    [QWGLOBALMANAGER saveAppConfigure];
                }
            }
        }
    } failure:^(HttpException *e) {
        
    }];
}

//轮训禁言 消息
- (void)pullCircleForbidMessage
{
    if(!QWGLOBALMANAGER.loginStatus)
        return;
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = QWGLOBALMANAGER.configure.expertToken;
    NSString *str = @"";
    if (QWGLOBALMANAGER.configure.lastTimestamp && ![QWGLOBALMANAGER.configure.lastTimestamp isEqualToString:@""]) {
        str = QWGLOBALMANAGER.configure.lastTimestamp;
    }
    
    setting[@"lastTimestamp"] = StrFromObj(str);
    [Circle TeamQueryUnReadMessageWithParams:setting success:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addCircleRedPoint];
        });
        TeamMessagePageModel *page = [TeamMessagePageModel parse:obj Elements:[TeamMessageModel class] forAttribute:@"msglist"];
        if ([page.apiStatus integerValue] == 0) {
            QWGLOBALMANAGER.configure.lastTimestamp = page.lastTimestamp;
            [QWGLOBALMANAGER saveAppConfigure];
            if (page.msglist.count > 0) {
                for (TeamMessageModel *model in page.msglist) {
                    
                    //18禁言 19解禁
                    if (model.msgType == 18) {
                        QWGLOBALMANAGER.configure.silencedFlag = YES;
                    }else if (model.msgType == 19){
                        QWGLOBALMANAGER.configure.silencedFlag = NO;
                    }
                    [QWGLOBALMANAGER saveAppConfigure];
                }
            }
        }
    } failure:^(HttpException *e) {
        
    }];
}


- (void)addCircleRedPoint
{
    if (QWGLOBALMANAGER.configure.expertCommentRed || QWGLOBALMANAGER.configure.expertFlowerRed || QWGLOBALMANAGER.configure.expertAtMineRed || QWGLOBALMANAGER.configure.expertSystemInfoRed) {
        [QWGLOBALMANAGER.tabBar showBadgePoint:YES itemTag:Enum_TabBar_Items_ExpertMine];
    }
}

- (void)organAUTHCheckTokenVaild
{

    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = self.configure.userToken;
    setting[@"v"] = @"2.1";
    
    [Mbr tokenValidWithParams:setting
                      success:^(CheckTokenModel *resultObj){
                          
                          
                          NSMutableDictionary *setting = [NSMutableDictionary dictionary];
                          setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
                          [Circle InitByBranchWithParams:setting success:^(id obj) {
                              CheckStoreStatuModel *model = [CheckStoreStatuModel parse:obj];
                              if ([model.apiStatus integerValue] == 0) {
                                  if (model.type) {
                                      QWGLOBALMANAGER.configure.storeType = model.type;
                                      QWGLOBALMANAGER.configure.storeCity = model.city;
                                      QWGLOBALMANAGER.configure.shortName = model.branchName;
                                      [QWGLOBALMANAGER saveAppConfigure];
                                  }
                              }else{
                                  QWGLOBALMANAGER.configure.storeType = 1;
                                  [QWGLOBALMANAGER saveAppConfigure];
                              }
                              
                              [QWGLOBALMANAGER.fadeCover fadeOut];
                              if([resultObj.apiStatus integerValue] != 0) {
                                  [SVProgressHUD showErrorWithStatus:resultObj.apiMessage duration:0.8f];
                                  [QWUserDefault setBool:NO key:APP_LOGIN_STATUS];
                                  self.configure.passWord = nil;
                                  [self clearAccountInformation];
                                  
                                  [self saveAppConfigure];
                                  [QWGLOBALMANAGER postNotif:NotifClearLoginPassword data:nil object:nil];
                                  
                              }else {
                                  
                                  if (QWGLOBALMANAGER.loginStatus) {
                                      
                                      NSString *approveStatus = [NSString stringWithFormat:@"%@",resultObj.approveStatus];
                                      
                                      QWGLOBALMANAGER.configure.groupId = StrFromObj(resultObj.branchId);
                                      
                                      if ([approveStatus integerValue] == 3)
                                      {
                                          // 认证通过后，清除缓存
                                          [QWUserDefault removeObjectBy:[NSString stringWithFormat:@"uploadLicense+%@",QWGLOBALMANAGER.configure.passportId]];
                                          [QWUserDefault removeObjectBy:[NSString stringWithFormat:@"OrganInfo+%@",QWGLOBALMANAGER.configure.passportId]];
                                          
                                          if (![approveStatus isEqualToString:QWGLOBALMANAGER.configure.approveStatus]) {
                                              QWGLOBALMANAGER.configure.approveStatus = [NSString stringWithFormat:@"%@",resultObj.approveStatus];
                                              [QWGLOBALMANAGER postNotif:NotifiOrganAuthPass data:nil object:nil];
                                          }
                                          [self loginAct];
                                          
                                      }else if ([approveStatus integerValue] == 2)
                                      {
                                          if (![approveStatus isEqualToString:QWGLOBALMANAGER.configure.approveStatus]) {
                                              QWGLOBALMANAGER.configure.approveStatus = [NSString stringWithFormat:@"%@",resultObj.approveStatus];
                                              [QWGLOBALMANAGER postNotif:NotifiOrganAuthFailure data:nil object:nil];
                                          }
                                      }
                                      
                                      QWGLOBALMANAGER.configure.approveStatus = [NSString stringWithFormat:@"%@",resultObj.approveStatus];
                                      
                                      [QWGLOBALMANAGER saveAppConfigure];
                                  }
                                  
                              }
                              
                          } failure:^(HttpException *e) {
                              QWGLOBALMANAGER.configure.storeType = 1;
                              [QWGLOBALMANAGER saveAppConfigure];
                              
                              [QWGLOBALMANAGER.fadeCover fadeOut];
                              if([resultObj.apiStatus integerValue] != 0) {
                                  [SVProgressHUD showErrorWithStatus:resultObj.apiMessage duration:0.8f];
                                  [QWUserDefault setBool:NO key:APP_LOGIN_STATUS];
                                  self.configure.passWord = nil;
                                  [self clearAccountInformation];
                                  
                                  [self saveAppConfigure];
                                  
                                  [QWGLOBALMANAGER postNotif:NotifClearLoginPassword data:nil object:nil];
                                  
                              }else {
                                  
                                  if (QWGLOBALMANAGER.loginStatus) {
                                      NSString *approveStatus = [NSString stringWithFormat:@"%@",resultObj.approveStatus];
                                      QWGLOBALMANAGER.configure.groupId = StrFromObj(resultObj.branchId);
                                      
                                      if ([approveStatus integerValue] == 3)
                                      {
                                          // 认证通过后，清除缓存
                                          [QWUserDefault removeObjectBy:[NSString stringWithFormat:@"uploadLicense+%@",QWGLOBALMANAGER.configure.passportId]];
                                          [QWUserDefault removeObjectBy:[NSString stringWithFormat:@"OrganInfo+%@",QWGLOBALMANAGER.configure.passportId]];
                                          if (![approveStatus isEqualToString:QWGLOBALMANAGER.configure.approveStatus]) {
                                              QWGLOBALMANAGER.configure.approveStatus = [NSString stringWithFormat:@"%@",resultObj.approveStatus];
                                              [QWGLOBALMANAGER postNotif:NotifiOrganAuthPass data:nil object:nil];
                                          }
                                          [self loginAct];
                                          
                                      }else if ([approveStatus integerValue] == 2)
                                      {
                                          if (![approveStatus isEqualToString:QWGLOBALMANAGER.configure.approveStatus]) {
                                              QWGLOBALMANAGER.configure.approveStatus = [NSString stringWithFormat:@"%@",resultObj.approveStatus];
                                             [QWGLOBALMANAGER postNotif:NotifiOrganAuthFailure data:nil object:nil];
                                          }
                                      }
                                      
                                      QWGLOBALMANAGER.configure.approveStatus = [NSString stringWithFormat:@"%@",resultObj.approveStatus];
                                      [QWGLOBALMANAGER saveAppConfigure];
                                  }
                                  
                              }
                          }];
                          
                      }
                      failure:^(HttpException *e){
                          
                      }];
}




#pragma mark - 问题已关闭
- (void)getClosedConsultList:(NSString *)timeStamp
{
    ConsultCloseModelR *colsedModelR = [ConsultCloseModelR new];
    colsedModelR.token = self.configure.userToken;
    colsedModelR.point = timeStamp;
    colsedModelR.view = @"15";
    __block NSNumber *headerRefresh;
    if ([timeStamp integerValue] == 0) {
        headerRefresh = [NSNumber numberWithBool:YES];
    }else{
        headerRefresh = [NSNumber numberWithBool:NO];
    }
    [Consult consultClosedtWithParams:colsedModelR success:^(id obj) {
        [self postNotif:NotiRefreshClosedConsult data:obj object:headerRefresh];
    } failure: NULL];
}

#pragma mark 开始/暂停
- (void)applicationDidEnterBackground{
    [self releaseMessageTimer];
}

/**
 *  APP 从后台进前台的回调
 */
- (void)applicationDidBecomeActive
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([[userDefault objectForKey:@"showGuide"] boolValue]){
    if (self.isForceUpdating) {
        if (self.currentNetWork == NotReachable) {
            Version * vmodel = [Version getFromNsuserDefault:@"Version"];
            if (vmodel != nil) {
                    [self showForceUpdateAlert:vmodel];
                } else {
                    [self checkVersion];
                }
            } else {
                [self checkVersion];
            }
        } else {
            [self checkNeedUpdate];
        }
    }
    // 专家入口
    if (IS_EXPERT_ENTRANCE) {
        
        [self createCircleMessageTimer];
    }else{
        // 门店入口
        if(AUTHORITY_ROOT) {
            [self createMessageTimer2];
        }
        [self createMessageTimer];
        if (QWGLOBALMANAGER.loginStatus) {
            [self createMessageTimerTaskScore];
        }
    }

    [self checkLogEnable];
    [self createTimerForCheckToken];
    [self checkAppAudition];
    if (IS_EXPERT_ENTRANCE) {
        
        if (app.isLaunchByNotification) {
            app.isLaunchByNotification = NO;
        }else {
            [self pullCircleMessage];
        }
        
        if (self.loginStatus) {
            [self expertCheckTokenVaild:YES];
        }
        
    }else{
        if (self.loginStatus) {
            [self checkTokenVaild:NO];
        }
    }
    
    [self postNotif:NotiRestartTimer data:nil object:nil];
    

    if (IS_EXPERT_ENTRANCE) {
        [self getAllAnsweringConsultData];
        [self getAllWaitingConsultData];
        [self pollWaitingConsultData];
        [[AppealUtil sharedInstance] synchronizeSilenceStatus];
    }
}


- (void)checkNeedUpdate
{
    self.lastTimeStamp = (double)[[NSDate date] timeIntervalSince1970];//[dicReturn[@"respTime"] doubleValue];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:APP_UPDATE_AFTER_THREE_DAYS] boolValue]) {
        // 3天后提醒
        NSTimeInterval intevalLast = [[[NSUserDefaults standardUserDefaults] objectForKey:APP_LAST_TIMESTAMP] doubleValue];//3*24*60*60
        if (self.lastTimeStamp - intevalLast >= 3*24*60*60) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:APP_UPDATE_AFTER_THREE_DAYS];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self checkVersion];
            self.boolLoadFromFirstIn = YES;
        }
        return ;
    } else {
        [self checkVersion];
    }
}



- (void)enablePushNotification:(BOOL)enable
{
    if(!self.loginStatus)
        return;
    SystemModelR *systemModelR = [SystemModelR new];
    systemModelR.token = self.configure.userToken;
    if(enable) {
        systemModelR.backStatus = @"0";
    }else{
        systemModelR.backStatus = @"1";
    }
    systemModelR.source = @"2";
    
    HttpClientMgr.progressEnabled=NO;
    [System systemBackSetWithParams:systemModelR success:^(id obj) {
        
    } failure:NULL];
}

//每10秒 同步一次服务器时间
- (void)checkCurrentSystemTime
{
    if([[QWUserDefault getNumberBy:SERVER_TIME] longLongValue] == 0 ) {
        [System checkTimeWithParams:nil success:^(CheckTimeModel *model) {
            if([model.apiStatus integerValue] == 0) {
                
                NSTimeInterval current = [[NSDate date] timeIntervalSince1970] * 1000ll;
                long long offset = model.check_timestamp - current;
                [QWUserDefault setNumber:[NSNumber numberWithLongLong:offset] key:SERVER_TIME];
                if(offset != 0) {
                    [self releaseHeartBeatTimer];
                }
            }
        } failure:NULL];
    }
}

- (void)checkAppAudition
{
    //首页判断是否在审核中,如果审核中,直接返回苏州生物纳米园位置信息
    [System systemCheckIosAuditParams:[NSDictionary dictionary] success:^(BaseAPIModel *model) {
        
        //审核中
        if([model.apiStatus integerValue] == 1) {
            
            [QWUserDefault setBool:YES key:kLocationAudition];
        }else{
            //审核之外，定位
            [QWUserDefault setBool:NO key:kLocationAudition];
        }
    } failure:^(HttpException *e) {
        [QWUserDefault setBool:NO key:kLocationAudition];
    }];
}


#pragma mark -
#pragma mark  全局定时器 轮询向服务器拉数据

- (void)createHeartBeatTimer
{
    heartBeatTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(heartBeatTimer, dispatch_time(DISPATCH_TIME_NOW, 3ull*NSEC_PER_SEC), 10ull*NSEC_PER_SEC , DISPATCH_TIME_FOREVER);
    dispatch_source_set_event_handler(heartBeatTimer, ^{
        [self checkCurrentSystemTime];
    });
    dispatch_source_set_cancel_handler(heartBeatTimer, ^{
        DDLogVerbose(@"has been canceled");
    });
    dispatch_resume(heartBeatTimer);
}

- (void)releaseHeartBeatTimer
{
    if(heartBeatTimer) {
        dispatch_source_cancel(self.heartBeatTimer);
        self.heartBeatTimer = NULL;
    }
}


- (void)createCircleMessageTimer
{
    pullCircleMessageTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(pullCircleMessageTimer, dispatch_time(DISPATCH_TIME_NOW, 0), 60ull*NSEC_PER_SEC, DISPATCH_TIME_FOREVER);
    dispatch_source_set_event_handler(pullCircleMessageTimer, ^{
        DebugLog(@"－－－111 圈子消息轮询");
        [ExpertMessageCenter pullAllExpertData];
        [self pullCircleForbidMessage];
        [self getAllAnsweringConsultData];
        [self pollWaitingConsultData];
    });
    dispatch_resume(pullCircleMessageTimer);
}

- (void)createMessageTimer
{
    pullMessageTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(pullMessageTimer, dispatch_time(DISPATCH_TIME_NOW, 0), 10ull*NSEC_PER_SEC, DISPATCH_TIME_FOREVER);
    dispatch_source_set_event_handler(pullMessageTimer, ^{
        DebugLog(@"－－－111 全维药事轮询");
        if(AUTHORITY_ROOT) {
            [self pullOfficialMessage];
        }
        [self getNewMsgBoxNoticeList]; // 消息轮询
        
    });
    dispatch_resume(pullMessageTimer);
}

//商户端 解答中轮训 默认10s执行一次（解答中是5）
//拉数据 存  更新ui（执行完一次轮回后才能执行下一次）
- (void)createMessageTimer2
{
    DebugLog(@"createMessageTimer2");
    self.lastTimestampfortimer = @"";
    pullMessageBoxTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(pullMessageBoxTimer, dispatch_time(DISPATCH_TIME_NOW, 1ull*NSEC_PER_SEC), 10ull*NSEC_PER_SEC, DISPATCH_TIME_FOREVER);
    dispatch_source_set_event_handler(pullMessageBoxTimer, ^{
        DebugLog(@"－－－222 问答轮询");
        [self getConsultingnewDetail];
        [self pollMyConsultingConsultList];
    });
    dispatch_resume(pullMessageBoxTimer);
}

/**
 *  商户端获取积分任务的轮询
 */
- (void)createMessageTimerTaskScore
{
    DebugLog(@"createMessageTimerTaskScore");
    self.lastTimestampfortimer = @"";
    pullMessageTaskScoreTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(pullMessageTaskScoreTimer, dispatch_time(DISPATCH_TIME_NOW, 0), 10ull*NSEC_PER_SEC, DISPATCH_TIME_FOREVER);
    dispatch_source_set_event_handler(pullMessageTaskScoreTimer, ^{
        [self.scoreManager checkIfOverOneHour];
    });
    dispatch_resume(pullMessageTaskScoreTimer);
}

// 商户端校验token 账号抢登

- (void)createTimerForCheckToken
{
    CheckTokenTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(CheckTokenTimer, dispatch_time(DISPATCH_TIME_NOW, 1ull*NSEC_PER_SEC), 10ull*NSEC_PER_SEC, DISPATCH_TIME_FOREVER);
    dispatch_source_set_event_handler(CheckTokenTimer, ^{
        if (IS_EXPERT_ENTRANCE) {
            [self expertCheckTokenVaild:NO];
        }else{
            [self checkTokenVaild:NO];
            [self getAllNewOrderCount];     //轮询未处理订单的数量
        }
    });
    dispatch_resume(CheckTokenTimer);
}

- (void)releaseMessageTimer
{
    if(pullCircleMessageTimer)
    {
        dispatch_source_cancel(pullCircleMessageTimer);
        pullCircleMessageTimer = NULL;
    }
    if(pullMessageTimer)
    {
        dispatch_source_cancel(pullMessageTimer);
        pullMessageTimer = NULL;
    }
    if (pullMessageBoxTimer)
    {
        dispatch_source_cancel(pullMessageBoxTimer);
        pullMessageBoxTimer = NULL;
    }
    if (pullMessageTaskScoreTimer) {
        dispatch_source_cancel(pullMessageTaskScoreTimer);
        pullMessageTaskScoreTimer = NULL;
    }
    if (CheckTokenTimer)
    {
        dispatch_source_cancel(CheckTokenTimer);
        CheckTokenTimer = NULL;
    }
}

//判断当前账号是否失效
- (void)checkTokenVaild:(BOOL)firstLogin
{
    if (!self.isCheckToken) {
        return;
    }
    
    self.isCheckToken = YES;
    if(firstLogin) {
        if(![QWUserDefault getBoolBy:APP_LOGIN_STATUS]) {
            return;
        }
    }else{
        [QWGLOBALMANAGER.fadeCover fadeOut];
        if(!self.loginStatus)
            return;
    }
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = self.configure.userToken;
    setting[@"v"] = @"2.1";
    
    
    
    [Mbr tokenValidWithParams:setting
                      success:^(CheckTokenModel *resultObj){
                          
                          NSMutableDictionary *setting = [NSMutableDictionary dictionary];
                          setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
                          [Circle InitByBranchWithParams:setting success:^(id obj) {
                              CheckStoreStatuModel *model = [CheckStoreStatuModel parse:obj];
                              if ([model.apiStatus integerValue] == 0) {
                                  if (model.type) {
                                      QWGLOBALMANAGER.configure.storeType = model.type;
                                      QWGLOBALMANAGER.configure.storeCity = model.city;
                                      QWGLOBALMANAGER.configure.shortName = model.branchName;
                                      [QWGLOBALMANAGER saveAppConfigure];
                                  }
                              }else{
                                  QWGLOBALMANAGER.configure.storeType = 1;
                                  [QWGLOBALMANAGER saveAppConfigure];
                              }
                              
                              [QWGLOBALMANAGER.fadeCover fadeOut];
                              if([resultObj.apiStatus integerValue] != 0) {
                                  [SVProgressHUD showErrorWithStatus:resultObj.apiMessage duration:0.8f];
                                  [QWUserDefault setBool:NO key:APP_LOGIN_STATUS];
                                  self.configure.passWord = @"";
                                  [self clearAccountInformation];
                                  [self saveAppConfigure];
                                  
                                  [QWGLOBALMANAGER postNotif:NotifClearLoginPassword data:nil object:nil];
                                  
                              }else {
                                  if(firstLogin) {
                                      [self saveOperateLog:@"2"];
                                      [QWGLOBALMANAGER.fadeCover fadeOut];
                                      QWGLOBALMANAGER.loginStatus = YES;
                                      [QWGLOBALMANAGER postNotif:NotifLoginSuccess data:nil object:self];
                                      [QWGLOBALMANAGER loginSucess];
                                      AppDelegate *apppp = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                      [apppp initTabBar];
                                  }
                                  
                                  if (QWGLOBALMANAGER.loginStatus) {

                                      NSString * approveStatus = [NSString stringWithFormat:@"%@",resultObj.approveStatus];
                                      QWGLOBALMANAGER.configure.groupId = StrFromObj(resultObj.branchId);
                                      
                                      if ([approveStatus integerValue] == 3)
                                      {
                                          // 认证通过后，清除缓存
                                          [QWUserDefault removeObjectBy:[NSString stringWithFormat:@"uploadLicense+%@",QWGLOBALMANAGER.configure.passportId]];
                                          [QWUserDefault removeObjectBy:[NSString stringWithFormat:@"OrganInfo+%@",QWGLOBALMANAGER.configure.passportId]];
                                          
                                          if (![approveStatus isEqualToString:QWGLOBALMANAGER.configure.approveStatus]) {
                                              QWGLOBALMANAGER.configure.approveStatus = [NSString stringWithFormat:@"%@",resultObj.approveStatus];
                                              [QWGLOBALMANAGER postNotif:NotifiOrganAuthPass data:nil object:nil];
                                          }

                                      }else if ([approveStatus integerValue] == 2)
                                      {
                                          if (![approveStatus isEqualToString:QWGLOBALMANAGER.configure.approveStatus]) {
                                              QWGLOBALMANAGER.configure.approveStatus = [NSString stringWithFormat:@"%@",resultObj.approveStatus];
                                              [QWGLOBALMANAGER postNotif:NotifiOrganAuthFailure data:nil object:nil];
                                          }
                                      }
                                      
                                      QWGLOBALMANAGER.configure.approveStatus = [NSString stringWithFormat:@"%@",resultObj.approveStatus];
                                      [QWGLOBALMANAGER saveAppConfigure];
                                      [self saveCreditEnhanceWithModel:(id)resultObj];
                                  }
                              }
                          } failure:^(HttpException *e) {
                              QWGLOBALMANAGER.configure.storeType = 1;
                              [QWGLOBALMANAGER saveAppConfigure];
                              
                              [QWGLOBALMANAGER.fadeCover fadeOut];
                              if([resultObj.apiStatus integerValue] != 0) {
                                  [SVProgressHUD showErrorWithStatus:resultObj.apiMessage duration:0.8f];
                                  [QWUserDefault setBool:NO key:APP_LOGIN_STATUS];
                                  self.configure.passWord = @"";
                                  [self clearAccountInformation];
                                  [self saveAppConfigure];
                                  
                                  [QWGLOBALMANAGER postNotif:NotifClearLoginPassword data:nil object:nil];
                                  
                              }else {
                                  if(firstLogin) {
                                      [self saveOperateLog:@"2"];
                                      [QWGLOBALMANAGER.fadeCover fadeOut];
                                      QWGLOBALMANAGER.loginStatus = YES;
                                      [QWGLOBALMANAGER postNotif:NotifLoginSuccess data:nil object:self];
                                      [QWGLOBALMANAGER loginSucess];
                                      AppDelegate *apppp = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                      [apppp initTabBar];
                                  }
                                  
                                  if (QWGLOBALMANAGER.loginStatus) {
                                      
                                      
                                      NSString * approveStatus = [NSString stringWithFormat:@"%@",resultObj.approveStatus];
                                      QWGLOBALMANAGER.configure.groupId = StrFromObj(resultObj.branchId);
                                      
                                      if ([approveStatus integerValue] == 3)
                                      {
                                          // 认证通过后，清除缓存
                                          [QWUserDefault removeObjectBy:[NSString stringWithFormat:@"uploadLicense+%@",QWGLOBALMANAGER.configure.passportId]];
                                          [QWUserDefault removeObjectBy:[NSString stringWithFormat:@"OrganInfo+%@",QWGLOBALMANAGER.configure.passportId]];
                                          
                                          if (![approveStatus isEqualToString:QWGLOBALMANAGER.configure.approveStatus]) {
                                              QWGLOBALMANAGER.configure.approveStatus = [NSString stringWithFormat:@"%@",resultObj.approveStatus];
                                              [QWGLOBALMANAGER postNotif:NotifiOrganAuthPass data:nil object:nil];
                                          }
                                          
                                      }else if ([approveStatus integerValue] == 2)
                                      {
                                          if (![approveStatus isEqualToString:QWGLOBALMANAGER.configure.approveStatus]) {
                                              QWGLOBALMANAGER.configure.approveStatus = [NSString stringWithFormat:@"%@",resultObj.approveStatus];
                                              [QWGLOBALMANAGER postNotif:NotifiOrganAuthFailure data:nil object:nil];
                                          }
                                      }
                                      
                                      QWGLOBALMANAGER.configure.approveStatus = [NSString stringWithFormat:@"%@",resultObj.approveStatus];
                                      [QWGLOBALMANAGER saveAppConfigure];
                                  }
                                  [self saveCreditEnhanceWithModel:(id)resultObj];
                              }
                          }];
                          

                      }
                      failure:^(HttpException *e){
                          
                      }];
}

- (void)expertCheckTokenVaild:(BOOL)firstLogin
{
    if(!StrIsEmpty(QWGLOBALMANAGER.configure.expertToken)) {
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"token"] = QWGLOBALMANAGER.configure.expertToken;
        HttpClientMgr.progressEnabled=NO;
    
        [Circle tokenValidWithParams:setting success:^(id obj) {
            
            CheckExpertTokenModel *model = [CheckExpertTokenModel parse:obj];
            
            if([model.apiStatus integerValue] != 0) {
                [SVProgressHUD showErrorWithStatus:model.apiMessage duration:0.8f];
                [QWUserDefault setBool:NO key:APP_LOGIN_STATUS];
                [self clearExpertAccountInformation];
                [self saveAppConfigure];
            }else{
                if (firstLogin) {
                    [self saveOperateLog:@"2"];
                    QWGLOBALMANAGER.loginStatus = YES;
                    [QWGLOBALMANAGER postNotif:NotifLoginSuccess data:nil object:self];
                    [QWGLOBALMANAGER expertLoginSuccess];
                    [QWUserDefault setBool:YES key:APP_LOGIN_STATUS];
                    
                    //（5:未申请 1:已申请待认证, 2:已认证, 3:认证不通过, 4:认证中(app不需要)）
                    if ([model.authStatus integerValue] == 5 || [model.authStatus integerValue] == 3) {
                        
                        //进入认证页面
                        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        LaunchEntranceViewController *vc = [[UIStoryboard storyboardWithName:@"Launch" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchEntranceViewController"];
                        UINavigationController *nav = [[QWBaseNavigationController alloc] initWithRootViewController:vc];
                        app.window.rootViewController = nav;
                        
                        ExpertAuthViewController *auth = [[UIStoryboard storyboardWithName:@"ExpertAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertAuthViewController"];
                        [nav pushViewController:auth animated:NO];
                        
                    }else if ([model.authStatus integerValue] == 1){
                        
                        //进入申请成功页面
                        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        LaunchEntranceViewController *vc = [[UIStoryboard storyboardWithName:@"Launch" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchEntranceViewController"];
                        UINavigationController *nav = [[QWBaseNavigationController alloc] initWithRootViewController:vc];
                        app.window.rootViewController = nav;
                        
                        ExpertAuthCommitViewController *auth = [[UIStoryboard storyboardWithName:@"ExpertAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertAuthCommitViewController"];
                        [nav pushViewController:auth animated:NO];
                        
                    }else if ([model.authStatus integerValue] == 2 || [model.authStatus integerValue] == 4){
                        //进入圈子主页
                        if(QWGLOBALMANAGER.tabBar)
                            return;
                        AppDelegate *apppp = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        [apppp initTabBar];
                        
                        NSDictionary *dicNotice = apppp.dicNotice;
                        
                        if (dicNotice == nil) {
                            [self pullCircleMessage];
                        }else{
                            [self appLuanchNoticefication];
                        }
                    }
                }
                QWGLOBALMANAGER.configure.silencedFlag = model.silencedFlag;
                [QWGLOBALMANAGER saveAppConfigure];
                
            }
        } failure:^(HttpException *e) {
            
        }];
    }
}

-(void)appLuanchNoticefication{
     AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *dicNotice =app.dicNotice;
    if (dicNotice ) {
        
        if(dicNotice[@"message"])
        {
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            
            NSData *jsonData = [dicNotice[@"message"] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
            
            NotificationModel *model = [NotificationModel parse:dic];
            if (model) {
                if ([[NSString stringWithFormat:@"%@",model.type] isEqualToString:@"19"]){//圈子消息
                    
                    [app jumpToCircleInfoWith:model];
                    
                }
            }
        }
    }
}


- (void)quitAccount
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:Kwarning220N81 delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    alert.tag = 10002;
    QWGLOBALMANAGER.isCheckToken = NO;
}

- (void)getCramePrivate{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"无法使用相机"message:kWaring67 delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)loginAct
{
    LoginModelR *modeR=[LoginModelR new];
    modeR.account = QWGLOBALMANAGER.configure.userName;
    modeR.password = QWGLOBALMANAGER.configure.passWord;
    modeR.deviceCode = DEVICE_IDD;
    modeR.deviceType = @"2";
    modeR.pushDeviceCode = [QWGLOBALMANAGER deviceToken];
    modeR.credentials=[AESUtil encryptAESData:QWGLOBALMANAGER.configure.passWord app_key:AES_KEY];
    //成功注册后登录
    [Store loginWithParam:modeR success:^(id obj) {
        [QWUserDefault setObject:@"1" key:@"ENTRANCETYPE"];
        StoreUserInfoModel *userModel = (StoreUserInfoModel *)obj;
        
        if ([userModel.apiStatus integerValue] == 0) {
            
            NSMutableDictionary *setting = [NSMutableDictionary dictionary];
            setting[@"token"] = StrFromObj(userModel.token);
            [Circle InitByBranchWithParams:setting success:^(id obj) {
                CheckStoreStatuModel *model = [CheckStoreStatuModel parse:obj];
                if ([model.apiStatus integerValue] == 0) {
                    if (model.type) {
                        QWGLOBALMANAGER.configure.storeType = model.type;
                        QWGLOBALMANAGER.configure.storeCity = model.city;
                        QWGLOBALMANAGER.configure.shortName = model.branchName;
                        [QWGLOBALMANAGER saveAppConfigure];
                    }
                }else{
                    QWGLOBALMANAGER.configure.storeType = 1;
                    [QWGLOBALMANAGER saveAppConfigure];
                }
                [self saveLoginUserInfo:userModel];
            } failure:^(HttpException *e) {
                QWGLOBALMANAGER.configure.storeType = 1;
                [QWGLOBALMANAGER saveAppConfigure];
                [self saveLoginUserInfo:userModel];
            }];
            
        }else{
            [SVProgressHUD showErrorWithStatus:userModel.apiMessage duration:0.8];
        }
    } failure:^(HttpException *e) {
       
    }];
}

- (void)saveLoginUserInfo:(StoreUserInfoModel *)userModel
{
    NSString * str = userModel.token;
    if (str) {
        QWGLOBALMANAGER.configure.userToken = userModel.token;
        QWGLOBALMANAGER.configure.passportId = userModel.passport;
        QWGLOBALMANAGER.configure.groupId = userModel.branchId;
        QWGLOBALMANAGER.configure.userName = QWGLOBALMANAGER.configure.userName;
        QWGLOBALMANAGER.configure.passWord = QWGLOBALMANAGER.configure.passWord;
        QWGLOBALMANAGER.configure.type = [NSString stringWithFormat:@"%@",userModel.type];
        QWGLOBALMANAGER.configure.showName = userModel.name;
        QWGLOBALMANAGER.configure.mobile = userModel.mobile;

        /*
         1, 待审核  资料已提交页面
         2, 审核不通过  带入老数据的认证流程
         3, 审核通过    功能正常
         4, 未提交审核  认证流程
         */
        QWGLOBALMANAGER.configure.approveStatus = [NSString stringWithFormat:@"%@",userModel.approveStatus];
        
        if ([QWGLOBALMANAGER.configure.approveStatus integerValue] == 3) {
            // 认证通过后，清除缓存
            [QWUserDefault removeObjectBy:[NSString stringWithFormat:@"uploadLicense+%@",QWGLOBALMANAGER.configure.passportId]];
            [QWUserDefault removeObjectBy:[NSString stringWithFormat:@"OrganInfo+%@",QWGLOBALMANAGER.configure.passportId]];
        }
        
        
        NSString *nickName = userModel.branchName;
        
        if(nickName && ![nickName isEqual:[NSNull null]]){
            QWGLOBALMANAGER.configure.nickName = nickName;
        }else{
            QWGLOBALMANAGER.configure.nickName = @"";
        }
        NSString *avatarUrl = userModel.branchImgUrl;
        if(avatarUrl && ![avatarUrl isEqual:[NSNull null]]){
            QWGLOBALMANAGER.configure.avatarUrl = avatarUrl;
        }else{
            QWGLOBALMANAGER.configure.avatarUrl = @"";
        }
        QWGLOBALMANAGER.loginStatus = YES;
        [QWGLOBALMANAGER saveAppConfigure];
        //通知登录成功
        [QWGLOBALMANAGER postNotif:NotifLoginSuccess data:userModel object:self];
        [QWGLOBALMANAGER loginSucess];
        
        [QWGLOBALMANAGER saveOperateLog:@"2"];
    }
    if(QWGLOBALMANAGER.tabBar){
        //                [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    }else{
        AppDelegate *appDe = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDe initTabBar];
        
    }
}

#pragma mark -
#pragma mark  版本检查

- (void)showForceUpdateAlert:(Version *)model
{
    if (!self.isShowAlert) {
        if (self.isShowCustomAlert) {
            [self autoDismissCustomAlert];
        }
        NSString *strAlertMessage = [NSString stringWithFormat:@"版本号: %@    \n%@",model.version, model.note];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"检测到新版本" message:strAlertMessage delegate:self cancelButtonTitle:@"暂不升级" otherButtonTitles:@"立即更新", nil];
        alertView.tag = 10000;
        [alertView show];
        self.isShowAlert = YES;
    }

}

- (void)showNormalUpdateAlert:(Version *)model
{
    if (!self.isShowAlert) {
        if (self.isShowCustomAlert) {
            [self autoDismissCustomAlert];
        }
        //    NSString *strAlertMessage = [NSString stringWithFormat:@"版本号: %@    大小: %@",dicUpdate[@"versionName"], dicUpdate[@"size"]];
        NSString *strAlertMessage = [NSString stringWithFormat:@"版本号: %@    ",model.version];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发现新版本" message:strAlertMessage delegate:self cancelButtonTitle:@"暂不升级" otherButtonTitles:@"立即更新", nil];
        NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"customAlertView"
                                                          owner:self
                                                        options:nil];
        
        myAlertView = [ nibViews objectAtIndex: 0];
        
        myAlertView.tvViewMessage.text = model.note;
        //check if os version is 7 or above
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            [alertView setValue:myAlertView forKey:@"accessoryView"];
        }else{
            [alertView addSubview:myAlertView];
        }
        alertView.tag = 10001;
        [alertView show];

        self.isShowAlert = YES;
    }
}

- (NSInteger)getIntValueFromVersionStr:(NSString *)strVersion
{
    NSArray *arrVer = [strVersion componentsSeparatedByString:@"."];
    NSString *strVer = [arrVer componentsJoinedByString:@""];
    NSInteger intVer = [strVer integerValue];
    return intVer;
}

- (void)clearOldCache
{
    NSString *homePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for(NSString *userDir in [fileManager contentsOfDirectoryAtPath:homePath error:nil])
    {
        [fileManager removeItemAtPath:[homePath stringByAppendingFormat:@"/%@",userDir] error:nil];
    }
    [QWUserDefault setBool:NO key:APP_LOGIN_STATUS];
}

//检查版本更新
- (void)checkVersion
{
    
    if (self.boolLoadFromFirstIn) {
        self.boolLoadFromFirstIn = NO;
        return;
    }
    self.boolLoadFromFirstIn = YES;
    HttpClientMgr.progressEnabled=NO;
    [VersionUpdate checkVersion:APP_VERSION
                        success:^(Version * model){
                            
                            self.boolLoadFromFirstIn = NO;
                            installUrl = model.downloadUrl;
                            NSInteger intCurVersion = [self getIntValueFromVersionStr:APP_VERSION];
                            intCurVersion = intCurVersion / 10;
                            NSInteger intSysVersion = [self getIntValueFromVersionStr:model.version];
                            NSInteger intLastSysVersion = [self getIntValueFromVersionStr:[[NSUserDefaults standardUserDefaults] objectForKey:APP_LAST_SYSTEM_VERSION]];
                            [[NSUserDefaults standardUserDefaults] setObject:model.version forKey:APP_LAST_SYSTEM_VERSION];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            if ([model.compel integerValue] == 1) {
                                // force update
                                self.isForceUpdating = YES;
                                [self showForceUpdateAlert:model];
                                [model saveToNsuserDefault:@"Version"];
                            } else {
                                // normal update
                                // add here
                                self.isForceUpdating = NO;
//                                if ((intLastSysVersion < intSysVersion)&&intLastSysVersion!=0)
//                                {
//                                    [self showNormalUpdateAlert:model];
//                                }
//                                else
//                                {
                                    if ([[[NSUserDefaults standardUserDefaults] objectForKey:APP_UPDATE_AFTER_THREE_DAYS] boolValue])
                                    {
                                        
                                    }
                                    else
                                    {
                                        [self showNormalUpdateAlert:model];
                                    }
//                                }
                            }
                        }
                        failure:^(HttpException *e){

                        }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10000) {
        self.isShowAlert = NO;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:APP_UPDATE_AFTER_THREE_DAYS];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (buttonIndex == 0) {
            exit(0);
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:installUrl]];
        }
    } else if (alertView.tag == 10001) {
        self.isShowAlert = NO;
        if (buttonIndex == 0) {
            if (myAlertView.isClick) {
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:APP_UPDATE_AFTER_THREE_DAYS];
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:(double)[[NSDate date] timeIntervalSince1970]] forKey:APP_LAST_TIMESTAMP];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } else {
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:APP_UPDATE_AFTER_THREE_DAYS];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:APP_UPDATE_AFTER_THREE_DAYS];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:installUrl]];
        }
    }else if (alertView.tag == 10002)
    {
        [QWGLOBALMANAGER postNotif:NotifQuitOut data:nil object:nil];
        QWGLOBALMANAGER.configure.passWord = @"";
        [QWGLOBALMANAGER saveAppConfigure];
        [QWGLOBALMANAGER clearAccountInformation];
        [QWUserDefault setBool:NO key:APP_LOGIN_STATUS];
    }
}

- (void)showSplash
{
    if (![QWUserDefault getBoolBy:ONCE_LOADING]) {
        //已经显示过引导页的话
        
        if (IS_IPHONE_4_OR_LESS)
        {
            showAppGuide(@[@"guide_one_960",@"guide_two_960",@"guide_three_960"]);
        }else if (IS_IPHONE_6P)
        {
            showAppGuide(@[@"guide_one_6p",@"guide_two_6p",@"guide_three_6p"]);
        }else
        {
            showAppGuide(@[@"guide_one_1136",@"guide_two_1136",@"guide_three_1136"]);
        }
        
        [QWUserDefault setBool:YES key:ONCE_LOADING];
        [QWUserDefault setBool:YES key:APP_QUESTIONPUSH_NOTIFICATION];
    } else {
//        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//        if([[userDefault objectForKey:@"showGuide"] boolValue]){
            [QWGLOBALMANAGER postNotif:NotifAppCheckVersion data:nil object:nil];
//        }
    }
    
}
- (NSString *)removeSpace:(NSString *)string
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

/**
 *  @brief 封装三目运算符 如果str1存在,返回str1,否则返回str2
 *
 *  @param str1 优先显示的对象
 *  @param str2 str1不存在时显示的对象
 *
 *  @return 如果str1存在,返回str1,否则返回str2
 */
- (id)compareExist:(id)str1 and:(id)str2
{
    id str = str1 ? str1 :str2;
    return str;
}


//-(void)jumpControlWithType:(int)index
//{
//    for(UINavigationController *navigationController in QWGLOBALMANAGER.tabBar.viewControllers) {
//        [navigationController popToRootViewControllerAnimated:NO];
//    }
//    QWGLOBALMANAGER.tabBar.selectedIndex = 0;
//    
//    //跳转到聊天详情
//    HomePageViewController *vc = [self homePage];
//    vc.segmentedControl.selectedSegmentIndex = index;
//}

//-(void)jumpChatWithType:(int)index
//{
//    for(UINavigationController *navigationController in QWGLOBALMANAGER.tabBar.viewControllers) {
//        [navigationController popToRootViewControllerAnimated:NO];
//    }
//    QWGLOBALMANAGER.tabBar.selectedIndex = 0;
//    
//    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:1];
//    
//    //跳转到聊天详情
//    HomePageViewController *newHomePageViewController = ((UINavigationController *)QWGLOBALMANAGER.tabBar.viewControllers[0]).viewControllers[0];
//    [newHomePageViewController tableView:Nil didSelectRowAtIndexPath:indexPath];
//}

//跳转全维药师
//-(void)jumpToOffical
//{
//    XHDemoWeChatMessageTableViewController *vc = nil;
//    vc = [[XHDemoWeChatMessageTableViewController alloc] init];
//    
//    vc.hidesBottomBarWhenPushed = YES;
//    
//    vc.accountType = OfficialType;
//    vc.showType = MessageShowTypeAnswer;
//    HomePageViewController *home = ((UINavigationController *)QWGLOBALMANAGER.tabBar.viewControllers[0]).viewControllers[0];
//    [home dismissOfficialHintImage];
//    [home.navigationController pushViewController:vc animated:YES];
//    
//}



#pragma mark -
#pragma mark 长按保存图片
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        UIImageWriteToSavedPhotosAlbum(QWGLOBALMANAGER.saveImage,  self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(!error) {
        [SVProgressHUD showSuccessWithStatus:@"图片保存成功" duration:0.8f];
    }
}

- (NSString *)randomUUID
{
    NSString* uuid = [NSUUID UUID].UUIDString;
    uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return uuid;
}

static NSDateFormatter* dateFormatter;
- (NSString*)timeStrSinceNowWithPastDateStr:(NSString*)pastDateStr withFormatter:(NSString*)formatterStr
{
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = formatterStr;
    NSDate* pastDate = [dateFormatter dateFromString:pastDateStr];
    return [self timeStrSinceNowWithPastDate:pastDate];
}

- (NSString *)timeStrSinceNowWithPastDate:(NSDate *)pastDate
{
    if (pastDate == nil) {
        return @"很久以前";
    }
    dateFormatter = [[NSDateFormatter alloc] init];
    NSString* dateFormatterString1 = @"yyyy.MM.dd hh:mm";
    NSString* dateFormatterString2 = @"MM.dd hh:mm";
    NSString* dateFormatterString3 = @"hh:mm";
    dateFormatter.dateFormat = dateFormatterString1;
    NSDate* now = [NSDate new];
    if (![now isSameYearAsDate:pastDate]) {
        dateFormatter.dateFormat = dateFormatterString1;
        return [dateFormatter stringFromDate:pastDate];
    }
    else
    {
        if ([pastDate isYesterday]) {
            dateFormatter.dateFormat = dateFormatterString3;
            return [NSString stringWithFormat:@"昨日 %@", [dateFormatter stringFromDate:pastDate]];
        }
        else if ([pastDate isToday])
        {
            NSTimeInterval interval = fabs([pastDate timeIntervalSinceNow]);
            if (interval < 60) {
                return @"刚刚";
            }
            else if (interval < 60 * 60 )
            {
                return [NSString stringWithFormat:@"%ld分钟前", MAX(1, ((long)interval) / 60)];
            }
            else if (interval < 60 * 60 * 5)
            {
                return [NSString stringWithFormat:@"%ld小时前", MAX(1, ((long)interval)%(60*60*60) / (60*60))];
            }
            else
            {
                dateFormatter.dateFormat = dateFormatterString3;
                return [dateFormatter stringFromDate:pastDate];
            }
        }
        else
        {
            dateFormatter.dateFormat = dateFormatterString2;
            return [dateFormatter stringFromDate:pastDate];
        }
    }
}

- (NSString *)timeStrSinceNowWithPastDate:(NSDate *)pastDate formatWithD:(NSString *)dStr andM:(NSString *)mStr andY:(NSString *)yStr
{
    if (pastDate == nil) {
        return @"很久以前";
    }
    dateFormatter = [[NSDateFormatter alloc] init];
    NSString* dateFormatterString1 = yStr;
    NSString* dateFormatterString2 = mStr;
    NSString* dateFormatterString3 = dStr;
    dateFormatter.dateFormat = dateFormatterString1;
    NSDate* now = [NSDate new];
    if (![now isSameYearAsDate:pastDate]) {
        dateFormatter.dateFormat = dateFormatterString1;
        return [dateFormatter stringFromDate:pastDate];
    }
    else
    {
        if ([pastDate isYesterday]) {
            dateFormatter.dateFormat = dateFormatterString3;
            return [NSString stringWithFormat:@"昨日 %@", [dateFormatter stringFromDate:pastDate]];
        }
        else if ([pastDate isToday])
        {
            double timeleap = [pastDate timeIntervalSinceNow];
            NSString *suffix = timeleap > 0 ? @"后" : @"前";
            NSTimeInterval interval = fabs(timeleap);
            
            if (interval < 60) {
                return @"刚刚";
            }
            else if (interval < 60 * 60 )
            {
                return [NSString stringWithFormat:@"%ld分钟%@", MAX(1, ((long)interval) / 60), suffix];
            }
            else if (interval < 60 * 60 * 5)
            {
                return [NSString stringWithFormat:@"%ld小时%@", MAX(1, ((long)interval)%(60*60*60) / (60*60)), suffix];
            }
            else
            {
                dateFormatter.dateFormat = dateFormatterString3;
                return [dateFormatter stringFromDate:pastDate];
            }
        }
        else
        {
            dateFormatter.dateFormat = dateFormatterString2;
            return [dateFormatter stringFromDate:pastDate];
        }
    }
}


#pragma mark ---- 获取专家咨询数据 ----
- (void)getAllExpertConsult
{
    if (IS_EXPERT_ENTRANCE)
    {
        //全量待抢答
        [self getAllWaitingConsultData];
        
        //全量解答中
        [self getAllAnsweringConsultData];
        
        //全量已关闭
        [self getAllColsedConsultData];
    }
}

#pragma mark ---- 全量待抢答数据 ----
- (void)getAllWaitingConsultData
{
    if(!self.loginStatus)
        return;
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"func"] = @"1";
    setting[@"page"] = @"1";
    setting[@"pageSize"] = @"9999";
    [UserChat ImConsultQueryQAListWithParams:setting success:^(id obj) {
        InterlocutionPageModel *page = [InterlocutionPageModel parse:obj Elements:[InterlocutionListModel class] forAttribute:@"list"];
        NSArray *array = page.list;
        [self postNotif:NotiRefreshExpertWaiting data:array object:nil];
        
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ---- 增量待抢答数据 ----
- (void)pollWaitingConsultData
{
    if(!self.loginStatus)
        return;
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"func"] = @"2";
    setting[@"page"] = @"1";
    setting[@"pageSize"] = @"9999";
    [UserChat ImConsultQueryQAListWithParams:setting success:^(id obj) {
        InterlocutionPageModel *page = [InterlocutionPageModel parse:obj Elements:[InterlocutionListModel class] forAttribute:@"list"];
        NSArray *array = page.list;
        //检测待抢答小红点
        if (self.vcInterlocution.selectedNum == 0 && self.tabBar.selectedIndex == 1 && self.vcConsultMain.selectedNum == 1)
        {
            //如果在待抢答的tab，不显示小红点
            if (array.count > 0) {
                [QWGLOBALMANAGER getAllWaitingConsultData];
            }
        }else
        {
            //待抢答新消息提醒
            if (array && array.count && array.count >0) {
                QWGLOBALMANAGER.configure.hadWaitingMessage = YES;
            }
            [QWGLOBALMANAGER saveAppConfigure];
        }
        [self checkInterlocutionRedPoint];
        
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ---- 全量/增量 解答中数据 ----
- (void)getAllAnsweringConsultData
{
    if(!self.loginStatus)
        return;
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"func"] = @"3";
    [UserChat ImConsultQueryQAListWithParams:setting success:^(id obj) {
        
        InterlocutionPageModel *page = [InterlocutionPageModel parse:obj Elements:[InterlocutionListModel class] forAttribute:@"list"];
        NSArray *listModel = page.list;
        [InterlocutionListModel deleteAllObjFromDB];
        
        if (listModel.count >0) {
            [InterlocutionListModel insertToDBWithArray:listModel filter:^(id model, BOOL inseted, BOOL *rollback) {
            }];
        }
        
        //检测小红点
        for (InterlocutionListModel *model in page.list) {
            if (model.unRead) {
                //有未读消息
                QWGLOBALMANAGER.configure.hadAnswerMessage = YES;
                [QWGLOBALMANAGER saveAppConfigure];
                break;
            }else{
                QWGLOBALMANAGER.configure.hadAnswerMessage = NO;
                [QWGLOBALMANAGER saveAppConfigure];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self checkInterlocutionRedPoint];
        });
        [self postNotif:NotiRefreshExpertAnswering data:page.list object:nil];
        
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ---- 全量已关闭数据 ----
- (void)getAllColsedConsultData
{
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"func"] = @"4";
    setting[@"page"] = @"1";
    setting[@"pageSize"] = @"20";
    [self postNotif:NotiChangeCurrentPage data:nil object:nil];
    __block NSNumber *headerRefresh;
    headerRefresh = [NSNumber numberWithBool:YES];
    
    [UserChat ImConsultQueryQAListWithParams:setting success:^(id obj) {
        
        InterlocutionPageModel *page = [InterlocutionPageModel parse:obj Elements:[InterlocutionListModel class] forAttribute:@"list"];
        [self postNotif:NotiRefreshExpertClosed data:page.list object:headerRefresh];
        
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ---- check 问答小红点 ----
- (void)checkInterlocutionRedPoint
{
    if (QWGLOBALMANAGER.configure.hadWaitingMessage || QWGLOBALMANAGER.configure.hadAnswerMessage || [IMChatPointVo checkPMUnread])
    {
        //如果私聊，待抢答，解答中 任意一个有新消息
        
        //咨询tab显示小红点
        [QWGLOBALMANAGER.tabBar showBadgePoint:YES itemTag:Enum_TabBar_Items_ExpertChat];
        
        if([IMChatPointVo checkPMUnread])
        {
            //如果私聊有新消息
            [self.vcConsultMain.segmentControl showBadgePoint:YES itemTag:0];
        }else
        {
            [self.vcConsultMain.segmentControl showBadgePoint:NO itemTag:1];
            
            if (QWGLOBALMANAGER.configure.hadWaitingMessage || QWGLOBALMANAGER.configure.hadAnswerMessage)
            {
                //如果待抢答，解答中任意一个有新信息
                [self.vcConsultMain.segmentControl showBadgePoint:YES itemTag:1];
                
                if (QWGLOBALMANAGER.configure.hadWaitingMessage) {
                    //如果待抢答有新消息
                    self.vcInterlocution.redPointOne.hidden = NO;
                }else{
                    self.vcInterlocution.redPointOne.hidden = YES;
                }
                
                if (QWGLOBALMANAGER.configure.hadAnswerMessage){
                    //如果解答中有新信息
                    self.vcInterlocution.redPointTwo.hidden = NO;
                }else
                {
                    self.vcInterlocution.redPointTwo.hidden = YES;
                }
            }
        }
    }else
    {
        //都没有小红点
        [QWGLOBALMANAGER.tabBar showBadgePoint:NO itemTag:Enum_TabBar_Items_ExpertChat];
        [self.vcConsultMain.segmentControl showBadgePoint:NO itemTag:0];
        [self.vcConsultMain.segmentControl showBadgePoint:NO itemTag:1];
        self.vcInterlocution.redPointOne.hidden = YES;
        self.vcInterlocution.redPointTwo.hidden = YES;
    }
}

@end

static NSMutableDictionary * app_history = nil;

NSString * getHistoryFilePath()
{
    NSString * account = [QWUserDefault getStringBy:APP_USERNAME_KEY];
    if (account == nil) {
        account = @"anonymous";
    }
    NSString * historyPath = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),account];

    NSString * historyFile = [NSString stringWithFormat:@"%@/history.plist",historyPath];

    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:historyPath]) {
        [fileManager createDirectoryAtPath:historyPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (![fileManager fileExistsAtPath:historyFile]) {
        app_history = [[NSMutableDictionary alloc] init];
        [app_history writeToFile:historyFile atomically:YES];
    }else {
        app_history = [[NSMutableDictionary alloc] initWithContentsOfFile:historyFile];
        
    }
    if (!app_history) {
        app_history = [[NSMutableDictionary alloc] initWithContentsOfFile:historyFile];
    }
    return historyFile;
}

void setHistoryConfig(NSString * key , id value)
{
    NSString * historyFile = getHistoryFilePath();
    if (value) {
        app_history[key] = value;
    }else {
        [app_history removeObjectForKey:key];
    }
    [app_history writeToFile:historyFile atomically:YES];
}

id getHistoryConfig(NSString *key){
    getHistoryFilePath();
    return app_history[key];
}


