//
//  Circle.h
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/8.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"

@interface Circle : NSObject

/**
 *    圈子热议
 *
 */
+ (void)TeamGetTeamHotInfoWithParams:(NSDictionary *)param
                             success:(void(^)(id obj))success
                             failure:(void(^)(HttpException * e))failure;

/**
 *    圈子详细信息
 *
 */
+ (void)TeamGetTeamDetailsInfoWithParams:(NSDictionary *)param
                                 success:(void(^)(id obj))success
                                 failure:(void(^)(HttpException * e))failure;

/**
 *    圈子详细信息 帖子列表
 *
 */
+ (void)TeamGetPostListInfoByTeamIdWithParams:(NSDictionary *)param
                                      success:(void(^)(id obj))success
                                      failure:(void(^)(HttpException * e))failure;

/**
 *    查看圈主列表
 *
 */
+ (void)teamGetMbrInfoListByTeamIdWithParams:(NSDictionary *)param
                                     success:(void(^)(id obj))success
                                     failure:(void(^)(HttpException * e))failure;

/**
 *    申请做圈主
 *
 */
+ (void)teamApplyMasterInfoWithParams:(NSDictionary *)param
                              success:(void(^)(id obj))success
                              failure:(void(^)(HttpException * e))failure;

/**
 *    关注／取消关注圈子
 *
 */
+ (void)teamAttentionTeamWithParams:(NSDictionary *)param
                            success:(void(^)(id obj))success
                            failure:(void(^)(HttpException * e))failure;

/**
 *    关注／取消关注用户
 *
 */
+ (void)teamAttentionMbrWithParams:(NSDictionary *)param
                           success:(void(^)(id obj))success
                           failure:(void(^)(HttpException * e))failure;

/**
 *    圈子全部列表
 *
 */
+ (void)teamAllTeamListWithParams:(NSDictionary *)param
                          success:(void(^)(id obj))success
                          failure:(void(^)(HttpException * e))failure;

/**
 *    我的粉丝
 *
 */
+ (void)teamMyFansListWithParams:(NSDictionary *)param
                         success:(void(^)(id obj))success
                         failure:(void(^)(HttpException * e))failure;

/**
 *    我关注的专家
 *
 */
+ (void)teamMyAttnExpertListWithParams:(NSDictionary *)param
                               success:(void(^)(id obj))success
                               failure:(void(^)(HttpException * e))failure;


/**
 *    我关注的圈子
 *
 */
+ (void)TeamMyAttnTeamListWithParams:(NSDictionary *)param
                             success:(void(^)(id obj))success
                             failure:(void(^)(HttpException * e))failure;

/**
 *    我的发帖列表
 *
 */
+ (void)TeamMyPostListWithParams:(NSDictionary *)param
                         success:(void(^)(id obj))success
                         failure:(void(^)(HttpException * e))failure;


/**
 *    我的回帖列表
 *
 */
+ (void)TeamMyReplyListWithParams:(NSDictionary *)param
                          success:(void(^)(id obj))success
                          failure:(void(^)(HttpException * e))failure;

/**
 *    专家专栏信息
 *
 */
+ (void)TeamExpertInfoWithParams:(NSDictionary *)param
                         success:(void(^)(id obj))success
                         failure:(void(^)(HttpException * e))failure;

/**
 *    Ta的发文列表
 *
 */
+ (void)TeamHisPostListWithParams:(NSDictionary *)param
                          success:(void(^)(id obj))success
                          failure:(void(^)(HttpException * e))failure;

/**
 *    Ta的回帖列表
 *
 */
+ (void)TeamHisReplyListWithParams:(NSDictionary *)param
                           success:(void(^)(id obj))success
                           failure:(void(^)(HttpException * e))failure;

/**
 *    专家token校验
 *
 */
+ (void)tokenValidWithParams:(NSDictionary *)param
                     success:(void(^)(id obj))success
                     failure:(void(^)(HttpException * e))failure;


/**
 *    上传专家认证信息
 *
 */
+ (void)TeamUploadCertInfoWithParams:(NSDictionary *)param
                             success:(void(^)(id obj))success
                             failure:(void(^)(HttpException * e))failure;


/**
 *    获取擅长领域列表
 *
 */
+ (void)TeamExpertiseListWithParams:(NSDictionary *)param
                            success:(void(^)(id obj))success
                            failure:(void(^)(HttpException * e))failure;


/**
 *    Ta关注的圈子列表
 *
 */
