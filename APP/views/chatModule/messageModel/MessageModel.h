//
//  MessageModel.h
//  APP
//
//  Created by carret on 15/5/21.
//  Copyright (c) 2015年 carret. All rights reserved.
//
#import "ChatManagerDefs.h"
#import <Foundation/Foundation.h>
//#import "MessageModelProtocol.h"
#import <CoreLocation/CoreLocation.h>


@interface MessageCreate : BaseModel
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *sessionId;
@property (nonatomic, strong) NSString *consultId;
@property (nonatomic, strong) NSString *contentType;
@property (nonatomic, strong) NSString *contentJson;
@property (nonatomic, strong) NSString *UUID;
@end

@interface MessageModel : NSObject < NSCoding, NSCopying>

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, copy) NSString *thumbnailUrl;
@property (nonatomic, copy) NSString *originPhotoUrl;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSString      *activityUrl;
@property (nonatomic, strong) UIImage *videoConverPhoto;
@property (nonatomic, copy) NSString *videoPath;
@property (nonatomic, copy) NSString *videoUrl;

@property (nonatomic, copy) NSString *voicePath;
@property (nonatomic, copy) NSString *voiceUrl;
@property (nonatomic, copy) NSString *voiceDuration;

@property (nonatomic, copy) NSString *emotionPath;

@property (nonatomic, strong) UIImage *localPositionPhoto;
@property (nonatomic, copy) NSString *geolocations;
@property (nonatomic, strong) CLLocation *location;

@property (nonatomic, strong) UIImage *avator;
@property (nonatomic, copy) NSString *avatorUrl;

@property (nonatomic, copy) NSString *sender;
@property (nonatomic, strong) NSString *richBody;
@property (nonatomic, strong) NSDate *timestamp;

@property (nonatomic, assign) MessageDeliveryState sended;
@property (nonatomic, strong) NSString *UUID;
@property (nonatomic, assign) CGFloat  starMark;
@property (nonatomic, assign) BOOL      officialType;
@property (nonatomic, assign) BOOL      isMarked;

@property (nonatomic, assign) MessageBodyType messageMediaType;
@property (nonatomic, strong) NSArray               *tagList;
@property (nonatomic, assign) MessageDeliveryType messageDeliveryType;
@property (nonatomic, assign) NSUInteger fromTag;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *otherID; //通用商品id
@property (nonatomic, copy) NSString *style; //通用int值
@property (nonatomic, strong) NSMutableArray               *arrList;//通用数组
@property (nonatomic, assign) BOOL   audioPlaying;
@property (nonatomic,copy)NSString *latitude;
@property (nonatomic,copy)NSString *longitude;

@property (nonatomic, assign) BOOL hadDownloaded;
@property (nonatomic, strong)UIImageView *imgView;
@property (nonatomic, assign) MessageFileState download;

@property (nonatomic,strong) NSString *spec;
@property (nonatomic,strong) NSString *branchId;
@property (nonatomic,strong) NSString *branchProId;


