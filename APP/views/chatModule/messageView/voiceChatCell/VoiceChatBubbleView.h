//
//  VoiceChatBubbleView.h
//  APP
//
//  Created by 李坚 on 15/7/22.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseChatBubbleView.h"
#import "ChatTableViewCell.h"
NSString *const kRouterEventOfVoice;
#define VoiceMaxWidth APP_W - 100
#define VoiceMinWidth 70.0f

@protocol VoiceChatBubbleViewDelegate <NSObject>

//开始播放动画回调方法
- (void)playVoice;

@end

@interface VoiceChatBubbleView : BaseChatBubbleView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LeftSpace;
@property (strong, nonatomic) ChatTableViewCell *cellChat;

//YES为正在播放状态，NO为停止状态
@property (assign, nonatomic) BOOL playEnable;

@property (weak, nonatomic) IBOutlet UIImageView *VoiceImageView;

@property (assign, nonatomic) id<VoiceChatBubbleViewDelegate>delegate;

@property (assign, nonatomic) id delegateMsgCenter;
//停止播放动画方法
- (void)stopVoice;
//音频文件下载方法
- (void)downLoadVoiceFile;
@end
