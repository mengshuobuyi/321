//
//  Forum.m
//  APP
//
//  Created by Martin.Liu on 16/1/7.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "Forum.h"
#import "HttpClient.h"
#import "QWGlobalManager.h"
#import "SBJson.h"
#import "SVProgressHUD.h"
#import "ForumUrlAPI.h"
@implementation Forum

+ (void)sendPostWithPostDetail:(QWPostDetailModel*)postDetail
                     isEditing:(BOOL)isEditing
               reminderExperts:(NSString*)experts
{
    NSMutableArray* postContentArray = [NSMutableArray array];
    [postDetail.postContentList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QWPostContentInfo* postContentobj = obj;
        postContentobj.postContentSort = idx; // [NSString stringWithFormat:@"%ld", (long)idx];
        
        QWPostContentDetailModelR* postContentModel = [[QWPostContentDetailModelR alloc] init];
        [postContentModel buildWithQWPostContentInfo:postContentobj];
        [postContentArray addObject:postContentModel];
    }];
    
    // 如果最后一个文本没内容 删掉
    QWPostContentDetailModelR* lastPostContent = [postContentArray lastObject];
    if (lastPostContent.contentType == 1 && StrIsEmpty(lastPostContent.postContent)) {
        [postContentArray removeObject:lastPostContent];
    }
    
    QWPostContentModelR* postContent = [QWPostContentModelR new];
    postContent.postId = postDetail.postId;
    postContent.teamId = postDetail.teamId;
    postContent.postTitle = postDetail.postTitle;
    postContent.status = @"2";
    NSMutableDictionary *postDict = [[postContent dictionaryModel] mutableCopy];
    
    postDict[@"postContentList"] = [NSMutableArray array];
    
    NSMutableArray* mycontentArray = postDict[@"postContentList"];
    for (QWPostContentDetailModelR* postContentModel in postContentArray) {
        [mycontentArray addObject:[postContentModel dictionaryModel]];
    }
    EditPostInfoR* sendPostInfoR = [[EditPostInfoR alloc] init];
    sendPostInfoR.token = QWGLOBALMANAGER.configure.expertToken;
    sendPostInfoR.operateType = isEditing ?  @"1" : @"0";  // 操作类型(0:新增,1:修改)
    sendPostInfoR.expertIds = experts;
    sendPostInfoR.anonFlag = postDetail.flagAnon ? @"Y" : @"N";
    sendPostInfoR.syncTeamId = postDetail.syncTeamId;
    NSMutableDictionary *editPostDict = [[sendPostInfoR dictionaryModel] mutableCopy];
    editPostDict[@"postJson"] = [postDict JSONRepresentation];
    
    [Forum editPostInfoCheck:editPostDict success:^(BaseAPIModel *baseAPIModel) {
        if ([baseAPIModel.apiStatus integerValue] == 0) {
            NSDictionary* dic = @{@"apiStatus":[NSNumber numberWithInteger:0],
                                  @"postId":postDetail.postId};
            [QWGLOBALMANAGER postNotif:NotifSendPostCheckResult data:nil object:dic];
            
            [Forum editPostInfo:editPostDict success:^(id responseObj) {
                if ([responseObj isKindOfClass:[NSDictionary class]]) {
                    if ([responseObj[@"apiStatus"] integerValue] == 0) {
                        
                        if (!StrIsEmpty(responseObj[@"postId"])) {
                            DebugLog(@"删除草稿 : %d", [QWPostDrafts deleteWIthPostId:responseObj[@"postId"]]);
                        }
                        NSDictionary* dic = @{@"apiStatus":[NSNumber numberWithInteger:0],
                                              @"postId":StrIsEmpty(responseObj[@"postId"]) ? @"0" : responseObj[@"postId"]};
                        
                        [QWGLOBALMANAGER postNotif:NotifSendPostResult data:nil object:dic];
                        [SVProgressHUD showSuccessWithStatus:@"发帖成功!"];
                        DebugLog(@"发帖成功!");
                    }
                    else
                    {
                        NSDictionary* dic = @{@"apiStatus":[NSNumber numberWithInteger:1],
                                              @"postId":postDetail.postId};
                        [QWGLOBALMANAGER postNotif:NotifSendPostResult data:nil object:dic];
                        if (!StrIsEmpty(responseObj[@"apiMessage"])) {
                            [SVProgressHUD showErrorWithStatus:responseObj[@"apiMessage"]];
                        }
                    }
                }
                DebugLog(@"send post response : %@", responseObj);
            } failure:^(HttpException *e) {
                NSDictionary* dic = @{@"apiStatus":[NSNumber numberWithInteger:1],
                                      @"postId":postDetail.postId};
                
                [QWGLOBALMANAGER postNotif:NotifSendPostResult data:nil object:dic];
                DebugLog(@"send post error : %@", e);
            }];
        }
        else
        {
            NSDictionary* dic = @{@"apiStatus":[NSNumber numberWithInteger:1],
                                  @"postId":postDetail.postId};
            [QWGLOBALMANAGER postNotif:NotifSendPostResult data:nil object:dic];
            
            [SVProgressHUD showErrorWithStatus:baseAPIModel.apiMessage];
        }
    } failure:^(HttpException *e) {

    }];
}