/**
 *  初始化文本消息
 *
 *  @param text   发送的目标文本
 *  @param sender 发送者的名称
 *  @param date   发送的时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithText:(NSString *)text
                      sender:(NSString *)sender
                   timestamp:(NSDate *)timestamp
                        UUID:(NSString *)messageUUID;

- (instancetype)initWithAutoSubscription:(NSString *)text
                                  sender:(NSString *)sender
                               timestamp:(NSDate *)timestamp
                                    UUID:(NSString *)messageUUID
                                 tagList:(NSArray *)tagList;

- (instancetype)initWithLocation:(NSString *)text
                        latitude:(NSString *)latitude
                       longitude:(NSString *)longitude
                          sender:(NSString *)sender
                       timestamp:(NSDate *)timestamp
                            UUID:(NSString *)messageUUID;

- (instancetype)initWithDrugGuide:(NSString *)text
                            title:(NSString *)title
                           sender:(NSString *)sender
                        timestamp:(NSDate *)timestamp
                             UUID:(NSString *)messageUUID
                          tagList:(NSArray *)tagList
                         subTitle:(NSString *)subTitle
                          fromTag:(NSInteger)fromTag;

- (instancetype)initWithPurchaseMedicine:(NSString *)text
                                  sender:(NSString *)sender
                               timestamp:(NSDate *)timestamp
                                    UUID:(NSString *)messageUUID
                                 tagList:(NSArray *)tagList
                                   title:(NSString *)title
                                subTitle:(NSString *)subTitle
                                 fromTag:(NSInteger)fromTag;

- (instancetype)initInviteEvaluate:(NSString *)text
                            sender:(NSString *)sender
                         timestamp:(NSDate *)timestamp
                              UUID:(NSString *)messageUUID;

- (instancetype)initEvaluate:(CGFloat)star
                        text:(NSString *)text
                      sender:(NSString *)sender
                   timestamp:(NSDate *)timestamp
                        UUID:(NSString *)messageUUID;
/**
 *  初始化图片类型的消息
 *
 *  @param photo          目标图片
 *  @param thumbnailUrl   目标图片在服务器的缩略图地址
 *  @param originPhotoUrl 目标图片在服务器的原图地址
 *  @param sender         发送者
 *  @param date           发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithPhoto:(UIImage *)photo
                 thumbnailUrl:(NSString *)thumbnailUrl
               originPhotoUrl:(NSString *)originPhotoUrl
                       sender:(NSString *)sender
                    timestamp:(NSDate *)timestamp
                         UUID:(NSString *)messageUUID
                     richBody:(NSString *)richbody;;

/**
 *  初始化视频类型的消息
 *
 *  @param videoConverPhoto 目标视频的封面图
 *  @param videoPath        目标视频的本地路径，如果是下载过，或者是从本地发送的时候，会存在
 *  @param videoUrl         目标视频在服务器上的地址
 *  @param sender           发送者
 *  @param date             发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithVideoConverPhoto:(UIImage *)videoConverPhoto
                               videoPath:(NSString *)videoPath
                                videoUrl:(NSString *)videoUrl
                                  sender:(NSString *)sender
                               timestamp:(NSDate *)timestamp;

- (instancetype)initMarketActivity:(NSString *)title
                            sender:(NSString *)sender
                          imageUrl:(NSString *)imageUrl
                           content:(NSString *)content
                           comment:(NSString *)comment
                          richBody:(NSString *)richbody
                         timestamp:(NSDate *)timestamp
                              UUID:(NSString *)messageUUID;

/**
 *  初始化语音类型的消息
 *
 *  @param voicePath        目标语音的本地路径
 *  @param voiceUrl         目标语音在服务器的地址
 *  @param voiceDuration    目标语音的时长
 *  @param sender           发送者
 *  @param date             发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithVoicePath:(NSString *)voicePath
                         voiceUrl:(NSString *)voiceUrl
                    voiceDuration:(NSString *)voiceDuration
                           sender:(NSString *)sender
                        timestamp:(NSDate *)timestamp
                             UUID:(NSString *)messageUUID;

/**
 *  初始化gif表情类型的消息
 *
 *  @param emotionPath 表情的路径
 *  @param sender      发送者
 *  @param timestamp   发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithEmotionPath:(NSString *)emotionPath
                             sender:(NSString *)sender
                          timestamp:(NSDate *)timestamp;

/**
 *  初始化地理位置的消息
 *
 *  @param localPositionPhoto 地理位置默认显示的图
 *  @param geolocations       地理位置的信息
 *  @param location           地理位置的经纬度
 *  @param sender             发送者
 *  @param timestamp          发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithLocalPositionPhoto:(UIImage *)localPositionPhoto
                              geolocations:(NSString *)geolocations
                                  location:(CLLocation *)location
                                    sender:(NSString *)sender
                                 timestamp:(NSDate *)timestamp;


- (instancetype)initWithSpreadHint:(NSString *)text
                             title:(NSString *)title
                            sender:(NSString *)sender
                         timestamp:(NSDate *)timestamp
                              UUID:(NSString *)messageUUID
                           tagList:(NSArray *)tagList
                           fromTag:(NSUInteger )fromTag;

- (instancetype)initWithPhone:(NSString *)text timestamp:(NSDate *)timestamp UUID:(NSString *)messageUUID;

- (instancetype)initWithHeader:(NSString *)text timestamp:(NSDate *)timestamp UUID:(NSString *)messageUUID;


- (instancetype)initWithLine:(NSString *)text timestamp:(NSDate *)timestamp UUID:(NSString *)messageUUID;

- (instancetype)initWithFooter:(NSString *)text timestamp:(NSDate *)timestamp UUID:(NSString *)messageUUID;

- (instancetype)initWithMedicine:(NSString *)text
                       productId:(NSString *)productId
                        imageUrl:(NSString *)imageUrl
                          sender:(NSString *)sender
                       timestamp:(NSDate *)timestamp
                            UUID:(NSString *)messageUUID;

- (instancetype)initWithStoreMedicine:(NSString *)text
                            productId:(NSString *)productId
                             imageUrl:(NSString *)imageUrl
                                 spec:(NSString *)spec
                             branchId:(NSString *)branchId
                          branchProId:(NSString *)branchProId
                               sender:(NSString *)sender
                            timestamp:(NSDate *)timestamp
                                 UUID:(NSString *)messageUUID;

- (instancetype)initWithMedicineShowOnce:(NSString *)text
                               productId:(NSString *)productId
                                imageUrl:(NSString *)imageUrl
                                  sender:(NSString *)sender
                               timestamp:(NSDate *)timestamp
                                    UUID:(NSString *)messageUUID;

- (instancetype)initWithSpecialOffersShowOnce:(NSString *)text
                                      content:(NSString *)content
                                  activityUrl:(NSString *)activityUrl
                                   activityId:(NSString *)activityId
                                       sender:(NSString *)sender
                                    timestamp:(NSDate *)timestamp
                                         UUID:(NSString *)messageUUID;
// modify yqy
//优惠活动
- (instancetype)initWithSpecialOffers:(NSString *)text
                              content:(NSString *)content
                          activityUrl:(NSString *)activityUrl
                           activityId:(NSString *)activityId
                              groupId:(NSString *)groupId
                           branchLogo:(NSString *)branchLogo
                               sender:(NSString *)sender
                            timestamp:(NSDate *)timestamp
                                 UUID:(NSString *)messageUUID;

//优惠商品
- (instancetype)initWithMedicineCoupon:(NSString *)name
                             productId:(NSString *)productId
                              imageUrl:(NSString *)imageUrl
                              pmtLable:(NSString *)pmtLable
                                 pmtID:(NSString *)pmtID
                                sender:(NSString *)sender
                             timestamp:(NSDate *)timestamp
                                  UUID:(NSString *)messageUUID;

//优惠券
- (instancetype)initWithCoupon:(NSString *)groupID
                    couponName:(NSString *)couponName
                   couponValue:(NSString *)couponValue
                     couponTag:(NSString *)couponTag
                      couponId:(NSString *)couponId
                         begin:(NSString *)begin
                           end:(NSString *)end
                         scope:(NSString *)scope
                           top:(NSInteger)top
                           imgUrl:(NSString *)imgUrl
                        sender:(NSString *)sender
                     timestamp:(NSDate *)timestamp
                          UUID:(NSString *)messageUUID;

@end
