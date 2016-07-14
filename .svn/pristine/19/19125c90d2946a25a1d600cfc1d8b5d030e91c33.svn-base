//
//  Forum.h
//  APP
//
//  Created by Martin.Liu on 16/1/7.
//  Copyright © 2016年 carret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ForumModelR.h"
#import "ForumModel.h"
#import "HttpClient.h"
@interface Forum : NSObject

+ (void)sendPostWithPostDetail:(QWPostDetailModel*)postDetail
                     isEditing:(BOOL)isEditing
               reminderExperts:(NSString*)experts;

#pragma mark 圈子-热议
+ (void)gethotPost:(GetHotPostR*)param
           success:(void (^)(QWCircleHotInfo *responModel))success
           failure:(void (^)(HttpException *e))failure;

#pragma mark 圈子-热议 无菊花
+ (void)gethotPostWithoutProgress:(GetHotPostR*)param
                          success:(void (^)(QWCircleHotInfo *responModel))success
                          failure:(void (^)(HttpException *e))failure;

#pragma mark 全部圈子列表
+ (void)getAllCircleList:(GetAllCircleListR*)param
               success:(void (^)(NSArray *teamList))success
               failure:(void (^)(HttpException *e))failure;

#pragma mark 申请做圈主
+ (void)applyCircler:(ApplyCirclerR*)param
             success:(void (^)(BaseAPIModel *baseAPIModel))success
             failure:(void (^)(HttpException *e))failure;

#pragma mark 关注用户
+ (void)attentionMbr:(AttentionMbrR*)param
             success:(void (^)(BaseAPIModel *baseAPIModel))success
             failure:(void (^)(HttpException *e))failure;

#pragma mark 关注圈子
+ (void)attentionCircle:(AttentionCircleR*)param
                success:(void (^)(BaseAPIModel *baseAPIModel))success
                failure:(void (^)(HttpException *e))failure;

#pragma mark 获取圈主列表
+ (void)getCirclerInfoList:(GetCirclerInfoR*)param
                   success:(void (^)(NSArray *responseModelArray))success
                   failure:(void (^)(HttpException *e))failure;

#pragma mark 圈子详细信息-帖子列表
+ (void)getPostListInfo:(GetPostListInfoR*)param
                success:(void (^)(NSArray *responseModelArray))success
                failure:(void (^)(HttpException *e))failure;

#pragma mark 圈子-详细信息
+(void)getCircleDetailsInfo:(GetCircleDetailsInfoR*)param
                    success:(void (^)(QWCircleModel *responseModel))success
                    failure:(void (^)(HttpException *e))failure;

#pragma mark 获取所有的专家信息
+(void)getExpertInfoSuccess:(void (^)(id responseObj))success
                    failure:(void (^)(HttpException *e))failure;

#pragma mark 举报帖子
+ (void)complaintPostInfo:(ComplaintPostInfoR*)param
                  success:(void (^)(BaseAPIModel *baseAPIModel))success
                  failure:(void (^)(HttpException *e))failure;

#pragma mark 删除帖子
+ (void)delPostInfo:(DeletePostInfoR*)param
            success:(void (^)(BaseAPIModel *baseAPIModel))success
            failure:(void (^)(HttpException *e))failure;

#pragma mark 发布/编辑帖子校验
+ (void)editPostInfoCheck:(NSDictionary*)param
                  success:(void (^)(BaseAPIModel* baseAPIModel))success
                  failure:(void (^)(HttpException *e))failure;

#pragma mark 发布/编辑帖子
+ (void)editPostInfo:(NSDictionary*)param
             success:(void (^)(id responseObj))success
             failure:(void (^)(HttpException *e))failure;

#pragma mark 获取所有的专家信息
+ (void)getAllExpertInfoSuccess:(void (^)(NSArray *expertArray))success
                        failure:(void (^)(HttpException *e))failure;

#pragma mark 举报
+ (void)complaint:(QWComplaintR*)param
          success:(void (^)(BaseAPIModel *baseAPIModel))success
          failure:(void (^)(HttpException *e))failure;

#pragma mark 获取举报原因
+ (void)getComplaintReson:(GetComplaintResonR*)param
                  success:(void (^)(NSArray *complaintReasonList))success
                  failure:(void (^)(HttpException *e))failure;

#pragma mark 获取关注和未关注的专家列表信息
+ (void)getAttenAndRecommendExpertListInfo:(GetExpertListInfoR*)param
                                   success:(void (^)(QWAttnAndRecommendExpertList* expertList))success
                                   failure:(void (^)(HttpException *e))failure;

#pragma mark 获取帖子详情
+ (void)getPostDetial:(GetPostDetailsR*)getPostDetailsR
              success:(void (^)(QWPostDetailModel* postDetail))success
              failure:(void (^)(HttpException *e))failure;

#pragma mark 获取帖子详情 无菊花
+ (void)getPostDetialWithoutProgress:(GetPostDetailsR*)getPostDetailsR
                             success:(void (^)(QWPostDetailModel* postDetail))success
                             failure:(void (^)(HttpException *e))failure;

#pragma mark 获取我的发帖列表
+ (void)getMyPostList:(GetMyPostListR*)param
              success:(void (^)(NSArray* postList))success
              failure:(void (^)(HttpException *e))failure;

#pragma mark 获取我的发帖列表 无菊花
+ (void)getMyPostListWithoutProgress:(GetMyPostListR*)param
                             success:(void (^)(NSArray* postList))success
                             failure:(void (^)(HttpException *e))failure;

