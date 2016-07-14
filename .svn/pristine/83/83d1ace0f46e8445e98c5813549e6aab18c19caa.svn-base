//
//  Circle.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/8.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "Circle.h"
#import "BaseAPIModel.h"

@implementation Circle

/**
 *    圈子热议
 *
 */
+ (void)TeamGetTeamHotInfoWithParams:(NSDictionary *)param
                             success:(void(^)(id obj))success
                             failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:TeamGetTeamHotInfo params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *    圈子详细信息
 *
 */
+ (void)TeamGetTeamDetailsInfoWithParams:(NSDictionary *)param
                                 success:(void(^)(id obj))success
                                 failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:TeamGetTeamDetailsInfo params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *    圈子详细信息 帖子列表
 *
 */
+ (void)TeamGetPostListInfoByTeamIdWithParams:(NSDictionary *)param
                                      success:(void(^)(id obj))success
                                      failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:TeamGetPostListInfoByTeamId params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *    查看圈主列表
 *
 */
+ (void)teamGetMbrInfoListByTeamIdWithParams:(NSDictionary *)param
                                     success:(void(^)(id obj))success
                                     failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:TeamGetMbrInfoListByTeamId params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *    申请做圈主
 *
 */
+ (void)teamApplyMasterInfoWithParams:(NSDictionary *)param
                              success:(void(^)(id obj))success
                              failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr post:TeamApplyMasterInfo params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *    关注／取消关注圈子
 *
 */
+ (void)teamAttentionTeamWithParams:(NSDictionary *)param
                            success:(void(^)(id obj))success
                            failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr post:TeamAttentionTeam params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *    关注／取消关注用户
 *
 */
+ (void)teamAttentionMbrWithParams:(NSDictionary *)param
                           success:(void(^)(id obj))success
                           failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr post:TeamAttentionMbr params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *    圈子全部列表
 *
 */
+ (void)teamAllTeamListWithParams:(NSDictionary *)param
                          success:(void(^)(id obj))success
                          failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:TeamAllTeamList params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *    我的粉丝
 *
 */
+ (void)teamMyFansListWithParams:(NSDictionary *)param
                         success:(void(^)(id obj))success
                         failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:TeamMyFansList params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *    我关注的专家
 *
 */
+ (void)teamMyAttnExpertListWithParams:(NSDictionary *)param
                               success:(void(^)(id obj))success
                               failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:TeamMyAttnExpertList params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *    我关注的圈子
 *
 */
+ (void)TeamMyAttnTeamListWithParams:(NSDictionary *)param
                             success:(void(^)(id obj))success
                             failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:TeamMyAttnTeamList params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *    我的发帖列表
 *
 */
+ (void)TeamMyPostListWithParams:(NSDictionary *)param
                         success:(void(^)(id obj))success
                         failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:TeamMyPostList params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *    我的回帖列表
 *
 */
+ (void)TeamMyReplyListWithParams:(NSDictionary *)param
                          success:(void(^)(id obj))success
                          failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:TeamMyReplyList params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *    专家专栏信息
 *
 */
+ (void)TeamExpertInfoWithParams:(NSDictionary *)param
                         success:(void(^)(id obj))success
                         failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:TeamExpertInfo params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *    Ta的发文列表
 *
 */
+ (void)TeamHisPostListWithParams:(NSDictionary *)param
                          success:(void(^)(id obj))success
                          failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:TeamHisPostList params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *    Ta的回帖列表
 *
 */
+ (void)TeamHisReplyListWithParams:(NSDictionary *)param
                           success:(void(^)(id obj))success
                           failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:TeamHisReplyList params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *    专家token校验
 *
 */
+ (void)tokenValidWithParams:(NSDictionary *)param
                     success:(void(^)(id obj))success
                     failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr postWithoutProgress:ExpertTokenValid params:param success:^(id resultObj) {
                    if (success) {
                        success(resultObj);
                    }
    }failure:^(HttpException *e) {
                    if (failure) {
                        failure(e);
                    }
                }];
}

/**
 *    上传专家认证信息
 *
 */
+ (void)TeamUploadCertInfoWithParams:(NSDictionary *)param
                             success:(void(^)(id obj))success
                             failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr post:TeamUploadCertInfo params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *    获取擅长领域列表
 *
 */
+ (void)TeamExpertiseListWithParams:(NSDictionary *)param
                            success:(void(^)(id obj))success
                            failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:TeamExpertiseList params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *    Ta关注的圈子列表
 *
 */
+ (void)TeamHisAttnTeamListWithParams:(NSDictionary *)param
                              success:(void(^)(id obj))success
                              failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:TeamHisAttnTeamList params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *    Ta关注的专家列表
 *
 */
