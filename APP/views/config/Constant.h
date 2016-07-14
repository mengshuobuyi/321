/*!
 @header Constant.h
 @abstract 记录所有的常量
 @author .
 @version 1.00 2015/03/06  (1.00)
 */


//  https://www.flinto.com/p/65f3c28f  //产品Web原型图
//  m.myquanwei.com/                   //web版本的参考app
//测试账号  手机号18675535684，密码：123456  9a960552303f3306800aa95ee6bf0a19
//uta环境测试账号13861318715   840319
//sit环境下           13915531876  111111
//jira

/*
 xmppserver   im.qw.com
 webapi  http://m.api.qw.com
 */



#ifndef quanzhi_Constant_h
#define quanzhi_Constant_h

//delegate
#define APPDelegate     ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define kTablePageSize  @"32"


#define appTalkingDataID                @"208A83C6BB7B920775F38D3741F40438"
#define appZhugeID                      @"1e176ddcacf44dc18e4b55a6381814d1"
#define CIRCLE_DETAIL_BYSEND            [[QWUserDefault getObjectBy:@"sendPostToCircleDetail"] isEqualToString:@"OK"]
#define DELETE_POSTTOPIC_SUCCESS        [[QWUserDefault getObjectBy:@"deletePostTopicSuccess"] isEqualToString:@"OK"]

#define IS_EXPERT_ENTRANCE              [[QWUserDefault getObjectBy:@"ENTRANCETYPE"] isEqualToString:@"2"]
#define AUTHORITY_ROOT                  [QWGLOBALMANAGER.configure.type isEqualToString:@"2"]
#define OrganAuthPass                   [QWGLOBALMANAGER.configure.approveStatus isEqualToString:@"3"]  // 审核通过，功能正常
#define APP_VOICE_NOTIFICATION          @"APP_VOICE_NOTIFICATION"                               //新消息提醒声音
#define APP_VIBRATION_NOTIFICATION      @"APP_VIBRATION_NOTIFICATION"                           //新消息提醒震动
#define APP_QUESTIONPUSH_NOTIFICATION   @"APP_QUESTIONPUSH_NOTIFICATION"                        //新问题消息推送

#define APP_RECEIVE_INBACKGROUND        @"APP_RECEIVE_INBACKGROUND"
#define ALARM_VOICE_NOTIFICATION        @"ALARM_VOICE_NOTIFICATION"
#define ALARM_VIBRATION_NOTIFICATION    @"ALARM_VIBRATION_NOTIFICATION"
#define APP_ALARM_NATIONWIDE            @"APP_ALARM_NATIONWIDE"
#define KICK_OFF                        @"KICK_OFF"
#define isHiddenRacingRedPoint          @"isHiddenRacingRedPoint"
#define isReadIntroduction              @"isReadIntroduction"
#define SERVER_TIME                     @"SERVER_TIME"
#define AES_KEY                         @"Ao6IFeRFTsXuaD681snWCk"
//机构执照的固定字符串
#define kIMG         @"IMG"         //图片
#define kNO          @"NO"          //证件编号
#define kHOLDER      @"HOLDER"      //拥有者
#define kDATE        @"DATE"        //有效期

#define NW_favoriteProductCollectList    @"favorite/queryProductCollectList"

//分页请求服务器,每页10个
#define PAGE_ROW_NUM                       10

#define DATE_FORMAT            @"yyyy-MM-dd"
#define TIME_FORMAT            @"HH:mm:ss"
#define DATE_TIME_FORMAT       @"yyyy-MM-dd HH:mm:ss"
//Method
#define NoNullStr(x)        (  ( x && (![x isEqual:[NSNull null]]) ) ? x : @"" )
//panadd end
/*****************************************************************************************************/

#define SeparateStr             @"_#QZSP#_"

#define QueryKey               @"queryDict" //这个是我的机构查询状态的字典key add by meng

//#define AMAP_KEY                    @"ff68e7dd86fe8d8220ac0129b19585aa"     //高德地图key,企业版的
#define AMAP_KEY               @"031aaebce6d5d91c26abbd9cf0726fd4"     //高德地图key,老版本的

#define APP_SELECT_INDEX_DISEASE    @"APP_SELECT_INDEX_DISEASE"


#define DRUG_GUIDE_1_UPDATE     @"DRUG_GUIDE_1_UPDATE"
#define DRUG_GUIDE_2_UPDATE     @"DRUG_GUIDE_2_UPDATE"
#define IMG_VIEW(x)         [[UIImageView alloc] initWithImage:[UIImage imageNamed:x]]

#define BTN_NEW     512
#define BTN_EDIT    1024

#define AttributedImageNameKey      @"ImageName"
#define EmotionItemPattern          @"\\[\\w{2}\\]"
#define PlaceHolder                 @"[0|]"
#define kHyperlinkKey               @"khyperlinkkey"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

/**
 弹框时间
 */
#define DURATION_SHORT                0.8f
#define DURATION_LONG                 1.5f

#define WRITE_RESOURCES @"/write-resources"
#define OFFLINE_RESOURCES @"/offline-resources"
#define PLUG_IN_RESOURCES @"/plug-in-resources"

#define DEFAULT_LONGITUDE               120.730435
#define DEFAULT_LATITUDE                31.273391
#define DEFAULT_CITY               @"苏州市"
#define DEFAULT_PROVINCE                @"江苏省"

//告诉服务器 我是ios设备
#define IOS_DEVICE                  @"2"

#define kEvaluate_History_Plist_Name         @"evaluateHistory_2_1.plist"

#define APP_SEARCH_ACTIVITY_KEY             @"com.quanwei.store"
#define APP_SEARCH_ACTIVITY_HEALTHQA        @"1"

//聊天的消息类型
typedef enum messageType
{
    TextMessage = 1,
    ImageMessage,
    AudioMessage,
    VideoMessage,
    LocationMessage,
    FileMessage,
    SystemMessage = 1000
}MessageType;

typedef NS_ENUM(NSInteger, MessageShowType) {
    MessageShowTypeP2PAsking,
    MessageShowTypeAsking,
    MessageShowTypeAnswer,
    MessageShowTypeClose
};

#endif


