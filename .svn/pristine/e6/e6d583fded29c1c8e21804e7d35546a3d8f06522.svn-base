//
//  ExpertChatViewController.m
//  wenYao-store
//  专家私聊详情
//  私聊详细接口单独放在ExpertChatUrl.h中，切勿与API.h混淆
//  私聊详情全量  h5/team/chat/detail/getAll
//  私聊详情增量  h5/team/chat/detail/getChatDetailList
//  私聊发送消息  h5/team/chat/detail/addChatDetail
//
//  Created by 李坚 on 16/3/25.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "ExpertChatViewController.h"
#import "ExpertMessageCenter.h"
#import "IMApi.h"
#import "UserPageViewController.h"
#import "QuickSearchDrugViewController.h"
#import "DrugModel.h"

@interface ExpertChatViewController ()<UITableViewDataSource,UITableViewDelegate,XHAudioPlayerHelperDelegate,LeveyPopListViewDelegate>{
    MessageModel        *playingMessageModel;
    ExpertMessageCenter *msgCenter;
    NSArray *imgArr;
    
    BOOL firstPushIntoView;
}

@property (nonatomic, strong) NSDictionary *dicNeedResend;//用来记录需要重发的字典对象
@property (nonatomic, strong) NSMutableArray *CommonWords;

@end

@implementation ExpertChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTableView.footerHidden = YES;
    [self setupShareMenuViewImgArr:@[@"photo_image.png",@"take_photo_image.png",@"常用话术.png",@"im_icon_assistant.png"] andTitleArr:@[@"相册",@"拍照",@"常用话术", @"医药助手"]];
    firstPushIntoView = YES;
    
    
    [self enableSimpleRefresh:self.myTableView block:^(SRRefreshView *sender) {
        
        if(!firstPushIntoView){
            [self headerRereshing];
        }
        
    }];
    
    [self messageCenterInit];
    
    [QWGLOBALMANAGER statisticsEventId:@"私聊详情页面_出现" withLable:@"圈子" withParams:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.myTableView setupPanGestureControlKeyboardHide:allowsPanToDismissKeyboard];
    
    //不要删注释
    if (self.shareMenuView.alpha == 1 || self.emotionManagerView.alpha == 1) {
//        self.shareMenuView.alpha = 0.0f;
//        [self layoutOtherMenuVriewHiden:NO];
    }else{
        // 设置键盘通知或者手势控制键盘消失
//        self.myTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0); //UIEdgeInsets( top: t, left: l, bottom: b, right: r)
//        self.myTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0); //UIEdgeInsets( top: t, left: l, bottom: b, right: r)
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    firstPushIntoView = NO;
}

- (void)headerRereshing
{
    //测试翻页历史数据
    [self getHistory];
    [self.myTableView headerEndRefreshing];
}

- (void)getHistory{
    //根据页码翻上一页
    IMHistoryBlock historyMsgBlock = ^(BOOL hadHistory){
        if (hadHistory)
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self myTableView] reloadData];
                [self scrollToBottomAnimated:YES];
                
            });        else {
                
            }
    };
    
    [msgCenter getHistoryMessages:historyMsgBlock success:^(id successObj) {
        
    } failure:^(id failureObj) {
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if(playingMessageModel) {
        playingMessageModel.audioPlaying = NO;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[msgCenter getMessageIndex:playingMessageModel] inSection:0];
        ChatTableViewCell *cell = (ChatTableViewCell *)[self.tableMain cellForRowAtIndexPath:indexPath];
        [cell stopVoicePlay];
        [[XHAudioPlayerHelper shareInstance] stopAudio];
        playingMessageModel = nil;
    }
    [[XHAudioPlayerHelper shareInstance] setDelegate:nil];
}

- (void)dealloc{
    self.emotionManagers = nil;

}

- (void)popVCAction:(id)sender{
    [super popVCAction:sender];
    
    [self closeMessageCenter];
    [[XHAudioPlayerHelper shareInstance] setDelegate:nil];
}