+ (void)TeamHisAttnExpertListWithParams:(NSDictionary *)param
                                success:(void(^)(id obj))success
                                failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:TeamHisAttnExpertList params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *    更新个人信息
 *
 */
+ (void)TeamUpdateMbrInfoWithParams:(NSDictionary *)param
                            success:(void(^)(id obj))success
                            failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr post:TeamUpdateMbrInfo params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *    获取个人信息
 *
 */
+ (void)TeamMyInfoWithParams:(NSDictionary *)param
                     success:(void(^)(id obj))success
                     failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:TeamMyInfo params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *    我收藏的帖子
 *
 */
+ (void)TeamGetCollectionPostWithParams:(NSDictionary *)param
                                success:(void(^)(id obj))success
                                failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:TeamGetCollectionPost params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *    取消收藏帖子
 *
 */
+ (void)H5CancelCollectionPostWithParams:(NSDictionary *)param
                                 success:(void(^)(id obj))success
                                 failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr post:H5CollectionCancelCollection params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *    圈子消息列表
 *
 */
+ (void)TeamMessageWithParams:(NSDictionary *)param
                      success:(void(^)(id obj))success
                      failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:TeamMessage params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *    轮询圈子消息
 *
 */
+ (void)TeamQueryUnReadMessageWithParams:(NSDictionary *)param
                                 success:(void(^)(id obj))success
                                 failure:(void(^)(HttpException * e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [HttpClientMgr getWithoutProgress:TeamQueryUnReadMessage params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *    删除帖子
 *
 */
+ (void)TeamDelPostInfoWithParams:(NSDictionary *)param
                          success:(void(^)(id obj))success
                          failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr post:TeamDelPostInfo params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *    删除评论
 *
 */
+ (void)TeamDelReplyWithParams:(NSDictionary *)param
                       success:(void(^)(id obj))success
                       failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr post:TeamDelReply params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *    删除单条消息
 *
 */
+ (void)TeamChangeMessageShowFlagWithParams:(NSDictionary *)param
                                    success:(void(^)(id obj))success
                                    failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr post:TeamChangeMessageShowFlag params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *    查看点赞
 *
 */
+ (void)TeamQueryZanListByObjIdWithParams:(NSDictionary *)param
                                  success:(void(^)(id obj))success
                                  failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:TeamQueryZanListByObjId params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *    全部标记为已读
 *
 */
+ (void)TeamChangeAllMessageReadFlagWithParams:(NSDictionary *)param
                                       success:(void(^)(id obj))success
                                       failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr post:TeamChangeAllMessageReadFlag params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *    回复评论
 *
 */
+ (void)TeamPostReplyWithParams:(NSDictionary *)param
                        success:(void(^)(id obj))success
                        failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr post:TeamPostReply params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *     分类标记已读
 *
 */
+ (void)TeamChangeMsgReadFlagByMsgClassWithParams:(NSDictionary *)param
                                          success:(void(^)(id obj))success
                                          failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr post:TeamChangeMsgReadFlagByMsgClass params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *     商户端获取基本信息
 *
 */
+ (void)InitByBranchWithParams:(NSDictionary *)param
                       success:(void(^)(id obj))success
                       failure:(void(^)(HttpException * e))failure
{
    HttpClientMgr.progressEnabled = NO;
    [HttpClientMgr get:InitByBranch params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *     用户注册校验
 *
 */
+ (void)registerValidWithParams:(NSDictionary *)param
                        success:(void(^)(id DFUserModel))success
                        failure:(void(^)(HttpException * e))failure
{
    NSString *url = [NSString stringWithFormat:@"%@?mobile=%@",UserRegisterValid,param[@"mobile"]];
    
    [[HttpClient sharedInstance] get:url params:nil success:^(id resultObj) {
        if (success) {
            success(resultObj);
        }
    }failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *     我的圈 帖子列表
 *
 */
+ (void)TeamMyTeamWithParams:(NSDictionary *)param
                     success:(void(^)(id DFUserModel))success
                     failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:TeamMyTeam params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];

}

/**
 *     全部圈子 4.0.0以后
 *
 */
+ (void)TeamQueryTeamListWithParams:(NSDictionary *)param
                            success:(void(^)(id DFUserModel))success
                            failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:TeamQueryTeamList params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];

}

/**
 *     入驻专家列表
 *
 */
+ (void)TeamQueryAttnTeamExpertWithParams:(NSDictionary *)param
                                  success:(void(^)(id DFUserModel))success
                                  failure:(void(^)(HttpException * e))failure
{
    [HttpClientMgr get:TeamQueryAttnTeamExpert params:param success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];

}


@end
