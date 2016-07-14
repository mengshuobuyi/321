//
//  BaseChatTableViewCell.m
//  APP
//
//  Created by carret on 15/5/21.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseChatTableViewCell.h"
//#import "MessageModelProtocol.h"
NSString *const kRouterEventChatHeadImageTapEventName = @"kRouterEventChatHeadImageTapEventName";

@implementation BaseChatTableViewCell

-(void)awakeFromNib
{
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    _headerLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(headerLongPress:)];
    [self addGestureRecognizer:_headerLongPress];
}

- (id)initWithMessageModel:(MessageModel *)model reuseIdentifier:(NSString *)reuseIdentifier
{
    NSArray* nibViews = nil;
    if (model.messageDeliveryType == MessageTypeSending) {
        nibViews = [[NSBundle mainBundle] loadNibNamed:@"ChatOutgoingTableViewCell" owner:self options:nil];
    }else
    {
        nibViews = [[NSBundle mainBundle] loadNibNamed:@"ChatIncomeTableViewCell" owner:self options:nil];
    }
    self = [nibViews objectAtIndex: 0];
    
    if (self) {
         //Initialization code
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImagePressed:)];
        CGFloat originX = HEAD_PADDING;
        if (model.messageDeliveryType) {
            originX = self.bounds.size.width - HEAD_SIZE - HEAD_PADDING;
        }
//        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, CELLPADDING, HEAD_SIZE, HEAD_SIZE)];
//        [_headImageView addGestureRecognizer:tap];
//        _headImageView.userInteractionEnabled = YES;
//        _headImageView.multipleTouchEnabled = YES;
//        _headImageView.backgroundColor = [UIColor clearColor];
        //[self.contentView addSubview:_headImageView];
        [self setupSubviewsForMessageModel:model];
    }
    return self;
}

- (void)setupSubviewsForMessageModel:(MessageModel *)model
{
//    if (model.messageDeliveryType) {
//        self.headImageView.frame = CGRectMake(self.bounds.size.width - HEAD_SIZE - HEAD_PADDING, CELLPADDING, HEAD_SIZE, HEAD_SIZE);
//    }
//    else{
//        self.headImageView.frame = CGRectMake(0, CELLPADDING, HEAD_SIZE, HEAD_SIZE);
//    }
}

//
//+ (NSString *)cellIdentifierForMessageModel:(MessageModel *)model
//{
//    NSString *identifier = @"MessageCell";
//    if (model.messageDeliveryType == MessageTypeSending) {
//        identifier = [identifier stringByAppendingString:@"Sender"];
//    }
//    else{
//        identifier = [identifier stringByAppendingString:@"Receiver"];
//    }
//    
//    switch (model.messageMediaType) {
//        case MessageMediaTypeText:
//        {
//            identifier = [identifier stringByAppendingString:@"Text"];
//        }
//        break;
//        case MessageMediaTypePhoto:
//        {
//            identifier = [identifier stringByAppendingString:@"Image"];
//        }
//            break;
//        case MessageMediaTypeVoice:
//        {
//            identifier = [identifier stringByAppendingString:@"Audio"];
//        }
//            break;
//        case MessageMediaTypeLocation:
//        {
//            identifier = [identifier stringByAppendingString:@"Location"];
//            break;
//        }
//        case MessageMediaTypeSpreadHint:
//        {
//            identifier = [identifier stringByAppendingString:@"SpreadHint"];
//            break;
//        }
//        case MessageMediaTypeMedicine:
//        {
//            identifier = [identifier stringByAppendingString:@"Medicine"];
//            break;
//        }
//        case MessageMediaTypeMedicineSpecialOffers:
//        {
//            identifier = [identifier stringByAppendingString:@"SpecialOffers"];
//            break;
//        }
//        case MessageMediaTypeMedicineShowOnce:
//        {
//            identifier = [identifier stringByAppendingString:@"MedicineShowOnce"];
//            break;
//        }
//        case MessageMediaTypeMedicineSpecialOffersShowOnce:
//        {
//            identifier = [identifier stringByAppendingString:@"SpecialOffersShowOnce"];
//            break;
//        }
//        case MessageMediaTypeHeader:
//        {
//            identifier = [identifier stringByAppendingString:@"Header"];
//            break;
//        }
//        case MessageMediaTypeLine:
//        {
//            identifier = [identifier stringByAppendingString:@"Line"];
//            break;
//        }
//        case MessageMediaTypeFooter:
//        {
//            identifier = [identifier stringByAppendingString:@"Footer"];
//            break;
//        }
//        case MessageMediaTypePhone:
//        {
//            identifier = [identifier stringByAppendingString:@"Phone"];
//            break;
//        }
//        default:
//            break;
//    }
//    
//    return identifier;
//}

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withObject:(MessageModel *)model
{
    return 0;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)headerLongPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if(_baseChatTableViewCellDelegate && _indexPath && [_baseChatTableViewCellDelegate respondsToSelector:@selector(cellImageViewLongPressAtIndexPath:)])
        {
            [_baseChatTableViewCellDelegate cellImageViewLongPressAtIndexPath:self.indexPath];
        }
    }
}
#pragma mark - private

-(void)headImagePressed:(id)sender
{
    [super routerEventWithName:kRouterEventChatHeadImageTapEventName userInfo:@{KMESSAGEKEY:self.messageModel}];
}

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    [super routerEventWithName:eventName userInfo:userInfo];
}


@end
