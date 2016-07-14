//
//  BaseChatTableViewCell.h
//  APP
//
//  Created by carret on 15/5/21.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QWBaseTableCell.h"
#import "MessageModel.h"
#import "BaseChatBubbleView.h"

#import "UIResponder+Router.h"

#define HEAD_SIZE 38 // 头像大小
#define HEAD_PADDING 5 // 头像到cell的内间距和头像到bubble的间距
#define CELLPADDING 0 // Cell之间间距

#define TIMEVIEW_TOP_PADDING 21 // 时间控件的高度
#define TIMEVIEW_PADDING 9  // 时间控件离底部的间距

#define NAME_LABEL_WIDTH 180 // nameLabel宽度
#define NAME_LABEL_HEIGHT 20 // nameLabel 高度
#define NAME_LABEL_PADDING 0 // nameLabel间距
#define NAME_LABEL_FONT_SIZE 14 // 字体


@protocol BaseChatTableViewCellDelegate;

@interface BaseChatTableViewCell : QWBaseTableCell
{
    UILongPressGestureRecognizer *_headerLongPress;
 
//    UIImageView *_headImageView;
    UILabel *_nameLabel;
    BaseChatBubbleView *_bubbleView;
    
    CGFloat _nameLabelHeight;
    MessageModel *_messageModel;
}

@property (nonatomic, strong) MessageModel *messageModel;



@property (nonatomic, strong) IBOutlet BaseChatBubbleView *bubbleView;   //内容区域

@property (weak, nonatomic) id<BaseChatTableViewCellDelegate> baseChatTableViewCellDelegate;

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (strong, nonatomic) UIView *bottomLineView;

- (id)initWithMessageModel:(MessageModel *)model reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setupSubviewsForMessageModel:(MessageModel *)model;

+ (NSString *)cellIdentifierForMessageModel:(MessageModel *)model;

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withObject:(MessageModel *)model hasTimeStamp:(BOOL)hasTimeStamp;

@end

@protocol BaseChatTableViewCellDelegate <NSObject>

- (void)cellImageViewLongPressAtIndexPath:(NSIndexPath *)indexPath;


@end