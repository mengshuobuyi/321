/*!
 @header Notification.h
 @abstract 所有通知常量
 @author .
 @version 1.00 2015/01/01  (1.00)
 */


#ifndef APP_Notification_h
#define APP_Notification_h


#define RELOADTABLEE                 @"RELOADTABLEE"
#define UPDATEBOX          @"UPDATEBOX"

typedef NS_ENUM(NSInteger, Enum_Notification_Type)  {
    //用户
    NotifQuitOut = 1,             //用户退出
    NotifLoginSuccess,              //登录成功
    NotifUserNickNameUpdate,
    NotifHiddenCircleMessage,
    
    //药物，药店
    NotifPharmacyNeedUpdate,   //发出通知,更新用药列表
    
    //消息
    NotifMessageNeedUpdate,    //更新message
    NotifMessageOfficial,
    NotifKickOff,

    //网络
    NotifNetworkDisconnect,    //网络断线
    NotifNetworkReconnect,          //网络重连
    NotifNetworkReachabilityChanged,
    
    //GPS
    NotifLocationUpdate,       //地址更新
    NotifLocationUpdateAddress,
    NotifLocationNeedReload,        //需要重新刷新地址
    
    //系统
    NotifAppCheckVersion,
    
    //更新联系人信息
    NotifContactUpdate,
    NotifContactUpdateImmediate,
    
    //消息需要更新
    NotifNeedUpdate,
    NotifOfficalMessage,
    NotifDeleteMessage,
    
    
    NotifNoReadEvaluate,
    
    //删除或添加小票更新订单
    NotiMyorderList,
    NotiHiddenMyorder,
    NotiRestartTimer,
    NotiRefreshClosedConsult,           //刷新问题已关闭
    NotiRefreshRacingConsult,           //刷新待抢答
    NotiRefreshConsultingConsult,       //刷新解答中问题列表
    NotiRefreshMyConsultingConsult,     //刷新本店咨询列表
    NotiRefreshAllConsult,               //刷新所有咨询列表
    NotimessageIMTabelUpdate,           //跟新Imtable View
    NotimessageBoxUpdate ,              // 发送图片后更新消息盒子
    NotiCountDonwRegister,
    NotiCountDonwChangePhone,
    NotiCountDonwForgetPassword,
    NotiCountDonwChangeAliPayAccount,
    NotiCountDownExpertForgetPwd,       // 专家忘记密码
    NotiCountStoreEditPhone,
    
    NotiCountDownCommonRegister,       // 普通注册
    NotiCountDownExpertLogin,       // 专家登录
    NotiCountDownExpertRegister,       // 专家注册
    
    
    NotifPollNewMessageStatus,
    //app进出后台
    NotifAppDidEnterBackground,  //到后台
    NotifAppDidBecomeActive,
    NotifAppWillEnterForeground,//前台
    
    NotifIMCenterSended, //消息中心发送结束
    
    NotifiIndexRedDotOrNumber,  // 首页的咨询显示小红点或数字角标
    NotifiOrganAuthPass,      // 机构认证通过
    NotifiOrganAuthFailure,   // 机构认证失败
    
    
    NotifClearLoginPassword,
    NotifCircleMessage, //圈子消息小红点
    NotifNewOrderCount,             // 订单处理数量更改
    
    NotiEditPostTextViewBeginEdit,  // 发帖中点击了textview
    NotiEditPostTextViewDidEndEdit, // 发帖中的textview完成的编辑
    NotifSendPostCheckResult,       // 发送帖子验证成功与否通知
    NotifSendPostResult,            // 发送帖子通知
    NotifDeletePostSuccess,         // 成功删除帖子
    NotifHiddenPostdetailExpertActionView,  // 隐藏帖子详情中的评价的辅助目录
    NotiPostCommentSuccess,         // 评论成功
    NotifHiddenCommentRedPoint,
    NotifHiddenFlowerRedPoint,
    NotifHiddenAtMineRedPoint,
    NotifHiddenSystemInfoRedPoint,

    NotiRefreshPrivateExpert,         //刷新砖家私聊
    NotiRefreshPrivateExpertDetail,   //刷新砖家私聊详情
    NotiRefreshPrivateExpertDetailLoop,   //轮循刷新砖家私聊详情
    NotiRefreshWaitingExpert,         //刷新待抢答砖家问题
    NotiRefreshAnsweringExpert,       //刷新解答中砖家问题
    NotiRefreshClosedExpert,          //刷新已关闭砖家问题
    
    NotiInternalProductRefresh,       // 通知本店商品详情更新
    
    
    NotiRefreshExpertWaiting,     //待抢答
    NotiRefreshExpertAnswering,   //解答中
    NotiRefreshExpertClosed,      //已关闭
    NotiRefreshExpertAllConsult,  //拉取专家所有的咨询
    NotiRefreshAnswerMessage,         //有解答中新消息
    NotiRefreshWaitingMessage,         //有待抢答新消息
    
    NotiChangeCurrentPage,
    //H5
    NotifRefreshCurH5Page,          //返回积分商城首页，刷新积分
    NotiQWTabBarDidChangeAppear,
    NotiMsgBoxNeedUpdate,
    NotiMsgBoxRedPointNeedUpdate,
    
    NotiTaskViewDismissed,           // 每天第一次登陆弹框消失
    NotiAddProductSuccessCallback    // 添加商品成功的回调
};
#endif