+ (void)TeamHisAttnTeamListWithParams:(NSDictionary *)param
                              success:(void(^)(id obj))success
                              failure:(void(^)(HttpException * e))failure;

/**
 *    Ta关注的专家列表
 *
 */
+ (void)TeamHisAttnExpertListWithParams:(NSDictionary *)param
                                success:(void(^)(id obj))success
                                failure:(void(^)(HttpException * e))failure;



/**
 *    更新个人信息
 *
 */
+ (void)TeamUpdateMbrInfoWithParams:(NSDictionary *)param
                            success:(void(^)(id obj))success
                            failure:(void(^)(HttpException * e))failure;


/**
 *    获取个人信息
 *
 */
+ (void)TeamMyInfoWithParams:(NSDictionary *)param
                     success:(void(^)(id obj))success
                     failure:(void(^)(HttpException * e))failure;


/**
 *    我收藏的帖子
 *
 */
+ (void)TeamGetCollectionPostWithParams:(NSDictionary *)param
                                success:(void(^)(id obj))success
                                failure:(void(^)(HttpException * e))failure;

/**
 *    取消收藏帖子
 *
 */
+ (void)H5CancelCollectionPostWithParams:(NSDictionary *)param
                                 success:(void(^)(id obj))success
                                 failure:(void(^)(HttpException * e))failure;


/**
 *    圈子消息列表
 *
 */
+ (void)TeamMessageWithParams:(NSDictionary *)param
                      success:(void(^)(id obj))success
                      failure:(void(^)(HttpException * e))failure;


/**
 *    轮询圈子消息
 *
 */
+ (void)TeamQueryUnReadMessageWithParams:(NSDictionary *)param
                                 success:(void(^)(id obj))success
                                 failure:(void(^)(HttpException * e))failure;


/**
 *    删除帖子
 *
 */
+ (void)TeamDelPostInfoWithParams:(NSDictionary *)param
                          success:(void(^)(id obj))success
                          failure:(void(^)(HttpException * e))failure;


/**
 *    删除评论
 *
 */
+ (void)TeamDelReplyWithParams:(NSDictionary *)param
                       success:(void(^)(id obj))success
                       failure:(void(^)(HttpException * e))failure;


/**
 *    删除单条消息
 *
 */
+ (void)TeamChangeMessageShowFlagWithParams:(NSDictionary *)param
                                    success:(void(^)(id obj))success
                                    failure:(void(^)(HttpException * e))failure;


/**
 *    查看点赞
 *
 */
+ (void)TeamQueryZanListByObjIdWithParams:(NSDictionary *)param
                                  success:(void(^)(id obj))success
                                  failure:(void(^)(HttpException * e))failure;


/**
 *    全部标记为已读
 *
 */
+ (void)TeamChangeAllMessageReadFlagWithParams:(NSDictionary *)param
                                       success:(void(^)(id obj))success
                                       failure:(void(^)(HttpException * e))failure;


/**
 *    回复评论
 *
 */
+ (void)TeamPostReplyWithParams:(NSDictionary *)param
                        success:(void(^)(id obj))success
                        failure:(void(^)(HttpException * e))failure;


/**
 *     分类标记已读
 *
 */
+ (void)TeamChangeMsgReadFlagByMsgClassWithParams:(NSDictionary *)param
                                          success:(void(^)(id obj))success
                                          failure:(void(^)(HttpException * e))failure;



/**
 *     商户端获取基本信息
 *
 */
+ (void)InitByBranchWithParams:(NSDictionary *)param
                       success:(void(^)(id obj))success
                       failure:(void(^)(HttpException * e))failure;

/**
 *     用户注册校验
 *
 */
+ (void)registerValidWithParams:(NSDictionary *)param
                        success:(void(^)(id DFUserModel))success
                        failure:(void(^)(HttpException * e))failure;

/**
 *     我的圈 帖子列表
 *
 */
+ (void)TeamMyTeamWithParams:(NSDictionary *)param
                     success:(void(^)(id DFUserModel))success
                     failure:(void(^)(HttpException * e))failure;

/**
 *     全部圈子 4.0.0以后
 *
 */
+ (void)TeamQueryTeamListWithParams:(NSDictionary *)param
                            success:(void(^)(id DFUserModel))success
                            failure:(void(^)(HttpException * e))failure;


/**
 *     入驻专家列表
 *
 */
+ (void)TeamQueryAttnTeamExpertWithParams:(NSDictionary *)param
                                  success:(void(^)(id DFUserModel))success
                                  failure:(void(^)(HttpException * e))failure;


@end
