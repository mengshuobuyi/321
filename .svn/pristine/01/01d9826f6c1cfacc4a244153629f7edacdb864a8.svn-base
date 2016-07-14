/*!
 @header QWErrorDefs.h
 @abstract QW SDK 错误定义
 @author
 @version 1.00
 */

#ifndef APP_QWErrorDefines_h
#define APP_QWErrorDefines_h

/*!
 @enum
 @brief EasQWob SDK 错误定义
 @discussion
 SDK系统支持的errorCode 是从1000开始, 但是还是会返回HTTP Response Code,
 如果遇到404, 501等ErrorType时, 需要和HTTP的网络请求返回的responseCode进行对比
 @constant QWErrorNotFound                      不存在
 @constant QWErrorServerMaxCountExceeded        发送失败，数量达到上限（每人最多100条离线消息，群组成员达到上线）
 @constant QWErrorServerNotReachable            连接服务器失败(Ex. 手机客户端无网的时候, 会返回的error)
 @constant QWErrorServerTimeout                 连接超时(Ex. 服务器连接超时会返回的error)
 @constant QWErrorServerAuthenticationFailure   获取token失败(Ex. 登录时用户名密码错误，或者服务器无法返回token)
 @constant QWErrorServerAPNSRegistrationFailure APNS注册失败 (Ex. 登录时, APNS注册失败会返回的error)
 @constant QWErrorServerDuplicatedAccount       注册失败(Ex. 注册时, 如果用户存在, 会返回的error)
 @constant QWErrorServerInsufficientPrivilege   所执行操作的权限不够(Ex. 非管理员删除群成员时, 会返回的error)
 @constant QWErrorServerOccupantNotExist        操作群组时, 人员不在此群组(Ex. rQWove群组成员时, 会返回的error)
 @constant QWErrorServerTooManyOperations       短时间内多次发起同一异步请求(Ex. 频繁刷新群组列表, 会返回的error)
 @constant QWErrorServerMaxRetryCountExceeded   已达到最大重试次数(Ex. 自动登陆情况下, 登陆不成功时的重试次数达到最大上线, 会返回的error)
 @constant QWErrorAttachmentNotFound            本地未找着附件
 @constant QWErrorAttachmentDamaged             文件被损坏或被修改了
 @constant QWErrorAttachmentUploadFailure       文件上传失败
 @constant QWErrorFileTypeConvertionFailure     文件格式转换失败
 @constant QWErrorFileTypeNotSupported          不支持的文件格式
 @constant QWErrorIllegalURI                    URL非法(内部使用)
 @constant QWErrorTooManyLoginRequest           正在登陆的时候又发起了登陆请求
 @constant QWErrorTooManyLogoffRequest          正在登出的时候又发起了登出请求
 @constant QWErrorMessageInvalid_NULL           无效的消息(为空)
 @constant QWErrorGroupInvalidID_NULL           无效的群组ID(为空)
 @constant QWErrorGroupJoined                   已加入群组
 @constant QWErrorGroupJoinNeedRequired         加入群组需要申请
 @constant QWErrorGroupFetchInfoFailure         获取群组失败
 @constant QWErrorGroupInvalidRequired          无效的群组申请
 @constant QWErrorInvalidUsername               无效的username
 @constant QWErrorInvalidUsername_NULL          无效的username(用户名为空)
 @constant QWErrorInvalidUsername_Chinese       无效的用户名(用户名不能是中文)
 @constant QWErrorAudioRecordStoping            调用开始录音方法时，上一个录音正在stoping
 @constant QWErrorAudioRecordDurationTooShort   录音时间过短
 @constant QWErrorAudioRecordNotStarted         录音没有开始
 @constant QWErrorPushNotificationInvalidOption 无效的消息推送设置
 @constant QWErrorRQWoveBuddyFromRosterFailure  删除好友失败
 @constant QWErrorAddBuddyToRosterFailure       添加好友失败
 @constant QWErrorCallChatterOffline,           对方不在线
 @constant QWErrorCallInvalidSessionId,         无效的通话Id
 @constant QWErrorOutOfRateLimited              调用频繁
 @constant QWErrorPermissionFailure             权限错误
 @constant QWErrorIsExist,                      已存在
 @constant QWErrorInitFailure                   初始化失败
 @constant QWErrorNetworkNotConnected,          网络未连接
 @constant QWErrorFailure                       失败
 @constant QWErrorFeatureNotImplQWented         还未实现的功能
 */