#pragma mark - 消息中心
- (void)messageCenterInit{
    
    if (msgCenter == nil){
        
        DebugLog(@"AAAAAAAAAAAAAAAAAAAAAAA");
        msgCenter = [[ExpertMessageCenter alloc]init];
        
        msgCenter.recipientId = self.recipientId;
        msgCenter.sessionID = self.sessionId;
        
        [msgCenter start];
        DebugLog(@"VVVVVVVVVVVVVVVVVVVVVVV");
    }
    
    //最新的消息回话，会实时刷新
    IMListBlock currentMsgBlock = ^(NSArray* list, IMListType gotType){
        //这里写刷新table的代码
        DebugLog(@"IIIIIIIIIIIIIMMMMMMMMMMMMM:%@",list);

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTableView reloadData];
            [self scrollToBottomAnimated:YES];
        });
        if (gotType == IMListAll) {
            
        }else if(gotType == IMListPolling){
            
            
        }else if (gotType == IMListDelete) {
            
        }else{
            
        }
  
    };
    
    [msgCenter getMessages:currentMsgBlock success:^(id successObj) {
        if (successObj !=nil) {
//            PharSessionDetailList *model = successObj;
        }
    } failure:^(id failureObj) {
    }];
}

- (void)closeMessageCenter{
    if (msgCenter) {
        [msgCenter close];
        msgCenter = nil;
    }
}

- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    if(type == NotimessageIMTabelUpdate)//图片SDWebImageDownLoad成功通知
    {
        [self.myTableView reloadData];
    }
}

#pragma mark - 发送按钮触发事件，砖家问答（文字，表情，语音，图片）
//普通键盘点击发送回调
- (void)didSendTextAction:(NSString *)text{
    
    if([QWGLOBALMANAGER removeSpace:text].length == 0)
    {
        
        [self.messageInputView.inputTextView  resignFirstResponder];
        return;
    }
    MessageModel *textModel = [[MessageModel alloc] initWithText:text sender:self.recipientId timestamp:[NSDate date] UUID:[XMPPStream generateUUID]];
    
    [self sendMessage:textModel messageBodyType:MessageMediaTypeText];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeText];
}
//表情键盘点击发送回调
- (void)didSendEmojiTextAction:(id)sender{
    
    if([QWGLOBALMANAGER removeSpace:self.messageInputView.inputTextView.text].length == 0){
        
        [self.messageInputView.inputTextView  resignFirstResponder];
        return;
    }
    MessageModel *textModel = [[MessageModel alloc] initWithText:self.messageInputView.inputTextView.text sender:self.recipientId timestamp:[NSDate date] UUID:[XMPPStream generateUUID]];
    
    [self sendMessage:textModel messageBodyType:MessageMediaTypeText];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeText];
}
//语音文件录制发送回调
- (void)didSendVoiceFileAction:(MessageModel *)filePath{
    
    MessageModel *voiceModel = [[MessageModel alloc]initWithVoicePath:filePath.voicePath voiceUrl:filePath.videoUrl voiceDuration:filePath.voiceDuration sender:self.recipientId timestamp:filePath.timestamp UUID:filePath.UUID];
    
    [self sendMessage:voiceModel messageBodyType:MessageMediaTypeVoice];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeVoice];
}

//相册图片选择完成回调
-(void)didSendImageFileAction:(NSMutableArray *)imgArr{

    for(UIImage *img in imgArr){
        
        NSString *UUID = [XMPPStream generateUUID];
        [[SDImageCache sharedImageCache] storeImage:img forKey:UUID toDisk:YES];
        if (![[SDImageCache sharedImageCache] diskImageExistsWithKey:UUID]) {
            [[SDImageCache sharedImageCache] storeImage:img forKey:UUID toDisk:YES];
        }
        
        MessageModel *model = [[MessageModel alloc] initWithPhoto:img thumbnailUrl:nil originPhotoUrl:nil sender:self.recipientId timestamp:[NSDate date] UUID:UUID richBody:nil];
        [self sendMessage:model messageBodyType:MessageMediaTypePhoto];
    }
}

