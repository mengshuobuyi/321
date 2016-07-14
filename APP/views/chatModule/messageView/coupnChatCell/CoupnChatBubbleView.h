//
//  CoupnChatBubbleView.h
//  APP
//
//  Created by caojing on 15/6/25.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseChatBubbleView.h"
extern NSString *const kRouterEventCoupnChat;
@interface CoupnChatBubbleView : BaseChatBubbleView
@property (weak, nonatomic) IBOutlet UILabel *coupnTitle;
@property (weak, nonatomic) IBOutlet UIImageView *coupnImage;
@property (weak, nonatomic) IBOutlet UILabel *coupnContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightCon;

@end
