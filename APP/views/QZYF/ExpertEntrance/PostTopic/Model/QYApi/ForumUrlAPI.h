// 圈子
#define API_Forum_GetAllTeamList        @"/api/team/allTeamList"                    // 全部圈子列表
#define API_Forum_ApplyMasterInfo       @"/api/team/applyMasterInfo"                // 申请做圈主
#define API_Forum_AttentionMbr          @"/api/team/attentionMbr"                   // 关注用户/取消关注用户
#define API_Forum_DelPostInfo           @"/api/team/delPostInfo"                    // 删除帖子
#define API_Forum_EditPostInfo          @"/api/team/editPostInfo"                   // 发布/编辑帖子
#define API_Forum_EditPostInfoCheck     @"/api/team/editPostCheck"                  // 发布/编辑帖子校验
#define API_Forum_GetAllExpertInfo      @"/api/team/getAllExpertInfo"               // 获取所有的专家信息
#define API_Forum_GetExpertListInfo     @"/api/team/getExpertListInfo"              // 获取关注和未关注的专家列表信息
#define API_Forum_GetMbrInfoList        @"/api/team/getMbrInfoListByTeamId"         // 圈主列表
#define API_Forum_GetPostListInfoByTeamId  @"/api/team/getPostListInfoByTeamId"     // 圈子详细信息-帖子列表
#define API_Forum_GetTeamDetailsInfo    @"/api/team/getTeamDetailsInfo"             // 圈子-详细信息
#define API_Forum_GetTeamHotInfo        @"/api/team/getTeamHotInfo"                 // 圈子-热议
#define API_Forum_AttentionTeam         @"/api/team/attentionTeam"                  // 关注圈子
#define API_Forum_GetExpertInfo         @"/api/team/getExpertInfo"                  // 获取所有的专家信息
#define API_Forum_ComplaintPostInfo     @"/api/team/complaintPostInfo"              // 举报帖子
//#define API_Forum_GetComplaintReson     @"/api/team/getComplaintReson"              // 获取举报原因
#define API_Complaint                   @"/api/complaint/complaint"                 // 举报
#define API_QuerryComplaintReason       @"/api/complaint/queryReasons"              // 获取举报原因列表
#define API_Forum_GetpostDetails        @"/h5/team/postDetails"                     // 帖子详情
#define API_Forum_GetMyPostList         @"/api/team/myPostList"                     // 我的发帖列表
#define API_Forum_PraisePost            @"/api/team/upVote"                         // 帖子点赞功能
#define API_Forum_CancelPraisePost      @"/api/team/upVoteRepeal"                   // POST /api/team/upVoteRepeal 帖子点赞取消功能
#define API_Forum_GetMyCircleList       @"/api/team/myAttnTeamList"                 // 我关注的圈子列表

#define API_Forum_getHisPostList        @"/api/team/hisPostList"                    // Ta的发文列表
#define API_Forum_getHisReplyList       @"/api/team/hisReplyList"                   // Ta的回帖列表
#define API_Forum_getMyAttnExpertList   @"/api/team/myAttnExpertList"               // 我关注的专家列表
#define API_Forum_getMyFansList         @"/api/team/myFansList"                     // 我的粉丝列表
#define API_Forum_getMyReplyList        @"/api/team/myReplyList"                    // 我的回帖列表
#define API_Forum_ReplyPost              @"/api/team/postReply"                      // 帖子回复功能
#define API_Forum_SharePost             @"/api/team/postShare"                      // 帖子分享功能?
#define API_Forum_TopPost               @"/api/team/topPost"                        // 置顶帖子
#define API_Forum_CheckCollectPost      @"/h5/collection/checkCollection"           // 检查用户是否收藏
#define API_Forum_CollectOBJ           @"/h5/collection/mbrCollection"             // 用户收藏
#define API_Forum_CancelCollectOBJ     @"/h5/collection/cancelCollection"          // 用户取消收藏帖子
#define API_Forum_PraiseComment         @"/api/team/replyUpVote"                    // 帖子评论的点赞功能
#define API_Forum_CancelPraiseComment   @"/api/team/replyUpVoteRepeal"                    // 帖子评论的取消点赞功能
#define API_Forum_DeletePostReply       @"/api/team/delReply"                       // 删除评论
#define API_Forum_GetTopPostId          @"/api/team/queryTopPostId"                 // 获取置顶帖子Id
#define API_GetSyncTeamList             @"h5/team/syncTeamList"                     // 可同步的圈子列表
// 4.0.1
#define API_getSilenceStatus            @"h5/mbr/user/querySilenceStatus"           // 获取是否禁言、是否申诉