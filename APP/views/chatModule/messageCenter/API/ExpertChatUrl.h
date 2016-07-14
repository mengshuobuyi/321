//
//  ExpertChatUrl.h
//  wenYao-store
//
//  Created by 李坚 on 16/3/23.
//  Copyright © 2016年 carret. All rights reserved.
//

#ifndef ExpertChatUrl_h
#define ExpertChatUrl_h



//------------V3.1 add by lijian-------------Start//

//-------私聊-------Start

#define PMChatDelete            @"h5/team/chat/session/del"         //私聊列表删除单个
#define PMChatGetAll            @"h5/team/chat/session/getAll"      //私聊列表全量
#define PMChatGetPoll           @"h5/team/chat/session/getChatList" //私聊列表增量

#define PMChatDetailGetAll      @"h5/team/chat/detail/getAll"       //私聊详情全量
#define PMChatDetailLoop        @"h5/team/chat/detail/getChatDetailList"//私聊详情增量

#define PMChatDetailSendMsg     @"h5/team/chat/detail/addChatDetail"//私聊发送消息


//-------私聊-------End



//-------问答-------Start

#define LocuationQAList         @"h5/imConsult/queryQAList"     //问答列表全量
#define IgnoreIMInterlocuation  @"h5/imConsult/ignore"          //砖家忽略
#define RaceIMInterlocuation    @"h5/imConsult/race"            //砖家抢答
#define CheckCanRace            @"h5/imConsult/checkCanRace"    //检查是否可以抢答

#define IMQADDetailList         @"h5/imConsult/queryQADetail"   //问答详情全量
#define IMInterLoop             @"h5/imConsult/loopNews"        //问答详情增量

#define XPQADetailSend          @"h5/imConsult/reply"           //问答发送消息

//-------问答-------End

//End---------V3.1 add by lijian--------------End//





#endif /* ExpertChatUrl_h */
