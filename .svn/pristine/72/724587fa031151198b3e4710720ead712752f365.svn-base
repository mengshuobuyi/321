//
//  MessageModel.m
//  APP
//
//  Created by carret on 15/5/21.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "MessageModel.h"
#import "UIImage+Ex.h"
#import "SDImageCache.h"
#import "SDWebImageDownloader.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Ex.h"
@implementation MessageCreate

@end

@implementation MessageModel

- (instancetype)initWithText:(NSString *)text
                      sender:(NSString *)sender
                   timestamp:(NSDate *)timestamp
                        UUID:(NSString *)messageUUID
{
    self = [super init];
    if (self) {
        self.text = text;
        self.isMarked = YES;
        self.sender = sender;
        self.timestamp = timestamp;
        self.UUID = messageUUID;
        self.messageMediaType = MessageMediaTypeText;
    }
    return self;
}

- (instancetype)initWithAutoSubscription:(NSString *)text
                                  sender:(NSString *)sender
                               timestamp:(NSDate *)timestamp
                                    UUID:(NSString *)messageUUID
                                 tagList:(NSArray *)tagList
{
    self = [super init];
    if (self) {
        self.text = text;
        self.isMarked = YES;
        self.sender = sender;
        self.timestamp = timestamp;
        self.UUID = messageUUID;
        self.messageMediaType = MessageMediaTypeAutoSubscription;
        self.tagList = tagList;
    }
    return self;
}

- (instancetype)initWithPurchaseMedicine:(NSString *)text
                                  sender:(NSString *)sender
                               timestamp:(NSDate *)timestamp
                                    UUID:(NSString *)messageUUID
                                 tagList:(NSArray *)tagList
                                   title:(NSString *)title
                                subTitle:(NSString *)subTitle
                                 fromTag:(NSInteger)fromTag;
{
    self = [super init];
    if (self) {
        self.text = text;
        self.isMarked = YES;
        self.sender = sender;
        self.timestamp = timestamp;
        self.UUID = messageUUID;
        self.title = title;
        self.fromTag = fromTag;
        self.subTitle = subTitle;
        self.messageMediaType = MessageMediaTypePurchaseMedicine;
        self.tagList = tagList;
    }
    return self;
}

- (instancetype)initWithLocation:(NSString *)text
                        latitude:(NSString *)latitude
                       longitude:(NSString *)longitude
                          sender:(NSString *)sender
                       timestamp:(NSDate *)timestamp
                            UUID:(NSString *)messageUUID
{
    self.text = text;
    self.location = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
    self.latitude = latitude;
    self.longitude = longitude;
    self.sender = sender;
    self.timestamp = timestamp;
    _UUID = messageUUID;
    self.messageMediaType = MessageMediaTypeLocation;
    return self;
}



- (instancetype)initWithDrugGuide:(NSString *)text
                            title:(NSString *)title
                           sender:(NSString *)sender
                        timestamp:(NSDate *)timestamp
                             UUID:(NSString *)messageUUID
                          tagList:(NSArray *)tagList
                         subTitle:(NSString *)subTitle
                          fromTag:(NSInteger)fromTag
{
    self = [super init];
    if (self) {
        self.text = text;
        self.isMarked = YES;
        self.title = title;
        self.sender = sender;
        self.timestamp = timestamp;
        self.UUID = messageUUID;
        self.subTitle= subTitle;
        self.fromTag = fromTag;
        self.messageMediaType = MessageMediaTypeDrugGuide;
        self.tagList = tagList;
    }
    return self;
}
- (instancetype)initWithSpreadHint:(NSString *)text
                             title:(NSString *)title
                            sender:(NSString *)sender
                         timestamp:(NSDate *)timestamp
                              UUID:(NSString *)messageUUID
                           tagList:(NSArray *)tagList
                           fromTag:(NSUInteger )fromTag
{
    self = [super init];
    if (self) {
        self.text = text;
        self.isMarked = YES;
        self.title = title;
        self.sender = sender;
        self.timestamp = timestamp;
        self.UUID = messageUUID;
        self.messageMediaType = MessageMediaTypeSpreadHint;
        self.tagList = tagList;
        self.fromTag = fromTag;
    }
    return self;
}
- (instancetype)initInviteEvaluate:(NSString *)text
                            sender:(NSString *)sender
                         timestamp:(NSDate *)timestamp
                              UUID:(NSString *)messageUUID
{
    self = [super init];
    if (self) {
        self.text = text;
        self.sender = sender;
        self.timestamp = timestamp;
        _UUID = messageUUID;
        self.messageMediaType = MessageMediaTypeStarStore;
    }
    return self;
}

