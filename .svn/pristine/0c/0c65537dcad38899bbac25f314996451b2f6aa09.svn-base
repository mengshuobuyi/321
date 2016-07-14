//
//  BubblePhotoImageView.h
//  APP
//
//  Created by YYX on 15/5/25.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHMessageBubbleFactory.h"
#import "chatManagerDefs.h"
#import "MessageModel.h"

@interface BubblePhotoImageView : UIView

/**
 *  发送后，需要显示的图片消息的图片，或者是视频的封面
 */
@property (nonatomic, strong) UIImage *messagePhoto;

/**
 *  发送后，需要显示的图片消息的图片，或者是视频的封面
 */
@property (nonatomic, strong) UIImageView *photoImageView;

@property (nonatomic, strong) MessageModel *messageModel;


@property (nonatomic ,assign)BOOL updateFrame;
/**
 *  加载网络图片的时候，需要用到转圈的控件
 */
@property (nonatomic, strong)__block UIActivityIndicatorView *activityIndicatorView;

/**
 *  消息类型
 */
@property (nonatomic, assign) MessageDeliveryType bubbleMessageType;



/**
 *  获取消息类型比如发送或接收
 *
 *  @return 消息类型
 */
- (MessageDeliveryType)getBubbleMessageType;
-(void)updatePhoto;
@end
