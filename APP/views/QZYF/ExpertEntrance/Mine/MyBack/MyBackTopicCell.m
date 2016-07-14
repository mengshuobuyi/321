//
//  MyBackTopicCell.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/5.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "MyBackTopicCell.h"
#import "CircleModel.h"
#import "NSString+WPAttributedMarkup.h"
#import "UIImageView+WebCache.h"

@implementation MyBackTopicCell

+ (CGFloat)getCellHeight:(id)data
{
    CircleReplayListModel *model = (CircleReplayListModel *)data;
    
    NSString *title = [NSString stringWithFormat:@"原帖：%@",model.postTitle];
    NSString *content = [NSString stringWithFormat:@"回帖：%@",model.content];;
    
    //改变title视图
    CGSize titleSize = [QWGLOBALMANAGER sizeText:title font:fontSystem(14) limitWidth:APP_W-54];
    //改变content视图
    CGSize contentSize = [QWGLOBALMANAGER sizeText:content font:fontSystem(15) limitWidth:APP_W-34];
    
    if (titleSize.height > 35) {
        titleSize.height = 35;
    }
    
    float singleLabelHeight = 15.5;
    int line = contentSize.height/singleLabelHeight;
    
    return 100 - 32 + titleSize.height + contentSize.height + (line-1)*4 +5;
}

- (void)UIGlobal
{
    [super UIGlobal];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.separatorLine.hidden = YES;

    self.topicTitle.numberOfLines = 2;
    self.content.numberOfLines = 0;
    
}


- (void)setCellData:(id)data type:(int)type
{
    [super setCell:data];
    
    CircleReplayListModel *model = (CircleReplayListModel *)data;
    
    // type 1我的回帖  2专家的回帖  3普通用户的回帖 （暂时不用）
    
    //帖子标题
    self.topicTitle.text = [NSString stringWithFormat:@"原帖：%@",model.postTitle];
    CGSize titleSize = [QWGLOBALMANAGER sizeText:self.topicTitle.text font:fontSystem(14) limitWidth:APP_W-50];
    if (titleSize.height > 35) {
        titleSize.height = 35;
    }
    self.topicBg_layout_height.constant = titleSize.height + 29;
    
    //评论内容
    self.content.text = [NSString stringWithFormat:@"回帖：%@",model.content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSDictionary *attributes = @{NSFontAttributeName:fontSystem(15),NSParagraphStyleAttributeName:paragraphStyle};
    self.content.attributedText = [[NSAttributedString alloc] initWithString:self.content.text attributes:attributes];
    
    //时间
    self.time.text = model.createDate;
}

@end