- (instancetype)initEvaluate:(CGFloat)star
                        text:(NSString *)text
                      sender:(NSString *)sender
                   timestamp:(NSDate *)timestamp
                        UUID:(NSString *)messageUUID
{
    self = [super init];
    if (self) {
        self.text = text;
        self.isMarked = YES;
        self.starMark = star;
        self.sender = sender;
        self.timestamp = timestamp;
        _UUID = messageUUID;
        self.messageMediaType = MessageMediaTypeStarClient;
    }
    return self;
}

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
                    timestamp:(NSDate *)timestamp {
    self = [super init];
    if (self) {
        self.photo = photo;
        self.thumbnailUrl = thumbnailUrl;
        self.originPhotoUrl = originPhotoUrl;
        
        self.sender = sender;
        self.timestamp = timestamp;
        
        self.messageMediaType = MessageMediaTypePhoto;
    }
    return self;
}

- (instancetype)initWithHeader:(NSString *)text timestamp:(NSDate *)timestamp UUID:(NSString *)messageUUID
{
    self = [super init];
    if (self) {
        self.text = text;
        self.timestamp = timestamp;
        self.UUID = messageUUID;
        self.messageMediaType = MessageMediaTypeHeader;
        
    }
    return self;
}

- (instancetype)initWithLine:(NSString *)text timestamp:(NSDate *)timestamp UUID:(NSString *)messageUUID
{
    self = [super init];
    if (self) {
        self.text = text;
        self.UUID = messageUUID;
        self.timestamp = timestamp;
        self.messageMediaType = MessageMediaTypeLine;
    }
    return self;
}


- (instancetype)initWithSpecialOffersShowOnce:(NSString *)text
                                      content:(NSString *)content
                                  activityUrl:(NSString *)activityUrl
                                   activityId:(NSString *)activityId
                                       sender:(NSString *)sender
                                    timestamp:(NSDate *)timestamp
                                         UUID:(NSString *)messageUUID
{
    self = [super init];
    if (self) {
        self.text = content;
        self.activityUrl = activityUrl;
        self.title = text;
        self.isMarked = YES;
        self.richBody = activityId;
        self.sender = sender;
        self.timestamp = timestamp;
        self.UUID = messageUUID;
        self.messageMediaType = MessageMediaTypeMedicineSpecialOffersShowOnce;
    }
    return self;
}

- (instancetype)initWithMedicineShowOnce:(NSString *)text
                               productId:(NSString *)productId
                                imageUrl:(NSString *)imageUrl
                                  sender:(NSString *)sender
                               timestamp:(NSDate *)timestamp
                                    UUID:(NSString *)messageUUID
{
    self = [super init];
    if (self) {
        self.text = text;
        self.isMarked = YES;
        self.richBody = productId;
        self.activityUrl = imageUrl;
        self.sender = sender;
        self.timestamp = timestamp;
        self.UUID = messageUUID;
        self.messageMediaType = MessageMediaTypeMedicineShowOnce;
    }
    return self;
}






- (instancetype)initWithPhone:(NSString *)text timestamp:(NSDate *)timestamp UUID:(NSString *)messageUUID
{
    self = [super init];
    if (self) {
        self.text = text;
        self.UUID = messageUUID;
        self.timestamp = timestamp;
        self.messageMediaType = MessageMediaTypePhone;
    }
    return self;
}

- (instancetype)initWithFooter:(NSString *)text timestamp:(NSDate *)timestamp UUID:(NSString *)messageUUID
{
    self = [super init];
    if (self) {
        self.text = text;
        self.UUID = messageUUID;
        self.timestamp = timestamp;
        self.messageMediaType = MessageMediaTypeFooter;
    }
    return self;
}



//-----------