#pragma mark - Messages View Controller
- (void)finishSendMessageWithBubbleMessageType:(XHBubbleMessageMediaType)mediaType {
    switch (mediaType) {
        case XHBubbleMessageMediaTypeText: {
            [self.messageInputView.inputTextView setText:nil];
            //[self.messageInputView.inputTextView resignFirstResponder];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                self.messageInputView.inputTextView.enablesReturnKeyAutomatically = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.messageInputView.inputTextView.enablesReturnKeyAutomatically = YES;
                    [self.messageInputView.inputTextView reloadInputViews];
                    [self scrollToBottomAnimated:YES];
                });
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark
#pragma mark 消息发送中心
- (void)sendMessage:(MessageModel *)messageModel messageBodyType:(MessageBodyType)messageType
{
    if (QWGLOBALMANAGER.configure.silencedFlag) {
        [self.messageInputView.inputTextView resignFirstResponder];
        [SVProgressHUD showErrorWithStatus:@"您已被禁言"];
        return;
    }
    
    switch (messageType) {
        case MessageMediaTypeText:   //发送纯文本
        {
            [msgCenter sendMessage:messageModel success:^(id successObj) {
                [self messageToExpertMsg:messageModel send:MessageDeliveryState_Delivered];
                [self.myTableView reloadData];
                [self scrollToBottomAnimated:YES];
            }failure:^(id failureObj) {
                if([failureObj isKindOfClass:[NSString class]]){
                    [SVProgressHUD showErrorWithStatus:failureObj];
                }
                [self messageToExpertMsg:messageModel send:MessageDeliveryState_Failure];
                [self.myTableView reloadData];
                [self scrollToBottomAnimated:YES];
            }];
            break;
        }
        case MessageMediaTypePhoto:     //发送图片
        {
            [msgCenter sendFileMessage:messageModel success:^(id successObj) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[msgCenter getMessageIndex:messageModel] inSection:0];
                ChatOutgoingTableViewCell *cell = (ChatOutgoingTableViewCell *)[self.myTableView cellForRowAtIndexPath:indexPath];
                ((PhotoChatBubbleView *)cell.bubbleView).dpMeterView.activeShow.hidden = YES;
                ((PhotoChatBubbleView *)cell.bubbleView).dpMeterView.hidden = YES;
                ((PhotoChatBubbleView *)cell.bubbleView).dpMeterView.progressLabel.text = [NSString stringWithFormat:@"%d%@",0,@"%"];
                [self messageToExpertMsg:messageModel send:MessageDeliveryState_Delivered ];
                [self.myTableView reloadData];
            } failure:^(id failureObj) {
                if([failureObj isKindOfClass:[NSString class]]){
                    [SVProgressHUD showErrorWithStatus:failureObj];
                }
                [self messageToExpertMsg:messageModel send:MessageDeliveryState_Failure];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[msgCenter getMessageIndex:messageModel] inSection:0];
                ChatOutgoingTableViewCell *cell = (ChatOutgoingTableViewCell *)[self.myTableView cellForRowAtIndexPath:indexPath];
                
                ((PhotoChatBubbleView *)cell.bubbleView).dpMeterView.activeShow.hidden = YES;
                ((PhotoChatBubbleView *)cell.bubbleView).dpMeterView.hidden = YES;
                ((PhotoChatBubbleView *)cell.bubbleView).dpMeterView.progressLabel.text = [NSString stringWithFormat:@"%d%@",0,@"%"];
                [self.myTableView reloadData];
                [self messageToExpertMsg:messageModel  send:MessageDeliveryState_Failure];
            } uploadProgressBlock:^(MessageModel *target, float progress) {
                
                [self progressUpdate:messageModel.UUID progress:progress];
                
            }];
            break;
        }
        case MessageMediaTypeVoice:{
            //note by meng ，等待消息bubber调试完成后打开
            //发送语音文件
            [msgCenter sendFileMessage:messageModel success:^(id successObj) {
                [self messageToExpertMsg:messageModel  send:MessageDeliveryState_Delivered];
                [self.myTableView reloadData];
            } failure:^(id failureObj) {
                if([failureObj isKindOfClass:[NSString class]]){
                    [SVProgressHUD showErrorWithStatus:failureObj];
                }
                [self messageToExpertMsg:messageModel send:MessageDeliveryState_Failure];
                [self.myTableView reloadData];
                [self messageToExpertMsg:messageModel  send:MessageDeliveryState_Failure];
            } uploadProgressBlock:^(MessageModel *target, float progress) {
                
            }];
            break;
        }
        case MessageMediaTypeCoupon:
        case MessageMediaTypeMedicineCoupon:
        case MessageMediaTypeMedicine: {
            [msgCenter sendMessage:messageModel success:^(id successObj) {
                [self messageToExpertMsg:messageModel  send:MessageDeliveryState_Delivered];
                [self.myTableView reloadData];
            } failure:^(id failureObj) {
                [self.myTableView reloadData];
                [self messageToExpertMsg:messageModel  send:MessageDeliveryState_Failure];
            }];
            break;
        }
        case MessageMediaTypeStoreMedicine: {
            [msgCenter sendMessage:messageModel success:^(id successObj) {
                [self messageToExpertMsg:messageModel  send:MessageDeliveryState_Delivered];
                [self.myTableView reloadData];
            } failure:^(id failureObj) {
                [self.myTableView reloadData];
                [self messageToExpertMsg:messageModel  send:MessageDeliveryState_Failure];
            }];
            break;
        }
            default:
            break;
    }  
}