typedef enum : NSUInteger {
    //general error
    QWErrorNotFound                 = 404,      //不存在
    QWErrorServerMaxCountExceeded   = 500,      //发送失败，数量达到上限（每人最多100条离线消息，群组成员达到上线）
    
    //configuration error
    QWErrorConfigInvalidAppKey      = 1000,     //无效的appKey
    
    //server error
    QWErrorServerNotLogin           = 1002,     //未登录
    QWErrorServerNotReachable,                  //连接服务器失败(Ex. 手机客户端无网的时候, 会返回的error)
    QWErrorServerTimeout,                       //连接超时(Ex. 服务器连接超时会返回的error)
    QWErrorServerAuthenticationFailure,         //获取token失败(Ex. 登录时用户名密码错误，或者服务器无法返回token)
    QWErrorServerAPNSRegistrationFailure,       //APNS注册失败 (Ex. 登录时, APNS注册失败会返回的error)
    QWErrorServerDuplicatedAccount,             //注册失败(Ex. 注册时, 如果用户存在, 会返回的error)
    QWErrorServerInsufficientPrivilege,         //所执行操作的权限不够(Ex. 非管理员删除群成员时, 会返回的error)
    QWErrorServerOccupantNotExist,              //操作群组时, 人员不在此群组(Ex. rQWove群组成员时, 会返回的error)
    QWErrorServerTooManyOperations,             //短时间内多次发起同一异步请求(Ex. 频繁刷新群组列表, 会返回的error)
    QWErrorServerMaxRetryCountExceeded,         //已达到最大重试次数(Ex. 自动登陆情况下, 登陆不成功时的重试次数达到最大上线, 会返回的error)
    
    //file error
    QWErrorAttachmentNotFound,                  //本地未找着附件
    QWErrorAttachmentDamaged,                   //文件被损坏或被修改了
    QWErrorAttachmentUploadFailure,             //文件上传失败
    QWErrorFileTypeConvertionFailure,           //文件格式转换失败
    QWErrorFileTypeNotSupported,                //不支持的文件格式
    
    QWErrorIllegalURI,                          //URL非法(内部使用)
    QWErrorTooManyLoginRequest,                 //正在登陆的时候又发起了登陆请求
    QWErrorTooManyLogoffRequest,                //正在登出的时候又发起了登出请求
    
    //message error
    QWErrorMessageInvalid_NULL,                 //无效的消息(为空)
    
    //group error
    QWErrorGroupInvalidID_NULL,                 //无效的群组ID(为空)
    QWErrorGroupJoined,                         //已加入群组
    QWErrorGroupJoinNeedRequired,               //加入群组需要申请
    QWErrorGroupFetchInfoFailure,               //获取群组失败
    QWErrorGroupInvalidRequired,                //无效的群组申请
    
    //username error
    QWErrorInvalidUsername,                     // 无效的username
    QWErrorInvalidUsername_NULL,                // 无效的用户名(用户名为空)
    QWErrorInvalidUsername_Chinese,             // 无效的用户名(用户名是中文)
    
    //play or record audio error
    QWErrorAudioRecordStoping,                  //调用开始录音方法时，上一个录音正在stoping
    QWErrorAudioRecordDurationTooShort,         //录音时间过短
    QWErrorAudioRecordNotStarted,               //录音没有开始
    
    //push error
    QWErrorPushNotificationInvalidOption,       //无效的消息推送设置
    
    QWErrorRQWoveBuddyFromRosterFailure,        //删除好友失败
    QWErrorAddBuddyToRosterFailure,             //添加好友失败
    QWErrorFetchBuddyListWhileFetching,         //正在获取好友列表时, 又发起一个获取好友列表的操作时返回的errorType
    QWErrorHasFetchedBuddyList,                 //获取好友列表成功后, 再次发起好友列表请求时返回的errorType
    
    //call error
    QWErrorCallChatterOffline,                  //对方不在线
    QWErrorCallInvalidSessionId,                //无效的通话Id
    
    QWErrorOutOfRateLimited,                    //调用频繁
    QWErrorPermissionFailure,                   //权限错误
    QWErrorIsExist,                             //已存在
    QWErrorInitFailure,                         //初始化失败
    QWErrorNetworkNotConnected,                 //网络未连接
    QWErrorFailure,                             //失败
    QWErrorFeatureNotImplQWented,               //还未实现的功能
} QWErrorType;


#endif