- (instancetype)initWithPhoto:(UIImage *)photo
                 thumbnailUrl:(NSString *)thumbnailUrl
               originPhotoUrl:(NSString *)originPhotoUrl
                       sender:(NSString *)sender
                    timestamp:(NSDate *)timestamp
                         UUID:(NSString *)messageUUID
                     richBody:(NSString *)richbody
{
    self = [super init];
    if (self) {
        if (!photo) {
//            NSData *dat = [NSData dataWithContentsOfURL:[NSURL URLWithString: thumbnailUrl]];
//            self.photo  = [UIImage imageWithData:dat];
//            if (!self.photo) {
//                self.photo=    [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:messageUUID];
//            }
//            self.photo = [UIImage imageWithData:dat];
            
            if ([[SDImageCache sharedImageCache] diskImageExistsWithKey:messageUUID]) {
                UIImage *image=[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:messageUUID];
//                image=[UIImage scaleImage:image toScale:0.25];
                self.photo = image;// [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:messageUUID];
//                DebugLog(@"SSSSSSSSSSSSSSS %@",NSStringFromCGSize(self.photo.size));
            }
//            else
//            {
//                UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
////                self.photo = [UIImage imageNamed: @"image_waiting2"];
//                [imgView setImageWithURL:[NSURL URLWithString:originPhotoUrl] placeholderImage:[UIImage imageNamed: @"image_waiting2"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
////                    image = [image resizedImage:image.size interpolationQuality:1.0];
//                    if (image) {
//                        
////                        [[SDImageCache sharedImageCache] storeImage:image forKey:messageUUID];
//                        image=[UIImage scaleImage:image toScale:0.25];
//                        self.photo = image;
////                        [GLOBALMANAGER postNotif:NotimessageIMTabelUpdate data:nil object:nil];
//                    }
//                }];
//            }
        }else
        {
            UIImage *preViewImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:[NSString stringWithFormat:@"PreView_%@",messageUUID]];
            if(!preViewImage) {
                preViewImage = [photo imageByScalingToPreView];
                [[SDImageCache sharedImageCache] storeImage:preViewImage forKey:[NSString stringWithFormat:@"PreView_%@",messageUUID] toDisk:NO];
            }
            self.photo = preViewImage;
        }

        
        self.thumbnailUrl = thumbnailUrl;
        self.originPhotoUrl = originPhotoUrl;
        _UUID = messageUUID;
        self.sender = sender;
        self.timestamp = timestamp;
        self.richBody = thumbnailUrl;
        self.messageMediaType = MessageMediaTypePhoto;
    }
    return self;
}

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

- (instancetype)initMarketActivity:(NSString *)title
                            sender:(NSString *)sender
                          imageUrl:(NSString *)imageUrl
                           content:(NSString *)content
                           comment:(NSString *)comment
                          richBody:(NSString *)richbody
                         timestamp:(NSDate *)timestamp
                              UUID:(NSString *)messageUUID

{
    self = [super init];
    if (self) {
        self.isMarked = YES;
        self.title = title;
        self.activityUrl = imageUrl;
        self.text = content;
        self.sender = sender;
        self.timestamp = timestamp;
        _UUID = messageUUID;
        self.richBody = richbody;
        self.messageMediaType = MessageMediaTypeActivity;
    }
    return self;
}

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
                             UUID:(NSString *)messageUUID
{
    self = [super init];
    if (self) {
        self.voicePath = voicePath;
        self.voiceUrl = voiceUrl;
        self.voiceDuration = voiceDuration;
        self.hadDownloaded = YES;
        self.sender = sender;
        self.timestamp = timestamp;
        self.messageMediaType = MessageMediaTypeVoice;
        _UUID = messageUUID;
    }
    return self;
}





- (instancetype)initWithEmotionPath:(NSString *)emotionPath
                             sender:(NSString *)sender
                          timestamp:(NSDate *)timestamp {
    self = [super init];
    if (self) {
        self.emotionPath = emotionPath;
        
        self.sender = sender;
        self.timestamp = timestamp;
        
        self.messageMediaType = MessageMediaTypeEmotion;
    }
    return self;
}