+ (void)gethotPost:(GetHotPostR *)param
           success:(void (^)(QWCircleHotInfo *))success
           failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] get:API_Forum_GetTeamHotInfo params:[param dictionaryModel] success:^(id responseObj) {
        
        NSMutableArray *keyArr = [NSMutableArray array];
        [keyArr addObject:NSStringFromClass([QWCircleModel class])];
        [keyArr addObject:NSStringFromClass([QWNoticePushModel class])];
        [keyArr addObject:NSStringFromClass([QWPostModel class])];
        
        NSMutableArray *valueArr = [NSMutableArray array];
        [valueArr addObject:@"teamList"];
        [valueArr addObject:@"noticePushList"];
        [valueArr addObject:@"postInfoList"];
        
        QWCircleHotInfo *model = [QWCircleHotInfo parse:responseObj ClassArr:keyArr Elements:valueArr];
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];

}

+ (void)gethotPostWithoutProgress:(GetHotPostR *)param
                          success:(void (^)(QWCircleHotInfo *))success
                          failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] getWithoutProgress:API_Forum_GetTeamHotInfo params:[param dictionaryModel] success:^(id responseObj) {
        
        NSMutableArray *keyArr = [NSMutableArray array];
        [keyArr addObject:NSStringFromClass([QWCircleModel class])];
        [keyArr addObject:NSStringFromClass([QWNoticePushModel class])];
        [keyArr addObject:NSStringFromClass([QWPostModel class])];
        
        NSMutableArray *valueArr = [NSMutableArray array];
        [valueArr addObject:@"teamList"];
        [valueArr addObject:@"noticePushList"];
        [valueArr addObject:@"postInfoList"];
        
        QWCircleHotInfo *model = [QWCircleHotInfo parse:responseObj ClassArr:keyArr Elements:valueArr];
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)getAllCircleList:(GetAllCircleListR *)param
                 success:(void (^)(NSArray *))success
                 failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] get:API_Forum_GetAllTeamList params:[param dictionaryModel] success:^(id responseObj) {
        NSArray* circleArray = [QWCircleModel parseArray:responseObj[@"teamInfoList"]];
        if (success) {
            success(circleArray);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)applyCircler:(ApplyCirclerR *)param
             success:(void (^)(BaseAPIModel *))success
             failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] post:API_Forum_ApplyMasterInfo params:[param dictionaryModel] success:^(id responseObj) {
        BaseAPIModel* baseAPIModel = [BaseAPIModel parse:responseObj];
        if (success) {
            success(baseAPIModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)attentionMbr:(AttentionMbrR *)param
             success:(void (^)(BaseAPIModel *))success
             failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] post:API_Forum_AttentionMbr params:[param dictionaryModel] success:^(id responseObj) {
        BaseAPIModel* baseAPIModel = [BaseAPIModel parse:responseObj];
        if (success) {
            success(baseAPIModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)attentionCircle:(AttentionCircleR *)param
                success:(void (^)(BaseAPIModel *))success
                failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] post:API_Forum_AttentionTeam params:[param dictionaryModel] success:^(id responseObj) {
        BaseAPIModel* baseAPIModel = [BaseAPIModel parse:responseObj];
        if (success) {
            success(baseAPIModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)getCirclerInfoList:(GetCirclerInfoR *)param
                   success:(void (^)(NSArray *))success
                   failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] get:API_Forum_GetMbrInfoList params:[param dictionaryModel] success:^(id responseObj) {
        NSArray* circlerArray = [QWCirclerModel parseArray:responseObj[@"mbrInfoList"]];
        if (success) {
            success(circlerArray);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)getPostListInfo:(GetPostListInfoR *)param
                success:(void (^)(NSArray *))success
                failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] get:API_Forum_GetPostListInfoByTeamId params:[param dictionaryModel] success:^(id responseObj) {
        NSArray* postArray = [QWPostModel parseArray:responseObj[@"postInfoList"]];
        if (success) {
            success(postArray);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)getCircleDetailsInfo:(GetCircleDetailsInfoR *)param
                     success:(void (^)(QWCircleModel *))success
                     failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] get:API_Forum_GetTeamDetailsInfo params:[param dictionaryModel] success:^(id responseObj) {
        QWCircleModel* circleModel = [QWCircleModel parse:responseObj];
//        NSMutableArray *keyArr = [NSMutableArray array];
//        [keyArr addObject:NSStringFromClass([QWCircleModel class])];
//        [keyArr addObject:NSStringFromClass([QWPostModel class])];
//        
//        NSMutableArray *valueArr = [NSMutableArray array];
//        [valueArr addObject:@"teamList"];
//        [valueArr addObject:@"postInfoList"];
//        QWCircleDetailsInfo *model = [QWCircleHotInfo parse:responseObj ClassArr:keyArr Elements:valueArr];
        if (success) {
            success(circleModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)getExpertInfoSuccess:(void (^)(id))success
                     failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] get:API_Forum_GetExpertInfo params:nil success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)complaintPostInfo:(ComplaintPostInfoR *)param
                  success:(void (^)(BaseAPIModel *))success
                  failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] post:API_Forum_ComplaintPostInfo params:[param dictionaryModel] success:^(id responseObj) {
        BaseAPIModel* baseApiModel = [BaseAPIModel parse:responseObj];
        if (success) {
            success(baseApiModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)delPostInfo:(DeletePostInfoR *)param
            success:(void (^)(BaseAPIModel *))success
            failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] post:API_Forum_DelPostInfo params:[param dictionaryModel] success:^(id responseObj) {
        BaseAPIModel* baseApiModel = [BaseAPIModel parse:responseObj];
        if (success) {
            success(baseApiModel);
        }
        if ([baseApiModel.apiStatus integerValue] == 2) {
            QWGLOBALMANAGER.configure.silencedFlag = YES;
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+(void)editPostInfoCheck:(NSDictionary *)param
                 success:(void (^)(BaseAPIModel *))success
                 failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] post:API_Forum_EditPostInfoCheck params:param success:^(id responseObj) {
        BaseAPIModel* baseApiModel = [BaseAPIModel parse:responseObj];
        if (success) {
            success(baseApiModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)editPostInfo:(NSDictionary *)param
             success:(void (^)(id))success
             failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] post:API_Forum_EditPostInfo params:param success:^(id responseObj) {
//        BaseAPIModel* baseApiModel = [BaseAPIModel parse:responseObj];
        if (success) {
            success(responseObj);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}


+ (void)getAllExpertInfoSuccess:(void (^)(NSArray *))success
                        failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] get:API_Forum_GetAllExpertInfo params:nil success:^(id responseObj) {
        NSArray* expertArray = [QWExpertInfoModel parseArray:responseObj[@"expertList"]];
        if (success) {
            success(expertArray);
        }
    } failure:^(HttpException *e) {
        ;
    }];
}

+ (void)complaint:(QWComplaintR *)param
          success:(void (^)(BaseAPIModel *))success
          failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] post:API_Complaint params:[param dictionaryModel] success:^(id responseObj) {
        BaseAPIModel* baseAPIModel = [BaseAPIModel parse:responseObj];
        if (success) {
            success(baseAPIModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        };
    }];
}

+ (void)getComplaintReson:(GetComplaintResonR *)param
                  success:(void (^)(NSArray *))success
                  failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] get:API_QuerryComplaintReason params:[param dictionaryModel] success:^(id responseObj) {
#warning need to check with api
        NSArray *complaintReasonList = [QWComplaintReason parseArray:responseObj[@""]];
        if (success) {
            success(complaintReasonList);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)getAttenAndRecommendExpertListInfo:(GetExpertListInfoR *)param
                                   success:(void (^)(QWAttnAndRecommendExpertList *))success
                                   failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] get:API_Forum_GetExpertListInfo params:[param dictionaryModel] success:^(id responseObj) {
        NSMutableArray *keyArr = [NSMutableArray array];
        [keyArr addObject:NSStringFromClass([QWExpertInfoModel class])];
        [keyArr addObject:NSStringFromClass([QWExpertInfoModel class])];
        
        NSMutableArray *valueArr = [NSMutableArray array];
        [valueArr addObject:@"attnExpertList"];
        [valueArr addObject:@"expertList"];
        
        QWAttnAndRecommendExpertList *model = [QWAttnAndRecommendExpertList parse:responseObj ClassArr:keyArr Elements:valueArr];
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)getPostDetial:(GetPostDetailsR *)getPostDetailsR
              success:(void (^)(QWPostDetailModel *))success
              failure:(void (^)(HttpException *))failure
{
    getPostDetailsR.showLink = YES;
    [[HttpClient sharedInstance] get:API_Forum_GetpostDetails params:[getPostDetailsR dictionaryModel] success:^(id responseObj) {
        
        NSMutableArray *keyArr = [NSMutableArray array];
        [keyArr addObject:NSStringFromClass([QWPostContentInfo class])];
        [keyArr addObject:NSStringFromClass([QWPostReply class])];
        
        NSMutableArray *valueArr = [NSMutableArray array];
        [valueArr addObject:@"postContentList"];
        [valueArr addObject:@"postReplyList"];
        
        QWPostDetailModel *model = [QWPostDetailModel parse:responseObj ClassArr:keyArr Elements:valueArr];
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)getPostDetialWithoutProgress:(GetPostDetailsR *)getPostDetailsR
                             success:(void (^)(QWPostDetailModel *))success
                             failure:(void (^)(HttpException *))failure
{
    getPostDetailsR.showLink = YES;
    [[HttpClient sharedInstance] getWithoutProgress:API_Forum_GetpostDetails params:[getPostDetailsR dictionaryModel] success:^(id responseObj) {
        
        NSMutableArray *keyArr = [NSMutableArray array];
        [keyArr addObject:NSStringFromClass([QWPostContentInfo class])];
        [keyArr addObject:NSStringFromClass([QWPostReply class])];
        
        NSMutableArray *valueArr = [NSMutableArray array];
        [valueArr addObject:@"postContentList"];
        [valueArr addObject:@"postReplyList"];
        
        QWPostDetailModel *model = [QWPostDetailModel parse:responseObj ClassArr:keyArr Elements:valueArr];
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)getMyPostList:(GetMyPostListR *)param
              success:(void (^)(NSArray *))success
              failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] get:API_Forum_GetMyPostList params:[param dictionaryModel] success:^(id responseObj) {
        NSArray* postList = [QWPostModel parseArray:responseObj[@"postInfoList"]];
        ;
        if (success) {
            success(postList);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)getMyPostListWithoutProgress:(GetMyPostListR *)param
                             success:(void (^)(NSArray *))success
                             failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] getWithoutProgress:API_Forum_GetMyPostList params:[param dictionaryModel] success:^(id responseObj) {
        NSArray* postList = [QWPostModel parseArray:responseObj[@"postInfoList"]];
        ;
        if (success) {
            success(postList);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)praisePost:(PraisePostR *)param
           success:(void (^)(BaseAPIModel *))success
           failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] post:API_Forum_PraisePost params:[param dictionaryModel] success:^(id responseObj) {
        BaseAPIModel* model = [BaseAPIModel parse:responseObj];
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+(void)cancelPraisePost:(PraisePostR *)param
                success:(void (^)(BaseAPIModel *))success
                failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] post:API_Forum_CancelPraisePost params:[param dictionaryModel] success:^(id responseObj) {
        BaseAPIModel* model = [BaseAPIModel parse:responseObj];
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)getMyCircleList:(GetMyCircleListR *)param
                success:(void (^)(QWMyCircleList *))success
                failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] get:API_Forum_GetMyCircleList params:[param dictionaryModel] success:^(id responseObj) {
        NSMutableArray *keyArr = [NSMutableArray array];
        [keyArr addObject:NSStringFromClass([QWCircleModel class])];
        [keyArr addObject:NSStringFromClass([QWCircleModel class])];
        
        NSMutableArray *valueArr = [NSMutableArray array];
        [valueArr addObject:@"teamList"];
        [valueArr addObject:@"attnTeamList"];
        
        QWMyCircleList* myCircleList = [QWMyCircleList parse:responseObj ClassArr:keyArr Elements:valueArr];
        if (success) {
            success(myCircleList);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)getHisPostList:(GetHisPostListR *)param
               success:(void (^)(NSArray *))success
               failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] get:API_Forum_getHisPostList params:[param dictionaryModel] success:^(id responseObj) {
        NSArray* postList = [QWPostModel parseArray:responseObj[@"postInfoList"]];
        if (success) {
            success(postList);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)getHisReplyList:(GetHisReplyR *)param
                success:(void (^)(NSArray *))success
                failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] get:API_Forum_getHisReplyList params:[param dictionaryModel] success:^(id responseObj) {
        NSArray* postReplyList = [QWPostReply parseArray:responseObj[@"postReplyList"]];
        if (success) {
            success(postReplyList);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)getMyAttnExpertList:(GetMyAttnExpertListR *)param
                    success:(void (^)(NSArray *))success
                    failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] get:API_Forum_getMyAttnExpertList params:[param dictionaryModel] success:^(id responseObj) {
        NSArray* expertArray = [QWExpertInfoModel parseArray:responseObj[@"expertList"]];
        if (success) {
            success(expertArray);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)getMyFansList:(GetMyFansListR *)param
              success:(void (^)(NSArray *))success
              failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] get:API_Forum_getMyFansList params:[param dictionaryModel] success:^(id responseObj) {
        NSArray* expertList = [QWExpertInfoModel parseArray:responseObj[@"expertList"]];
        if (success) {
            success(expertList);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)getMyPostReplyList:(GetMyPostReplyListR *)param
                   success:(void (^)(NSArray *))success
                   failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] get:API_Forum_getMyReplyList params:[param dictionaryModel] success:^(id responseObj) {
        NSArray* postReplyList = [QWPostReply parseArray:responseObj[@"postReplyList"]];
        if (success) {
            success(postReplyList);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)replyPost:(ReplyPostR *)param
          success:(void (^)(BaseAPIModel *))success
          failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] post:API_Forum_ReplyPost params:[param dictionaryModel] success:^(id responseObj) {
        BaseAPIModel* baseAPIModel = [BaseAPIModel parse:responseObj];
        if (success) {
            success(baseAPIModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)sharePost:(PostShareR *)param
          success:(void (^)(BaseAPIModel *))success
          failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] post:API_Forum_SharePost params:[param dictionaryModel] success:^(id responseObj) {
        BaseAPIModel* baseAPIModel = [BaseAPIModel parse:responseObj];
        if (success) {
            success(baseAPIModel);
        }
        if ([baseAPIModel.apiStatus integerValue] == 2) {
            QWGLOBALMANAGER.configure.silencedFlag = YES;
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)topPost:(TopPostR *)param
        success:(void (^)(BaseAPIModel *))success
        failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] post:API_Forum_TopPost params:[param dictionaryModel] success:^(id responseObj) {
        BaseAPIModel* baseAPIModel = [BaseAPIModel parse:responseObj];
        if (success) {
            success(baseAPIModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)checkCollcetPost:(CheckCollectPostR *)param
                 success:(void (^)(BaseAPIModel *))success
                 failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] get:API_Forum_CheckCollectPost params:[param dictionaryModel] success:^(id responseObj) {
        BaseAPIModel* baseAPIModel = [BaseAPIModel parse:responseObj];
        if (success) {
            success(baseAPIModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)collectOBJ:(CollectOBJR *)param
           success:(void (^)(BaseAPIModel *))success
           failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] post:API_Forum_CollectOBJ params:[param dictionaryModel] success:^(id responseObj) {
        BaseAPIModel* baseAPIModel = [BaseAPIModel parse:responseObj];
        if (success) {
            success(baseAPIModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)cancelCollectOBJ:(CancelCollectOBJR *)param
                 success:(void (^)(BaseAPIModel *))success
                 failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] post:API_Forum_CancelCollectOBJ params:[param dictionaryModel] success:^(id responseObj) {
        BaseAPIModel* baseAPIModel = [BaseAPIModel parse:responseObj];
        if (success) {
            success(baseAPIModel);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)praisePostComment:(PraisePostComment *)param
                  success:(void (^)(BaseAPIModel *))success
                  failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] post:API_Forum_PraiseComment params:[param dictionaryModel] success:^(id responseObj) {
        BaseAPIModel* baseAPIModel = [BaseAPIModel parse:responseObj];
        if (success) {
            success(baseAPIModel);
        };
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)cancelPraisePostComment:(PraisePostComment *)param
                        success:(void (^)(BaseAPIModel *))success
                        failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] post:API_Forum_CancelPraiseComment params:[param dictionaryModel] success:^(id responseObj) {
        BaseAPIModel* baseAPIModel = [BaseAPIModel parse:responseObj];
        if (success) {
            success(baseAPIModel);
        };
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)deletePostReply:(DeletePostReplyR *)param
                success:(void (^)(BaseAPIModel *))success
                failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] post:API_Forum_DeletePostReply params:[param dictionaryModel] success:^(id responseObj) {
        BaseAPIModel* baseAPIModel = [BaseAPIModel parse:responseObj];
        if (success) {
            success(baseAPIModel);
        }
        if ([baseAPIModel.apiStatus integerValue] == 2) {
            QWGLOBALMANAGER.configure.silencedFlag = YES;
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

+ (void)GetTopPostId:(GetTopPostIdR *)param
             success:(void (^)(QWTopPostId *))success
             failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] get:API_Forum_GetTopPostId params:[param dictionaryModel] success:^(id responseObj) {
        QWTopPostId* topPostId = [QWTopPostId parse:responseObj];
        if (success) {
            success(topPostId);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *  可同步的圈子列表
 */
+ (void)getSyncTeamList:(GetSyncTeamListR *)param success:(void (^)(QWSyncTeamListModel *))success failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] get:API_GetSyncTeamList params:[param dictionaryModel] success:^(id responseObj) {
        NSMutableArray *keyArr = [NSMutableArray array];
        [keyArr addObject:NSStringFromClass([QWCircleModel class])];
        
        NSMutableArray *valueArr = [NSMutableArray array];
        [valueArr addObject:@"teamInfoList"];
        
        QWSyncTeamListModel *model = [QWSyncTeamListModel parse:responseObj ClassArr:keyArr Elements:valueArr];
        if (success) {
            success(model);
        }
        
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

/**
 *  4.0.1 获取是否禁言、是否申诉
 */
+ (void)getSilenceStatus:(GetSilenceStatusR *)params
                 success:(void (^)(SilenceStatusModel *))success
                 failure:(void (^)(HttpException *))failure
{
    [[HttpClient sharedInstance] postWithoutProgress:API_getSilenceStatus params:[params dictionaryModel] success:^(id responseObj) {
        SilenceStatusModel* model = [SilenceStatusModel parse:responseObj];
        if (success) {
            success(model);
        }
    } failure:^(HttpException *e) {
        if (failure) {
            failure(e);
        }
    }];
}

@end