#pragma mark 帖子点赞功能
+ (void)praisePost:(PraisePostR*)param
           success:(void (^)(BaseAPIModel *baseAPIModel))success
           failure:(void (^)(HttpException *e))failure;

#pragma mark 帖子点赞取消功能
+ (void)cancelPraisePost:(PraisePostR*)param
                 success:(void (^)(BaseAPIModel *baseAPIModel))success
                 failure:(void (^)(HttpException *e))failure;

#pragma mark 获取我关注的圈子列表和我的圈子列表
+ (void)getMyCircleList:(GetMyCircleListR*)param
                success:(void (^)(QWMyCircleList *myCircleList))success
                failure:(void (^)(HttpException *e))failure;

#pragma mark 获取Ta的发文列表
+ (void)getHisPostList:(GetHisPostListR*)param
               success:(void (^)(NSArray *postList))success
               failure:(void (^)(HttpException *e))failure;

#pragma mark 获取Ta的回帖列表
+ (void)getHisReplyList:(GetHisReplyR*)param
                success:(void (^)(NSArray *postReplyList))success
                failure:(void (^)(HttpException *e))failure;

#pragma mark 获取我关注的专家列表
+ (void)getMyAttnExpertList:(GetMyAttnExpertListR*)param
                    success:(void (^)(NSArray *expertList))success
                    failure:(void (^)(HttpException *e))failure;

#pragma mark 获取我的粉丝列表
+ (void)getMyFansList:(GetMyFansListR*)param
              success:(void (^)(NSArray *expertList))success
              failure:(void (^)(HttpException *e))failure;

#pragma mark 获取我的回帖列表
+ (void)getMyPostReplyList:(GetMyPostReplyListR*)param
                   success:(void (^)(NSArray *postReplyList))success
                   failure:(void (^)(HttpException *e))failure;

#pragma mark 帖子回复功能
+ (void)replyPost:(ReplyPostR*)param
          success:(void (^)(BaseAPIModel* baseAPIModel))success
          failure:(void (^)(HttpException *e))failure;

#pragma mark 帖子分享功能
+ (void)sharePost:(PostShareR*)param
          success:(void (^)(BaseAPIModel* baseAPIModel))success
          failure:(void (^)(HttpException *e))failure;

#pragma mark 置顶帖子
+ (void)topPost:(TopPostR*)param
        success:(void (^)(BaseAPIModel* baseAPIModel))success
        failure:(void (^)(HttpException *e))failure;

#pragma mark 检查用户是否收藏帖子
+ (void)checkCollcetPost:(CheckCollectPostR*)param
                 success:(void (^)(BaseAPIModel* baseAPIModel))success
                 failure:(void (^)(HttpException *e))failure;

#pragma mark 用户收藏(收藏对象类型（1:商品, 2:消息(用药指导收藏信息), 3:疾病, 4:保留, 5:健康资讯, 6:症状, 7:药店, 8:优惠活动, 9:专题/特刊, 10:帖子）)
+ (void)collectOBJ:(CollectOBJR*)param
            success:(void (^)(BaseAPIModel* baseAPIModel))success
            failure:(void (^)(HttpException *e))failure;

+ (void)cancelCollectOBJ:(CancelCollectOBJR*)param
                 success:(void (^)(BaseAPIModel* baseAPIModel))success
                 failure:(void (^)(HttpException *e))failure;

#pragma mark 评论的点赞功能
/** ApiStatus
 0	成功点赞!
 1	评论人Id不能为空!
 2	帖子标题不能为空!
 3	本机设备号不能为空!
 4	帖子Id不能为空!
 5	评论Id不能为空!
 6	你已经点赞过!
 */
+(void)praisePostComment:(PraisePostComment*)param
                 success:(void (^)(BaseAPIModel* baseAPIModel))success
                 failure:(void (^)(HttpException *e))failure;

#pragma mark 取消评论的点赞功能
/** ApiStatus
 0	成功取消点赞!
 1	评论人Id不能为空!
 2	帖子标题不能为空!
 3	本机设备号不能为空!
 4	帖子Id不能为空!
 5	评论Id不能为空!
 6	你未点过赞!
 */
+(void)cancelPraisePostComment:(PraisePostComment*)param
                       success:(void (^)(BaseAPIModel* baseAPIModel))success
                       failure:(void (^)(HttpException *e))failure;


#pragma mark 删除评论
/**
 0	删除成功!
 1	您没有权限删除!
 2	您已被禁言!
 */
+ (void)deletePostReply:(DeletePostReplyR*)param
                success:(void (^)(BaseAPIModel* baseAPIModel))success
                failure:(void (^)(HttpException *e))failure;

#pragma mark 获取置顶帖子Id
+ (void)GetTopPostId:(GetTopPostIdR*)param
             success:(void (^)(QWTopPostId* topPostId))success
             failure:(void (^)(HttpException *e))failure;

/**
 *  可同步的圈子列表
 */
+ (void)getSyncTeamList:(GetSyncTeamListR*)param
                success:(void (^)(QWSyncTeamListModel* syncTeamListModel))success
                failure:(void (^)(HttpException *e))failure;

/**
 *  4.0.1 获取是否禁言、是否申诉
 */
+ (void)getSilenceStatus:(GetSilenceStatusR*)params
                 success:(void(^)(SilenceStatusModel* silenceStatusModel))success
                 failure:(void(^)(HttpException * e))failure;

@end
