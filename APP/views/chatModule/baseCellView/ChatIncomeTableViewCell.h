//
//  ChatOutgoingTableViewCell.h
//  APP
//
//  Created by PerryChen on 5/28/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import "BaseChatTableViewCell.h"
#import "ChatTableViewCell.h"

@interface ChatIncomeTableViewCell: ChatTableViewCell
- (id)initWithMessageModel:(MessageModel *)model reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setupSubviewsForMessageModel:(MessageModel *)model;

- (void)setupIncomeBubbleStyleWithBubbleSize:(CGSize)bubbleSize;

@end