- (void)messageToExpertMsg:(MessageModel *)messageModel send:(NSInteger)sended
{
    IMChatPointVo *history = [IMChatPointVo getObjFromDBWithKey:self.recipientId];
    history.respondDate =[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    history.readFlag = @"1";
    
    switch ( messageModel.messageMediaType ) {
        case MessageMediaTypeText:
        {
            history.respond = messageModel.text;
            break;
        }
        case MessageMediaTypePhoto:
        {
            history.respond = @"[图片]";
            break;
        }
        case MessageMediaTypeVoice:
        {
            history.respond = @"[语音]";
            break;
        }
        case MessageMediaTypeCoupon:
        case MessageMediaTypeMedicineCoupon:
        case MessageMediaTypeMedicine: {
            
            history.respond = @"[药品]";
            break;
        }
        case MessageMediaTypeStoreMedicine: {
            
            history.respond = @"[药品]";
            break;
        }
        default:
            break;
    }
    
    [IMChatPointVo updateObjToDB:history WithKey:self.recipientId];
    [QWGLOBALMANAGER postNotif:NotiRefreshPrivateExpert data:nil object:nil];
}


#pragma mark - 百分比更新，用于图片发送
-(void)progressUpdate:(NSString *)uuid progress:(float)newProgress
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MessageModel *message = [msgCenter getMessageWithUUID:uuid];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[msgCenter getMessageIndex:message] inSection:0];
        
        ChatOutgoingTableViewCell *cell = (ChatOutgoingTableViewCell *)[self.myTableView cellForRowAtIndexPath:indexPath];
        if (cell) {
            ((PhotoChatBubbleView *)cell.bubbleView).dpMeterView.hidden = NO;
            [((PhotoChatBubbleView *)cell.bubbleView).dpMeterView setProgress:newProgress];
    
        }
    });
}

- (void)stopMusicInOtherBubblePressed
{
    if(playingMessageModel) {
        playingMessageModel.audioPlaying = NO;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[msgCenter getMessageIndex:playingMessageModel] inSection:0];
        ChatTableViewCell *cell = (ChatTableViewCell *)[self.myTableView cellForRowAtIndexPath:indexPath];
        [cell stopVoicePlay];
        XHAudioPlayerHelper *playerHelper = [XHAudioPlayerHelper shareInstance];
        [playerHelper stopAudioWithOutDelegate];
        playingMessageModel = nil;
    }
}


- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    if(![eventName isEqualToString:kRouterEventOfVoice]) {
        [self stopMusicInOtherBubblePressed];
    }
    
    if ([eventName isEqualToString:kRouterEventPhotoBubbleTapEventName])
    {
        //点击预览图片
        BubblePhotoImageView *bubble=[userInfo objectForKey:KMESSAGEKEY];
        MessageModel *mm=bubble.messageModel;
        NSString *uuid=StrFromObj(mm.UUID);
        imgArr = [msgCenter getImages];
        if (imgArr.count==0) {
            return;
        }
        int i = 0;
        for (id obj in imgArr) {
            if ([obj isKindOfClass:[NSString class]]) {
                NSString *uid=obj;
                if ([uid isEqualToString:uuid]) {
                    break;
                }
            }
            i++;
        }

        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PhotoAlbum" bundle:nil];
        PhotoPreView* vc = [sb instantiateViewControllerWithIdentifier:@"PhotoPreView"];
        
        vc.arrPhotos = imgArr;//uiimage或者url数组，用全局数组，否则会crash
        vc.indexSelected = (i==imgArr.count)?0:i;
        [self presentViewController:vc animated:YES completion:^{
            
        }];
    }else if ([eventName isEqualToString:kRouterEventOfVoice]) {
        MessageModel *model = [userInfo objectForKey:KMESSAGEKEY];
        
        XHAudioPlayerHelper *playerHelper = [XHAudioPlayerHelper shareInstance];
        [playerHelper setDelegate:self];
        if(playingMessageModel) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[msgCenter getMessageIndex:playingMessageModel] inSection:0];
            ChatTableViewCell *cell = (ChatTableViewCell *)[self.myTableView cellForRowAtIndexPath:indexPath];
            [cell stopVoicePlay];
            playingMessageModel.audioPlaying = NO;
            if(model == playingMessageModel) {
                [playerHelper stopAudioWithOutDelegate];
                playingMessageModel = nil;
                return;
            }
        }
        
        if(model.download == MessageFileState_Downloading) {
            return;
        }else if(model.download == MessageFileState_Failure || model.download == MessageFileState_Pending) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[msgCenter getMessageIndex:model] inSection:0];
            ChatTableViewCell *cell = (ChatTableViewCell *)[self.myTableView cellForRowAtIndexPath:indexPath];
            [cell redownloadAudio:nil];
        }else{
            
            XHAudioPlayerHelper *playerHelper = [XHAudioPlayerHelper shareInstance];
            [playerHelper setDelegate:self];
            [playerHelper stopAudioWithOutDelegate];
            playingMessageModel = model;
            playingMessageModel.audioPlaying = YES;
            if (model.voicePath.length == 0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[msgCenter getMessageIndex:model] inSection:0];
                ChatTableViewCell *cell = (ChatTableViewCell *)[self.myTableView cellForRowAtIndexPath:indexPath];
                [cell redownloadAudio:nil];
                return;
            }
            NSMutableArray *conpoment = [[model.voicePath componentsSeparatedByString:@"/"] mutableCopy];
            conpoment = [conpoment subarrayWithRange:NSMakeRange(conpoment.count - 4, 4)];
            NSString *amrPath = [NSHomeDirectory() stringByAppendingPathComponent:[conpoment componentsJoinedByString:@"/"]];
            
            if(model.messageDeliveryType == MessageTypeSending){
                amrPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat: @"Documents/%@/Voice/%@",QWGLOBALMANAGER.configure.expertMobile,[conpoment objectAtIndex:conpoment.count - 1]]];
            }
            
            NSData *amrData = [[NSData alloc] initWithContentsOfFile:amrPath];
            if(!amrData || amrData.length == 0) {
                return;
            }
            NSData *cafData = [self.voiceRecordHelper convertAmrToCaf:amrData];
            NSString *cafTempPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat: @"tmp/temp.caf"]];
            [cafData writeToFile:cafTempPath atomically:YES];
            [playerHelper managerAudioWithFileName:cafTempPath toPlay:YES];
        }
        
    }else if ([eventName isEqualToString:kResendButtonTapEventName])
    {
        //重发
        self.dicNeedResend = userInfo;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"重发该消息?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 999;
        [alertView show];
    }else if([eventName isEqualToString:kRouterEventDrugChat]){
        //220 药品详情
        [QWGLOBALMANAGER statisticsEventId:@"私聊详情_药品链接" withLable:@"圈子" withParams:nil];
        
        MessageModel *model=[userInfo objectForKey:KMESSAGEKEY];
        [self pushToDrugDetailWithDrugID:model.richBody promotionId:nil];
    }else if ([eventName isEqualToString:kHeadImageClickEventName]) {
        MessageModel *model=[userInfo objectForKey:KMESSAGEKEY];
//        NSString *where=[NSString stringWithFormat:@"UUID = '%@'",model.UUID];
//        ExpertMessageModel *expertModel =  [ExpertMessageModel getObjFromDBWithWhere:where];
        if(model.messageDeliveryType == MessageTypeSending){
            return;
        }
        //用户个人主页
        UserPageViewController *vc = [[UIStoryboard storyboardWithName:@"UserPage" bundle:nil] instantiateViewControllerWithIdentifier:@"UserPageViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.mbrId = msgCenter.senderId;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

#pragma mark XHAudioPlayerHelperDelegate
- (void)didAudioPlayerBeginPlay:(AVAudioPlayer*)audioPlayer
{
    
}

- (void)didAudioPlayerStopPlay:(AVAudioPlayer*)audioPlayer
{
    if(playingMessageModel) {
        playingMessageModel.audioPlaying = NO;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[msgCenter getMessageIndex:playingMessageModel] inSection:0];
        ChatTableViewCell *cell = (ChatTableViewCell *)[self.myTableView cellForRowAtIndexPath:indexPath];
        [cell stopVoicePlay];
        playingMessageModel = nil;
    }
}

- (void)didAudioPlayerPausePlay:(AVAudioPlayer*)audioPlayer
{
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 999) {
        if (buttonIndex == 0) {
            
        } else if (buttonIndex == 1) {
            // 重发
            if (self.dicNeedResend) {
                MessageModel *model=[self.dicNeedResend objectForKey:@"kShouldResendModel"];
                switch (model.messageMediaType) {
                    case MessageMediaTypeText:
                    {
                        [msgCenter resendMessage:model success:^(id successObj) {
                            [self messageToExpertMsg:model send:MessageDeliveryState_Delivered];
                            [self.myTableView reloadData];
                        } failure:^(id failureObj) {
                            if([failureObj isKindOfClass:[NSString class]]){
                                [SVProgressHUD showErrorWithStatus:failureObj];
                            }
                            [self messageToExpertMsg:model send:MessageDeliveryState_Failure];
                            [self.myTableView reloadData];
                        }];
                    }
                        break;
                    case MessageMediaTypePhoto:
                    {
                        [msgCenter resendFileMessage:model success:^(id successObj) {
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[msgCenter getMessageIndex:model] inSection:0];
                            ChatOutgoingTableViewCell *cell = (ChatOutgoingTableViewCell *)[self.myTableView cellForRowAtIndexPath:indexPath];
                            ((PhotoChatBubbleView *)cell.bubbleView).dpMeterView.activeShow.hidden = YES;
                            ((PhotoChatBubbleView *)cell.bubbleView).dpMeterView.hidden = YES;
                            ((PhotoChatBubbleView *)cell.bubbleView).dpMeterView.progressLabel.text = [NSString stringWithFormat:@"%d%@",0,@"%"];
                            [self messageToExpertMsg:model send:MessageDeliveryState_Delivered];
                            [self.myTableView reloadData];
                            
                        } failure:^(id failureObj) {
                            if([failureObj isKindOfClass:[NSString class]]){
                                [SVProgressHUD showErrorWithStatus:failureObj];
                            }
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[msgCenter getMessageIndex:model] inSection:0];
                            ChatOutgoingTableViewCell *cell = (ChatOutgoingTableViewCell *)[self.myTableView cellForRowAtIndexPath:indexPath];
                            
                            ((PhotoChatBubbleView *)cell.bubbleView).dpMeterView.activeShow.hidden = YES;
                            ((PhotoChatBubbleView *)cell.bubbleView).dpMeterView.hidden = YES;
                            ((PhotoChatBubbleView *)cell.bubbleView).dpMeterView.progressLabel.text = [NSString stringWithFormat:@"%d%@",0,@"%"];
                            [self.myTableView reloadData];
                            [self messageToExpertMsg:model  send:MessageDeliveryState_Failure];
                        } uploadProgressBlock:^(MessageModel *target, float progress) {
                            
                            [self progressUpdate:model.UUID progress:progress];
                            
                        }];
                        
                    }
                        break;
                    case MessageMediaTypeVoice:
                    {
                        [msgCenter resendFileMessage:model success:^(id successObj) {
                            [self messageToExpertMsg:model send:MessageDeliveryState_Delivered];
                            [self.myTableView reloadData];
                        } failure:^(id failureObj) {
                            if([failureObj isKindOfClass:[NSString class]]){
                                [SVProgressHUD showErrorWithStatus:failureObj];
                            }
                            [self messageToExpertMsg:model send:MessageDeliveryState_Failure];
                            [self.myTableView reloadData];
                        } uploadProgressBlock:NULL];
                    }
                        break;
                    default:
                    {
                        [msgCenter resendMessage:model success:^(id successObj) {
                            [self messageToExpertMsg:model send:MessageDeliveryState_Delivered];
                            [self.myTableView reloadData];
                        } failure:^(id failureObj) {
                            [self messageToExpertMsg:model send:MessageDeliveryState_Failure];
                            [self.myTableView reloadData];
                        }];
                    }
                        break;
                }
            }
        }
    }
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *obj = nil;
    //    [self.dataSource objectAtIndex:indexPath.row];
    obj = [msgCenter getMessageByIndex:indexPath.row];
    //TODO: need update
    BOOL displayTimestamp = YES;
    displayTimestamp = [self shouldDisplayTimestampForRowAtIndexPath:indexPath];
    CGFloat CellHeight = [ChatTableViewCell tableView:tableView heightForRowAtIndexPath:indexPath withObject:(MessageModel *)obj hasTimeStamp:displayTimestamp];
    return CellHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger msgCount = msgCenter.count;
    return msgCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel *model;
    model = [msgCenter getMessageByIndex:indexPath.row];

    if(model.messageDeliveryType == MessageTypeSending) {
        ChatOutgoingTableViewCell   *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatOutgoingTableViewCell"];
        cell.delegate = msgCenter;
        cell.chatCellStyle = ChatCellStylePrivateChat;
        //是否显示时间戳
        BOOL displayTimestamp = YES;
        displayTimestamp = [self shouldDisplayTimestampForRowAtIndexPath:indexPath];
        cell.displayTimestamp = displayTimestamp;
        
        [cell setupSubviewsForMessageModel:model];
        cell.messageModel = model;
        [cell updateBubbleViewConsTraint:model];
        
        [cell.headImageView setImageWithURL:[NSURL URLWithString:QWGLOBALMANAGER.configure.expertAvatarUrl] placeholderImage:[UIImage imageNamed:@"expert_ic_people"]];
        
        
        if(displayTimestamp){
            [cell configureTimeStampLabel:model];
        }
        
        [cell setupTheBubbleImageView:model];
        cell.headImageView.layer.cornerRadius = 20.0f;
        
        return cell;
        
    }else{
        ChatIncomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatIncomeTableViewCell"];
        cell.delegate = msgCenter;
        cell.chatCellStyle = ChatCellStylePrivateChat;
        //是否显示时间戳
        BOOL displayTimestamp = YES;
        displayTimestamp = [self shouldDisplayTimestampForRowAtIndexPath:indexPath];
        cell.displayTimestamp = displayTimestamp;
        
        [cell setupSubviewsForMessageModel:model];
        cell.messageModel = model;
        [cell updateBubbleViewConsTraint:model];
        
        [cell.headImageView setImageWithURL:[NSURL URLWithString:model.avatorUrl] placeholderImage:[UIImage imageNamed:@"expert_ic_people"]];
        
        
        if(displayTimestamp){
            [cell configureTimeStampLabel:model];
        }
        
        [cell setupTheBubbleImageView:model];
        cell.headImageView.layer.cornerRadius = 20.0f;
        
        return cell;
    }
}