- (instancetype)initWithLocalPositionPhoto:(UIImage *)localPositionPhoto
                              geolocations:(NSString *)geolocations
                                  location:(CLLocation *)location
                                    sender:(NSString *)sender
                                 timestamp:(NSDate *)timestamp {
    self = [super init];
    if (self) {
        self.localPositionPhoto = localPositionPhoto;
        self.geolocations = geolocations;
        self.location = location;
        
        self.sender = sender;
        self.timestamp = timestamp;
        
        self.messageMediaType = MessageMediaTypeLocalPosition;
    }
    return self;
}

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
                                 UUID:(NSString *)messageUUID
{
    self = [super init];
    if (self) {
        self.text = content;
        self.activityUrl = activityUrl;
        self.title = text;
        self.richBody = activityId;
        self.isMarked = YES;
        
        self.sender = sender;
        self.timestamp = timestamp;
        self.UUID = messageUUID;
        self.messageMediaType = MessageMediaTypeMedicineSpecialOffers;
        self.thumbnailUrl = branchLogo;//QWGLOBALMANAGER.configure.avatarUrl;
        self.otherID=groupId;
    }
    return self;
}

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
                          UUID:(NSString *)messageUUID
{
    self = [super init];
    if (self) {
        
        self.title = groupID;
        self.subTitle = couponName;
        self.text = couponTag;
        self.richBody = couponValue;
        self.style = scope;
        self.otherID = couponId;
        self.thumbnailUrl=imgUrl;
        self.sender = sender;
        self.timestamp = timestamp;
        self.UUID = messageUUID;
        self.messageMediaType = MessageMediaTypeCoupon;
        
        self.isMarked=top?YES:NO;
        
        self.arrList=[[NSMutableArray alloc]initWithCapacity:2];
        if (begin && end) {
            [self.arrList addObject:begin];
            [self.arrList addObject:end];
        }
    }
    return self;
}

//优惠商品
- (instancetype)initWithMedicineCoupon:(NSString *)name
                             productId:(NSString *)productId
                              imageUrl:(NSString *)imageUrl
                              pmtLable:(NSString *)pmtLable
                                 pmtID:(NSString *)pmtID
                                sender:(NSString *)sender
                             timestamp:(NSDate *)timestamp
                                  UUID:(NSString *)messageUUID
{
    self = [super init];
    if ([self initWithMedicine:name productId:productId imageUrl:imageUrl sender:sender timestamp:timestamp UUID:messageUUID]) {
        self.subTitle = pmtLable;
        self.otherID = pmtID;
        self.messageMediaType =MessageMediaTypeMedicineCoupon;
    }
    return self;
}

//普通药品
- (instancetype)initWithMedicine:(NSString *)text
                       productId:(NSString *)productId
                        imageUrl:(NSString *)imageUrl
                          sender:(NSString *)sender
                       timestamp:(NSDate *)timestamp
                            UUID:(NSString *)messageUUID
{
    self = [super init];
    if (self) {
        self.text = text;
        self.isMarked = YES;
        self.richBody = productId;
        self.activityUrl = imageUrl;
        self.sender = sender;
        self.timestamp = timestamp;
        self.UUID = messageUUID;
        self.messageMediaType = MessageMediaTypeMedicine;
    }
    return self;
}

//本店药品
- (instancetype)initWithStoreMedicine:(NSString *)text
                            productId:(NSString *)productId
                             imageUrl:(NSString *)imageUrl
                                 spec:(NSString *)spec
                             branchId:(NSString *)branchId
                          branchProId:(NSString *)branchProId
                               sender:(NSString *)sender
                            timestamp:(NSDate *)timestamp
                                 UUID:(NSString *)messageUUID
{
    self = [super init];
    if (self) {
        self.text = text;
        self.isMarked = YES;
        self.richBody = productId;
        self.activityUrl = imageUrl;
        
        self.spec = spec;
        self.branchId = branchId;
        self.branchProId = branchProId;
        
        self.sender = sender;
        self.timestamp = timestamp;
        self.UUID = messageUUID;
        self.messageMediaType = MessageMediaTypeStoreMedicine;
    }
    return self;
}

// end yqy