#pragma mark - XHShareMenuViewDelegate回调
- (void)didSelectedShareMenuViewAtIndex:(NSInteger)index{
    
    switch (index) {
        case 0: {
            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
            if(author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) {
                [SVProgressHUD showErrorWithStatus:@"当前程序未开启相册使用权限" duration:0.8];
                return;
            }
            
            [self LocalPhoto];
            break;
        }
        case 1: {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
                [SVProgressHUD showErrorWithStatus:@"当前程序未开启相机使用权限" duration:0.8];
                return;
            }
            
            [self takePhoto];
            break;
        }
        case 2: {
            if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
                [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试" duration:0.8f];
                return;
            }
            //常用话术
            
            if(self.CommonWords.count == 0) {
                [IMApi qReplyIMWithParams:[NSMutableDictionary dictionary] success:^(id array) {
                    [self.CommonWords removeAllObjects];
                    if(!self.CommonWords) self.CommonWords = [NSMutableArray array];
                    for(IMApiModel *iMApiModel in array) {
                        [self.CommonWords addObject:iMApiModel.content];
                    }
                    [self showRegularTalk];
                } failure:NULL];
            }else{
                [self showRegularTalk];
            }
            break;
        }
        case 3: {
            
            if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
                [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试" duration:DURATION_SHORT];
                return;
            }
            
            [QWGLOBALMANAGER statisticsEventId:@"私聊详情_医药助手" withLable:@"圈子" withParams:nil];
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"药事知识库",@"健康问答库",@"快捷发送(药品)", nil];
            sheet.tag = 1002;
            [sheet showInView:self.view];
            break;
        }
            default:
            break;
    }
}