- (void)dealloc {
    _text = nil;
    
    _photo = nil;
    _thumbnailUrl = nil;
    _originPhotoUrl = nil;
    
    _videoConverPhoto = nil;
    _videoPath = nil;
    _videoUrl = nil;
    
    _voicePath = nil;
    _voiceUrl = nil;
    _voiceDuration = nil;
    
    _emotionPath = nil;
    
    _localPositionPhoto = nil;
    _geolocations = nil;
    _location = nil;
    
    _avator = nil;
    _avatorUrl = nil;
    
    _sender = nil;
    
    _timestamp = nil;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _text = [aDecoder decodeObjectForKey:@"text"];
        
        _photo = [aDecoder decodeObjectForKey:@"photo"];
        _thumbnailUrl = [aDecoder decodeObjectForKey:@"thumbnailUrl"];
        _originPhotoUrl = [aDecoder decodeObjectForKey:@"originPhotoUrl"];
        
        _videoConverPhoto = [aDecoder decodeObjectForKey:@"videoConverPhoto"];
        _videoPath = [aDecoder decodeObjectForKey:@"videoPath"];
        _videoUrl = [aDecoder decodeObjectForKey:@"videoUrl"];
        
        _voicePath = [aDecoder decodeObjectForKey:@"voicePath"];
        _voiceUrl = [aDecoder decodeObjectForKey:@"voiceUrl"];
        _voiceDuration = [aDecoder decodeObjectForKey:@"voiceDuration"];
        
        _emotionPath = [aDecoder decodeObjectForKey:@"emotionPath"];
        
        _localPositionPhoto = [aDecoder decodeObjectForKey:@"localPositionPhoto"];
        _geolocations = [aDecoder decodeObjectForKey:@"geolocations"];
        _location = [aDecoder decodeObjectForKey:@"location"];
        
        _avator = [aDecoder decodeObjectForKey:@"avator"];
        _avatorUrl = [aDecoder decodeObjectForKey:@"avatorUrl"];
        
        _sender = [aDecoder decodeObjectForKey:@"sender"];
        _timestamp = [aDecoder decodeObjectForKey:@"timestamp"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.text forKey:@"text"];
    
    [aCoder encodeObject:self.photo forKey:@"photo"];
    [aCoder encodeObject:self.thumbnailUrl forKey:@"thumbnailUrl"];
    [aCoder encodeObject:self.originPhotoUrl forKey:@"originPhotoUrl"];
    
    [aCoder encodeObject:self.videoConverPhoto forKey:@"videoConverPhoto"];
    [aCoder encodeObject:self.videoPath forKey:@"videoPath"];
    [aCoder encodeObject:self.videoUrl forKey:@"videoUrl"];
    
    [aCoder encodeObject:self.voicePath forKey:@"voicePath"];
    [aCoder encodeObject:self.voiceUrl forKey:@"voiceUrl"];
    [aCoder encodeObject:self.voiceDuration forKey:@"voiceDuration"];
    
    [aCoder encodeObject:self.emotionPath forKey:@"emotionPath"];
    
    [aCoder encodeObject:self.localPositionPhoto forKey:@"localPositionPhoto"];
    [aCoder encodeObject:self.geolocations forKey:@"geolocations"];
    [aCoder encodeObject:self.location forKey:@"location"];
    
    [aCoder encodeObject:self.sender forKey:@"sender"];
    [aCoder encodeObject:self.timestamp forKey:@"timestamp"];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    switch (self.messageMediaType) {
        case MessageMediaTypeText:
            return [[[self class] allocWithZone:zone] initWithText:[self.text copy]
                                                            sender:[self.sender copy]
                                                         timestamp:[self.timestamp copy] UUID:[self.UUID copy]];
        case MessageMediaTypePhoto:
            return [[[self class] allocWithZone:zone] initWithPhoto:[self.photo copy]
                                                       thumbnailUrl:[self.thumbnailUrl copy]
                                                     originPhotoUrl:[self.originPhotoUrl copy]
                                                             sender:[self.sender copy]
                                                          timestamp:[self.timestamp copy]
                                                               UUID:[self.UUID copy]
                                                           richBody:@"[图片]"];
        case MessageMediaTypeEmotion:
            return [[[self class] allocWithZone:zone] initWithEmotionPath:[self.emotionPath copy]
                                                                   sender:[self.sender copy]
                                                                timestamp:[self.timestamp copy]];
        case MessageMediaTypeLocalPosition:
            return [[[self class] allocWithZone:zone] initWithLocalPositionPhoto:[self.localPositionPhoto copy]
                                                                    geolocations:self.geolocations
                                                                        location:[self.location copy]
                                                                          sender:[self.sender copy]
                                                                       timestamp:[self.timestamp copy]];
        default:
            return nil;
    }
}


@end