- (void)leveyPopListView:(LeveyPopListView *)popListView didSelectedIndex:(NSInteger)anIndex{
    if(popListView.tag == 1001) {

    }else if (popListView.tag == 1002) {
        NSString *content = self.CommonWords[anIndex];
        

        self.messageInputView.inputTextView.text = content;
        [self.messageInputView.inputTextView becomeFirstResponder];
    }
    
}
            
- (void)showRegularTalk
{
    LeveyPopListView *popListView = [[LeveyPopListView alloc] initWithTitle:@"" options:self.CommonWords];
    popListView.delegate = self;
    popListView.tag = 1002;
    [popListView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.6]];
    [popListView showInView:self.view animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(actionSheet.tag == 1002){
        if(buttonIndex == 0) {
            //药事知识库

            [QWGLOBALMANAGER statisticsEventId:@"私聊详情_医药助手_药事知识库" withLable:@"圈子" withParams:nil];
            SearchSliderViewController *sliderViewController = [[SearchSliderViewController alloc] init];
            //sliderViewController.keyBoardShow = YES;
            [self.navigationController pushViewController:sliderViewController animated:NO];
            
        }else if(buttonIndex == 1){
            //健康问答库
            
            [QWGLOBALMANAGER statisticsEventId:@"私聊详情_医药助手_健康问答库" withLable:@"圈子" withParams:nil];
            UIStoryboard *sbHealthQA = [UIStoryboard storyboardWithName:@"HealthQALibrary" bundle:nil];
            HealthQASearchViewController *sliderViewController = [sbHealthQA instantiateViewControllerWithIdentifier:@"HealthQASearchViewController"];
            sliderViewController.delegatePopVC = self;
            [self.navigationController pushViewController:sliderViewController animated:NO];
        }else if (buttonIndex == 2) {
            //药品快捷发送
            [QWGLOBALMANAGER statisticsEventId:@"私聊详情_医药助手_快捷发送（药品）" withLable:@"圈子" withParams:nil];
            QuickSearchDrugViewController *quickSearchDrugViewController = [QuickSearchDrugViewController new];
            quickSearchDrugViewController.returnValueBlock = ^(ExpertSearchMedicineListModel *model){
            
                MessageModel *medicineModel = [[MessageModel alloc] initWithStoreMedicine:model.proName
                                                                                productId:model.proId
                                                                                 imageUrl:model.imgUrl
                                                                                     spec:model.spec
                                                                                 branchId:@""
                                                                              branchProId:@""
                                                                                   sender:self.recipientId
                                                                                timestamp:[NSDate date]
                                                                                     UUID:[XMPPStream generateUUID]];
                [self sendMessage:medicineModel messageBodyType:MessageMediaTypeStoreMedicine];
            };
            [self.navigationController pushViewController:quickSearchDrugViewController animated:NO];
        }
        
    }
}



- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageModel *message1 = [msgCenter getMessageByIndex:indexPath.row];
    if(indexPath.row == 0) {
        return YES;
    }else{
        MessageModel *message0 = [msgCenter getMessageByIndex:indexPath.row - 1];
        NSTimeInterval offset = [message1.timestamp timeIntervalSinceDate:message0.timestamp];
        if(offset >= 300.0)
            return YES;
    }
    return NO;
}

@end
